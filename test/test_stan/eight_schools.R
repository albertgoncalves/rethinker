#!/usr/bin/env Rscript

# via https://betanalpha.github.io/assets/case_studies/rstan_workflow.html

library(rstan)

if (sys.nframe() == 0) {
    rstan_options(auto_write=TRUE)
    options(mc.cores=parallel::detectCores())
    J = 8
    y = c(28, 8, -3, 7, -1, 1, 18, 12)
    sigma = c(15, 10, 16, 11, 9, 11, 10, 18)
    fn = "eight_schools"
    data_file = sprintf("%s.data.R", fn)
    stan_rdump(c("J", "y", "sigma"), file=data_file)
    data = read_rdump(data_file)
    fit = stan( file=sprintf("%s.stan", fn)
              , data=data
              , seed=194838
              , iter=4000
              , control=list(adapt_delta=0.9)
              )
    print(fit)
}
