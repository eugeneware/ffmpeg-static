# ffmpeg-ffprobe-static

Fork of [ffmpeg-static](https://github.com/eugeneware/ffmpeg-static) that includes ffprobe.

## Info

**[ffmpeg](https://ffmpeg.org) static binaries for Mac OSX and Linux and Windows.**

Supports macOS (64-bit), Linux (32 and 64-bit, armhf, arm64) and Windows (32 and 64-bit). [The ffmpeg version currently used is `4.3.1`.](https://github.com/descriptinc/ffmpeg-ffprobe-static/releases/tag/b4.3.1)

*Note:* The version of `ffmpeg-ffprobe-static` follows [SemVer](http://semver.org). When releasing new versions, **we do *not* consider breaking changes in `ffmpeg` itself**, but only the JS interface (see below). To stop `ffmpeg-ffprobe-static` from breaking your code by getting updated, [lock the version down](https://docs.npmjs.com/files/package.json#dependencies) or use a [lockfile](https://docs.npmjs.com/files/package-lock.json).

[![npm version](https://img.shields.io/npm/v/ffmpeg-ffprobe-static.svg)](https://www.npmjs.com/package/ffmpeg-ffprobe-static)
[![Actions Status](https://github.com/descriptinc/ffmpeg-ffprobe-static/workflows/test/badge.svg)](https://github.com/descriptinc/ffmpeg-ffprobe-static/actions)
![minimum Node.js version](https://img.shields.io/node/v/ffmpeg-ffprobe-static.svg)

## Installation

This module is installed via npm:

``` bash
$ npm install ffmpeg-ffprobe-static
```

*Note:* During installation, it will download the appropriate `ffmpeg`/`ffprobe` binary from the [`b4.3.1` GitHub release](https://github.com/descriptinc/ffmpeg-ffprobe-static/releases/tag/b4.3.1). Use and distribution of the binary releases of FFmpeg are covered by their respective license.

Alternatively, it will fetch binaries from `FFMPEG_FFPROBE_STATIC_BASE_URL` if set as an environment variable. The default base URL is https://github.com/descriptinc/ffmpeg-ffprobe-static/releases/download/. The install script will fetch binaries from `BASE_URL/binary-release-tag` (the `binary-release-tag` is set in package.json and can customized by setting `FFMPEG_BINARY_RELEASE`).


### Electron & other cross-platform packaging tools

Because `ffmpeg-ffprobe-static` will download a binary specific to the OS/platform, you need to purge `node_modules` before (re-)packaging your app *for a different OS/platform* ([read more in #35](https://github.com/eugeneware/ffmpeg-static/issues/35#issuecomment-630225392)).

## Example Usage

Returns the path of a statically linked ffmpeg binary on the local filesystem.

``` js
var pathToFfmpeg = require('ffmpeg-ffprobe-static');
console.log(pathToFfmpeg);
```

```
/Users/j/playground/node_modules/ffmpeg-ffprobe-static/ffmpeg
```

Check the [example script](example.js) for a more thorough example.

## Sources of the binaries

[The build script](build/index.sh) downloads binaries from these locations:

- [Windows builds](https://ffmpeg.zeranoe.com/builds/win64/static/)
- [Linux builds](https://johnvansickle.com/ffmpeg/)
- [macOS builds](https://evermeet.cx/pub/ffmpeg/)

The build script extracts build information and (when possible) the license file from the downloaded package or the distribution server. Please consult the individual build's project site for exact source versions, which you can locate based on the version information included in the README file.

## Show your support

This npm package includes statically linked binaries that are produced by the following individuals. Please consider supporting and donating to them who have been providing quality binary builds for many years:

- **Windows builds**: [Kyle Schwarz](https://ffmpeg.zeranoe.com/builds/)
- **Linux builds**: [John Van Sickle](https://www.johnvansickle.com/ffmpeg/)
- **macOS builds**: [Helmut K. C. Tessarek](https://evermeet.cx/ffmpeg/#donations)

## Building the project

The `unzip`, `tar` CLI executables need to be installed. On macOS, use `brew install gnu-tar xz`.
