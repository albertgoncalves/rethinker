#!/usr/bin/env bash

set -e

os=$(uname -s)

if [ $os == "Darwin" ]; then
    nix-shell src/darwin.nix
else
    nix-shell src/linux.nix
fi
