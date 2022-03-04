#!/usr/bin/env sh

ls /opt/build/workspace/ || mkdir -p /opt/build/workspace/

tar czvf /opt/build/last.tgz /opt/build/workspace/

rm -rf /opt/build/workspace/*

exit 0
