#!/bin/bash -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKDIR=$SCRIPT_DIR/workdir
SVN_ROOT=$WORKDIR/ttssh2
GIT_ROOT=$WORKDIR/gitdir

rm   -rf $GIT_ROOT
mkdir -p $WORKDIR
mkdir -p $GIT_ROOT
cd       $GIT_ROOT

$SCRIPT_DIR/make-identity-map.py $SCRIPT_DIR/user-list.csv $SCRIPT_DIR/identity-map

echo running svn-all-fast-export
$SCRIPT_DIR/svn2git/svn-all-fast-export \
    --rules $SCRIPT_DIR/input.rules \
    --identity-map  $SCRIPT_DIR/identity-map \
    --add-metadata \
    --svn-branches \
    --debug-rules \
    --svn-ignore \
    --empty-dirs \
    --msg-filter $SCRIPT_DIR/convert-svn-log.py \
    --commit-interval 1 \
    --use-localtime \
    $SVN_ROOT > $GIT_ROOT/log-migration.log  2>&1

echo rename defaut branch to main
git -C $GIT_ROOT/ttssh2 branch -m main
git -C $GIT_ROOT/ttssh2 log --all --grep=NotFound > $GIT_ROOT/log-NotFound.log
