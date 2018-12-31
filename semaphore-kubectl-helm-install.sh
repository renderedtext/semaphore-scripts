#!/bin/bash

####
# Description: This script will install and cache `kubectl` and `helm` binaries
# on Semaphore.
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-kubectl-helm-install.sh && bash semaphore-kubectl-helm-install.sh
#
# Note:
####

set -e

# install kubectl
if [ ! -e $SEMAPHORE_CACHE_DIR/kubectl ]
then
    echo "kubectl not found in cache, downloading..."
    curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
    sudo chmod +x ./kubectl
    echo "Saving kubectl to cache..."
    mv ./kubectl $SEMAPHORE_CACHE_DIR
fi
echo "Using kubectl from cache..."
sudo cp $SEMAPHORE_CACHE_DIR/kubectl /usr/local/bin/kubectl

# cache kubectl settings
if [ ! -e $SEMAPHORE_CACHE_DIR/.kube ]; then mkdir $SEMAPHORE_CACHE_DIR/.kube; fi
ln -s $SEMAPHORE_CACHE_DIR/.kube /home/runner/.kube


# install helm
if [ ! -e $SEMAPHORE_CACHE_DIR/helm ]
then
    echo "helm not found in cache, downloading..."
    mkdir $SEMAPHORE_CACHE_DIR/helm
    wget https://storage.googleapis.com/kubernetes-helm/helm-v2.10.0-linux-amd64.tar.gz
    echo "Saving helm to cache..."
    tar -zxf helm-v2.10.0-linux-amd64.tar.gz --directory $SEMAPHORE_CACHE_DIR/helm
    sudo chmod +x $SEMAPHORE_CACHE_DIR/helm/linux-amd64/helm
fi
echo "Using helm from cache..."
sudo cp $SEMAPHORE_CACHE_DIR/helm/linux-amd64/helm /usr/local/bin/helm

# cache helm settings
if [ ! -e $SEMAPHORE_CACHE_DIR/.helm ]; then mkdir $SEMAPHORE_CACHE_DIR/.helm; fi
ln -s $SEMAPHORE_CACHE_DIR/.helm /home/runner/.helm