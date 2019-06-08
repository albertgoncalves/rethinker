#!/usr/bin/env Rscript

source("../src/rethinking.R")

if (sys.nframe() == 0) {
    xlab = "proportion water"
    ylab = "density"
    ac = "analytical calculation"
    w = 6
    n = 9
    curve(dbeta(x, w + 1, n - w + 1), from=0, to=1, xlab=xlab, ylab=ylab)
    qa = "quadratic approximation"
    globe.qa = map( alist( w ~ dbinom(9, p) # binomial likelihood
                         , p ~ dunif(0, 1)  # uniform prior
                         )
                  , data=list(w=6)
                  )
    cat(sprintf("%s\n", qa))
    print(precis(globe.qa))
    curve(dnorm(x, 0.67, 0.16), lty=2, add=TRUE)
    legend(0.05, 2.5, legend=c(ac, qa), lty=1:2, cex=0.8)
}
