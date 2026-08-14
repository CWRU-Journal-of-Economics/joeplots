library(ggplot2)
library(joeplots)

stopifnot(identical(joe_colors("bright_blue"), "#2F6DB3"))
stopifnot(identical(
  names(joe_colors("bright_blue", named = TRUE)),
  "bright_blue"
))

manual_colors <- c(
  Highlighted = joe_colors("bright_blue"),
  Other = joe_colors("light_gray")
)
stopifnot(identical(names(manual_colors), c("Highlighted", "Other")))

web_size <- joe_chart_size("web")
print_size <- joe_chart_size("print")
social_size <- joe_chart_size("social")
stopifnot(
  unname(web_size$dpi) == 300,
  unname(web_size$pixel_width) == 2400,
  unname(web_size$pixel_height) == 1500,
  unname(print_size$dpi) == 400,
  unname(print_size$pixel_width) == 3000,
  unname(print_size$pixel_height) == 1875,
  unname(social_size$dpi) == 300,
  unname(social_size$pixel_width) == 1800,
  unname(social_size$pixel_height) == 2250
)

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point(color = joe_colors("bright_blue")) +
  labs(title = "Fuel economy falls as vehicle weight rises") +
  theme_joe()

f <- tempfile(fileext = ".png")
save_joe(p, f, format = "social", source = "Test")
stopifnot(file.exists(f), file.info(f)$size > 0)
