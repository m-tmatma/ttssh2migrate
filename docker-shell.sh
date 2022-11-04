#!/bin/bash

function build_docker {
    docker build -t svn2git `pwd`/svn2git
}

function run_docker {
    mkdir -p `pwd`/homedir
    docker run --rm -it -v `pwd`/homedir:/homedir \
    svn2git $@
}

function show_help {
    echo $0 build
    echo $0 bash
    echo $0 shell
}

case $1 in
  "build" ) build_docker ;;
  "bash"  ) run_docker bash ;;
  "shell" ) run_docker bash ;;
  *       ) show_help ;;
esac
