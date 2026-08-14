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

p <- ggplot(mtcars, aes(wt, mpg)) +
  geom_point(color = joe_colors("bright_blue")) +
  labs(title = "Fuel economy falls as vehicle weight rises") +
  theme_joe()

f <- tempfile(fileext = ".png")
save_joe(p, f, format = "social", source = "Test")
stopifnot(file.exists(f), file.info(f)$size > 0)
