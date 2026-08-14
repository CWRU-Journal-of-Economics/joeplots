.joe_sizes <- list(
  web = c(width = 8, height = 5, dpi = 200),
  web_wide = c(width = 8, height = 4.5, dpi = 200),
  web_tall = c(width = 8, height = 6, dpi = 200),
  print = c(width = 7.5, height = 4.6875, dpi = 300),
  social = c(width = 6, height = 7.5, dpi = 180)
)

joe_chart_size <- function(format = c("web", "web_wide", "web_tall", "print", "social")) {
  format <- match.arg(format); x <- .joe_sizes[[format]]
  list(format = format, width = x["width"], height = x["height"], dpi = x["dpi"],
       pixel_width = round(x["width"] * x["dpi"]), pixel_height = round(x["height"] * x["dpi"]))
}

.joe_logo <- function() {
  x <- png::readPNG(system.file("extdata", "joe-logo.png", package = "joeplots"))
  if (length(dim(x)) == 3L && dim(x)[3] >= 4L) {
    a <- x[, , 4]; rr <- which(rowSums(a > .01) > 0); cc <- which(colSums(a > .01) > 0)
    x <- x[min(rr):max(rr), min(cc):max(cc), , drop = FALSE]
  }
  x
}

add_joe_footer <- function(plot, source = NULL, note = NULL, logo = TRUE, base_family = "sans") {
  bits <- c(if (!is.null(source)) paste0("Source: ", source), if (!is.null(note)) paste0("Note: ", note))
  footer <- cowplot::ggdraw()
  if (length(bits)) footer <- footer + cowplot::draw_text(paste(bits, collapse = " | "), x = .01, y = .5, hjust = 0, size = 9, colour = joe_palette["gray"], family = base_family)
  if (logo) footer <- footer + cowplot::draw_grob(grid::rasterGrob(.joe_logo(), interpolate = TRUE), x = .93, y = .05, width = .06, height = .9)
  cowplot::plot_grid(plot, footer, ncol = 1, rel_heights = c(1, .1))
}

save_joe <- function(plot, filename, format = c("web", "web_wide", "web_tall", "print", "social"), source = NULL, note = NULL, logo = TRUE, width = NULL, height = NULL, dpi = NULL, ...) {
  format <- match.arg(format); s <- joe_chart_size(format)
  width <- if (is.null(width)) s$width else width; height <- if (is.null(height)) s$height else height; dpi <- if (is.null(dpi)) s$dpi else dpi
  if (logo || !is.null(source) || !is.null(note)) plot <- add_joe_footer(plot, source, note, logo)
  device <- if (tolower(tools::file_ext(filename)) == "png" && requireNamespace("ragg", quietly = TRUE)) ragg::agg_png else NULL
  ggplot2::ggsave(filename, plot, width = width, height = height, units = "in", dpi = dpi, bg = "white", device = device, ...)
  invisible(normalizePath(filename, mustWork = FALSE))
}
