# ===============================================================================
# SETUP SCRIPT - Install Required Packages
# ===============================================================================
# 
# Script ini akan menginstall semua package yang diperlukan untuk project
# data analysis menggunakan R
#
# Author: Henry Soedibyo
# Date: July 2025
# ===============================================================================

# Function untuk check dan install package
install_if_missing <- function(packages) {
  new_packages <- packages[!(packages %in% installed.packages()[,"Package"])]
  if(length(new_packages)) {
    cat("Installing missing packages:", paste(new_packages, collapse = ", "), "\n")
    install.packages(new_packages, dependencies = TRUE)
  } else {
    cat("All packages are already installed!\n")
  }
}

# List of required packages
required_packages <- c(
  # Data Manipulation
  "dplyr",          # Data manipulation
  "tidyr",          # Data tidying
  "readr",          # Reading data
  "readxl",         # Reading Excel files
  "janitor",        # Data cleaning
  
  # Visualization
  "ggplot2",        # Grammar of graphics
  "plotly",         # Interactive plots
  "corrplot",       # Correlation plots
  "RColorBrewer",   # Color palettes
  "scales",         # Scale functions for visualization
  
  # Statistical Analysis
  "broom",          # Tidy statistical objects
  "psych",          # Psychology/psychometric package
  "car",            # Companion to Applied Regression
  "lmtest",         # Testing Linear Regression Models
  
  # Reporting
  "rmarkdown",      # Dynamic Documents
  "knitr",          # Dynamic report generation
  "DT",             # Interactive data tables
  
  # Utilities
  "here",           # For easy file referencing
  "lubridate",      # Date/time manipulation
  "stringr"         # String manipulation
)

# Install packages
cat("=== R DATA ANALYSIS PROJECT SETUP ===\n")
cat("Installing required packages...\n\n")

install_if_missing(required_packages)

# Load main packages
library(dplyr)
library(ggplot2)
library(readr)

cat("\n=== SETUP COMPLETE ===\n")
cat("All packages installed successfully!\n")
cat("You can now run the analysis scripts.\n")
cat("\nNext steps:\n")
cat("1. Place your data in the 'data/raw/' folder\n")
cat("2. Run scripts in order: 01 -> 02 -> 03 -> 04\n")
cat("3. Check 'outputs/' folder for results\n")

# Create .gitignore if it doesn't exist
if (!file.exists(".gitignore")) {
  gitignore_content <- c(
    "# R specific",
    ".RData",
    ".Rhistory",
    ".Rproj.user",
    "*.Rproj",
    "",
    "# Data files (uncomment if you don't want to track data)",
    "# data/raw/*",
    "# !data/raw/.gitkeep",
    "",
    "# Output files",
    "outputs/plots/*.png",
    "outputs/plots/*.pdf",
    "outputs/reports/*.html",
    "outputs/reports/*.pdf",
    "",
    "# System files",
    ".DS_Store",
    "Thumbs.db",
    "",
    "# Temporary files",
    "*~",
    "*.tmp"
  )
  
  writeLines(gitignore_content, ".gitignore")
  cat("\n.gitignore file created!\n")
}
