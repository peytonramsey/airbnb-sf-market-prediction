# =============================================================================
# Airbnb San Francisco Market Prediction
# 01_setup.R - Library Loading and Data Import
# =============================================================================

# Load required libraries
library(tidyverse)
library(tidymodels)
library(ranger)      # Random Forest engine
library(baguette)    # Bagged Trees
library(bonsai)      # LightGBM interface
library(lightgbm)    # LightGBM engine
library(yardstick)   # Model evaluation metrics

# Set seed for reproducibility
set.seed(3.14159)

# Load the Airbnb San Francisco dataset
# Dataset contains 12,947 listings with property, host, and pricing features
# Note: Sample dataset (dfsf_sample.csv) contains ~6,000 listings
df_raw <- read_csv("dfsf_sample.csv") %>%
  mutate(high_booking = as.factor(high_booking))

# Display initial data overview
cat("Dataset Overview:\n")
cat("- Total listings:", nrow(df_raw), "\n")
cat("- Total features:", ncol(df_raw), "\n")
cat("- High-booking properties:", sum(df_raw$high_booking == 1, na.rm = TRUE), "\n")
