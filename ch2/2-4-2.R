#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../", getwd()))

if (sys.nframe() == 0) {
    globe.qa = map( alist( w ~ dbinom(9, p) # binomial likelihood
                         , p ~ dunif(0, 1)  # uniform prior
                         )
                  , data=list(w=6)
                  )
    print(precis(globe.qa))
}
