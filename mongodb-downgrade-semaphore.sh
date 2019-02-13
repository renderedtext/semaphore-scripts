#! /usr/bin/env bash

###
# Add the line below to your setup command in Project Settings
#
# wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/mongodb-downgrade-semaphore.sh && bash mongodb-downgrade-semaphore.sh
#
# Note: reset your dependency cache in Project Settings > Admin, before running this script
# Taken from https://gist.githubusercontent.com/ervinb/3f8b634ecbb8646ea00ad2a0d5523b33/raw/mongodb-downgrade-semaphore.sh
###

MONGODB_VERSION=${1:-'2.6.12'}

echo "---------------------------------------"
echo "# Removing currently installed MongoDB"
echo "---------------------------------------"
sudo apt-get purge -y mongodb-org* &>/dev/null
sudo rm -rf /var/lib/mongodb

echo "---------------------------------------"
echo "# Installing MongoDB version $MONGODB_VERSION"
echo "---------------------------------------"

# add PPA for 2.6.x
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 9ECBEC467F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb-dep.list

# add PPA for 3.0.x
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.0.list

# add PPA for 3.2.x
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys D68FA50FEA312927
echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list

# install MongoDB
install-package --update mongodb-org-server=$MONGODB_VERSION mongodb-org-mongos=$MONGODB_VERSION mongodb-org-shell=$MONGODB_VERSION mongodb-org-tools=$MONGODB_VERSION

# print post-installation info
echo "---------------------------------------"
printf "\nInstallation complete.\n\nDetails:\n $(mongod --version)\n"
printf "\nService status:\n $(sudo service mongod status)\n"
