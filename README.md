# ffmpeg-static

ffmpeg static binaries for Mac OSX and Linux and Windows

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

Currently supports Mac OS X (64-bit), Linux (32 and 64-bit) and Windows
(32 and 64-bit).

Currently version `3.1` is installed for Mac and Linux, and `3.0.1` for
Windows.

I pulled the versions from the ffmpeg static build pages linked from the
official ffmpeg site. Namely:

* [64 bit Mac OSX](https://evermeet.cx/ffmpeg/)
* [64 bit Linux](http://johnvansickle.com/ffmpeg/)
* [32 bit Linux](http://johnvansickle.com/ffmpeg/)
* [64 bit Windows](http://ffmpeg.zeranoe.com/builds/win64/static/)
* [32 bit Windows](http://ffmpeg.zeranoe.com/builds/win32/static/)

NB: Open to pull requests to update this module with the latest versions.

Ideally I'd like to dynamically pull the latest version down, but this requires
access to 7-zip which and being able to untar `xz` files.

And I couldn't find a good js-only decoders for these files either.

So, for now it's just embedded binaries.
