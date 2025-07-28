# ===============================================================================
# DATA VISUALIZATION SCRIPT
# ===============================================================================
# 
# Script ini berisi kode untuk membuat berbagai jenis visualisasi data
# yang informatif dan menarik
#
# Author: Henry Soedibyo
# Date: July 2025
# ===============================================================================

# Load required libraries
library(dplyr)
library(readr)
library(ggplot2)
library(plotly)
library(RColorBrewer)
library(scales)
library(corrplot)
library(here)

# Clear environment
rm(list = ls())

cat("=== DATA VISUALIZATION SCRIPT ===\n")

# ===============================================================================
# LOAD DATA AND SETUP
# ===============================================================================

data <- read_csv(here("data", "processed", "cleaned_customer_data.csv"))
cat("✓ Data loaded successfully\n")

# Set theme for ggplot2
theme_set(theme_minimal() + 
          theme(plot.title = element_text(hjust = 0.5, size = 14, face = "bold"),
                plot.subtitle = element_text(hjust = 0.5, size = 12),
                legend.position = "bottom"))

# Color palette
colors <- brewer.pal(8, "Set2")

# ===============================================================================
# DISTRIBUTION PLOTS
# ===============================================================================

cat("\n=== CREATING DISTRIBUTION PLOTS ===\n")

# 1. Age Distribution
if ("age" %in% names(data)) {
  p1 <- ggplot(data, aes(x = age)) +
    geom_histogram(bins = 20, fill = colors[1], alpha = 0.7, color = "white") +
    geom_vline(aes(xintercept = mean(age)), color = "red", linetype = "dashed", size = 1) +
    labs(title = "Distribution of Age",
         subtitle = paste("Mean age:", round(mean(data$age), 1), "years"),
         x = "Age", y = "Frequency") +
    scale_x_continuous(breaks = pretty_breaks())
  
  ggsave(here("outputs", "plots", "age_distribution.png"), p1, width = 10, height = 6, dpi = 300)
  cat("✓ Age distribution plot saved\n")
}

# 2. Income Distribution
if ("income" %in% names(data)) {
  p2 <- ggplot(data, aes(x = income)) +
    geom_histogram(bins = 25, fill = colors[2], alpha = 0.7, color = "white") +
    geom_vline(aes(xintercept = mean(income)), color = "red", linetype = "dashed", size = 1) +
    labs(title = "Distribution of Income",
         subtitle = paste("Mean income: $", comma(round(mean(data$income), 0))),
         x = "Income ($)", y = "Frequency") +
    scale_x_continuous(labels = dollar_format())
  
  ggsave(here("outputs", "plots", "income_distribution.png"), p2, width = 10, height = 6, dpi = 300)
  cat("✓ Income distribution plot saved\n")
}

# 3. Satisfaction Distribution
if ("satisfaction" %in% names(data)) {
  satisfaction_counts <- data %>%
    count(satisfaction) %>%
    mutate(percentage = n / sum(n) * 100)
  
  p3 <- ggplot(satisfaction_counts, aes(x = factor(satisfaction), y = n)) +
    geom_col(fill = colors[3], alpha = 0.7) +
    geom_text(aes(label = paste0(n, "\n(", round(percentage, 1), "%)")), 
              vjust = -0.5, size = 3.5) +
    labs(title = "Customer Satisfaction Distribution",
         x = "Satisfaction Level", y = "Count") +
    scale_y_continuous(expand = expansion(mult = c(0, 0.1)))
  
  ggsave(here("outputs", "plots", "satisfaction_distribution.png"), p3, width = 10, height = 6, dpi = 300)
  cat("✓ Satisfaction distribution plot saved\n")
}

# ===============================================================================
# RELATIONSHIP PLOTS
# ===============================================================================

cat("\n=== CREATING RELATIONSHIP PLOTS ===\n")

# 4. Income vs Purchase Amount
if (all(c("income", "purchase_amount") %in% names(data))) {
  p4 <- ggplot(data, aes(x = income, y = purchase_amount)) +
    geom_point(alpha = 0.6, color = colors[4]) +
    geom_smooth(method = "lm", color = "red", se = TRUE) +
    labs(title = "Relationship between Income and Purchase Amount",
         x = "Income ($)", y = "Purchase Amount ($)") +
    scale_x_continuous(labels = dollar_format()) +
    scale_y_continuous(labels = dollar_format())
  
  ggsave(here("outputs", "plots", "income_vs_purchase.png"), p4, width = 10, height = 6, dpi = 300)
  cat("✓ Income vs Purchase plot saved\n")
}

# 5. Age vs Income
if (all(c("age", "income") %in% names(data))) {
  p5 <- ggplot(data, aes(x = age, y = income)) +
    geom_point(alpha = 0.6, color = colors[5]) +
    geom_smooth(method = "loess", color = "blue", se = TRUE) +
    labs(title = "Relationship between Age and Income",
         x = "Age (years)", y = "Income ($)") +
    scale_y_continuous(labels = dollar_format())
  
  ggsave(here("outputs", "plots", "age_vs_income.png"), p5, width = 10, height = 6, dpi = 300)
  cat("✓ Age vs Income plot saved\n")
}

# ===============================================================================
# GROUP COMPARISON PLOTS
# ===============================================================================

cat("\n=== CREATING GROUP COMPARISON PLOTS ===\n")

# 6. Income by Gender
if (all(c("gender", "income") %in% names(data))) {
  p6 <- ggplot(data, aes(x = gender, y = income, fill = gender)) +
    geom_boxplot(alpha = 0.7) +
    geom_jitter(width = 0.2, alpha = 0.3) +
    scale_fill_manual(values = colors[1:2]) +
    labs(title = "Income Distribution by Gender",
         x = "Gender", y = "Income ($)") +
    scale_y_continuous(labels = dollar_format()) +
    guides(fill = "none")
  
  ggsave(here("outputs", "plots", "income_by_gender.png"), p6, width = 10, height = 6, dpi = 300)
  cat("✓ Income by Gender plot saved\n")
}

# 7. Purchase Amount by Education
if (all(c("education", "purchase_amount") %in% names(data))) {
  p7 <- ggplot(data, aes(x = reorder(education, purchase_amount, median), y = purchase_amount)) +
    geom_boxplot(fill = colors[6], alpha = 0.7) +
    coord_flip() +
    labs(title = "Purchase Amount by Education Level",
         x = "Education Level", y = "Purchase Amount ($)") +
    scale_y_continuous(labels = dollar_format())
  
  ggsave(here("outputs", "plots", "purchase_by_education.png"), p7, width = 10, height = 6, dpi = 300)
  cat("✓ Purchase by Education plot saved\n")
}

# 8. Satisfaction by Gender
if (all(c("gender", "satisfaction") %in% names(data))) {
  satisfaction_by_gender <- data %>%
    group_by(gender, satisfaction) %>%
    summarise(count = n(), .groups = 'drop') %>%
    group_by(gender) %>%
    mutate(percentage = count / sum(count) * 100)
  
  p8 <- ggplot(satisfaction_by_gender, aes(x = factor(satisfaction), y = percentage, fill = gender)) +
    geom_col(position = "dodge", alpha = 0.7) +
    scale_fill_manual(values = colors[1:2]) +
    labs(title = "Satisfaction Levels by Gender",
         x = "Satisfaction Level", y = "Percentage (%)",
         fill = "Gender") +
    scale_y_continuous(expand = expansion(mult = c(0, 0.05)))
  
  ggsave(here("outputs", "plots", "satisfaction_by_gender.png"), p8, width = 10, height = 6, dpi = 300)
  cat("✓ Satisfaction by Gender plot saved\n")
}

# ===============================================================================
# CORRELATION HEATMAP
# ===============================================================================

cat("\n=== CREATING CORRELATION HEATMAP ===\n")

numeric_data <- data %>% select_if(is.numeric)
if (ncol(numeric_data) > 1) {
  # Create correlation matrix
  cor_matrix <- cor(numeric_data, use = "complete.obs")
  
  # Convert to long format for ggplot
  cor_long <- expand.grid(Var1 = rownames(cor_matrix), Var2 = colnames(cor_matrix))
  cor_long$Correlation <- as.vector(cor_matrix)
  
  p9 <- ggplot(cor_long, aes(x = Var1, y = Var2, fill = Correlation)) +
    geom_tile() +
    scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                        midpoint = 0, limit = c(-1,1)) +
    labs(title = "Correlation Matrix Heatmap",
         x = "", y = "") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(here("outputs", "plots", "correlation_heatmap.png"), p9, width = 10, height = 8, dpi = 300)
  cat("✓ Correlation heatmap saved\n")
}

# ===============================================================================
# SUMMARY STATISTICS VISUALIZATION
# ===============================================================================

cat("\n=== CREATING SUMMARY VISUALIZATION ===\n")

# 10. Summary Dashboard-style plot
if (ncol(numeric_data) >= 3) {
  # Create summary statistics
  summary_stats <- numeric_data %>%
    summarise_all(list(
      Mean = ~round(mean(., na.rm = TRUE), 2),
      Median = ~round(median(., na.rm = TRUE), 2),
      SD = ~round(sd(., na.rm = TRUE), 2)
    )) %>%
    gather(key = "Metric", value = "Value") %>%
    separate(Metric, into = c("Variable", "Statistic"), sep = "_") %>%
    spread(Statistic, Value)
  
  # Create a summary plot
  p10 <- ggplot(summary_stats, aes(x = Variable, y = Mean)) +
    geom_col(fill = colors[7], alpha = 0.7) +
    geom_errorbar(aes(ymin = Mean - SD, ymax = Mean + SD), width = 0.2) +
    labs(title = "Summary Statistics by Variable",
         subtitle = "Bars show mean values, error bars show ±1 standard deviation",
         x = "Variables", y = "Mean Value") +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
  
  ggsave(here("outputs", "plots", "summary_statistics.png"), p10, width = 12, height = 6, dpi = 300)
  cat("✓ Summary statistics plot saved\n")
}

# ===============================================================================
# INTERACTIVE PLOTS
# ===============================================================================

cat("\n=== CREATING INTERACTIVE PLOTS ===\n")

# 11. Interactive scatter plot
if (all(c("income", "purchase_amount", "age") %in% names(data))) {
  p11_static <- ggplot(data, aes(x = income, y = purchase_amount, color = age)) +
    geom_point(alpha = 0.7) +
    scale_color_gradientn(colors = brewer.pal(9, "YlOrRd")) +
    labs(title = "Interactive Plot: Income vs Purchase Amount (colored by Age)",
         x = "Income ($)", y = "Purchase Amount ($)") +
    scale_x_continuous(labels = dollar_format()) +
    scale_y_continuous(labels = dollar_format())
  
  # Convert to interactive plot
  p11_interactive <- ggplotly(p11_static)
  
  # Save interactive plot
  htmlwidgets::saveWidget(p11_interactive, 
                         here("outputs", "plots", "interactive_scatter.html"))
  cat("✓ Interactive scatter plot saved as HTML\n")
}

# ===============================================================================
# VISUALIZATION SUMMARY
# ===============================================================================

cat("\n=== VISUALIZATION SUMMARY ===\n")
cat("✓ Distribution plots created\n")
cat("✓ Relationship plots created\n")
cat("✓ Group comparison plots created\n")
cat("✓ Correlation heatmap created\n")
cat("✓ Summary visualization created\n")
cat("✓ Interactive plot created\n")

# List all created plots
plot_files <- list.files(here("outputs", "plots"), pattern = "\\.(png|html)$")
cat("\nGenerated visualization files:\n")
for (file in plot_files) {
  cat("- ", file, "\n")
}

cat("\n=== VISUALIZATION COMPLETE ===\n")
cat("All plots saved in 'outputs/plots/' folder\n")
cat("You can now view and share your visualizations!\n")
