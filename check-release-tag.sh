#!/bin/sh

NEW_TAG=`curl -s https://api.github.com/repos/deroproject/derohe/releases/latest \
| grep "\"tag_name\":" \
| cut -d : -f 2,3 \
| tr -d \"\,`

# if first time, set the environmental release tag
if [ -z "$DERO_RELEASE_TAG" ] # DERO_RELEASE_TAG is empty
then
 # log: starting up with dero relase: $NEW_TAG
 echo "$(date) $@" . ", starting with release: $(NEW_TAG)" >> $LOGFILE
 export DERO_RELEASE_TAG=$(echo $NEW_TAG)
fi

# otherwise, if the two do not match, shut down (forcing docker restart)
if [ "$DERO_RELEASE_TAG" != "$NEW_TAG" ] # DERO_RELEASE_TAG is empty
then
  # log: detected new release, restarting system
  echo "$(date) $@" . ", restarting. New release detected: $(NEW_TAG)" >> $LOGFILE
  poweroff
else
  ## remove after testing
  echo "$(date) $@" . ", checked release. Up to date: $(NEW_TAG)" >> $LOGFILE
fi

