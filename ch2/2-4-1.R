#!/usr/bin/env Rscript

posterior = function(likelihood, prior) {
    unstd.posterior = likelihood * prior
    posterior = unstd.posterior / sum(unstd.posterior)
    return(posterior)
}

if (sys.nframe() == 0) {
    n = 20
    p_grid = seq(from=0, to=1, length.out=n)
    likelihood = dbinom(6, size=9, prob=p_grid)
    priors = c( "rep(1, n)"
              , "ifelse(p_grid < 0.5, 0, 1)"
              , "exp(-5 * abs(p_grid - 0.5))"
              )
    for (prior in priors) {
        plot( p_grid
            , posterior(likelihood, eval(parse(text=prior)))
            , type="b"
            , xlab="probability of water"
            , ylab="posterior probability"
            )
        title(main=sprintf("prior = %s", prior))
        mtext(sprintf("%s points", n))
    }
}
