#!/usr/bin/env bash
set -e

# https://docs.github.com/en/rest/releases/releases#get-the-latest-release

t1=$(mktemp)
curl -s -S \
  -o "${t1}" \
  -A 'koitsu' \
  -H 'Accept: application/vnd.github+json' \
  'https://api.github.com/repos/JanisEst/KeePassQRCodeView/releases/latest'

plgxurl=$(cat "${t1}" | jq -r '.assets[] | select(.name | endswith(".plgx")) | .browser_download_url')
version_str=$(cat "${t1}" | jq -r '.tag_name')
version_num=${version_str/v/}

# XXX debug
# cat ${t1} | jq .

rm -f "${t1}"

case "$(uname -s)" in
  Linux)   checksum=$(curl -s -L -o- "${plgxurl}" | sha256sum | awk '{ print $1 }') ;;
  FreeBSD) checksum=$(curl -s -L -o- "${plgxurl}" | sha256) ;;
  *)       echo "ERROR: Unknown platform for sha256 checksum utility" ; exit 1
esac

echo "Latest release details:"
echo "version_str: $version_str"
echo "version_num: $version_num"
echo "plgxurl:     $plgxurl"
echo "checksum:    $checksum"
echo

license_url="https://github.com/JanisEst/KeePassQRCodeView/blob/${version_str}/LICENSE"
docs_url="https://github.com/JanisEst/KeePassQRCodeView/blob/${version_str}/README.md"

nuspec="keepass-plugin-keepassqrcodeview.nuspec"
install_ps1="tools/chocolateyInstall.ps1"

# Update nuspec with new licenseUrl, docsUrl, and version parameters

sed -i '' -r \
  -e "/<licenseUrl>/ s|>.+<|>${license_url}<|" \
  -e "/<docsUrl>/    s|>.+<|>${docs_url}<|" \
  -e "/<version>/    s|>.+<|>${version_num}<|" \
  "${nuspec}"

# Update chocolateyInstall.ps1 with new url64bit and checksum64

sed -i '' -r \
  -e "/\\\$url[[:space:]]*=/      s|'.+'|'${plgxurl}'|" \
  -e "/\\\$checksum[[:space:]]*=/ s|'.+'|'${checksum}'|" \
  "${install_ps1}"

git status
git --no-pager diff
