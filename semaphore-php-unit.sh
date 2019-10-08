#!/usr/bin/bash env

####
# Description: Installs required PHPunit. 
# Also uses caching so the future installations are quicker.
#
# Runs on: Standard and Docker (Docker Light not supported)
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-php-unit.sh && source semaphore-php-unit.sh <phpunit_version>
#
# For example, the following command will install Python 3.7 and cache its installation on Semaphore
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-php-unit.sh && source semaphore-php-unit.sh 4.8
#
# Note: Reset your dependency cache in Project Settings > Admin, before running this script
####

set -e

phpunit_ver=${1:-'6.5'}
phpunit_cache_archive="$SEMAPHORE_CACHE_DIR/phpunit-$phpunit_ver.phar"

if [ -e $phpunit_cache_archive ]; then
  mv $phpunit_cache_archive /usr/local/bin/phpunit
  sudo chmod +x /usr/local/bin/phpunit/phpunit-$phpunit_ver.phar
else
wget https://phar.phpunit.de/phpunit-$phpunit_ver.phar
chmod +x phpunit-$phpunit_ver.phar
cp phpunit-$phpunit_ver.phar $SEMAPHORE_CACHE_DIR
sudo mv phpunit-$phpunit_ver.phar /usr/local/bin/phpunit
fi
phpunit --version

