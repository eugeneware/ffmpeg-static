#!/bin/bash
set -e
cd $(dirname $0)

set +e
tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi
set -e
echo using tar executable at $tar_exec

download () {
	curl -L -# -A 'https://github.com/eugeneware/ffmpeg-static' -o $2 $1
}

echo 'windows x64'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip' win32-x64.zip
echo '  extracting'
unzip -o -d ../bin -j win32-x64.zip '**/ffmpeg.exe'
mv ../bin/ffmpeg.exe ../bin/win32-x64

echo 'windows ia32'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip '**/ffmpeg.exe'
mv ../bin/ffmpeg.exe ../bin/win32-ia32

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-x64.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-x64

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-ia32.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-ia32

echo 'linux arm'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-arm.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-arm

echo 'linux arm64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-arm64.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-arm64

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download "https://evermeet.cx/ffmpeg/getrelease" darwin-x64-ffmpeg.7z
echo '  extracting'
7zr e -y -bd -o../bin darwin-x64-ffmpeg.7z >/dev/null
mv ../bin/ffmpeg ../bin/darwin-x64
