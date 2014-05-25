## Save the file "summarySCC_PM25.rds" to working directory

## Open the file
NEI <- readRDS("summarySCC_PM25.rds")

## Create the summary data set
q1 <- aggregate(NEI$Emissions ~ as.factor(NEI$year), NEI, sum)

## Rename variables
names(q1) <- c("year","TotalEmissions")

## Create a variable with the numeric values of the factor levels of "year"
yr1 <- (as.numeric(levels(q1$year))[q1$year])

## Create a scatterplot of total emissions by year and add a trendline
q1g <- with(q1, plot(yr1, TotalEmissions, 
                     main = "Total PM2.5 Emissions in U.S., selected years", 
                     xlab = "year", 
                     ylab = "Total PM2.5 Emissions", pch = 20))
model <- lm(TotalEmissions ~ as.numeric(yr1), q1)
abline(model, lwd = 2)

## Save the graph
dev.copy(png, file = "Project2q1.png", width = 480, height = 480)
dev.off()
