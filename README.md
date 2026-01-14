# Airbnb Market Prediction Analysis: San Francisco

Predicting high-booking Airbnb listings using machine learning classification models.

## Project Overview

This project builds supervised machine learning models to predict which Airbnb listings in San Francisco are most likely to achieve high booking rates. Using a dataset of 12,947 listings, the analysis explores the impact of pricing, host characteristics, property features, and review scores on booking performance.

### Key Results

| Model | ROC-AUC |
|-------|---------|
| **Random Forest** | **95%** |
| Bagged Trees | 94% |
| LightGBM | 93% |
| Logistic Regression | 59% |

### Key Insights

- High-booking properties offer **14.3% weekly discounts** vs 5% industry average
- Each additional bedroom increases high-booking odds by **65%**
- Optimal pricing strategy: **5-10% below market median** with generous weekly discounts

## Project Structure

```
airbnb-sf-market-prediction/
├── main.R                  # Run full analysis pipeline
├── 01_setup.R              # Library loading and data import
├── 02_preprocessing.R      # 32-feature preprocessing pipeline
├── 03_eda.R                # Exploratory data analysis & visualizations
├── 04_models.R             # Classification model training (4 models)
├── 05_evaluation.R         # ROC curves and model comparison
├── 06_business_insights.R  # Weekly discount & pricing strategy analysis
├── dfsf_sample.csv         # San Francisco Airbnb dataset (~6,000 sample)
└── airbnb-project-resume.pdf  # Project presentation slides
```

## Technical Details

### Data Preprocessing
- **Price normalization**: Removed dollar signs, converted to numeric
- **Binary encoding**: Converted logical variables (superhost, instant_bookable, etc.)
- **Missing value imputation**: Median for numeric, mode for categorical
- **Feature selection**: Retained 32 numerical and categorical features

### Models Implemented
1. **Logistic Regression** - Baseline model with interpretable coefficients
2. **Random Forest** - Best performer using ranger engine
3. **LightGBM** - Gradient boosting with fast training
4. **Bagged Trees** - Bootstrap aggregated decision trees

### Evaluation Metrics
- Primary: **ROC-AUC** (Area Under ROC Curve)
- Secondary: Accuracy, Confusion Matrix

## How to Run

```r
# Option 1: Run full pipeline
source("main.R")

# Option 2: Run individual steps
source("01_setup.R")
source("02_preprocessing.R")
source("03_eda.R")
source("04_models.R")
source("05_evaluation.R")
source("06_business_insights.R")
```

### Requirements

```r
install.packages(c("tidyverse", "tidymodels", "ranger",
                   "baguette", "bonsai", "lightgbm", "yardstick"))
```

## Dataset

- **Source**: Inside Airbnb (San Francisco)
- **Size**: 12,947 total properties (6,000 sample in repo)
- **Target**: `high_booking` (binary classification)
- **Features**: 32 numeric/categorical variables including:
  - Property: bedrooms, bathrooms, accommodates, beds
  - Pricing: price, weekly_price, security_deposit
  - Host: superhost_status, response_rate, acceptance_rate
  - Reviews: rating, cleanliness, location, value scores

**Note**: This repository contains a random sample (~6,000 listings) to keep file sizes manageable. The original analysis was performed on the full dataset of 12,947 listings. Running the code on the sample data will produce slightly different results, but the methodology and approach remain identical.

## Author

**Peyton Ramsey** - [GitHub](https://github.com/yourusername)

*Project completed as part of business analytics coursework.*
