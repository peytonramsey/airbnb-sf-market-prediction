# =============================================================================
# Airbnb San Francisco Market Prediction
# 04_models.R - Classification Model Training
# =============================================================================
# Models evaluated:
# 1. Logistic Regression (baseline)
# 2. Random Forest (best performer - 95% AUC)
# 3. LightGBM (93% AUC)
# 4. Bagged Trees (94% AUC)
# =============================================================================

# =============================================================================
# MODEL 1: Logistic Regression (Baseline)
# =============================================================================
cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("Training Logistic Regression Model...\n")

# Define recipe
log_recipe <- recipe(high_booking ~ ., data = df_train)

# Define model specification
log_spec <- logistic_reg() %>%
  set_engine("glm") %>%
  set_mode("classification")

# Create workflow
log_workflow <- workflow() %>%
  add_model(log_spec) %>%
  add_recipe(log_recipe)

# Fit model
fit_logistic <- fit(log_workflow, data = df_train)

# Display model summary
cat("\nLogistic Regression Coefficients:\n")
print(tidy(fit_logistic))

# Coefficient interpretation example
cat("\nCoefficient Interpretation (bedrooms):\n")
bedrooms_coef <- tidy(fit_logistic) %>%
  filter(term == "bedrooms") %>%
  pull(estimate)
cat("- Odds ratio:", round(exp(bedrooms_coef), 2), "\n")
cat("- Each additional bedroom increases odds of high booking by",
    round((exp(bedrooms_coef) - 1) * 100, 1), "%\n")

# =============================================================================
# MODEL 2: Random Forest (Best Performer - 95% AUC)
# =============================================================================
cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("Training Random Forest Model...\n")

# Define recipe with preprocessing
rf_recipe <- recipe(high_booking ~ ., data = df_train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_zv(all_predictors())

# Define model specification
rf_spec <- rand_forest(trees = 500) %>%
  set_engine("ranger") %>%
  set_mode("classification")

# Create workflow
rf_workflow <- workflow() %>%
  add_model(rf_spec) %>%
  add_recipe(rf_recipe)

# Fit model
set.seed(3.14159)
fit_rf <- fit(rf_workflow, data = df_train)

cat("Random Forest model trained successfully.\n")

# =============================================================================
# MODEL 3: LightGBM (93% AUC)
# =============================================================================
cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("Training LightGBM Model...\n")

# Define recipe
lgb_recipe <- recipe(high_booking ~ ., data = df_train) %>%
  step_normalize(all_numeric_predictors()) %>%
  step_zv(all_predictors())

# Define model specification
lgb_spec <- boost_tree(
  trees = 100,
  tree_depth = 6,
  min_n = 10,
  learn_rate = 0.1
) %>%
  set_engine("lightgbm") %>%
  set_mode("classification")

# Create workflow
lgb_workflow <- workflow() %>%
  add_model(lgb_spec) %>%
  add_recipe(lgb_recipe)

# Fit model
set.seed(3.14159)
fit_lgb <- fit(lgb_workflow, data = df_train)

cat("LightGBM model trained successfully.\n")

# =============================================================================
# MODEL 4: Bagged Trees (94% AUC)
# =============================================================================
cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("Training Bagged Trees Model...\n")

# Define recipe
bag_recipe <- recipe(high_booking ~ ., data = df_train) %>%
  step_normalize(all_predictors()) %>%
  step_zv(all_predictors())

# Define model specification (using rpart with bagging)
bag_spec <- bag_tree(min_n = 10) %>%
  set_engine("rpart", times = 50) %>%
  set_mode("classification")

# Create workflow
bag_workflow <- workflow() %>%
  add_model(bag_spec) %>%
  add_recipe(bag_recipe)

# Fit model
set.seed(3.14159)
fit_bag <- fit(bag_workflow, data = df_train)

cat("Bagged Trees model trained successfully.\n")

# =============================================================================
# Store all fitted models in a list for evaluation
# =============================================================================
models <- list(
  logistic = fit_logistic,
  random_forest = fit_rf,
  lightgbm = fit_lgb,
  bagged_trees = fit_bag
)

cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("All 4 models trained successfully!\n")
