$ErrorActionPreference = 'Stop'

$packageName = $env:ChocolateyPackageName
$packageSearch = 'KeePass Password Safe'
$pluginFilename = 'HIBPOfflineCheck.plgx'

try {
  # Search the registry for the directory/path KeePass was installed into
  $regPath = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                      'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                      'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
                              -ErrorAction:SilentlyContinue `
             | Where-Object { $_.DisplayName -like "$packageSearch*" } `
             | ForEach-Object { $_.InstallLocation }

  if ( -not $regPath ) {
    throw "A KeePass installation could not be found in the registry."
  }

  $pluginsDir = Join-Path $regPath 'Plugins'

  if (-not ( Test-Path -Path $pluginsDir ) ) {
    throw "Abnormal KeePass installation detected (lacks a Plugins directory)."
  }

  $pluginFilePath = Join-Path $pluginsDir $pluginFilename

  Remove-Item -Path $pluginFilePath -Force -ErrorAction Continue

  if ( Get-Process -Name 'KeePass' -ErrorAction SilentlyContinue ) {
    Write-Warning "KeePass is currently running. Please restart KeePass to unload the plugin."
  }
} catch {
  throw $_.Exception
}
