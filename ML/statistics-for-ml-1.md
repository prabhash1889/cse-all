# Statistics for Machine Learning — Part 1

A placement-focused guide to descriptive and inferential statistics. In every ML workflow, compute statistics on training data first; reuse those fitted values on validation and test data to avoid leakage.

# Mean, Median, and Mode

## 1. Overview
Mean, median, and mode are measures of central tendency: compact answers to “what is typical in this feature?” They are used in EDA, data-quality reports, missing-value imputation, baseline models, and feature monitoring.

## 2. Intuition
For salaries `[30, 35, 40, 45, 300]`, the mean is pulled toward the CEO’s salary, while the median better describes a typical employee. Mode answers which value or category appears most often.

## 3. Prerequisites
Arithmetic; sorting; numeric versus categorical variables; NumPy/Pandas arrays.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Mean | Sum of all values divided by count | Uses every magnitude but is sensitive to outliers. |
| Median | Middle value after sorting | Robust center; average the two middle values when `n` is even. |
| Mode | Most frequent value | Works for categorical data; may be absent or multiple. |
| Weighted mean | `Σwᵢxᵢ / Σwᵢ` | Used when samples have different importance. |

## 5. Algorithm / Working Process
Input one feature column. Sum and divide for the mean; sort and choose the middle for the median; count values and choose the highest count for the mode. Output one representative value, except multimodal data can return several modes.

## 6. Mathematical Foundation
For `x₁,...,xₙ`, `x̄=(1/n)Σxᵢ`. Median is the 50th percentile. Mode is `argmax_v count(xᵢ=v)`. The mean minimizes total squared error; the median minimizes total absolute error.

## 7. Practical Implementation
```python
import numpy as np
from collections import Counter

x = np.array([30, 35, 40, 45, 300])
print(x.mean(), np.median(x), Counter(x).most_common(1)[0][0])

# Fit this statistic on train data only in a real pipeline.
x_nan = np.array([30., 35., np.nan, 45., 300.])
filled = np.where(np.isnan(x_nan), np.nanmedian(x_nan), x_nan)
print(filled)
```

## 8. Code Explanation
NumPy computes vectorized mean and median. `Counter` counts discrete values. `nanmedian` ignores missing values, and `where` replaces only missing entries.

## 9. Training / Evaluation
These are preprocessing statistics, not trained models. Fit an imputer on training rows only. Median is often a strong regression baseline for MAE; mean is the equivalent baseline for MSE.

## 10. Complexity and Cost
Mean is `O(n)` time and constant extra memory. Median is commonly `O(n log n)` when sorted; mode is `O(n)` time and `O(k)` memory for `k` unique values. CPU is enough.

## 11. Common Use Cases
EDA summaries; median imputation for skewed columns; most-common-category imputation; monitoring feature center; regression baselines.

## 12. Common Mistakes
Using mean for heavy-tailed income; averaging arbitrary category IDs; computing imputation before a split; assuming mode is always unique.

## 13. Edge Cases / Limitations
Mean is outlier-sensitive; median loses magnitude detail; mode is unstable for continuous values. All three can conceal multimodal distributions.

## 14. Variations
Trimmed mean removes tails; geometric mean handles multiplicative growth; harmonic mean handles rates; weighted mean handles importance. Mean/median/mode are placement essentials.

## 15. Related Topics
Quantiles generalize median. Skewness explains mean–median gaps. MSE targets the mean; MAE targets the median.

## 16. Interview Questions
1. **Mean vs median?** Mean uses all magnitudes; median resists outliers.
2. **When use mode?** For most frequent category or repeated discrete value.
3. **Can mode be multiple?** Yes, a dataset may be multimodal.
4. **Median with even count?** Average the two sorted middle values.
5. **Which minimizes MSE?** Mean.
6. **Which minimizes MAE?** Median.
7. **Why can mean mislead?** One extreme value shifts it substantially.
8. **Can categorical codes be averaged?** Usually no; encoding numbers are arbitrary.
9. **What does mean > median often suggest?** Right skew.
10. **Income imputation choice?** Usually median after distribution inspection.

## 17. Practice Tasks
Implement all three without libraries; add outliers and compare summaries; perform train-only median imputation; plot a histogram where summaries hide two clusters.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| Data profiler | Pandas, Streamlit; arbitrary CSV | Automated robust EDA report. |
| Salary explorer | Pandas, Plotly; salary survey | Explains skew and representative center. |
| Drift monitor | Python, Evidently; event logs | Detects changes in feature center. |

## 19. Quick Revision
Key idea: summarize center. Main formula: `Σx/n`. Use median with outliers. Trap: mean is not the most common value. Interview one-liner: mean is efficient; median is robust.

## 20. Final Cheat Sheet
**Definition:** center summaries. **Input/output:** column → representative value. **Steps:** aggregate, sort, or count. **Metrics:** compare with quantiles/plots. **Pros:** simple. **Cons:** information loss. **Best use:** EDA and train-only imputation.

# Variance and Standard Deviation

## 1. Overview
Variance and standard deviation measure spread around the mean. They support feature scaling, anomaly detection, target-noise analysis, uncertainty reasoning, and normalization in ML pipelines.

## 2. Intuition
Two classes may average 70 marks, but one ranges 68–72 and another 20–100. The second has larger variance. Standard deviation expresses spread in the original unit, unlike variance.

## 3. Prerequisites
Mean, deviations, squares, square roots, basic probability, and z-score normalization.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Deviation | `xᵢ-x̄` | Signed deviations sum to zero. |
| Variance | Average squared deviation | Penalizes large departures. |
| Standard deviation | Square root of variance | Has the original unit and is interpretable. |
| Sample vs population | Divide by `n-1` vs `N` | Explain Bessel’s correction and `ddof`. |

## 5. Algorithm / Working Process
Compute mean, subtract it from each observation, square deviations, average them, then square-root for standard deviation. Input is a numeric feature; output is non-negative spread.

## 6. Mathematical Foundation
Population: `σ²=(1/N)Σ(xᵢ-μ)²`, `σ=√σ²`. Sample variance: `s²=Σ(xᵢ-x̄)²/(n-1)`. Z-score: `z=(x-x̄)/s`.

## 7. Practical Implementation
```python
import numpy as np

x = np.array([2., 4., 4., 4., 5., 5., 7., 9.])
print("population", np.var(x), np.std(x))
print("sample variance", np.var(x, ddof=1))
z = (x - x.mean()) / x.std()
assert np.isclose(z.mean(), 0) and np.isclose(z.std(), 1)
```

## 8. Code Explanation
NumPy defaults to population calculations (`ddof=0`). `ddof=1` uses the sample denominator. The assertion is a minimal check that z-score scaling centered and rescaled this sample.

## 9. Training / Evaluation
Use a training-fitted scaler for KNN, SVM, linear models, PCA, and neural networks. Tree models generally do not need scaling. Judge scaling by held-out model metrics, not only by unit variance.

## 10. Complexity and Cost
Time is `O(n)`; streaming algorithms can use constant extra memory. Avoid numerically fragile manual formulas for huge values. CPU is normally sufficient.

## 11. Common Use Cases
Standardization; control limits; anomaly detection; residual diagnostics; volatility; batch-normalization intuition.

## 12. Common Mistakes
Confusing variance with standard deviation; mixing `n` and `n-1`; fitting scaler before split; treating standard deviations as universal normal-distribution guarantees.

## 13. Edge Cases / Limitations
Outliers inflate both. A constant column has zero standard deviation and cannot be z-scored without a guard. IQR/MAD are better for heavy-tailed data.

## 14. Variations
Weighted, running (Welford), robust (MAD/IQR), and conditional variance. Standard deviation and standardization are interview priorities.

## 15. Related Topics
Variance is covariance with itself. PCA maximizes projected variance. Bias–variance trade-off includes model prediction variance.

## 16. Interview Questions
1. **Why square deviations?** To prevent cancellation and weight large errors.
2. **Variance vs standard deviation?** Squared units versus original units.
3. **Why `n-1`?** It corrects sample underestimation of population variance.
4. **Can variance be negative?** No.
5. **What does zero variance mean?** Every value is identical.
6. **Effect of multiplying data by 3?** Variance multiplies by 9.
7. **Why scale before KNN?** Large units dominate distances.
8. **Do decision trees need scaling?** Usually no.
9. **Robust spread alternative?** IQR or MAD.
10. **High target variance suggests?** A noisier, harder prediction problem.

## 17. Practice Tasks
Calculate variance manually; compare both `ddof` choices; scale train/test safely; show one outlier’s impact on standard deviation and IQR.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| Sensor anomaly alerts | Pandas, NumPy; IoT data | Statistical monitoring baseline. |
| Scaling benchmark | scikit-learn; UCI data | Measures impact on KNN/SVM. |
| Streaming variance monitor | Python; simulated events | Shows online-data competence. |

## 19. Quick Revision
Key idea: spread. Formula: average squared deviation. Use std in original units. Trap: fitting scaling on all data. One-liner: variance quantifies dispersion and drives normalization.

## 20. Final Cheat Sheet
**Input/output:** numbers → spread. **Steps:** mean, deviations, square, average, root. **Key choice:** `ddof`. **Pros:** fundamental. **Cons:** outlier-sensitive. **Best use:** scaling and data quality.

# Correlation

## 1. Overview
Correlation quantifies strength and direction of association. It helps with EDA, feature redundancy, multicollinearity checks, and monitoring relationships, but does not establish causality.

## 2. Intuition
Study hours and marks may move upward together (positive); price and demand may move oppositely (negative). A zero Pearson correlation means no linear relationship—not no relationship at all.

## 3. Prerequisites
Mean, standard deviation, covariance, scatter plots, and paired observations.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Pearson `r` | Linear association in `[-1,1]` | Interpret sign, magnitude, and causal limitation. |
| Spearman `ρ` | Pearson correlation of ranks | Use for ordinal/monotonic trends or outliers. |
| Correlation matrix | Pairwise values across features | Finds redundancy and suspicious leakage. |
| Spurious correlation | Coincidence or confounding | Correlation alone never proves mechanism. |

## 5. Algorithm / Working Process
Align paired numeric rows, handle missing values consistently, inspect a scatter plot, calculate a suitable coefficient, then assess whether the relationship is useful on held-out data.

## 6. Mathematical Foundation
`r=cov(X,Y)/(s_Xs_Y)=Σ((xᵢ-x̄)(yᵢ-ȳ))/√(Σ(xᵢ-x̄)²Σ(yᵢ-ȳ)²)`. It is undefined if either variable has zero standard deviation.

## 7. Practical Implementation
```python
import pandas as pd
from scipy.stats import pearsonr, spearmanr

df = pd.DataFrame({"hours": [1, 2, 3, 4, 5], "score": [45, 50, 65, 70, 85]})
r, p = pearsonr(df.hours, df.score)
rho, _ = spearmanr(df.hours, df.score)
print(f"Pearson r={r:.3f}, p={p:.4f}; Spearman rho={rho:.3f}")
print(df.corr(numeric_only=True))
```

## 8. Code Explanation
`pearsonr` returns coefficient plus a zero-correlation p-value under its assumptions. Spearman ranks values first. A DataFrame correlation matrix scales pairwise inspection to many numeric columns.

## 9. Training / Evaluation
Calculate correlation-based feature filters on training data only. Validate model value on a held-out set: a feature can correlate with the target but add nothing after other features, or be leakage.

## 10. Complexity and Cost
One pair is `O(n)`. A dense matrix for `d` features is about `O(nd²)` time and `O(d²)` memory. CPU is sufficient for ordinary tabular data.

## 11. Common Use Cases
EDA heatmaps; redundant-feature screening; linear-regression multicollinearity diagnosis; financial co-movement; feature-target monitoring.

## 12. Common Mistakes
Claiming causation; using Pearson for a curved relationship without plotting; ignoring outliers; blindly removing correlated features from trees; leaking target-derived features.

## 13. Edge Cases / Limitations
Pearson misses U-shaped dependence and is outlier-sensitive. Range restriction changes it. Zero correlation does not generally mean independence.

## 14. Variations
Spearman, Kendall tau, partial correlation, point-biserial correlation, and autocorrelation. Pearson/Spearman are key placement topics.

## 15. Related Topics
Covariance is unnormalized correlation. VIF measures multicollinearity. Mutual information detects wider nonlinear dependence. Causal inference asks why association exists.

## 16. Interview Questions
1. **Pearson range?** `[-1,1]`.
2. **Does `r=0` imply independence?** No, only no linear association.
3. **Does `r=1` prove causation?** No.
4. **Why is r unitless?** It divides covariance by both standard deviations.
5. **When use Spearman?** Ordinal or monotonic/outlier-prone data.
6. **When undefined?** A constant variable.
7. **Can high correlation be leakage?** Yes; inspect data origin and time.
8. **What is multicollinearity?** Predictors strongly correlate with each other.
9. **Do trees require uncorrelated inputs?** No.
10. **Best inspection method?** Coefficient plus scatter plot and domain context.

## 17. Practice Tasks
Simulate linear, U-shaped, and outlier data; compare Pearson/Spearman; build a heatmap; find a leaked feature in a toy pipeline.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| Correlation auditor | Pandas, Plotly | Flags collinearity and leakage risks. |
| Asset relationship explorer | Pandas, Plotly; returns | Studies changing correlations. |
| Feature filter study | sklearn; UCI data | Validates EDA choices on holdout data. |

## 19. Quick Revision
Key idea: standardized linear association. Formula: `cov/(std×std)`. Use a plot. Trap: causation claims. One-liner: correlation is an EDA signal, not causal proof.

## 20. Final Cheat Sheet
**Input/output:** paired columns → `[-1,1]`. **Steps:** align, inspect, compute, validate. **Metrics:** `r`, `ρ`, CI/p-value. **Pros:** interpretable. **Cons:** linear/outlier limitations. **Best use:** EDA.

# Covariance

## 1. Overview
Covariance measures whether variables deviate from their means together. It powers covariance matrices, PCA, multivariate Gaussian models, Mahalanobis distance, and risk analysis.

## 2. Intuition
If people who are above-average in height are usually also above-average in weight, products of their deviations are positive, so covariance is positive.

## 3. Prerequisites
Mean, variance, deviations, matrix multiplication, and paired observations.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Sign | Positive together; negative opposite | Indicates joint direction, not comparable magnitude. |
| Covariance matrix | Diagonal variances; off-diagonal covariances | Input to PCA and Gaussian methods. |
| Scale dependence | Units alter magnitude | Explains why correlation is often easier to compare. |
| PSD property | Valid matrix is symmetric positive semidefinite | Important for numerical validity. |

## 5. Algorithm / Working Process
Center every feature by its mean. Multiply paired centered values and average for a scalar covariance. For many features, multiply the centered matrix transpose by itself and divide by the degrees-of-freedom denominator.

## 6. Mathematical Foundation
`Cov(X,Y)=E[(X-μ_X)(Y-μ_Y)]`. Sample covariance is `Σ(xᵢ-x̄)(yᵢ-ȳ)/(n-1)`. For centered rows-as-samples matrix `X_c`, `S=X_cᵀX_c/(n-1)`.

## 7. Practical Implementation
```python
import numpy as np

X = np.array([[1., 2.], [2., 4.], [3., 5.], [4., 8.]])
S = np.cov(X, rowvar=False, ddof=1)
print(S)
assert np.allclose(S, S.T)
print("joint covariance:", S[0, 1])
```

## 8. Code Explanation
`rowvar=False` says columns are variables. The diagonal is sample variance; off-diagonal entries measure joint spread. Symmetry is an essential covariance-matrix check.

## 9. Training / Evaluation
Estimate covariance on training data for PCA, Gaussian classifiers, or whitening. When features outnumber samples, regularize/shrink covariance and validate the downstream result.

## 10. Complexity and Cost
For `n` samples and `d` features, dense covariance costs roughly `O(nd²)` time and `O(d²)` memory. Large `d` often needs dimensionality reduction or shrinkage.

## 11. Common Use Cases
PCA; portfolio diversification; multivariate anomaly detection; Kalman filters; Gaussian discriminant analysis; whitening.

## 12. Common Mistakes
Using rows/features in the wrong orientation; comparing covariance across differently scaled units; forgetting centering; inverting a singular matrix; reading covariance as causation.

## 13. Edge Cases / Limitations
Outliers distort it. Categorical columns do not suit ordinary covariance. Small-sample high-dimensional estimates can be singular/noisy. Zero covariance is not general independence.

## 14. Variations
Population/sample, robust, shrinkage (Ledoit–Wolf), autocovariance, and cross-covariance. Covariance matrices and PCA are interview-relevant.

## 15. Related Topics
`Var(X)=Cov(X,X)`. Correlation normalizes covariance. PCA eigendecomposes it. Mahalanobis distance uses inverse covariance.

## 16. Interview Questions
1. **Variance relationship?** `Var(X)=Cov(X,X)`.
2. **Is covariance symmetric?** Yes.
3. **Why not compare magnitudes directly?** Units affect them.
4. **Diagonal of a covariance matrix?** Feature variances.
5. **Positive covariance means?** Values tend to move together.
6. **Does zero imply independence?** Not generally.
7. **Why divide by `n-1`?** Sample correction.
8. **PCA connection?** Components are variance-maximizing covariance directions.
9. **Why is singularity bad?** Matrix inverse is unavailable.
10. **Fix high dimension?** Shrinkage or reduce dimensions.

## 17. Practice Tasks
Calculate a 2×2 matrix by hand; verify diagonal variance; compare empirical/shrinkage covariance; apply PCA before and after scaling.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| PCA image compressor | NumPy, sklearn; Fashion-MNIST | Explains covariance-to-components pipeline. |
| Portfolio risk dashboard | Pandas, Plotly; asset returns | Demonstrates diversification math. |
| Multivariate anomaly detector | sklearn; sensor readings | Uses Mahalanobis distance. |

## 19. Quick Revision
Key idea: joint spread. Formula: average product of deviations. Trap: scale-dependent values. One-liner: correlation is normalized covariance.

## 20. Final Cheat Sheet
**Input/output:** paired features → scalar/matrix. **Steps:** center, multiply, average. **Key choice:** sample vs population/shrinkage. **Pros:** multivariate foundation. **Cons:** scale and outlier sensitivity. **Best use:** PCA/Gaussian methods.

# Sampling

## 1. Overview
Sampling chooses observations from a population so we can train, evaluate, and infer without measuring everything. It is foundational for datasets, minibatches, A/B tests, labeling, and reliable model evaluation.

## 2. Intuition
A city survey should sample residents broadly, not only friends. A representative random subset can estimate population behavior; a biased subset cannot be rescued merely by making it large.

## 3. Prerequisites
Population versus sample, probability, random seeds, class labels, and train/validation/test splitting.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Random sampling | Known selection chance | Reduces selection bias. |
| With replacement | Units can repeat | Bootstrap draws are independent. |
| Stratified sampling | Preserves group proportions | Essential for imbalanced classification splits. |
| Cluster/systematic | Sample groups/every kth unit | Practical but can inherit pattern bias. |
| Bootstrap | Resample observed sample | Estimates uncertainty without new data. |

## 5. Algorithm / Working Process
Define target population and sampling frame; choose a design; sample with a reproducible seed; verify representation; isolate test data. For ML, fit preprocessing only after splitting and use minibatches during training.

## 6. Mathematical Foundation
The sample mean estimates population mean. Under IID sampling, standard error is approximately `s/√n`. Random error decreases at rate `1/√n`; systematic selection bias does not disappear with larger `n`.

## 7. Practical Implementation
```python
import numpy as np
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split

X, y = load_breast_cancer(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)
rng = np.random.default_rng(42)
means = [rng.choice(X_train[:, 0], len(X_train), replace=True).mean() for _ in range(1000)]
print(y.mean(), y_test.mean(), np.percentile(means, [2.5, 97.5]))
```

## 8. Code Explanation
`stratify=y` preserves class balance approximately; `random_state` makes results reproducible. Each bootstrap draw resamples training rows with replacement; percentile bounds approximate a 95% interval for a mean.

## 9. Training / Evaluation
Use stratified splits for imbalanced labels, group splits for repeated users/patients, and chronological splits for time series. Never let duplicates, augmented variants, or future data cross into evaluation.

## 10. Complexity and Cost
Basic sampling is `O(n)`. `B` bootstrap draws cost `O(Bn)`. Minibatches reduce memory and make large-model optimization feasible.

## 11. Common Use Cases
Surveys; data labeling; train/test split; SGD minibatches; class-balanced batches; bootstrap confidence intervals; A/B experiments.

## 12. Common Mistakes
Convenience sampling; random time-series split; no stratification for rare labels; duplicate leakage; repeatedly using test data; unseeded experiments.

## 13. Edge Cases / Limitations
Missing groups in the sampling frame remain unobserved. Tiny rare classes may not split well. IID assumptions fail in time, geography, networks, and repeated-user data.

## 14. Variations
Simple random, stratified, cluster, systematic, reservoir, importance, and active sampling. Stratification and bootstrap are placement essentials.

## 15. Related Topics
Sampling distributions support CIs and tests. Minibatch sampling enables SGD. Cross-validation repeatedly resamples partitions.

## 16. Interview Questions
1. **Population vs sample?** Whole target group versus observed subset.
2. **Why stratify?** Preserve label proportions.
3. **With replacement?** A unit may occur repeatedly.
4. **Why bootstrap?** Estimate uncertainty from existing observations.
5. **Does bigger n remove bias?** No.
6. **Why not random split time data?** Future leakage.
7. **Sampling frame?** Source list/process from which units are selected.
8. **Why seed?** Reproducibility.
9. **How split grouped data?** A group-aware splitter.
10. **What is a minibatch?** Small sample used for one gradient estimate.

## 17. Practice Tasks
Compare random/stratified splits; bootstrap a metric; simulate sample means at several `n`; show temporal leakage from a random split.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| Split auditor | sklearn, Pandas | Detects label/group/time imbalance. |
| Bootstrap metric reporter | sklearn, NumPy | Adds uncertainty to model metrics. |
| Active-labeling simulator | Python, sklearn; text/images | Shows data-efficient learning. |

## 19. Quick Revision
Key idea: representative subset. Formula: `SE=s/√n`. Use stratification for imbalance. Trap: random split is not always valid. One-liner: more data reduces variance, not bias.

## 20. Final Cheat Sheet
**Input/output:** population/frame → sample/splits. **Steps:** define target, choose method, sample, audit. **Key choices:** seed, strata, replacement. **Pros:** scalable. **Cons:** selection bias. **Best use:** all empirical ML.

# Bias and Variance

## 1. Overview
Bias and variance explain generalization error from overly simple assumptions versus excessive sensitivity to training data. They guide model capacity, regularization, ensembles, and debugging of underfitting/overfitting.

## 2. Intuition
A line forced through a curved pattern is consistently wrong (high bias). A deep tree that changes dramatically after a few rows change has high variance. Good generalization balances them.

## 3. Prerequisites
Supervised learning, train/validation error, expectation, squared loss, regularization, and cross-validation.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Bias | Difference between average prediction and true function | High bias produces underfitting. |
| Variance | Prediction variation across training sets | High variance produces overfitting. |
| Irreducible noise | Unobservable randomness in target | Cannot be removed by complexity. |
| Regularization | Complexity penalty | Typically raises bias and lowers variance. |

## 5. Algorithm / Working Process
Train models of several capacities, compare train and cross-validation loss, then act on the pattern. High train and validation loss suggests bias; low train but high validation loss suggests variance.

## 6. Mathematical Foundation
For squared loss: `E[(Y-f̂(X))²]=Bias(f̂(X))²+Var(f̂(X))+σ²_noise`. Validation loss estimates the total, not perfect individual components from one dataset.

## 7. Practical Implementation
```python
from sklearn.datasets import make_regression
from sklearn.model_selection import validation_curve
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import PolynomialFeatures
from sklearn.linear_model import Ridge

X, y = make_regression(n_samples=200, n_features=1, noise=25, random_state=42)
model = make_pipeline(PolynomialFeatures(), Ridge())
degree, train, valid = validation_curve(
    model, X, y, param_name="polynomialfeatures__degree",
    param_range=range(1, 11), scoring="neg_mean_squared_error", cv=5
)
print(list(zip(degree, -train.mean(1), -valid.mean(1))))
```

## 8. Code Explanation
The validation curve trains increasing polynomial capacities under five folds. MSE is negated by sklearn’s scoring convention. A widening train–validation gap indicates variance; uniformly bad scores indicate bias or weak features.

## 9. Training / Evaluation
Use cross-validation and reserve final test data. To reduce variance: get data, augment, regularize, prune, early-stop, use dropout/bagging. To reduce bias: improve features, train longer, reduce regularization, or increase appropriate capacity.

## 10. Complexity and Cost
Higher capacity and ensembles raise training, inference, and memory cost. Cross-validation multiplies training by the number of folds.

## 11. Common Use Cases
Choosing tree depth; neural-network regularization; learning-curve diagnosis; bagging; boosting; hyperparameter tuning.

## 12. Common Mistakes
Calling all poor accuracy overfitting; choosing by train score; tuning on test data; assuming complexity always helps; ignoring label noise or split mismatch.

## 13. Edge Cases / Limitations
The textbook decomposition is cleanest for regression squared loss. Dataset shift can dominate both. A validation gap may come from a bad split, not only model variance.

## 14. Variations
Learning curves, bagging (variance reduction), boosting (often bias reduction), Bayesian uncertainty, double descent. This trade-off is a core placement concept.

## 15. Related Topics
Overfitting/underfitting operationalize the trade-off. Regularization controls capacity. Cross-validation estimates generalization. Ensembles trade compute for stability.

## 16. Interview Questions
1. **High-bias pattern?** High train and validation loss.
2. **High-variance pattern?** Low train, high validation loss.
3. **What does more data help?** Usually variance.
4. **Regularization effect?** Higher bias, lower variance.
5. **Bagging effect?** Mainly lower variance.
6. **Boosting effect?** Often lower bias, may fit noise.
7. **Can test loss rise with capacity?** Yes.
8. **Irreducible error?** Noise unavailable in inputs.
9. **How diagnose?** Learning and validation curves.
10. **Can leakage hide variance?** Yes, with unrealistically good validation.

## 17. Practice Tasks
Plot polynomial curves; vary tree depth; compare a tree to Random Forest; add label noise; use learning curves to recommend a next fix.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| Diagnosis dashboard | sklearn, Streamlit | Turns error patterns into actions. |
| Ensemble benchmark | sklearn; California Housing | Quantifies bagging benefits. |
| Augmentation study | PyTorch; CIFAR-10 | Demonstrates variance control. |

## 19. Quick Revision
Key idea: systematic error versus instability. Formula: bias² + variance + noise. Trap: train score alone. One-liner: generalization needs the capacity sweet spot.

## 20. Final Cheat Sheet
**Input/output:** model/data → error diagnosis. **Steps:** correct split, curves, tune capacity. **Hyperparameters:** depth, alpha, dropout. **Metrics:** held-out loss. **Pros:** actionable. **Cons:** idealized decomposition. **Best use:** model debugging.

# Hypothesis Testing

## 1. Overview
Hypothesis testing is a decision framework for assessing whether observed data is sufficiently inconsistent with a baseline claim. It is used in A/B tests, feature experiments, model comparisons, and scientific studies.

## 2. Intuition
A recommender’s conversion rises from 10.0% to 10.3%. The test asks whether a difference this large would be unusual if the true lift were zero, rather than declaring success from the raw difference alone.

## 3. Prerequisites
Probability distributions, sampling, standard errors, null/alternative hypotheses, confidence intervals, and significance levels.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Null `H₀` | Baseline/no-effect claim | Tests seek evidence against it, not proof it is true. |
| Alternative `H₁` | Competing claim | Specify one- or two-sided direction before seeing data. |
| Type I/II error | False positive / false negative | `α` controls Type I; power addresses Type II. |
| Test statistic | Standardized discrepancy | Determines the null distribution and p-value. |
| Power | Detecting a true effect | Drives sample-size planning. |

## 5. Algorithm / Working Process
State a measurable question and `H₀/H₁`; choose method/assumptions and `α` in advance; collect independent representative data; compute statistic, p-value, effect size, and CI; reject or fail to reject `H₀`; report practical impact.

## 6. Mathematical Foundation
One-sample t statistic: `t=(x̄-μ₀)/(s/√n)`. Compare it with a t distribution with `n-1` degrees of freedom. For two independent means, Welch’s t-test is a good default when variances may differ.

## 7. Practical Implementation
```python
import numpy as np
from scipy.stats import ttest_ind

rng = np.random.default_rng(42)
control = rng.normal(100, 12, 200)
treatment = rng.normal(103, 12, 200)
t, p = ttest_ind(treatment, control, equal_var=False)
print(f"lift={treatment.mean()-control.mean():.2f}, t={t:.2f}, p={p:.4f}, reject={p < .05}")
```

## 8. Code Explanation
The code simulates independent groups. Welch’s test avoids assuming equal variance. The result must include lift, not only p-value: a statistically detectable difference may be operationally trivial.

## 9. Training / Evaluation
For ML model comparisons on the same examples, preserve paired errors/predictions and use a paired method or paired bootstrap. Predeclare primary metric, stopping rule, guardrails, and minimum useful effect.

## 10. Complexity and Cost
Common analytic tests are `O(n)`; computation is cheap. Obtaining enough independent data or training repetitions for reliable power is usually expensive.

## 11. Common Use Cases
A/B tests; conversion comparison; feature impact; model-error comparison; scientific evaluation.

## 12. Common Mistakes
Peeking/stopping after significance; uncorrected multiple tests; post-hoc hypotheses; p-value-only reporting; confusing statistical and practical significance; biased instrumentation.

## 13. Edge Cases / Limitations
Huge samples make trivial effects significant. Small samples miss real effects. Dependence, contamination, nonstationarity, and poor sampling invalidate nominal conclusions.

## 14. Variations
z-test, Welch/paired t-test, chi-square/Fisher test, Mann–Whitney, permutation test, Bayesian A/B analysis. t-test and error types are placement priorities.

## 15. Related Topics
p-values quantify null-data compatibility. Confidence intervals show uncertainty. Sampling and power control reliability. Causal conclusions require good experimental design.

## 16. Interview Questions
1. **What is `H₀`?** Baseline/no-effect claim.
2. **Reject or accept?** Reject or fail to reject; never prove it true.
3. **Type I error?** False positive.
4. **Type II error?** Missing a real effect.
5. **Power?** Probability of detection when an effect exists.
6. **Why Welch?** It handles unequal variances.
7. **One vs two tailed?** Directional predeclared claim versus either direction.
8. **Practical significance?** Effect is large enough to matter.
9. **Why correct multiple tests?** Many tests inflate false positives.
10. **Can a test prove a model always wins?** No, it is conditional on sampled conditions.

## 17. Practice Tasks
Test two model-error arrays; simulate 1,000 null experiments; vary sample size while holding effect fixed; implement a permutation test.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| A/B analyzer | Streamlit, SciPy | End-to-end experiment reporting. |
| Model comparison lab | sklearn, SciPy; UCI data | Uses paired uncertainty analysis. |
| Power calculator | NumPy, statsmodels | Plans experiment sample size. |

## 19. Quick Revision
Key idea: evidence against a baseline. Formula: `t=(estimate-null)/SE`. Use a predeclared test. Trap: p-value is not probability the null is true. One-liner: report effect, CI, and p-value together.

## 20. Final Cheat Sheet
**Input/output:** experiment → decision plus uncertainty. **Steps:** predefine, test, contextualize. **Key choices:** alternative, α, power. **Pros:** disciplined comparison. **Cons:** design-sensitive. **Best use:** A/B and model experiments.

# p-value

## 1. Overview
A p-value is the probability, assuming the null hypothesis and test assumptions, of data at least as extreme as the observed result. It is evidence against a null model—not the probability that the null is true.

## 2. Intuition
Seeing 95 heads in 100 flips is very surprising if a coin is fair, so its p-value under fairness is tiny. That does not itself state the probability that the coin is unfair.

## 3. Prerequisites
Hypothesis testing, null distributions, test statistics, probability tails, significance thresholds, and sampling variability.

## 4. Core Concepts
| Subtopic | Meaning | Why it matters / interview angle |
|---|---|---|
| Null conditionality | Calculated under `H₀` | Corrects the most common interpretation error. |
| Extremeness | At least as incompatible with `H₀` | Depends on statistic and alternative. |
| Threshold `α` | Prechosen decision boundary | `.05` is policy, not a truth cutoff. |
| Effect size | Magnitude of difference | Tiny p can have tiny practical value. |
| Multiplicity | Many tests create chance small p-values | Requires adjustment or preselection. |

## 5. Algorithm / Working Process
Choose null, alternative, statistic, tails, and `α` before data analysis. Compute observed statistic, find its null-tail probability, and report p-value with effect size and confidence interval. Make a predeclared decision, not a binary truth claim.

## 6. Mathematical Foundation
For statistic `T`, right-tailed p-value is `P(T≥t_obs | H₀)`. A symmetric two-sided p-value is commonly `P(|T|≥|t_obs| | H₀)`. Under true `H₀` and valid assumptions, p-values are uniformly distributed on `[0,1]`.

## 7. Practical Implementation
```python
import numpy as np
from scipy.stats import ttest_1samp

latency_ms = np.array([102, 98, 101, 104, 99, 103, 100, 105])
result = ttest_1samp(latency_ms, popmean=100, alternative="two-sided")
print(f"mean diff={latency_ms.mean()-100:.2f} ms, t={result.statistic:.2f}, p={result.pvalue:.4f}")
```

## 8. Code Explanation
The test assumes a null population mean latency of 100 ms. Two-sided means deviations in either direction count. Mean difference communicates size; p-value communicates null-model compatibility.

## 9. Training / Evaluation
Do not declare one model better from a single accuracy difference alone. Preserve paired per-example predictions, avoid tuning repeatedly on the test set, and use a valid paired method. Report uncertainty and product relevance.

## 10. Complexity and Cost
Analytic calculation is usually `O(n)`. Permutation p-values cost `O(Bn)` for `B` shuffles. Independent data collection is the real cost.

## 11. Common Use Cases
A/B-test dashboards; regression coefficient tests; feature experiments; model-improvement checks; scientific reporting.

## 12. Common Mistakes
Reading p as `P(H₀ true)`; treating .049 and .051 as meaningfully different; p-hacking; ignoring multiplicity, power, and effect size; choosing a one-sided test after seeing results.

## 13. Edge Cases / Limitations
Low power can yield high p for meaningful effects. Massive samples can yield tiny p for negligible effects. Dependence and invalid distribution assumptions produce misleading p-values.

## 14. Variations
One-/two-sided, exact, permutation, and adjusted p-values (Bonferroni, Benjamini–Hochberg). Bayesian posterior probabilities are a different answer, not p-values.

## 15. Related Topics
Hypothesis testing supplies decisions; confidence intervals provide effect ranges; power and sampling determine sensitivity; FDR handles multiple comparisons.

## 16. Interview Questions
1. **Define p-value.** Probability of equally/more extreme data assuming `H₀`.
2. **Is it `P(H₀ true)`?** No.
3. **Does p=.03 prove usefulness?** No; inspect effect and cost.
4. **Does p>.05 prove no effect?** No; it is insufficient evidence at that α.
5. **Why set α first?** Prevents outcome-driven decisions.
6. **Why does n lower p?** Larger n reduces standard error for a fixed effect.
7. **One/two-sided choice?** Predeclared directional vs non-directional claim.
8. **How handle 100 tests?** Control familywise error/FDR.
9. **What determines p?** Effect, variance, n, and test design.
10. **What should accompany p?** Effect estimate and CI.

## 17. Practice Tasks
Simulate fair coins; vary sample size for fixed effect; compare analytic and permutation p-values; apply Bonferroni and FDR corrections.

## 18. Project Ideas
| Project | Stack and dataset | Resume value |
|---|---|---|
| Result explainer | Streamlit, SciPy | Prevents p-value misinterpretation. |
| Multiple-testing dashboard | Pandas, statsmodels | Demonstrates FDR control. |
| ML improvement validator | sklearn, NumPy | Tests paired prediction changes. |

## 19. Quick Revision
Key idea: surprise under `H₀`. Formula: null-tail probability. Use alongside effect/CI. Trap: it is not hypothesis probability. One-liner: p-values measure compatibility, not importance.

## 20. Final Cheat Sheet
**Definition:** null-conditional tail probability. **Input/output:** statistic/data → p-value. **Steps:** declare test, calculate statistic, use null tail. **Key parameters:** alternative, α, correction. **Pros:** familiar. **Cons:** easily misread. **Best use:** preplanned experiments.

