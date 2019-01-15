#!/usr/bin/env Rscript

source("../../src/rethinking.R")

if (sys.nframe() == 0) {
    f <- alist(y ~ dnorm(mu, sigma), mu ~ dnorm(0, 10), sigma ~ dcauchy(0, 1))
    data = list(y=c(-1, 1))
    start = list(mu=0, sigma=1)
    fit_stan = map2stan(f, data=data, start=start, sample=FALSE)
    stancode(fit_stan)
}
