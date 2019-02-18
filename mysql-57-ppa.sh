#!/bin/bash

# Taken from https://gist.github.com/ervinb/bff380f0b333f76dca14eae735cb4649/

data_dir="/usr/data"

function prepare-data-dir(){
  echo "* Preparring data directory"
  sudo mkdir $data_dir
  sudo chown mysql:mysql $data_dir
}

function install-mysql(){
  echo "* Adding PPA key"
  curl -s -L https://repo.mysql.com/RPM-GPG-KEY-mysql |  sudo apt-key add -
  echo "* Installing MySQL 5.7 from PPA"
  echo "deb http://repo.mysql.com/apt/ubuntu/ trusty mysql-5.7" | sudo tee /etc/apt/sources.list.d/mysql57.list
  install-package --update-new mysql-server -o Dpkg::Options::="--force-confnew"
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
