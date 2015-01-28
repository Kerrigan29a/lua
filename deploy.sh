#!/usr/bin/env bash

curl -R -O http://www.lua.org/ftp/lua-5.3.0.tar.gz
tar zxf lua-5.3.0.tar.gz
mv lua-5.3.0/* .
cat <<EOF > README.md
# Lua unofficial repository
[![Build Status](https://travis-ci.org/Kerrigan29a/lua.svg)](https://travis-ci.org/Kerrigan29a/lua)
[![Coverage Status](https://coveralls.io/repos/Kerrigan29a/lua/badge.svg)](https://coveralls.io/r/Kerrigan29a/lua)
EOF
cat <<EOF >> Makefile
uneploy:
	rm -rf doc
	rm -rf src
	rm README
	rm Makefile
EOF
cat README >> README.md
rm -rf lua-5.3.0
rm lua-5.3.0.tar.gz
if [ "$(uname)" == "Darwin" ]; then
	make macosx test "MYCFLAGS=-fPIC"
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
	make linux test  "MYCFLAGS=-fPIC"
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
	make mingw test  "MYCFLAGS=-fPIC"
else
	make generic test
fi
make clean