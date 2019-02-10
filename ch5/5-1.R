#!/usr/bin/env Rscript

source("../src/rethinking.R")

standardize = function(x) {
    return((x - mean(x)) / sd(x))
}

if (sys.nframe() == 0) {
    data(WaffleDivorce)
    d = WaffleDivorce

    # median age marriage -> mam
    d$mam_std = standardize(d$MedianAgeMarriage)
    d$marriage_std = standardize(d$Marriage)

    local({
        flist = alist( Divorce ~ dnorm(mu, sigma)
                     , mu <- alpha + (beta * mam_std)
                     , alpha ~ dnorm(10, 10)
                     , beta ~ dnorm(0, 1)
                     , sigma ~ dunif(0, 10)
                     )
        start = list(alpha=0, beta=0, sigma=1)
        model = map(flist, data=d, start=start)
        print(model)
        print(precis(model))

        mam_seq = seq(from=-3, to=3.5, length.out=30)
        mu = link(model, data=data.frame(mam_std=mam_seq))
        mu_PI = apply(mu, 2, PI)
        model_coef = coef(model)

        plot(Divorce ~ mam_std, data=d, col=rangi2)
        abline( a=model_coef["alpha"]
              , b=model_coef["beta"]
              )
        shade(mu_PI, mam_seq)
    })

    local({
        flist = alist( Divorce ~ dnorm(mu, sigma)
                     , mu <- alpha + (beta * marriage_std)
                     , alpha ~ dnorm(10, 10)
                     , beta ~ dnorm(0, 1)
                     , sigma ~ dunif(0, 10)
                     )
        start = list(alpha=0, beta=0, sigma=1)
        model = map(flist, data=d, start=start)
        print(model)
        print(precis(model))

        marriage_seq = seq(from=-3, to=3.5, length.out=30)
        mu = link(model, data=data.frame(marriage_std=marriage_seq))
        mu_PI = apply(mu, 2, PI)
        model_coef = coef(model)

        plot(Divorce ~ marriage_std, data=d, col=rangi2)
        abline( a=model_coef["alpha"]
              , b=model_coef["beta"]
              )
        shade(mu_PI, marriage_seq)
    })
}
