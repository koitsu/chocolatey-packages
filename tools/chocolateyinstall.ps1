$ErrorActionPreference = 'Stop';

$checksum32 = 'B76416EEB86C226654F425151370801D1C51182A90DE1DCB8DB1BCA0F5758A999F1FE18303EABEAF789B4E62F54E1181262D4DE623DED89481F9E32CC8F70FA9'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipLocation   = Join-Path $toolsDir 'HxDSetup.zip'
$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

Get-ChecksumValid -File $zipLocation -Checksum $checksum32 -ChecksumType 'sha512'

Get-ChocolateyUnzip $zipLocation $unzipLocation
Install-ChocolateyInstallPackage 'HxD' 'exe' '/silent' $setupLocation

Remove-Item $unzipLocation -Recurse
