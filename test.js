'use strict'

const {ok, strictEqual} = require('assert')
const {isAbsolute} = require('path')
const fs = require('fs')
const {spawnSync} = require('child_process')
const shell = require('any-shell-escape')
const { ffmpegPath, ffprobePath } = require('.')

console.info('TAP version 12')
console.info('1..8')

ok(isAbsolute(ffmpegPath))
console.info('ok 1 - ffmpeg path is absolute')
ok(isAbsolute(ffprobePath))
console.info('ok 2 - ffprobe path is absolute')

ok(fs.statSync(ffmpegPath).isFile(ffmpegPath))
console.info(`ok 3 - ${ffmpegPath} is a file`)
ok(fs.statSync(ffprobePath).isFile(ffprobePath))
console.info(`ok 4 - ${ffprobePath} is a file`)

fs.accessSync(ffmpegPath, fs.constants.X_OK)
console.info(`ok 5 - ${ffmpegPath} is executable`)
fs.accessSync(ffprobePath, fs.constants.X_OK)
console.info(`ok 6 - ${ffprobePath} is executable`)

const spawnFfmpeg = spawnSync(ffmpegPath, ['--help'], {
	stdio: ['ignore', 'ignore', 'pipe'], // stdin, stdout, stderr
})
strictEqual(spawnFfmpeg.status, 0)
console.info(`ok 7 - \`${ffmpegPath} --help\` works`)

const spawnFfprobe = spawnSync(ffprobePath, ['--help'], {
	stdio: ['ignore', 'ignore', 'pipe'], // stdin, stdout, stderr
})
strictEqual(spawnFfprobe.status, 0)
console.info(`ok 8 - \`${ffprobePath} --help\` works`)
