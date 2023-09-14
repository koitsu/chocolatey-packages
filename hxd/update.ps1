Import-Module AU

function global:au_BeforeUpdate {
  Get-RemoteFiles -Purge -NoSuffix -Algorithm $Latest.ChecksumType

  Write-Host "Get-RemoteFiles checksum: $($Latest.Checksum32)"
  Write-Host "Manifest checksum:        $($Latest.ManifestSHA512)"

  if ($Latest.Checksum32 -ine $Latest.ManifestSHA512) {
    throw 'HxD manifest checksum and downloaded file checksum do not match!'
  }
}

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$($Latest.URL32)>"
      "(?i)(\s*Software.*)\<.*\>"         = "`${1}<$($Latest.URL32)>"
      "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType)"
      "(?i)(^\s*checksum\:).*"            = "`${1} $($Latest.Checksum32)"
    }
  }
}

# HxD JSON manifest format: https://forum.mh-nexus.de/viewtopic.php?f=7&t=1212

function global:au_GetLatest {
  $ManifestUrl = 'https://mh-nexus.de/updates/HxDCurrentVersion.json'

  $j = Invoke-WebRequest -Uri $ManifestUrl -UseBasicParsing | ConvertFrom-Json

  @{
    ChecksumType   = 'sha512'
    ManifestSHA512 = $j.'Unique-File-IDs'.'HxDSetup.zip'.'SHA-512'
    URL32          = $j.'Download-URI'.'*'
    Version        = $j.Version
  }
}

Update-Package -ChecksumFor none -NoReadme
