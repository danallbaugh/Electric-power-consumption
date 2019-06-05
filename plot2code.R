library(dplyr)
library(lubridate)

url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
dest <- "./data/powerconsumption.zip"

if(!dir.exists("./data/")) {dir.create("./data")}
if(!file.exists(dest)) {download.file(url, dest)}
if(!file.exists("./data/household_power_consumption.txt")) {unzip(zipfile = dest, exdir = "./data")}

#read data to table
all_data <- read.table("./data/household_power_consumption.txt", sep = ";", header = TRUE)
all_data <- tbl_df(all_data)

#convert Date column from character to Date format
date_convert <- mutate(all_data, Date = as.Date(dmy(all_data$Date)))
filtered_data <- filter(date_convert, Date == "2007-02-01" | Date == "2007-02-02")

#converting columns 3-8 to integers
i <- c(3:8)
filtered_data[,i] <- apply(filtered_data[,i], 2, function(x)as.numeric(as.character(x)))


png("plot2.png", width=480, height=480)
plot(filtered_data$Global_active_power, type = "l", xaxt = "n", ylab = "Global Active Power (kilowatts)", xlab = "")
axis(1, at = c(0, count(filtered_data)/2, count(filtered_data)),labels = c("Thu", "Fri", "Sat"))
dev.off()

