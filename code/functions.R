# functions

clock_24_hours <- function(activity_df){
  
  activity_df %>%
    ggplot(., aes(x = hour)) +
    geom_histogram(stat = "count", breaks=c(1:24), color = "black", fill = "firebrick3")+
    coord_polar() +
    scale_x_continuous("", limits = c(0, 24),
                       breaks = seq(0, 24), labels = seq(0,24)) +
    ylab("") +
    theme_bw() +
    theme(panel.border = element_blank(),
          legend.key = element_blank(),
          axis.text.y = element_blank(),
          panel.grid  = element_blank(),
          axis.ticks.y = element_blank())
}



proportion_run_class <- function(activity_df){
  
  activity_df %>%
    group_by(run_class) %>%
    summarise(count = n()) %>%
    mutate(percent = count / sum(count)) %>%
    ungroup %>%
    ggplot(., aes(x = "", y = percent, fill = run_class)) +
    geom_bar(width = 1, stat = "identity", color = "white") +
    coord_polar("y", start = 0)+
    scale_fill_carto_d(palette = "Vivid") +
    theme_void()
  
}


calendar_heatmap_distance <- function(activity_df){
  
  activity_df %>%
    group_by(year, month, wk, wkday) %>%
    summarize(distance_k_sum = sum(distance)) %>%
    ggplot(., aes(wk, wkday, fill=distance_k_sum)) +
    geom_tile(color='white') +
    geom_text(aes(label=round(distance_k_sum)), size=2.5, color = "black") +
    labs(x='',
         y='',
         title="Distance by day") +
    scale_fill_carto_c(palette="SunsetDark") +
    theme(panel.background = element_blank(),
          axis.ticks = element_blank(),
          axis.text.x = element_blank(),
          strip.background = element_rect("grey92")) +
    facet_grid(year~month, scales="free", space="free") +
    labs(fill='Distance')
}


calendar_heatmap_time <- function(activity_df){
  
  activity_df %>%
    group_by(year, month, wk, wkday) %>%
    summarize(time_sum = sum(moving_time_minutes)) %>%
    ggplot(., aes(wk, wkday, fill=time_sum)) +
    geom_tile(color='white') +
    geom_text(aes(label=round(time_sum)), size=2, color = "black") +
    labs(x='',
         y='',
         title="Time by day") +
    scale_fill_carto_c(palette="SunsetDark") +
    theme(panel.background = element_blank(),
          axis.ticks = element_blank(),
          axis.text.x = element_blank(),
          strip.background = element_rect("grey92")) +
    facet_grid(year~month, scales="free", space="free") +
    labs(fill='Time')
}

calendar_heatmap_pace <- function(activity_df){
  
  activity_df %>%
    group_by(year, month, wk, wkday) %>%
    summarize(pace_mean = mean(moving_time_minutes / distance)) %>%
    ggplot(., aes(wk, wkday, fill=2^-pace_mean)) +
    geom_tile(color='white') +
    geom_text(aes(label=round(pace_mean,digits = 1)), size=2, color = "black") +
    labs(x='',
         y='',
         title="Pace by day") +
    scale_fill_carto_c(palette="Tropic", direction = 1) +
    theme(panel.background = element_blank(),
          axis.ticks = element_blank(),
          axis.text.x = element_blank(),
          strip.background = element_rect("grey92"),
          legend.position = "none") +
    facet_grid(year~month, scales="free", space="free") + 
    labs(fill='Pace')
}