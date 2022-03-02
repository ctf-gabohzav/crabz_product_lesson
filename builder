#!/usr/bin/env sh

echo "starting build $(date +%Y%m%d%H%M%S)"
echo
$HOME/.cargo/bin/cargo build --release

