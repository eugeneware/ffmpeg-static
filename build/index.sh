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

mkdir -p ../bin

download () {
	curl -L -# --compressed -A 'https://github.com/eugeneware/ffmpeg-static build script' -o $2 $1
}

echo 'windows x64'
echo '  downloading from gyan.dev'
download 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z' win32-x64.7z
echo '  extracting'
tmpdir=$(mktemp -d)
7zr e -y -bd -o"$tmpdir" win32-x64.7z >/dev/null
tree "$tmpdir"
mv "$tmpdir/ffmpeg.exe" ../bin/win32-x64
mv "$tmpdir/LICENSE" ../bin/win32-x64.LICENSE
mv "$tmpdir/README.txt" ../bin/win32-x64.README

echo 'windows ia32'
echo '  downloading from github.com'
download 'https://github.com/ShareX/FFmpeg/releases/download/v4.3.1/ffmpeg-4.3.1-win32.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip 'ffmpeg.exe'
mv ../bin/ffmpeg.exe ../bin/win32-ia32
curl -s -L 'https://github.com/ShareX/FFmpeg/raw/master/LICENSE.txt' -o ../bin/win32-ia32.LICENSE

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
xzcat linux-x64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-x64
xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-x64.LICENSE
xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-x64.README

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
xzcat linux-ia32.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-ia32
xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-ia32.LICENSE
xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-ia32.README

echo 'linux arm'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
xzcat linux-arm.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-arm
xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm.LICENSE
xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm.README

echo 'linux arm64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
xzcat linux-arm64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-arm64
xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm64.LICENSE
xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm64.README

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download 'https://evermeet.cx/ffmpeg/getrelease/ffmpeg/zip' darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j darwin-x64.zip ffmpeg
mv ../bin/ffmpeg ../bin/darwin-x64
curl -s -L 'https://evermeet.cx/ffmpeg/info/ffmpeg/release' | jq --tab '.' >../bin/darwin-x64.README
