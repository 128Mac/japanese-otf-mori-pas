#!/bin/bash

# モリサワフォントのシンボリックリンクを貼る。
# 2020/09/22

LINK_DIR=/cygdrive/c/texlive/texmf-local/fonts/opentype/morisawa
TARGET_DIR=/cygdrive/c/Windows/Fonts
TARGET_DIR_WIN=c:\\Windows\\Fonts

MKLINK="cmd /c mklink"

# Fonts フォルダに移動
cd $TARGET_DIR

LINK_FILE=$(\ls A-OTF-*.otf)
#echo $LINK_FILE

# シンボリックリンク張る先のフォルダに移動
echo cd $LINK_DIR
cd $LINK_DIR


for file in $LINK_FILE;do
    if [ -f ${file} ];then
        echo rm -v ${file}
        rm -v ${file}
    fi
    echo $MKLINK ${file} ${TARGET_DIR_WIN}\\${file}
    $MKLINK ${file} ${TARGET_DIR_WIN}\\${file}
done
