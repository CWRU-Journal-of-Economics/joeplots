joe_palette <- c(
  bright_blue = "#2F6DB3", navy = "#112F52", steel_blue = "#3F5F7A",
  light_blue = "#8FAFCA", sand = "#E6D3B3", medium_orange = "#D49A73",
  muted_rust = "#C07A5A", muted_teal = "#7FA7A3",
  pale_bluegreen = "#D6E3DD", light_gray = "#C2C8CF",
  gray = "#7B7F86", dark_gray = "#4E545C"
)

joe_palettes <- list(
  single = unname(joe_palette["bright_blue"]),
  categorical = unname(joe_palette[c("bright_blue", "medium_orange", "muted_teal", "navy", "light_blue", "muted_rust")]),
  blue_orange = unname(joe_palette[c("bright_blue", "medium_orange")]),
  highlight = unname(joe_palette[c("light_gray", "bright_blue")]),
  stacked_blue = unname(joe_palette[c("navy", "steel_blue", "light_blue", "pale_bluegreen")]),
  sequential = unname(joe_palette[c("pale_bluegreen", "light_blue", "bright_blue", "steel_blue", "navy")])
)

joe_colors <- function(..., named = FALSE) {
  requested <- unlist(list(...), use.names = FALSE)
  if (!length(requested)) return(joe_palette)
  unknown <- setdiff(requested, names(joe_palette))
  if (length(unknown)) stop("Unknown JoE color: ", paste(unknown, collapse = ", "), call. = FALSE)
  colors <- joe_palette[requested]
  if (named) colors else unname(colors)
}

.joe_values <- function(palette, reverse = FALSE) {
  palette <- match.arg(palette, names(joe_palettes))
  x <- joe_palettes[[palette]]
  if (reverse) rev(x) else x
}

scale_color_joe <- function(palette = NULL, discrete = TRUE, reverse = FALSE, ...) {
  if (is.null(palette)) palette <- if (discrete) "categorical" else "sequential"
  x <- .joe_values(palette, reverse)
  if (discrete) ggplot2::scale_color_manual(values = x, ...) else ggplot2::scale_color_gradientn(colors = x, ...)
}
scale_colour_joe <- scale_color_joe

scale_fill_joe <- function(palette = NULL, discrete = TRUE, reverse = FALSE, ...) {
  if (is.null(palette)) palette <- if (discrete) "categorical" else "sequential"
  x <- .joe_values(palette, reverse)
  if (discrete) ggplot2::scale_fill_manual(values = x, ...) else ggplot2::scale_fill_gradientn(colors = x, ...)
}

scale_color_joe_diverging <- function(midpoint = 0, ...) {
  ggplot2::scale_color_gradient2(low = joe_palette["navy"], mid = joe_palette["sand"], high = joe_palette["muted_rust"], midpoint = midpoint, ...)
}
scale_fill_joe_diverging <- function(midpoint = 0, ...) {
  ggplot2::scale_fill_gradient2(low = joe_palette["navy"], mid = joe_palette["sand"], high = joe_palette["muted_rust"], midpoint = midpoint, ...)
}
