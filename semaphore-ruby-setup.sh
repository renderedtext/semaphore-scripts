#!/bin/bash

####
# Description: Installs specified Ruby version and cache its installation on Semaphore
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-ruby-setup.sh && source semaphore-ruby-setup.sh <ruby-version>
#
# For example, the following command will install Ruby 2.5.1 and cache its installation on Semaphore
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/semaphore-ruby-setup.sh && source semaphore-ruby-setup.sh 2.5.1
#
# Note: Reset your dependency cache in Project Settings > Admin, before running this script.
####

set -e

ruby_version=${1:-"2.5.3"}
gem_version=${2:-"2.7.7"}
ruby_archive="$ruby_version.tar.gz"
ruby_install_path="/home/runner/.rbenv/versions/$ruby_version"
semaphore_test_boosters="no"
HOST="http://packages.semaphoreci.com/classic"

if [ ! -e /home/runner/.rbenv ]
then
  echo "*****************************************"
  echo "Setting up rbenv"
  echo "*****************************************"
  # install the prerequisites
  sudo apt-get update
  sudo apt-get install -y autoconf bison build-essential libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

  # install rbenv & ruby-build
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init -)"
  #curl -fsSL https://github.com/rbenv/rbenv-installer/raw/master/bin/rbenv-doctor | bash
fi

if [ $(gem list | grep semaphore_test_boosters | wc -l) -gt 0 ]
then
  echo "Found Semaphore Test Boosters Gem, marking it for update..."
  semaphore_test_boosters="yes"
fi
echo "*****************************************"
echo "Checking for prebuilt Ruby $ruby_version"
echo "*****************************************"
response=$(curl --write-out %{http_code} --head --silent --output /dev/null $HOST/ruby/$ruby_version.tar.gz)
if [[ "$response = "200" ]]; then
  wget $HOST/ruby/$ruby_version.tar.gz
  tar -zxf $ruby_version.tar.gz
  mv $ruby_version ~/.rbenv/versions/
fi



echo "*****************************************"
echo "Setting up Ruby $ruby_version"
echo "*****************************************"

if ! [ -d $ruby_install_path ]; then
  if ! [ -e $SEMAPHORE_CACHE_DIR/$ruby_archive ]; then
    cd /home/runner/.rbenv/plugins/ruby-build && git pull && cd -
    CFLAGS='-fPIC -std=gnu99' rbenv install $ruby_version
    (cd $SEMAPHORE_CACHE_DIR && tar -cf $ruby_archive -C $ruby_install_path .)
  else
    echo "Ruby $ruby_version installation archive found in cache. Unpacking..."
    if ! [ -d ~/.rbenv/versions ]; then mkdir ~/.rbenv/versions; fi
    (cd $SEMAPHORE_CACHE_DIR && mkdir $ruby_install_path && tar xf $ruby_archive -C $ruby_install_path)
  fi
else
  echo "Ruby $ruby_version already installed. Skipping setup..."
fi

rbenv rehash

echo "Activating Ruby $ruby_version"
rbenv global $ruby_version
ruby --version

if [ ! -e $HOME/.rbenv/versions/$ruby_version/bin/bundle ]
then
  echo "Installing bundler..."
  gem install bundler --no-document
fi

if ! [ $gem_version = "$(gem --version)" ]; then
  echo "Updating RubyGems to version $gem_version"
  gem update --system $gem_version --no-document
fi

if [ $semaphore_test_boosters == "yes" ]
then
  echo "Installing Semaphore Test Boosters Gem..."
  gem install semaphore_test_boosters
fi

echo "Setup complete."
echo "-----------------------------------------------"
echo "Details:"
echo "$(ruby --version)"
echo "$(bundle --version)"
echo "RubyGems version: $(gem --version)"
