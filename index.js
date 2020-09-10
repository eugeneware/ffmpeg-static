'use strict'

function getPath(name) {
  const os = require('os')
  const path = require('path')

  const binaries = Object.assign(Object.create(null), {
    darwin: ['x64'],
    linux: ['x64', 'ia32', 'arm64', 'arm'],
    win32: ['x64', 'ia32']
  })

  const platform = process.env.npm_config_platform || os.platform()
  const arch = process.env.npm_config_arch || os.arch()

  if (!binaries[platform] || binaries[platform].indexOf(arch) === -1) {
    return null
  }

  return path.join(
    __dirname,
    platform === 'win32' ? name + '.exe' : name
  )
}

exports.ffmpegPath = getPath('ffmpeg')
exports.ffprobePath = getPath('ffprobe')
