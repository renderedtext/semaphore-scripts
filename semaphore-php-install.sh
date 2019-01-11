#!/usr/bin/bash env

####
# Description: Installs required dependencies andPHP using `phpbrew` command. 
# Also uses caching so the future installations are quicker.
#
# Runs on: Standard and Docker (Docker Light not supported)
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-php-install.sh && source semaphore-php-install.sh <php_version>
#
# For example, the following command will install Python 3.7 and cache its installation on Semaphore
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-php-install.sh && source semaphore-php-install.sh 7.3.1
#
# Note: Reset your dependency cache in Project Settings > Admin, before running this script
####

set -e

php_ver=${1:-'7.3.0'}
php_cache_archive="$SEMAPHORE_CACHE_DIR/php$php_ver-cache.tar.gz"

echo "deb http://ppa.launchpad.net/ondrej/php/ubuntu trusty main" | sudo tee -a /etc/apt/sources.list.d/ondrej-ppa.list
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 14AA40EC0831756756D7F66C4F4EA0AAE5267A6C

install-package --update-new libzip-dev

phpbrew self-update
phpbrew update

if [ -e $php_cache_archive ]; then
  echo "Restoring php installation cache..."
  tar -xf $php_cache_archive -C $SEMAPHORE_CACHE_DIR
  mv $SEMAPHORE_CACHE_DIR/php-$php_ver ~/.phpbrew/php
  echo "Php installation cache restored."
else
  echo "Cached php installation not found, compiling php..."
  phpbrew install php-$php_ver

  echo "Creating new cache archive ..."
  tar -czf $php_cache_archive -C "$HOME/.phpbrew/php" php-$php_ver

  echo "Done."
fi

phpbrew switch php-$php_ver

php --version