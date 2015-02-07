#!/usr/bin/env bash

# Get the URL of the last version
LUA_VERSION=$(curl -R -o - "http://www.lua.org/start.html" | awk '
    /http:\/\/www.lua.org\/ftp\/lua/ {
        split($4, p, "/");
        split(p[5], q, ".");
        print q[1] "." q[2] "." q[3]
    }'
)
URL="http://www.lua.org/ftp/$LUA_VERSION.tar.gz"

# Get Lua
curl -R -O $URL
tar zxf $LUA_VERSION.tar.gz

# Move src
mv $LUA_VERSION/* .

# Compose new REAMDE
cat <<EOF > README.md
# Lua unofficial repository
[![Build Status](https://travis-ci.org/Kerrigan29a/lua.svg)](https://travis-ci.org/Kerrigan29a/lua)
[![Coverage Status](https://coveralls.io/repos/Kerrigan29a/lua/badge.svg)](https://coveralls.io/r/Kerrigan29a/lua)
EOF
cat README >> README.md
rm README

# Create undeploy script
cat <<EOF > undeploy.sh
#!/usr/bin/env bash
rm -rf doc
rm -rf src
rm README.md
rm Makefile
rm undeploy.sh
EOF
chmod +x undeploy.sh

# Test
TEST_FLAGS="MYCFLAGS=-fPIC"

if [ "$(uname)" == "Darwin" ]; then
    make macosx test $TEST_FLAGS
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
    make linux test  $TEST_FLAGS
elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
    make mingw test  $TEST_FLAGS
else
    make generic test $TEST_FLAGS
fi
make clean

# Clean
rm -rf $LUA_VERSION
rm $LUA_VERSION.tar.gz
