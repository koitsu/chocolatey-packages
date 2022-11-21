#!/usr/bin/env bash
set -e
shopt -s expand_aliases

# https://docs.github.com/en/rest/releases/releases#get-the-latest-release

t1=$(mktemp)
curl -s -S \
  -o "${t1}" \
  -A 'koitsu' \
  -H 'Accept: application/vnd.github+json' \
  'https://api.github.com/repos/freem/asm6f/releases/latest'

zipurl=$(cat "${t1}" | jq -r '.assets[] | select(.name | endswith(".zip")) | .browser_download_url')
tag_name=$(cat "${t1}" | jq -r '.tag_name')
version_str=$(echo "${tag_name}" | cut -d'_' -f1)
version_num=${version_str/v/}
build=$(basename "${zipurl}" | cut -d'_' -f2)
build=${build%%.zip}

# XXX debug
# cat ${t1} | jq .

rm -f "${t1}"

case "$(uname -s)" in
  Linux|MINGW*)
    alias sed="sed -i"
    checksum=$(curl -s -L -o- "${zipurl}" | sha256sum | awk '{ print $1 }')
    ;;
  FreeBSD)
    alias sed="sed -i ''"
    checksum=$(curl -s -L -o- "${zipurl}" | sha256)
    ;;
  *) echo "ERROR: Unknown platform for sha256 checksum utility" ; exit 1
esac

echo "Latest release details:"
echo "tag_name: $tag_name"
echo "version_str: $version_str"
echo "version_num: $version_num"
echo "zipurl:   $zipurl"
echo "build:    $build"
echo "checksum: $checksum"
echo

nuspec="asm6f.nuspec"
install_ps1="tools/chocolateyInstall.ps1"

# Update nuspec with new version parameters

sed -r \
  -e "/<version>/ s|>.+<|>${version_num}.${build}<|" \
  "${nuspec}"

# Update chocolateyInstall.ps1 with new url and checksum

sed -r \
  -e "/url[[:space:]]*=/      s|'.+'|'${zipurl}'|" \
  -e "/checksum[[:space:]]*=/ s|'.+'|'${checksum}'|" \
  "${install_ps1}"

git status
git --no-pager diff
