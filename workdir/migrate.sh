#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
SVNDIR=$SCRIPT_DIR/ttssh2
GITDIR=$SCRIPT_DIR/gitdir

rm   -rf $GITDIR
mkdir -p $GITDIR
cd       $GITDIR

svn-all-fast-export \
    --rules $SCRIPT_DIR/conf/input.rules \
    --add-metadata \
    --svn-branches \
    --debug-rules \
    --svn-ignore \
    --empty-dirs \
    $SVNDIR
