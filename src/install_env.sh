#!/usr/bin/env bash

env=$1

. ~/miniconda3/etc/profile.d/conda.sh

conda env list | grep $env >/dev/null

if (( ! $? == 0 )); then
    conda create \
        -n $env \
        -c r -c conda-forge \
        r r-rstan r-coda r-loo r-mvtnorm
fi
