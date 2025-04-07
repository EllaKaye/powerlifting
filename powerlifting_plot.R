library(ggplot2)
library(dplyr)
library(readr)

# Data
lifting_data <- read_csv("powerlifting_tracker.csv", col_types = "Dccidc")

# Plot data
plot_data <- lifting_data |>
  filter(!(set %in% c("one_rep", "two_rep", "heavy_4"))) |>
  filter(!is.na(weight)) |>
  filter(date != as.Date("2024-11-14")) |> # PT session is different
  filter(date != as.Date("2024-12-11")) |> # PT session is different
  mutate(
    lift = factor(lift, levels = c("squat", "benchpress", "deadlift"))
  ) |>
  mutate(
    set = factor(
      set,
      levels = c("bar", "light", "medium", "heavy_1", "heavy_2", "heavy_3")
    )
  )

# Labels for legend
custom_labels <- c(
  "bar (10)",
  "light (8)",
  "medium (6)",
  "heavy 1 (3)",
  "heavy 2 (3)",
  "heavy 3 (3)"
)

# Custom function to add kg to axis labels
# add_kg <- function(x) {
#   paste(x, "kg")
# }

# Create the faceted plot
ggplot(plot_data, aes(x = date, y = weight, color = set, group = set)) +
  geom_line() +
  geom_point() +
  #facet_grid(lift ~ ., scales = "free_y") +
  facet_wrap(~lift, ncol = 1, strip.position = "top", scale = "free_y") +
  labs(
    title = "Powerlifting Progress Tracker",
    subtitle = "Weight in kg. Legend shows set and reps.",
    color = NULL
  ) +
  scale_color_discrete(labels = custom_labels) +
  # scale_y_continuous(labels = add_kg) +
  # guides(
  #   color = guide_legend(
  #     nrow = 2,
  #     byrow = TRUE
  #   )
  # ) +
  theme_minimal() +
  theme(
    # legend.position = "top",
    # axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    strip.text = element_text(size = 11, hjust = 0), # Left-align the strip text
    #strip.background = element_rect(fill = "white", color = "gray90"),
    plot.title.position = "plot"
  )

ggsave("powerlifting_plot.png", width = 7, height = 5, bg = "white")
