#!/bin/bash

####
# Description: Installs gcc8 toolchain, sets it up for use and caches the install packages.
#
# Runs on: All platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-install-gcc8.sh && source semaphore-install-gcc8.sh
#
# Note: 
####

set -e

sudo add-apt-repository -y ppa:ubuntu-toolchain-r/test
sudo apt-get update

install-package cpp-8 g++-8 gcc-8
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-8 90 --slave /usr/bin/g++ g++ /usr/bin/g++-8

change-gcc-version 8
