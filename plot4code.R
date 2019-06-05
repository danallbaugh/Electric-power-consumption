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

#plotting
png("plot4.png")
par(mfrow=c(2,2))

plot(filtered_data$Global_active_power, type = "l", xaxt = "n", ylab = "Global Active Power", xlab = "")
axis(1, at = c(0, count(filtered_data)/2, count(filtered_data)),labels = c("Thu", "Fri", "Sat"))


plot(filtered_data$Voltage, type = "l", xaxt = "n", ylab = "Voltage", xlab = "datetime")
axis(1, at = c(0, count(filtered_data)/2, count(filtered_data)),labels = c("Thu", "Fri", "Sat"))

plot(filtered_data$Sub_metering_1, type = "l", xaxt = "n", ylab = "Energy sub metering", xlab = "")
lines(filtered_data$Sub_metering_2, type = "l", col = "red")
lines(filtered_data$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col = c("black", "red","blue"), lty = 1)
axis(1, at = c(0, count(filtered_data)/2, count(filtered_data)),labels = c("Thu", "Fri", "Sat"))

plot(filtered_data$Global_reactive_power, type = "l", xaxt = "n", xlab = "datetime")
axis(1, at = c(0, count(filtered_data)/2, count(filtered_data)),labels = c("Thu", "Fri", "Sat"))
dev.off()
