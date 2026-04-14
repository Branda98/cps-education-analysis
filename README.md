# CPS Education Analysis

This project analyzes factors associated with obtaining a bachelor's degree or higher using CPS data. Models include LASSO, Ridge, and Random Forest.

## Repository Structure

- `scripts/`: Contains all R scripts used in the analysis
  - `03_lasso_model.R`: LASSO regression + CV + evaluation
  - `04_ridge_model.R`: Ridge regression
  - `05_random_forest.R`: Random Forest model
- `data/`: Contains dataset
- `report/`: Final paper

## How to Run

Run scripts in order:
1. `01_data_cleaning.R`
2. `03_lasso_model.R`
3. `04_ridge_model.R`
4. `05_random_forest.R`

## Notes

- LASSO uses 10-fold cross-validation with lambda.1se
- Random Forest uses 500 trees
