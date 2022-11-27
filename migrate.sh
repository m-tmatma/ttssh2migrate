#!/bin/bash -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKDIR=$SCRIPT_DIR/workdir
SVN_ROOT=$WORKDIR/ttssh2
GIT_ROOT=$WORKDIR/gitdir

rm   -rf $GIT_ROOT
mkdir -p $GIT_ROOT
cd       $GIT_ROOT

$SCRIPT_DIR/make-identity-map.py $SCRIPT_DIR/user-list.csv $SCRIPT_DIR/identity-map

echo running svn-all-fast-export
svn-all-fast-export \
    --rules $SCRIPT_DIR/input.rules \
    --identity-map  $SCRIPT_DIR/identity-map \
    --add-metadata \
    --svn-branches \
    --debug-rules \
    --svn-ignore \
    --empty-dirs \
    $SVN_ROOT > $GIT_ROOT/log-migration.log  2>&1

echo rename defaut branch to main
git -C $GIT_ROOT/ttssh2 branch -m main
