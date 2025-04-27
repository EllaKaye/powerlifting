use("readr", c("read_csv", "write_csv"))
library(ragg)

source("powerlifting_helpers.R")

# TODO: update date
date <- "2025-04-27"

# TODO: update weight and maybe reps and note
# fmt: skip
latest_lifts <- tibble::tribble(
  ~lift, ~set, ~reps, ~weight, ~note,
  "squat", "bar", 10L, 20, NA, 
  "squat", "light", 8L, 40, NA, 
  "squat", "medium", 6L, 50, NA, 
  "squat", "heavy_1", 3L, 60, NA,
  "squat", "heavy_2", 3L, 65, NA,
  "squat", "heavy_3", 2L, 70, "probably could have done 3",
  "benchpress", "bar", 10L, 20, NA, 
  "benchpress", "light", 8L, NA, NA, 
  "benchpress", "medium", 6L, 30, NA, 
  "benchpress", "heavy_1", 3L, 35, NA,
  "benchpress", "heavy_2", 3L, 35, NA,
  "benchpress", "heavy_3", 2L, 37.5, NA,
  "deadlift", "bar", 10L, NA, NA, 
  "deadlift", "light", 8L, 50L, NA, 
  "deadlift", "medium", 6L, 60L, NA, 
  "deadlift", "heavy_1", 3L, 70L, NA,
  "deadlift", "heavy_2", 3L, 80L, NA,
  "deadlift", "heavy_3", 3L, NA, NA
)

latest_data <- cbind(date = as.Date(date), latest_lifts)
previous_data <- read_csv("powerlifting_tracker.csv", col_types = "Dccidc")
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
