#!/usr/bin/env Rscript

source("../src/rethinking.R")
source("3-1.R")

if (sys.nframe() == 0) {
    n = 50000
    nn = as.integer(n / 2)
    p_grid = seq(from=0, to=1, length.out=n)
    prior = rep(1, n)
    likelihood = dbinom(3, size=3, prob=p_grid)
    posterior = std_posterior(likelihood * prior)
    samples = posterior_samples(p_grid, posterior, nn)
    print(PI(samples, prob=0.5))
    print(HPDI(samples, prob=0.5))
}
