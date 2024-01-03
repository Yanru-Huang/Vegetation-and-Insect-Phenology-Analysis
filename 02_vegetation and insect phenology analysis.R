###vegetation and insects phenology analysis###

# The primary objective of this R script is to investigate the effects of year, 
# latitude, and longitude on vegetation phenology (LUD), insect phenology (IOD), 
# and their difference (VID) using a quantile regression model. 
# It aims to calculate the trends of these changes over time.

# Load the required libraries
library(stats)
library(mgcv)
library(ggplot2)
library(grid)
library(quantreg)
library(boot)

# Set the working directory
path <- "...your_path\\"  #Modified to the path where phenology data are stored 
setwd(dir = path)

# Read the file list
speciesfile <- list.files()

# Initialise the data frame
tab <- as.data.frame(matrix(nrow = length(speciesfile), ncol = 0))
column_names <- c("order", "species", "mode", "intercept", "year", "year_p", "Latitude", "Latitude_p", "Longitude", "Longitude_p", "diff1", "VID1980", "VID2015")
tab[, column_names] <- ""

# Define a function to process a single file
process_file <- function(file_name) {
  # read the file
  data <- read.csv(file_name, sep = ',', encoding = "UTF-8")
  
  # Perform quantile regression
  insect_glm <- rq(VID ~ year + Latitude * Longitude, data = data)
  # Statistical coefficients and significance
  sum <- summary(insect_glm, se = "iid")
  
  # Extract the results
  species <- strsplit(basename(file_name), "\\.")[[1]][1]
  mode <- strsplit(species, "_")[[1]][2]
  intercept <- sum$coefficients[1]
  year_coefficient <- sum$coefficients[2]
  year_p <- sum$coefficients[17] # p-value
  latitude <- sum$coefficients[3] 
  latitude_p <- sum$coefficients[18] 
  longitude <- sum$coefficients[4]
  longitude_p <- sum$coefficients[19] 
  
  # Predict and calculate the trend of increase or decrease in VID
  data1 <- data
  data1$year <- 1982
  predicted1 <- predict(insect_glm, newdata = data1)
  data1$year <- 2015
  predicted2 <- predict(insect_glm, newdata = data1)
  diff1 <- mean(abs(predicted2) - abs(predicted1))
  
  # Return the processed data
  return(c(data$order[1], species, mode, intercept, year_coefficient, year_p, latitude, latitude_p, longitude, longitude_p, diff1, mean(predicted1), mean(predicted2)))
}

# Process each file using a loop
for (i in 1:length(speciesfile)) {
  file <- paste(path, speciesfile[i], sep = "")
  tab[i,] <- process_file(file)
}

# Process data related to the year
tab$year <- as.numeric(tab$year)
tab$year_p <- as.numeric(tab$year_p)
tab$adj_year <- ifelse(tab$diff1 >= 0, abs(tab$year), -abs(tab$year))
tab$significance <- ifelse(tab$year_p < 0.05, 1, 0) # Is the result significant 1 - Significant 0 - Not significant 

#save the result
df <- tab[, c("order", "species", "mode", "adj_year", "significance")]
colnames(df)[colnames(df) == "adj_year"] <- "year_coefficients"
colnames(df)[colnames(df) == "significance"] <- "year_significance"
write.csv(df, "...your_path\\VID_shift_rate_result.csv", row.names = FALSE) #Modified to the path where you want to store the result 
