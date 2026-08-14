theme_joe <- function(base_size = 14, base_family = "sans", horizontal_grid = TRUE) {
  y_grid <- if (horizontal_grid) ggplot2::element_line(colour = joe_palette["light_gray"], linewidth = 0.35) else ggplot2::element_blank()
  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      plot.background = ggplot2::element_rect(fill = "white", colour = NA),
      panel.background = ggplot2::element_rect(fill = "white", colour = NA),
      plot.title = ggplot2::element_text(size = base_size * 1.45, face = "bold", colour = "#111111", hjust = 0, lineheight = 0.98, margin = ggplot2::margin(b = 10)),
      plot.subtitle = ggplot2::element_text(size = base_size * 0.95, colour = joe_palette["dark_gray"], hjust = 0, lineheight = 1.15, margin = ggplot2::margin(b = 14)),
      axis.text = ggplot2::element_text(size = base_size * 0.86, colour = joe_palette["dark_gray"]),
      axis.title = ggplot2::element_text(size = base_size * 0.93, face = "bold", colour = joe_palette["dark_gray"]),
      panel.grid.major.y = y_grid, panel.grid.major.x = ggplot2::element_blank(),
      panel.grid.minor = ggplot2::element_blank(), axis.ticks = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(), legend.position = "top",
      legend.justification = "left", legend.title = ggplot2::element_blank(),
      plot.title.position = "plot", plot.caption.position = "plot",
      plot.margin = ggplot2::margin(16, 22, 8, 16)
    )
}
