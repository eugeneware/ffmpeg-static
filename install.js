'use strict'

import {statSync, createWriteStream, chmodSync} from 'node:fs'
import {arch as osArch, platform as osPlatform} from 'node:os'
import HttpsProxyAgent from 'https-proxy-agent'
import {encode as encodeQuery} from 'node:querystring'
import {strictEqual} from 'node:assert'
import envPaths from 'env-paths'
import httpBasic from '@derhuerst/http-basic'
const {FileCache} = httpBasic
import {extname} from 'node:path'
import ProgressBar from 'progress'
import request from '@derhuerst/http-basic'
import {createGunzip} from 'node:zlib'
import {pipeline} from 'node:stream'
import ffmpegPath from './index.js'

import { createRequire } from 'node:module'
const require = createRequire(import.meta.url)
const pkg = require('./package.json')

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
  if (statSync(ffmpegPath).isFile()) {
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

const isGzUrl = (url) => {
  const path = new URL(url).pathname.split('/')
  const filename = path[path.length - 1]
  return filename && extname(filename) === '.gz'
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

    const file = createWriteStream(destinationPath);
    const streams = isGzUrl(url)
      ? [response.body, createGunzip(), file]
      : [response.body, file]
    pipeline(
      ...streams,
      (err) => {
        if (err) {
          err.url = response.url
          err.statusCode = response.statusCode
          reject(err)
        } else fulfill()
      }
    )

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
    progressBar = new ProgressBar(`Downloading ffmpeg ${releaseName} [:bar] :percent :etas `, {
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
  pkg['ffmpeg-static']['binary-release-tag']
)
const releaseName = (
  pkg['ffmpeg-static']['binary-release-name'] ||
  release
)
const arch = process.env.npm_config_arch || osArch()
const platform = process.env.npm_config_platform || osPlatform()

const baseUrl = `https://github.com/eugeneware/ffmpeg-static/releases/download/${release}`
const downloadUrl = `${baseUrl}/${platform}-${arch}.gz`
const readmeUrl = `${baseUrl}/${platform}-${arch}.README`
const licenseUrl = `${baseUrl}/${platform}-${arch}.LICENSE`

downloadFile(downloadUrl, ffmpegPath, onProgress)
.then(() => {
  chmodSync(ffmpegPath, 0o755) // make executable
})
.catch(exitOnError)

.then(() => downloadFile(readmeUrl, `${ffmpegPath}.README`))
.catch(exitOnErrorOrWarnWith('Failed to download the ffmpeg README.'))

.then(() => downloadFile(licenseUrl, `${ffmpegPath}.LICENSE`))
.catch(exitOnErrorOrWarnWith('Failed to download the ffmpeg LICENSE.'))
