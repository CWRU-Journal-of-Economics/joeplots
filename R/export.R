.joe_sizes <- list(
  web = c(width = 8, height = 5, dpi = 300),
  web_wide = c(width = 8, height = 4.5, dpi = 300),
  web_tall = c(width = 8, height = 6, dpi = 300),
  print = c(width = 7.5, height = 4.6875, dpi = 400),
  social = c(width = 6, height = 7.5, dpi = 300)
)

joe_chart_size <- function(format = c("web", "web_wide", "web_tall", "print", "social")) {
  format <- match.arg(format)
  x <- .joe_sizes[[format]]
  list(
    format = format,
    width = x["width"],
    height = x["height"],
    dpi = x["dpi"],
    pixel_width = round(x["width"] * x["dpi"]),
    pixel_height = round(x["height"] * x["dpi"])
  )
}

add_joe_footer <- function(plot, source = NULL, note = NULL, base_family = "sans") {
  bits <- c(if (!is.null(source)) paste0("Source: ", source), if (!is.null(note)) paste0("Note: ", note))
  if (!length(bits)) return(plot)
  footer <- cowplot::ggdraw()
  footer <- footer + cowplot::draw_text(
    paste(bits, collapse = " | "),
    x = .01,
    y = .5,
    hjust = 0,
    size = 9,
    colour = joe_palette["gray"],
    family = base_family
  )
  cowplot::plot_grid(plot, footer, ncol = 1, rel_heights = c(1, .1))
}

save_joe <- function(plot, filename, format = c("web", "web_wide", "web_tall", "print", "social"), source = NULL, note = NULL, width = NULL, height = NULL, dpi = NULL, base_family = "sans", ...) {
  format <- match.arg(format)
  s <- joe_chart_size(format)
  width <- if (is.null(width)) s$width else width
  height <- if (is.null(height)) s$height else height
  dpi <- if (is.null(dpi)) s$dpi else dpi
  if (!is.null(source) || !is.null(note)) {
    plot <- add_joe_footer(plot, source, note, base_family)
  }
  device <- if (tolower(tools::file_ext(filename)) == "png") {
    ragg::agg_png
  } else {
    NULL
  }
  ggplot2::ggsave(filename, plot, width = width, height = height, units = "in", dpi = dpi, bg = "white", device = device, ...)
  invisible(normalizePath(filename, mustWork = FALSE))
}
