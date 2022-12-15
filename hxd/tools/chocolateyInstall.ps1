$ErrorActionPreference = 'Stop'

if ($env:chocolateyForceX86 -eq 'true') {
  $err = ("This package does not support --x86/--force86. The installer" +
  " chooses which to install depending on OS architecture. It cannot be" +
  " overridden using this flag.")
  Write-Error $err
}

$packageName = $env:chocolateyPackageName
$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

$packageArgs = @{
  packageName     = $packageName
  url             = 'https://mh-nexus.de/downloads/HxDSetup.zip'
  checksum        = 'ea97d98877342d725adcbfa075d5d5770470cf4a1d79477d577d299b6298d62f9a7fec8903633f8adcda7d306bff848751f8c788b611cc2d1074624a9153bc49'
  checksumType    = 'sha512'
  unzipLocation   = $unzipLocation
}

Install-ChocolateyZipPackage @packageArgs

$packageArgs = @{
  packageName     = $packageName
  fileType        = 'exe'
  file            = $setupLocation
  silentArgs      = '/VERYSILENT /NORESTART'
  validExitCodes = @(0)
}

Install-ChocolateyInstallPackage @packageArgs

Remove-Item $unzipLocation -Recurse
