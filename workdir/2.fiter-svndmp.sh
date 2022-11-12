#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

SRC_REPO=ttssh2.org
DST_REPO=ttssh2
FILES=$(cat exclude-files.txt)
rm -rf $DST_REPO
svnadmin create --compatible-version 1.8 $DST_REPO
svnadmin dump $SRC_REPO  | \
    svndumpfilter exclude \
        "･ｳ･ﾔ｡ｼ ｡ﾁ ttpdlg.rc" \
        "/Attic" \
        $FILES \
        | \
    svnadmin load $DST_REPO
