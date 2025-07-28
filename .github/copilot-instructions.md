<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# R Data Analysis Project Instructions

This is an R data analysis project focused on learning and demonstrating data science skills. When working with this codebase:

## Project Structure
- Use the established folder structure with `data/`, `scripts/`, and `outputs/` directories
- Follow the numbered script sequence: 00_setup.R → 01_data_import.R → 02_data_cleaning.R → 03_data_analysis.R → 04_visualization.R
- Save raw data in `data/raw/` and processed data in `data/processed/`
- Output all plots to `outputs/plots/` and reports to `outputs/reports/`

## Coding Standards
- Use descriptive function and variable names
- Include comprehensive comments explaining the analysis steps
- Use the `here` package for robust file path management
- Follow tidyverse conventions when possible
- Create reproducible code that can be run by others

## Data Analysis Best Practices
- Always perform data quality checks before analysis
- Handle missing values appropriately
- Document assumptions and limitations
- Include statistical significance testing where appropriate
- Create both static and interactive visualizations when relevant

## Package Management
- List all required packages at the beginning of each script
- Use the setup script to install missing packages
- Prefer tidyverse packages for data manipulation and visualization

## Documentation
- Update README.md when adding new analyses or datasets
- Include interpretation of results in comments
- Create clear, publication-ready plots with proper titles and labels
- Generate summary reports of findings

This project serves as a portfolio piece demonstrating R programming and data analysis skills.
