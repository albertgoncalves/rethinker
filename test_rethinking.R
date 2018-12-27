#!/usr/bin/env Rscript

library(rethinking, lib.loc=getwd())

if (sys.nframe() == 0) {
    f = alist( y ~ dnorm(mu, sigma)
             , mu ~ dnorm(0, 10)
             , sigma ~ dcauchy(0, 1)
             )
    fit = map( f
             , data=list(y=c(-1, 1))
             , start=list(mu=0, sigma=1)
             )
    print(fit)
}
