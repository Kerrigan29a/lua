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
curl -L -O $URL
tar zxf $LUA_VERSION.tar.gz



# Move src
mv $LUA_VERSION/* .



# Compose new README
cat <<'EOF' > README.md
# Lua unofficial repository
[![Build Status](https://travis-ci.org/Kerrigan29a/lua.svg)](https://travis-ci.org/Kerrigan29a/lua)
[![Coverage Status](https://coveralls.io/repos/Kerrigan29a/lua/badge.svg)](https://coveralls.io/r/Kerrigan29a/lua)
[![Coverity Scan Build Status](https://scan.coverity.com/projects/4202/badge.svg)](https://scan.coverity.com/projects/4202)

## Original README
EOF
cat README >> README.md
rm README
cat <<'EOF' >> README.md

## Building on Windows with Visual Studio
```bash
nmake -f Makefile.win
```

## Building on other platforms
```bash
make
# Read the information and select one platform
make SELECTED_PLATFORM
```
EOF



# Create undeploy script
cat <<'EOF' > undeploy.sh
#!/usr/bin/env bash
rm -rf doc
rm -rf src
rm README.md
rm Makefile
rm undeploy.sh
EOF
chmod +x undeploy.sh



# Create Windows Nmake Makefile
cat <<'EOF' > src/Makefile.win
!if "$(DEBUG)" == ""
DEBUG = 0
!endif

CFLAGS= -D__inline__=__inline -Wall -DLUA_COMPAT_5_2 -DLUA_USE_WINDOWS -DDLUA_BUILD_AS_DLL

!if "$(DEBUG)" == "1"
CFLAGS = $(CFLAGS) -Od -D_DEBUG -DDEBUG -ZI -WX
!else
CFLAGS = $(CFLAGS) -O2 -DNDEBUG -Zi
!endif

COMMON_SOURCES = \
EOF
cd src
find . -name "*.c" ! -name "lua.c" ! -name "luac.c" -exec echo {} + >> Makefile.win
cd ..
cat <<'EOF' >> src/Makefile.win

LUA_SOURCES = lua.c $(COMMON_SOURCES)
LUAC_SOURCES = luac.c $(COMMON_SOURCES)

COMMON_OBJETS = $(COMMON_SOURCES:.c=.obj)
LUA_OBJECTS = $(LUA_SOURCES:.c=.obj)
LUAC_OBJETS = $(LUAC_SOURCES:.c=.obj)

TARGET_LUA = lua.exe
TARGET_LUAC = luac.exe
TARGET_LUA_LIB = liblua53.lib
TARGET_LUA_DLL = lua53.dll


all: $(TARGET_LUA) $(TARGET_LUAC) $(TARGET_LUA_LIB) $(TARGET_LUA_DLL)

$(TARGET_LUA): $(LUA_OBJECTS)
  link -out:$@ $**

$(TARGET_LUAC): $(LUAC_OBJETS)
  link -out:$@ $**

$(TARGET_LUA_LIB): $(COMMON_OBJETS)
  lib -out:$@ $**

$(TARGET_LUA_DLL): $(COMMON_OBJETS)
  link -out:$@ -dll $**

.c.obj:
  cl $(CFLAGS) -c $< -Fo$*.obj

clean:
  @del *.pdb
  @del *.obj
  @del *.ilk
  @del *.exe
  @del *.dll
  @del *.lib
EOF

cat <<'EOF' > Makefile.win

all:
  cd src
  nmake -f Makefile.win

clean:
  cd src
  nmake -f Makefile.win clean
  
test:
  src\lua -v
EOF



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
  