#!/bin/sh -x

# https://github.com/docker-library/ruby/issues/66
export BUNDLE_PATH=/usr/local/bundle
export BUNDLE_BIN=/usr/local/bundle/bin
export BUNDLE_APP_CONFIG=/usr/local/bundle/config

export USER_UID=`stat -c %u /insitu/Gemfile`
export USER_GID=`stat -c %g /insitu/Gemfile`

usermod -u $USER_UID insitu 2> /dev/null
groupmod -g $USER_GID insitu 2> /dev/null
usermod -g $USER_GID insitu 2> /dev/null

chown -R -h $USER_UID $BUNDLE_PATH 2> /dev/null
chgrp -R -h $USER_GID $BUNDLE_PATH 2> /dev/null

/usr/bin/sudo -EH -u insitu "$@"
