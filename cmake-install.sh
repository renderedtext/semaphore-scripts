#! /usr/bin/env bash

####
# Description: This script will install and cache cmake on Semaphore.
#
# Runs on: All platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/cmake-install.sh && bash cmake-install.sh <cmake-version>
#
# Note: reset your dependency cache in Project Settings > Admin, before running this script
####

set -e

ver=${1:-'3.13.2'}

sudo apt-get purge -y cmake
if [ ! -f $SEMAPHORE_CACHE_DIR/cmake-$ver-Linux-x86_64.sh ]
then
  wget --directory-prefix=$SEMAPHORE_CACHE_DIR https://github.com/Kitware/CMake/releases/download/v$ver/cmake-$ver-Linux-x86_64.sh
fi

sudo chmod +x $SEMAPHORE_CACHE_DIR/cmake-$ver-Linux-x86_64.sh
sudo mkdir /opt/cmake
sudo sh $SEMAPHORE_CACHE_DIR/cmake-$ver-Linux-x86_64.sh --prefix=/opt/cmake --exclude-subdir
sudo ln -s /opt/cmake/bin/cmake /usr/bin/cmake

cmake --version
