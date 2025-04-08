library(ggplot2)
library(dplyr)
library(readr)
library(ggtext)
library(ragg)
#library(marquee)

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

set_colours <- c(
  bar = "#6AD400",
  light = "#00D46A",
  medium = "#D46A00",
  heavy_1 = "#006AD4",
  heavy_2 = "#6A00D4",
  heavy_3 = "#D4006A"
)

#subtitle_marquee <- "Weight (kg) lifted in each set (reps): **{#6AD400 bar (10)}**, **{#00D46A light (8)}**, **{#D46A00 medium (6)}**, **{#006AD4 heavy 1 (3)}**, **{#6A00D4 heavy 2 (3)}**, and **{#D4006A heavy 3 (3)}**."

# Create the faceted plot
ggplot(plot_data, aes(x = date, y = weight, color = set, group = set)) +
  geom_line() +
  geom_point() +
  facet_wrap(~lift, ncol = 1, strip.position = "top", scale = "free_y") +
  labs(
    title = "Powerlifting Progress Tracker",
    subtitle = "Weight (kg) lifted in each set (reps): **<span style = 'color:#6AD400;'>bar (10)</span>**, **<span style = 'color:#00D46A;'>light (8)</span>**, **<span style = 'color:#D46A00;'>medium (6)</span>**, **<span style = 'color:#006AD4;'>heavy 1 (3)</span>**, **<span style = 'color:#6A00D4;'>heavy 2 (3)</span>**, and **<span style = 'color:#D4006A;'>heavy 3 (3)</span>**",
    color = NULL
  ) +
  scale_color_manual(values = set_colours) +
  theme_minimal() +
  theme(
    legend.position = "none",
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    strip.text = element_text(size = 14, hjust = 0, face = "bold"), # Left-align the strip text
    #strip.background = element_rect(fill = "white", color = "gray90"),
    text = element_text(family = "LEMON MILK Pro"),
    panel.spacing = unit(2, "lines"),
    plot.title.position = "plot",
    plot.title = element_text(
      size = 20,
      margin = margin(6, 0, 12, 0),
      face = "bold"
    ),
    #plot.subtitle = marquee::element_marquee(),
    plot.subtitle = element_textbox_simple(
      size = 10.5,
      margin = margin(0, 0, 12, 0),
      lineheight = 1.3
    ),
    plot.margin = margin(rep(18, 4))
  )

ggsave(
  "powerlifting_plot.png",
  width = 9,
  height = 7,
  bg = "white",
  device = agg_png,
  res = 320,
  unit = "in"
)


# Total weight -----------------------------------------------------------

total_weight <- lifting_data |>
  filter(!(set %in% c("one_rep", "two_rep", "heavy_4"))) |>
  filter(!is.na(weight)) |>
  filter(date != as.Date("2024-11-14")) |> # PT session is different
  filter(date != as.Date("2024-12-11")) |> # PT session is different
  summarise(total = sum(weight), .by = date)

ggplot(total_weight, aes(date, total)) +
  geom_point() +
  geom_line() +
  theme_minimal()

lift_data <- lifting_data |>
  filter(!is.na(weight)) |>
  filter(date != as.Date("2024-11-14")) |> # PT session is different
  filter(date != as.Date("2024-12-11")) |> # PT session is different
  summarise(total = sum(weight), .by = c(date, lift)) |>
  mutate(
    lift = factor(lift, levels = c("deadlift", "benchpress", "squat"))
  )

lift_colours <- c(
  a = "#6AD400",
  b = "#00D46A",
  c = "#D46A00",
  squat = "#006AD4",
  benchpress = "#6A00D4",
  deadlift = "#D4006A"
)

ggplot(lift_data, aes(date, total)) +
  geom_bar(aes(fill = lift), stat = "identity") +
  scale_color_manual(values = lift_colours) +
  theme_minimal() +
  theme(
    #legend.position = "none",
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    strip.text = element_text(size = 14, hjust = 0, face = "bold"), # Left-align the strip text
    #strip.background = element_rect(fill = "white", color = "gray90"),
    text = element_text(family = "figtree"),
    plot.title.position = "plot",
    plot.title = element_text(size = 20, margin = margin(6, 0, 12, 0)),
    plot.subtitle = element_marquee(width = 1),
    # plot.subtitle = element_textbox_simple(
    #   margin = margin(0, 0, 12, 0),
    #   lineheight = 1.3
    # ),
    plot.margin = margin(rep(18, 4))
  )
