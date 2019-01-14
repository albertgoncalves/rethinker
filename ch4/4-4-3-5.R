#!/usr/bin/env Rscript

source("../rethinking.R")

if (sys.nframe() == 0) {
    data(Howell1)
    adults = data.frame(Howell1[Howell1$age >= 18, ])

    flist = alist( height ~ dnorm(mu, sigma)
                 , mu <- alpha + (beta * weight)
                 , alpha ~ dnorm(178, 100)
                 , beta ~ dnorm(0, 10)
                 , sigma ~ dunif(0, 50)
                 )
    start = list( alpha=mean(adults$height)
                , beta=0
                , sigma=sd(adults$height)
                )
    model = map(flist, data=adults, start=start)

    weight_seq = seq(from=25, to=70, by=1)

    mu = link(model, data=data.frame(weight=weight_seq))
    mu_mean = apply(mu, 2, mean)
    mu_HPDI= apply(mu, 2, HPDI, prob=0.89)

    sim_height = sim(model, data=list(weight=weight_seq), n=2500)
    str(sim_height)

    height_PI = apply(sim_height, 2, PI, prob=0.89)

    plot(height ~ weight, adults, col=col.alpha(rangi2, 0.5))
    lines(weight_seq, mu_mean)
    shade(mu_HPDI, weight_seq)
    shade(height_PI, weight_seq)
}
