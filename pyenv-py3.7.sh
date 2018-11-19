#!/bin/bash

####
# Description: Installs pyenv and Python version 3.7. Also uses caching so the future installations
# are quicker.
#
# Runs on: Docker Light platform (requires Ubuntu 16.04, Ubuntu 14.04 not working properly: https://github.com/travis-ci/travis-ci/issues/9069)
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/pyenv-py3.7.sh && bash pyenv-py3.7.sh <python_version>
#
# For example, the following command will install Python 3.7 and cache its installation on Semaphore
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/pyenv-py3.7.sh && bash pyenv-py3.7.sh 3.7.0
#
# Note: Reset your dependency cache in Project Settings > Admin, before running this script
####

py_ver=${1:-'3.7.0'}
py_cache_archive="$SEMAPHORE_CACHE_DIR/py$py_ver-cache.tar.gz"

pyenv_home="$HOME/.pyenv"
py_installation_dir="${pyenv_home}/versions/${py_ver}"

# Install pyenv
if ! which pyenv; then
  curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

  echo 'export PATH="/home/runner/.pyenv/bin:$PATH"' | tee -a ~/.bash_profile
  echo 'eval "$(pyenv init -)"' | tee -a ~/.bash_profile
  echo 'eval "$(pyenv virtualenv-init -)"' | tee -a ~/.bash_profile
fi

. ~/.bash_profile

if [[ -e $py_cache_archive ]]; then
   mkdir -p $py_installation_dir
  (cd $SEMAPHORE_CACHE_DIR && tar -xf $py_cache_archive -C $py_installation_dir)
else
  sudo apt-get update
  sudo apt-get install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdm-dev libc6-dev libbz2-dev zlib1g-dev openssl libffi-dev python3-dev python3-setuptools wget               

  pyenv install $py_ver

  (cd $SEMAPHORE_CACHE_DIR && tar -czf $py_cache_archive -C $py_installation_dir .)
fi

pyenv rehash
pyenv global $py_ver
