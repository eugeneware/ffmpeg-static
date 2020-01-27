var os = require('os')
var path = require('path')

var binaries = Object.assign(Object.create(null), {
  darwin: ['x64'],
  linux: ['x64', 'ia32', 'arm64', 'arm'],
  win32: ['x64', 'ia32']
})

var platform = os.platform()
var arch = os.arch()

var ffmpegPath = path.join(
  __dirname,
  platform === 'win32' ? 'ffmpeg.exe' : 'ffmpeg'
)

if (!binaries[platform] || binaries[platform].indexOf(arch) === -1) {
  ffmpegPath = null
}

module.exports = ffmpegPath
