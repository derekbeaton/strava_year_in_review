## load data, find possible issues, clean things up
  ## mostly used as a scratch pad and formulating thoughts


library(dplyr)
library(magrittr)
library(ggplot2)
library(httr)
library(lubridate)
library(rStrava)


base::load("./data/running_activities_2022_2023.rda")

# through some exploration there's something that isn't a run (so I went into Strava and fixed it so I don't have to do that here...)
## make a rough sketch of the story you want tot ell with viz/table

## start the narrative with the totals over 2 years. then just dive into 2023
## which will include for 2023:
### total time, total distance, earliest/latest activity, longest activity

## total time (hours)
## total distance

running_activities_2022_2023 %>%
  group_by(year) %>% 
  summarize(number_activities = n(),
            total_kilometers = sum(distance),
            total_moving_hours = sum(moving_time_hours),
            total_elapsed_hours = sum(elapsed_time_hours)
  )

## didn't realize how low 2022 was and it's my lowest on strava, 2023 is second highest year


## longests

running_activities_2022_2023 %>%
  group_by(year) %>%
  summarize(longest_distance = max(distance),
            longest_moving_time = max(moving_time_hours),
            longest_elapsed_time = max(elapsed_time_hours))


## specifically longest activity
running_activities_2022_2023 %>%
  group_by(year) %>%
  filter(distance == max(distance)) %>%
  select(start_date_local, wkday, distance, moving_time_hours, total_elevation_gain)


## biggest week (distance)
  ## worth noting how we got here with the calculation...
running_activities_2022_2023 %>%
  group_by(year, wk) %>%
  summarise(weekly_total = sum(distance)) %>%
  filter(weekly_total == max(weekly_total))


## earliest and latest
## earliest run? latest run?
running_activities_2022_2023 %>%
  group_by(year) %>%
  summarize(
    earliest_start = min(hms),
    latest_start = max(hms)
  )

## 2023 (or 2022 as well?)
monthly_summaries <- running_activities_2022_2023 %>%
  group_by(year, month) %>%
  summarize(monthly_distance = sum(distance),
            monthly_moving_time_hours = sum(moving_time_hours),
            monthly_elevation = sum(total_elevation_gain)) %>%
  ungroup()


### I have some clean up to do including year flip in legend
monthly_summaries %>%
  ggplot(., aes(month, monthly_distance, fill = as.factor(year))) + 
  geom_bar(stat = "identity", position=position_dodge()) +
  coord_flip() + 
  scale_x_discrete(limits = rev) +
  theme_classic()


monthly_summaries %>%
  ggplot(., aes(month, monthly_moving_time_hours, fill = as.factor(year))) + 
  geom_bar(stat = "identity", position=position_dodge()) +
  coord_flip() + 
  scale_x_discrete(limits = rev) +
  theme_classic()


monthly_summaries %>%
  ggplot(., aes(month, monthly_elevation, fill = as.factor(year))) + 
  geom_bar(stat = "identity", position=position_dodge()) +
  coord_flip() + 
  scale_x_discrete(limits = rev) +
  theme_classic()

# do a smidgen of grouping based on my criteria

running_activities_2022_2023 %<>%
  mutate(run_class = 
    factor(
      case_when(
        distance <= 1 ~ "<= 1 km",
        distance > 1 & distance <= 5 ~ "1-5 km",
        distance > 5 & distance <= 10 ~ "5-10 km",
        distance > 10 & distance <= 15 ~ "10-15 km",
        distance > 15 & distance <= 18 ~ "15-18 km",
        distance > 18 & distance <= 21 ~ "18-21 km",
        distance > 21 & distance <= 24 ~ "21-24 km",
        distance > 24 ~ "> 24 km"
      ), levels = c("<= 1 km", "1-5 km", "5-10 km", "10-15 km", "15-18 km", "18-21 km", "21-24 km", "> 24 km")
    )
  )


running_activities_2023 <- running_activities_2022_2023 %>%
  filter(year == 2023)

## not really interesting to me anymore
# running_activities_2023 %>%
#   group_by(wkday) %>% 
#   summarize(number_activities = n(),
#             average_kilometers = mean(distance),
#             average_hours = mean(moving_time_minutes)
#   )


## can viz the run range (get the code from the other repo)
## 2023 will be Ragnar


# then go back to some of my previous visualizations/tables


## do what I see in the year in sport: time, longest activity, distance x month, elevation by month, days active (can just use the calendar...)
