#!/usr/bin/env node

const {join: pathJoin} = require('path')
const {cpSync, writeFileSync} = require('fs')
const basePkg = require('./package.json')

// directory name -> package name
const PACKAGES = new Map([
	['ffmpeg-static', 'ffmpeg-static'],
	['ffprobe-static', '@derhuerst/ffprobe-static'],
])

const copyFileIntoPackage = (pkgDirName, filename) => {
	const src = pathJoin(__dirname, filename)
	const dest = pathJoin(__dirname, 'packages', pkgDirName, filename)
	cpSync(src, dest, {
		dereference: true, // dereference symlinks
		preserveTimestamps: true,
	})
}

const generatePackageJsonForPackages = (pkgDirName, pkgName) => {
	const tplPath = pathJoin(__dirname, 'packages', pkgDirName, 'package.template.json')
	const tpl = require(tplPath)

	const packageJson = {
		...basePkg,

		// remove fields
		private: undefined,
		workspaces: undefined,
		...Object.fromEntries(
			Array.from(PACKAGES.entries())
			// remove own entry so that basePkg's field is not shadowed
			.filter(([_, _pkgName]) => _pkgName !== pkgName)
			// remove others by setting `undefined` as value
			.map(([_, _pkgName]) => [_pkgName, undefined])
		),

		main: 'index.js',
		files: [
			'index.js',
			'install.js',
			'example.js',
			'types',
		],
		types: 'types/index.d.ts',
		scripts: {
			install: 'node install.js',
			prepublishOnly: 'npm run install',
		},
		devDependencies: {
			...basePkg.devDependencies,
			eslint: undefined, // remove field
		},

		...tpl,
	}

	const dest = pathJoin(__dirname, 'packages', pkgDirName, 'package.json')
	writeFileSync(dest, JSON.stringify(packageJson, null, '\t'))
}

for (const [pkgDirName, pkgName] of PACKAGES.entries()) {
	copyFileIntoPackage(pkgDirName, 'LICENSE')
	copyFileIntoPackage(pkgDirName, 'index.js')
	copyFileIntoPackage(pkgDirName, 'install.js')
	generatePackageJsonForPackages(pkgDirName, pkgName)

	console.info(pkgName, '✔︎')
}
