#!/bin/bash
wget -q http://packages.semaphoreci.com/classic/ruby/2.4.5.tar.gz
tar -zxf 2.4.5.tar.gz  -C ~/.rbenv/versions/ >/dev/null 2>&1 && rbenv rehash
[ -e 2.4.5.tar.gz ] && rm -f 2.4.5.tar.gz
