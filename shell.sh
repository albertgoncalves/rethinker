#!/usr/bin/env bash

set -e

if [ $(uname -s) = "Darwin" ]; then
    nix-shell src/darwin.nix
else
    nix-shell src/linux.nix
fi
