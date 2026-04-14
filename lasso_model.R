# One hot encoding to prep for lasso regression using training dataset

make_matrix <- function(df) {
  model.matrix(
    df$education ~
      df$disability + df$hispanic + df$hardships +
      df$marital_status + df$metropolitan_area +
      df$nativity + df$family_income + df$sex +
      df$race + df$location + df$children
  )[ , -1] %>%                          # drop intercept column
    { as.matrix(data.frame(., df$age, df$household_members)) }
}

trainx <- make_matrix(train)
testx  <- make_matrix(test)


# ============================================================
# METHOD 1: LASSO LOGISTIC REGRESSION (alpha = 1)
# ============================================================

set.seed(1)
lasso_model <- cv.glmnet(trainx, train$education,
                         alpha        = 1,
                         family       = "binomial",
                         type.measure = "deviance")

best_lambda_lasso <- lasso_model$lambda.1se

# Coefficients
cat("\n--- LASSO Coefficients (lambda.1se) ---\n")
print(coef(lasso_model, best_lambda_lasso))

# Plot cross-validation curve
# plot(lasso_model, main = "LASSO: CV Deviance vs Lambda")

# Predictions
lasso_probs   <- as.vector(predict(lasso_model, newx = testx,
                                   s = best_lambda_lasso, type = "response"))
lasso_classes <- ifelse(lasso_probs > 0.5, 1, 0)

# Performance metrics
lasso_auc  <- auc(roc(test$education, lasso_probs))

cat("\n--- LASSO Performance AUC score ---\n")
cat("\nAUC:", lasso_auc, "\n")
print(confusionMatrix(as.factor(lasso_classes), as.factor(test$education)))