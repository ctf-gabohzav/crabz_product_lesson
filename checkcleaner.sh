#!/usr/bin/env sh

ls /opt/build/workspace/ || mkdir -p /opt/build/workspace/

which cargo || aptitude install cargo -y

tar czvf /opt/build/last.tgz /opt/build/workspace/

rm -rf /opt/build/workspace/*
