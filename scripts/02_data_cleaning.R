# ===============================================================================
# DATA CLEANING SCRIPT
# ===============================================================================
# 
# Script ini berisi fungsi-fungsi untuk membersihkan data, menangani missing values,
# dan mempersiapkan data untuk analisis
#
# Author: Henry Soedibyo
# Date: July 2025
# ===============================================================================

# Load required libraries
library(dplyr)
library(tidyr)
library(readr)
library(janitor)
library(here)

# Clear environment
rm(list = ls())

cat("=== DATA CLEANING SCRIPT ===\n")

# ===============================================================================
# LOAD DATA
# ===============================================================================

# Load sample data (modify path as needed)
raw_data <- read_csv(here("data", "raw", "sample_customer_data.csv"))
cat("✓ Data loaded successfully\n")
cat("Original data dimensions:", nrow(raw_data), "rows x", ncol(raw_data), "columns\n")

# ===============================================================================
# DATA CLEANING FUNCTIONS
# ===============================================================================

# Function to check data quality
data_quality_check <- function(data) {
  cat("\n--- DATA QUALITY CHECK ---\n")
  
  # Check dimensions
  cat("Dimensions:", nrow(data), "rows x", ncol(data), "columns\n")
  
  # Check missing values
  missing_summary <- data %>%
    summarise_all(~sum(is.na(.))) %>%
    gather(key = "column", value = "missing_count") %>%
    mutate(missing_percentage = round(missing_count / nrow(data) * 100, 2)) %>%
    filter(missing_count > 0)
  
  if (nrow(missing_summary) > 0) {
    cat("\nMissing values:\n")
    print(missing_summary)
  } else {
    cat("\n✓ No missing values found\n")
  }
  
  # Check duplicates
  duplicates <- sum(duplicated(data))
  cat("\nDuplicate rows:", duplicates, "\n")
  
  # Check data types
  cat("\nData types:\n")
  print(sapply(data, class))
  
  cat("\n", rep("=", 40), "\n")
}

# Function to handle missing values
handle_missing_values <- function(data, method = "mean") {
  cat("\n--- HANDLING MISSING VALUES ---\n")
  
  data_cleaned <- data
  
  # For numeric columns, impute with mean/median
  numeric_cols <- sapply(data, is.numeric)
  
  for (col in names(data)[numeric_cols]) {
    if (sum(is.na(data[[col]])) > 0) {
      if (method == "mean") {
        impute_value <- mean(data[[col]], na.rm = TRUE)
        cat("Imputing", col, "with mean:", round(impute_value, 2), "\n")
      } else if (method == "median") {
        impute_value <- median(data[[col]], na.rm = TRUE)
        cat("Imputing", col, "with median:", round(impute_value, 2), "\n")
      }
      
      data_cleaned[[col]][is.na(data_cleaned[[col]])] <- impute_value
    }
  }
  
  # For categorical columns, impute with mode
  categorical_cols <- sapply(data, function(x) is.character(x) | is.factor(x))
  
  for (col in names(data)[categorical_cols]) {
    if (sum(is.na(data[[col]])) > 0) {
      mode_value <- names(sort(table(data[[col]]), decreasing = TRUE))[1]
      cat("Imputing", col, "with mode:", mode_value, "\n")
      data_cleaned[[col]][is.na(data_cleaned[[col]])] <- mode_value
    }
  }
  
  return(data_cleaned)
}

# Function to detect outliers using IQR method
detect_outliers <- function(data, columns = NULL) {
  cat("\n--- OUTLIER DETECTION ---\n")
  
  if (is.null(columns)) {
    columns <- names(data)[sapply(data, is.numeric)]
  }
  
  outlier_summary <- data.frame()
  
  for (col in columns) {
    if (is.numeric(data[[col]])) {
      Q1 <- quantile(data[[col]], 0.25, na.rm = TRUE)
      Q3 <- quantile(data[[col]], 0.75, na.rm = TRUE)
      IQR <- Q3 - Q1
      
      lower_bound <- Q1 - 1.5 * IQR
      upper_bound <- Q3 + 1.5 * IQR
      
      outliers <- sum(data[[col]] < lower_bound | data[[col]] > upper_bound, na.rm = TRUE)
      
      outlier_summary <- rbind(outlier_summary, 
                              data.frame(
                                column = col,
                                outliers = outliers,
                                percentage = round(outliers / nrow(data) * 100, 2),
                                lower_bound = round(lower_bound, 2),
                                upper_bound = round(upper_bound, 2)
                              ))
    }
  }
  
  print(outlier_summary)
  return(outlier_summary)
}

# Function to standardize column names
standardize_column_names <- function(data) {
  cat("\n--- STANDARDIZING COLUMN NAMES ---\n")
  
  original_names <- names(data)
  data_clean <- data %>%
    clean_names()  # from janitor package
  
  new_names <- names(data_clean)
  
  if (!identical(original_names, new_names)) {
    cat("Column names standardized:\n")
    for (i in 1:length(original_names)) {
      if (original_names[i] != new_names[i]) {
        cat(paste0("  ", original_names[i], " -> ", new_names[i], "\n"))
      }
    }
  } else {
    cat("✓ Column names already standardized\n")
  }
  
  return(data_clean)
}

# ===============================================================================
# EXECUTE CLEANING PROCESS
# ===============================================================================

cat("\n=== STARTING DATA CLEANING PROCESS ===\n")

# Step 1: Initial data quality check
data_quality_check(raw_data)

# Step 2: Standardize column names
cleaned_data <- standardize_column_names(raw_data)

# Step 3: Handle missing values
cleaned_data <- handle_missing_values(cleaned_data, method = "mean")

# Step 4: Detect outliers
outlier_info <- detect_outliers(cleaned_data)

# Step 5: Remove duplicates
duplicates_before <- sum(duplicated(cleaned_data))
cleaned_data <- cleaned_data %>% distinct()
duplicates_after <- sum(duplicated(cleaned_data))

cat("\n--- DUPLICATE REMOVAL ---\n")
cat("Duplicates removed:", duplicates_before - duplicates_after, "\n")

# Step 6: Final data quality check
cat("\n=== FINAL DATA QUALITY CHECK ===\n")
data_quality_check(cleaned_data)

# ===============================================================================
# SAVE CLEANED DATA
# ===============================================================================

# Save cleaned data
write_csv(cleaned_data, here("data", "processed", "cleaned_customer_data.csv"))
cat("\n✓ Cleaned data saved as 'cleaned_customer_data.csv'\n")

# Create data summary
data_summary <- cleaned_data %>%
  select_if(is.numeric) %>%
  summary()

cat("\n--- SUMMARY STATISTICS ---\n")
print(data_summary)

# ===============================================================================
# CLEANING REPORT
# ===============================================================================

cat("\n=== DATA CLEANING REPORT ===\n")
cat("Original rows:", nrow(raw_data), "\n")
cat("Final rows:", nrow(cleaned_data), "\n")
cat("Rows removed:", nrow(raw_data) - nrow(cleaned_data), "\n")
cat("Missing values handled: ✓\n")
cat("Duplicates removed: ✓\n")
cat("Column names standardized: ✓\n")
cat("Outliers identified: ✓\n")

cat("\n=== NEXT STEP ===\n")
cat("Run script: 03_data_analysis.R\n")
