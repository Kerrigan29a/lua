#!/usr/bin/env bash

# Download build && test spell
curl -R -o - "http://www.lua.org/faq.html" | awk '
	/<PRE CLASS="session">/ {flag=1;next}
	/<\/PRE>/ {flag=0}
	flag {
		spell=spell "\n" $0;
		if ($2 == "linux") {
			print spell > "linux_deploy.sh";
			spell="";
		} else if ($2 == "macosx") {
			print spell >"macosx_deploy.sh";
			spell="";
		}
	}
'

# Execute spell
if [ "$(uname)" == "Darwin" ]; then
	echo "make clean" >> macosx_deploy.sh
	chmod +x macosx_deploy.sh
	./macosx_deploy.sh
else
	echo "make clean" >> linux_deploy.sh
	chmod +x linux_deploy.sh
	./linux_deploy.sh
fi

# Delete spells
rm macosx_deploy.sh
rm linux_deploy.sh

# Move src
mv lua-5.3.0/* .

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

# Clean
rm -rf lua-5.3.0
rm lua-5.3.0.tar.gz
