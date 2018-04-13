#! /usr/bin/env bash

set -e

###
# Usage:
# Add the following command to the setup of a build in the Project Settings
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/golang_setup.sh && bash golang_setup.sh
#
# By default this script installs and caches Golang v1.10.
# Also, in order to install arbitary Golang version, it is neccessary to pass the version as a parameter. 
# This can be done with the command similar to the following:
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/golang_setup.sh && bash golang_setup.sh <golang-version>
#
# Note: reset your dependency cache in Project Settings > Admin, before running this script
###

GOLANG_VERSION=${1:-"1.10"}
TAR=go$GOLANG_VERSION.linux-amd64.tar.gz
URL=https://storage.googleapis.com/golang/$TAR
GOLANG_CACHE_PATH="$SEMAPHORE_CACHE_DIR/$TAR"

function cache_golang_installation(){
  if ! [ -e $SEMAPHORE_CACHE_DIR/$TAR ]; then (cd $SEMAPHORE_CACHE_DIR; wget $URL); fi
}

function install_golang(){
  sudo mkdir -p /usr/local/golang/$GOLANG_VERSION
  sudo tar -xzf $SEMAPHORE_CACHE_DIR/$TAR -C /usr/local/golang/$GOLANG_VERSION
}

function switch_golang_version(){
  sudo rm /usr/local/bin/go
  sudo ln -s /usr/local/golang/$GOLANG_VERSION/go/bin/go /usr/local/bin/go
}

function main(){
  cache_golang_installation
  install_golang
  switch_golang_version

  echo "## Setup complete."
  echo "-----------------------------------------------"
  echo "## Details:"
  echo "$(go version)"
}

main
