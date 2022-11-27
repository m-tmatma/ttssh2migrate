#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKDIR=$SCRIPT_DIR/workdir
GIT_ROOT=$WORKDIR/gitdir
GIT_ROOT_REPACK=$WORKDIR/gitdir-repack

rm   -rf $GIT_ROOT_REPACK
mkdir -p $GIT_ROOT_REPACK

du -h $GIT_ROOT/ttssh2

cp   -a $GIT_ROOT/ttssh2 $GIT_ROOT_REPACK/

# See https://techbase.kde.org/Projects/MoveToGit/UsingSvn2Git for `git repack`
git  -C $GIT_ROOT_REPACK/ttssh2 repack -a -d -f --window=250 --depth=250

du -h $GIT_ROOT_REPACK/ttssh2

diff -r $GIT_ROOT/ttssh2 $GIT_ROOT_REPACK/ttssh2
ls -lh  $GIT_ROOT/ttssh2/objects/pack $GIT_ROOT_REPACK/ttssh2/objects/pack
