# CPS Education Analysis

This project analyzes factors associated with obtaining a bachelor's degree or higher using CPS data. Models include LASSO, Ridge, and Random Forest.

## Repository Structure

- `scripts/`: Contains all R scripts used in the analysis
  - `lasso_model.R`: LASSO regression
  - `ridge_model.R`: Ridge regression
  - `random_forest.R`: Random Forest model
- `data/`: Contains dataset
- `report/`: Final paper

## How to Run

Run scripts in order:
1. `data_cleaning.R`
2. `lasso_model.R`
3. `ridge_model.R`
4. `random_forest.R`

## Notes

- LASSO uses 10-fold cross-validation with lambda.1se
- Random Forest uses 500 trees
