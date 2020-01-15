var it = require('tape'),
    path = require('path');
    fs = require('fs'),
    ffmpegPath = require('..');

it('should find ffmpeg', function(t) {
  t.ok(path.isAbsolute(ffmpegPath));

  var stats = fs.statSync(ffmpegPath);
  t.ok(stats.isFile(ffmpegPath));

  try {
    fs.accessSync(ffmpegPath, fs.constants.X_OK)
  } catch {
    t.error("ffmpeg not executable");
  }

  t.end();
});
