#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.org
DST_REPO=$WORKDIR/ttssh2
FILES=$(cat $SCRIPT_DIR/exclude-files.txt)
rm -rf $DST_REPO
svnadmin create $DST_REPO
svnadmin dump $SRC_REPO  | \
    svndumpfilter exclude \
        "･ｳ･ﾔ｡ｼ ｡ﾁ ttpdlg.rc" \
        "/Attic" \
        $FILES \
        | \
    svnadmin load $DST_REPO
