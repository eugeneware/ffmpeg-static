var path = require('path')
var fs = require('fs')

var paths = {}
fs.readdirSync('bin').forEach(function(platform) {
  var platformPath = path.join('bin', platform)
  fs.readdirSync(platformPath).forEach(function(arch) {
    paths[platform] = paths[platform] || {}
    paths[platform][arch] = path.join(
      __dirname,
      'bin',
      platform,
      arch,
      platform === 'win32' ? 'ffmpeg.exe' : 'ffmpeg'
    )
  })
})

exports.paths = paths
