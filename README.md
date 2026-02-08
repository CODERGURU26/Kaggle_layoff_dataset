# Layoffs Data Analysis Project

A comprehensive SQL-based data analysis project focused on cleaning, exploring, and analyzing global layoff data from 2025-2026. This project demonstrates end-to-end data processing workflows including data cleaning, standardization, and exploratory data analysis (EDA).

## 📊 Dataset Overview

The dataset contains information about company layoffs across various industries and countries, including:
- **Company details**: Name, location, country
- **Layoff metrics**: Total employees laid off, percentage of workforce affected
- **Temporal data**: Layoff dates and announcement dates
- **Company context**: Industry, funding stage, total funds raised
- **Sources**: News article links documenting each layoff event

**Dataset Size**: 4,279 records covering layoffs from late 2025 through early 2026

## 🎯 Project Objectives

1. **Data Cleaning**: Remove duplicates, handle missing values, and standardize data formats
2. **Data Exploration**: Identify trends and patterns in layoffs across different dimensions
3. **Insights Generation**: Analyze which companies, industries, and countries were most affected

## 📁 Project Structure

```
├── layoffs.csv                          # Raw dataset
├── layoff_dataset_data-cleaning.sql     # Data cleaning scripts
├── layoff_dataset_EDA.sql              # Exploratory data analysis queries
└── README.md                            # Project documentation
```

## 🧹 Data Cleaning Process

### Step 1: Remove Duplicates
- Created staging tables to preserve original data
- Identified duplicates using `ROW_NUMBER()` window function
- Partitioned by all relevant columns to detect exact duplicates
- Removed duplicate records while keeping one instance

### Step 2: Standardize Data

**Text Standardization**:
- Trimmed whitespace from company names
- Removed ", Non-U.S." suffix from location fields for consistency
- Consolidated industry names (e.g., standardized variations of "Transportation")

**Date Formatting**:
- Converted date strings from `MM/DD/YYYY` format to proper DATE type
- Applied conversion to both `date` and `date_added` columns
- Modified column types to DATE for proper temporal analysis

### Step 3: Handle Missing Values

**Empty String Conversion**:
- Converted empty strings to NULL for `total_laid_off` and `percentage_laid_off`
- Set `funds_raised` empty values to NULL
- Replaced blank industry values with 'other'

**Data Validation**:
- Removed records where both `total_laid_off` AND `percentage_laid_off` were NULL
- Set NULL stage values to 'Unknown' for categorization

### Step 4: Schema Optimization
- Removed utility columns (e.g., `row_num`) used during cleaning
- Ensured proper data types for all columns

## 📈 Exploratory Data Analysis

### Key Analyses Performed

#### 1. **Aggregate Analysis by Dimensions**

**By Company**:
- Total layoffs per company
- Identified companies with highest absolute layoffs

**By Industry**:
- Total layoffs across different sectors
- Industry-level impact assessment

**By Country**:
- Geographic distribution of layoffs
- Country-wise impact comparison

**By Year**:
- Annual trends in layoff events
- Temporal patterns in workforce reductions

#### 2. **Temporal Analysis**

**Monthly Rolling Totals**:
```sql
-- Calculate cumulative layoffs over time
-- Shows escalating impact month-over-month
```

**Granular Event Analysis**:
- Company-specific layoff events by date and location
- Percentage-based impact analysis (companies laying off 100% of workforce)

#### 3. **Industry-Year Analysis**

- Cross-tabulation of industry performance by year
- Identification of sector-specific trends
- Year-over-year comparisons

#### 4. **Company Rankings**

**Top 5 Companies per Year**:
- Ranked companies by total layoffs within each year
- Used `DENSE_RANK()` to handle ties appropriately
- Calculated average percentage laid off alongside absolute numbers

### Key SQL Techniques Used

- ✅ Common Table Expressions (CTEs) for complex queries
- ✅ Window Functions (`ROW_NUMBER()`, `DENSE_RANK()`, `SUM() OVER()`)
- ✅ Aggregate Functions with GROUP BY
- ✅ Date manipulation functions (`DATE_FORMAT()`, `STR_TO_DATE()`, `YEAR()`)
- ✅ String functions (`TRIM()`, `REPLACE()`)
- ✅ Conditional logic with CASE statements

## 🔍 Sample Insights

Based on the SQL queries, this analysis can reveal:

1. **Most Affected Companies**: Which organizations had the largest absolute and relative layoffs
2. **Industry Trends**: Which sectors experienced the most significant workforce reductions
3. **Geographic Patterns**: Countries most impacted by the layoff wave
4. **Temporal Trends**: How layoff activity evolved over the 2025-2026 period
5. **Complete Shutdowns**: Companies that laid off 100% of their workforce
6. **Rolling Impact**: Cumulative effect of layoffs over time

## 🛠️ Technologies Used

- **Database**: MySQL
- **SQL Features**: 
  - Window Functions
  - CTEs (Common Table Expressions)
  - Data Type Conversions
  - String Manipulation
  - Date/Time Functions

## 📋 How to Use This Project

### Prerequisites
- MySQL Server (5.7 or higher)
- MySQL Workbench or any SQL client

### Setup Instructions

1. **Create Database**:
```sql
CREATE DATABASE layoffs_analysis;
USE layoffs_analysis;
```

2. **Import Raw Data**:
```sql
-- Create the initial table
CREATE TABLE layoffs (
    company TEXT,
    location TEXT,
    total_laid_off TEXT,
    date TEXT,
    percentage_laid_off TEXT,
    industry TEXT,
    source TEXT,
    stage TEXT,
    funds_raised TEXT,
    country TEXT,
    date_added TEXT
);

-- Load CSV data
LOAD DATA INFILE 'path/to/layoffs.csv'
INTO TABLE layoffs
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
```

3. **Run Data Cleaning**:
```bash
# Execute the data cleaning script
mysql -u username -p layoffs_analysis < layoff_dataset_data-cleaning.sql
```

4. **Perform Analysis**:
```bash
# Run exploratory data analysis queries
mysql -u username -p layoffs_analysis < layoff_dataset_EDA.sql
```

## 📊 Sample Queries

### Find Top 10 Companies by Total Layoffs
```sql
SELECT company, SUM(total_laid_off) AS total_laid_off
FROM layoff_staging2
GROUP BY company
ORDER BY total_laid_off DESC
LIMIT 10;
```

### Industry Impact Analysis
```sql
SELECT industry, 
       SUM(total_laid_off) AS total_laid_off,
       COUNT(*) AS num_events,
       AVG(percentage_laid_off) AS avg_percentage
FROM layoff_staging2
WHERE total_laid_off IS NOT NULL
GROUP BY industry
ORDER BY total_laid_off DESC;
```

### Monthly Layoff Trends
```sql
SELECT DATE_FORMAT(date, '%Y-%m') AS month,
       SUM(total_laid_off) AS monthly_layoffs,
       COUNT(*) AS num_companies
FROM layoff_staging2
WHERE date IS NOT NULL
GROUP BY month
ORDER BY month;
```

## 🎓 Learning Outcomes

This project demonstrates proficiency in:
- Data cleaning and preprocessing techniques
- Handling messy real-world data (nulls, blanks, duplicates)
- SQL best practices for data analysis
- Window functions for advanced analytics
- Temporal data analysis
- Data standardization and normalization

## 📄 Data Sources

The dataset includes layoffs tracked from various news sources and company announcements. Each record includes a source URL for verification.

## ⚠️ Important Notes

- Data represents layoffs from late 2025 through early 2026
- Some records have missing values for certain fields (handled during cleaning)
- Percentage laid off values range from 0 to 1 (representing 0% to 100%)
- The dataset focuses on notable layoffs reported in major news outlets

## 👤 Author

This project demonstrates SQL data analysis capabilities focusing on data cleaning, transformation, and exploratory analysis.

**Gururaj Krishna Sharma**

- 📧 Email: [guruuu2468@gmail.com](mailto:guruuu2468@gmail.com)
- 💼 LinkedIn: [Gururaj Krishna Sharma](https://www.linkedin.com/in/gururaj-krishna-sharma)
- 💻 GitHub: [@CODERGURU26](https://github.com/CODERGURU26)

---

**Note**: This analysis is based on publicly available information and should be used for educational and research purposes only.
