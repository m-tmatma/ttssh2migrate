#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

SRC_REPO=ttssh2.org
DST_REPO=ttssh2
rm -rf $DST_REPO
svnadmin create --compatible-version 1.8 $DST_REPO
svnadmin dump $SRC_REPO  | \
    svndumpfilter exclude \
        "･ｳ･ﾔ｡ｼ ｡ﾁ ttpdlg.rc" \
        "/Attic" \
        TTProxy.aps \
        TTProxy.ncb \
        TTProxy.vcproj.SAI.yutaka.user \
        cygterm.res \
        ttermpro.aps \
        ttermpro.ncb \
        ttermpro.pch \
        ttpcmn.pch \
        ttpdlg.aps \
        ttpdlg.pch \
        ttpfile.pch \
        ttpmacro.pch \
        ttpmenu.ncb \
        ttpset.pch \
        ttptek.pch \
        ttssh.aps \
        ttssh.ncb \
        ttssh.opt \
        ttxkanjimenu.aps \
        ttxssh.aps \
        | \
    svnadmin load $DST_REPO
