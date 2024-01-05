library(dplyr)
# library(ggplot2)
library(httr)
library(rStrava)


app_name <- 'myappname' # chosen by user

stoken <- httr::config(token = strava_oauth(app_name, Sys.getenv("STRAVA_KEY"), Sys.getenv("STRAVA_SECRET"), app_scope="activity:read_all"))

# my_info <- rStrava::get_athlete(stoken, id = Sys.getenv("ATHLETE_ID"))

my_acts <- get_activity_list(stoken)
act_data <- compile_activities(my_acts)


running_activities_2022_2023 <- act_data %>%
  mutate(start_date_local = lubridate::as_datetime(start_date_local)) %>%
  mutate(start_date = lubridate::as_datetime(start_date)) %>%
  filter(start_date_local >= lubridate::as_datetime("2022-01-01")) %>%
  filter(start_date_local < lubridate::as_datetime("2024-01-01")) %>%
  filter(sport_type == "Run") %>%
  select(id, start_date_local, distance, elapsed_time, moving_time, average_speed, max_speed, elev_high, elev_low, total_elevation_gain, name, map.summary_polyline) %>%
  mutate(year = lubridate::year(start_date_local)) %>%
  mutate(month = lubridate::month(start_date_local, label = TRUE)) %>%
  mutate(wkday = lubridate::wday(start_date_local, label = TRUE)) %>%
  mutate(hour = lubridate::hour(start_date_local)) %>%
  mutate(cal_wk = lubridate::week(start_date_local)) %>%
  mutate(wk = lubridate::epiweek(floor_date(as.Date(start_date_local)-1, "weeks"))) %>%
  mutate(hms = format(start_date_local, format = "%H:%M:%S")) %>%
  mutate(elapsed_time_seconds = elapsed_time) %>%
  mutate(elapsed_time_minutes = elapsed_time / 60) %>%
  mutate(elapsed_time_hours = elapsed_time / 60 / 60) %>%
  mutate(moving_time_seconds = moving_time) %>%
  mutate(moving_time_minutes = moving_time / 60) %>%
  mutate(moving_time_hours = moving_time / 60 / 60)


base::save(running_activities_2022_2023, file = "./data/running_activities_2022_2023.rda")