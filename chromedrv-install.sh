#!/bin/bash

# Usage: ./chromedrv-install.sh <VERSION>

####
# Description: Installs specified ChromeDriver version and caches the installation for future use
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/chromedrv-install.sh && bash chromedrv-install.sh <version>
#
# For example, the following command will install ChromeDriver 2.46 and cache its install archive on Semaphore
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/chromedrv-install.sh && bash chromedrv-install.sh 2.46
#
# Note: 
####

set -e

DRV_VER=${1:-'2.46'}
DRV_ARCHIVE=$SEMAPHORE_CACHE_DIR/chromedriver_$DRV_VER.zip

if [ ! -f $DRV_ARCHIVE ] 
then
  echo "ChromeDriver not found in cache. Downloading..."
  wget https://chromedriver.storage.googleapis.com/$DRV_VER/chromedriver_linux64.zip
  echo "Moving cache. Downloading..."
  mv chromedriver_linux64.zip $DRV_ARCHIVE
fi
echo "Using ChromeDriver archive..."
unzip $DRV_ARCHIVE
sudo mv chromedriver /usr/local/bin/
sudo chown runner:runner /usr/local/bin/chromedriver

chromedriver --version
