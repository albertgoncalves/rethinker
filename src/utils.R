#!/usr/bin/env Rscript

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

color_ramp = function(colors, z, alpha=1, max=255) {
    rgbs = colorRamp(plot_colors)(normalize(z, min(z), max(z)))
    colors = rgb(rgbs[, 1], rgbs[, 2], rgbs[, 3], maxColorValue=max)

    if ((alpha > 1) | (alpha <= 0)) {
        stop("\n alpha out of bounds\n 0.0 < alpha <= 1.0")
    } else if (alpha < 1) {
        colors = adjustcolor(colors, alpha.f=alpha)
    }

    return(colors)
}

if (sys.nframe() == 0) {
    rn = function(n) {
        return(rnorm(n, 0, 10))
    }

    n = 2500
    x = rn(n)
    y = rn(n)

    plot_colors = c("lightsalmon2", "dodgerblue1", "green")
    shade_color = adjustcolor("mediumvioletred", alpha.f=0.05)

    plot(x, y, col=color_ramp(colors, x, alpha=0.85))
    shade(x, y, col=shade_color)
}
