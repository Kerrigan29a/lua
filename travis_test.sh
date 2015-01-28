#!/usr/bin/env bash

if [ $1 == "osx" ]; then
    make macosx test
elif [ $1 == "linux" ]; then
    make linux test
fi
