#!/bin/bash
set -x
tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi

tar_options="--wildcards --ignore-case"
if [ "$(uname)" == "Darwin" ]; then
  tar_options=""
fi

set -e
echo using tar executable: $tar_exec $tar_options

cd $(dirname $0)

download () {
  if [ -e $2 ]; then
    echo "  already downloaded: $2"
  else
    echo "  downloading $1"
    curl --connect-timeout 30 --retry 5 --retry-max-time 60 \
       --silent -L -# --compressed -A 'https://github.com/descriptinc/ffmpeg-ffprobe-static' -o $2 $1
  fi
}

echo 'windows x64'
download 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-4.3-win64-static.zip' win32-x64.zip
echo '  extracting'
unzip -o -d ../bin -j win32-x64.zip '**/ffmpeg.exe' '**/ffprobe.exe'
mv ../bin/ffmpeg.exe ../bin/ffmpeg-win32-x64
mv ../bin/ffprobe.exe ../bin/ffprobe-win32-x64
unzip -p win32-x64.zip '**/LICENSE.txt' > ../bin/win32-x64.LICENSE
unzip -p win32-x64.zip '**/README.txt' > ../bin/win32-x64.README

echo 'windows ia32'
download 'https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-4.3-win32-static.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip '**/ffmpeg.exe' '**/ffprobe.exe'
mv ../bin/ffmpeg.exe ../bin/ffmpeg-win32-ia32
mv ../bin/ffprobe.exe ../bin/ffprobe-win32-ia32
unzip -p win32-ia32.zip '**/LICENSE.txt' > ../bin/win32-ia32.LICENSE
unzip -p win32-ia32.zip '**/README.txt' > ../bin/win32-ia32.README

echo 'linux x64'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
$tar_exec $tar_options -x -C ../bin --strip-components 1 -f linux-x64.tar.xz '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-x64
mv ../bin/ffprobe ../bin/ffprobe-linux-x64
$tar_exec $tar_options -x -f linux-x64.tar.xz -O '**/GPLv3.txt' > ../bin/linux-x64.LICENSE
$tar_exec $tar_options -x -f linux-x64.tar.xz -O '**/readme.txt' > ../bin/linux-x64.README

echo 'linux ia32'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
$tar_exec $tar_options -x -C ../bin --strip-components 1 -f linux-ia32.tar.xz '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-ia32
mv ../bin/ffprobe ../bin/ffprobe-linux-ia32
$tar_exec $tar_options -x -f linux-ia32.tar.xz -O '**/GPLv3.txt' > ../bin/linux-ia32.LICENSE
$tar_exec $tar_options -x -f linux-ia32.tar.xz -O '**/readme.txt' > ../bin/linux-ia32.README

echo 'linux arm'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
$tar_exec $tar_options -x -C ../bin --strip-components 1 -f linux-arm.tar.xz '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm
mv ../bin/ffprobe ../bin/ffprobe-linux-arm
$tar_exec $tar_options -x -f linux-arm.tar.xz -O '**/GPLv3.txt' > ../bin/linux-arm.LICENSE
$tar_exec $tar_options -x -f linux-arm.tar.xz -O '**/readme.txt' > ../bin/linux-arm.README

echo 'linux arm64'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
$tar_exec $tar_options -x -C ../bin --strip-components 1 -f linux-arm64.tar.xz '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm64
mv ../bin/ffprobe ../bin/ffprobe-linux-arm64
$tar_exec $tar_options -x -f linux-arm64.tar.xz -O '**/GPLv3.txt' > ../bin/linux-arm64.LICENSE
$tar_exec $tar_options -x -f linux-arm64.tar.xz -O '**/readme.txt' > ../bin/linux-arm64.README

echo 'darwin x64'
download 'https://evermeet.cx/ffmpeg/getrelease/ffmpeg/zip' ffmpeg-darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j ffmpeg-darwin-x64.zip ffmpeg
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-x64

download 'https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip' ffprobe-darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j ffprobe-darwin-x64.zip ffprobe
mv ../bin/ffprobe ../bin/ffprobe-darwin-x64
curl -s -L 'https://evermeet.cx/ffmpeg/info/ffmpeg/release' | jq --tab '.' >../bin/darwin-x64.README
