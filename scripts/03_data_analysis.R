# ===============================================================================
# DATA ANALYSIS SCRIPT
# ===============================================================================
# 
# Script ini berisi analisis statistik deskriptif, korelasi, dan pengujian hipotesis
#
# Author: Henry Soedibyo
# Date: July 2025
# ===============================================================================

# Load required libraries
library(dplyr)
library(readr)
library(broom)
library(psych)
library(corrplot)
library(car)
library(here)

# Clear environment
rm(list = ls())

cat("=== DATA ANALYSIS SCRIPT ===\n")

# ===============================================================================
# LOAD CLEANED DATA
# ===============================================================================

data <- read_csv(here("data", "processed", "cleaned_customer_data.csv"))
cat("✓ Cleaned data loaded successfully\n")
cat("Analyzing", nrow(data), "observations with", ncol(data), "variables\n")

# ===============================================================================
# DESCRIPTIVE STATISTICS
# ===============================================================================

cat("\n=== DESCRIPTIVE STATISTICS ===\n")

# Overall summary
cat("\n--- Overall Summary ---\n")
print(summary(data))

# Detailed statistics for numeric variables
numeric_vars <- data %>% select_if(is.numeric)
cat("\n--- Detailed Statistics (Numeric Variables) ---\n")
detailed_stats <- describe(numeric_vars)
print(detailed_stats)

# Frequency tables for categorical variables
categorical_vars <- data %>% select_if(function(x) is.character(x) | is.factor(x))

if (ncol(categorical_vars) > 0) {
  cat("\n--- Frequency Tables (Categorical Variables) ---\n")
  for (col in names(categorical_vars)) {
    cat("\n", col, ":\n")
    freq_table <- table(data[[col]])
    prop_table <- prop.table(freq_table) * 100
    
    result <- data.frame(
      Category = names(freq_table),
      Count = as.numeric(freq_table),
      Percentage = round(as.numeric(prop_table), 2)
    )
    print(result)
  }
}

# ===============================================================================
# CORRELATION ANALYSIS
# ===============================================================================

cat("\n=== CORRELATION ANALYSIS ===\n")

if (ncol(numeric_vars) > 1) {
  # Calculate correlation matrix
  cor_matrix <- cor(numeric_vars, use = "complete.obs")
  
  cat("\n--- Correlation Matrix ---\n")
  print(round(cor_matrix, 3))
  
  # Find strong correlations (> 0.7 or < -0.7)
  strong_correlations <- data.frame()
  
  for (i in 1:(ncol(cor_matrix)-1)) {
    for (j in (i+1):ncol(cor_matrix)) {
      cor_value <- cor_matrix[i, j]
      if (abs(cor_value) > 0.7) {
        strong_correlations <- rbind(strong_correlations,
                                   data.frame(
                                     Variable1 = rownames(cor_matrix)[i],
                                     Variable2 = colnames(cor_matrix)[j],
                                     Correlation = round(cor_value, 3)
                                   ))
      }
    }
  }
  
  if (nrow(strong_correlations) > 0) {
    cat("\n--- Strong Correlations (|r| > 0.7) ---\n")
    print(strong_correlations)
  } else {
    cat("\n✓ No strong correlations found (|r| > 0.7)\n")
  }
  
  # Save correlation matrix plot
  png(here("outputs", "plots", "correlation_matrix.png"), width = 800, height = 600)
  corrplot(cor_matrix, method = "color", type = "upper", 
           order = "hclust", tl.cex = 0.8, tl.col = "black")
  dev.off()
  cat("\n✓ Correlation plot saved as 'correlation_matrix.png'\n")
  
} else {
  cat("\n⚠ Not enough numeric variables for correlation analysis\n")
}

# ===============================================================================
# GROUP ANALYSIS
# ===============================================================================

cat("\n=== GROUP ANALYSIS ===\n")

# Example: Analyze by gender (if exists)
if ("gender" %in% names(data)) {
  cat("\n--- Analysis by Gender ---\n")
  
  gender_summary <- data %>%
    group_by(gender) %>%
    summarise(
      count = n(),
      avg_age = round(mean(age, na.rm = TRUE), 2),
      avg_income = round(mean(income, na.rm = TRUE), 2),
      avg_satisfaction = round(mean(satisfaction, na.rm = TRUE), 2),
      avg_purchase = round(mean(purchase_amount, na.rm = TRUE), 2),
      .groups = 'drop'
    )
  
  print(gender_summary)
  
  # T-test for income difference between genders
  if (length(unique(data$gender)) == 2) {
    t_test_result <- t.test(income ~ gender, data = data)
    cat("\n--- T-test: Income by Gender ---\n")
    cat("t-statistic:", round(t_test_result$statistic, 3), "\n")
    cat("p-value:", round(t_test_result$p.value, 4), "\n")
    
    if (t_test_result$p.value < 0.05) {
      cat("Result: Significant difference in income between genders (p < 0.05)\n")
    } else {
      cat("Result: No significant difference in income between genders (p >= 0.05)\n")
    }
  }
}

# Example: Analyze by education level (if exists)
if ("education" %in% names(data)) {
  cat("\n--- Analysis by Education Level ---\n")
  
  education_summary <- data %>%
    group_by(education) %>%
    summarise(
      count = n(),
      avg_income = round(mean(income, na.rm = TRUE), 2),
      avg_satisfaction = round(mean(satisfaction, na.rm = TRUE), 2),
      .groups = 'drop'
    ) %>%
    arrange(desc(avg_income))
  
  print(education_summary)
  
  # ANOVA for income by education
  if (length(unique(data$education)) > 2) {
    anova_result <- aov(income ~ education, data = data)
    anova_summary <- summary(anova_result)
    
    cat("\n--- ANOVA: Income by Education ---\n")
    print(anova_summary)
    
    p_value <- anova_summary[[1]]$`Pr(>F)`[1]
    if (!is.na(p_value) && p_value < 0.05) {
      cat("Result: Significant difference in income across education levels (p < 0.05)\n")
      
      # Post-hoc test
      tukey_result <- TukeyHSD(anova_result)
      cat("\n--- Post-hoc Test (Tukey HSD) ---\n")
      print(tukey_result)
    } else {
      cat("Result: No significant difference in income across education levels\n")
    }
  }
}

# ===============================================================================
# REGRESSION ANALYSIS
# ===============================================================================

cat("\n=== REGRESSION ANALYSIS ===\n")

# Example: Predict purchase amount
if (all(c("age", "income", "satisfaction") %in% names(data))) {
  cat("\n--- Linear Regression: Predicting Purchase Amount ---\n")
  
  # Fit linear model
  model <- lm(purchase_amount ~ age + income + satisfaction, data = data)
  
  # Model summary
  model_summary <- summary(model)
  print(model_summary)
  
  # Model diagnostics
  cat("\n--- Model Diagnostics ---\n")
  cat("R-squared:", round(model_summary$r.squared, 4), "\n")
  cat("Adjusted R-squared:", round(model_summary$adj.r.squared, 4), "\n")
  cat("F-statistic p-value:", format.pval(pf(model_summary$fstatistic[1], 
                                           model_summary$fstatistic[2], 
                                           model_summary$fstatistic[3], 
                                           lower.tail = FALSE)), "\n")
  
  # Check assumptions
  cat("\n--- Assumption Checks ---\n")
  
  # Durbin-Watson test for autocorrelation
  dw_test <- durbinWatsonTest(model)
  cat("Durbin-Watson test p-value:", round(dw_test$p, 4), "\n")
  
  # Shapiro-Wilk test for normality of residuals
  if (nrow(data) <= 5000) {  # Shapiro test limitation
    sw_test <- shapiro.test(residuals(model))
    cat("Shapiro-Wilk test p-value:", round(sw_test$p.value, 4), "\n")
  }
  
  # Save model results
  model_results <- tidy(model)
  write_csv(model_results, here("outputs", "reports", "regression_results.csv"))
  cat("\n✓ Regression results saved as 'regression_results.csv'\n")
}

# ===============================================================================
# ANALYSIS SUMMARY
# ===============================================================================

cat("\n=== ANALYSIS SUMMARY ===\n")
cat("✓ Descriptive statistics completed\n")
cat("✓ Correlation analysis completed\n")
cat("✓ Group analysis completed\n")
cat("✓ Regression analysis completed\n")
cat("✓ Results saved to outputs folder\n")

# Save workspace for later use
save.image(here("outputs", "analysis_workspace.RData"))
cat("✓ Workspace saved as 'analysis_workspace.RData'\n")

cat("\n=== NEXT STEP ===\n")
cat("Run script: 04_visualization.R\n")
