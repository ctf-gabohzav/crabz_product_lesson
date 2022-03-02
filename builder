#!/usr/bin/env sh

echo "starting build $(date +%Y%m%d%H%M%S)"
echo
source $HOME/.cargo/env
which cargo || exit 1
