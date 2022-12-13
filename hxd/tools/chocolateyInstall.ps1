$ErrorActionPreference = 'Stop'

$packageName = $env:chocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

$packageArgs = @{
  packageName     = $packageName
  url             = 'https://mh-nexus.de/downloads/HxDSetup.zip'
  checksum        = '33714bf909de383b2df6c7b860634cad0f1c0f6954753076c417feddc1477f506bc887b1b867a9ca2945fe90e6fd0ca70bbf74a63999a818e394d60cff59df99'
  checksumType    = 'sha512'
  unzipLocation   = $unzipLocation
}

Install-ChocolateyZipPackage @packageArgs
Install-ChocolateyInstallPackage 'HxD' 'exe' '/silent' $setupLocation

Remove-Item $unzipLocation -Recurse
