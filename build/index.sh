#!/bin/bash
set -e
cd $(dirname $0)

set +e
tar_exec=$(command -v gtar)
if [ $? -ne 0 ]; then
	tar_exec=$(command -v tar)
fi
# https://rtfmp.wordpress.com/2017/03/31/difference-7z-7za-and-7zr/
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
	# todo: use https://gist.github.com/derhuerst/745cf09fe5f3ea2569948dd215bbfe1a ?
	curl -f -L -# --compressed -A 'https://github.com/eugeneware/ffmpeg-static build script' -o $2 $1
}

echo 'windows x64'
echo '  downloading from github.com/GyanD/codexffmpeg'
download 'https://github.com/GyanD/codexffmpeg/releases/download/5.1.2/ffmpeg-5.1.2-essentials_build.7z' win32-x64.7z
echo '  extracting'
tmpdir=$(mktemp -d)
$p7zip_exec e -y -bd -o"$tmpdir" win32-x64.7z >/dev/null
mv "$tmpdir/ffmpeg.exe" ../bin/win32-x64
chmod +x ../bin/win32-x64
mv "$tmpdir/LICENSE" ../bin/win32-x64.LICENSE
mv "$tmpdir/README.txt" ../bin/win32-x64.README

echo 'windows ia32'
echo '  downloading from github.com'
download 'https://github.com/sudo-nautilus/FFmpeg-Builds-Win32/releases/download/autobuild-2022-10-23-12-41/ffmpeg-n5.1.2-4-gf5455889fd-win32-gpl-5.1.zip' win32-ia32.zip
echo '  extracting'
unzip -o -d ../bin -j win32-ia32.zip '*/bin/ffmpeg.exe'
mv ../bin/ffmpeg.exe ../bin/win32-ia32
curl -sf -L 'https://raw.githubusercontent.com/sudo-nautilus/FFmpeg-Builds-Win32/autobuild-2022-10-23-12-41/LICENSE' -o ../bin/win32-ia32.LICENSE

# echo 'linux x64'
# echo '  downloading from johnvansickle.com'
# download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.1.2-amd64-static.tar.xz' linux-x64.tar.xz
# echo '  extracting'
# xzcat linux-x64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
# mv ../bin/ffmpeg ../bin/linux-x64
# xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-x64.LICENSE
# xzcat linux-x64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-x64.README

# echo 'linux ia32'
# echo '  downloading from johnvansickle.com'
# download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.1.2-i686-static.tar.xz' linux-ia32.tar.xz
# echo '  extracting'
# xzcat linux-ia32.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
# mv ../bin/ffmpeg ../bin/linux-ia32
# xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-ia32.LICENSE
# xzcat linux-ia32.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-ia32.README

# echo 'linux arm'
# echo '  downloading from johnvansickle.com'
# download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.1.2-armhf-static.tar.xz' linux-arm.tar.xz
# echo '  extracting'
# xzcat linux-arm.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
# mv ../bin/ffmpeg ../bin/linux-arm
# xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm.LICENSE
# xzcat linux-arm.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm.README

# echo 'linux arm64'
# echo '  downloading from johnvansickle.com'
# download 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-5.1.2-arm64-static.tar.xz' linux-arm64.tar.xz
# echo '  extracting'
# xzcat linux-arm64.tar.xz | $tar_exec -x -C ../bin --strip-components 1 --wildcards '*/ffmpeg'
# mv ../bin/ffmpeg ../bin/linux-arm64
# xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/GPLv3.txt' >../bin/linux-arm64.LICENSE
# xzcat linux-arm64.tar.xz | $tar_exec -x --ignore-case --wildcards -O '**/readme.txt' >../bin/linux-arm64.README

echo 'darwin x64'
echo '  downloading from evermeet.cx'
download $(curl 'https://evermeet.cx/ffmpeg/info/ffmpeg/5.1.2' -sfL | jq -rc '.download.zip.url') darwin-x64.zip
echo '  extracting'
unzip -o -d ../bin -j darwin-x64.zip ffmpeg
mv ../bin/ffmpeg ../bin/darwin-x64
curl -sf -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n5.1.2:/LICENSE.md'  -o ../bin/darwin-x64.LICENSE
curl -sf -L 'https://evermeet.cx/ffmpeg/info/ffmpeg/5.1.2' | jq --tab '.' >../bin/darwin-x64.README

# echo 'darwin arm64'
# echo '  downloading from osxexperts.net'
# download 'https://www.osxexperts.net/FFmpeg512ARM.zip' darwin-arm64.zip
# echo '  extracting'
# unzip -o -d ../bin -j darwin-arm64.zip ffmpeg
# mv ../bin/ffmpeg ../bin/darwin-arm64
# curl -sf -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n5.1.2:/LICENSE.md'  -o ../bin/darwin-arm64.LICENSE
# curl -sf -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n5.1.2:/README.md'  -o ../bin/darwin-arm64.README

# echo 'freebsd x64'
# echo '  downloading from github.com/Thefrank/ffmpeg-static-freebsd'
# download 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v5.1.2/ffmpeg' ../bin/freebsd-x64
# chmod +x ../bin/freebsd-x64
# curl -sf -L 'https://github.com/Thefrank/ffmpeg-static-freebsd/releases/download/v5.1.2/GPLv3.LICENSE' -o ../bin/freebsd-x64.LICENSE
# curl -sf -L 'https://git.ffmpeg.org/gitweb/ffmpeg.git/blob_plain/n5.1.2:/README.md' -o ../bin/freebsd-x64.README
