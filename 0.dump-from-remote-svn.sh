#!/bin/sh

QUIET=
if [ x"$CI" = x"true" ]; then
    QUIET=--quiet
fi

svnrdump dump $QUIET http://svn.osdn.net/svnroot/ttssh2 > ttssh2.svndmp
