#!/usr/bin/env Rscript

library(MASS)
source("../src/rethinking.R")

extract_samples = function(model, n) {
    return(data.frame(mvrnorm(n=n, mu=coef(model), Sigma=vcov(model))))
}

if (sys.nframe() == 0) {
    data(Howell1)
    adults = data.frame(Howell1[Howell1$age >= 18, ])
    str(adults)
    n = 10000
    local({
        # h(index i) ~ Normal(mu, sigma) -> height ~ dnorm(mu, sigma)
        # mu ~ Normal(178, 20) -> mu ~ dnorm(178, 20)
        # sigma ~ Normal(0, 50) -> mu ~ dunif(0, 50)
        flist = alist( height ~ dnorm(mu, sigma)
                     , mu ~ dnorm(178, 20)
                     , sigma ~ dunif(0, 50)
                     )
        start = list(mu=mean(adults$height), sigma=sd(adults$height))
        model = map(flist, data=adults, start=start)
        variance_matrix = vcov(model)
        post = extract_samples(model, n)
        xs = list( precis(model)
                 , coef(model)
                 , variance_matrix
                 , diag(variance_matrix)
                 , cov2cor(variance_matrix)
                 , head(post)
                 , precis(post)
                 )
        for (x in xs) {
            print(x)
        }
        plot(post)
    })
    local({
        model = map( alist( height ~ dnorm(mu, exp(log_sigma))
                          , mu ~ dnorm(178, 20)
                          , log_sigma ~ dnorm(2, 10)
                          )
                   , data=adults
                   )
        post = extract_samples(model, n)
        sigma = exp(post$log_sigma)
        print(head(sigma))
        plot(post)
    })
}
