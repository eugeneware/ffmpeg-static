'use strict'

var fs = require("fs");
var os = require("os");
var ProgressBar = require("progress");
var get = require("simple-get");
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

const noop = () => {}
function downloadFile(url, destinationPath, progressCallback = noop) {
  let fulfill, reject;
  let totalBytes = 0;

  const promise = new Promise((x, y) => {
    fulfill = x;
    reject = y;
  });

  get(url, function(err, response) {
    if (err || response.statusCode !== 200) {
      err = err || new Error('Download failed.')
      if (response) {
        err.url = url
        err.statusCode = response.statusCode
      }
      reject(err)
      return;
    }

    const file = fs.createWriteStream(destinationPath);
    file.on("finish", () => fulfill());
    file.on("error", error => reject(error));
    response.pipe(file);

    totalBytes = parseInt(response.headers["content-length"], 10);

    if (progressCallback) {
      response.on("data", function(chunk) {
        progressCallback(chunk.length, totalBytes);
      });
    }
  });

  return promise;
}

let progressBar = null;
function onProgress(deltaBytes, totalBytes) {
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
const downloadUrl = `https://github.com/eugeneware/ffmpeg-static/releases/download/${release}/${os.platform()}-${os.arch()}`
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
