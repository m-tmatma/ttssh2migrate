#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKDIR=$SCRIPT_DIR/workdir
SRC_REPO=$WORKDIR/ttssh2.org
URL=file://$SRC_REPO

QUIET=
if [ x"$CI" = x"true" ]; then
    QUIET=--quiet
fi

cd $SCRIPT_DIR
if [ ! -f $SRC_REPO/format ]; then
    svnadmin create $SRC_REPO

    cd $SRC_REPO
    echo '#!/bin/sh'  > hooks/pre-revprop-change
    echo 'exit 0'    >> hooks/pre-revprop-change
    chmod +x            hooks/pre-revprop-change

    echo "Running: svnsync init"
    svnsync init $URL http://svn.osdn.net/svnroot/ttssh2/
else
    echo "Skip: svnsync init"
fi

cd $SRC_REPO
echo "Running: svnsync sync"
svnsync sync $QUIET $URL
