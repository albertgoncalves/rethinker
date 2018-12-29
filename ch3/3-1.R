#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../", getwd()))

std_posterior = function(posterior) return(posterior / sum(posterior))

if (sys.nframe() == 0) {
    p_grid = seq(from=0, to=1, length.out=1000)
    prior = rep(1, 1000)
    likelihood = dbinom(6, size=9, prob=p_grid)
    posterior = std_posterior(likelihood * prior)
    samples = sample(p_grid, prob=posterior, size=1e4, replace=TRUE)
    plot(samples)
    dens(samples)
}
