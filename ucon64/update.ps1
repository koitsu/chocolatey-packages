Import-Module AU

$releases = 'https://sourceforge.net/projects/ucon64/files/ucon64/'

function global:au_BeforeUpdate { Get-RemoteFiles -Purge -NoSuffix }

function global:au_SearchReplace {
  @{
    ".\legal\VERIFICATION.txt" = @{
      "(?i)(\s*32-Bit Software.*)\<.*\>"  = "`${1}<$($Latest.URL32)>"
      "(?i)(^\s*checksum\s*type\:).*"     = "`${1} $($Latest.ChecksumType32)"
      "(?i)(^\s*checksum(32)?\:).*"       = "`${1} $($Latest.Checksum32)"
    }
    ".\tools\chocolateyInstall.ps1" = @{
      "(?i)(^\s*fileFullPath\s*=\s*`"[$]toolsDir\\).*" = "`${1}$($Latest.FileName32)`""
    }
  }
}

function global:au_GetLatest {
  $content = Invoke-WebRequest -Uri $releases -UseBasicParsing

  $latest = $content.Links.Href `
            | Where-Object { $_ -Match '/ucon64/ucon64-([0-9\.]+)/$' } `
            | ForEach-Object { $Matches[1] } `
            | Sort-Object -Descending { $_ -As [version] } `
            | Select-Object -First 1

  @{
    URL32   = 'https://sourceforge.net/projects/ucon64/files/ucon64/ucon64-' + $latest + '/ucon64-' + $latest + '-win32-vc-bin.zip'
    Version = $latest.TrimStart("v")
  }
}

Update-Package -ChecksumFor none -NoReadme

