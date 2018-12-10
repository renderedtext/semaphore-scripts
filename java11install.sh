#!/bin/bash
#downloading from Oracle
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.tar.gz
tar -zxvf jdk-*
#move into place
sudo mv jdk-11.0.1 /usr/lib/
#install
sudo update-alternatives --install /usr/bin/java java /usr/lib/jdk-11.*/bin/java  1111
#select default
version_info=$(echo -e '\n' | update-alternatives --config java | grep 1111.*manual | sed 's/*//')
option_number=$(echo $version_info | awk '{print $1}')
java_home_path=$(echo $version_info | awk '{print $2}' | grep -oP '/usr/lib/jdk[^/]*')

echo $option_number | sudo update-alternatives --config java > /dev/null 2>&1
echo $option_number | sudo update-alternatives --config javac > /dev/null 2>&1

export JAVA_HOME="$java_home_path"

#verify java version
java -version

