# static ffmpeg/ffprobe binaries

Static **[ffmpeg](https://ffmpeg.org)/ffprobe binaries for macOS, Linux, Windows.**

Supports macOS (64-bit and arm64), Linux (32 and 64-bit, armhf, arm64), Windows (32 and 64-bit). [The ffmpeg version currently used is `6.0`.](https://github.com/eugeneware/ffmpeg-static/releases/tag/b6.0)

[![npm version](https://img.shields.io/npm/v/ffmpeg-static.svg)](https://www.npmjs.com/package/ffmpeg-static)
![minimum Node.js version](https://img.shields.io/node/v/ffmpeg-static.svg)

## Sources of the binaries

[The binaries download script](download-binaries/index.sh) downloads binaries from these locations:

- [Windows x64 builds](https://www.gyan.dev/ffmpeg/builds/)
- [Windows x86 builds](https://github.com/sudo-nautilus/FFmpeg-Builds-Win32/)
- [Linux x64/x86/ARM/ARM64 builds](https://johnvansickle.com/ffmpeg/)
- macOS [x64 (Intel)](https://evermeet.cx/pub/ffmpeg/) & [ARM64 (Apple Silicon)](https://osxexperts.net/) builds

The script extracts build information and (when possible) the license file from the downloaded package or the distribution server. Please consult the individual build's project site for exact source versions, which you can locate based on the version information included in the README file.

## Show your support

The npm packages include statically linked binaries that are produced by the following individuals, who have been doing this for many years. Please consider supporting and donating to them:

- **Linux builds**: [John Van Sickle](https://www.johnvansickle.com/ffmpeg/)
- **macOS builds**: [Helmut K. C. Tessarek](https://evermeet.cx/ffmpeg/#donations)

## Building the project

The `unzip`, `tar` CLI executables need to be installed. On macOS, use `brew install gnu-tar xz`.
