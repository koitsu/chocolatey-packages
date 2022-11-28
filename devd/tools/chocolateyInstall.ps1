# Based on sources:
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/sysinternals/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/curl/tools/chocolateyInstall.ps1
# https://github.com/chocolatey-community/chocolatey-packages/blob/master/automatic/wget/tools/chocolateyinstall.ps1

$ErrorActionPreference = 'Stop'

$packageName = $env:chocolateyPackageName
$installDir = Split-Path $MyInvocation.MyCommand.Definition

Write-Host "$packageName is going to be installed in: $installDir"

$packageArgs = @{
  packageName     = $packageName
  url             = 'https://github.com/cortesi/devd/releases/download/v0.9/devd-0.9-windows32.zip'
  checksum        = 'd2241c27f1a23829bdf068ddaf30dda74d7d763c6782d67067fcb6b39f524d37'
  url64bit        = 'https://github.com/cortesi/devd/releases/download/v0.9/devd-0.9-windows64.zip'
  checksum64      = '650575ac95228dd62fd3bb8a42d640daa476c23ae3bc58ac1ba8931e26096aa2'
  checksumType    = 'sha256'
  unzipLocation   = $installDir
}

Install-ChocolateyZipPackage @packageArgs

