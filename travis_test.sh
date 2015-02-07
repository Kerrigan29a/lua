#!/usr/bin/env bash

./undeploy.sh
./deploy.sh
if [ $1 == "osx" ]; then
    make macosx test "MYCFLAGS=-fprofile-arcs -ftest-coverage -g -fPIC" "MYLDFLAGS=-fprofile-arcs -ftest-coverage"
elif [ $1 == "linux" ]; then
    make linux test  "MYCFLAGS=-fprofile-arcs -ftest-coverage -g -fPIC" "MYLDFLAGS=-fprofile-arcs -ftest-coverage"
fi
