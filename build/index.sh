#!/bin/bash
set -e
cd $(dirname $0)

set +e
tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi
https://rtfmp.wordpress.com/2017/03/31/difference-7z-7za-and-7zr/
p7zip_exec=$(command -v 7zr)
if [ $? -ne 0 ]; then
	p7zip_exec=$(command -v 7zz)
fi
if [ $? -ne 0 ]; then
	p7zip_exec=$(command -v 7z)
fi
set -e
echo using tar executable at $tar_exec
echo using 7z executable at $p7zip_exec

mkdir -p ../bin

download () {
	curl -f -L -# --compressed -A 'https://github.com/eugeneware/ffmpeg-static build script' -o $2 $1
}

echo 'windows x64'
echo '  downloading from gyan.dev'
download 'https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.7z' win32-x64.7z
echo '  extracting'
tmpdir=$(mktemp -d)
$p7zip_exec e -y -bd -o"$tmpdir" win32-x64.7z >/dev/null
mv "$tmpdir/ffmpeg.exe" ../bin/ffmpeg-win32-x64
mv "$tmpdir/ffprobe.exe" ../bin/ffprobe-win32-x64
chmod +x ../bin/ffmpeg-win32-x64 ../bin/ffprobe-win32-x64
mv "$tmpdir/LICENSE" ../bin/win32-x64.LICENSE
mv "$tmpdir/README.txt" ../bin/win32-x64.README

echo 'windows ia32'
echo '  downloading from github.com'
download 'https://github.com/sudo-nautilus/FFmpeg-Builds-Win32/releases/download/autobuild-2022-04-30-14-19/ffmpeg-n5.0.1-4-ga5ebb3d25e-win32-gpl-5.0.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip '*/bin/ffmpeg.exe' '*/bin/ffprobe.exe'
mv ../bin/ffmpeg.exe ../bin/ffmpeg-win32-ia32
mv ../bin/ffprobe.exe ../bin/ffprobe-win32-ia32
curl -s -L 'https://raw.githubusercontent.com/sudo-nautilus/FFmpeg-Builds-Win32/master/LICENSE' -o ../bin/win32-ia32.LICENSE

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
xzcat linux-x64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-x64
mv ../bin/ffprobe ../bin/ffprobe-linux-x64
xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-x64.LICENSE
xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-x64.README

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
xzcat linux-ia32.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-ia32
mv ../bin/ffprobe ../bin/ffprobe-linux-ia32
xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-ia32.LICENSE
xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-ia32.README

echo 'linux arm'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
xzcat linux-arm.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm
mv ../bin/ffprobe ../bin/ffprobe-linux-arm
xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm.LICENSE
xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm.README

echo 'linux arm64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
xzcat linux-arm64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm64
mv ../bin/ffprobe ../bin/ffprobe-linux-arm64
xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm64.LICENSE
xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm64.README

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download 'https://evermeet.cx/ffmpeg/getrelease/ffmpeg/zip' ffmpeg-darwin-x64.zip
download 'https://evermeet.cx/ffmpeg/getrelease/ffprobe/zip' ffprobe-darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j ffmpeg-darwin-x64.zip ffmpeg
unzip -o -d ../bin -j ffprobe-darwin-x64.zip ffprobe
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-x64
mv ../bin/ffprobe ../bin/ffprobe-darwin-x64
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/LICENSE.md'  -o ../bin/darwin-x64.LICENSE
curl -s -L 'https://evermeet.cx/ffmpeg/info/ffmpeg/release' | jq --tab '.' >../bin/darwin-x64.README

echo 'darwin arm64'
echo '  downloading from osxexperts.net'
download 'https://www.osxexperts.net/FFmpeg501ARM.zip' darwin-arm64.zip
echo '  extracting'
unzip -o -d ../bin -j darwin-arm64.zip ffmpeg
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-arm64
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/LICENSE.md'  -o ../bin/darwin-arm64.LICENSE
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/README.md'  -o ../bin/darwin-arm64.README

# todo: add FreeBSD again
# echo 'freebsd x64'
# echo '  downloading from github.com/Thefrank/ffmpeg-static-freebsd'
# download 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v5.0.0/ffmpeg' ../bin/freebsd-x64
# chmod +x ../bin/freebsd-x64
