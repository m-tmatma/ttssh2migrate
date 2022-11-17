#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKDIR=$SCRIPT_DIR/workdir
SVNDIR=$WORKDIR/ttssh2
GITDIR=$WORKDIR/gitdir

rm   -rf $GITDIR
mkdir -p $GITDIR
cd       $GITDIR

svn-all-fast-export \
    --rules $SCRIPT_DIR/input.rules \
    --add-metadata \
    --svn-branches \
    --debug-rules \
    --svn-ignore \
    --empty-dirs \
    $SVNDIR
