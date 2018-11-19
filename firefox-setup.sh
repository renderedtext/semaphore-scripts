#! /usr/bin/env bash

####
# Description: Installs specified version of Firefox browser and set up the symlink to newly installed version.
# Script uses caching so the future installations are quicker.
#
# Runs on: All platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/firefox-setup.sh && bash firefox-setup.sh <firefox-version>
#
# For example, the following command will install Firefox version 60
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/firefox-setup.sh && bash firefox-setup.sh 60.0
#
# Note: 
####

set -e

FF_VERSION=${1:-'60.0'}
TAR='firefox-'"$FF_VERSION"'.tar.bz2'
INSTALL_PATH="/opt/firefox-$FF_VERSION"
BIN_PATH="/usr/bin/firefox"
URL="https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$FF_VERSION/linux-x86_64/en-US/$TAR"

if ! [ -e $SEMAPHORE_CACHE_DIR/$TAR ]; then (cd $SEMAPHORE_CACHE_DIR; wget $URL); fi

echo "Installing Firefox $FF_VERSION ..."

sudo mkdir -p $INSTALL_PATH
sudo tar --strip=1 -xf $SEMAPHORE_CACHE_DIR/$TAR -C $INSTALL_PATH
sudo ln -fs $INSTALL_PATH/firefox $BIN_PATH

echo "Done."
echo "-----------------------"

echo "$(firefox --version 2>/dev/null)"
echo "Path: $INSTALL_PATH"
