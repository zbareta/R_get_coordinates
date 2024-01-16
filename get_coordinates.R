library(httr)
library(readxl)

# Set your OpenCage API key
key <- "API_KEY_GOES_HERE"

# Read the original Excel file
original_df <- read_excel("list.xlsx")

# Function to geocode a location
geocode_location <- function(location) {
  url <- paste0("https://api.opencagedata.com/geocode/v1/json?q=", URLencode(location), "&key=", key)
  response <- GET(url)
  result <- content(response, "parsed")

  if (length(result$results) > 0) {
    coordinates <- result$results[[1]]$geometry
    return(c(lat = coordinates$lat, lng = coordinates$lng))
  } else {
    return(c(lat = NA, lng = NA))
  }
}

# Apply the geocoding function to the 'Location' column
coordinates_list <- lapply(original_df$Location, geocode_location)

# Create a data frame from the list of coordinates
coordinates_df <- do.call(rbind, coordinates_list)

# Combine the original data frame with the new coordinates
new_df <- cbind(original_df, coordinates_df)

# Print the results to the console
print(new_df)

# Save the results to a new CSV file
write.csv(new_df, "List_new.csv", row.names = FALSE)