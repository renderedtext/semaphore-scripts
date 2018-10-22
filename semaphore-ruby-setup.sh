#!/bin/bash

set -e

ruby_version=${1:-"2.5.3"}
gem_version=${2:-"2.7.7"}
ruby_archive="$ruby_version.tar.gz"
ruby_install_path="/home/runner/.rbenv/versions/$ruby_version"

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
  source ~/.bashrc
fi

echo "*****************************************"
echo "Setting up Ruby $ruby_version"
echo "*****************************************"

if ! [ -d $ruby_install_path ]; then
  if ! [ -e $SEMAPHORE_CACHE_DIR/$ruby_archive ]; then
    cd /home/runner/.rbenv/plugins/ruby-build && git pull && cd -
    CFLAGS='-fPIC' rbenv install $ruby_version
    (cd $SEMAPHORE_CACHE_DIR && tar -cf $ruby_archive -C $ruby_install_path .)
  else
    echo "Ruby $ruby_version installation archive found in cache. Unpacking..."
    if ! [ -d ~/.rbenv/versions ]; then mkdir ~/.rbenv/versions; fi
    (cd $SEMAPHORE_CACHE_DIR && mkdir $ruby_install_path && tar xf $ruby_archive -C $ruby_install_path)
  fi
else
  echo "Ruby $ruby_version already installed. Skipping setup..."
fi

echo "Activating Ruby $ruby_version"
rbenv global $ruby_version

if ! [ $gem_version = "$(gem --version)" ]; then
  echo "Updating RubyGems to version $gem_version"
  gem update --system $gem_version --no-ri --no-rdoc
fi

if [ ! -e $HOME/.rbenv/versions/$ruby_version/bin/bundle ]
then
  echo "Installing bundler..."
  gem install bundler --no-ri --no-rdoc
fi

if [ $(gem list | grep semaphore_test_boosters | wc -l) -gt 0 ]
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
