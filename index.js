'use strict'

import {arch as osArch, platform as osPlatform} from 'node:os'
import {fileURLToPath} from 'url'
import {join as pathJoin, dirname} from 'node:path'

let ffmpegPath = null

if (process.env.FFMPEG_BIN) {
  ffmpegPath = process.env.FFMPEG_BIN
} else {
  const binaries = Object.assign(Object.create(null), {
    darwin: ['x64', 'arm64'],
    freebsd: ['x64'],
    linux: ['x64', 'ia32', 'arm64', 'arm'],
    win32: ['x64', 'ia32']
  })

  const platform = process.env.npm_config_platform || osPlatform()
  const arch = process.env.npm_config_arch || osArch()

  if (binaries[platform] && binaries[platform].includes(arch)) {
    const __dirname = dirname(fileURLToPath(import.meta.url))
    ffmpegPath = pathJoin(
      __dirname,
      platform === 'win32' ? 'ffmpeg.exe' : 'ffmpeg'
    )
  }
}

export default ffmpegPath
