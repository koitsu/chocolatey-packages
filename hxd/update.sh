#!/usr/bin/env bash
set -e
shopt -s expand_aliases

t1=$(mktemp)

curl -s -S -o "${t1}" 'https://mh-nexus.de/updates/HxDCurrentVersion.json'

version=$(cat "${t1}" | jq -r '.Version')
zipurl=$(cat "${t1}" | jq -r '."Download-URI"')
zipfile=$(basename "${zipurl}")

# XXX debug
# cat ${t1} | jq .

rm -f "${t1}"

# Fetch zipurl per JSON, and put it in tools/ directory

curl -s -S --output-dir tools/ -O "${zipurl}"

case "$(uname -s)" in
  Linux|CYGWIN*|MINGW*)
    alias sed="sed -i"
    checksum=$(sha512sum "tools/${zipfile}" | awk '{ print $1 }' | tr 'a-f' 'A-F')
    ;;
  FreeBSD)
    alias sed="sed -i ''"
    checksum=$(sha512 "tools/${zipfile}" | awk '{ print $NF }' | tr 'a-f' 'A-F')
    ;;
  *) echo "ERROR: Unknown platform for sha512 checksum utility" ; exit 1
esac

echo "Latest release details:"
echo "version:  $version"
echo "zipurl:   $zipurl"
echo "zipfile:  $zipfile"
echo "checksum: $checksum"
echo

nuspec="hxd.nuspec"
verification="tools/VERIFICATION.txt"
install_ps1="tools/chocolateyInstall.ps1"

# Update nuspec with new version parameter

sed -r \
  -e "/<version>/ s|>.+<|>${version}<|" \
  "${nuspec}"

# Update tools/VERIFICATION.txt with new checksum

sed -r \
  -e "/SHA-512:/ s|SHA-512:.+|SHA-512: ${checksum}|" \
  "${verification}"

git status
git --no-pager diff
