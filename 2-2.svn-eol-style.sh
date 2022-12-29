#!/bin/sh

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

QUIET=
if [ x"$CI" = x"true" ]; then
    QUIET=--quiet
fi

WORKDIR=$SCRIPT_DIR/workdir
DST_REPO=$WORKDIR/ttssh2
svn co file://$DST_REPO/trunk             $WORKDIR/svnwork/trunk
svn co file://$DST_REPO/branches/4-stable $WORKDIR/svnwork/4-stable

(cd $WORKDIR/svnwork/trunk    && find -name "*.c" -or -name "*.h" -or  -name "*.cpp" | xargs svn propset svn:eol-style native && svn commit -m "svn:eol-style native")
(cd $WORKDIR/svnwork/4-stable && find -name "*.c" -or -name "*.h" -or  -name "*.cpp" | xargs svn propset svn:eol-style native && svn commit -m "svn:eol-style native")