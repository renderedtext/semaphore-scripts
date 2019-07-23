#!/bin/bash

####
# Description: Installs latest MySQL Server 5.7 version from MySQL PPA.
#
# Runs on: All platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/mysql-57-ppa.sh && bash mysql-57-ppa.sh
#
# Note: Taken from https://gist.github.com/ervinb/bff380f0b333f76dca14eae735cb4649/
####

data_dir="/usr/data"

function prepare-data-dir(){
  echo "* Preparring data directory"
  sudo mkdir $data_dir
  sudo chown mysql:mysql $data_dir
}

function install-mysql(){
  echo "* Creating temporary folder"
  mkdir /tmp/mysql
  cd /tmp/mysql
  echo "* Downloading packages"
  wget http://packages.semaphoreci.com/classic/mysql/libmysqlclient20_5.7.26-1ubuntu14.04_amd64.deb
  wget http://packages.semaphoreci.com/classic/mysql/libmysqlclient-dev_5.7.26-1ubuntu14.04_amd64.deb
  wget http://packages.semaphoreci.com/classic/mysql/mysql-client_5.7.26-1ubuntu14.04_amd64.deb
  wget http://packages.semaphoreci.com/classic/mysql/mysql-common_5.7.26-1ubuntu14.04_amd64.deb
  wget http://packages.semaphoreci.com/classic/mysql/mysql-community-client_5.7.26-1ubuntu14.04_amd64.deb
  wget http://packages.semaphoreci.com/classic/mysql/mysql-community-server_5.7.26-1ubuntu14.04_amd64.deb
  wget http://packages.semaphoreci.com/classic/mysql/mysql-server_5.7.26-1ubuntu14.04_amd64.deb
  echo "* Removing previous installation"
  sudo apt-get remove mysql-server mysql-client mysql-common libmysqlclient18 -y
  echo "* Installing MySQL..."
  sudo apt-get install libmecab2 -y
  sudo DEBIAN_FRONTEND=noninterative dpkg -i --force-confold mysql-community-server_5.7.26-1ubuntu14.04_amd64.deb mysql-community-client_5.7.26-1ubuntu14.04_amd64.deb mysql-common_5.7.26-1ubuntu14.04_amd64.deb mysql-client_5.7.26-1ubuntu14.04_amd64.deb libmysqlclient-dev_5.7.26-1ubuntu14.04_amd64.deb libmysqlclient20_5.7.26-1ubuntu14.04_amd64.deb mysql-server_5.7.26-1ubuntu14.04_amd64.deb mysql-common_5.7.26-1ubuntu14.04_amd64.deb
  echo "* Cleaning environment"
  cd -
  rm -rf /tmp/mysql
}

function upgrade-system-tables(){
  echo "* Running MySQL system upgrade"
  # remove to avoid loading rogue sql modes
  sudo rm -f /usr/my.cnf

  mysql_upgrade -u ${DATABASE_MYSQL_USERNAME} -p${DATABASE_MYSQL_PASSWORD} --force
  sudo service mysql restart
}

function print-active-sql-modes(){
  mysql -u ${DATABASE_MYSQL_USERNAME} -p${DATABASE_MYSQL_PASSWORD} -e "show variables like 'sql_mode'"
}

function main(){
  prepare-data-dir

  install-mysql

  upgrade-system-tables

  print-active-sql-modes

  echo "* Installation complete"
}

main
