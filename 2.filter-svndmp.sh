#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.org
DST_REPO=$WORKDIR/ttssh2
rm -rf $DST_REPO
svnadmin create $DST_REPO
svnadmin dump -q $SRC_REPO  | \
    svndumpfilter exclude \
        "/Attic" \
        | \
    svndumpfilter exclude \
        --pattern "* ttpdlg.rc" \
        --pattern "*.plg" \
        --pattern "*.opt" \
        --pattern "*.ncb" \
        --pattern "*.res" \
        --pattern "*.user" \
        --pattern "*.aps" \
        --pattern "*.pch" \
        --pattern "*.suo" \
        --pattern "*.sbr" \
        | \
    svnadmin load -q $DST_REPO
