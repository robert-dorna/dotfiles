#!/usr/bin/env bash

URL="https://channels.nixos.org/nixos-23.05"
ISO="latest-nixos-minimal-x86_64-linux.iso"
SHA="latest-nixos-minimal-x86_64-linux.iso.sha256"

echo "[1/4] downloading .iso ..."
wget "$URL/$ISO"
echo "[1/4] downloading .iso ... done"

echo "[2/4] downloading .iso.sha256 ..."
wget "$URL/$SHA"
echo "[2/4] downloading .iso.sha256 ... done"

echo "[3/4] renaming files ..."
ISO_CORRECT="$(cat $SHA | awk "{print \$2}")"
SHA_CORRECT="${ISO_CORRECT}.sha256"
mv "$ISO" "$ISO_CORRECT"
mv "$SHA" "$SHA_CORRECT"
echo "[3/4] renaming files ... done"

echo "[4/4] checking checksum ..."
sha256sum --check $SHA_CORRECT
echo "[4/4] checking checksum ... done"
