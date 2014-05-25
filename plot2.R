## Save the file "summarySCC_PM25.rds" to working directory

## Open the file
NEI <- readRDS("summarySCC_PM25.rds")

## Create a new dataset that is a subset of the original 
  # which contains observations for Baltimore City only
sub <- NEI[(NEI$fips=="24510"), ]

## Create the summary data set
q2 <- aggregate(sub$Emissions ~ as.factor(sub$year), sub, sum)

## Rename variables
names(q2) <- c("year","TotalEmissions")

## Create a variable with the numeric values of the factor levels of "year"
yr <- (as.numeric(levels(q2$year))[q2$year])

## Create a scatterplot of total emissions by year and add a trendline
q2g <- with(q2, plot(yr, TotalEmissions, 
                     main = "Total PM2.5 Emissions in Baltimore, selected years", 
                     xlab = "year", 
                     ylab = "Total PM2.5 Emissions", pch = 20))
model <- lm(TotalEmissions ~ as.numeric(yr), q2)
abline(model, lwd = 2)

## Save the graph
dev.copy(png, file = "Project2q2.png", width = 500, height = 480)
dev.off()