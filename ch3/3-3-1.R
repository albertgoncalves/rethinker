#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../src/", getwd()))

dummy_w = function(n, size) return(rbinom(n, size=size, prob=0.7))

if (sys.nframe() == 0) {
    print(dbinom(0:2, size=2, prob=0.7))

    n = 10000
    print(table(dummy_w(n, 2)) / n)
    simplehist(dummy_w(n, 9), xlab="dummy water count")
}
