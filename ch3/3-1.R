#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../", getwd()))

std_posterior = function(posterior) return(posterior / sum(posterior))

posterior = function(n, p_grid) {
    prior = rep(1, n)
    likelihood = dbinom(6, size=9, prob=p_grid)
    return(std_posterior(likelihood * prior))
}

posterior_samples = function(p_grid, posterior, n) {
    samples = sample(p_grid, prob=posterior, size=n, replace=TRUE)
    return(samples)
}

if (sys.nframe() == 0) {
    n = 50000
    p_grid = seq(from=0, to=1, length.out=n)
    samples = posterior_samples(p_grid, posterior(n, p_grid), 25000)
    plot(samples)
    dens(samples)
}
