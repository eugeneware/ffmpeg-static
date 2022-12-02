'use strict'

const {ok, strictEqual} = require('assert')
const {isAbsolute} = require('path')
const {statSync, accessSync, constants} = require('fs')
const {spawnSync} = require('child_process')
const shell = require('any-shell-escape')

{
	const ffmpegPath = require('./packages/ffmpeg-static')

	ok(isAbsolute(ffmpegPath), 'ffmpeg path must be absolute')
	ok(statSync(ffmpegPath).isFile(ffmpegPath), `${ffmpegPath} must be a file`)
	accessSync(ffmpegPath, constants.X_OK, `${ffmpegPath} must be executable`)

	const {status} = spawnSync(ffmpegPath, ['--help'], {
		stdio: ['ignore', 'ignore', 'pipe'], // stdin, stdout, stderr
	})
	strictEqual(status, 0, `\`${ffmpegPath} --help\` exits with 0`)
}

{
	const ffprobePath = require('./packages/ffprobe-static')

	ok(isAbsolute(ffprobePath), 'ffprobe path must be absolute')
	ok(statSync(ffprobePath).isFile(ffprobePath), `${ffprobePath} must be a file`)
	accessSync(ffprobePath, constants.X_OK, `${ffprobePath} must be executable`)

	const {status} = spawnSync(ffprobePath, ['--help'], {
		stdio: ['ignore', 'ignore', 'pipe'], // stdin, stdout, stderr
	})
	strictEqual(status, 0, `\`${ffprobePath} --help\` exits with 0`)
}

console.info('seems to work ✔︎')
