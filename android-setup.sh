#! /usr/bin/env bash

####
# Description: This script creates Android development environment on Semaphore.
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/android-setup.sh && source android-setup.sh
#
# Note:
####

set -e

# make more room in the environment
sudo rm -rf ~/.rbenv ~/.phpbrew

# install the necesarry base components

SDK_VERSION=${1:-'3859397'}
SDK_ARCHIVE="sdk-tools-linux-${SDK_VERSION}.zip"
SDK_URL="https://dl.google.com/android/repository/$SDK_ARCHIVE"
CACHED_SDK_PATH="$SEMAPHORE_CACHE_DIR/$SDK_ARCHIVE"
SDK_INSTALL_PATH="/opt/android/sdk"

function install-dependencies() {
  install-package --skip-update libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1
}

function setup-android-sdk() {
  ! [ -e $CACHED_SDK_PATH ] && wget $SDK_URL -P $SEMAPHORE_CACHE_DIR

  sudo mkdir -p $SDK_INSTALL_PATH
  sudo chown $USER:$USER $SDK_INSTALL_PATH

  yes 'y' | unzip $CACHED_SDK_PATH -d $SDK_INSTALL_PATH

  export PATH="$SDK_INSTALL_PATH/tools:$SDK_INSTALL_PATH/tools/bin:$SDK_INSTALL_PATH/platform-tools:$PATH"
  export ANDROID_HOME=$SDK_INSTALL_PATH
}

function accept-licenses(){
   script --return -c "yes | sdkmanager --licenses"
}

function list-sdk-components(){
  sdkmanager --list
}

install-dependencies

setup-android-sdk

accept-licenses

list-sdk-components

# setup Android system image 
(while sleep 3; do echo "y"; done) | sdkmanager "build-tools;26.0.1" "platforms;android-25" "extras;google;m2repository" "extras;android;m2repository" "platform-tools" "emulator" "system-images;android-25;google_apis;armeabi-v7a"

# create an AVD
echo -ne '\n' | avdmanager -v create avd -n semaphore-android-dev -k "system-images;android-25;google_apis;armeabi-v7a" --tag "google_apis" --abi "armeabi-v7a"
