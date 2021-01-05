#!/bin/bash

# ヒラギノフォントのシンボリックリンクを貼る。
# 2020/09/25

LINK_DIR=/cygdrive/c/texlive/texmf-local/fonts/opentype/hiragino
TARGET_DIR=/cygdrive/c/Windows/Fonts
TARGET_DIR_WIN=c:\\Windows\\Fonts

MKLINK="cmd /c mklink"

# ファイル名変換リストcsvの改行コード変更
IN_FILE=$1
IN_FILE2="${IN_FILE%.*}-unix.csv"
echo $IN_FILE to $IN_FILE2
nkf -w -d $IN_FILE > $IN_FILE2

# シンボリックリンク張る先のフォルダに移動
NOW_DIR=$(pwd)
echo cd $LINK_DIR
cd $LINK_DIR

while IFS=, read LINK_FILEnoSUF TARGET_FILE
do
    LINK_FILE=${LINK_FILEnoSUF}.otf
    # 既にシンボリックリンクファイルがあったら消す
    if [ -f ${LINK_FILE} ];then
        echo rm -v ${LINK_FILE}
        rm -v ${LINK_FILE}
    fi
    # フォントインストールしてたらシンボリックリンク実行
    # 一々確認してリストファイル作る手間が減るかも。
    if [ -f "${TARGET_DIR}/${TARGET_FILE}" ];then
#        echo ${TARGET_DIR}/${TARGET_FILE} exist
        echo $MKLINK "\"${LINK_FILE}\" \"${TARGET_DIR_WIN}\\${TARGET_FILE}\""
        eval $MKLINK "\"${LINK_FILE}\" \"${TARGET_DIR_WIN}\\${TARGET_FILE}\""
    fi
    
done < ${NOW_DIR}/${IN_FILE2}
