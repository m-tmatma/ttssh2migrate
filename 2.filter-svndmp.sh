#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

QUIET=
if [ x"$CI" = x"true" ]; then
    QUIET=--quiet
fi

WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.org
DST_REPO=$WORKDIR/ttssh2
rm -rf $DST_REPO
mkdir -p $WORKDIR

svnadmin create $DST_REPO
svnadmin dump $QUIET $SRC_REPO  | \
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
    svnadmin load $QUIET $DST_REPO

# change parent directory of $DST_REPO and archive it.
(cd $DST_REPO/.. && tar cfz $WORKDIR/ttssh2-svn-2-filtered.tar.gz $(basename $DST_REPO) )
