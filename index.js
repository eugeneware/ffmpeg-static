'use strict'

if (process.env.FFMPEG_BIN) {
  module.exports = process.env.FFMPEG_BIN
} else {
  var os = require('os')
  var path = require('path')
  const pkg = require('./package.json')
  const {
    'executable-base-name': executableBaseName,
  } = pkg[pkg.name]
  if ('string' !== typeof executableBaseName) {
    throw new Error(`package.json: invalid/missing ${pkg.name}.executable-base-name entry`)
  }

  var binaries = Object.assign(Object.create(null), {
    darwin: ['x64', 'arm64'],
    freebsd: ['x64'],
    linux: ['x64', 'ia32', 'arm64', 'arm'],
    win32: ['x64', 'ia32']
  })

  var platform = process.env.npm_config_platform || os.platform()
  var arch = process.env.npm_config_arch || os.arch()

  var ffmpegPath = path.join(
    __dirname,
    executableBaseName + (platform === 'win32' ? '.exe' : ''),
  )

  if (!binaries[platform] || binaries[platform].indexOf(arch) === -1) {
    ffmpegPath = null
  }

  module.exports = ffmpegPath
}
