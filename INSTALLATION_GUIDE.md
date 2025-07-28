# 🚀 Installation Guide - R Data Analysis Project

Panduan lengkap untuk menyiapkan environment R data analysis di Windows.

## 📋 Prerequisites

### 1. Install R
1. Download R dari [https://cran.r-project.org/bin/windows/base/](https://cran.r-project.org/bin/windows/base/)
2. Pilih "Download R-4.x.x for Windows" 
3. Jalankan installer dan ikuti petunjuk default
4. **PENTING**: Pastikan mencentang "Add R to PATH" saat instalasi

### 2. Install RStudio (Opsional tapi Recommended)
1. Download RStudio dari [https://posit.co/downloads/](https://posit.co/downloads/)
2. Pilih "RStudio Desktop" versi gratis
3. Install dengan pengaturan default

### 3. Verify Installation
Buka Command Prompt atau PowerShell dan jalankan:
```bash
R --version
Rscript --help
```

Jika berhasil, Anda akan melihat informasi versi R.

## 🛠️ Setup Project

### 1. Clone Repository
```bash
git clone https://github.com/henrysoed/R-Learn-data.git
cd R-Learn-data
```

### 2. Install Required Packages
```bash
# Metode 1: Via Command Line
Rscript scripts/00_setup.R

# Metode 2: Via RStudio
# Buka RStudio, lalu jalankan:
source("scripts/00_setup.R")
```

### 3. Install VS Code Extension
Dalam VS Code, install extension berikut:
- **R Extension for Visual Studio Code** (`REditorSupport.r`)

## ⚡ Quick Start

### Option A: Menggunakan VS Code Tasks
1. Buka VS Code di folder project
2. Tekan `Ctrl+Shift+P`
3. Ketik "Tasks: Run Task"
4. Pilih salah satu:
   - `Run R Setup Script` - Install packages
   - `Run Complete Analysis Pipeline` - Jalankan semua analysis

### Option B: Menjalankan Script Satu per Satu
```bash
# 1. Setup dan install packages
Rscript scripts/00_setup.R

# 2. Import data
Rscript scripts/01_data_import.R

# 3. Clean data  
Rscript scripts/02_data_cleaning.R

# 4. Analyze data
Rscript scripts/03_data_analysis.R

# 5. Create visualizations
Rscript scripts/04_visualization.R
```

### Option C: Menggunakan RStudio
1. Buka RStudio
2. Set working directory: `setwd("path/to/R-Learn-data")`
3. Jalankan script satu per satu dari panel Source

## 📁 What You'll Get

Setelah menjalankan semua script, Anda akan memiliki:

### Data
- `data/raw/sample_customer_data.csv` - Data sample untuk latihan
- `data/processed/cleaned_customer_data.csv` - Data yang sudah dibersihkan

### Outputs
- `outputs/plots/` - Berbagai visualisasi (histogram, scatter plots, boxplots, dll)
- `outputs/reports/` - Hasil analisis dalam format CSV
- `outputs/analysis_workspace.RData` - R workspace untuk analisis lanjutan

### Visualizations Created
1. **age_distribution.png** - Distribusi umur customer
2. **income_distribution.png** - Distribusi pendapatan  
3. **satisfaction_distribution.png** - Tingkat kepuasan customer
4. **income_vs_purchase.png** - Hubungan pendapatan dan pembelian
5. **age_vs_income.png** - Hubungan umur dan pendapatan
6. **income_by_gender.png** - Perbandingan pendapatan berdasarkan gender
7. **purchase_by_education.png** - Pembelian berdasarkan tingkat pendidikan
8. **satisfaction_by_gender.png** - Kepuasan berdasarkan gender
9. **correlation_heatmap.png** - Heatmap korelasi antar variabel
10. **summary_statistics.png** - Ringkasan statistik
11. **interactive_scatter.html** - Plot interaktif

## 🎯 Learning Objectives

Project ini akan mengajarkan Anda:

1. **Data Import & Export**
   - Membaca CSV dan Excel files
   - Menyimpan data processed
   - Best practices file management

2. **Data Cleaning**
   - Handling missing values
   - Outlier detection
   - Data type conversion
   - Duplicate removal

3. **Statistical Analysis**
   - Descriptive statistics
   - Correlation analysis
   - T-tests dan ANOVA
   - Linear regression

4. **Data Visualization**
   - ggplot2 fundamentals
   - Different plot types
   - Interactive plots with plotly
   - Publication-ready graphics

5. **Project Organization**
   - Folder structure best practices
   - Reproducible workflows
   - Documentation
   - Version control with Git

## 🆘 Troubleshooting

### R/Rscript not found
- Pastikan R sudah terinstall dengan benar
- Check apakah R sudah ditambahkan ke PATH
- Restart terminal/command prompt setelah instalasi

### Package installation errors
- Coba install packages satu per satu
- Update R ke versi terbaru
- Check internet connection

### Path issues
- Gunakan forward slashes (/) atau double backslashes (\\\\) di Windows
- Pastikan working directory sudah benar

### Memory issues
- Tutup aplikasi lain yang tidak perlu
- Gunakan `rm(list=ls())` untuk clear environment
- Restart R session

## 🔗 Next Steps

1. **Eksplorasi Data Sendiri**
   - Ganti sample data dengan data Anda sendiri
   - Modifikasi analysis sesuai kebutuhan

2. **Learn More**
   - Pelajari package R lainnya (shiny, dplyr, tidyr)
   - Eksplorasi machine learning dengan caret/randomForest

3. **Portfolio Development**
   - Document findings di README
   - Share visualizations di LinkedIn/GitHub
   - Create presentation dari results

## 📞 Support

Jika mengalami kendala:
1. Check dokumentasi R: [https://www.r-project.org/other-docs.html](https://www.r-project.org/other-docs.html)
2. Search Stack Overflow untuk error messages
3. Lihat GitHub Issues di repository ini

---

Selamat belajar dan semoga sukses dengan portfolio data analyst Anda! 🚀
