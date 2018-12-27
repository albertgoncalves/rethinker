#!/usr/bin/env bash

set -e

package="1.59.tar.gz"

wget "https://github.com/rmcelreath/rethinking/archive/$package"
nix-shell --run "R CMD INSTALL -l $(pwd) $package"
