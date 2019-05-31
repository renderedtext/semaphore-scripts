#!/bin/bash


wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/nb/ruby-2.6.x-precompiled/semaphore-ruby-setup.sh
chmod +x semaphore-ruby-setup.sh

./semaphore-ruby-setup.sh 2.3.8
./semaphore-ruby-setup.sh 2.4.5
./semaphore-ruby-setup.sh 2.4.6
./semaphore-ruby-setup.sh 2.5.5
./semaphore-ruby-setup.sh 2.6.3

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb


wget https://chromedriver.storage.googleapis.com/74.0.3729.6/chromedriver_linux64.zip

unzip -uo chromedriver_linux64.zip

sudo mv chromedriver /usr/local/bin/chromedriver

rm -f chromedriver_linux64.zip

ls -lah


wget https://launchpad.net/~git-core/+archive/ubuntu/ppa/+files/git_2.21.0-0ppa1~ubuntu14.04.1_amd64.deb
wget https://launchpad.net/~git-core/+archive/ubuntu/ppa/+files/git-man_2.21.0-0ppa1~ubuntu14.04.1_all.deb

sudo dpkg -i git_2.21.0-0ppa1~ubuntu14.04.1_amd64.deb git-man_2.21.0-0ppa1~ubuntu14.04.1_all.deb

rm -f *.deb
