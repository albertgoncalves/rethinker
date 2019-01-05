#!/usr/bin/env bash

set -e

os=$(uname -s)

if [ $os == "Darwin" ]; then
    nix-shell darwin.nix
else
    nix-shell linux.nix
fi
