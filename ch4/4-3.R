#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../src/", getwd()))

if (sys.nframe() == 0) {
    data(Howell1)
    adults = Howell1[Howell1$age >= 18, ]
    str(adults)
    dens(adults$height)

    mu_mu = 178
    mu_sigma = 20
    sigma_lower = 0
    sigma_upper = 50
    n = 10000

    {
        curve(dnorm(x, mu_mu, mu_sigma), from=100, to=250)
        curve(dunif(x, sigma_lower, sigma_upper), from=-10, to=60)

        mu = rnorm(n, mu_mu, mu_sigma)
        sigma = runif(n, sigma_lower, sigma_upper)
        prior = rnorm(n, mu, sigma)
        dens(prior)
    }

    {
        mu_list = seq(from=153, to=156, length.out=500)
        sigma_list = seq(from=6.75, to=8.75, length.out=500)

        post = expand.grid(mu=mu_list, sigma=sigma_list)
        post$LL = vapply( 1:nrow(post)
                        , function(i) return(sum(dnorm( adults$height
                                                      , mean=post$mu[i]
                                                      , sd=post$sigma[i]
                                                      , log=TRUE
                                                      )))
                        , 0
                        )
        post$prod = post$LL
            + dnorm(post$mu, mu_mu, mu_sigma, TRUE)
            + dunif(post$sigma, sigma_lower, sigma_upper, TRUE)
        post$prob = exp(post$prod - max(post$prod))

        for (f in c(contour_xyz, image_xyz))
            f(post$mu, post$sigma, post$prob)

        sample_rows = sample( 1:nrow(post)
                            , size=n
                            , replace=TRUE
                            , prob=post$prob
                            )
        sample_mu = post$mu[sample_rows]
        sample_sigma = post$sigma[sample_rows]

        plot( sample_mu
            , sample_sigma
            , cex=1.5
            , pch=16
            , col=col.alpha(rangi2, 0.1)
            )

        printHPDI = function(x) return(print(HPDI(x)))
        for (s in list(sample_mu, sample_sigma))
            for (f in list(dens, printHPDI))
                f(s)
    }
}
