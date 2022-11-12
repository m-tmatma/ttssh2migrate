#!/bin/sh

DST_REPO=workdir/ttssh2
rm -rf $DST_REPO
svnadmin create --compatible-version 1.8 $DST_REPO
cat workdir/ttssh2.svndmp | \
    svndumpfilter exclude "･ｳ･ﾔ｡ｼ ｡ﾁ ttpdlg.rc" "/Attic" | \
    svnadmin load $DST_REPO
