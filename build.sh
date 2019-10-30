#!/bin/bash

# Flashable Zip Builder
# Copyright (C) 2018-2019, VR25 @ xda-developers
# License: GPLv3+

echo
get_value() { sed -n "s/^$1=//p" module.prop; }
#set_value() { sed -i "s/^$1=.*/$1=$2/" module.prop; }
get_file_value() {
if [ -f "$1" ]; then
cat $1 | grep $2 | sed "s|.*${2}||" | sed 's|"||g'
fi
}

VER=$(grep "version=" module.prop | sed 's|.*=||' | sed 's|-.*||')
#VERCODE=$(grep "versionCode=" module.prop | sed 's|.*=||' | sed 's|-.*||')
MODID=$(grep "id=" module.prop | sed 's|.*=||' | sed 's|-.*||')

cd ${0%/*} 2>/dev/null

#version=$(grep '\*\*.*\(.*\)\*\*' README.md \
#  | head -n1 | sed 's/\*\*//; s/ .*//')

#versionCode=$(grep '\*\*.*\(.*\)\*\*' README.md \
#  | head -n1 | sed 's/\*\*//g; s/.* //' | tr -d ')' | tr -d '(')

#set_value version $version
#set_value versionCode $versionCode

mkdir -p _builds

if [[ ${1:-x} != f ]]; then
  echo "Downloading latest update-binary..."
  curl -#L https://raw.githubusercontent.com/topjohnwu/Magisk/master/scripts/module_installer.sh > _builds/update-binary \
    && mv -f _builds/update-binary META-INF/com/google/android/
fi

zip -r9v _builds/"$MODID-$VER".zip \
  * .gitattributes .gitignore \
  -x _\*/\* | grep .. && echo
