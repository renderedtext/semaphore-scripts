#!/bin/bash

####
# Description: Installs Oracle Java JDK 11. Also uses caching so the future installations
# are quicker.
#
# Runs on: All Semaphore Classic platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/java11install.sh && bash java11install.sh
#
# Note: Will overwrite any previous Oracle Java JDK 11 installation in `/usr/lib/jvm/java-11-oracle/`
####

set -e

jdk_download_url=https://download.oracle.com/otn-pub/java/jdk/11.0.2+7/f51449fcd52f4d52b93a989c5c56ed3c/jdk-11.0.2_linux-x64_bin.tar.gz
cached_archive=$SEMAPHORE_CACHE_DIR/jdk-11_linux-x64_bin.tar.gz
jdk11_path=/usr/lib/jvm/java-11-oracle/

#downloading from Oracle
if [ ! -f $cached_archive ]; then
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" $jdk_download_url -O $cached_archive
fi
tar -zxvf $cached_archive
#move into place
if [ -d $jdk11_path ]; then
    rm -rf $jdk11_path
fi
sudo mkdir -p $jdk11_path
sudo mv jdk-11*/* $jdk11_path
rm -rf jdk-11*
#install
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/java-11-oracle/bin/java  1111
#select default
version_info=$(echo -e '\n' | update-alternatives --config java | grep 1111.*manual | sed 's/*//')
option_number=$(echo $version_info | awk '{print $1}')
java_home_path=$(echo $version_info | awk '{print $2}' | grep -oP '/usr/lib/jvm/java[^/]*')

echo $option_number | sudo update-alternatives --config java > /dev/null 2>&1
echo $option_number | sudo update-alternatives --config javac > /dev/null 2>&1

export JAVA_HOME="$java_home_path"

#verify java version
java -version
