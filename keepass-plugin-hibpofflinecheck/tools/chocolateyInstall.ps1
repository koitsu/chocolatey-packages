$ErrorActionPreference = 'Stop'

$packageName    = $env:ChocolateyPackageName
$packageSearch  = 'KeePass Password Safe'
$pluginFilename = 'HIBPOfflineCheck.plgx'

try {
  # Search the registry for the directory/path KeePass was installed into
  $regPath = Get-ItemProperty -Path @('HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                      'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*',
                                      'HKCU:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*') `
                              -ErrorAction:SilentlyContinue `
             | Where-Object { $_.DisplayName -like "$packageSearch*" -and `
                              $_.DisplayVersion -ge 2.42 -and `
                              $_.DisplayVersion -lt 3.0 } `
             | ForEach-Object { $_.InstallLocation }

  if ( -not $regPath ) {
    throw "A KeePass 2.42 or newer installation could not be found in the registry."
  }

  $pluginsDir = Join-Path $regPath 'Plugins'

  if ( -not ( Test-Path -Path $pluginsDir ) ) {
    throw "Abnormal KeePass installation detected (lacks a Plugins directory)."
  }

  $toolsPath = Split-Path -parent $MyInvocation.MyCommand.Definition
  $pluginFilePath = Join-Path $toolsPath $pluginFilename

  Copy-Item $pluginFilePath -Destination $pluginsDir

  if ( Get-Process -Name 'KeePass' -ErrorAction SilentlyContinue ) {
    Write-Warning "KeePass is currently running. Please restart KeePass to load the plugin."
  } else {
    Write-Output "Plugin $($packageName) will be loaded the next time KeePass is started."
    Write-Output "Please note this plugin may require additional configuration. Look for a new entry in the KeePass Tools menu."
  }
} catch {
  throw $_.Exception
}
