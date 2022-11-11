# Based on sources:
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/sysinternals/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/curl/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/wget/tools/chocolateyinstall.ps1

if ((Get-OSArchitectureWidth 32) -or $env:chocolateyForceX86 -eq 'true') {
  throw 'x86 architecture detected. SuperFamiconv binaries are only available for 64-bit systems.'
}

$toolsPath = Split-Path $MyInvocation.MyCommand.Definition
$pp = Get-PackageParameters
$installDir = $toolsPath

if ($pp.InstallDir -or $pp.InstallationPath) {
  $InstallDir = $pp.InstallDir + $pp.InstallationPath
}

Write-Host "SuperFamiconv is going to be installed in: $installDir"

$packageArgs = @{
  packageName     = $env:chocolateyPackageName
  url             = 'https://github.com/Optiroc/SuperFamiconv/releases/download/v0.9.2/SuperFamiconv-v0.9.2-win_x64.zip'
  checksum64      = 'd8e3ebcacda5092dd39a54d73ebbccac1e590cabef2cdc4bd0721cf1b58908c7'
  checksumType64  = 'sha256'
  unzipLocation   = $installDir
}

Install-ChocolateyZipPackage @packageArgs

