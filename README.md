# joeplots

`joeplots` provides the CWRU Journal of Economics color palette, a minimal
`ggplot2` theme, and standard export sizes for web, print, and social charts.

## Install

Install `remotes` once, then install `joeplots` directly from GitHub:

```r
install.packages("remotes")
remotes::install_github(
  "CWRU-Journal-of-Economics/joeplots",
  upgrade = "never"
)
```

## Make a chart

```r
library(ggplot2)
library(joeplots)

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point(color = joe_colors("bright_blue"), size = 3) +
  labs(
    title = "Fuel economy falls as vehicle weight rises",
    x = "Weight (1,000 pounds)",
    y = "Miles per gallon"
  ) +
  theme_joe()

p
```

Use sentence case for titles: capitalize the first word and proper nouns only.
`theme_joe()` uses the portable system sans-serif font, left-aligned titles,
minimal horizontal gridlines, and no axis ticks.

## Use JoE colors

```r
joe_colors()
joe_colors("bright_blue")
joe_colors("navy", "medium_orange")
```

Requested colors are returned as plain hex values, so they work directly in
manual scales:

```r
scale_fill_manual(values = c(
  Highlighted = joe_colors("bright_blue"),
  Other = joe_colors("light_gray")
))
```

For ordinary categorical and continuous scales, use the packaged helpers:

```r
scale_color_joe(palette = "categorical")
scale_fill_joe(palette = "sequential", discrete = FALSE)
```

## Export

```r
save_joe(
  p,
  "chart.png",
  format = "web",
  source = "Motor Trend, 1974"
)
```

The footer contains source and note text only; exported charts do not include
a logo. Available formats are `web`, `web_wide`, `web_tall`, `print`, and
`social`.

```r
joe_chart_size("web")
joe_chart_size("print")
joe_chart_size("social")
```
