# Install required packages if not already installed
if (!requireNamespace("gtrendsR", quietly = TRUE)) {
  install.packages("gtrendsR")
}
if (!requireNamespace("ggplot2", quietly = TRUE)) {
  install.packages("ggplot2")
}
if (!requireNamespace("dplyr", quietly = TRUE)) {
  install.packages("dplyr")
}

# Load the required libraries
library(gtrendsR)
library(ggplot2)
library(dplyr)

# Define Telugu movie titles for 2024
telugu_movies_2024 <- c(
  "Mathu Vadalara 2", "Tillu Square", "35-Chinna Katha Kaadu", 
  "Darling", "Srikanth", "Maa Nanna Superhero", "Janaka", 
  "Mahendragiri Varahi", "Sharwa 37", "Narendra", "Nakide First Time", 
  "Rakshasudu 2", "Paradha", "Kalki 2898 AD", "Pushpa: The Rule", 
  "Saripodhaa Sanivaaram", "Thandel", "Mega 156", "OG - Original Gangsters", 
  "Game Changer", "Devara", "Gangs Of Godavari", "Family Star", 
  "Eagle", "Naa Saami Ranga", "Saindhav", "Guntur Kaaram", "HanuMan"
)

# Define parameters
geo <- "IN"  # Geographic region (India)
time_frame <- "2024-01-01 2024-11-15"  # Time period for analysis
output_file <- "trends_data.RDS"  # File to save/load data

# Helper function to fetch trends data for batches of movies
fetch_trends_data <- function(movie_batch, geo, time_frame) {
  tryCatch({
    Sys.sleep(20)  # Delay to avoid rate limits
    gtrends(keyword = movie_batch, geo = geo, time = time_frame)
  }, error = function(e) {
    message("Error fetching data for batch: ", movie_batch, ". Error: ", e$message)
    NULL
  })
}

# Load data from file if it exists
if (file.exists(output_file)) {
  message("Loading data from file...")
  trends_results <- readRDS(output_file)
} else {
  # Fetch new data if the file doesn't exist
  message("Fetching data from Google Trends API...")
  movie_batches <- split(telugu_movies_2024, ceiling(seq_along(telugu_movies_2024) / 5))
  trends_results <- lapply(movie_batches, function(batch) fetch_trends_data(batch, geo, time_frame))
  
  # Save the data to a file for future use
  saveRDS(trends_results, output_file)
}

# Summarize total interest and create a pie chart
if (!is.null(interest_over_time_data) && nrow(interest_over_time_data) > 0) {
  interest_over_time_data$hits <- as.numeric(interest_over_time_data$hits)
  total_interest <- interest_over_time_data %>%
    group_by(keyword) %>%
    summarise(total_hits = sum(hits, na.rm = TRUE))
  
  pie_data <- total_interest %>%
    mutate(percentage = total_hits / sum(total_hits) * 100)
  
  pie_chart <- ggplot(pie_data, aes(x = "", y = percentage, fill = keyword)) +
    geom_bar(stat = "identity", width = 1, color = "white") +
    coord_polar(theta = "y") +
    labs(title = "Search Interest Distribution for Telugu Movies in 2024",
         fill = "Movie Title") +
    theme_void()
  # Save the pie chart as PNG
  ggsave("search_interest_distribution.png", pie_chart, width = 10, height = 6)
}

# Save regional interest
regional_interest <- do.call(rbind, lapply(trends_results, function(x) x$interest_by_region))
if (!is.null(regional_interest)) {
  write.csv(regional_interest, "regional_interest.csv", row.names = FALSE)
  print("Regional interest saved successfully.")
}

# Save related queries
related_queries <- do.call(rbind, lapply(trends_results, function(x) x$related_queries))
if (!is.null(related_queries)) {
  write.csv(related_queries, "related_queries.csv", row.names = FALSE)
  print("Related queries saved successfully.")
}

# Compare trends for a few top movies
if (!is.null(interest_over_time_data) && nrow(interest_over_time_data) > 0) {
  top_movies <- total_interest %>%
    top_n(3, total_hits) %>%
    pull(keyword)
  
  comparison_data <- interest_over_time_data %>%
    filter(keyword %in% top_movies)
  
  comparison_plot <- ggplot(comparison_data, aes(x = date, y = hits, color = keyword)) +
    geom_line(size = 1) +
    labs(title = "Trend Comparison for Top 3 Movies",
         x = "Date", y = "Search Interest", color = "Movie Title") +
    theme_minimal()
  # Save the comparison plot as PNG
  ggsave("trend_comparison_top3.png", comparison_plot, width = 10, height = 6)
}
# Load the CSV files
interest_over_time <- read.csv("interest_over_time_data.csv", stringsAsFactors = FALSE)
regional_interest <- read.csv("regional_interest.csv", stringsAsFactors = FALSE)

### Data Cleanup ###

# 1. Cleanup for interest_over_time
interest_over_time <- interest_over_time %>%
  mutate(
    hits = as.numeric(gsub("<1", "0.5", hits)), # Replace "<1" with 0.5 for numeric conversion
    date = as.Date(date) # Convert 'date' to Date type
  ) %>%
  filter(!is.na(hits) & hits > 0) %>%
  distinct()

# 2. Cleanup for regional_interest
# Rename columns if necessary
if ("geoName" %in% colnames(regional_interest)) {
  regional_interest <- regional_interest %>%
    rename(Region = geoName)
}

regional_interest <- regional_interest %>%
  mutate(hits = as.numeric(hits)) %>%
  filter(!is.na(hits) & hits > 0) %>%
  distinct()

### Visualizations ###

# 1. Trend of Search Interest Over Time (Line Chart)
trend_plot <- ggplot(interest_over_time, aes(x = date, y = hits, color = keyword)) +
  geom_line(size = 1) +
  labs(
    title = "Search Interest Over Time for Telugu Movies",
    x = "Date",
    y = "Search Interest",
    color = "Movie Title"
  ) +
  theme_minimal()

# Save the trend plot
ggsave("cleaned_trend_over_time.png", trend_plot, width = 10, height = 6)

# 2. Regional Interest Distribution (Bar Chart)
# Verify the column names in regional_interest
print("Regional Interest Data Column Names:")
print(colnames(regional_interest))

# Rename the region column if it exists
if ("geoName" %in% colnames(regional_interest)) {
  regional_interest <- regional_interest %>%
    rename(Region = geoName)
} else if ("location" %in% colnames(regional_interest)) {
  regional_interest <- regional_interest %>%
    rename(Region = location)
} else {
  stop("The regional_interest dataset does not contain a recognizable region column.")
}

# Proceed with cleanup and visualization
regional_interest <- regional_interest %>%
  mutate(hits = as.numeric(hits)) %>%
  filter(!is.na(hits) & hits > 0)

if (nrow(regional_interest) > 0) {
  top_regions <- regional_interest %>%
    group_by(Region) %>%
    summarise(total_hits = sum(hits, na.rm = TRUE)) %>%
    arrange(desc(total_hits)) %>%
    slice_max(order_by = total_hits, n = 10)
  
  # Generate regional interest distribution plot
  region_plot <- ggplot(top_regions, aes(x = reorder(Region, -total_hits), y = total_hits, fill = Region)) +
    geom_bar(stat = "identity") +
    labs(
      title = "Regional Interest Distribution",
      x = "Region",
      y = "Total Hits"
    ) +
    theme_minimal() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  # Save the plot
  ggsave("regional_interest_distribution.png", region_plot, width = 10, height = 6)
} else {
  print("No valid data available for regional interest.")
}

# 3. Comparison of Top Movies (Bar Chart)
top_movies <- interest_over_time %>%
  group_by(keyword) %>%
  summarise(total_hits = sum(hits, na.rm = TRUE)) %>%
  arrange(desc(total_hits)) %>%
  slice_max(order_by = total_hits, n = 5)

top_movies_plot <- ggplot(top_movies, aes(x = reorder(keyword, -total_hits), y = total_hits, fill = keyword)) +
  geom_bar(stat = "identity") +
  labs(
    title = "Top 5 Movies by Total Search Interest",
    x = "Movie Title",
    y = "Total Search Interest"
  ) +
  theme_minimal()

# Save the top movies plot
ggsave("top_movies_comparison.png", top_movies_plot, width = 10, height = 6)

### Save Cleaned Data ###
write.csv(interest_over_time, "cleaned_interest_over_time.csv", row.names = FALSE)
write.csv(regional_interest, "cleaned_regional_interest.csv", row.names = FALSE)

print("Visualizations and cleaned data saved successfully.")
