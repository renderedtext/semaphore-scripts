#!/bin/bash

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
