#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKDIR=$SCRIPT_DIR/workdir
SVN_ROOT=$WORKDIR/ttssh2
GIT_ROOT=$WORKDIR/gitdir
GIT_DIR=$GIT_ROOT/ttssh2

cd       $GIT_DIR
git rev-list --all | xargs -n 1 git ls-files | xargs -n 1 basename | tee $WORKDIR/filenames.txt
