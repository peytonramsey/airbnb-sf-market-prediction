# =============================================================================
# Airbnb San Francisco Market Prediction
# main.R - Full Analysis Pipeline
# =============================================================================
#
# Project: Predicting Airbnb High-Booking Properties in San Francisco
# Dataset: 12,947 listings with 32 features
# Best Model: Random Forest (95% AUC)
#
# Author: Peyton Ramsey
# =============================================================================

cat("\n")
cat("╔══════════════════════════════════════════════════════════════════════╗\n")
cat("║     AIRBNB SAN FRANCISCO MARKET PREDICTION ANALYSIS                  ║\n")
cat("║     Predicting High-Booking Properties with Machine Learning         ║\n")
cat("╚══════════════════════════════════════════════════════════════════════╝\n")
cat("\n")

# Set working directory to project root (adjust if needed)
# setwd("path/to/airbnb-sf-market-prediction")

# -----------------------------------------------------------------------------
# Step 1: Setup - Load libraries and import data
# -----------------------------------------------------------------------------
cat("Step 1: Loading libraries and data...\n")
source("01_setup.R")

# -----------------------------------------------------------------------------
# Step 2: Preprocessing - Clean and transform features
# -----------------------------------------------------------------------------
cat("\nStep 2: Preprocessing data (32-feature pipeline)...\n")
source("02_preprocessing.R")

# -----------------------------------------------------------------------------
# Step 3: Exploratory Data Analysis
# -----------------------------------------------------------------------------
cat("\nStep 3: Running exploratory data analysis...\n")
source("03_eda.R")

# -----------------------------------------------------------------------------
# Step 4: Model Training - Train all 4 classification models
# -----------------------------------------------------------------------------
cat("\nStep 4: Training classification models...\n")
source("04_models.R")

# -----------------------------------------------------------------------------
# Step 5: Model Evaluation - Compare models using ROC-AUC
# -----------------------------------------------------------------------------
cat("\nStep 5: Evaluating model performance...\n")
source("05_evaluation.R")

# -----------------------------------------------------------------------------
# Step 6: Business Insights - Extract actionable recommendations
# -----------------------------------------------------------------------------
cat("\nStep 6: Generating business insights...\n")
source("06_business_insights.R")

# -----------------------------------------------------------------------------
# Analysis Complete
# -----------------------------------------------------------------------------
cat("\n")
cat("╔══════════════════════════════════════════════════════════════════════╗\n")
cat("║                      ANALYSIS COMPLETE                               ║\n")
cat("╠══════════════════════════════════════════════════════════════════════╣\n")
cat("║  Key Results:                                                        ║\n")
cat("║  • Best Model: Random Forest (95% AUC)                               ║\n")
cat("║  • Runner-up: Bagged Trees (94% AUC)                                 ║\n")
cat("║  • Key Insight: 14.3% weekly discounts drive booking success         ║\n")
cat("╚══════════════════════════════════════════════════════════════════════╝\n")
cat("\n")
