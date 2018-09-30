$ErrorActionPreference = 'Stop';

$packageName = 'HxD'
$registryUninstallerKeyName = 'HxD_is1'

$local_key       = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName"
$local_key6432   = "HKCU:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName"
$machine_key     = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName"
$machine_key6432 = "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\$registryUninstallerKeyName"

$file = @($local_key, $local_key6432, $machine_key, $machine_key6432) `
	| ?{ Test-Path $_ } `
	| Get-ItemProperty `
	| Select-Object -ExpandProperty UninstallString

if (($null -eq $file) -or ($file -eq '')) {
	Write-Host "$packageName has already been uninstalled by other means."
	Write-Host 'The registry uninstall entry does not exist (anymore).'
}
else {
	$installerType = 'EXE'
	$silentArgs = '/verysilent'
	$validExitCodes = @(0)

	Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $file
}