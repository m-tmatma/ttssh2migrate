#!/bin/bash -xe

SCRIPT_DIR=$(cd $(dirname $0); pwd)
cd $SCRIPT_DIR

git submodule update --init --recursive

cd svn2git
qmake
make

