# joeplots

`joeplots` is the official R chart toolkit for the CWRU Journal of Economics
(JoE). It gives students a shared color palette, a minimal `ggplot2` theme,
standard export sizes, and consistent source footers.

The goal is simple: a student should be able to focus on the data and the
message while the package handles most visual formatting decisions.

## Quick start

Install `remotes` once:

```r
install.packages("remotes")
```

Install `joeplots` from GitHub:

```r
remotes::install_github(
  "CWRU-Journal-of-Economics/joeplots",
  upgrade = "never"
)
```

Then make and export a chart:

```r
library(ggplot2)
library(joeplots)

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point(
    color = joe_colors("bright_blue"),
    size = 3,
    alpha = 0.8
  ) +
  labs(
    title = "Heavier cars get worse fuel economy",
    subtitle = "Fuel economy and vehicle weight for 32 cars",
    x = "Weight (1,000 pounds)",
    y = "Miles per gallon"
  ) +
  theme_joe()

p

save_joe(
  p,
  "fuel-economy.png",
  format = "web",
  source = "Motor Trend, 1974"
)
```

## JoE chart standard

Every JoE chart should follow these rules unless the story requires a clear
exception:

1. Use a white background.
2. Use a large, bold, left-aligned title.
3. Write titles in sentence case: capitalize the first word and proper nouns
   only.
4. Make the title state the chart's main takeaway when possible.
5. Use a subtitle only when it adds necessary context.
6. Use large, readable axis text and label axes with units when needed.
7. Remove minor gridlines and axis ticks. Keep only subtle horizontal major
   gridlines when they help readers compare values.
8. Use JoE colors only. Do not introduce a new hex color without editorial
   approval.
9. Prefer one emphasis color and neutral gray for context.
10. Add a source to every published chart. Add a note only when readers need
    a definition, caveat, or methodological detail.
11. Do not place the JoE logo inside exported charts.
12. Do not use color as the only way to communicate an important distinction;
    use labels, ordering, or annotations too.

## Titles and labels

Good titles are short, specific, and written in sentence case:

- `Inflation slowed in the second half of 2025`
- `Cleveland rents remain below the national average`
- `Young workers changed jobs most often`

Avoid title case such as `Inflation Slowed In The Second Half Of 2025`.

For a narrow or social chart, insert `\n` where the title should wrap:

```r
labs(title = "Baseball has become more expensive,\nbut attendance holds steady")
```

Avoid shrinking the title until it becomes hard to read. Shorten or wrap it
instead.

Axis labels should identify the measure and unit. Examples include `Percent`,
`Price index (2020 = 100)`, and `Thousands of people`. Set an axis title to
`NULL` when the categories or surrounding text already make it obvious.

## Theme

Add `theme_joe()` after labels, scales, and coordinates:

```r
p + theme_joe()
```

Its arguments are:

```r
theme_joe(
  base_size = 14,
  base_family = "sans",
  horizontal_grid = TRUE
)
```

- `base_size` controls the overall text scale.
- `base_family = "sans"` uses a portable system sans-serif font and avoids
  requiring students to install a particular font.
- `horizontal_grid = FALSE` removes all gridlines. This is often useful for
  bar charts.

Place `theme_joe()` near the end of the plot code. Small chart-specific theme
adjustments may come after it:

```r
p +
  theme_joe() +
  theme(legend.position = "bottom")
```

## Color palette

The complete palette is:

| R name | Hex | Typical use |
|---|---:|---|
| `bright_blue` | `#2F6DB3` | Main series or highlight |
| `navy` | `#112F52` | Strong dark series or endpoint |
| `steel_blue` | `#3F5F7A` | Secondary blue |
| `light_blue` | `#8FAFCA` | Supporting series |
| `sand` | `#E6D3B3` | Neutral midpoint or soft context |
| `medium_orange` | `#D49A73` | Comparison or contrast |
| `muted_rust` | `#C07A5A` | Strong warm endpoint |
| `muted_teal` | `#7FA7A3` | Supporting category |
| `pale_bluegreen` | `#D6E3DD` | Light background or low value |
| `light_gray` | `#C2C8CF` | De-emphasized observations |
| `gray` | `#7B7F86` | Secondary text or marks |
| `dark_gray` | `#4E545C` | Dark secondary text |

List every color or request one or more hex values:

```r
joe_colors()
joe_colors("bright_blue")
joe_colors("navy", "medium_orange")
```

When specific colors are requested, `joe_colors()` returns plain hex values
that can be used directly in geoms and manual scales.

### Approved combinations

The named combinations in `joe_palettes` are:

- `single`: bright blue
- `categorical`: bright blue, medium orange, muted teal, navy, light blue,
  and muted rust
- `blue_orange`: bright blue and medium orange
- `highlight`: light gray and bright blue
- `stacked_blue`: navy, steel blue, light blue, and pale blue-green
- `sequential`: pale blue-green through light blue and bright blue to navy

The diverging scales run from navy through sand to muted rust.

Use no more categories than readers can distinguish comfortably. If a chart
has many categories, highlight the important one and make the rest light gray,
or split the chart into smaller panels.

## Color scales

For a categorical variable mapped inside `aes()`, use a discrete JoE scale:

```r
ggplot(airquality, aes(Day, Temp, color = factor(Month))) +
  geom_line(linewidth = 1) +
  scale_color_joe(palette = "categorical") +
  theme_joe()
```

Available palette names are `single`, `categorical`, `blue_orange`,
`highlight`, `stacked_blue`, and `sequential`.

Use `scale_color_joe()` for lines and points and `scale_fill_joe()` for bars,
areas, tiles, and other filled shapes:

```r
scale_color_joe(palette = "categorical")
scale_fill_joe(palette = "stacked_blue")
```

For a continuous variable, set `discrete = FALSE`:

```r
scale_color_joe(palette = "sequential", discrete = FALSE)
scale_fill_joe(palette = "sequential", discrete = FALSE)
```

For values with a meaningful midpoint, such as zero or the national average,
use a diverging scale:

```r
scale_color_joe_diverging(midpoint = 0)
scale_fill_joe_diverging(midpoint = 0)
```

Set a constant color outside `aes()`:

```r
geom_line(color = joe_colors("navy"))
```

Map a data variable to color inside `aes()`:

```r
geom_line(aes(color = region))
```

## Complete chart examples

### Highlighted bar chart

Bars should normally begin at zero. Order categories by value unless the data
has a meaningful natural order.

```r
car_data <- aggregate(hwy ~ class, data = mpg, FUN = mean)

bar_plot <- ggplot(
  car_data,
  aes(
    x = reorder(class, hwy),
    y = hwy,
    fill = class == "compact"
  )
) +
  geom_col(width = 0.7) +
  coord_flip() +
  scale_fill_manual(
    values = c(
      "TRUE" = joe_colors("bright_blue"),
      "FALSE" = joe_colors("light_gray")
    ),
    guide = "none"
  ) +
  labs(
    title = "Compact cars lead in highway mileage",
    subtitle = "Average fuel economy by vehicle class",
    x = NULL,
    y = "Average highway miles per gallon"
  ) +
  theme_joe(horizontal_grid = FALSE)

bar_plot
```

### Time series

```r
line_plot <- ggplot(economics, aes(date, unemploy / 1000)) +
  geom_line(color = joe_colors("navy"), linewidth = 1.1) +
  labs(
    title = "Unemployment rose sharply during recessions",
    subtitle = "Monthly unemployment in the United States",
    x = NULL,
    y = "Unemployed people (millions)"
  ) +
  theme_joe()

line_plot
```

### Scatterplot with a trend

```r
scatter_plot <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point(
    color = joe_colors("bright_blue"),
    size = 3,
    alpha = 0.8
  ) +
  geom_smooth(
    method = "lm",
    se = FALSE,
    color = joe_colors("navy"),
    linewidth = 1
  ) +
  labs(
    title = "Heavier cars get worse fuel economy",
    x = "Weight (1,000 pounds)",
    y = "Miles per gallon"
  ) +
  theme_joe()

scatter_plot
```

## Exporting charts

Always use `save_joe()` for a final chart rather than calling `ggsave()`
directly. This keeps output sizes, resolution, background, source treatment,
and PNG rendering consistent.

```r
save_joe(
  plot = bar_plot,
  filename = "bar-chart.png",
  format = "web",
  source = "EPA fuel economy data",
  note = "Values are unweighted class averages."
)
```

The source and optional note appear in a small text footer. No logo is added.

### Standard dimensions

| Format | Size in inches | DPI for PNG | Pixel dimensions | Use |
|---|---:|---:|---:|---|
| `web` | 8 × 5 | 300 | 2400 × 1500 | Standard website chart |
| `web_wide` | 8 × 4.5 | 300 | 2400 × 1350 | Wide website layout |
| `web_tall` | 8 × 6 | 300 | 2400 × 1800 | Chart needing extra vertical room |
| `print` | 7.5 × 4.6875 | 400 | 3000 × 1875 | Print-quality raster image |
| `social` | 6 × 7.5 | 300 | 1800 × 2250 | Vertical social post |

These presets intentionally create files larger than their final display size.
Downscaling a sharp image generally looks better than enlarging a small one.
PNG files are rendered with `ragg` for clear text, lines, and antialiasing.

Check a preset from R:

```r
joe_chart_size("web")
joe_chart_size("print")
joe_chart_size("social")
```

For print workflows that accept PDF, a vector PDF is usually preferable to a
raster image because text and lines remain sharp at any size:

```r
save_joe(
  bar_plot,
  "bar-chart.pdf",
  format = "print",
  source = "EPA fuel economy data"
)
```

You may override a preset when an editor requires exact dimensions:

```r
save_joe(
  bar_plot,
  "custom-chart.png",
  format = "web",
  width = 10,
  height = 6,
  dpi = 300,
  source = "EPA fuel economy data"
)
```

The file is saved relative to the current working directory. Check it with:

```r
getwd()
```

Use an existing folder in the filename. `save_joe()` does not create missing
folders automatically.

## Choosing a chart type

- Use a bar chart to compare values across categories.
- Use a line chart to show change over time.
- Use a scatterplot to show the relationship between two numeric variables.
- Use a map only when geography is central to the story.
- Avoid pie charts when readers need to compare similar values precisely.
- Avoid dual y-axes unless there is an unusually strong justification.

A chart should answer one main question. If it needs several legends, many
colors, and extensive explanatory text, consider simplifying it or splitting
it into multiple charts.

## Instructions for AI assistants

When helping a JoE student create or revise a chart, an AI assistant should
treat this README as the chart specification and follow these rules:

1. Write self-contained R code using `ggplot2` and `joeplots`.
2. Ask for or identify the data frame, relevant columns, intended audience,
   main takeaway, and source.
3. Choose a chart type appropriate to the analytical question.
4. Use `joe_colors()` or a packaged JoE scale; do not invent colors.
5. Use a white background and add `theme_joe()` near the end of the plot code.
6. Use a bold, left-aligned, sentence-case title that communicates the result.
7. Label units clearly and remove redundant axis titles or legends.
8. Use subtle horizontal gridlines only when helpful.
9. Prefer highlighting one important series while muting comparison data.
10. Include a source in the final `save_joe()` call.
11. Use `save_joe()` with the correct format instead of plain `ggsave()`.
12. Do not add a logo.
13. For narrow outputs, shorten or explicitly wrap long titles with `\n`.
14. Return code that can be pasted and run, followed by a short explanation of
    any data assumptions.

A student can give an AI this repository or README and use a prompt such as:

> Read the joeplots README as the required chart specification. Using my data
> frame named `survey`, make a JoE-style chart showing how `support` differs by
> `class_year`. Highlight seniors, include the source "JoE student survey",
> explain any assumptions, and export a web PNG.

An AI should not fabricate column names, sources, units, or findings. When any
of those are unclear, it should ask the student or mark the assumption clearly.

## Updating the package

Check the installed version:

```r
packageVersion("joeplots")
```

Install the latest GitHub version during development:

```r
remotes::install_github(
  "CWRU-Journal-of-Economics/joeplots",
  upgrade = "never",
  force = TRUE
)
```

- `upgrade = "never"` prevents an unrelated package-update prompt.
- `force = TRUE` reinstalls `joeplots` even when the version appears unchanged.

Restart R after reinstalling so an older loaded copy is not kept in memory.

## Troubleshooting

### `unused arguments` from `save_joe()`

R is probably using an older package version or a function with the same name.
Restart R, reinstall `joeplots`, and call `joeplots::save_joe()` explicitly.

### Manual-scale warning about no shared levels

The names in `scale_fill_manual()` or `scale_color_manual()` must exactly match
the values in the mapped data column. Inspect them with `unique(data$column)`.
With `joeplots` 0.1.1 or later, `joe_colors()` returns plain requested values
and does not create compound names.

### Font warnings

Use `theme_joe()` with its default `base_family = "sans"`. Avoid specifying
`Arial` unless it is registered with the R graphics device on that computer.

### The title is clipped

Shorten it or insert a deliberate line break with `\n`, especially for the
`social` format.

### The file cannot be found

Run `getwd()` to see the output folder. If the filename contains a directory,
create that directory before exporting.

### Changes do not appear after reinstalling

Confirm that the changes were pushed to GitHub, reinstall with `force = TRUE`,
restart R, and run `packageVersion("joeplots")`.

## Function reference

- `theme_joe()` applies the standard JoE visual theme.
- `joe_colors()` returns approved palette values.
- `joe_palette` contains the named master palette.
- `joe_palettes` contains approved color combinations.
- `scale_color_joe()` and `scale_colour_joe()` style mapped line and point
  colors.
- `scale_fill_joe()` styles mapped fill colors.
- `scale_color_joe_diverging()` and `scale_fill_joe_diverging()` create scales
  around a meaningful midpoint.
- `joe_chart_size()` reports a standard export preset.
- `add_joe_footer()` adds source and note text to a plot.
- `save_joe()` adds the footer and exports at a standard size.

Report bugs or propose improvements through the repository's GitHub Issues
page: <https://github.com/CWRU-Journal-of-Economics/joeplots/issues>.
