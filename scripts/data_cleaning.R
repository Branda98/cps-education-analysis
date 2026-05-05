library(tidyverse)
library(glmnet)
library(randomForest)
library(pROC)
library(caret)
library(dplyr)

data <- read.csv("C:\\Users\\brand\\Downloads\\jun22pub.csv", header = TRUE)

#Filtering age responses
new_data <- filter(data, prtage >= 22 & prtage <= 32)
```

```{r include=FALSE}
# hardships
new_data <- new_data %>% 
  rename(hardships = penlfact)
new_data <- new_data %>% 
  mutate(hardships = case_when(
    hardships == -1 ~ "Unknown/None",
    hardships == 1 ~ "Disabled",
    hardships == 3 ~ "School",
    hardships == 2 ~ "Ill",
    hardships == 4 ~ "Care",
    hardships == 5 ~ "Retirement",
    hardships == 6 ~ "Other",
  ))

# Family income
new_data <- new_data %>%
  rename(family_income = hefaminc) %>%
  mutate(family_income = factor(
    family_income,
    levels = 1:16,
    labels = c(
      "<5K", "5-7.5K", "7.5-10K", "10-12.5K", "12.5-15K", "15-20K",
      "20-25K", "25-30K", "30-35K", "35-40K", "40-50K", "50-60K",
      "60-75K", "75-100K", "100-150K", "150K+"
    ),
    ordered = TRUE
  ))

# Education (No higher degree = 0, Higher degree = 1)
# I will code education (education) into two options so I can apply logistic regression on my model.

new_data <- new_data %>% 
  rename(education = peeduca)
new_data <- new_data %>% 
  mutate(education = case_when(
    education < 43 ~ 0,
    education >= 43 ~ 1,
  ))

# Sex (Female = 1, Male = 2)
new_data <- new_data %>% 
  rename(sex = pesex)
new_data <- new_data %>% 
  mutate(sex = case_when(
    sex == 1 ~ "male",
    sex == 2 ~ "female",
  ))

# Race
new_data <- new_data %>% 
  rename(race = ptdtrace)
new_data <- new_data %>% 
  mutate(race = case_when(
    race == 1 ~ "White",
    race == 2 ~ "Black",
    race == 3 ~ "amer_ind_alask",
    race == 4 ~ "asian",
    race == 5 ~ "hawai_Pac",
    race >= 6 ~ "mixed",
  ))

# Location
new_data <- new_data %>% 
  rename(location = gereg)
new_data <- new_data %>% 
  mutate(location = case_when(
    location == 1 ~ "northeast",
    location == 2 ~ "midwest",
    location == 3 ~ "south",
    location == 4 ~ "west",
  ))

# Nativity
new_data <- new_data %>% 
  rename(nativity = prcitshp)
new_data <- new_data %>% 
  mutate(nativity = case_when(
    nativity == 1 ~ "native_US",
    nativity == 2 ~ "native_Other",
    nativity == 3 ~ "native_Abroad",
    nativity == 4 ~ "foreign_NatuCit",
    nativity == 5 ~ "foreign_NotCit",
  ))

# Filtering out Armed Force people
new_data <- filter(new_data, pemlr != -1)

# Disability
new_data <- new_data %>% 
  rename(disability = prdisflg)
new_data <- new_data %>% 
  mutate(disability = case_when(
    disability == 1 ~ "no_disability",
    disability == 2 ~ "disability",
  ))

# Metropolitan area
new_data <- new_data %>% 
  rename(metropolitan_area = gtcbsasz)
new_data <- new_data %>% 
  mutate(metropolitan_area = case_when(
    metropolitan_area == 0 ~ "not_identified_or_nonmetropolitan",
    metropolitan_area == 2 ~ "100,000 - 249,999",
    metropolitan_area == 3 ~ "250,000 - 499,999",
    metropolitan_area == 4 ~ "500,000 - 999,999",
    metropolitan_area == 5 ~ "1,000,000 - 2,499,999",
    metropolitan_area == 6 ~ "2,500,000 - 4,999,999",
    metropolitan_area == 7 ~ "5,000,000",
  ))

# Marital status
new_data <- new_data %>% 
  rename(marital_status = pemaritl)
new_data <- new_data %>% 
  mutate(marital_status = case_when(
    marital_status == 1 ~ "married_Spouse_present",
    marital_status == 2 ~ "married_Spouse_absent",
    marital_status == 3 ~ "widowed",
    marital_status == 4 ~ "divorced",
    marital_status == 5 ~ "separated",
    marital_status == 6 ~ "never_married",
  ))

# Hispanic
new_data <- new_data %>% 
  rename(hispanic = pehspnon)
new_data <- new_data %>% 
  mutate(hispanic = case_when(
    hispanic == 1 ~ "hispanic",
    hispanic == 2 ~ "non_hispanic",
  ))

# Number of children
new_data <- new_data %>% 
  rename(children = prnmchld)

# Age
new_data <- new_data %>% 
  rename(age = prtage)

# Number of household members
new_data <- new_data %>% 
  rename(household_members = hrnumhou)


# Re leveling to make "White" as the reference level
new_data$race = relevel(factor(new_data$race), ref = "White")

# Splitting 80% of the dataset into training and 20% of the dataset into testing.

set.seed(1)
indexset <- sample(2, nrow(new_data), replace = T, prob = c(0.8, 0.2))
train <- new_data[indexset == 1, ]
test <- new_data[indexset == 2, ]
