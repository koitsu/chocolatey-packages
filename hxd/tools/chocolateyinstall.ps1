$ErrorActionPreference = 'Stop';

$checksum32 = 'EA97D98877342D725ADCBFA075D5D5770470CF4A1D79477D577D299B6298D62F9A7FEC8903633F8ADCDA7D306BFF848751F8C788B611CC2D1074624A9153BC49'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipLocation   = Join-Path $toolsDir 'HxDSetup.zip'
$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

Get-ChecksumValid -File $zipLocation -Checksum $checksum32 -ChecksumType 'sha512'

Get-ChocolateyUnzip $zipLocation $unzipLocation
Install-ChocolateyInstallPackage 'HxD' 'exe' '/silent' $setupLocation

Remove-Item $unzipLocation -Recurse
