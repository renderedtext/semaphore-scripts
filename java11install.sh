#!/bin/bash
#downloading from Oracle
wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" https://download.oracle.com/otn-pub/java/jdk/11.0.1+13/90cf5d8f270a4347a95050320eef3fb7/jdk-11.0.1_linux-x64_bin.tar.gz
tar -zxvf jdk-*
#move into place
sudo mv jdk-11.0.1 /usr/lib/
#install
sudo update-alternatives --install /usr/bin/java java /usr/lib/jdk-11.*/bin/java  1111
#select default
sudo update-alternatives --config java
#verify java version
java -version
