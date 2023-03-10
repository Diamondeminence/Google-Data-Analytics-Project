# **Cyclistic Bike-Share: Case Study**

_This document is created as part of the capstone project of the Google Data Analytics Professional Certificate._

## Introduction and Scenario
You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.

### **About the Company**
In 2016, Cyclistic launched a successful bike-share offering. Since then, the program has grown to a fleet of 5,824 bicycles that are geo-tracked and locked into a network of 692 stations across Chicago. The bikes can be unlocked from one station and returned to any other station in the system anytime.

The project follows the six step data analysis process: **ask, prepare, process, analyze, share, and act**.

## **PHASE 1: Ask** 
Three questions will guide the future marketing program:
 1. How do annual members and casual riders use Cyclistic bikes
    differently? 
 2. why would casual riders buy Cyclistic annual memberships?
 3. How can Cyclistic use digital media to influence casual
        riders to become members?
        
The director of marketing has assigned you the first question to answer: 
**How do annual members and casual riders use Cyclistic bikes differently?**

**Summary of Business Task**

The goal of this case study is to identify how do annual members and casual riders use Cyclistic bikes differently.

This comparison along with other tasks will later be used by marketing department for developing strategies aimed at converting casual riders into members

**Stakeholders:**

Primary stakeholders: The director of marketing and Cyclistic executive team

Secondary stakeholders: Cyclistic marketing analytics team

## **PHASE 2: Data Preparation**

The data that we will be using is Cyclistic’s historical trip data from last 12 months (Oct-2021 to Sept-2022). The data has been made available by Motivate International Inc. on this [link](https://divvy-tripdata.s3.amazonaws.com/index.html) under this [license](https://www.divvybikes.com/data-license-agreement).

The dataset consists of 12 CSV files (each for a month) with 13 columns and more than 4 million rows.

ROCCC approach is used to determine the credibility of the data

-   **R**eliable – It is complete and accurate and it represents all bike rides taken in the city of Chicago for the selected duration of our analysis.
-   **O**riginal - The data is made available by Motivate International Inc. which operates the city of Chicago’s Divvy bicycle sharing service which is powered by Lyft.
-   **C**omprehensive - the data includes all information about ride details including starting time, ending time, station name, station ID, type of membership and many more.
-   **C**urrent – It is up-to-date as it includes data until end of May 2021
-   **C**ited - The data is cited and is available under Data License Agreement.

**Data Limitation**

A quick filtering and checking data for completeness shows that “start station name and ID” and “end station name and ID” for some rides are missing. Further observations suggest that the most missing data about “start station name” belongs to “electric bikes” as 201,975 out of 888,490 electric ride shares have missing data and it accounts for 22% of total electric-bike ride shares.

This limitation could slightly affect our analysis for finding stations where most electric-bikes are taken but we can use “end station names” to locate our customers and this can be used for further analysis and potential marketing campaigns.
<![endif]-->

## **PHASE 3: Process**

Before we start analyzing, it is necessary to make sure data is clean, free of error and in the right format.
### **Tasks:**

 **1. Tools:** R Programming is used for its ability to handle huge datasets efficiently. Microsoft Excel is used for further analysis and visualization. 

	># Load packages in R
	>library(tidyverse)
	>library(janitor)
	>library(lubridate)
	>library(readr)
	>library(dplyr)
	>library(skimr)
	>library(ggplot2)

**2. Organize**: Combined all 12 datasets into one.

	># Add files to the list and combine all 12 files into a single csv file  	
	>files <- dir("CSV/", full.names = T)  	
	bike_rides <-rbind(df1,df2,df3,df4,df5,df6,df7,df8,df9,df10,df11,df12)


**3. Sampling**: Due to limitation in computational power and efficiency purposes, I had to take a random sample without replacement out of 4,073,561 observations. Sample size is calculated as follow:
 - Population size: 5,828,235
 - Confidence level: 99.99%
 - Margin of Error: 0.2
 - Sample size: 606,149

 bikerides <- sample_n(bike_rides, 606149, replace = F)


**4. Preparing for analysis**

- Added column called “ride_length and calculated the length of each ride
- Added new columns to calculate the following for each ride.
	- Date
	- Year
	- Month
	- Day
	- Day of the week
 - These columns provide additional opportunities to aggregate the data.

		>bikerides$date <- as.Date(bikerides$started_at)
 
		>bikerides$year <- format(as.Date(bikerides$date), "%Y")
 
		>bikerides$month <- format(as.Date(bikerides$date), "%m")
		>bikerides$day <- format(as.Date(bikerides$date), "%d")

		>bikerides <- bikerides %>% 
		>  mutate(ride_length = ended_at - started_at) %>%   
		>  mutate(day_of_week = weekdays(as.Date(bikerides$started_at)))

**5. Check data for errors**: A quick sorting and filtering shows that in 1931 rows, there is a negative difference between two time periods (started_at and ended_at) which logically isn’t possible.
	Removed the rows where trip duration is negative.

	>bikerides <- bikerides %>%
  		filter(ride_length > 0)


**6. Clean column names and checked for duplicate records in rows.**

    >bikerides <- bikerides %>%
  	clean_names() %>%
  	unique()


## PHASE 4: Analyzing Data
Performed data aggregation using R Programming.
- Click [here](https://github.com/Diamondeminence/Google-Data-Analytics-Project/blob/main/Cyclistic%20Script.R) to view the R script and the summary of complete analysis process.

Further analysis were carried out to perform calculations, identify trends and relationships using PivotTable and Charts on Microsoft Excel.

 - Click [here](https://github.com/Diamondeminence/Google-Data-Analytics-Project/blob/main/BikeRidesSummary.xlsx) to view individual Excel files used for analysis

## PHASE 5: Share
Microsoft PowerPoint is used for data visualization and presenting key insights.
- Click [here](https://github.com/Diamondeminence/Google-Data-Analytics-Project/blob/main/Case%20StudyPresentation.pptx) to download the presentation.

## PHASE 6: Act
After analizing, we reached to the following conclusion:
- Casual riders take less number of rides but for longer durations.
- Casual Riders are most active on weekends, and the months of June and July.
- Casual riders mostly use bikes for recreational purposes.

Here are my top 3 recommendations based on above key findings:
1. Design riding packages by keeping recreational activities, weekend contests, and summer events in mind and offer special discounts and coupons on such events to encourage casual riders get annual membership.

2. Design seasonal packages, It allows flexibility and encourages casual riders to get membership for specific periods if they are not willing to pay for annual subscription.

3. Effective and efficient promotions by targeting casual riders at the busiest times and stations:
	- Days: Weekends
	- Months: April, May, and September
	- Stations: Streeter Dr & Grand Ave, DuSable Lake Shore Dr & North Blvd, Millennium Park


***Thank you for reading and Happy Analyzing!*** :smiley: :bar_chart:
