#! /usr/bin/env bash

####
# Description: This script will remove all the Ruby, Node.js, PHP versions except the default one in order 
# to free up disk space by removing unused languages from Semaphore environment
#
# Runs on: Standard and Docker (Docker Light is not supported)
#
# Usage:
# Add the line below to your setup command in Project Settings
#
# wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/remove-unused-languages.sh  && bash remove-unused-languages.sh
#
# Note: Even though the script works and removes the unused languages on Standard platform, there will be
# no free disk space increase on Standard platform when using this script
####

find ~/.rbenv/versions -maxdepth 1 -type d | grep -v "$(rbenv version | awk '{print $1}')" | tail -n +2 | xargs rm -rf
find ~/.nvm/versions/node -maxdepth 1 -type d | grep -v "$(node -v)" | tail -n +2 | xargs rm -rf
find ~/.phpbrew/php -maxdepth 1 -type d | grep -v "$(php -v | cut -d ' ' -f2 | head -n1)" | tail -n +2 | xargs rm -rf

echo "-------------------------------------------------------"
echo "Removed unused languages from the Semaphore environment"
echo "-------------------------------------------------------"

df -h
