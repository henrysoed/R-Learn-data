# ===============================================================================
# DATA IMPORT SCRIPT
# ===============================================================================
# 
# Script ini berisi fungsi-fungsi untuk import data dari berbagai sumber
# dan melakukan eksplorasi data awal
#
# Author: Henry Soedibyo
# Date: July 2025
# ===============================================================================

# Load required libraries
library(dplyr)
library(readr)
library(readxl)
library(here)

# Clear environment
rm(list = ls())

cat("=== DATA IMPORT SCRIPT ===\n")

# ===============================================================================
# HELPER FUNCTIONS
# ===============================================================================

# Function to display data overview
data_overview <- function(data, dataset_name = "Dataset") {
  cat("\n--- Overview:", dataset_name, "---\n")
  cat("Dimensions:", nrow(data), "rows x", ncol(data), "columns\n")
  cat("Column names:\n")
  print(names(data))
  cat("\nData types:\n")
  print(sapply(data, class))
  cat("\nFirst 6 rows:\n")
  print(head(data))
  cat("\nMissing values:\n")
  print(colSums(is.na(data)))
  cat("\n" , rep("=", 50), "\n")
}

# ===============================================================================
# DATA IMPORT FUNCTIONS
# ===============================================================================

# Function to import CSV files
import_csv <- function(file_path, ...) {
  tryCatch({
    data <- read_csv(here("data", "raw", file_path), ...)
    cat("✓ Successfully imported:", file_path, "\n")
    return(data)
  }, error = function(e) {
    cat("✗ Error importing", file_path, ":", e$message, "\n")
    return(NULL)
  })
}

# Function to import Excel files
import_excel <- function(file_path, sheet = 1, ...) {
  tryCatch({
    data <- read_excel(here("data", "raw", file_path), sheet = sheet, ...)
    cat("✓ Successfully imported:", file_path, "(Sheet:", sheet, ")\n")
    return(data)
  }, error = function(e) {
    cat("✗ Error importing", file_path, ":", e$message, "\n")
    return(NULL)
  })
}

# ===============================================================================
# EXAMPLE DATA IMPORT
# ===============================================================================

# Example: Import sample data (uncomment and modify as needed)

# # Import CSV file
# my_data <- import_csv("sample_data.csv")
# 
# if (!is.null(my_data)) {
#   data_overview(my_data, "Sample Dataset")
# }

# # Import Excel file
# excel_data <- import_excel("sample_data.xlsx", sheet = "Sheet1")
# 
# if (!is.null(excel_data)) {
#   data_overview(excel_data, "Excel Dataset")
# }

# ===============================================================================
# CREATE SAMPLE DATA (FOR DEMONSTRATION)
# ===============================================================================

# Create sample dataset for demonstration
set.seed(123)
sample_data <- data.frame(
  id = 1:100,
  age = sample(18:65, 100, replace = TRUE),
  gender = sample(c("Male", "Female"), 100, replace = TRUE),
  income = round(rnorm(100, 50000, 15000), 2),
  education = sample(c("High School", "Bachelor", "Master", "PhD"), 100, replace = TRUE, 
                    prob = c(0.3, 0.4, 0.2, 0.1)),
  satisfaction = sample(1:5, 100, replace = TRUE),
  purchase_amount = round(rnorm(100, 200, 50), 2)
)

# Add some missing values for demonstration
sample_data$income[sample(1:100, 5)] <- NA
sample_data$satisfaction[sample(1:100, 3)] <- NA

# Save sample data
write_csv(sample_data, here("data", "raw", "sample_customer_data.csv"))
cat("✓ Sample data created and saved as 'sample_customer_data.csv'\n")

# Display overview
data_overview(sample_data, "Sample Customer Data")

# ===============================================================================
# INSTRUCTIONS FOR USE
# ===============================================================================

cat("\n=== HOW TO USE THIS SCRIPT ===\n")
cat("1. Place your data files in the 'data/raw/' folder\n")
cat("2. Modify the import section above to load your specific files\n")
cat("3. Use import_csv() or import_excel() functions\n")
cat("4. Always check data overview after import\n")
cat("5. Save processed data to 'data/processed/' folder\n")
cat("\nAvailable functions:\n")
cat("- import_csv(file_path): Import CSV files\n")
cat("- import_excel(file_path, sheet): Import Excel files\n")  
cat("- data_overview(data, name): Display data summary\n")

cat("\n=== NEXT STEP ===\n")
cat("Run script: 02_data_cleaning.R\n")
