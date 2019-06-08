#!/usr/bin/env Rscript

source("../src/rethinking.R")

if (sys.nframe() == 0) {
    data(Howell1)
    adults = data.frame(Howell1[Howell1$age >= 18, ])
    # h(index i) ~ Normal(mu(index i), sigma) -> likelihood
    # mu(index i) = alpha + beta * x(index i) -> linear model
    # alpha ~ Normal(178, 100) -> prior
    # beta ~ Normal(0, 10) -> prior
    # sigma ~ Uniform(0, 50) -> prior
    local({
        flist = alist( height ~ dnorm(mu, sigma)
                     , mu <- alpha + (beta * weight)
                     , alpha ~ dnorm(178, 100)
                     , beta ~ dnorm(0, 10)
                     , sigma ~ dunif(0, 50)
                     )
        model = map(flist, data=adults)
        variance_matrix = vcov(model)
        xs = list( precis(model, corr=TRUE)
                 , coef(model)
                 , variance_matrix
                 , diag(variance_matrix)
                 , cov2cor(variance_matrix)
                 )
        for (x in xs) {
            print(x)
        }
    })
    local({
        weight = adults$weight
        weight_mean = mean(weight)
        weight_center <<- weight - weight_mean # alist needs global assignment
        flist = alist( height ~ dnorm(mu, sigma)
                     , mu <- alpha + (beta * weight_center)
                     , alpha ~ dnorm(178, 100)
                     , beta ~ dnorm(0, 10)
                     , sigma ~ dunif(0, 50)
                     )
        start = list( alpha=mean(adults$height)
                    , beta=0
                    , sigma=sd(adults$height)
                    )
        model = map(flist, data=adults, start=start)
        print(precis(model, corr=TRUE))
        model_coef = coef(model)
        plot(height ~ weight, data=adults, col="blue")
        abline( a=model_coef["alpha"] - weight_mean
              , b=model_coef["beta"]
              , lwd=2
              )
        post = extract.samples(model)
        print(head(post))
    })
}
