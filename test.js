'use strict'

const {ok, strictEqual} = require('assert')
const {isAbsolute} = require('path')
const fs = require('fs')
const {spawnSync} = require('child_process')
const shell = require('any-shell-escape')
const ffmpegPath = require('.')

console.info('TAP version 12')
console.info('1..4')

ok(isAbsolute(ffmpegPath))
console.info('ok 1 - ffmpeg path is absolute')

ok(fs.statSync(ffmpegPath).isFile(ffmpegPath))
console.info(`ok 2 - ${ffmpegPath} is a file`)

fs.accessSync(ffmpegPath, fs.constants.X_OK)
console.info(`ok 3 - ${ffmpegPath} is executable`)

const {status} = spawnSync(ffmpegPath, ['--help'], {
	stdio: ['ignore', 'ignore', 'pipe'], // stdin, stdout, stderr
})
strictEqual(status, 0)
console.info(`ok 4 - \`${ffmpegPath} --help\` works`)
