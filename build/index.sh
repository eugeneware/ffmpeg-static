#!/bin/sh
set +e
cd $(dirname $0)

tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi

download () {
	curl -L -# -A 'https://github.com/eugeneware/ffmpeg-static' -o $2 $1
}

echo 'windows x64'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip' win32-x64.zip
echo '  extracting'
unzip -o -d ../bin/win32/x64 -j win32-x64.zip '**/ffmpeg.exe'

echo 'windows ia32'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin/win32/ia32 -j win32-ia32.zip '**/ffmpeg.exe'

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin/linux/x64 --strip-components 1 -f linux-x64.tar.xz --wildcards '*/ffmpeg'

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin/linux/ia32 --strip-components 1 -f linux-ia32.tar.xz --wildcards '*/ffmpeg'

echo 'linux arm'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin/linux/arm --strip-components 1 -f linux-arm.tar.xz --wildcards '*/ffmpeg'

echo 'linux arm64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin/linux/arm64 --strip-components 1 -f linux-arm64.tar.xz --wildcards '*/ffmpeg'

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download "https://evermeet.cx/ffmpeg/getrelease" darwin-x64-ffmpeg.7z
7zr e -y -bd -o../bin/darwin/x64 darwin-x64-ffmpeg.7z >/dev/null
