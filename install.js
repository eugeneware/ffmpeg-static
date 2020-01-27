var fs = require("fs");
var os = require("os");
var ProgressBar = require("progress");
var get = require("simple-get");
var ffmpegPath = require(".");
var pkg = require("./package");

function downloadFile(url, destinationPath, progressCallback) {
  let fulfill, reject;
  let downloadedBytes = 0;
  let totalBytes = 0;

  const promise = new Promise((x, y) => {
    fulfill = x;
    reject = y;
  });

  get(url, function(err, response) {
    if (err || response.statusCode !== 200) {
      const error = new Error(`Download failed. URL: ${url}`);
      reject(err || error);
      return;
    }

    const file = fs.createWriteStream(destinationPath);
    file.on("finish", () => fulfill());
    file.on("error", error => reject(error));
    response.pipe(file);

    totalBytes = parseInt(response.headers["content-length"], 10);

    if (progressCallback) {
      response.on("data", function(chunk) {
        downloadedBytes += chunk.length;
        progressCallback(downloadedBytes, totalBytes);
      });
    }
  });

  return promise;
}

let progressBar = null;
let lastDownloadedBytes = 0;
function onProgress(downloadedBytes, totalBytes) {
  if (!progressBar) {
    progressBar = new ProgressBar(`Downloading ffmpeg [:bar] :percent :etas `, {
      complete: "|",
      incomplete: " ",
      width: 20,
      total: totalBytes
    });
  }

  const delta = downloadedBytes - lastDownloadedBytes;
  lastDownloadedBytes = downloadedBytes;
  progressBar.tick(delta);
}

function getDownloadUrl() {
  var platform = os.platform();
  var arch = os.arch();
  var release =
    process.env.FFMPEG_BINARY_RELEASE || pkg["ffmpeg-static"]["binary_release"];
  var url = `https://github.com/qawolf/ffmpeg-static/releases/download/${release}/${platform}-${arch}`;
  return url;
}

if (ffmpegPath) {
  downloadFile(getDownloadUrl(), ffmpegPath, onProgress).then(() => {
    // make executable
    fs.chmodSync(ffmpegPath, 0o755);
  });
} else {
  console.error(
    "ffmpeg-static install failed: No binary found for architecture"
  );
}
