'use strict'

var fs = require("fs");
var os = require("os");
const {encode: encodeQuery} = require('querystring')
const {strictEqual} = require('assert')
const envPaths = require('env-paths')
const FileCache = require('http-basic/lib/FileCache').default
var ProgressBar = require("progress");
var request = require('http-basic')
var ffmpegPath = require(".");
var pkg = require("./package");

const exitOnError = (err) => {
  console.error(err)
  process.exit(1)
}
const exitOnErrorOrWarnWith = (msg) => (err) => {
  if (err.statusCode === 404) console.warn(msg)
  else exitOnError(err)
}

if (!ffmpegPath) {
  exitOnError('ffmpeg-static install failed: No binary found for architecture')
}

try {
  if (fs.statSync(ffmpegPath).isFile()) {
    console.info('ffmpeg is installed already.')
    process.exit(0)
  }
} catch (err) {
  if (err && err.code !== 'ENOENT') exitOnError(err)
}

let agent = false
// https://github.com/request/request/blob/a9557c9e7de2c57d92d9bab68a416a87d255cd3d/lib/getProxyFromURI.js#L66-L71
const proxyUrl = (
  process.env.HTTPS_PROXY ||
  process.env.https_proxy ||
  process.env.HTTP_PROXY ||
  process.env.http_proxy
)
if (proxyUrl) {
  const HttpsProxyAgent = require('https-proxy-agent')
  const {hostname, port, protocol} = new URL(proxyUrl)
  agent = new HttpsProxyAgent({hostname, port, protocol})
}

// https://advancedweb.hu/how-s3-signed-urls-work/
const normalizeS3Url = (url) => {
  url = new URL(url)
  if (url.hostname.slice(-17) !== '.s3.amazonaws.com') return url.href
  const query = Array.from(url.searchParams.entries())
  .filter(([key]) => key.slice(0, 6).toLowerCase() !== 'x-amz-')
  .reduce((query, [key, val]) => ({...query, [key]: val}), {})
  url.search = encodeQuery(query)
  return url.href
}
strictEqual(
  normalizeS3Url('https://example.org/foo?bar'),
  'https://example.org/foo?bar'
)
strictEqual(
  normalizeS3Url('https://github-production-release-asset-2e65be.s3.amazonaws.com/29458513/26341680-4231-11ea-8e36-ae454621d74a?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAIWNJYAX4CSVEH53A%2F20200405%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20200405T225358Z&X-Amz-Expires=300&X-Amz-Signature=d6415097af04cf62ea9b69d3c1a421278e96bcb069afa48cf021ec3b6941bae4&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Ddarwin-x64&response-content-type=application%2Foctet-stream'),
  'https://github-production-release-asset-2e65be.s3.amazonaws.com/29458513/26341680-4231-11ea-8e36-ae454621d74a?actor_id=0&response-content-disposition=attachment%3B%20filename%3Ddarwin-x64&response-content-type=application%2Foctet-stream'
)

const cache = new FileCache(envPaths(pkg.name).cache)
cache.getCacheKey = (url) => {
  return FileCache.prototype.getCacheKey(normalizeS3Url(url))
}

const noop = () => {}
function downloadFile(url, destinationPath, progressCallback = noop) {
  let fulfill, reject;
  let totalBytes = 0;

  const promise = new Promise((x, y) => {
    fulfill = x;
    reject = y;
  });

  request('GET', url, {
    agent,
    followRedirects: true,
    maxRedirects: 3,
    gzip: true,
    cache,
    timeout: 30 * 1000, // 30s
    retry: true,
  }, (err, response) => {
    if (err || response.statusCode !== 200) {
      err = err || new Error('Download failed.')
      if (response) {
        err.url = response.url
        err.statusCode = response.statusCode
      }
      reject(err)
      return;
    }

    const file = fs.createWriteStream(destinationPath);
    file.on("finish", () => fulfill());
    file.on("error", error => reject(error));
    response.body.pipe(file)

    if (!response.fromCache && progressCallback) {
      const cLength = response.headers["content-length"]
      totalBytes = cLength ? parseInt(cLength, 10) : null
      response.body.on('data', (chunk) => {
        progressCallback(chunk.length, totalBytes);
      });
    }
  });

  return promise;
}

let progressBar = null;
function onProgress(deltaBytes, totalBytes) {
  if (totalBytes === null) return;
  if (!progressBar) {
    progressBar = new ProgressBar(`Downloading ffmpeg [:bar] :percent :etas `, {
      complete: "|",
      incomplete: " ",
      width: 20,
      total: totalBytes
    });
  }

  progressBar.tick(deltaBytes);
}

const release = (
  process.env.FFMPEG_BINARY_RELEASE ||
  pkg['ffmpeg-static'].binary_release
)
const arch = process.env.npm_config_arch || os.arch()
const platform = process.env.npm_config_platform || os.platform()
const downloadUrl = `https://github.com/eugeneware/ffmpeg-static/releases/download/${release}/${platform}-${arch}`
const readmeUrl = `${downloadUrl}.README`
const licenseUrl = `${downloadUrl}.LICENSE`

downloadFile(downloadUrl, ffmpegPath, onProgress)
.then(() => {
  fs.chmodSync(ffmpegPath, 0o755) // make executable
})
.catch(exitOnError)

.then(() => downloadFile(readmeUrl, `${ffmpegPath}.README`))
.catch(exitOnErrorOrWarnWith('Failed to download the ffmpeg README.'))

.then(() => downloadFile(licenseUrl, `${ffmpegPath}.LICENSE`))
.catch(exitOnErrorOrWarnWith('Failed to download the ffmpeg LICENSE.'))
