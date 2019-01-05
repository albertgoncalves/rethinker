#!/usr/bin/env bash

set -e

package="1.59.tar.gz"

if [ ! -e "$package" ]; then
    wget "https://github.com/albertgoncalves/rethinking/archive/$package"
fi

if [ ! -e "rethinking" ]; then
    R CMD INSTALL -l $(pwd) $package
fi
