# ffmpeg-static

**[ffmpeg](https://ffmpeg.org) static binaries for Mac OSX and Linux and Windows.**

Supports macOS (64-bit), Linux (32 and 64-bit) and Windows (32 and 64-bit). The current ffmpeg version is `3.3.3`.

[![build status](https://secure.travis-ci.org/eugeneware/ffmpeg-static.png)](http://travis-ci.org/eugeneware/ffmpeg-static)

## Installation

This module is installed via npm:

``` bash
$ npm install ffmpeg-static
```

## Example Usage

Returns the path of a statically linked ffmpeg binary on the local filesystem.

``` js
var ffmpeg = require('ffmpeg-static');
console.log(ffmpeg.path);
// /Users/eugeneware/Dropbox/work/ffmpeg-static/bin/darwin/x64/ffmpeg
```

## Sources of the binaries

[The build script](build/index.sh) downloads binaries from these locations:

- [Windows builds](https://ffmpeg.zeranoe.com/builds/win64/static/)
- [Linux builds](https://johnvansickle.com/ffmpeg/releases/)
- [macOS builds](https://evermeet.cx/pub/ffmpeg/)

## Building the project

The `unzip`, `tar` and `7zr` CLI executables need to be installed. On macOS, use `brew install p7zip gnu-tar`.