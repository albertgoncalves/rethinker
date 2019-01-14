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

normalize = function(x, ...) {
    return((x - min(x, ...)) / (max(x, ...) - min(x, ...)))
}

lrgb = function(list_rgb, max=255) {
    r = list_rgb[[1]]
    g = list_rgb[[2]]
    b = list_rgb[[3]]
    return(rgb(r, g, b, maxColorValue=max))
}

color_ramp = function(colors, z) {
    return(sapply(lapply(normalize(z), colorRamp(plot_colors)), lrgb))
}

if (sys.nframe() == 0) {
    rn = function(n) {
        return(rnorm(n, 0, 10))
    }

    n = 2500
    x = rn(n)
    y = rn(n)

    plot_colors = c("lightsalmon2", "dodgerblue1", "green")
    shade_color = transparent("mediumvioletred", 0.05)

    plot(x, y, col=color_ramp(colors, x))
    shade(x, y, col=shade_color)
}
