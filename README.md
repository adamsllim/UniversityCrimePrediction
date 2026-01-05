# University Crime Prediction

## Objective...
This project analyzes crime occurrences across U.S. universities to determine whether a campus is more prone to property crime or violent crime. Using seven crime categories from the FBI’s Uniform Crime Reporting (UCR) framework, the project applies supervised learning techniques — Support Vector Machines (SVM) and K‑Nearest Neighbors (KNN) — to classify universities based on their crime profiles.

The goal of the project is to help students, administrators, and analysts understand crime patterns on university campuses, identify risk factors, and evaluate which institutions are more likely to experience property‑related or violent offenses.

## Objectives...
- Classify universities as “property crime dominant” or “violent crime dominant”
- Explore crime distributions across U.S. campuses
- Compare SVM and KNN performance on the classification task
- Identify which crime features most strongly influence classification
- Provide insights that support campus safety awareness and decision‑making

## Methodology...
1. Data Cleaning & Feature Engineering
- Used seven crime categories: rape, robbery, aggravated assault, burglary, larceny‑theft, motor vehicle theft, and arson
- Removed murder from the dataset due to zero occurrences
- Created a new response variable crime:
  - “Property crime” if property crime count > median
  - “Violent crime” otherwise
- Removed features directly correlated with the target (total violent/property crime counts)
- Explored the effect of including/excluding state information

2. Exploratory Data Analysis (EDA)
- Visualized overall crime distributions across universities
- Compared property vs violent crime frequencies
- Examined each specific crime category
- Identified that property crimes (especially larceny‑theft) occur far more frequently than violent crimes
- Observed that rape is the most common violent crime, while arson is rare

3. Modeling
- Support Vector Machine (SVM)
  - Tested linear, polynomial, and radial kernels
  - Used 80/20 train‑test split with 10‑fold cross‑validation
  - Compared scaled vs unscaled data
  - Linear kernel (unscaled) produced the best performance
  - Final model used cost = 10

- K‑Nearest Neighbors (KNN)
  - Used Leave‑One‑Out Cross‑Validation (LOOCV)
  - Tested k = 1, 3, 5, 10, 15, 20
  - Best performance achieved at k = 10

4. Interpretation
- Examined confusion matrices for both models
- Analyzed support vectors to understand misclassifications
- Found that violent crime data clusters more tightly, making it easier to classify
- Property crime data shows more variation, leading to occasional misclassification

## Key Findings...
### SVM Results

Linear kernel (unscaled) achieved the best performance
- Final model error: 1.98%
- Violent crime was classified correctly in all cases
- Only two property‑crime universities were misclassified
- Support vectors showed violent crime features cluster more tightly than property crime features

Conclusion:
- SVM with a linear kernel is highly effective for this dataset, achieving near‑perfect classification.

### KNN Results
- Best performance at k = 10
- Training error: 22.57%
- 86 misclassifications out of 381 observations
- More sensitive to noise and variation in property crime data

Conclusion:
- KNN performs reasonably but is significantly less accurate than SVM for this task.

## Error Analysis...
- SVM performed best because the dataset is linearly separable after feature selection
- Radial and polynomial kernels overfit, showing low training error but high test error
- KNN struggled due to:
  - High variation in property crime counts
  - Sensitivity to outliers
  - Lack of a clear boundary between classes
- Including “State” as a feature reduced accuracy, likely due to inconsistent regional patterns

## Future Work...
- Expand dataset to include more universities and additional crime‑related features
- Explore logistic regression, decision trees, and ensemble methods
- Investigate socio‑economic or geographic factors influencing campus crime
- Build an interactive dashboard for campus safety visualization
- Improve feature engineering to reduce variation in property crime classification
