#!/usr/bin/env Rscript

source("../src/rethinking.R")
source("3-1.R")

if (sys.nframe() == 0) {
    n = 50000
    p_grid = seq(from=0, to=1, length.out=n)

    post = posterior(n, p_grid)
    print(sum(post[p_grid < 0.5]))

    nn = 25000
    samples = posterior_samples(p_grid, post, nn)
    print(sum(samples < 0.5) / nn)
    print(sum(samples > 0.5 & samples < 0.75) / nn)

    print(quantile(samples, 0.8))
    print(quantile(samples, c(0.1, 0.9)))
}
