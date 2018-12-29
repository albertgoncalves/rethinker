#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../", getwd()))

source("3-1.R")

if (sys.nframe() == 0) {
    set.seed(100)

    { # easy 1-7
        n = 1000
        p_grid = seq(from=0, to=1, length.out=n)
        prior = rep(1, n)
        likelihood = dbinom(6, size=9, prob=p_grid)
        posterior = std_posterior(likelihood * prior)
        samples = sample(p_grid, prob=posterior, size=n, replace=TRUE)

        print(mean(samples < 0.2))
        print(mean(samples > 0.8))
        print(mean(samples >= 0.2 & samples <= 0.8))
        print(quantile(samples, c(0.2, 1 - 0.2)))
        print(HPDI(samples, prob=0.66))
        print(PI(samples, prob=0.66))
    }

    {
        { # medium 1
            n = 10000
            p_grid = seq(from=0, to=1, length.out=n)
            prior = rep(1, n)
            likelihood = dbinom(8, size=15, prob=p_grid)
            posterior = std_posterior(likelihood * prior)

            # medium 2
            samples = sample(p_grid, prob=posterior, size=n, replace=TRUE)
            print(HPDI(samples, prob=0.9))

            { # medium 3
                post_predictive_check = rbinom(n, size=15, prob=samples)
                simplehist(post_predictive_check)
                print(mean(post_predictive_check == 8))
            }

            { # medium 4
                post_predictive_check = rbinom(n, size=9, prob=samples)
                simplehist(post_predictive_check)
                print(mean(post_predictive_check == 6))
            }
        }
        { # medium 5
            n = 10000
            p_grid = seq(from=0, to=1, length.out=n)
            prior = ifelse(p_grid < 0.5, 0, 1)
            likelihood = dbinom(8, size=15, prob=p_grid)
            posterior = std_posterior(likelihood * prior)
            samples = sample(p_grid, prob=posterior, size=n, replace=TRUE)

            print(HPDI(samples, prob=0.9))

            {
                t = 15
                s = 8
                post_predictive_check = rbinom(n, size=t, prob=samples)
                simplehist(post_predictive_check)
                print(mean(post_predictive_check == s))
                print(mean(rbinom(n, size=t, prob=0.7) == s))
            }

            {
                t = 9
                s = 6
                post_predictive_check = rbinom(n, size=t, prob=samples)
                simplehist(post_predictive_check)
                print(mean(post_predictive_check == s))
                print(mean(rbinom(n, size=t, prob=0.7) == s))
            }
        }
    }
}
