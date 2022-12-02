#!/usr/bin/env node

const {join: pathJoin} = require('path')
const {cpSync, writeFileSync} = require('fs')
const basePkg = require('./package.json')

const PACKAGES = [
	'ffmpeg-static',
	'ffprobe-static',
]

const copyFileIntoPackage = (pkgName, filename) => {
	const src = pathJoin(__dirname, filename)
	const dest = pathJoin(__dirname, 'packages', pkgName, filename)
	cpSync(src, dest, {
		dereference: true, // dereference symlinks
		preserveTimestamps: true,
	})
}

const generatePackageJsonForPackages = (pkgName) => {
	const tplPath = pathJoin(__dirname, 'packages', pkgName, 'package.template.json')
	const tpl = require(tplPath)

	const packageJson = {
		...basePkg,

		// remove fields
		private: undefined,
		workspaces: undefined,
		...Object.fromEntries(
			PACKAGES
			// remove own entry
			.filter(_pkgName => _pkgName !== pkgName)
			// remove others by setting `undefined` as value
			.map(_pkgName => [_pkgName, undefined])
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

	const dest = pathJoin(__dirname, 'packages', pkgName, 'package.json')
	writeFileSync(dest, JSON.stringify(packageJson, null, '\t'))
}

for (const pkgName of PACKAGES) {
	copyFileIntoPackage(pkgName, 'LICENSE')
	copyFileIntoPackage(pkgName, 'index.js')
	copyFileIntoPackage(pkgName, 'install.js')
	generatePackageJsonForPackages(pkgName)

	console.info(pkgName, '✔︎')
}
