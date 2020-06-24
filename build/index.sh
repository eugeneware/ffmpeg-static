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
	curl -L -# --compressed -A 'https://github.com/eugeneware/ffmpeg-static' -o $2 $1
}

echo 'windows x64'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.3-win64-static.zip' win32-x64.zip
echo '  extracting'
unzip -o -d ../bin -j win32-x64.zip '**/ffmpeg.exe'
mv ../bin/ffmpeg.exe ../bin/win32-x64
unzip -p win32-x64.zip '**/LICENSE.txt' > ../bin/win32-x64.LICENSE
unzip -p win32-x64.zip '**/README.txt' > ../bin/win32-x64.README

echo 'windows ia32'
echo '  downloading from ffmpeg.zeranoe.com'
download 'https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-4.3-win32-static.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip '**/ffmpeg.exe'
mv ../bin/ffmpeg.exe ../bin/win32-ia32
unzip -p win32-ia32.zip '**/LICENSE.txt' > ../bin/win32-ia32.LICENSE
unzip -p win32-ia32.zip '**/README.txt' > ../bin/win32-ia32.README

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-x64.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-x64
$tar_exec -x -f linux-x64.tar.xz --ignore-case --wildcards -O '**/GPLv3.txt' > ../bin/linux-x64.LICENSE
$tar_exec -x -f linux-x64.tar.xz --ignore-case --wildcards -O '**/readme.txt' > ../bin/linux-x64.README

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-ia32.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-ia32
$tar_exec -x -f linux-ia32.tar.xz --ignore-case --wildcards -O '**/GPLv3.txt' > ../bin/linux-ia32.LICENSE
$tar_exec -x -f linux-ia32.tar.xz --ignore-case --wildcards -O '**/readme.txt' > ../bin/linux-ia32.README

echo 'linux arm'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-arm.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-arm
$tar_exec -x -f linux-arm.tar.xz --ignore-case --wildcards -O '**/GPLv3.txt' > ../bin/linux-arm.LICENSE
$tar_exec -x -f linux-arm.tar.xz --ignore-case --wildcards -O '**/readme.txt' > ../bin/linux-arm.README

echo 'linux arm64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
$tar_exec -x -C ../bin --strip-components 1 -f linux-arm64.tar.xz --wildcards '*/ffmpeg'
mv ../bin/ffmpeg ../bin/linux-arm64
$tar_exec -x -f linux-arm64.tar.xz --ignore-case --wildcards -O '**/GPLv3.txt' > ../bin/linux-arm64.LICENSE
$tar_exec -x -f linux-arm64.tar.xz --ignore-case --wildcards -O '**/readme.txt' > ../bin/linux-arm64.README

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download 'https://evermeet.cx/ffmpeg/getrelease/ffmpeg/zip' darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j darwin-x64.zip ffmpeg
mv ../bin/ffmpeg ../bin/darwin-x64
curl -s -L 'https://evermeet.cx/ffmpeg/info/ffmpeg/release' | jq --tab '.' >../bin/darwin-x64.README
