#!/usr/bin/env bash

set -e

package="1.59.tar.gz"

wget "https://github.com/albertgoncalves/rethinking/archive/$package"
nix-shell ./shell.nix --run "R CMD INSTALL -l $(pwd) $package"
