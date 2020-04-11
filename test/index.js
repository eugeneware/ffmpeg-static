'use strict'

const it = require('tape')
const path = require('path')
const fs = require('fs')
const ffmpegPath = require('..')

it('should find ffmpeg', function(t) {
  t.ok(path.isAbsolute(ffmpegPath));

  var stats = fs.statSync(ffmpegPath);
  t.ok(stats.isFile(ffmpegPath));

  t.doesNotThrow(()=> {
    fs.accessSync(ffmpegPath, fs.constants.X_OK)
  }, "ffmpeg not executable");

  t.end();
});
