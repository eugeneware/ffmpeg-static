#!/bin/sh
set -e
cd $(dirname $0)

download () {
	curl -L -# -A 'https://github.com/eugeneware/ffmpeg-static' -o $2 $1
}

echo 'windows x64'
echo \t'downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip' win32-x64.zip
echo \t'extracting'
unzip -d bin/win32/x64 -j win32-x64.zip '**/ffmpeg.exe'

echo 'windows ia32'
echo \t'downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip' win32-ia32.zip
echo \t'extracting'
unzip -d bin/win32/ia32 -j win32-ia32.zip '**/ffmpeg.exe'

echo 'linux x64'
echo \t'downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-64bit-static.tar.xz' linux-x64.tar.xz
echo \t'extracting'
tar -x -C bin/linux/x64 --strip-components 1 -f linux-x64.tar.xz --wildcards '*/ffmpeg'

echo 'linux ia32'
echo \t'downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-32bit-static.tar.xz' linux-ia32.tar.xz
echo \t'extracting'
tar -x -C bin/linux/ia32 --strip-components 1 -f linux-ia32.tar.xz --wildcards '*/ffmpeg'

# todo: find latest version
echo 'darwin x64 – downloading from evermeet.cx'
download 'https://evermeet.cx/pub/ffmpeg/ffmpeg-3.3.3.7z' darwin-x64-ffmpeg.7z
7zr e -y -bd -o../bin/darwin/x64 darwin-x64-ffmpeg.7z >/dev/null
