#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../src/", getwd()))

source("3-1.R")

loss_f = function(posterior, p_grid) {
    f = function(d) {
        return(sum(posterior * abs(d - p_grid)))
    }

    return(f)
}

if (sys.nframe() == 0) {
    n = 25000
    nn = 10000

    p_grid = seq(from=0, to=1, length.out=n)
    prior = rep(1, n)
    likelihood = dbinom(3, size=3, prob=p_grid)

    posterior = std_posterior(likelihood * prior)
    samples = posterior_samples(p_grid, posterior, nn)

    print(p_grid[which.max(posterior)])
    print(chainmode(samples, adj=0.01))
    print(mean(samples))
    print(median(samples))

    print(sum(posterior * abs(0.5 - p_grid)))

    loss = vapply(p_grid, loss_f(posterior, p_grid), 0)
    print(p_grid[which.min(loss)])
}
