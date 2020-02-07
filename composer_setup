#!/bin/bash

php_version="$(php -v | head -n1|awk '{print $2}')"
bin_path="/home/semaphore/.phpbrew/php/php-$php_version/bin"

wget https://getcomposer.org/composer.phar 
mv composer.phar "$bin_path/"
echo '#!/usr/bin/env bash' > $bin_path/composer
echo "/home/semaphore/.phpbrew/php/php-$php_version/bin/php /home/semaphore/.phpbrew/php/php-$php_version/bin/composer.phar \$@" >> $bin_path/composer
chmod +x $bin_path/composer
