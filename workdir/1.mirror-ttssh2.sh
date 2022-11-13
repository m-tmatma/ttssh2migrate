#!/bin/bash

SCRIPT_DIR=$(cd $(dirname $0); pwd)
URL=file://$SCRIPT_DIR/ttssh2

cd $SCRIPT_DIR
if [ ! -f ttssh2/format ]; then
    svnadmin create ttssh2

    cd $SCRIPT_DIR/ttssh2
    echo '#!/bin/sh'  > hooks/pre-revprop-change
    echo 'exit 0'    >> hooks/pre-revprop-change
    chmod +x            hooks/pre-revprop-change

    echo "Running: svnsync init"
    svnsync init $URL http://svn.osdn.net/svnroot/ttssh2/
else
    echo "Skip: svnsync init"
fi

cd $SCRIPT_DIR/ttssh2
echo "Running: svnsync sync"
svnsync sync $URL
