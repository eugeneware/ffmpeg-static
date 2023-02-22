#!/bin/bash
set -e -u -o pipefail
cd $(dirname $0)

set +e
tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi
if [ -z "$tar_exec" ]; then
	1>&2 echo "no tar executable found"
	exit 1
fi
# https://rtfmp.wordpress.com/2017/03/31/difference-7z-7za-and-7zr/
p7zip_exec=$(command -v 7zr)
if [ $? -ne 0 ]; then
	p7zip_exec=$(command -v 7zz)
fi
if [ $? -ne 0 ]; then
	p7zip_exec=$(command -v 7z)
fi
if [ -z "$p7zip_exec" ]; then
	1>&2 echo "no p7zip executable found"
	exit 1
fi
set -e
echo using tar executable at $tar_exec
echo using 7z executable at $p7zip_exec

mkdir -p ../bin

download () {
	# todo: use https://gist.github.com/derhuerst/745cf09fe5f3ea2569948dd215bbfe1a ?
	curl -f -L -# --compressed -A 'https://github.com/eugeneware/ffmpeg-static binaries download script' -o $2 $1
}

set -x # todo: remove

echo 'windows x64'
echo '  downloading from github.com/GyanD/codexffmpeg'
# todo: 404
download 'https://github.com/GyanD/codexffmpeg/releases/download/5.0.1/ffmpeg-5.0.1-essentials_build.7z' win32-x64.7z
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
curl -sf -L 'https://raw.githubusercontent.com/sudo-nautilus/FFmpeg-Builds-Win32/autobuild-2022-04-30-14-19/LICENSE' -o ../bin/win32-ia32.LICENSE

echo 'linux x64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.0.1-amd64-static.tar.xz' linux-x64.tar.xz
echo '  extracting'
xzcat linux-x64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-x64
mv ../bin/ffprobe ../bin/ffprobe-linux-x64
xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-x64.LICENSE
xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-x64.README

echo 'linux ia32'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.0.1-i686-static.tar.xz' linux-ia32.tar.xz
echo '  extracting'
xzcat linux-ia32.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-ia32
mv ../bin/ffprobe ../bin/ffprobe-linux-ia32
xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-ia32.LICENSE
xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-ia32.README

echo 'linux arm'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.0.1-armhf-static.tar.xz' linux-arm.tar.xz
echo '  extracting'
xzcat linux-arm.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm
mv ../bin/ffprobe ../bin/ffprobe-linux-arm
xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm.LICENSE
xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm.README

echo 'linux arm64'
echo '  downloading from johnvansickle.com'
download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.0.1-arm64-static.tar.xz' linux-arm64.tar.xz
echo '  extracting'
xzcat linux-arm64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg' '*/ffprobe'
mv ../bin/ffmpeg ../bin/ffmpeg-linux-arm64
mv ../bin/ffprobe ../bin/ffprobe-linux-arm64
xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm64.LICENSE
xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm64.README

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download $(curl 'https://evermeet.cx/ffmpeg/info/ffmpeg/5.0.1' -sfL | jq -rc '.download.zip.url') ffmpeg-darwin-x64.zip
download $(curl 'https://evermeet.cx/ffmpeg/info/ffprobe/5.0.1' -sfL | jq -rc '.download.zip.url') ffprobe-darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j ffmpeg-darwin-x64.zip ffmpeg
unzip -o -d ../bin -j ffprobe-darwin-x64.zip ffprobe
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-x64
mv ../bin/ffprobe ../bin/ffprobe-darwin-x64
curl -s -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/HEAD:/LICENSE.md'  -o ../bin/darwin-x64.LICENSE
curl -s -L 'https://evermeet.cx/ffmpeg/info/ffmpeg/release' | jq --tab '.' >../bin/darwin-x64.README
# todo: pull ffprobe README?

echo 'darwin arm64'
echo '  downloading from osxexperts.net'
download 'https://www.osxexperts.net/FFmpeg501ARM.zip' darwin-arm64.zip
echo '  extracting'
unzip -o -d ../bin -j darwin-arm64.zip ffmpeg
mv ../bin/ffmpeg ../bin/ffmpeg-darwin-arm64
curl -sf -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n5.0.1:/LICENSE.md'  -o ../bin/darwin-arm64.LICENSE
curl -sf -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n5.0.1:/README.md'  -o ../bin/darwin-arm64.README

echo 'freebsd x64'
echo '  downloading from github.com/Thefrank/ffmpeg-static-freebsd'
download 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v5.0.1/ffmpeg' ../bin/ffmpeg-freebsd-x64
download 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v5.0.1/ffmprobe' ../bin/ffmprobe-freebsd-x64
chmod +x ../bin/ffmpeg-freebsd-x64
chmod +x ../bin/ffprobe-freebsd-x64
curl -sf -L 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v5.0.1/GPLv3.LICENSE' -o ../bin/freebsd-x64.LICENSE
curl -sf -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n5.0.1:/README.md' -o ../bin/freebsd-x64.README
