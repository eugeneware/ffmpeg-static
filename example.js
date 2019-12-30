#!/usr/bin/env node
'use strict'

const {join} = require('path')
const shell = require('any-shell-escape')
const {exec} = require('child_process')

const argv = process.argv.slice(2)
if (argv.includes('-h') || argv.includes('--help')) {
	console.info(`
This is just a simple CLI wrapper around the powerful ffmpeg CLI tool.
This script just showcases how to use ffmpeg-static; It wouldn't make
sense to hide a flexible tool behind a limited wrapper script.
Usage:
	./example.js src-audio-file.m4a dest-audio-file.mp3
`)
	process.exit(0)
}

const [src, dest] = argv
const makeMp3 = shell([
	'ffmpeg', '-y', '-v', 'error',
	'-i', join(process.cwd(), src),
	'-acodec', 'mp3',
	'-format', 'mp3',
	join(process.cwd(), dest)
])

exec(makeMp3, (err) => {
	if (err) {
		console.error(err)
		process.exit(1)
	} else {
		console.info('done!')
	}
})
