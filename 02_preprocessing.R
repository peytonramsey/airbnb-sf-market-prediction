# =============================================================================
# Airbnb San Francisco Market Prediction
# 02_preprocessing.R - Data Cleaning and Feature Engineering
# =============================================================================

# Define column groups for transformation
# Price columns contain dollar signs that need removal
price_columns <- c("price", "weekly_price", "security_deposit",
                   "monthly_price", "extra_people", "cleaning_fee")

# Rate columns contain percentage signs
rate_columns <- c("host_response_rate", "host_acceptance_rate")

# Logical columns to convert to binary (0/1)
logical_columns <- c(
  "instant_bookable", "host_has_profile_pic", "host_identity_verified",
  "host_is_superhost", "is_business_travel_ready", "is_location_exact",
  "require_guest_phone_verification", "require_guest_profile_picture",
  "requires_license"
)

# Helper function to only transform columns that exist
transform_if_exists <- function(data, columns, transform_fn) {
  existing_cols <- intersect(columns, names(data))
  if (length(existing_cols) > 0) {
    data <- data %>% mutate(across(all_of(existing_cols), transform_fn))
  }
  return(data)
}

# -----------------------------------------------------------------------------
# Step 1: Price Normalization - Remove dollar signs and commas
# -----------------------------------------------------------------------------
df_clean <- df_raw %>%
  transform_if_exists(price_columns, ~ str_remove_all(as.character(.), "\\$")) %>%
  transform_if_exists(price_columns, ~ str_remove_all(., ",")) %>%
  transform_if_exists(price_columns, ~ as.numeric(.))

# -----------------------------------------------------------------------------
# Step 2: Percentage Cleaning - Convert rates to decimal format
# Handle "N/A" strings that appear in the data
# -----------------------------------------------------------------------------
df_clean <- df_clean %>%
  transform_if_exists(rate_columns, ~ na_if(., "N/A")) %>%
  transform_if_exists(rate_columns, ~ str_remove_all(as.character(.), "\\%")) %>%
  transform_if_exists(rate_columns, ~ as.numeric(.)) %>%
  transform_if_exists(rate_columns, ~ . / 100)

# -----------------------------------------------------------------------------
# Step 3: Binary Encoding - Convert logical variables to numeric
# -----------------------------------------------------------------------------
existing_logical <- intersect(logical_columns, names(df_clean))
df_clean <- df_clean %>%
  mutate(across(all_of(existing_logical), ~ as.numeric(as.logical(.))))

# -----------------------------------------------------------------------------
# Step 4: Missing Value Imputation
# -----------------------------------------------------------------------------
df_clean <- df_clean %>%
  mutate(across(where(is.numeric), ~ replace_na(., 0))) %>%
  mutate(across(where(is.character), ~ replace_na(., "")))

# -----------------------------------------------------------------------------
# Step 5: Feature Selection - Retain numeric features for modeling
# -----------------------------------------------------------------------------
df_model <- df_clean %>%
  select(high_booking, where(is.numeric))

# -----------------------------------------------------------------------------
# Step 6: Train/Test Split (75/25)
# -----------------------------------------------------------------------------
set.seed(3.14159)
data_split <- initial_split(df_model, prop = 0.75)
df_train <- training(data_split)
df_test <- testing(data_split)

# Display preprocessing summary
cat("\nPreprocessing Complete:\n")
cat("- Features retained:", ncol(df_model) - 1, "\n")
cat("- Training set size:", nrow(df_train), "\n")
cat("- Test set size:", nrow(df_test), "\n")
cat("- Training high-booking rate:",
    round(mean(df_train$high_booking == 1) * 100, 1), "%\n")
