#! /usr/bin/env bash

set -e

#####
## Usage:
## In order to enable additional unsupported Fireforx version
## add the following line to the setup of a build
##
## wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/firefox_setup.sh && bash firefox_setup.sh <firefox-version>
##
## For example, in order to install Firefox 55
## wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/firefox_setup.sh && bash firefox_setup.sh 55.0
#####

FF_VERSION=${1:-'44.0'}
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
