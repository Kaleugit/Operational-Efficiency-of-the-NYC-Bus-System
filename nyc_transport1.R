library(dplyr)
library(chron)
library(ggplot2)

#Load the data
mta_dec17 <- read.csv("mta_1712.csv", stringsAsFactors = FALSE)

#Let's use the function deg2rad to convert degrees to radians.
deg2rad <- function(deg) {
  return(deg * pi / 180)
}

getDistanceFromLatLonInKm <- function(lat1, lon1, lat2, lon2) {
  
  R <- 6371 
  dLat <- deg2rad(lat2 - lat1)  
  dLon <- deg2rad(lon2 - lon1) 
  
  a <- sin(dLat / 2)^2 +
    cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2)^2
  c <- 2 * atan2(sqrt(a), sqrt(1 - a))
  d <- R * c    
  
  return(d)
}

getDistanceVector <- function(df) {
  distance_vector <- 0
  
  for (i in 2:nrow(df)) {
    d <- getDistanceFromLatLonInKm(df$VehicleLocation.Latitude[i],
                                   df$VehicleLocation.Longitude[i],
                                   df$VehicleLocation.Latitude[i - 1],
                                   df$VehicleLocation.Longitude[i - 1])
    distance_vector <- c(distance_vector, d)
  }
  return(distance_vector)
}

#select the data that will be used
selected_buses <- as.list(c("NYCT_5231", "NYCT_406", "NYCT_4223", "NYCT_7080",
                            "NYCT_3809", "NYCT_8099", "NYCT_5888", "NYCT_4562", "NYCT_6714",
                            "NYCT_679", "NYCT_4250", "NYCT_328"))

mta_dec17$RecordedAtTime <- as.POSIXct(strptime(mta_dec17$RecordedAtTime,
                                                format = "%Y-%m-%d %H:%M:%S",
                                                tz = "America/New_York"))

buses <- select(mta_dec17,
                RecordedAtTime,
                VehicleRef,
                VehicleLocation.Latitude,
                VehicleLocation.Longitude) %>%
  filter(!is.na(RecordedAtTime)) %>%
  filter(VehicleRef %in% selected_buses)

buses$RecordedAtTime <-  as.integer(days(buses$RecordedAtTime))

#Generate the cumulative distance data frame for a specific bus
get_cum_dist <- function(bus) {
  df <- filter(buses,
               VehicleRef == bus)
  df$DistanceTravelled <- getDistanceVector(df)
  df <- df %>%
    group_by(RecordedAtTime) %>%
    summarise(DailyDistTrav = sum(DistanceTravelled)) %>%
    mutate(CumDistTrav = cumsum(DailyDistTrav)) %>%
    select(-DailyDistTrav)
  df$Vehicle <- bus
  
  return(df)
}

plot.df <- bind_rows(lapply(selected_buses, get_cum_dist))


##Get the daily average per vehicle
daily_dist_df <- plot.df %>%
  group_by(Vehicle, RecordedAtTime) %>%
  summarise(DailyDistTrav = sum(CumDistTrav)) %>%
  summarise(AvgDistTrav = mean(DailyDistTrav))

#Get Daily total distance
total_daily_dist <- plot.df %>%
  group_by(RecordedAtTime) %>%
  summarise(TotalDistTrav = sum(CumDistTrav))


##PLOTS BELOW

#Plot the daily average per vehicle
ggplot(daily_dist_df, aes(x = Vehicle, y = AvgDistTrav, fill = Vehicle)) +
  geom_bar(stat = "identity") +
  ggtitle("Average Daily Distance by Vehicle - Dec 2017") +
  labs(x = "Vehicle", y = "Average Distance (km)") +
  theme_minimal()


#Plot Daily total distance
ggplot(total_daily_dist, aes(x = RecordedAtTime, y = TotalDistTrav)) +
  geom_line(color = "blue", size = 1.0) +
  ggtitle("Total Distance Traveled by All Vehicles - Dec 2017") +
  labs(x = "Day of the Month", y = "Total Distance (km)") +
  theme_minimal()

#Plot Distance x Time
ggplot(plot.df, aes(x = RecordedAtTime, y = CumDistTrav, color = Vehicle)) +
  geom_point() +
  geom_smooth(se = FALSE) +
  ggtitle("Distance Accumulated Over Time") +
  labs(x = "Time", y = "Total Distance (km)") +
  theme_minimal()