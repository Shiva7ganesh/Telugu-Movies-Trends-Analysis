# Telugu Movie Trends Analysis with Google Trends API

## Abstract

The **Telugu Movie Trends Analysis** project utilizes the **Google Trends API** to analyze and visualize search interest patterns for Telugu movies scheduled for release in 2024. The project leverages **R programming** along with key libraries such as **gtrendsR**, **ggplot2**, and **dplyr** to extract and process trends data. It focuses on tracking fluctuations in search interest over time, understanding regional preferences, and analyzing related queries, ultimately offering insights into audience sentiment and movie popularity.

## Introduction

The primary goal of this project is to explore the public interest in Telugu movies set for release in 2024, using the **Google Trends API** to gather and analyze search behavior data. By employing **R programming** for data extraction, processing, and visualization, the project provides actionable insights into trends over time, geographical interest, and the popularity of specific movies.

## Dataset Description

This analysis is based on data retrieved from the **Google Trends API**, focusing on search interest in Telugu movies set to release in 2024. The dataset consists of the following columns:

- **Date**: Date of search activity.
- **Keyword**: Telugu movie title.
- **Hits**: Normalized search interest, ranging from 0 to 100.
- **Region**: Geographical area of search origin (e.g., states or cities).
- **Related Query**: Associated search terms related to the movie title.
- **Relevance**: Degree of association between the search term and movie title.

## Exploratory Data Analysis (EDA)

### 1. Loading and Cleaning the Dataset  
   - Importing two key datasets: interest over time and regional interest.
   - Cleaning data by handling missing values, replacing "<1" values with 0.5, and converting dates into Date format.
   - Removing duplicates to ensure the data integrity.

### 2. Analyzing Search Interest Over Time  
   - Visualization: Line chart depicting the fluctuation in search interest over time for each Telugu movie.
   - Insights: Identify key events (like trailers, promotions) influencing search spikes.

   ![Search Interest Over Time](https://github.com/user-attachments/assets/53a258d2-9e28-4dc9-a311-1255eedeef9a)

   *Figure 1: Search Interest Over Time for Telugu Movies in 2024*

### 3. Regional Interest Analysis  
   - Summing search interest for each region and identifying the top 10 regions.
   - Visualization: Bar chart showing regional distribution of search interest.
 
   ![Regional Interest](https://github.com/user-attachments/assets/44bcd8e1-0f04-4007-8072-3f098bcf8ec6)

   *Figure 2: Regional Search Interest Distribution*

### 4. Search Interest Distribution  
   - Visualization: Pie chart displaying the share of search interest each movie receives.
   - Insights: Identify the most anticipated Telugu movies based on search interest.
 
   ![Search Interest Distribution](https://github.com/user-attachments/assets/8e2901a3-9b19-4360-b4cf-9ca630288c56)

   *Figure 3: Search Interest Distribution for Telugu Movies in 2024*

### 5. Top Movies Trend Comparison  
   - Visualization: Line chart comparing search trends for the top 3 Telugu movies.
   - Insights: Understanding engagement patterns for top movies based on search interest.
 
   ![Top Movies Trend Comparison](https://github.com/user-attachments/assets/bfb5388c-7323-4971-9730-ce9d877bb020)

   *Figure 4: Trend Comparison for the Top 3 Movies*

## Requirements

### Software Requirements

- **R**: Version 4.0.0 or later.
- **RStudio**: The latest stable version of RStudio Desktop.
- **R Packages**:
  - `gtrendsR`: For fetching Google Trends data.
  - `ggplot2`: For generating visualizations.
  - `dplyr`: For data manipulation and cleaning.

### Hardware Requirements

- **Operating System**: Windows 10+, macOS 10.15+, or Linux (Ubuntu 18.04+).
- **Processor**: Modern multi-core processor (e.g., Intel i5/i7).
- **RAM**: Minimum of 8 GB (16 GB recommended for larger datasets).
- **Graphics Card**: Optional for advanced visualizations.

## Output

- **Trend of Search Interest Over Time (Line Chart)**: A visualization of how the search interest for Telugu movies has evolved over time.

- **Regional Interest Distribution (Bar Chart)**: Insights into which regions show the highest engagement with Telugu movies.

- **Search Interest Distribution (Pie Chart)**: Displays the proportion of total search interest each movie commands.

- **Top Movies Trend Comparison (Line Chart)**: A comparative view of the search interest for the top 3 movies over time.

## Conclusion

The **Telugu Movie Trends Analysis** project effectively demonstrates how **Google Trends** data can be leveraged to track and analyze public interest in Telugu movies. By processing and visualizing the data with **R programming**, key insights into audience behavior, regional preferences, and trends are uncovered. These insights can be valuable for filmmakers, distributors, and marketing teams, enabling them to plan more targeted and effective campaigns for upcoming Telugu movie releases.

## How to Run the Project

1. **Install R and RStudio**:
   - Download and install **[R](https://cran.r-project.org/mirrors.html)**.
   - Install **[RStudio](https://posit.co/products/rstudio/download/)**.

2. **Install Required R Packages**:
   In your R console, run the following commands to install necessary libraries:
   ```R
   install.packages("gtrendsR")
   install.packages("ggplot2")
   install.packages("dplyr")
   ```

3. **Run the Script**:
   - Clone this repository or download the project files.
   - Open the script in **RStudio** and execute the analysis by running the code.

## License

This project is licensed under the **MIT License**.
