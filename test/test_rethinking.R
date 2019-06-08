#!/usr/bin/env Rscript

source("../src/rethinking.R")

if (sys.nframe() == 0) {
    options(mc.cores=parallel::detectCores())
    data(chimpanzees)
    d = chimpanzees
    data = list( y=d$pulled_left
               , prosoc=d$prosoc_left
               , condition=d$condition
               , N=nrow(d)
               )
    model_code = "
       data {
           int<lower=1> N;
           int y[N];
           int prosoc[N];
       }
       parameters {
           real a;
           real bP;
       }
       model {
           vector[N] p;
           bP ~ normal(0, 1);
           a ~ normal(0, 10);
           for (i in 1:N)
               p[i] = a + bP * prosoc[i];
           y ~ binomial_logit(1, p);
       }
       generated quantities {
           vector[N] p;
           vector[N] log_lik;
           for (i in 1:N) {
               p[i] = a + bP * prosoc[i];
               log_lik[i] = binomial_logit_log(y[i], 1, p[i]);
           }
       }
    "
    model = stan(model_code=model_code, data=data, chains=2, iter=2000)
    WAIC(model)
    LOO(model)
}
