#!/usr/bin/env bash

###
# Usage:
# Add the following set of commands to the setup of a build in the Project Settings
#
#    sudo apt-get purge -y postgresql-client-* postgresql-* postgresql-contrib-* postgresql-server-dev-* libpq-dev
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/pg_setup.sh && bash pg_setup.sh
#
# First command will remove current PG version and its configuration.
# Last command will install PG 10 using this script and it will use the default port.
# Also, script is using our install-package tool for caching APT get packages.
#
# To install the needed PG extensions use option --extensions as first parametar
# and use , as a separator. Extension hstore will be installed by default, so it shouldn't be stated
#
#    sudo apt-get purge -y postgresql-client-* postgresql-* postgresql-contrib-* postgresql-server-dev-* libpq-dev
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/pg_setup.sh && bash pg_setup.sh --extensions btree_gist
#
# Note: reset your dependency cache in Project Settings > Admin, before running this script
###

set -e

case "$1" in
        '--extensions')
                IFS="," read -ra pg_extensions <<< $2

                shift
                shift
                ;;
esac

pg_extensions+=(hstore)
pg_version=${1:-"10"}

echo "Extensions to be installed: ${pg_extensions[@]}"

echo "Installing PostgreSQL version: $pg_version"

install-package --update libpq5 postgresql-client-$pg_version postgresql-$pg_version postgresql-contrib-$pg_version postgresql-server-dev-$pg_version libpq-dev postgresql-$pg_version-postgis-2.2
echo 'allow_system_table_mods = on' | sudo tee -a /etc/postgresql/10/main/postgresql.conf
sudo service postgresql restart

sudo su postgres <<CMD
set -x
psql -c "ALTER USER postgres" -d template1;
psql -c "CREATE USER runner WITH PASSWORD 'semaphoredb';" -d template1;
psql -c "ALTER USER runner CREATEDB" -d template1;
for ext in ${pg_extensions[@]}; do
    psql -c "CREATE EXTENSION \$ext WITH SCHEMA pg_catalog;" -d template1;
done
CMD
