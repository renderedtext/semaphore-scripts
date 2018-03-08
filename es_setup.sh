#! /usr/bin/env bash

#####
## Usage:
##
##    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/es_setup.sh && bash es_setup.sh <es-download-url>
##
## Where <es-download-url> should match the download URL
## of the Debian package for the ElasticSearch version your project depends on.
## This URL can be found here https://www.elastic.co/downloads/past-releases
##
## For example, ElasticSearch 2.3.5 can be installed
## by adding the following commands to the build sequence
##
##    export ES_DOWNLOAD_URL=https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-2.3.5.deb
##    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/es_setup.sh && bash es_setup.sh $ES_DOWNLOAD_URL
##
#####

ES_HOST="0.0.0.0"
ES_PORT="9200"
URL=${1:-"https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.0.0.deb"}
DEB=$(echo "$URL" | sed "s/.*\///")

function stall_for_elasticsearch() {
  echo ">> Waiting for ElasticSearch to become available"

  while true; do
    printf "."

    nc -4 -w 5 $ES_HOST $ES_PORT 2>/dev/null && break
    sleep 1
  done

  printf "\n"
}

function setup_java() {
  source /opt/change-java-version.sh
  change-java-version 8
}

function remove_installed_version() {
  sudo service elasticsearch stop
  sudo apt-get purge -y -f elasticsearch
  sudo rm -rf /var/lib/elasticsearch
}

function install_new_version() {
  if ! [ -e $SEMAPHORE_CACHE_DIR/$DEB ]; then (cd $SEMAPHORE_CACHE_DIR; wget $URL); fi

  echo ">> Installing ElasticSearch from the following url:"
  echo "$URL"
  echo 'Y' | sudo dpkg -i $SEMAPHORE_CACHE_DIR/$DEB

  sudo service elasticsearch start

  echo ">> Installation completed"
}

function run_health_check() {
  echo ">> Running health check..."
  curl http://"$ES_HOST":"$ES_PORT"/_cluster/health?pretty=true
  curl http://"$ES_HOST":"$ES_PORT"
}

setup_java

remove_installed_version

install_new_version

stall_for_elasticsearch

run_health_check
