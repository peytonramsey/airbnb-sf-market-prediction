# =============================================================================
# Airbnb San Francisco Market Prediction
# 05_evaluation.R - Model Evaluation and ROC Curve Comparison
# =============================================================================

# =============================================================================
# Generate predictions for all models
# =============================================================================
cat("Generating predictions on test set...\n\n")

# Helper function to get predictions and calculate AUC
evaluate_model <- function(model, test_data, model_name) {
  # Get probability predictions
  preds <- predict(model, new_data = test_data, type = "prob") %>%
    bind_cols(test_data %>% select(high_booking)) %>%
    mutate(high_booking = factor(high_booking, levels = c(0, 1)))

  # Calculate ROC AUC
  auc <- roc_auc(
    preds,
    truth = high_booking,
    .pred_1,
    event_level = "second"
  )

  # Get ROC curve data
  roc_data <- roc_curve(
    preds,
    truth = high_booking,
    .pred_1,
    event_level = "second"
  ) %>%
    mutate(model = model_name)

  list(
    predictions = preds,
    auc = auc$.estimate,
    roc_curve = roc_data
  )
}

# Evaluate all models
results_log <- evaluate_model(fit_logistic, df_test, "Logistic Regression")
results_rf <- evaluate_model(fit_rf, df_test, "Random Forest")
results_lgb <- evaluate_model(fit_lgb, df_test, "LightGBM")
results_bag <- evaluate_model(fit_bag, df_test, "Bagged Trees")

# =============================================================================
# Display AUC Results Summary
# =============================================================================
cat(paste(rep("=", 60), collapse = ""), "\n")
cat("MODEL PERFORMANCE COMPARISON (ROC-AUC)\n")
cat(paste(rep("=", 60), collapse = ""), "\n\n")

auc_summary <- tibble(
  Model = c("Logistic Regression", "Random Forest", "LightGBM", "Bagged Trees"),
  AUC = c(results_log$auc, results_rf$auc, results_lgb$auc, results_bag$auc)
) %>%
  arrange(desc(AUC))

print(auc_summary)

cat("\nBest Model:", auc_summary$Model[1],
    "with AUC:", round(auc_summary$AUC[1] * 100, 1), "%\n")

# =============================================================================
# ROC Curve Comparison Plot
# =============================================================================
# Combine all ROC curve data
combined_roc <- bind_rows(
  results_rf$roc_curve,
  results_bag$roc_curve,
  results_lgb$roc_curve,
  results_log$roc_curve
)

# Create ROC comparison plot
roc_comparison_plot <- ggplot(combined_roc,
                               aes(x = 1 - specificity, y = sensitivity,
                                   color = model)) +
  geom_path(size = 1.2) +
  geom_abline(lty = 3, alpha = 0.5) +
  coord_equal() +
  scale_color_manual(
    values = c(
      "Random Forest" = "#00A699",
      "Bagged Trees" = "#FF5A5F",
      "LightGBM" = "#FFB400",
      "Logistic Regression" = "#767676"
    )
  ) +
  labs(
    title = "ROC Curve Comparison",
    subtitle = paste0(
      "Random Forest: ", round(results_rf$auc * 100, 1), "% | ",
      "Bagged Trees: ", round(results_bag$auc * 100, 1), "% | ",
      "LightGBM: ", round(results_lgb$auc * 100, 1), "% | ",
      "Logistic: ", round(results_log$auc * 100, 1), "%"
    ),
    x = "False Positive Rate (1 - Specificity)",
    y = "True Positive Rate (Sensitivity)",
    color = "Model"
  ) +
  theme_minimal() +
  theme(
    legend.position = "bottom",
    legend.title = element_blank(),
    panel.grid.minor = element_blank()
  )

print(roc_comparison_plot)

# =============================================================================
# Confusion Matrix for Best Model (Random Forest)
# =============================================================================
cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("Random Forest Confusion Matrix:\n")

rf_predictions <- results_rf$predictions %>%
  mutate(predicted_class = factor(
    if_else(.pred_1 > 0.5, 1, 0),
    levels = c(0, 1)
  ))

conf_mat_rf <- conf_mat(
  rf_predictions,
  truth = high_booking,
  estimate = predicted_class
)

print(conf_mat_rf)

# Calculate accuracy
accuracy_rf <- accuracy(
  rf_predictions,
  truth = high_booking,
  estimate = predicted_class
)

cat("\nRandom Forest Accuracy:", round(accuracy_rf$.estimate * 100, 1), "%\n")

# =============================================================================
# Save model comparison results
# =============================================================================
model_comparison <- auc_summary %>%
  mutate(AUC_pct = paste0(round(AUC * 100, 1), "%"))

cat("\n", paste(rep("=", 60), collapse = ""), "\n")
cat("Final Model Rankings:\n")
for (i in 1:nrow(model_comparison)) {
  cat(i, ". ", model_comparison$Model[i], ": ",
      model_comparison$AUC_pct[i], "\n", sep = "")
}
