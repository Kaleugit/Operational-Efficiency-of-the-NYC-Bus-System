# Operational-Efficiency-of-the-NYC-Bus-System
GTFS - New York City Transport EDA

Objective of the Analysis:
The primary goal of this EDA is to evaluate the operational efficiency of the NYC bus system by analyzing several key metrics related to bus movement and performance:

Daily Average Distance per Vehicle: Calculating the average distance traveled by each vehicle per day. Total Daily Distance: Measuring the total distance covered by all buses combined each day. Cumulative Distance over Time: Tracking the cumulative distance covered by the fleet over time to observe operational patterns and trends.

> > New York City Transport EDA
This Exploratory Data Analysis focuses on a dataset from the New York City public bus system, with data entries recorded every 10 minutes for the month of June 2017. The analysis aims to assess the accuracy of bus arrival time predictions based on scheduled and expected arrival times. The key features in the dataset and their descriptions are as follows:

RecordedAtTime DirectionRef PublishedLineName OriginRef DestinationRef VehicleRef VehicleLocation.Latitude VehicleLocation.Longitude StopPointName ExpectedArrivalTime ScheduledArrivalTime

RecordedAtTime: The timestamp of the vehicle observation. Observations are taken approximately every 10 minutes while the vehicle is in service during June 2017.

DirectionRef: Indicates the direction of the bus route. 0: Outbound (moving away from a transit center). 1: Inbound (moving towards a transit center).

PublishedLineName: The bus route name. Only a selected subset of bus routes is included due to storage limitations.

OriginRef: The ID of the bus stop where the route originates.

DestinationRef: The ID of the bus stop where the route terminates.

DestinationName: The name of the final destination of the bus route.

VehicleRef: Unique ID number assigned to each bus.

VehicleLocation.Longitude & VehicleLocation.Latitude: The geographic coordinates (longitude and latitude) of the vehicle at the time of the observation.

ExpectedArrivalTime: The predicted actual arrival time of the bus at its next stop, based on real-time data at the time of the observation.

StopPointRef: The ID of the bus stop for the next scheduled stop.

StopPointName: The name of the bus stop where the next stop is scheduled. The dataset includes the 25 most popular next stops.

ScheduledArrivalTime: The scheduled arrival time for the next stop, according to the official MTA bus timetable.
