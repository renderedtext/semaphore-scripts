#! /usr/bin/env bash

####
# Description: This script installs specified Elixir and Erlang version on Semaphore.
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-elixir-setup.sh && source ./semaphore-elixir-setup.sh <elixir-version> <erlang-version>
#
# Note:
####

. /home/runner/.bash_profile

elixir_version=${1:-"1.7"}
erlang_version=${2:-"21"}
elixirs_path="/home/runner/.kiex/elixirs"
elixir_archive="elixir-$elixir_version(erl-$erlang_version).tar.gz"
elixir_install_path="/home/runner/.kiex/versions/$elixir_version"

echo "*****************************************"
echo "Setting up Elixir $elixir_version" with Erlang $erlang_version
echo "*****************************************"

function switch_erlang_version(){
  echo "## Switching to Erlang $erlang_version"
  source ~/.kerl/installs/$erlang_version/activate
}

function switch_elixir_version(){
  echo "## Activating Elixir $elixir_version"
  kiex use $elixir_version
}

function install_elixir(){
  switch_erlang_version

  echo "## Installing Elixir $elixir_version"
  kiex install $elixir_version

  switch_elixir_version

  mix local.hex --force
}

function cache_elixir_installation(){
  echo "## Storing Elixir $elixir_version installation in cache ..."
  (cd $SEMAPHORE_CACHE_DIR && tar -cf $elixir_archive -C $elixirs_path elixir-$elixir_version elixir-$elixir_version.env)
}

function restore_elixir_installation(){
  echo "## Elixir $elixir_version installation archive found in cache. Unpacking..."
  (cd $SEMAPHORE_CACHE_DIR && tar xf $elixir_archive -C $elixirs_path)
}

function main(){
  if ! [ -d $elixir_install_path ]; then
    if ! [ -e $SEMAPHORE_CACHE_DIR/$elixir_archive ]; then
      kiex selfupdate

      install_elixir

      cache_elixir_installation
    else
      restore_elixir_installation
    fi
  else
    echo "## Elixir $elixir_version already installed. Skipping setup..."
  fi

  switch_erlang_version
  switch_elixir_version

  echo "## Setup complete."
  echo "-----------------------------------------------"
  echo "## Details:"
  echo "$(elixir --version)"
}

main