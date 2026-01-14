# =============================================================================
# Airbnb San Francisco Market Prediction
# 03_eda.R - Exploratory Data Analysis and Visualizations
# =============================================================================

# -----------------------------------------------------------------------------
# Price Distribution Analysis
# Key Finding: Right-skewed distribution with $150 median vs $257 mean
# -----------------------------------------------------------------------------
price_stats <- df_clean %>%
  summarise(
    mean_price = mean(price, na.rm = TRUE),
    median_price = median(price, na.rm = TRUE),
    sd_price = sd(price, na.rm = TRUE)
  )

cat("Price Statistics:\n")
cat("- Mean: $", round(price_stats$mean_price, 2), "\n")
cat("- Median: $", round(price_stats$median_price, 2), "\n")
cat("- Std Dev: $", round(price_stats$sd_price, 2), "\n")

# Price distribution histogram (log scale)
# Filter out zero/negative prices for log scale
plot_price_dist <- ggplot(df_clean %>% filter(price > 0), aes(x = price)) +
  geom_histogram(fill = "#FF5A5F", bins = 50, alpha = 0.8) +
  scale_x_log10(labels = scales::dollar_format()) +
  geom_vline(xintercept = price_stats$median_price,
             linetype = "dashed", color = "darkgreen", size = 1) +
  geom_vline(xintercept = price_stats$mean_price,
             linetype = "dashed", color = "darkred", size = 1) +
  labs(
    title = "Price Distribution (Log Scale) of San Francisco Airbnb Listings",
    x = "Nightly Price ($) - Log Scale",
    y = "Number of Listings"
  ) +
  theme_minimal()

print(plot_price_dist)

# -----------------------------------------------------------------------------
# Superhost Analysis
# Key Finding: Superhosts charge lower prices ($217 vs $280) but have
#              higher quality metrics (99% response rate vs 92%)
# -----------------------------------------------------------------------------
superhost_analysis <- df_clean %>%
  group_by(host_is_superhost) %>%
  summarise(
    count = n(),
    avg_price = mean(price, na.rm = TRUE),
    high_booking_rate = mean(high_booking == 1, na.rm = TRUE) * 100,
    avg_response_rate = mean(host_response_rate, na.rm = TRUE) * 100,
    avg_acceptance_rate = mean(host_acceptance_rate, na.rm = TRUE) * 100
  )

cat("\nSuperhost Analysis:\n")
print(superhost_analysis)

# Superhost percentage in dataset
superhost_pct <- mean(df_clean$host_is_superhost, na.rm = TRUE) * 100
cat("\nSuperhost percentage:", round(superhost_pct, 1), "%\n")

# -----------------------------------------------------------------------------
# Review Scores by Booking Status
# Key Finding: High-booking properties have similar review scores
# -----------------------------------------------------------------------------
review_summary <- df_train %>%
  group_by(high_booking) %>%
  summarise(
    avg_rating = mean(review_scores_rating, na.rm = TRUE),
    avg_cleanliness = mean(review_scores_cleanliness, na.rm = TRUE),
    avg_location = mean(review_scores_location, na.rm = TRUE),
    avg_value = mean(review_scores_value, na.rm = TRUE)
  )

cat("\nReview Scores by Booking Status:\n")
print(review_summary)

# Review scores visualization
review_long <- df_train %>%
  select(
    high_booking,
    rating = review_scores_rating,
    cleanliness = review_scores_cleanliness,
    location = review_scores_location,
    value = review_scores_value
  ) %>%
  pivot_longer(
    cols = -high_booking,
    names_to = "score_type",
    values_to = "score"
  )

plot_reviews <- ggplot(review_long, aes(x = score_type, y = score,
                                         fill = high_booking)) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  scale_fill_manual(values = c("#FF5A5F", "#00A699"),
                    labels = c("Low Booking", "High Booking")) +
  labs(
    title = "Review Scores by Booking Status",
    x = "Score Type",
    y = "Average Score",
    fill = "Booking Status"
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

print(plot_reviews)

# -----------------------------------------------------------------------------
# Price vs Review Scores Relationship
# -----------------------------------------------------------------------------
plot_price_reviews <- ggplot(df_train %>% filter(price > 0),
                              aes(x = review_scores_rating, y = price)) +
  geom_point(aes(color = high_booking), alpha = 0.5) +
  scale_y_log10(labels = scales::dollar_format()) +
  scale_color_manual(values = c("#FF5A5F", "#00A699"),
                     labels = c("Low Booking", "High Booking")) +
  labs(
    title = "Relationship between Ratings, Price, and Booking Success",
    x = "Overall Review Score",
    y = "Price (log scale)",
    color = "Booking Status"
  ) +
  theme_minimal()

print(plot_price_reviews)

# -----------------------------------------------------------------------------
# Train/Test Price Comparison
# Validates consistent distribution across splits
# -----------------------------------------------------------------------------
cat("\nTrain/Test Price Comparison:\n")
cat("- Train mean: $", round(mean(df_train$price, na.rm = TRUE), 2), "\n")
cat("- Test mean: $", round(mean(df_test$price, na.rm = TRUE), 2), "\n")
cat("- Train median: $", round(median(df_train$price, na.rm = TRUE), 2), "\n")
cat("- Test median: $", round(median(df_test$price, na.rm = TRUE), 2), "\n")
