const os = require('os')
const util = require('util')
const child_process = require('child_process')
const fs = require('fs')

function execCommand(command) {
  try {
    child_process.execSync(command)
  } catch (error) {
    console.error(`${command} command failed with error:${error}`)
    process.exit(1)
  }
}

function download(src, dest) {
  execCommand(`curl -L -# -A 'https://github.com/eugeneware/ffmpeg-static' -o ${dest} ${src}`)
}

function tarCommand(params) {
  var tar_command
  try {
    tar_command = child_process.execSync('command -v gtar')
  } catch (error) {
    tar_command = child_process.execSync('command -v tar')
  }
  execCommand(tar_command.toString().trim() + ' ' + params)
}

var download_urls = {
  'win32': {
    'x64': 'https://ffmpeg.zeranoe.com/builds/win64/static/ffmpeg-latest-win64-static.zip',
    'ia32': 'https://ffmpeg.zeranoe.com/builds/win32/static/ffmpeg-latest-win32-static.zip'
  },
  'linux': {
    'x64': 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz',
    'ia32': 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-i686-static.tar.xz',
    'arm': 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-armhf-static.tar.xz',
    'arm64': 'https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-arm64-static.tar.xz'
  },
  'darwin': {
    'x64': 'https://evermeet.cx/ffmpeg/getrelease'
  }
}

const platform = os.platform()
const arch = os.arch()

if (!(platform in download_urls)) {
  console.error('Unsupported platform.', platform)
  process.exit(1)
}

if (!(arch in download_urls[platform])) {
  console.error('Unsupported architecture.', platform)
  process.exit(1)
}

process.chdir(__dirname)

switch (platform) {
  case 'win32':
    console.log(platform, arch)
    console.log('  downloading from ffmpeg.zeranoe.com')
    download(download_urls[platform][arch], 'ffmpeg-static.zip')
    console.log('  extracting')
    execCommand(`unzip -o -d ../bin/win32/${arch} -j ffmpeg-static.zip **/ffmpeg.exe`)
    fs.unlinkSync('ffmpeg-static.zip')
    break
  case 'linux':
    console.log(platform, arch)
    console.log('  downloading from johnvansickle.com')
    download(download_urls[platform][arch], 'ffmpeg-static.tar.xz')
    console.log('  extracting')
    tarCommand(`-xJ -C ../bin/linux/${arch} --strip-components 1 -f ffmpeg-static.tar.xz --wildcards '*/ffmpeg'`)
    fs.unlinkSync('ffmpeg-static.tar.xz')
    break
  case 'darwin':
    console.log(platform, arch)
    console.log('  downloading from evermeet.cx')
    download(download_urls[platform][arch], 'ffmpeg-static.7z')
    execCommand('7zr e -y -bd -o../bin/darwin/x64 ffmpeg-static.7z')
    fs.unlinkSync('ffmpeg-static.7z')
    break
}
