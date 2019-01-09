#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../src/", getwd()))

source("3-1.R")

samples = function(n) {
    p_grid = seq(from=0, to=1, length.out=n)
    prior = rep(1, n)
    likelihood = dbinom(6, size=9, prob=p_grid)
    posterior = std_posterior(likelihood * prior)
    return(posterior_samples(p_grid, posterior, n))
}

if (sys.nframe() == 0) {
    n = 10000
    w = rbinom(n, size=9, prob=samples(n))
    simplehist(w, xlab="posterior predictive distribution")
}
