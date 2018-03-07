#! /usr/bin/env bash

###
# In order to free up some space by removing unused languages from Semaphore environment
# Add the line below to your setup command in Project Settings
#
# wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/remove_unused_languages.sh  && bash remove_unused_languages.sh
#
# These commands will:

# remove all the Ruby, Node.js, PHP versions except the default
# alternatively you can add following commands to the setup of your build

find ~/.rbenv/versions -maxdepth 1 -type d | grep -v "$(rbenv version | awk '{print $1}')" | tail -n +2 | xargs rm -rf
find ~/.nvm/versions/node -maxdepth 1 -type d | grep -v "$(node -v)" | tail -n +2 | xargs rm -rf
find ~/.phpbrew/php -maxdepth 1 -type d | grep -v "$(php -v | cut -d ' ' -f2 | head -n1)" | tail -n +2 | xargs rm -rf

echo "-------------------------------------------------------"
echo "Removed unused languages from the Semaphore environment"
echo "-------------------------------------------------------"

df -h
