#!/usr/bin/env Rscript

source("../rethinking.R")

if (sys.nframe() == 0) {
    data(Howell1)
    adults = data.frame(Howell1[Howell1$age >= 18, ])
    str(adults)
    data = sample(adults$height, size=20)

    n = 10000
    n_list = 200
    mu_list = seq(from=150, to=170, length.out=n_list)
    sigma_list = seq(from=4, to=20, length.out=n_list)

    post = expand.grid(mu=mu_list, sigma=sigma_list)

    lambda = function(i) {
        return(sum(dnorm(data, mean=post$mu[i], sd=post$sigma[i], log=TRUE)))
    }

    post$LL = vapply(1:nrow(post), lambda, 0)

    post$prod = post$LL
        + dnorm(post$mu, 178, 20, TRUE)
        + dunif(post$sigma, 0, 50, TRUE)
    post$prob = exp(post$prod - max(post$prod))

    sample_rows = sample(1:nrow(post), size=n, replace=TRUE, prob=post$prob)
    sample_mu = post$mu[sample_rows]
    sample_sigma = post$sigma[sample_rows]

    plot( sample_mu
        , sample_sigma
        , cex=1.5
        , pch=16
        , col=col.alpha(rangi2, 0.1)
        )
    dens(sample_sigma, norm.comp=TRUE)
}
