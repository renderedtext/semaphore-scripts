#!/bin/bash

####
# Description: Script used for caching public Docker images on Semaphore mirror which should result in faster download times.
# It will download the custom configuration file, install it and restart Docker daemon in order to apply the settings.
#
# Runs on: Docker and Docker Light platforms
#
# Usage:
# Add the line below to your setup command in Project Settings
#
# wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-docker-mirror.sh  && bash semaphore-docker-mirror.sh
#
# Note: This script works for public docker images only, private images are not supported.
####

wget https://raw.githubusercontent.com/renderedtext/quickfix/master/daemon.json
sudo mv daemon.json /etc/docker/daemon.json
sudo service docker restart
