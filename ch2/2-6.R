#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../", getwd()))

source("2-4-1.R")

plot_posterior = function(prior_f, obs) {
    n = 20
    p_grid = seq(from=0, to=1, length.out=n)

    prior = prior_f(p_grid)
    x = eval(parse(text=obs))
    likelihood = dbinom(sum(x), size=length(x), prob=p_grid)

    plot( p_grid
        , posterior(likelihood, prior)
        , type="b"
        , xlab="probability of water"
        , ylab="posterior probability"
        )
    title(main=sprintf("obs = %s", obs))
}

medium1 = function(obs) {
    prior_f = function(p_grid) return(rep(1, length(p_grid)))
    return(plot_posterior(prior_f, obs))
}

medium2 = function(obs) {
    prior_f = function(p_grid) return(ifelse(p_grid < 0.5, 0, 1))
    return(plot_posterior(prior_f, obs))
}

medium3 = function() {
    # Posterior = (Likelihood * Prior) / Average Likelihood
    p_land = c(0.3, 1.0)
    equal_weight = rep(1 / length(p_land), length(p_land))
    prior = p_land * (1 / equal_weight)
    likelihood = sum(p_land * equal_weight)
    return(posterior(likelihood, prior))
}

medium4 = function() {
    cards = list(c(0, 0), c(0, 1), c(1, 1))
    draw = function (cards) {
        card = cards[[sample(1:length(cards), 1)]]
        if (card[[2]] == 1)
            return(1)
        else
            return(0)
    }
    n = 50000
    return(mean(sapply(rep(NA, n), function(x) return(draw(cards)))))
}

if (sys.nframe() == 0) {
    # easy1
    # the probability of rain on Monday = Pr(rain|Monday)

    # easy2
    # Pr(Monday|rain) = probability of Monday given rain

    # easy3
    # the probability that it is Monday, given that it is raining =
        # Pr(Monday|rain)
        # (Pr(rain|Monday) * Pr(Monday)) / Pr(rain)

    for (ex in c(medium1, medium2)) {
        obs = c( "c(1, 1, 1)"
               , "c(1, 1, 1, 0)"
               , "c(0, 1, 1, 0, 1, 1, 1)"
               )
        for (ob in obs) ex(ob)
    }
    print(medium3())
    print(medium4())
}
