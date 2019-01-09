#!/usr/bin/env Rscript

library(rethinking, lib.loc=sprintf("%s/../src/", getwd()))

source("2-4-1.R")

if (sys.nframe() == 0) {
    # easy 1-3
    # the probability of rain on Monday = Pr(rain|Monday)

    # Pr(Monday|rain) = probability of Monday given rain

    # the probability that it is Monday, given that it is raining =
        # Pr(Monday|rain)
        # (Pr(rain|Monday) * Pr(Monday)) / Pr(rain)

    { # medium 1-2
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

        observations= c( "c(1, 1, 1)"
                       , "c(1, 1, 1, 0)"
                       , "c(0, 1, 1, 0, 1, 1, 1)"
                       )

        flat_prior = function(p_grid) {
            return(rep(1, length(p_grid)))
        }

        step_prior = function(p_grid) {
            return(ifelse(p_grid < 0.5, 0, 1))
        }

        for (prior in list(flat_prior, step_prior)) {
            for (obs in observations) {
                plot_posterior(prior, obs)
            }
        }
    }

    { # medium 3
        prior = c(0.3, 1.0)
        globe_odds = c(1, 1) # each globe equally likely to be tossed
        likelihood = sum(prior * globe_odds)
        print(posterior(likelihood, prior))
    }

    { # medium 4-7
        counter = function(n, cards, draw, candidate, match) {
            draws = lapply(rep(NA, n), function(x) return(draw(cards)))
            candidates = vapply(draws, function(x) return(candidate(x)), 0)
            matches = vapply(draws, function(x) return(match(x)), 0)
            return(sum(matches) / sum(candidates))
        }

        { # medium 4-6
            draws = function(cards, n) {
                draw = function(cards) {
                    return(sample(cards[[sample(1:length(cards), 1)]]))
                }

                candidate = function(card) {
                    if (card[[1]] == 1) {
                        return(1)
                    } else {
                        return(0)
                    }
                }

                match = function(card) {
                    if (identical(card, c(1, 1))) {
                        return(1)
                    } else {
                        return(0)
                    }
                }

                return(counter(n, cards, draw, candidate, match))
            }

            n = 10000
            # medium 4
            print(draws(list(c(0, 0), c(0, 1), c(1, 1)), n))

            # medium 5
            print(draws(list(c(0, 0), c(0, 1), c(1, 1), c(1, 1)), n))

            # medium 6
            print(draws(list( c(0, 0)
                            , c(0, 0)
                            , c(0, 0)
                            , c(0, 1)
                            , c(0, 1)
                            , c(1, 1)
                            ), n))
        }

        { # medium 7
            draws = function(cards, n) {
                draw = function(cards) {
                    l = length(cards)
                    i = sample(1:l, 1)
                    first_card = cards[[i]]
                    remaining_cards = cards[-i]
                    second_card = remaining_cards[[sample(1:(l - 1), 1)]]
                    return(list(sample(first_card), sample(second_card)))
                }

                candidate = function(draw) {
                    one_side_black = draw[[1]][[1]] == 1
                    one_side_white = draw[[2]][[1]] == 0

                    if (one_side_black & one_side_white) {
                        return(1)
                    } else {
                        return(0)
                    }
                }

                match = function(draw) {
                    both_sides_black = identical(draw[[1]], c(1, 1))
                    one_side_white = draw[[2]][[1]] == 0

                    if (both_sides_black & one_side_white) {
                        return(1)
                    } else {
                        return(0)
                    }
                }

                return(counter(n, cards, draw, candidate, match))
            }

            cards = list(c(0, 0), c(0, 1), c(1, 1))
            print(draws(cards, n))
        }
    }

    { # hard 1-3
        prior = c(1, 1)
        likelihood = c(0.1, 0.2)

        # hard 1
        print(sum(posterior(likelihood, prior) * likelihood))

        # hard 2
        print(posterior(likelihood, prior))

        # hard 3
        print(posterior(1 - likelihood, posterior(likelihood, prior)))
    }

    { # hard 4
        prior = c(1, 1)
        orig_likelihood = c(0.1, 0.2)
        vet_likelihood = c(0.8, 1 - 0.65)
        update = posterior( 1 - orig_likelihood
                          , posterior(orig_likelihood, prior)
                          )
        print(posterior(posterior(vet_likelihood, prior), update))
    }
}
