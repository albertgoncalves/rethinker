#!/usr/bin/env Rscript

inject = function(f, xs) {
    return(do.call(deparse(substitute(f)), xs))
}

outline_2d = function(x, y) {
    m = matrix(c(x, y), ncol=2)
    ch = chull(m)
    return(m[c(ch, ch[1]), ])
}

shade = function(x, y, col, border=NA, ...) {
    if (length(dev.list()) > 0) {
        outline = outline_2d(x, y)
        polygon(outline, col=col, border=border, ...)
    }
}

normalize = function(x, lower, upper) {
    return((x - lower) / (upper - lower))
}

color_ramp = function(colors, v, alpha=1, max=255) {
    m = colorRamp(colors)(normalize(v, min(v), max(v)))
    c = rgb(m[, 1], m[, 2], m[, 3], maxColorValue=max)

    if ((alpha > 1) | (alpha <= 0)) {
        stop("\n alpha out of bounds\n 0.0 < alpha <= 1.0")
    } else if (alpha < 1) {
        c = adjustcolor(c, alpha.f=alpha)
    }

    return(c)
}

if (sys.nframe() == 0) {
    rn = function(n) {
        return(rnorm(n, 0, 10))
    }

    n = 2500
    x = rn(n)
    y = rn(n)

    kwargs =
        list( colors=list("lightsalmon2", "dodgerblue1", "mediumseagreen")
            , v=x
            , alpha=0.85
            )

    plot(x, y, col=inject(color_ramp, kwargs))
    shade(x, y, col=adjustcolor("mediumvioletred", alpha.f=0.05))
}
