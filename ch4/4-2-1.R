#!/usr/bin/env Rscript

source("../src/rethinking.R")

posterior_samples = function(p_grid, posterior, n) {
    samples = sample(p_grid, prob=posterior, size=n, replace=TRUE)
    return(samples)
}

if (sys.nframe() == 0) {
    w = 6
    n = 9
    m = 10000
    p_grid = seq(from=0, to=1, length.out=m)
    # w ~ Binomial(n, p)
    # p ~ Uniform(0, 1)
    posterior = dbinom(w, n, p_grid) * dunif(p_grid, 0, 1)
    samples = posterior_samples(p_grid, posterior / sum(posterior), m)
    plot(samples)
    dens(samples)
}
