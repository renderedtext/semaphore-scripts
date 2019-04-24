#! /usr/bin/env bash

####
# Description: Installs specified Node.JS version. By default, it will install version 10.13.0
# and cache it for future installs.
#
# Runs on: Standard and Docker platform (requires `nvm`)
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/cache-node-install.sh && source cache-node-install.sh <node.js_version>
#
# For example, the following command will install Node.JS version 10.13.0
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/cache-node-install.sh && source cache-node-install.sh 10.13.0
#
# Note: 
####


set -e

. $HOME/.nvm/nvm.sh

n_ver=${1:-'10.13.0'}
n_archive=node-v$n_ver-linux-x64.tar # partial name, the name of archive can end with .gz or .xz.
n_dir=node-v$n_ver-linux-x64
nv_cache_dir=$HOME/.nvm/.cache/bin

function set_archive_name() {
    if [ -e $SEMAPHORE_CACHE_DIR/$n_archive.gz ] 
    then
         n_archive=$n_archive.gz
    elif [ -e $SEMAPHORE_CACHE_DIR/$n_archive.xz ]
    then
        n_archive=$n_archive.xz
    else
        n_archive='None'
    fi
}

function install_fresh() {
    echo "Node.js version $n_ver not found in cache. Downloading..."
    nvm install $n_ver
    cp $nv_cache_dir/$n_dir/* $SEMAPHORE_CACHE_DIR/
}

function install_from_cache() {
    echo "Node.js version $n_ver found in cache... ($n_archive)"
    mkdir -p $nv_cache_dir/$n_dir
    cp $SEMAPHORE_CACHE_DIR/$n_archive $nv_cache_dir/$n_dir/$n_archive
    nvm install $n_ver
}

function main() {
    set_archive_name

    if [ $n_archive != "None" ]
    then
        install_from_cache
    else
        install_fresh
    fi
}

main
