#!/bin/bash

####
# Description: Installs latest Goodle Chrome browser. By default, it will install the stable version
# but allows for installing the beta (unstable) version as well.
#
# Runs on: All platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/chrome-setup.sh && bash chrome-setup.sh <[stable | unstable]>
#
# For example, the following command will install stable version of Google Chrome
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/chrome-setup.sh && bash chrome-setup.sh
#
# Alternatively, to install google-chrome-unstable (google-chrome-beta) use `bash chrome-setup.sh unstable` (beta)
#
# Note: 
####

set -e

CHROME_VERSION=${1:-"stable"}
BIN="/usr/bin/google-chrome-$CHROME_VERSION"

function set_key_and_repository(){
  wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
  sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
}

function install_chrome(){
  install-package --update-new google-chrome-$CHROME_VERSION
}

function switch_chrome_version(){
  sudo update-alternatives --set google-chrome $BIN
}

function main(){
  set_key_and_repository
  install_chrome
  switch_chrome_version

  echo "## Setup complete."
  echo "-----------------------------------------------"
  echo "## Details:"
  echo "$(google-chrome --version)"
}

main
