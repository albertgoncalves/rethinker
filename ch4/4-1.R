#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../src/", getwd()))

add_norm = function(m, n) {
    obs = replicate(m, sum(runif(n, -1, 1)))
    hist(obs, main=sprintf("n = %s", n))
    plot(density(obs), main=sprintf("n = %s", n))
}

multi_norm = function(m, n) {
    return(replicate(m, prod(1 + runif(12, 0, n))))
}

log_norm = function(m, n) {
    return(replicate(m, log(prod(1 + runif(12, 0, n)))))
}

if (sys.nframe() == 0) {
    m = 10000

    for (n in c(4, 8, 16)) {
        add_norm(m, n)
    }

    for (f in c(multi_norm, log_norm)) {
        for (n in c(0.1, 5)) {
            dens(f(m, n), norm.comp=TRUE)
        }
    }
}
