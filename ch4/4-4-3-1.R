#!/usr/bin/env Rscript

source("../src/rethinking.R")

plot_samples = function(data, n_data, n_samples) {
    data = data.frame(data[1:n_data, ])
    flist = alist( height ~ dnorm(mu, sigma)
                 , mu <- alpha + (beta * weight)
                 , alpha ~ dnorm(178, 100)
                 , beta ~ dnorm(0, 10)
                 , sigma ~ dunif(0, 50)
                 )
    start = list( alpha=mean(data$height)
                , beta=0
                , sigma=sd(data$height)
                )
    model = map(flist, data=data, start=start)
    post = extract.samples(model, n=n_samples)
    plot( data$weight
        , data$weight
        , xlim=range(data$weight)
        , ylim=range(data$height)
        , col="blue"
        , xlab="weight"
        , ylab="height"
        )
    mtext(concat("n = ", n_data))
    for (i in 1:n_samples) {
        abline(a=post$a[i], b=post$b[i], col=col.alpha("black", 0.3))
    }
}

if (sys.nframe() == 0) {
    data(Howell1)
    adults = data.frame(Howell1[Howell1$age >= 18, ])
    for (x in c(10, 50, 150, 350)) {
        plot_samples(adults, x, 20)
    }
}
