library(tidyverse)
library(janitor)
library(lubridate)
library(readr)
library(dplyr)
library(skimr)
library(ggplot2)
files <- dir("csv/", full.names = T)
## Import previous 12 months data, downloaded from https://divvy-tripdata.s3.amazonaws.com/index.html
## October, 2021 to September, 2022 were the months used.

df1 <- read.csv("./Data/1t1021.csv")
df2 <- read.csv("./Data/2t1121.csv")
df3 <- read.csv("./Data/3t1221.csv")
df4 <- read.csv("./Data/4t0122.csv")
df5 <- read.csv("./Data/5t0222.csv")
df6 <- read.csv("./Data/6t0322.csv")
df7 <- read.csv("./Data/7t0422.csv")
df8 <- read.csv("./Data/8t0522.csv")
df9 <- read.csv("./Data/9t0622.csv")
df10 <- read.csv("./Data/10t0722.csv")
df11<- read.csv("./Data/11t0822.csv")
df12<- read.csv("./Data/12t0922.csv")

#Combining the above files into a CSV file
bike_rides <- rbind(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)
bike_rides <- janitor::remove_empty(bike_rides,which = c("cols"))
bike_rides <- janitor::remove_empty(bike_rides,which = c("rows"))
View(bike_rides)
str(bike_rides)
#Due to computer limitation, we need to take a random
# sample without replacement from total 4,073,561 observations
# Here is how the sample size was calculated
# Population size : 5828235
# Confidence level : 99.99%
# Margin of Error : 0.2
# Sample size: 606149

bikerides <- sample_n(bike_rides, 606149, replace = F)
str(bikerides)
colnames(bikerides)
nrow(bikerides)
dim(bikerides)
head(bikerides)
str(bikerides)
summary(bikerides)

bikerides$date <- as.Date(bikerides$started_at)
bikerides$year <- format(as.Date(bikerides$date), "%Y")
bikerides$month <- format(as.Date(bikerides$date), "%m")
bikerides$day <- format(as.Date(bikerides$date), "%d")

bikerides$started_at <- lubridate::ymd_hms(bikerides$started_at)
bikerides$ended_at <- lubridate::ymd_hms(bikerides$ended_at)

bikerides$start_hour <- lubridate::hour(bikerides$started_at)
bikerides$end_hour <- lubridate::hour(bikerides$ended_at)
head(bikerides)


bikerides <- bikerides %>%
  mutate(ride_length = ended_at - started_at) %>%
  mutate(day_of_week = weekdays(as.Date(bikerides$started_at)))

# Remove rows which have negative ride_length
bikerides <- bikerides %>%
  filter(ride_length > 0)
# Clean column names and remove duplicates
bikerides <- bikerides %>%
  clean_names() %>%
  unique()
bikerides <- bikerides[!duplicated(bikerides$ride_id), ]
print(paste("Removed", nrow(bikerides) - nrow(bikerides), "duplicated rows"))

# Descriptive Analysis

# Descriptive analysis on ride_length (all figures in seconds)
summary(bikerides$ride_length)

# Compare members and casual users
bikerides %>% 
  group_by(member_casual) %>% 
  summarise(mean = mean(ride_length), median = median(ride_length), max = max(ride_length), min = min(ride_length))
  

aggregate(bikerides$ride_length ~ bikerides$member_casual, FUN = mean)
aggregate(bikerides$ride_length ~ bikerides$member_casual, FUN = median)
aggregate(bikerides$ride_length ~ bikerides$member_casual, FUN = max)
aggregate(bikerides$ride_length ~ bikerides$member_casual, FUN = min)

# Here is the average ride time by each day for members vs casual users
aggregate(bikerides$ride_length ~ bikerides$member_casual + bikerides$day_of_week, FUN = mean)

bikerides %>% 
  group_by(member_casual, day_of_week) %>% 
  summarise(mean = mean(ride_length))

# Sort days of the week
bikerides$day_of_week <- ordered(bikerides$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))

# Analysis by ride type and weekday
bikerides %>% 
  mutate(day_of_week = wday(started_at, label = TRUE)) %>%  
  group_by(member_casual, day_of_week) %>%  
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%    
  arrange(member_casual, day_of_week)

# SUMMARY FILE EXPORT FOR FURTHER ANALYSIS

# Total & Average number of monthly rides by ride type
summary_month <- bikerides %>% 
  mutate(month = month(started_at, label = TRUE)) %>%  
  group_by(month,member_casual) %>%  
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>%    
  arrange(month, member_casual)
write.csv(summary_month,"C:\\Users\\Hp\\Documents\\R\\SummaryMonth.csv", row.names = FALSE)

# Most station used by rider type
summary_station <- bikerides %>% 
  mutate(station = start_station_name) %>%
  drop_na(start_station_name) %>% 
  group_by(start_station_name, member_casual) %>%  
  summarise(number_of_rides = n()) %>%    
  arrange(number_of_rides)
write.csv(summary_station,"C:\\Users\\Hp\\Documents\\R\\SummaryStation.csv", row.names = FALSE)

bike_rides_sampled_summary <- bikerides %>% 
  group_by(member_casual, day_of_week) %>%  
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length), total_duration = sum(ride_length)) %>%    
  arrange(member_casual, day_of_week)

# Visualize the number of rides by rider type
ggplot(bike_rides_sampled_summary, aes(x = day_of_week, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")

# Visualization for average duration
ggplot(bike_rides_sampled_summary, aes(x = day_of_week, y = as.numeric(average_duration), fill = member_casual)) +
  geom_col(position = "dodge")

