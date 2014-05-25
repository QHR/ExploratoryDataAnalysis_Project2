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

## Create the summary data set
q5 <- aggregate(MVBalt$Emissions ~ as.factor(MVBalt$year), MVBalt, sum)

## Rename variables
names(q5) <- c("year","TotalEmissions")

## Create a variable with the numeric values of the factor levels of "year"
q5$yr4 <- (as.numeric(levels(q5$year))[q5$year])

barplot(q5$TotalEmissions, xlab = "year", 
        ylab = "Total Emissions", 
        main = "Motor Vehicle-Related PM2.5 Emissions in Baltimore, 
        selected recent years",
        names.arg=q5$year)

## Save the graph
dev.copy(png, file = "Project2q5.png", width = 800, height = 400)
dev.off()
