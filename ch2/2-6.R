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

card_counter = function(n, cards, draw, partial, full) {
    draws = lapply(rep(NA, n), function(x) return(draw(cards)))
    partials = sapply(draws, function(x) return(partial(x)))
    fulls = sapply(draws, function(x) return(full(x)))
    return(sum(fulls) / sum(partials))
}

single_draw = function(cards, n) {
    draw = function(cards) {
        return(sample(cards[[sample(1:length(cards), 1)]]))
    }

    partial = function(card) {
        if (card[[1]] == 1)
            return(1)
        else
            return(0)
    }

    full = function(card) {
        if (identical(card, c(1, 1)))
            return(1)
        else
            return(0)
    }

    return(card_counter(n, cards, draw, partial, full))
}

medium4 = function(n) {
    cards = list(c(0, 0), c(0, 1), c(1, 1))
    return(single_draw(cards, n))
}

medium5 = function(n) {
    cards = list(c(0, 0), c(0, 1), c(1, 1), c(1, 1))
    return(single_draw(cards, n))
}

medium6 = function(n) {
    cards = list(c(0, 0), c(0, 0), c(0, 0), c(0, 1), c(0, 1), c(1, 1))
    return(single_draw(cards, n))
}

medium7 = function(n) {
    draw = function(cards) {
        l = length(cards)
        i = sample(1:l, 1)
        first_card = cards[[i]]
        remaining_cards = cards[-i]
        second_card = remaining_cards[[sample(1:(l - 1), 1)]]
        return(list(sample(first_card), sample(second_card)))
    }

    partial = function(draw) {
        first_card = draw[[1]]
        second_card = draw[[2]]
        if ((first_card[[1]] == 1) & (second_card[[1]] == 0))
            return(1)
        else
            return(0)
    }

    full = function(draw) {
        first_card = draw[[1]]
        second_card = draw[[2]]
        if (identical(first_card, c(1, 1)) & (second_card[[1]] == 0))
            return(1)
        else
            return(0)
    }

    cards = list(c(0, 0), c(0, 1), c(1, 1))
    return(card_counter(n, cards, draw, partial, full))
}

medium = function() {
    for (ex in c(medium1, medium2)) {
        obs = c( "c(1, 1, 1)"
               , "c(1, 1, 1, 0)"
               , "c(0, 1, 1, 0, 1, 1, 1)"
               )
        for (ob in obs) ex(ob)
    }

    print(medium3())

    n = 10000
    print(medium4(n))
    print(medium5(n))
    print(medium6(n))
    print(medium7(n))
}

hard = function() {
    prior = c(1, 1)
    likelihood = c(0.1, 0.2)

    hard1 = sum(posterior(likelihood, prior) * likelihood)
    hard2 = posterior(likelihood, prior)
    hard3 = posterior(1 - likelihood, hard2)

    vet_likelihood = c(0.8, 1 - 0.65)
    hard4 = posterior(posterior(vet_likelihood, prior), hard3)

    print(hard1)
    print(hard2)
    print(hard3)
    print(hard4)
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

    medium()
    hard()
}
