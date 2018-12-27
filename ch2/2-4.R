#!/usr/bin/env Rscript

posterior = function(p_grid, prior) {
    likelihood = dbinom(6, size=9, prob=p_grid)
    unstd.posterior = likelihood * prior
    posterior = unstd.posterior / sum(unstd.posterior)
    return(posterior)
}

if (sys.nframe() == 0) {
    p_grid = seq(from =0, to=1, length.out=20)
    priors = c( "rep(1, 20)"
              , "ifelse(p_grid < 0.5, 0, 1)"
              , "exp(-5 * abs(p_grid - 0.5))"
              )
    for (prior in priors) {
        plot( p_grid
            , posterior(p_grid, eval(parse(text=prior)))
            , type="b"
            , xlab="probability of water"
            , ylab="posterior probability"
            )
        title(main=sprintf("prior = %s", prior))
        mtext("20 points")
    }
}
