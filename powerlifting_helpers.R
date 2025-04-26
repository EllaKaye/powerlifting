library(dplyr)
library(ggplot2)
library(ggtext)

prep_data_for_plot <- function(data) {
  data |>
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
}

create_powerlifting_plot <- function(data) {
  set_colours <- c(
    bar = "#6AD400",
    light = "#00D46A",
    medium = "#D46A00",
    heavy_1 = "#006AD4",
    heavy_2 = "#6A00D4",
    heavy_3 = "#D4006A"
  )

  ggplot(data, aes(x = date, y = weight, color = set, group = set)) +
    geom_line() +
    geom_point() +
    facet_wrap(~lift, ncol = 1, strip.position = "top", scale = "free_y") +
    labs(
      title = "Powerlifting Progress Tracker",
      subtitle = "Weight (kg) lifted in each set (reps)<br>
      **<span style = 'color:#6AD400;'>bar (10)</span>**, 
      **<span style = 'color:#00D46A;'>light (8)</span>**, 
      **<span style = 'color:#D46A00;'>medium (6)</span>**, 
      **<span style = 'color:#006AD4;'>heavy 1 (3)</span>**, 
      **<span style = 'color:#6A00D4;'>heavy 2 (3)</span>**, 
      **<span style = 'color:#D4006A;'>heavy 3 (3)</span>**",
      color = NULL
    ) +
    scale_color_manual(values = set_colours) +
    scale_x_date(date_labels = "%b\n%Y") +
    theme_minimal() +
    theme(
      legend.position = "none",
      axis.title.x = element_blank(),
      axis.title.y = element_blank(),
      strip.text = element_text(size = 14, hjust = 0.5, face = "bold"),
      #strip.background = element_rect(fill = "white", color = "gray90"),
      text = element_text(family = "LEMON MILK Pro"),
      panel.spacing = unit(2, "lines"),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(colour = "#FFF4F9"),
      plot.title = element_text(
        size = 20,
        margin = margin(6, 0, 12, 0),
        face = "bold",
        hjust = 0.5
      ),
      #plot.subtitle = marquee::element_marquee(),
      plot.subtitle = element_textbox_simple(
        size = 12,
        margin = margin(0, 0, 12, 0),
        lineheight = 1.7,
        halign = 0.5
      ),
      plot.margin = margin(rep(24, 4))
    )
}

save_powerlifting_plot <- function() {
  ggsave(
    "powerlifting_plot.png",
    width = 9,
    height = 7,
    bg = "white",
    device = agg_png,
    res = 320,
    unit = "in"
  )
}
