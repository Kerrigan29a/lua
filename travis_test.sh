#!/usr/bin/env bash

if [ $1 == "osx" ]; then
    make macosx test "MYCFLAGS=-fprofile-arcs -ftest-coverage -g -fPIC" "MYLDFLAGS=-fprofile-arcs -ftest-coverage"
elif [ $1 == "linux" ]; then
    make linux test  "MYCFLAGS=-fprofile-arcs -ftest-coverage -g -fPIC" "MYLDFLAGS=-fprofile-arcs -ftest-coverage"
fi
