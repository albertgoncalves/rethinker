#!/usr/bin/env Rscript

source("../rethinking.R")

if (sys.nframe() == 0) {
    options(mc.cores=parallel::detectCores())

    data(chimpanzees)
    d = chimpanzees
    dat = list( y=d$pulled_left
               , prosoc=d$prosoc_left
               , condition=d$condition
               , N=nrow(d)
               )

    m1s_code = "
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

    m1s = stan(model_code=m1s_code, data=dat, chains=2, iter=2000)
    WAIC(m1s)
    LOO(m1s)
}
