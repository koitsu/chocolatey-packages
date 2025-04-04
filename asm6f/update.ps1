Import-Module AU

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUrl)>"
      "(?i)(\s*Software.*)\<.*\>"         = "`${1}<$($Latest.URL32)>"
      "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType32)"
      "(?i)(^\s*checksum\:).*"            = "`${1} $($Latest.Checksum32)"
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*fileFullPath\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
    }
    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseUrl)`${2}"
    }
  }
}

function global:au_GetLatest {
  $LatestRelease = Get-GitHubRelease -OwnerName freem -RepositoryName asm6f -Latest

  $asset       = $LatestRelease.assets | Where-Object { $_.name -match '^asm6f_v\d+_.*\.zip$' }
  $downloadUrl = $asset | Select-Object -ExpandProperty browser_download_url
  $fileName    = $asset | Select-Object -ExpandProperty name
  $majorMinor  = $LatestRelease.tag_name.TrimStart("v") -Split '_' | Select-Object -First 1
  $buildDate   = $fileName -Replace "^asm6f_v\d+_(\d+).*", '$1'

  @{
    URL32      = $downloadUrl
    Version    = $majorMinor + '.' + $buildDate
    ReleaseUrl = $LatestRelease.html_url
  }
}

Update-Package -ChecksumFor none -NoReadme
