#assumption: the file household_power_consumption.txt is in the working directory

#load the first column
firstcolumn <- read.table("household_power_consumption.txt", na.strings = "?", header = TRUE, sep=";", comment.char = "", colClasses = c(rep("character", 1), rep("NULL", 8)))

#find the first occurrence of 1/2/2007 to determine how many records to skip
recordstoskip <- which(firstcolumn[1] == '1/2/2007')[1] 

#find the first occurrence of 3/2/2007 to determine the last record to load
finalrecordtoload <- which(firstcolumn[1] == '3/2/2007')[1] 

#once we have these two number, can we determine the number of records to load
recordstoload <- finalrecordtoload - recordstoskip

consumption <- read.table("household_power_consumption.txt", na.strings = "?", header = FALSE, sep=";", comment.char = "", colClasses = c(rep("character", 2), rep("numeric", 7)), col.names = c("DateTime", "Time", "GlobalActivePower", "GlobalReactivePower", "Voltage", "GlobalIntensity", "SubMetering1", "SubMetering2", "SubMetering3"), nrows = recordstoload, skip = recordstoskip )

consumption$DateTime <- strptime(paste(consumption$DateTime, consumption$Time), format="%d/%m/%Y %H:%M:%S")
consumption$Time <- NULL

#Plot 4
#create PNG file
png(filename = "plot4.png")

par(mfrow = c(2, 2))
with(consumption, {
  with(consumption, plot(DateTime, GlobalActivePower, type="l", ylab="Global Active Power (kilowatts)", xlab=""))
  
  with(consumption, plot(DateTime, Voltage, type="l"))
  
  with(consumption, plot(DateTime, SubMetering1, type="l", ylab="Energy sub metering", xlab=""))
  with(consumption, lines(DateTime, SubMetering2, col="red"))
  with(consumption, lines(DateTime, SubMetering3, col="blue"))
  legend("topright", pch=NA, lty=1, lwd=1, col=c("black","red", "blue"), legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

  with(consumption, plot(DateTime, GlobalReactivePower, type="l", ylab="Global_reactive_power"))
  
})

dev.off()
