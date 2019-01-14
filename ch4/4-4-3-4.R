#!/usr/bin/env Rscript

source("../rethinking.R")

# link() by hand
link_simple = function(model_function, param_seq) {
    return(sapply(param_seq, model_function))
}

shade = function( object, lim, label=NULL, col=col.alpha("black", 0.15)
                , border=NA, ...) {
    if (missing(lim)) {
        stop("Interval limits missing.")
    } else if (missing(object)) {
        stop("No density or formula object.")
    }

    from = lim[1]
    to = lim[2]

    if (class(object) == "formula") {
        x1 = eval(object[[3]])
        y1 = eval(object[[2]])
        x = x1[x1 >= from & x1 <= to]
        y = y1[x1 >= from & x1 <= to]
    } else if (class(object) == "density") {
        x = object$x[object$x >= from & object$x <= to]
        y = object$y[object$x >= from & object$x <= to]
    } else if (class(object) == "matrix" & length(dim(object)) == 2) {
        y = c(object[1, ], object[2, ][ncol(object):1])
        x = c(lim, lim[length(lim):1])
    } else {
        error = paste( "Unable to handle object. Object must be formula,"
                     , "density, or 2-dimensional matrix."
                     )
        stop(error)
    }

    if (class(object) == "matrix") {
        polygon(x, y, col=col, border=border, ...)
    } else {
        polygon(c(x, to, from), c(y, 0, 0), col=col, border=border, ...)
    }

    if (!is.null(label)) {
        lx = mean(x)
        ly = max(y) / 2
        text(lx, ly, label)
    }
}

if (sys.nframe() == 0) {
    data(Howell1)
    adults = data.frame(Howell1[Howell1$age >= 18, ])

    flist = alist( height ~ dnorm(mu, sigma)
                 , mu <- alpha + (beta * weight)
                 , alpha ~ dnorm(178, 100)
                 , beta ~ dnorm(0, 10)
                 , sigma ~ dunif(0, 50)
                 )
    start = list( alpha=mean(adults$height)
                , beta=0
                , sigma=sd(adults$height)
                )
    model = map(flist, data=adults, start=start)

    n_samples = 10000
    post = extract.samples(model, n=n_samples)

    local({
        mu_at_50 = post$alpha + (post$beta * 50)
        dens(mu_at_50, col=rangi2, lwd=2, xlab="mu | weight=50")
        print(HPDI(mu_at_50, prob=0.89))
    })

    local({
        mu = link(model)
        str(mu)
    })

    local({
        weight_seq = seq(from=25, to=70, by=1)
        mu = link(model, data=data.frame(weight=weight_seq))
        str(mu)

        plot(height ~ weight, data=adults, type="n")

        for (i in 1:100) {
            points(weight_seq, mu[i, ], pch=16, col=col.alpha(rangi2, 0.1))
        }

        mu_mean = apply(mu, 2, mean) # compute mean of each column (axis 2)
        mu_HPDI = apply(mu, 2, HPDI, prob=0.89)

        for (x in list(mu_mean, mu_HPDI)) {
            print(x[1:5])
        }

        plot(height ~ weight, data=adults, col=col.alpha(rangi2, 0.5))
        lines(weight_seq, mu_mean)
        shade(mu_HPDI, weight_seq)
    })

    local({
        post = extract.samples(model)
        mu_link = function(weight) {
            post$alpha + (post$beta * weight)
        }
        weight_seq = seq(from=25, to=70, by=1)

        mu = link_simple(mu_link, weight_seq)
        str(mu)
    })
}
