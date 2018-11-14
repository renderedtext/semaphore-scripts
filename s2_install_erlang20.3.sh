#!/bin/bash
curl -H 'Host: packages.rt.com' --silent http://138.201.33.90/erlang/20.3.tar.gz --output 20.3.tar.gz
tar -zxf 20.3.tar.gz
rm -rf 20.3.tar.gz
mv 20.3 ~/.kerl/installs/
echo "20.3,20.3" >> ~/.kerl/otp_builds 
echo "20.3 /home/semaphore/.kerl/installs/20.3" >> ~/.kerl/otp_installations 
#activate version 20 in elixir env
sed -i 's/21/20/g' ~/.kiex/elixirs/elixir-1.7.3.env 
