#! /usr/bin/env bash

####
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/ruby_setup.sh && bash ruby_setup.sh <ruby-version>
#
# For example, the following command will install Ruby 2.5.1
# and cache its installation on Semaphore

#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/ruby_setup.sh && bash ruby_setup.sh 2.5.1
#
# Note: reset your dependency cache in Project Settings > Admin, before running this script
####

. /home/runner/.bash_profile

ruby_version=${1:-"2.3.1"}
gem_version=${2:-"2.6.14"}
ruby_archive="$ruby_version.tar.gz"
ruby_install_path="/home/runner/.rbenv/versions/$ruby_version"

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

echo "Installing bundler..."
gem install bundler --no-ri --no-rdoc

echo "Setup complete."
echo "-----------------------------------------------"
echo "Details:"
echo "$(ruby --version)"
echo "$(bundle --version)"
echo "RubyGems version: $(gem --version)"
