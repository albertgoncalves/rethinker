#!/usr/bin/env Rscript

source("../src/rethinking.R")

if (sys.nframe() == 0) {
    # medium 2
    local({
        flist = alist( y = dnorm(mu, sigma)
                     , mu = dnorm(0, 10)
                     , sigma = dunif(0, 10)
                     )
        d = NULL
        if (length(d) > 0) {
            model = map(flist, data=d)
        }
    })

    # medium 3
    # y ~ Normal(mu, sigma)
    # mu = a + b(x)
    # a ~ Normal(0, 50)
    # b ~ Uniform(0, 10)
    # sigma ~ Uniform(0, 50)

    data(Howell1)

    # hard 1
    local({
        d = data.frame(Howell1)
        print(summary(d))

        flist = alist( height ~ dnorm(mu, sigma)
                     , mu <- alpha + (beta * weight)
                     , alpha ~ dnorm(150, 50)
                     , beta ~ dnorm(0, 10)
                     , sigma ~ dunif(0, 50)
                     )
        start = list( alpha=mean(d$height)
                    , beta=0
                    , sigma=sd(d$height)
                    )
        model = map(flist, data=d, start=start)

        weight_seq = c(46.95, 43.72, 64.78, 32.59, 54.63)

        mu = link(model, data=data.frame(weight=weight_seq))
        mu_mean = apply(mu, 2, mean)
        mu_HPDI= apply(mu, 2, HPDI, prob=0.89)

        sim_height = sim(model, data=list(weight=weight_seq), n=2500)
        str(sim_height)
        print(summary(sim_height))

        height_PI = apply(sim_height, 2, PI, prob=0.89)
        print(height_PI)
    })

    # hard 2
    local({
        d = data.frame(Howell1[Howell1$age < 18, ])
        print(summary(d))

        flist = alist( height ~ dnorm(mu, sigma)
                     , mu <- alpha + (beta * weight)
                     , alpha ~ dnorm(100, 50)
                     , beta ~ dnorm(0, 10)
                     , sigma ~ dunif(0, 50)
                     )
        start = list( alpha=mean(d$height)
                    , beta=0
                    , sigma=sd(d$height)
                    )
        model = map(flist, data=d, start=start)

        weight_seq = seq(from=0, to=70, by=1)

        mu = link(model, data=data.frame(weight=weight_seq))
        mu_mean = apply(mu, 2, mean)

        plot(height ~ weight, d, col=col.alpha(rangi2, 0.5))
        lines(weight_seq, mu_mean)
    })

    # hard 3
    local({
        d = data.frame(Howell1[Howell1$age < 18, ])

        flist = alist( height ~ dnorm(mu, sigma)
                     , mu <- alpha + (beta * log(weight))
                     , alpha ~ dnorm(100, 50)
                     , beta ~ dnorm(0, 100)
                     , sigma ~ dunif(0, 50)
                     )
        start = list( alpha=mean(d$height)
                    , beta=0
                    , sigma=sd(d$height)
                    )
        model = map(flist, data=d, start=start)

        weight_seq = seq(from=0, to=70, by=1)

        mu = link(model, data=data.frame(weight=weight_seq))
        mu_mean = apply(mu, 2, mean)
        mu_HPDI = apply(mu, 2, HPDI, prob=0.89)

        sim_height = sim(model, data=list(weight=weight_seq), n=2500)

        height_PI = apply(sim_height, 2, PI, prob=0.89)

        plot(height ~ weight, d, col=col.alpha(rangi2, 0.5))
        lines(weight_seq, mu_mean)
        shade(mu_HPDI, weight_seq)
        shade(height_PI, weight_seq)
    })
}
