## Open the file
NEI <- readRDS("summarySCC_PM25.rds")


## Create a new dataset that is a subset of the original 
# which contains observations for Baltimore City only
sub <- NEI[(NEI$fips=="24510"), ]

## Create new datasets that are subsets of the original 
# which contain only observations alternately for each pollution source type

point <- sub[(sub$type =="POINT"), ]
nonpoint <- sub[(sub$type =="NONPOINT"), ]
onroad <- sub[(sub$type =="ON-ROAD"), ]
nonroad <- sub[(sub$type =="NON-ROAD"), ]

## Create a summary data set for each type, and append the type
spoint <- aggregate(point$Emissions ~ as.factor(point$year), point, sum)
type1 <- rep("Point", 4)
sumpoint <- cbind(spoint, type1)

snonpoint <- aggregate(nonpoint$Emissions ~ as.factor(nonpoint$year), 
                         nonpoint, sum)
type2 <- rep("Nonpoint", 4)
sumnonpoint <- cbind(snonpoint, type2)

sonroad <- aggregate(onroad$Emissions ~ as.factor(onroad$year), onroad, sum)
type3 <- rep("On-Road", 4)
sumonroad <- cbind(sonroad, type3)


snonroad <- aggregate(nonroad$Emissions ~ as.factor(nonroad$year), 
                        nonroad, sum)
type4 <- rep("Non-Road", 4)
sumnonroad <- cbind(snonroad, type4)

## Rename the variables in each dataset
names(sumpoint) <- c("year","TotalEmissions", "type")
names(sumnonpoint) <- c("year","TotalEmissions", "type")
names(sumonroad) <- c("year","TotalEmissions", "type")
names(sumnonroad) <- c("year","TotalEmissions", "type")

## Merge the datasets
total <- rbind(sumpoint, sumnonpoint, sumonroad, sumnonroad)

## Create a variable with the numeric values of the factor levels of "year"
total$yr <- (as.numeric(levels(total$year))[total$year])

## Activate ggplot
library(ggplot2)

## Create the plot
qplot(yr, TotalEmissions, data=total, geom = c("point", "smooth"), 
      method = "lm", facets = . ~ type, xlab = "year", 
      ylab = "Total PM2.5 Emissions", 
      main = "Total PM2.5 Emissions in Baltimore, by type, selected years")

## Save the graph
dev.copy(png, file = "Project2q3.png",  width = 600, height = 300)
dev.off()
