$ErrorActionPreference = 'Stop';

$checksum32 = '3524320C54AFA4AA597913011F2A650DFABACE924664072A26FAC3A10462895CC26D14474908F0F64AFC2CB634DBCB29F1B37316641AB56110AE2C7E0C370F8A'

$toolsDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

$zipLocation   = Join-Path $toolsDir 'HxDSetup.zip'
$unzipLocation = Join-Path $toolsDir 'HxDSetup'
$setupLocation = Join-Path $unzipLocation 'HxDSetup.exe'

Get-ChecksumValid -File $zipLocation -Checksum $checksum32 -ChecksumType 'sha512'

Get-ChocolateyUnzip $zipLocation $unzipLocation
Install-ChocolateyInstallPackage 'HxD' 'exe' '/silent' $setupLocation

Remove-Item $unzipLocation -Recurse
