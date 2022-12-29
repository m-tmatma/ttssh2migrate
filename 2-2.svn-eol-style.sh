#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

QUIET=
if [ x"$CI" = x"true" ]; then
    QUIET=--quiet
fi

WORKDIR=$SCRIPT_DIR/workdir
DST_REPO=$WORKDIR/ttssh2
svn co file://$DST_REPO $WORKDIR/svnwork
cd $WORKDIR/svnwork
find -name "*.c" -or -name "*.h" -or  -name "*.cpp" | xargs svn propset svn:eol-style native
svn commit -m "svn:eol-style native"
