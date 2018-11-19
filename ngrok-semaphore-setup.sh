#!/bin/bash

####
# Description: Downloads, installs and starts latest stable ngrok version. Uses caching so the 
# future installations should be faster.
#
# Runs on: All platforms
#
# Usage:
# Add the line below to your setup command in Project Settings
#
# wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/ngrok-semaphore-setup.sh  && bash ngrok-semaphore-setup.sh
#
# Note: 
####

ngrok_archive="ngrok-stable-linux-amd64.zip"
ngrok_archive_path="${SEMAPHORE_CACHE_DIR}/${ngrok_archive}"
ngrok_dl_url="https://bin.equinox.io/c/4VmDzA7iaHb/${ngrok_archive}"
ngrok_local_api_url="localhost:4040/api"

function wait_for_ngrok() {
  echo -n "Waiting for ngrok to come online..."

  while true; do
    printf "."

    curl --fail ${ngrok_local_api_url}/tunnels &> /dev/null && break

    sleep 1
  done

  printf "\n"
}

function setup() {
  wget -O $ngrok_archive_path --no-clobber $ngrok_dl_url

  echo "Y" | unzip $ngrok_archive_path -d $SEMAPHORE_PROJECT_DIR
}

function start_http() {
  ./ngrok http 80 > /dev/null &
}

function get_public_url() {
  echo -e "\nThe public URL is:"
  curl -s ${ngrok_local_api_url}/tunnels | grep -oP '(?<="public_url":)[^,]*' | tail -n1
}

setup

start_http

wait_for_ngrok

get_public_url
