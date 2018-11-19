#!/bin/bash

####
# Description: Installs specified Meteor version and cache its installation on Semaphore so the future
# installations are faster.
#
# Runs on: all Semaphore platforms
#
# Usage:
# Add the following command to the setup of a build in the Project Settings
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/cache-meteor.sh && bash cache-meteor.sh <meteor-version>
#
# For example, the following command will install Ruby 1.7.0.1 and cache its installation on Semaphore
#
#    wget https://raw.githubusercontent.com/renderedtext/semaphore-scripts/master/cache-meteor.sh && bash cache-meteor.sh 1.7.0.1
#
# Note: This script is based on original Meteor install script.
####

set -e

METEOR_RELEASE=${1:-'1.7.0.1'}
PLATFORM="os.linux.x86_64"
TARBALL_URL="https://static-meteor.netdna-ssl.com/packages-bootstrap/${METEOR_RELEASE}/meteor-bootstrap-${PLATFORM}.tar.gz"
INSTALL_TMPDIR="$HOME/.meteor-install-tmp"
TARBALL_FILE="$SEMAPHORE_CACHE_DIR/meteor-${METEOR_RELEASE}.tar.gz"

# Download
if ! [ -e $TARBALL_FILE ]
then
  curl -o $TARBALL_FILE -L $TARBALL_URL
fi

# Extract/move
# If you already have a tropohouse/warehouse, we do a clean install here:
if [ -e "$HOME/.meteor" ]; then
  echo "Removing your existing Meteor installation."
  rm -rf "$HOME/.meteor"
fi

echo "Removing existing Meteor installation files."
rm -rf "$INSTALL_TMPDIR"
mkdir "$INSTALL_TMPDIR"

# Extract Meteor archive
tar -xzf "$TARBALL_FILE" -C "$INSTALL_TMPDIR" -o

mv "${INSTALL_TMPDIR}/.meteor" "$HOME"

METEOR_SYMLINK_TARGET="$(readlink "$HOME/.meteor/meteor")"
METEOR_TOOL_DIRECTORY="$(dirname "$METEOR_SYMLINK_TARGET")"
LAUNCHER="$HOME/.meteor/$METEOR_TOOL_DIRECTORY/scripts/admin/launch-meteor"

if cp "$LAUNCHER" "$PREFIX/bin/meteor" >/dev/null 2>&1; then
  echo "Writing a launcher script to $PREFIX/bin/meteor for your convenience."
  cat <<"EOF"

To get started fast:

  $ meteor create ~/my_cool_app
  $ cd ~/my_cool_app
  $ meteor

Or see the docs at:

  docs.meteor.com

EOF
elif type sudo >/dev/null 2>&1; then
  echo "Writing a launcher script to $PREFIX/bin/meteor for your convenience."
  echo "This may prompt for your password."

  # New macs (10.9+) don't ship with /usr/local, however it is still in
  # the default PATH. We still install there, we just need to create the
  # directory first.
  # XXX this means that we can run sudo too many times. we should never
  #     run it more than once if it fails the first time
  if [ ! -d "$PREFIX/bin" ] ; then
      sudo mkdir -m 755 "$PREFIX" || true
      sudo mkdir -m 755 "$PREFIX/bin" || true
  fi

  if sudo cp "$LAUNCHER" "$PREFIX/bin/meteor"; then
    cat <<"EOF"

To get started fast:

  $ meteor create ~/my_cool_app
  $ cd ~/my_cool_app
  $ meteor

Or see the docs at:

  docs.meteor.com

EOF
  else
    cat <<EOF

Couldn't write the launcher script. Please either:

  (1) Run the following as root:
        cp "$LAUNCHER" /usr/bin/meteor
  (2) Add "\$HOME/.meteor" to your path, or
  (3) Rerun this command to try again.

Then to get started, take a look at 'meteor --help' or see the docs at
docs.meteor.com.
EOF
  fi
else
  cat <<EOF

Now you need to do one of the following:

  (1) Add "\$HOME/.meteor" to your path, or
  (2) Run this command as root:
        cp "$LAUNCHER" /usr/bin/meteor

Then to get started, take a look at 'meteor --help' or see the docs at
docs.meteor.com.
EOF
fi

# Print out the version
meteor --version
