# Random Forest needs factors, use the cleaned data frames directly
train_rf        <- train
train_rf$education <- as.factor(train_rf$education)
test_rf         <- test
test_rf$education  <- as.factor(test_rf$education)

set.seed(1)
rf_model <- randomForest(
  education ~ disability + hispanic + hardships + marital_status +
    metropolitan_area + nativity + family_income + sex + race +
    location + children + age + household_members,
  data       = train_rf,
  ntree      = 500,
  importance = TRUE
)

print(rf_model)

# Variable importance plot
varImpPlot(rf_model, main = "Random Forest: Variable Importance")

# Predictions
rf_probs   <- predict(rf_model, newdata = test_rf, type = "prob")[ , 2]
rf_classes <- predict(rf_model, newdata = test_rf, type = "class")

# Performance metrics
rf_auc  <- auc(roc(as.numeric(as.character(test_rf$education)), rf_probs))

cat("\n--- Random Forest Performance AUC score ---\n")
cat(rf_auc, "\n")
print(confusionMatrix(rf_classes, test_rf$education))


# ============================================================
# ROC CURVES: ALL THREE MODELS TOGETHER
# ============================================================

roc_lasso <- roc(test$education, lasso_probs)
roc_ridge <- roc(test$education, ridge_probs)
roc_rf    <- roc(as.numeric(as.character(test_rf$education)), rf_probs)

plot(roc_lasso, col = "blue",  lwd = 2, main = "ROC Curves: All Models")
plot(roc_ridge, col = "red",   lwd = 2, add = TRUE)
plot(roc_rf,    col = "green", lwd = 2, add = TRUE)
legend("bottomright",
       legend = c(paste("LASSO  AUC =", round(auc(roc_lasso), 3)),
                  paste("Ridge  AUC =", round(auc(roc_ridge), 3)),
                  paste("RF     AUC =", round(auc(roc_rf),    3))),
       col = c("blue", "red", "green"), lwd = 2)


# ============================================================
# SUMMARY COMPARISON TABLE
# ============================================================

results <- data.frame(
  Method = c("LASSO", "Ridge", "Random Forest"), AUC = round(c(lasso_auc,  ridge_auc,  rf_auc),  4)
)

print(results)