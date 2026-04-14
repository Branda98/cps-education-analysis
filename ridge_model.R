set.seed(1)
ridge_model <- cv.glmnet(trainx, train$education,
                         alpha        = 0,
                         family       = "binomial",
                         type.measure = "deviance")

best_lambda_ridge <- ridge_model$lambda.1se

# Coefficients
cat("\n--- Ridge Coefficients (lambda.1se) ---\n")
print(coef(ridge_model, best_lambda_ridge))

# Plot cross-validation curve
# plot(ridge_model, main = "Ridge: CV Deviance vs Lambda")

# Predictions
ridge_probs   <- as.vector(predict(ridge_model, newx = testx,
                                   s = best_lambda_ridge, type = "response"))
ridge_classes <- ifelse(ridge_probs > 0.5, 1, 0)

# Performance metrics
ridge_auc  <- auc(roc(test$education, ridge_probs))

cat("\n--- Ridge Performance AUC score ---\n")
cat("\nAUC:", ridge_auc, "\n")
print(confusionMatrix(as.factor(ridge_classes), as.factor(test$education)))