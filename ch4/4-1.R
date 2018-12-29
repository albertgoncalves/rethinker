#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../", getwd()))

add_norm = function(n) {
    obs = replicate(1000, sum(runif(n, -1, 1)))
    hist(obs, main=sprintf("n = %s", n))
    plot(density(obs), main=sprintf("n = %s", n))
}

multi_norm = function(n) return(replicate(10000, prod(1 + runif(12, 0, n))))

log_norm = function(n) return(replicate(10000, log(prod(1 + runif(12, 0, n)))))

if (sys.nframe() == 0) {
    for (n in c(4, 8, 16)) add_norm(n)
    for (growth in c(multi_norm, log_norm)) {
        for (n in c(0.1, 5)) dens(growth(n), norm.comp=TRUE)
    }
}
