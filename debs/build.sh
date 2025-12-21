# !/bin/bash

rm -rf dists
rm -rf packages-*.db

(
  mkdir -p dists/trixie/main/binary-amd64
  mkdir -p dists/trixie/main/source
) && (
  find . -name "Contents-amd64.*" -or -name "Packages" -or -name "Packages.*" -delete
) && (
  apt-ftparchive generate -c=aptftp.conf aptgenerate.conf
) && (
  apt-ftparchive release -c=aptftp.conf dists/trixie >dists/trixie/Release
) && (
  rm -f dists/trixie/Release.gpg dists/trixie/InRelease
) && (
  gpg --clearsign -o dists/trixie/InRelease dists/trixie/Release
) && (
  gpg -abs -o dists/trixie/Release.gpg dists/trixie/Release
) && (
  echo OK
)
