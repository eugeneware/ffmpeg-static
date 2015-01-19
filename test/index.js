var it = require('tape'),
    fs = require('fs'),
    ffmpeg = require('..');

it('should find ffmpeg', function(t) {
  var stats = fs.statSync(ffmpeg.path);
  t.ok(stats.isFile(ffmpeg.path));
  t.end();
});
