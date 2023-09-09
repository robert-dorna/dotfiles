#!/usr/bin/env bash

# TODO: passwords in command-line are unsafe, should check better approach

script_name="d-extract-apk.sh"

usage="""Extract universal .apk from .aab or .apks file using bundletool.\n
\nusage:\n
\t$script_name --rebuild\n
\t$script_name <apks_file>\n
\t$script_name <aab_file> <keystore_file> <password>\n
\nnote:\n
\t1. This script assumes that <keystore_file> has the same name as the ks-key-alias, plus '-key.keystore'.\n
\tGiven a <keystore_file> 'myapp-upload-local-key.keystore', the alias for that key has to be 'myapp-upload-local'\n
\t(and vice-versa).\n
\n
\t2. Output will be in the same location as <apks_file> or <aab_file>.
"""

function check_docker_image() {
  # TODO: implement this
  docker_image_available="yes"
}

function rebuild_docker_image() {
  echo "$script_name: rebuiliding docker image..."
  docker build \
    -t ubuntu-bundletool \
    -f "$HOME/Projects/dotfiles/dockerfiles/bundletool.Dockerfile" \
    .  # maybe I should have some special place for building those cuz .e.g this is a security vuln? 
  echo "$script_name: rebuiliding docker image... done"
}

if [ "$1" = "--rebuild" ]; then
  rebuild_docker_image
  exit 0
elif [ "$1" = "" ]; then
  echo -e $usage
  exit 1
fi

file_full="$(realpath $1)"
file_dir="$(dirname $file_full)"
file_name_ext="$(basename $file_full)"
file_ext=".aab" # TODO: extract this
file_name="${file_name_ext%$file_ext}"

if [ "$file_ext" = ".aab" ]; then
  check_docker_image
  if [ "$docker_image_available" != "yes" ]; then
    rebuild_docker_image
  fi

  keystore_full="$(realpath $2)"
  keystore_dir="$(dirname $keystore_full)"
  keystore_name_ext="$(basename $keystore_full)"

  keystore_alias="${keystore_name_ext%-key.keystore}"
  keystore_password="$3"

  # TODO: check that "$2" contains "-key.keystore"
  if [ "$2" = "" ] || ! [ -f "$2" ] || [ "$3" = "" ]; then
    echo -e $usage
    exit 3
  fi

  # --connected-device instead of --mode universal is a nice alternative
  # but prob will not work now as e.g. adb is not inside docker
  # btw. nix bundletool does not work cuz of some aapt error but there is a
  # --aapt2 flag that can override path to it so maybe docker image is unnecessary/overkill
  # (aapt2 is in ~/Android/Sdk/...)
  docker run --rm \
    --mount type=bind,src="$file_dir",target=/src \
    --mount type=bind,src="$keystore_dir",target=/keystore \
    ubuntu-bundletool \
    java -jar /bundletool-all-1.14.1.jar build-apks \
    --bundle "/src/$file_name.aab" --output "/src/$file_name.apks" --mode universal \
    --ks "/keystore/$keystore_name_ext" \
    --ks-key-alias "$keystore_alias" \
    --ks-pass "pass:$keystore_password"
fi

mv "$file_dir/$file_name.apks" "$file_dir/$file_name.zip"
unzip "$file_dir/$file_name.zip"
mv "$file_dir/$file_name.zip" "$file_dir/$file_name.apks"
