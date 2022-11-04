#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
SVNDIR=$SCRIPT_DIR/ttssh2
GITDIR=$SCRIPT_DIR/gitdir

mkdir -p $GITDIR
cd       $GITDIR

/usr/local/svn2git/svn-all-fast-export \
    --rules /workdir/conf/input.rules \
    --add-metadata \
    --svn-branches \
    --debug-rules \
    --svn-ignore \
    --empty-dirs \
    $SVNDIR
