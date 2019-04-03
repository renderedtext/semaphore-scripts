#!/bin/bash

####
# Description: Updates docker-compose and caches the installation for future use
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/docker-compose-update.sh && bash docker-compose-update.sh <version>
#
# For example, the following command will install docker-compose 1.24.0 and cache its install archive on Semaphore
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/docker-compose-update.sh && bash docker-compose-update.sh 1.24.0
#
# Note: 
####

set -e

ver=${1:-'1.24.0'}

if [ ! -e $SEMAPHORE_CACHE_DIR/docker-compose-$ver ]
then
    echo "docker-compose not found in cache, downloading version $ver..."
    sudo curl -L "https://github.com/docker/compose/releases/download/$ver/docker-compose-$(uname -s)-$(uname -m)" -o $SEMAPHORE_CACHE_DIR/docker-compose-$ver
    sudo chmod +x $SEMAPHORE_CACHE_DIR/docker-compose-$ver
fi

if [ -e /usr/bin/docker-compose ]
then
    echo "Removing existing docker-compose version..."
    sudo rm /usr/bin/docker-compose
fi
echo "Linking docker-compose version in cache..."
sudo ln -s $SEMAPHORE_CACHE_DIR/docker-compose-$ver /usr/bin/docker-compose

docker-compose version
