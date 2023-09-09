Import-Module AU

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(^\s*location on\:?\s*)\<.*\>" = "`${1}<$($Latest.ReleaseUrl)>"
      "(?i)(\s*32\-Bit Software.*)\<.*\>" = "`${1}<$($Latest.URL32)>"
      "(?i)(\s*64\-Bit Software.*)\<.*\>" = "`${1}<$($Latest.URL64)>"
      "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType32)"
      "(?i)(^\s*checksum(32)?\:).*"       = "`${1} $($Latest.Checksum32)"
      "(?i)(^\s*checksum(64)?\:).*"       = "`${1} $($Latest.Checksum64)"
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*fileFullPath\s*=\s*`"[$]toolsDir\\).*"   = "`${1}$($Latest.FileName32)`""
      "(?i)(^\s*fileFullPath64\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName64)`""
    }
    "$($Latest.PackageName).nuspec" = @{
      "(\<releaseNotes\>).*?(\</releaseNotes\>)" = "`${1}$($Latest.ReleaseUrl)`${2}"
    }
  }
}

function global:au_GetLatest {
  $LatestRelease = Get-GitHubRelease -OwnerName cortesi -RepositoryName devd -Latest

  @{
    URL32         = $LatestRelease.assets | Where-Object { $_.name -match '-windows32\.zip$' } | Select-Object -ExpandProperty browser_download_url
    URL64         = $LatestRelease.assets | Where-Object { $_.name -match '-windows64\.zip$' } | Select-Object -ExpandProperty browser_download_url
    Version       = $LatestRelease.tag_name.TrimStart("v")
    ReleaseUrl    = $LatestRelease.html_url
  }
}

Update-Package -ChecksumFor none -NoReadme
