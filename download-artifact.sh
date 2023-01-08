#!/bin/bash -e

function show_help () {
    echo $0 latest [...]
    echo $0 main   [...]
    echo $0 help
}

ARG=$1
BRANCH_PARAM=
if  [ x"$ARG" = x"help" ]; then
    show_help
    exit 0
elif [ x"$ARG" = x"latest" ]; then
    BRANCH_PARAM=
    shift
elif [ x"$ARG" = x"main" ]; then
    BRANCH_PARAM="-b main"
    shift
else
    BRANCH_PARAM="-b main"
fi

set -x
gh run list -L 1 $BRANCH_PARAM
gh run download $(gh run list -L 1 $BRANCH_PARAM --json databaseId  --jq '.[].databaseId') $@
