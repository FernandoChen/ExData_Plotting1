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

png(filename = "plot2.png")
with(consumption, plot(DateTime, GlobalActivePower, type="l", ylab="Global Active Power (kilowatts)", xlab=""))
dev.off()
