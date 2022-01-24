'use strict'

import {ok, strictEqual} from 'node:assert'
import {isAbsolute} from 'node:path'
import {statSync, accessSync, constants as fsConstants} from 'node:fs'
import {spawnSync} from 'node:child_process'
import shell from 'any-shell-escape'
import ffmpegPath from './index.js'

console.info('TAP version 12')
console.info('1..4')

ok(isAbsolute(ffmpegPath))
console.info('ok 1 - ffmpeg path is absolute')

ok(statSync(ffmpegPath).isFile(ffmpegPath))
console.info(`ok 2 - ${ffmpegPath} is a file`)

accessSync(ffmpegPath, fsConstants.X_OK)
console.info(`ok 3 - ${ffmpegPath} is executable`)

const {status} = spawnSync(ffmpegPath, ['--help'], {
	stdio: ['ignore', 'ignore', 'pipe'], // stdin, stdout, stderr
})
strictEqual(status, 0)
console.info(`ok 4 - \`${ffmpegPath} --help\` works`)
