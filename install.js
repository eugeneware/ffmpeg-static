var fs = require("fs");
var os = require("os");
var URL = require("url");

var ffmpegPath = require(".");

function httpRequest(url, method, response) {
  /** @type {Object} */
  let options = URL.parse(url);
  options.method = method;

  const requestCallback = res => {
    if (res.statusCode >= 300 && res.statusCode < 400 && res.headers.location)
      httpRequest(res.headers.location, method, response);
    else response(res);
  };
  const request =
    options.protocol === "https:"
      ? require("https").request(options, requestCallback)
      : require("http").request(options, requestCallback);
  request.end();
  return request;
}

function downloadFile(url, destinationPath, progressCallback) {
  let fulfill, reject;
  let downloadedBytes = 0;
  let totalBytes = 0;

  const promise = new Promise((x, y) => {
    fulfill = x;
    reject = y;
  });

  const request = httpRequest(url, "GET", response => {
    if (response.statusCode !== 200) {
      const error = new Error(
        `Download failed: server returned code ${response.statusCode}. URL: ${url}`
      );
      // consume response data to free up memory
      response.resume();
      reject(error);
      return;
    }
    const file = fs.createWriteStream(destinationPath);
    file.on("finish", () => fulfill());
    file.on("error", error => reject(error));
    response.pipe(file);
    totalBytes = parseInt(
      /** @type {string} */ (response.headers["content-length"]),
      10
    );
    if (progressCallback) response.on("data", onData);
  });
  request.on("error", error => reject(error));
  return promise;

  function onData(chunk) {
    downloadedBytes += chunk.length;
    progressCallback(downloadedBytes, totalBytes);
  }
}

let progressBar = null;
let lastDownloadedBytes = 0;
function onProgress(downloadedBytes, totalBytes) {
  if (!progressBar) {
    const ProgressBar = require("progress");
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

var platform = os.platform();
var arch = os.arch();

var name = platform === "win32" ? "ffmpeg.exe" : "ffmpeg";

var url = `https://github.com/qawolf/ffmpeg-static/releases/download/v3.0.0/${platform}-${arch}-${name}`;

downloadFile(url, ffmpegPath, onProgress);
