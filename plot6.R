## Save the files "summarySCC_PM25.rds" and "Source_Classification_Code.rds"
# to the working directory

## Open the datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Determine the levels of EI.Sector
l <- levels(SCC$EI.Sector)

## Find which ones involve coal
z <-grepl("Vehicles",l)

## How many are there?
sum(z)

# Answer = 4

## Copy their values
# "Mobile - On-Road Diesel Heavy Duty Vehicles"       
# "Mobile - On-Road Diesel Light Duty Vehicles"       
# "Mobile - On-Road Gasoline Heavy Duty Vehicles"     
# "Mobile - On-Road Gasoline Light Duty Vehicles"  


##Identify these observations in the dataset with these values for EI.Sector
SCC5 <- SCC[(SCC$EI.Sector == "Mobile - On-Road Diesel Heavy Duty Vehicles" | 
               SCC$EI.Sector == "Mobile - On-Road Diesel Light Duty Vehicles" |
               SCC$EI.Sector == "Mobile - On-Road Gasoline 
             Heavy Duty Vehicles" |
               SCC$EI.Sector == "Mobile - On-Road Gasoline 
             Light Duty Vehicles" ), ]


## Create a frequency table of SCC variable observations in SCC2
mvtab <- data.frame(table(SCC5$SCC))

names(mvtab) <- c("SCC","n")

## Keep those values with >0 observations
mvSCC <- mvtab[mvtab$n >0, ]

## Save these values as a character vector
vehicle <- as.character(mvSCC$SCC)


## Save the subset of NEI that has one of the coal SCCs as CoalObs
MVObs <- NEI[NEI$SCC %in% vehicle, ]



## Create a new dataset which contains observations for Baltimore City only
MVBalt <- MVObs[(MVObs$fips=="24510"), ]

## Create a new dataset which contains observations for Los Angeles only
MVLA <- MVObs[(MVObs$fips=="06037"), ]

## Create a summary data set for each city, and append the city name
sBalt <- aggregate(MVBalt$Emissions ~ as.factor(MVBalt$year), MVBalt, sum)
city1 <- rep("Baltimore", 4)
BaltSum <- cbind(sBalt, city1)

sLA <- aggregate(MVLA$Emissions ~ as.factor(MVLA$year), MVLA, sum)
city2 <- rep("Los Angeles", 4)
LASum <- cbind(sLA, city2)

## Rename the variables in each dataset
names(BaltSum) <- c("year","TotalEmissions", "city")
names(LASum) <- c("year","TotalEmissions", "city")

## Merge the datasets
cities <- rbind(BaltSum, LASum)


## Create a variable with the numeric values of the factor levels of "year"
cities$yr <- (as.numeric(levels(cities$year))[cities$year])

## Create the plot
qplot(yr, TotalEmissions, data = cities, facets = . ~ city, xlab = "year", 
      ylab = "PM2.5 Emisssions",
      main = "Vehicle-Related PM2.5 Emissions in Baltimore 
      and LA, selected years") + geom_line()


## Save the graph
dev.copy(png, file = "Project2q6.png",  width = 600, height = 300)
dev.off()