#######################################
#  
# Reading data and clean data
#
#######################################


options(stringsAsFactors = FALSE)
setwd("U:/CourseRA/Exploratory_Data_Analysis")

# A small trial dataset to get the structure of the larger data
trydata <- read.table("household_power_consumption.txt", 
                      header=T, nrows=5, sep=";", na.strings ="?")
classes <- c("character", "character", "numeric", "numeric", 
             "numeric", "numeric","numeric", "numeric","numeric")

# I used trial and error to find a rough row range to load
data <- read.table("household_power_consumption.txt",
                   header=F, skip=66000, nrows=5000, sep=";", 
                   na.strings ="?",
                   colClasses=classes)

# assign names because we skipped header also
names(data) <- names(trydata)

# merge Date and Time columns to a proper datetime object
data <- transform(data, Date=as.Date(Date, format="%d/%m/%Y"))
data <- subset(data, Date== "2007-02-01" | Date== "2007-02-02")
datetime <- paste(data$Date, data$Time)
datetime <- strptime(datetime, format="%Y-%m-%d %H:%M:%S")
data <- cbind(datetime, data[, 3:9])


#######################################
#  
# Making plot-4
#
#######################################


png("plot4.png", height = 480, width = 480)
par(mfrow = c(2, 2))

# subplot(1,1)
plot(data$datetime, data$Global_active_power, 
     ylab="", xlab="",
     type="l")
title(ylab = "Global Active Power")

# subplot(1,2)
plot(data$datetime, data$Voltage, 
     ylab="Voltage", xlab="datetime",
     type="l")

# subplot(2,1)
plot(data$datetime, data$Sub_metering_1, col="black",
     ylab="", xlab="",
     type="l")
lines(data$datetime, data$Sub_metering_2, col="red")
lines(data$datetime, data$Sub_metering_3, col="blue")
title(ylab = "Energy sub metering")
legend("topright",
       c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"), 
       lty=c(1,1), # gives the legend appropriate symbols (lines)
       bty="n",
       col=c("black","red", "blue"))

# subplot(2,2)
with(data, plot(datetime, Global_reactive_power, 
      xlab="datetime",
      lwd=0.25,
     type="l"))



dev.off()