#!/bin/bash -xe

gh run list -L 1 -b main
gh run download $(gh run list -L 1 -b main --json url  --jq '.[].url' | xargs -n1 basename) $@
