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

transparent = function(color, alpha) {
    return(adjustcolor(color, alpha.f=alpha))
}

color_ramp = function(colors, n) {
    return(colorRampPalette(colors)(n))
}

if (sys.nframe() == 0) {
    rn = function(n) {
        return(rnorm(n, 0, 10))
    }

    n = 5000
    x = rn(n)
    y = rn(n)
    z = order(x)
    plot_colors = color_ramp(c("lightsalmon2", "dodgerblue1"), n)
    shade_color = transparent("mediumvioletred", 0.15)

    plot(x[z], y[z], col=plot_colors)
    shade(x, y, col=shade_color)
}
