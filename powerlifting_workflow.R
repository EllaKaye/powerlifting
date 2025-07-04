use("readr", c("read_csv", "write_csv"))
library(ragg)

source("powerlifting_helpers.R")

# TODO: update date
date <- "2025-06-29"

# TODO: update start_date if needed
# To keep track of effect of menstrual cycle on lifts
start_date <- as.Date("2025-06-17")
cycle_day <- as.numeric(as.Date(date) - start_date)

# TODO: update weight and maybe reps and note
# fmt: skip
latest_lifts <- tibble::tribble(
  ~lift, ~set, ~reps, ~weight, ~note,
  "squat", "bar", 10L, 20, NA, 
  "squat", "light", 8L, 40, NA, 
  "squat", "medium", 6L, 55, NA, 
  "squat", "heavy_1", 3L, 65, "weight good, depth good reps 1 and 3 just sjy on rep 2",
  "squat", "heavy_2", 1L, 65, "hurt back and stopped",
  "squat", "heavy_3", 3L, NA, NA,
  "benchpress", "bar", 10L, 20, NA, 
  "benchpress", "light", 8L, 30, "up", 
  "benchpress", "medium", 6L, 35, "up", 
  "benchpress", "heavy_1", 3L, 39, "very smooth",
  "benchpress", "heavy_2", 3L, 40, "p.b. slight push on last rep but feeling good",
  "benchpress", "heavy_3", 3L, 42, "p.b. first 2 smooth, last rep a struggle but it went!",
  "deadlift", "bar", 10L, NA, "did deadlift first today", 
  "deadlift", "light", 8L, 50, NA, 
  "deadlift", "medium", 6L, 65, NA, 
  "deadlift", "heavy_1", 3L, 80, NA,
  "deadlift", "heavy_2", 3L, 80, NA,
  "deadlift", "heavy_3", 3L, 82.5, "absolutely fine - could have gone 85kg. p.b. reps at weight."
)

latest_data <- cbind(date = as.Date(date), latest_lifts, cycle_day = cycle_day)
previous_data <- read_csv("powerlifting_tracker.csv", col_types = "Dccidci")
lifting_data <- rbind(previous_data, latest_data)

# append latest data to csv
write_csv(latest_data, "powerlifting_tracker.csv", na = "", append = TRUE)

# create and save plot
plot_data <- prep_data_for_plot(lifting_data)
create_powerlifting_plot(plot_data)
save_powerlifting_plot() # a wrapper to ggsave

# git workflow
system(
  "git add powerlifting_workflow.R powerlifting_plot.png powerlifting_tracker.csv"
)
system(paste0('git commit -m "', date, '"'))
system("git push")

# check
usethis::browse_github()

# total weight
total_weight <- lifting_data |>
  filter(!(set %in% c("one_rep", "two_rep", "heavy_4"))) |>
  filter(!is.na(weight)) |>
  filter(date != as.Date("2024-11-14")) |> # PT session is different
  filter(date != as.Date("2024-12-11")) |> # PT session is different
  summarise(total = sum(reps * weight), .by = date)

total_weight |>
  arrange(desc(total))
