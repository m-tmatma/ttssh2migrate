#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
SRC_REPO=ttssh2.org
URL=file://$SCRIPT_DIR/$SRC_REPO

cd $SCRIPT_DIR
if [ ! -f $SRC_REPO/format ]; then
    svnadmin create $SRC_REPO

    cd $SCRIPT_DIR/$SRC_REPO
    echo '#!/bin/sh'  > hooks/pre-revprop-change
    echo 'exit 0'    >> hooks/pre-revprop-change
    chmod +x            hooks/pre-revprop-change

    echo "Running: svnsync init"
    svnsync init $URL http://svn.osdn.net/svnroot/ttssh2/
else
    echo "Skip: svnsync init"
fi

cd $SCRIPT_DIR/$SRC_REPO
echo "Running: svnsync sync"
svnsync sync $URL
