#!/bin/bash -e

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKDIR=$SCRIPT_DIR/workdir
SVN_ROOT=$WORKDIR/ttssh2
GIT_ROOT=$WORKDIR/gitdir
GIT_DIR=$GIT_ROOT/ttssh2

mkdir -p $WORKDIR
cd       $GIT_DIR
git rev-list --all | xargs -n 1 git ls-tree -r --name-only | $SCRIPT_DIR/drop-duplicate.py | tee $WORKDIR/file-full-names.txt
sort $WORKDIR/file-full-names.txt > $WORKDIR/file-sorted-full-names.txt
cat $WORKDIR/file-full-names.txt | xargs -n 1 basename | sort | uniq | tee $WORKDIR/file-names.txt
cat $WORKDIR/file-names.txt | python3 -c "import sys; import os; lines = sys.stdin.readlines(); print(''.join({os.path.splitext(os.path.basename(line))[1] for line in lines}))" | tee $WORKDIR/file-ext.txt
