$ErrorActionPreference = 'Stop';

$checksum32 = 'D2C58C3CED7D12F0DADAA20723D0C1B34167BB6EE6292DEB8D9921F8DC711964778348059EFD653BBAC05AB3277C90350B7DA9DE4FFB82D8683494A98D87C137'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipLocation   = Join-Path $toolsDir 'HxDSetup.zip'
$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

Get-ChecksumValid -File $zipLocation -Checksum $checksum32 -ChecksumType 'sha512'

Get-ChocolateyUnzip $zipLocation $unzipLocation
Install-ChocolateyInstallPackage 'HxD' 'exe' '/silent' $setupLocation

Remove-Item $unzipLocation -Recurse
