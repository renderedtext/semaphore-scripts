#!/bin/bash

set -e

#####
## Usage:
##
##   wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/chrome_setup.sh && bash chrome_setup.sh <chrome-version>
##
## By default script will install the latest google-chrome-stable.
## Alternatively, to install google-chrome-unstable (google-chrome-beta) use `bash chrome-setup.sh unstable` (beta)
#####

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
