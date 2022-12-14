$ErrorActionPreference = 'Stop'

$packageName = $env:chocolateyPackageName
$softwareName = 'HxD Hex Editor*'

[array]$key = Get-UninstallRegistryKey -SoftwareName $softwareName

if ($key.Count -eq 1) {
  $key | ForEach-Object {
    $packageArgs = @{
      packageName    = $packageName
      fileType       = 'exe'
      silentArgs     = '/VERYSILENT /SUPPRESSMSGBOXES /NORESTART'
      validExitCodes = @(0)
      file           = "$($_.UninstallString.Trim('"'))"
      softwareName   = $softwareName
    }
    Uninstall-ChocolateyPackage @packageArgs
  }
} elseif ($key.Count -eq 0) {
  Write-Warning "$packageName may have been uninstalled by other means"
} elseif ($key.Count -gt 1) {
  Write-Warning "$($key.Count) uninstaller registry keys found"
  Write-Warning "Please inform the package maintainer that the following keys were matched:"
  $key | ForEach-Object { Write-Warning "- $($_.DisplayName): $($_.InstallLocation)" }
  Write-Error "$packageName uninstallation failed"
}
