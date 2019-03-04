#!/bin/bash

####
# Description: This script is used to verify that ElasticSearch service is running.
# When using this script in a build, the build does not move on to the next build 
# command unless the script successfully connects to the ElasticSerch service.
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/wait-for-es.sh && bash ./wait-for-es.sh
#
# Note: Requires ElasticSearch service
####

ES_HOST="0.0.0.0"
ES_PORT="9200"

function stall_for_elasticsearch() {
  echo ">> Waiting for ElasticSearch to become available"

  while true; do
    printf "."

    nc -4 -w 5 $ES_HOST $ES_PORT 2>/dev/null && break
    sleep 1
  done
  
  printf "\n"
}

function run_health_check() {
  echo ">> Running health check..."
  curl http://"$ES_HOST":"$ES_PORT"/_cluster/health?pretty=true
}

stall_for_elasticsearch

run_health_check
