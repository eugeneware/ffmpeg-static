#!/usr/bin/env node
'use strict'

const {resolve} = require('path')
const shell = require('any-shell-escape')
const {exec} = require('child_process')
const pathToFfprobe = require('.')

const argv = process.argv.slice(2)
if (argv.includes('-h') || argv.includes('--help')) {
	console.info(`
This is just a simple CLI wrapper around the powerful ffprobe CLI tool.
This script just showcases how to use ffprobe-static; It wouldn't make
sense to hide a flexible tool behind a limited wrapper script.
Usage:
	./example.js <file>
Example:
	./example.js audio-file.m4a
`)
	process.exit(0)
}

const [file, dest] = argv
if (!file) {
	console.error('Missing <file> positional argument.')
	process.exit(1)
}

const inspectAsJson = shell([
	pathToFfprobe,
	'-show_format', '-show_streams',
	'-of', 'json',
	resolve(process.cwd(), file),
])

exec(inspectAsJson, (err) => {
	if (!err) return;
	console.error(err)
	process.exit(1)
})
