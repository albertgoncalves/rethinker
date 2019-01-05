#!/usr/bin/env bash

set -e

. /Users/albert/miniconda3/etc/profile.d/conda.sh

env=$1

conda env list | grep "$env" >/dev/null

if (( ! $? == 0 )); then
    conda create -n renv -c r -c conda-forge r r-rstan r-coda r-loo r-mvtnorm
fi
