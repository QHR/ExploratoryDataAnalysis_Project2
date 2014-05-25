## Save the files "summarySCC_PM25.rds" and "Source_Classification_Code.rds"
  # to the working directory

## Open the datasets
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

## Determine the levels of EI.Sector
l <- levels(SCC$EI.Sector)

## Find which ones involve coal
y <-grepl("Coal",l)

## How many are there?
sum(y)

# Answer = 3

## Copy their values
# "Fuel Comb - Comm/Institutional - Coal"
# "Fuel Comb - Electric Generation - Coal" 
# "Fuel Comb - Industrial Boilers, ICEs - Coal"

##Identify these observations in the dataset with these values for EI.Sector
SCC2 <- SCC[(SCC$EI.Sector == "Fuel Comb - Comm/Institutional - Coal" | 
               SCC$EI.Sector == "Fuel Comb - Electric Generation - Coal" |
               SCC$EI.Sector == "Fuel Comb - Industrial Boilers, ICEs - Coal" ), ]


## Create a frequency table of SCC variable observations in SCC2
coaltab <- data.frame(table(SCC2$SCC))

names(coaltab) <- c("SCC","n")

## Keep those values with >0 observations
coalSCC <- coaltab[coaltab$n >0, ]

## Save these values as a character vector
coal <- as.character(coalSCC$SCC)


## Save the subset of NEI that has one of the coal SCCs as CoalObs
CoalObs <- NEI[NEI$SCC %in% coal, ]

## Create the summary data set
q4 <- aggregate(CoalObs$Emissions ~ as.factor(CoalObs$year), CoalObs, sum)

## Rename variables
names(q4) <- c("year","TotalEmissions")

## Create a variable with the numeric values of the factor levels of "year"
q4$yr4 <- (as.numeric(levels(q4$year))[q4$year])


barplot(q4$TotalEmissions, xlab = "year", 
     ylab = "Total Emissions", 
     main = "U.S. Coal-Related PM2.5 Emissions, selected recent years",
     names.arg=q4$year)

## Save the graph
dev.copy(png, file = "Project2q4.png", width = 620, height = 400)
dev.off()
