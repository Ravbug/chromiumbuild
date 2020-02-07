#!/bin/zsh
# Using https://chromium.googlesource.com/chromium/src/+/master/docs/mac_build_instructions.md

initial=`pwd`

echo -e "\e[101m\e[97mPerforming initial git init\e[49m\e[39m"

# setup the directories
mkdir chromebuild && cd chromebuild
git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --depth=1

export PATH="$PATH:`pwd`/depot_tools"

# Ensure that unicode filenames aren't mangled by HFS:
git config --global core.precomposeUnicode true

# download chromium components
echo -e "\e[45m\e[97mFetching Chromium\e[49m\e[39m"

# fetch
mkdir chromium && cd chromium
fetch --no-history chromium
cd src

# GN build init
echo -e "\e[45m\e[97mInitializing GN build\e[49m\e[39m"

args="--args=is_debug=false is_component_build=false symbol_level=0 blink_symbol_level=0 enable_stripping=true thin_lto_enable_optimizations=true"
echo Using args: $args
gn gen out/Default $args

echo -e "\e[45m\e[97mBuilding Chromium\e[49m\e[39m"

autoninja -C out/Default chrome && echo -e "\e[102m\e[97mBuild Succeeded\e[49m\e[39m"

# move the executable out
echo -e "\e[44m\e[97mMoving application\e[49m\e[39m"
mv out/Default/Chromium.app $initial

# clean up
echo -e "\e[104m\e[97mCleaning up\e[49m\e[39m"
cd $initial
rm -rf chromebuild

echo -e "\e[102m\e[97mBuild Complete\e[49m\e[39m"
open . 