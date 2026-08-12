# Scikit-learn (`sklearn`): Complete Placement and Interview Guide

Scikit-learn is Python's standard general-purpose library for classical machine learning. The import name is `sklearn`, while the package is installed as `scikit-learn`. Its most important contribution is not one particular algorithm; it is a **consistent estimator API** that makes preprocessing, training, validation, tuning, evaluation, and deployment composable.

Throughout this guide:

- $X \in \mathbb{R}^{n \times d}$ is the feature matrix with $n$ samples and $d$ features.
- $y$ is the target: continuous for regression and categorical for classification.
- `fit` learns state only from training data.
- `transform` applies a learned transformation.
- `predict` produces model outputs for unseen examples.

> **Interview focus:** A strong answer does more than name classes. Explain how scikit-learn prevents leakage, why pipelines are cloned during cross-validation, how scoring and parameter routing work, and how the chosen metric connects to business cost.

---

## 1. Overview

### What scikit-learn is

Scikit-learn is an open-source Python library built around NumPy, SciPy, and related scientific-Python tools. It provides production-quality implementations of many classical ML workflows:

- **Supervised learning:** linear models, support-vector machines, nearest neighbors, decision trees, ensembles, naive Bayes, discriminant analysis, and neural-network multilayer perceptrons.
- **Unsupervised learning:** clustering, dimensionality reduction, density estimation, anomaly detection, and matrix decomposition.
- **Data preparation:** imputation, scaling, encoding, discretization, feature generation, feature selection, and text vectorization.
- **Model selection:** train/test splitting, cross-validation, learning curves, validation curves, randomized/grid search, and successive-halving search.
- **Evaluation:** classification, regression, clustering, ranking, probability, calibration, and custom metrics.
- **Composition:** `Pipeline`, `ColumnTransformer`, `FeatureUnion`, transformed-target regression, multiclass wrappers, and reusable custom estimators.
- **Utilities:** datasets, inspection tools, partial dependence, permutation importance, calibration, persistence-compatible estimators, and configuration.

Scikit-learn is mainly designed for **tabular data and classical ML on one machine**. It can process sparse matrices efficiently and parallelize some operations, but it is not a distributed big-data framework and is not the usual choice for training modern CNNs, Transformers, or billion-parameter models.

### Why it is useful

The library gives different algorithms the same vocabulary:

```python
estimator.fit(X_train, y_train)
predictions = estimator.predict(X_test)
score = estimator.score(X_test, y_test)
```

This consistency enables algorithms to be swapped inside the same pipeline, tuned by the same search object, and evaluated by the same cross-validation machinery. A reliable ML system therefore needs less custom orchestration code.

### Where it is used

Real systems commonly use scikit-learn for:

- churn, fraud, approval, risk, and conversion prediction;
- price, demand, duration, and capacity forecasting from tabular features;
- customer or document segmentation;
- search/ranking features and lightweight text classifiers;
- anomaly detection for operations, security, and manufacturing;
- preprocessing or baseline models around deep-learning systems;
- offline experimentation, prototypes, teaching, and model benchmarks;
- small and medium-sized inference services, batch jobs, and edge deployments.

### When not to use it

Prefer another tool when the main requirement is distributed computation over data too large for one machine, automatic differentiation and GPU-heavy deep learning, streaming-first learning at large scale, or specialized statistical inference. Common alternatives include Spark ML for distributed workloads, PyTorch/JAX/TensorFlow for deep learning, statsmodels for detailed statistical inference, and specialized gradient-boosting libraries for some large tabular tasks.

---

## 2. Intuition

Think of scikit-learn as a set of interchangeable machines connected by standard plugs.

1. A **transformer** learns how to clean or represent data. For example, `StandardScaler` learns each feature's mean and standard deviation.
2. An **estimator** learns a model. For example, `LogisticRegression` learns coefficients.
3. A **pipeline** connects transformers to the final estimator.
4. A **model-selection tool** repeatedly clones and trains that pipeline on different folds or hyperparameter settings.
5. A **metric** judges the predictions according to the real objective.

Suppose a bank predicts loan default from age, income, city, and employment type. Numeric columns require imputation and perhaps scaling; categorical columns require imputation and one-hot encoding. If these transformations are manually fitted before cross-validation, validation information leaks into training. A `Pipeline` containing a `ColumnTransformer` makes each fold learn its own imputation, categories, scaling, and model using only that fold's training partition.

The key mental model is:

$$
X_{\text{raw}}
\xrightarrow{\text{fit/transform preprocessing}}
X_{\text{features}}
\xrightarrow{\text{fit/predict estimator}}
\hat y.
$$

At inference time, the already learned preprocessing state is reused; it must never be refitted on the new example.

---

## 3. Prerequisites

### Python and data tools

- Python functions, classes, imports, exceptions, and context managers.
- NumPy arrays: shape, axis, indexing, vectorization, data types, and missing values.
- pandas DataFrames: columns, categorical/numeric types, joins, grouping, and missing values.
- Sparse matrices for high-dimensional text or one-hot data.
- Basic visualization with Matplotlib or Seaborn.

### Mathematics

- Vectors, matrices, dot products, norms, rank, eigenvectors, and singular values.
- Mean, median, variance, covariance, quantiles, and probability distributions.
- Conditional probability and Bayes' rule.
- Derivatives, gradients, convexity, and regularization.
- Distance measures such as Euclidean and cosine distance.
- Confusion matrices and statistical sampling.

### Machine-learning foundations

- Features, labels, training, inference, parameters, and hyperparameters.
- Supervised versus unsupervised learning.
- Classification versus regression.
- Bias-variance trade-off, underfitting, overfitting, and regularization.
- Train/validation/test splits and cross-validation.
- Data leakage, class imbalance, metric selection, and reproducibility.

### Environment basics

Know the distinction between:

```bash
pip install scikit-learn   # distribution/package name
```

and:

```python
import sklearn             # Python import name
```

For reproducible projects, pin dependencies in a lock file or environment specification and record the Python and scikit-learn versions alongside serialized models.

---

## 4. Core Concepts

### 4.1 The estimator API

An **estimator** is any object that learns from data through `fit`. Estimator constructor arguments are hyperparameters; learned attributes conventionally end with an underscore.

```python
from sklearn.linear_model import LogisticRegression

model = LogisticRegression(C=1.0, max_iter=2000)  # hyperparameters
model.fit(X_train, y_train)

print(model.get_params())  # includes C and max_iter
print(model.coef_)         # learned parameter; trailing underscore
```

Why it matters: model-selection tools can inspect `get_params`, clone the object, change parameters through `set_params`, and train independent copies. Do not put training data or learned values in the constructor of a custom estimator.

**Interview angle:** `fit` mutates the estimator and returns `self`; learned attributes such as `classes_`, `coef_`, or `n_features_in_` appear after fitting. Calling prediction before fitting normally raises `NotFittedError`.

### 4.2 Estimator families and methods

| Family | Main methods | Meaning | Example |
|---|---|---|---|
| Classifier | `fit`, `predict`, often `predict_proba` or `decision_function` | Predict a discrete class | `LogisticRegression` |
| Regressor | `fit`, `predict` | Predict a continuous value | `RandomForestRegressor` |
| Transformer | `fit`, `transform`, `fit_transform` | Learn and apply a representation | `StandardScaler` |
| Clusterer | `fit`, often `fit_predict` | Discover groups without labels | `KMeans` |
| Density/anomaly estimator | `fit`, `score_samples`, `predict` | Estimate density or abnormality | `IsolationForest` |
| Meta-estimator | wraps other estimators | Adds composition or behavior | `Pipeline`, `GridSearchCV` |

`score` is only a default convenience metric and varies by estimator. Classifiers commonly return accuracy; regressors commonly return $R^2$. In serious work, select an explicit scoring metric.

### 4.3 Parameters versus learned attributes

- **Parameter/hyperparameter:** chosen before fitting, such as `max_depth=5` or `C=0.1`.
- **Learned parameter:** estimated from data, such as a regression coefficient or tree split.
- **Attribute ending in `_`:** fitted state exposed by convention, such as `mean_`, `categories_`, or `feature_importances_`.

`clone(estimator)` constructs an unfitted estimator with the same hyperparameters. Cross-validation and search rely on this behavior, so each fold receives a fresh model and fitted state is not shared.

### 4.4 Transformers and preprocessing

A transformer separates learning from application:

```python
scaler.fit(X_train)          # learns train mean/std
X_train_z = scaler.transform(X_train)
X_test_z = scaler.transform(X_test)  # reuses train statistics
```

Common transformers include:

| Need | Class | Important detail |
|---|---|---|
| Fill missing values | `SimpleImputer`, `KNNImputer`, `IterativeImputer` | Imputer must be fit inside validation folds |
| Standard scaling | `StandardScaler` | Important for distance/gradient/margin models |
| Robust scaling | `RobustScaler` | Uses median and IQR; less sensitive to outliers |
| Range scaling | `MinMaxScaler` | Maps training range to a chosen interval |
| One-hot encoding | `OneHotEncoder` | Use unknown-category handling for inference |
| Ordinal encoding | `OrdinalEncoder` | Only imply order when order is real |
| Polynomial features | `PolynomialFeatures` | Can rapidly increase dimension |
| Feature selection | `SelectKBest`, `RFE`, `SelectFromModel` | Put selection inside the pipeline |
| Text features | `CountVectorizer`, `TfidfVectorizer` | Produces sparse matrices |
| Dimensionality reduction | `PCA`, `TruncatedSVD` | PCA centers; SVD works naturally with sparse text |

**Common interview angle:** scaling is normally unnecessary for decision trees because split ordering is unchanged by monotonic rescaling. It matters for SVMs, k-NN, k-means, PCA, regularized linear models, and neural networks because their objectives use magnitudes, distances, variance, or gradient optimization.

### 4.5 `Pipeline`

A pipeline is an ordered sequence of transformations followed by an estimator:

```python
from sklearn.pipeline import Pipeline

pipe = Pipeline([
    ("scale", StandardScaler()),
    ("model", LogisticRegression())
])
```

Benefits:

- prevents preprocessing leakage during cross-validation;
- keeps training and inference transformations identical;
- allows joint tuning with names such as `model__C`;
- packages the full feature-to-prediction process into one object;
- reduces brittle manual feature processing in deployment.

Every intermediate step must implement `fit` and `transform`. The last step only needs `fit`; it may be a classifier, regressor, or transformer. Use `'passthrough'` to keep a step inactive and `None` to remove it where supported.

### 4.6 `ColumnTransformer`

Tabular datasets often need different transformations by column:

```python
from sklearn.compose import ColumnTransformer

preprocess = ColumnTransformer([
    ("numeric", numeric_pipeline, numeric_columns),
    ("categorical", categorical_pipeline, categorical_columns),
])
```

It selects column subsets, transforms them independently, and horizontally concatenates the results. `remainder="drop"` is the default; `remainder="passthrough"` retains unlisted columns. Be explicit so schema changes do not silently alter the model.

### 4.7 Feature names and output containers

Interpretation and debugging become easier when feature lineage is preserved:

```python
names = fitted_pipeline.named_steps["preprocess"].get_feature_names_out()
```

One-hot encoding can turn `city` into `categorical__city_Delhi`, `categorical__city_Mumbai`, and so on. Some transformers support configured pandas output, but downstream estimators and sparse-output constraints must be compatible. Always verify shape and feature order rather than assuming it.

### 4.8 Train, validation, and test data

- **Training set:** learns model and preprocessing parameters.
- **Validation set:** selects hyperparameters, thresholds, and sometimes models.
- **Test set:** estimates final generalization only after choices are frozen.
- **Cross-validation:** rotates validation roles across training partitions.

For classification, `stratify=y` approximately preserves label proportions. For grouped data, split by group. For time series, preserve time ordering. Random splitting is not universally valid.

### 4.9 Cross-validation splitters

| Splitter | Use when | Main risk addressed |
|---|---|---|
| `KFold` | IID regression/general data | ordinary sampling variation |
| `StratifiedKFold` | classification | unstable class proportions |
| `GroupKFold` | samples share patient/user/device | group leakage |
| `StratifiedGroupKFold` | groups and label balance both matter | group leakage plus imbalance |
| `TimeSeriesSplit` | observations are time ordered | future-to-past leakage |
| `LeaveOneOut` | very small datasets, high compute acceptable | maximal training fraction, but high variance |
| repeated splitters | uncertainty across repeated partitions matters | sensitivity to one partition |

Cross-validation estimates performance of the **whole learning procedure**, not merely the already-fitted model. A pipeline is cloned and fitted from scratch in every fold.

### 4.10 Hyperparameter search

`GridSearchCV` evaluates a specified Cartesian grid. `RandomizedSearchCV` samples a fixed number of configurations from distributions or lists and is usually better when many dimensions matter. Search objects:

1. split the data;
2. clone the estimator for each candidate and fold;
3. fit and score all candidates;
4. identify `best_params_` according to `refit`/scoring;
5. normally refit the best configuration on all supplied training data.

Nested parameter names use double underscores:

```python
param_grid = {
    "preprocess__numeric__imputer__strategy": ["mean", "median"],
    "model__C": [0.01, 0.1, 1, 10],
}
```

Do not tune on the test set. For an unbiased estimate after extensive model selection, use a final untouched test set or nested cross-validation.

### 4.11 Metrics and scorers

A **metric function** typically receives `(y_true, y_pred)` and returns a value. A **scorer** follows scikit-learn's model-selection convention and receives `(estimator, X, y)`. Search and CV functions use scorer names such as `"roc_auc"`, `"f1"`, or `"neg_mean_absolute_error"`.

Why are loss scorers negative? Model selection always maximizes a score, so losses are sign-flipped:

```python
scores = cross_val_score(model, X, y, scoring="neg_mean_absolute_error")
mae = -scores.mean()
```

For custom business metrics, use `make_scorer`, state whether larger is better, and state whether the metric needs hard labels, probabilities, or decision scores.

### 4.12 Randomness and reproducibility

`random_state` controls pseudorandom behavior in splitters and many estimators. Fixing it helps debugging and comparison, but does not automatically guarantee identical results across different package versions, hardware, numerical libraries, parallel schedules, or unordered data ingestion.

Use a fixed split during development, then confirm conclusions over multiple folds or seeds when variance matters. A lucky seed is not evidence of a good model.

### 4.13 Dense and sparse data

One-hot encoding and text vectorization frequently produce sparse matrices. A dense $n \times d$ float64 matrix uses roughly $8nd$ bytes, while a sparse matrix stores mainly nonzero values and indices. Some estimators accept sparse input; some silently densify or reject it. Densifying a huge term-document matrix can exhaust memory.

### 4.14 Metadata, sample weights, and class weights

Some estimators accept metadata such as `sample_weight` during fitting. A larger weight makes a sample influence the objective more strongly. `class_weight="balanced"` often assigns class weights inversely proportional to observed frequency:

$$
w_c = \frac{n}{K n_c},
$$

where $K$ is the number of classes and $n_c$ is the count of class $c$. Weights do not create information; they change the optimization trade-off. Evaluation should still reflect the deployment distribution and business costs.

### 4.15 Model inspection

Useful inspection tools include:

- linear coefficients, after accounting for feature scaling;
- tree impurity-based importance, with its known biases;
- permutation importance on held-out data;
- partial dependence and individual conditional expectation;
- confusion matrices, calibration curves, prediction-error plots, and learning curves.

Interpretation is not causality. Correlated features can split or hide importance, and preprocessing changes coefficient units.

### 4.16 Custom estimators

A minimal custom transformer should follow the API:

```python
from sklearn.base import BaseEstimator, TransformerMixin
from sklearn.utils.validation import check_is_fitted

class PercentileClipper(TransformerMixin, BaseEstimator):
    def __init__(self, lower=1.0, upper=99.0):
        self.lower = lower
        self.upper = upper

    def fit(self, X, y=None):
        import numpy as np
        self.lower_bounds_ = np.percentile(X, self.lower, axis=0)
        self.upper_bounds_ = np.percentile(X, self.upper, axis=0)
        return self

    def transform(self, X):
        import numpy as np
        check_is_fitted(self, ["lower_bounds_", "upper_bounds_"]) 
        return np.clip(X, self.lower_bounds_, self.upper_bounds_)
```

Constructor parameters should be stored without data-dependent work. `fit` creates learned underscore attributes and returns `self`. `transform` should not alter input unexpectedly. Production-grade custom estimators should validate shape/types, expose output names if appropriate, support sparse input if claimed, and pass estimator checks.

---

## 5. Algorithm / Working Process

Scikit-learn is a framework, so its working process is an end-to-end workflow rather than one algorithm.

### Step 1: Define the prediction problem

Specify:

- one row's meaning and prediction time;
- target definition and prediction horizon;
- available features at prediction time;
- cost of false positives, false negatives, and delayed decisions;
- offline metric and business acceptance criteria.

This prevents target leakage and avoids optimizing an irrelevant metric.

### Step 2: Load and audit data

Check schema, types, missingness, duplicates, target frequency, units, suspicious identifiers, temporal coverage, groups, and label quality. Separate features and target:

$$
D = \{(x_i,y_i)\}_{i=1}^{n}.
$$

### Step 3: Create the final holdout split

Choose the split based on the data-generating process:

- IID observations: randomized split;
- imbalanced classification: stratified split;
- multiple rows per entity: group split;
- future prediction: chronological split.

Never inspect the test set to make repeated modeling choices.

### Step 4: Build preprocessing by feature type

For example:

- numeric: median imputation followed by standardization;
- categorical: most-frequent imputation followed by one-hot encoding;
- text: TF-IDF;
- ordinal: explicit ordered encoding;
- skewed positive variables: logarithmic transformation if justified.

Fit every learned transformation inside a pipeline.

### Step 5: Establish a baseline

Use `DummyClassifier` or `DummyRegressor`. A complex model that cannot beat a target-only baseline has no demonstrated value. Then try a simple interpretable model before a complex ensemble.

### Step 6: Train using the unified pipeline

Input: raw training rows. Processing: the pipeline learns preprocessing state, transforms training data, and fits the estimator. Output: a fitted composite model that accepts raw rows.

For a pipeline $f = h \circ g$, training learns transformer $g_{\theta}$ and model $h_{\phi}$:

$$
\theta = \operatorname{fitTransformState}(X_{train}), \qquad
\phi = \operatorname{fitModel}(g_{\theta}(X_{train}), y_{train}).
$$

### Step 7: Cross-validate and tune

For each candidate hyperparameter setting $\lambda$ and each fold $k$:

1. clone the entire pipeline;
2. fit preprocessing and estimator on $D \setminus D_k$;
3. transform and predict $D_k$;
4. calculate the chosen score;
5. aggregate scores over folds.

Choose a candidate based on the mean, variance, business constraints, and complexity—not an insignificant decimal difference alone.

### Step 8: Select threshold when needed

Classification models often emit a score or probability. The business decision is:

$$
\hat y = \mathbb{1}[\hat p(y=1\mid x) \ge t].
$$

The default $t=0.5$ is not sacred. Choose $t$ on validation data according to cost, recall, precision, capacity, or expected utility. Do not choose it on the final test set.

### Step 9: Evaluate once on the final test set

Report several complementary views:

- primary metric and confidence/variability where possible;
- confusion matrix or residual distribution;
- subgroup/slice performance;
- calibration when probabilities drive decisions;
- comparison with baseline and current production method;
- latency and memory if operationally relevant.

### Step 10: Refit, persist, and serve

Once the procedure and hyperparameters are frozen, optionally refit on all appropriate development data. Persist the complete pipeline, not just the estimator. The inference process becomes:

```text
raw schema validation -> fitted preprocessing -> fitted model -> score
-> validated threshold/business rule -> prediction
```

### Step 11: Monitor after deployment

Monitor input schema, missingness, category rates, drift, prediction distribution, latency, errors, delayed outcome metrics, calibration, subgroup quality, and model/data version. Retrain based on evidence or a validated schedule, not merely because a cron job exists.

---

## 6. Mathematical Foundation

Scikit-learn implements many mathematical models. The following foundations explain the most frequently interviewed components.

### 6.1 Standardization

For feature $j$, `StandardScaler` learns the training mean and scale and applies:

$$
z_{ij}=\frac{x_{ij}-\mu_j}{\sigma_j}, \qquad
\mu_j=\frac{1}{n}\sum_{i=1}^{n}x_{ij}, \qquad
\sigma_j=\sqrt{\frac{1}{n}\sum_{i=1}^{n}(x_{ij}-\mu_j)^2}.
$$

The test set uses training $\mu_j$ and $\sigma_j$. Standardization does not make a distribution Gaussian; it changes location and scale.

### 6.2 Min-max and robust scaling

Min-max scaling to $[a,b]$:

$$
x' = a + \frac{x-x_{\min}}{x_{\max}-x_{\min}}(b-a).
$$

Robust scaling commonly uses median $m$ and interquartile range:

$$
x' = \frac{x-m}{Q_3-Q_1}.
$$

Min-max scaling is strongly affected by extreme training values; robust scaling is less sensitive but does not remove outliers.

### 6.3 One-hot encoding

A categorical feature with $K$ observed categories becomes $K$ indicator columns:

$$
x=c_k \Rightarrow [0,\ldots,1_k,\ldots,0].
$$

For an unregularized linear model with an intercept, keeping all $K$ columns creates exact collinearity. One category may be dropped, although regularized predictors can often handle the redundant representation. Unknown categories at inference require an explicit policy such as all-zero encoding or an infrequent-category bucket.

### 6.4 Linear regression and regularization

Ordinary least squares minimizes:

$$
\min_{w,b}\frac{1}{n}\sum_{i=1}^{n}(y_i-w^Tx_i-b)^2.
$$

Ridge adds an $L_2$ penalty:

$$
\min_{w,b}\frac{1}{n}\sum_i(y_i-w^Tx_i-b)^2+\alpha\|w\|_2^2.
$$

Lasso adds an $L_1$ penalty:

$$
\min_{w,b}\frac{1}{n}\sum_i(y_i-w^Tx_i-b)^2+\alpha\|w\|_1.
$$

Ridge shrinks correlated coefficients and improves conditioning. Lasso can set coefficients exactly to zero, performing embedded selection, but may choose unstably among correlated features. Scaling is important because regularization penalizes coefficient magnitude.

### 6.5 Logistic regression

For binary classification:

$$
z=w^Tx+b, \qquad
p(y=1\mid x)=\sigma(z)=\frac{1}{1+e^{-z}}.
$$

The log-odds are linear:

$$
\log\frac{p}{1-p}=w^Tx+b.
$$

Binary cross-entropy/log loss is:

$$
\mathcal L=-\frac{1}{n}\sum_{i=1}^{n}
[y_i\log p_i+(1-y_i)\log(1-p_i)] + \lambda R(w).
$$

In scikit-learn, `C` is conventionally the inverse of regularization strength: smaller `C` means stronger regularization. Solver and penalty compatibility matters.

### 6.6 Support-vector machines

A soft-margin linear SVM solves a form of:

$$
\min_{w,b,\xi}\frac{1}{2}\|w\|^2+C\sum_i\xi_i
$$

subject to:

$$
y_i(w^Tx_i+b)\ge 1-\xi_i,\qquad \xi_i\ge0.
$$

Equivalently, it balances margin size against hinge loss $\max(0,1-y_if(x_i))$. Kernel SVMs replace inner products with a kernel such as the RBF kernel:

$$
K(x,x')=\exp(-\gamma\|x-x'\|^2).
$$

Scaling matters because distances and margins depend on feature magnitude. Kernel SVM training can become expensive as sample count grows.

### 6.7 Decision trees

A decision tree recursively selects a feature and threshold that maximize impurity reduction. For classification, common impurity measures include:

$$
Gini(S)=1-\sum_{k=1}^{K}p_k^2,
$$

and entropy:

$$
H(S)=-\sum_{k=1}^{K}p_k\log_2p_k.
$$

Weighted impurity decrease for a split is:

$$
\Delta I=I(S)-\frac{n_L}{n}I(S_L)-\frac{n_R}{n}I(S_R).
$$

For regression, squared-error reduction is common. Trees capture nonlinear interactions without scaling but are unstable and can overfit unless depth, leaf size, pruning, or ensembles control complexity.

### 6.8 Random forests and bagging

A random forest trains many trees on bootstrap samples and considers a random subset of features at each split. Regression averages predictions:

$$
\hat y(x)=\frac{1}{B}\sum_{b=1}^{B}T_b(x).
$$

Classification averages class probabilities or aggregates tree outputs. Averaging reduces variance when tree errors are not perfectly correlated. More trees mainly increase computation and memory; depth/leaf constraints control individual-tree complexity.

### 6.9 Gradient boosting

Gradient boosting builds an additive model:

$$
F_M(x)=F_0(x)+\eta\sum_{m=1}^{M}h_m(x),
$$

where each weak learner $h_m$ approximately follows the negative gradient of the loss from the current model, and $\eta$ is the learning rate. Small learning rates usually require more iterations. Tree depth/leaf count controls interaction complexity. Boosting can be highly accurate but needs careful validation and is more sequential than random forests.

### 6.10 k-nearest neighbors

For a query $x$, k-NN finds the $k$ closest training points. Euclidean distance is:

$$
d(x,z)=\sqrt{\sum_{j=1}^{d}(x_j-z_j)^2}.
$$

Classification uses a vote; regression uses an average, optionally weighted by inverse distance. Training mostly stores data, so inference can be expensive. Scaling and the curse of dimensionality are central interview points.

### 6.11 Naive Bayes

Bayes' rule gives:

$$
P(y=c\mid x)=\frac{P(x\mid y=c)P(y=c)}{P(x)}.
$$

Naive Bayes assumes conditional feature independence:

$$
P(x\mid y=c)=\prod_{j=1}^{d}P(x_j\mid y=c).
$$

Despite the unrealistic assumption, it can be strong for text because high-dimensional word evidence combines efficiently. Gaussian, multinomial, Bernoulli, categorical, and complement variants use different likelihood assumptions.

### 6.12 Principal component analysis

After centering $X$, PCA finds orthonormal directions maximizing projected variance. Equivalently, the first component solves:

$$
v_1=\arg\max_{\|v\|=1}\operatorname{Var}(Xv).
$$

Using singular value decomposition:

$$
X=U\Sigma V^T.
$$

Rows of $V^T$ define principal directions; singular values determine explained variance. PCA is unsupervised: it preserves variance, not necessarily predictive signal. It also changes interpretability and is sensitive to feature scale.

### 6.13 k-means clustering

K-means minimizes within-cluster squared distance:

$$
J=\sum_{i=1}^{n}\|x_i-\mu_{c_i}\|_2^2.
$$

It alternates:

1. assign each point to its nearest centroid;
2. update each centroid to the mean of assigned points;
3. stop when assignments/objective stabilize or a limit is reached.

Initialization matters because the objective is non-convex. K-means favors roughly spherical, similarly scaled clusters and requires choosing $K$.

### 6.14 Cross-validation estimate

For $K$ folds and metric $M$, the mean cross-validation score is:

$$
\widehat M_{CV}=\frac{1}{K}\sum_{k=1}^{K}
M\left(y^{(k)},\hat f^{(-k)}(X^{(k)})\right),
$$

where $\hat f^{(-k)}$ is trained without fold $k$. Fold scores are dependent because training sets overlap, so their standard deviation is a useful stability summary but not automatically a rigorous confidence interval.

### 6.15 Classification metrics

From true positives (TP), false positives (FP), true negatives (TN), and false negatives (FN):

$$
Accuracy=\frac{TP+TN}{TP+TN+FP+FN},
$$

$$
Precision=\frac{TP}{TP+FP},\qquad
Recall=\frac{TP}{TP+FN},
$$

$$
F_1=2\frac{Precision\cdot Recall}{Precision+Recall}.
$$

Specificity is $TN/(TN+FP)$. Balanced accuracy averages recall across classes. ROC-AUC measures ranking over positive-negative pairs; PR-AUC/average precision is often more informative about positive retrieval under severe imbalance. Log loss evaluates probabilistic confidence and strongly penalizes confident errors. Brier score measures squared probability error:

$$
BS=\frac{1}{n}\sum_i(p_i-y_i)^2.
$$

### 6.16 Regression metrics

$$
MAE=\frac1n\sum_i|y_i-\hat y_i|,
$$

$$
MSE=\frac1n\sum_i(y_i-\hat y_i)^2,\qquad RMSE=\sqrt{MSE},
$$

$$
R^2=1-\frac{\sum_i(y_i-\hat y_i)^2}{\sum_i(y_i-\bar y)^2}.
$$

MAE is robust relative to MSE and stays in target units. RMSE penalizes large errors more. $R^2$ compares against predicting the test-set mean and can be negative on unseen data. Percentage metrics require care near zero and with negative targets.

### 6.17 Optimization

Different estimators use different solvers: closed-form linear algebra, coordinate descent, stochastic or batch gradient methods, quasi-Newton methods, sequential minimal optimization, greedy tree construction, expectation-maximization-like alternation, and more.

A generic gradient step is:

$$
\theta_{t+1}=\theta_t-\eta\nabla_\theta \mathcal L(\theta_t).
$$

Convergence warnings are diagnostic signals. Appropriate responses include scaling, increasing iteration limits, checking collinearity or extreme values, selecting a compatible solver, or changing regularization—not blindly suppressing warnings.

---

## 7. Practical Implementation

The following end-to-end example creates a realistic mixed-type classification dataset without requiring a network download. It demonstrates splitting, baselines, preprocessing, pipeline construction, cross-validation, randomized search, threshold selection, final evaluation, feature inspection, and persistence.

### 7.1 Imports and reproducible sample data

```python
from pathlib import Path
import joblib
import numpy as np
import pandas as pd

from scipy.stats import loguniform, randint
from sklearn.compose import ColumnTransformer
from sklearn.datasets import make_classification
from sklearn.dummy import DummyClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.impute import SimpleImputer
from sklearn.inspection import permutation_importance
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    classification_report,
    confusion_matrix,
    f1_score,
    precision_recall_curve,
    roc_auc_score,
)
from sklearn.model_selection import (
    RandomizedSearchCV,
    StratifiedKFold,
    cross_validate,
    train_test_split,
)
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

RANDOM_STATE = 42

# Create numeric signal, then add realistic categorical and missing values.
X_array, y = make_classification(
    n_samples=3000,
    n_features=6,
    n_informative=4,
    n_redundant=1,
    weights=[0.82, 0.18],
    class_sep=1.0,
    flip_y=0.02,
    random_state=RANDOM_STATE,
)

numeric_columns = [
    "income",
    "utilization",
    "account_age",
    "recent_queries",
    "balance",
    "risk_signal",
]
X = pd.DataFrame(X_array, columns=numeric_columns)

rng = np.random.default_rng(RANDOM_STATE)
X["region"] = rng.choice(["north", "south", "east", "west"], len(X))
X["channel"] = rng.choice(
    ["web", "branch", "partner"], len(X), p=[0.60, 0.25, 0.15]
)

# Introduce missing values to exercise the imputation pipeline.
for column in ["income", "utilization", "region"]:
    missing_rows = rng.choice(len(X), size=int(0.04 * len(X)), replace=False)
    X.loc[missing_rows, column] = np.nan

categorical_columns = ["region", "channel"]
```

### 7.2 Train/validation/test split

```python
# The test set is untouched until all model and threshold choices are complete.
X_dev, X_test, y_dev, y_test = train_test_split(
    X,
    y,
    test_size=0.20,
    stratify=y,
    random_state=RANDOM_STATE,
)

# A validation set is used only for choosing the operating threshold.
X_train, X_valid, y_train, y_valid = train_test_split(
    X_dev,
    y_dev,
    test_size=0.25,  # 0.25 of 0.80 = 0.20 of all rows
    stratify=y_dev,
    random_state=RANDOM_STATE,
)

print(X_train.shape, X_valid.shape, X_test.shape)
```

### 7.3 Baseline and preprocessing

```python
baseline = DummyClassifier(strategy="prior")
baseline.fit(X_train, y_train)
baseline_probability = baseline.predict_proba(X_valid)[:, 1]
print("Baseline validation ROC-AUC:", roc_auc_score(y_valid, baseline_probability))

numeric_pipeline = Pipeline([
    ("imputer", SimpleImputer(strategy="median", add_indicator=True)),
    ("scaler", StandardScaler()),
])

categorical_pipeline = Pipeline([
    ("imputer", SimpleImputer(strategy="most_frequent")),
    ("onehot", OneHotEncoder(handle_unknown="ignore")),
])

preprocess = ColumnTransformer([
    ("numeric", numeric_pipeline, numeric_columns),
    ("categorical", categorical_pipeline, categorical_columns),
])

pipeline = Pipeline([
    ("preprocess", preprocess),
    ("model", LogisticRegression(max_iter=3000)),
])
```

### 7.4 Cross-validation with multiple metrics

```python
cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=RANDOM_STATE)

cv_result = cross_validate(
    pipeline,
    X_train,
    y_train,
    cv=cv,
    scoring={
        "roc_auc": "roc_auc",
        "average_precision": "average_precision",
        "f1": "f1",
    },
    return_train_score=True,
    n_jobs=-1,
)

for metric in ["roc_auc", "average_precision", "f1"]:
    values = cv_result[f"test_{metric}"]
    print(f"CV {metric}: {values.mean():.3f} +/- {values.std():.3f}")
```

### 7.5 Joint model and hyperparameter search

The search compares a scaled logistic model with a random forest. Each list is a separate search space, avoiding parameters that are invalid for the other estimator.

```python
search_spaces = [
    {
        "model": [LogisticRegression(max_iter=3000)],
        "model__C": loguniform(1e-3, 1e2),
        "model__class_weight": [None, "balanced"],
    },
    {
        "model": [RandomForestClassifier(random_state=RANDOM_STATE, n_jobs=1)],
        "model__n_estimators": randint(150, 500),
        "model__max_depth": [None, 5, 10, 20],
        "model__min_samples_leaf": randint(1, 15),
        "model__max_features": ["sqrt", 0.5, 1.0],
        "model__class_weight": [None, "balanced"],
    },
]

search = RandomizedSearchCV(
    estimator=pipeline,
    param_distributions=search_spaces,
    n_iter=20,
    scoring={
        "roc_auc": "roc_auc",
        "average_precision": "average_precision",
    },
    refit="average_precision",
    cv=cv,
    n_jobs=-1,
    random_state=RANDOM_STATE,
    return_train_score=True,
    verbose=1,
)

search.fit(X_train, y_train)
print("Best parameters:", search.best_params_)
print("Best CV average precision:", search.best_score_)
```

> **Parallelism warning:** Avoid severe nested parallelism. The search uses `n_jobs=-1`, while the forest candidate uses `n_jobs=1`, so every candidate does not create another full set of workers.

### 7.6 Select a threshold on validation data

This example chooses the threshold with the best validation $F_1$. A real system should instead encode the actual false-positive/false-negative cost or capacity constraint.

```python
best_model = search.best_estimator_
valid_probability = best_model.predict_proba(X_valid)[:, 1]

precision, recall, thresholds = precision_recall_curve(y_valid, valid_probability)

# precision and recall contain one extra endpoint compared with thresholds.
f1_values = 2 * precision[:-1] * recall[:-1] / (
    precision[:-1] + recall[:-1] + 1e-12
)
best_index = int(np.argmax(f1_values))
threshold = float(thresholds[best_index])

print("Chosen threshold:", threshold)
print("Validation F1:", f1_values[best_index])
```

### 7.7 Final test evaluation

```python
test_probability = best_model.predict_proba(X_test)[:, 1]
test_prediction = (test_probability >= threshold).astype(int)

print("Test ROC-AUC:", roc_auc_score(y_test, test_probability))
print("Test F1:", f1_score(y_test, test_prediction))
print("Confusion matrix:\n", confusion_matrix(y_test, test_prediction))
print(classification_report(y_test, test_prediction, digits=3))
```

### 7.8 Inspect feature effects safely

Permutation importance can be evaluated on raw held-out columns because it calls the complete pipeline. It measures score degradation after shuffling each raw column.

```python
importance = permutation_importance(
    best_model,
    X_test,
    y_test,
    scoring="average_precision",
    n_repeats=10,
    random_state=RANDOM_STATE,
    n_jobs=-1,
)

importance_table = (
    pd.DataFrame({
        "feature": X_test.columns,
        "importance_mean": importance.importances_mean,
        "importance_std": importance.importances_std,
    })
    .sort_values("importance_mean", ascending=False)
)
print(importance_table)
```

### 7.9 Persist model and decision threshold

```python
artifact = {
    "model": best_model,
    "threshold": threshold,
    "raw_columns": X.columns.tolist(),
    "target_definition": "synthetic positive-class risk label",
}

artifact_path = Path("risk_model.joblib")
joblib.dump(artifact, artifact_path)

loaded = joblib.load(artifact_path)
new_rows = X_test.iloc[:3]
new_probability = loaded["model"].predict_proba(new_rows)[:, 1]
new_prediction = (new_probability >= loaded["threshold"]).astype(int)
print(new_prediction)
```

> Load pickle/joblib artifacts only from trusted sources. These formats can execute arbitrary code during loading. They are also sensitive to dependency versions; store environment and data/model metadata with the artifact.

### 7.10 Compact regression example

```python
from sklearn.datasets import fetch_california_housing
from sklearn.ensemble import HistGradientBoostingRegressor
from sklearn.metrics import mean_absolute_error, root_mean_squared_error
from sklearn.model_selection import train_test_split

X, y = fetch_california_housing(return_X_y=True, as_frame=True)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, random_state=42
)

regressor = HistGradientBoostingRegressor(
    learning_rate=0.08,
    max_leaf_nodes=31,
    l2_regularization=1.0,
    random_state=42,
)
regressor.fit(X_train, y_train)
prediction = regressor.predict(X_test)

print("MAE:", mean_absolute_error(y_test, prediction))
print("RMSE:", root_mean_squared_error(y_test, prediction))
print("R2:", regressor.score(X_test, y_test))
```

`fetch_california_housing` may download data on first use. For offline practice, replace it with `load_diabetes`, which is packaged with scikit-learn.

### 7.11 Text classification example

`TfidfVectorizer` is itself a transformer, so raw strings can enter the pipeline directly.

```python
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import cross_val_score
from sklearn.pipeline import make_pipeline

texts = [
    "excellent product and fast delivery",
    "terrible quality and broken item",
    "very useful and easy to use",
    "late delivery and poor support",
    "good value for money",
    "waste of money",
]
labels = [1, 0, 1, 0, 1, 0]

text_model = make_pipeline(
    TfidfVectorizer(ngram_range=(1, 2), min_df=1),
    LogisticRegression(max_iter=2000),
)

# Tiny demonstration only; a real evaluation needs far more independent data.
text_model.fit(texts, labels)
print(text_model.predict(["good quality and fast support"]))
```

---

## 8. Code Explanation

### Data generation

`make_classification` provides controlled signal, redundancy, imbalance, and label noise. pandas columns make the schema explicit. Missing values are inserted **before splitting**, but no values are learned from them until imputers are fitted on training folds.

### Three-way split

The test set is isolated first. The remaining development data is split again so the validation set can select an operating threshold. `stratify` keeps the minority-class proportion approximately stable. In entity-based or temporal data, a group/time-aware split must replace this random split.

### Baseline

`DummyClassifier(strategy="prior")` predicts class probabilities from training priors. Its ROC-AUC is normally 0.5 because it produces the same ranking score for all rows. Other strategies are useful for testing whether the real estimator adds value beyond trivial behavior.

### Numeric preprocessing

`SimpleImputer(strategy="median", add_indicator=True)` learns training medians and adds binary features showing where values were missing. Indicators can capture informative missingness, but missingness may drift or reflect a flawed collection process. `StandardScaler` then puts numeric dimensions on comparable scales for logistic regression.

### Categorical preprocessing

The most frequent training category fills missing values. `OneHotEncoder(handle_unknown="ignore")` creates sparse indicators and avoids failure when a new category appears at inference. An unknown category maps to zeros for that feature's learned categories; this is operationally robust but may not be statistically ideal.

### Composition

`ColumnTransformer` applies numeric and categorical pipelines to named DataFrame columns. The outer `Pipeline` feeds their combined output to the model. During each CV split, all medians, scales, categories, and coefficients or trees are learned only from that split's training rows.

### Multi-metric cross-validation

`cross_validate` can return several validation metrics and training scores. A large training-validation gap suggests variance/overfitting. Uniformly poor training and validation scores suggest underfitting, weak features, noisy labels, or a mismatch between data and objective.

### Search space

`RandomizedSearchCV` explores only 20 sampled settings rather than the complete Cartesian product. A log-uniform distribution is appropriate for `C` because useful regularization scales can span orders of magnitude. Separate dictionaries prevent forest-only parameters from being applied to logistic regression.

`refit="average_precision"` means the configuration with the best mean cross-validated average precision is trained again on all `X_train, y_train`. The validation set is still independent of search and is available for threshold choice.

### Threshold selection

`precision_recall_curve` returns precision/recall arrays with one additional endpoint, so the code aligns them with `thresholds` using `[:-1]`. A tiny epsilon prevents division by zero. The selected threshold and model are both part of the deployed decision system.

### Test evaluation

ROC-AUC uses continuous probabilities and evaluates ranking across thresholds. F1 and the confusion matrix evaluate the chosen operating threshold. The classification report exposes precision, recall, and support by class; macro and weighted averages answer different questions.

### Permutation importance

For each raw feature, the procedure shuffles its test values and measures the average fall in average precision. This can reveal predictive reliance but does not imply causation. Correlated features can substitute for each other, causing both to appear less important.

### Persistence

The entire fitted pipeline, threshold, raw schema, and target definition are saved together. Persisting only the classifier would lose learned imputation, scaling, and encoding. A real artifact should also record library versions, training-data lineage, metric results, code revision, and creation time.

---

## 9. Training / Evaluation

### 9.1 Dataset preparation

Before modeling, establish a data contract:

| Question | Why it matters |
|---|---|
| What does one row represent? | Prevents accidental duplicate/entity leakage |
| When is the prediction made? | Determines which features are legally available |
| How is the target observed? | Exposes censoring, delay, and label noise |
| Are rows independent? | Determines random, group, or temporal splitting |
| Which fields are identifiers? | High-cardinality IDs often enable memorization |
| Are categories stable? | Determines unknown/infrequent-category handling |
| Are missing values meaningful? | Guides imputation and indicators |

Do not use the target or future information while imputing, aggregating, encoding, selecting features, removing outliers, or balancing classes outside the training pipeline.

### 9.2 Split strategy

**IID data:** use a random split and stratify classification labels.

**Grouped data:** all records for one patient, customer, document, or machine must remain in the same fold. Otherwise the model may recognize entity-specific patterns.

**Time-dependent data:** train on the past and validate on the future. Include an operational gap when features or labels have a look-ahead window. Ordinary shuffled CV gives an unrealistically easy estimate.

**Spatial data:** nearby observations can be strongly correlated; geographic holdouts may better measure deployment generalization.

### 9.3 Baselines

Use multiple baselines when appropriate:

- target mean/median or majority/prior baseline;
- simple heuristic already used by the business;
- regularized linear model;
- previous production model.

Report absolute metric values and incremental improvement. A 2% relative gain may or may not be meaningful depending on uncertainty and operational cost.

### 9.4 Choosing metrics

| Situation | Useful primary metrics | Why |
|---|---|---|
| Balanced classification, equal costs | accuracy, macro F1 | easy overall correctness |
| Rare positive detection | average precision, recall at precision, precision at recall | focuses retrieval of positives |
| Ranking | ROC-AUC, average precision, ranking metrics | threshold-independent ordering |
| Decision probabilities | log loss, Brier score, calibration curve | confidence quality matters |
| Symmetric regression with large errors costly | RMSE | squares large residuals |
| Robust regression reporting | MAE, median absolute error | less dominated by outliers |
| Relative error | domain-safe percentage/log metric | scale matters; zero needs care |
| Clustering without truth | silhouette plus stability/domain review | no single internal metric proves usefulness |

For multiclass metrics, explicitly choose `macro`, `micro`, or `weighted` averaging:

- **Macro:** equal weight per class; reveals minority-class weakness.
- **Weighted:** per-class metric weighted by support; can hide rare-class failures.
- **Micro:** pool all decisions; emphasizes frequent instances.

### 9.5 Overfitting and underfitting

| Pattern | Likely diagnosis | Possible response |
|---|---|---|
| High train, much lower validation | overfitting/high variance | regularize, simplify, gather data, fix leakage/split |
| Low train and validation | underfitting/high bias or weak signal | stronger features/model, lower regularization |
| CV good, test bad | selection overfit, distribution shift, split mismatch | audit procedure and test distribution |
| Offline good, production bad | training-serving skew, drift, feedback effects | validate pipeline/schema and monitor slices |
| Mean CV good, fold variance high | small/heterogeneous data or bad splitting | inspect folds/groups, collect data, report uncertainty |

Learning curves plot train and validation performance as training size increases. If both converge poorly, more identical data may not solve high bias. If the gap narrows with more data, additional representative samples can help.

### 9.6 Important hyperparameters

| Model/component | Important hyperparameters | Main effect |
|---|---|---|
| Logistic regression | `C`, `penalty`, `solver`, `class_weight` | regularization and optimization |
| Ridge/Lasso | `alpha` | regularization strength |
| Decision tree | `max_depth`, `min_samples_leaf`, `ccp_alpha` | complexity and variance |
| Random forest | `n_estimators`, `max_features`, depth/leaf controls | averaging, diversity, complexity |
| Gradient boosting | `learning_rate`, iterations, leaves/depth, regularization | additive model capacity |
| RBF SVM | `C`, `gamma` | error penalty and kernel locality |
| k-NN | `n_neighbors`, `weights`, distance metric | smoothness and locality |
| PCA | `n_components`, whitening | retained information/geometry |
| k-means | `n_clusters`, initialization, `n_init` | cluster count and local optimum stability |
| TF-IDF | n-grams, `min_df`, `max_df`, max features | vocabulary and sparsity |

Tune parameters that control meaningful bias, variance, or cost. Do not create an enormous grid merely because parameters exist.

### 9.7 Improving performance systematically

1. Verify labels, schemas, split semantics, and leakage.
2. Compare with a dummy and simple linear baseline.
3. Perform error analysis by class, subgroup, time, and feature range.
4. Improve data coverage and label quality.
5. Add domain-grounded features available at inference.
6. Choose an estimator compatible with dataset size, sparsity, and nonlinearities.
7. Tune a small number of high-impact hyperparameters with valid CV.
8. Calibrate probabilities and tune the threshold if decisions need it.
9. Consider ensembling only if complementary errors justify complexity.
10. Recheck latency, fairness, robustness, and maintainability.

Feature and label improvements often deliver more durable gains than exhaustive hyperparameter search.

### 9.8 Confidence and statistical comparison

Do not overinterpret tiny CV differences. Use identical folds for candidate models, inspect paired fold results, repeat splits when appropriate, and consider bootstrap intervals on an untouched test set. Practical significance should be expressed in domain units such as prevented fraud, false alerts per analyst, or absolute MAE reduction.

---

## 10. Complexity and Cost

Let $n$ be samples, $d$ features after transformation, $T$ trees, $L$ tree leaves, $k$ neighbors, and $I$ optimization iterations. Exact complexity depends on solver, sparsity, number of classes, and implementation, so interview answers should state assumptions.

| Method | Approximate training cost | Approximate inference per sample | Memory/notes |
|---|---:|---:|---|
| Linear/logistic iterative model | roughly $O(Ind)$ | $O(d)$ | stores coefficients; sparse-friendly solvers exist |
| Closed-form linear algebra | often $O(nd^2+d^3)$ when $n\ge d$ | $O(d)$ | solver usually avoids explicit inverse |
| Decision tree | commonly around $O(nd\log n)$ | $O(\text{depth})$ | stores nodes; worst cases differ |
| Random forest | about $T$ times tree cost, parallelizable | $O(T\cdot\text{depth})$ | can be large with deep trees |
| Gradient-boosted trees | sequentially about $T$ times learner cost | $O(T\cdot\text{depth})$ | training less parallel across rounds |
| Exact k-NN | little fitting beyond storage/index | $O(nd)$ brute-force | stores training data; index helps mainly at low dimension |
| Kernel SVM | commonly between quadratic and cubic in $n$ | depends on support vectors | poor fit for very large $n$ |
| PCA via full SVD | roughly $O(\min(nd^2,n^2d))$ | $O(dq)$ for $q$ components | randomized solvers help truncated problems |
| k-means | $O(nkdI)$ | $O(kd)$ | mini-batch variant lowers per-iteration cost |
| Naive Bayes | roughly $O(nd)$ | $O(Kd)$ | fast, sparse-friendly variants |

### Preprocessing cost

- One-hot encoding may expand one raw categorical column into thousands of sparse columns.
- Polynomial features can expand $d$ features to combinatorial size. Degree-2 output is roughly $O(d^2)$.
- Imputation and scaling are usually linear in observed entries.
- Feature selection can reduce downstream time but itself must be fitted within CV.
- Caching pipeline transformers can help when the same expensive transformation is reused across search candidates; caching also adds disk and serialization overhead.

### CPU and GPU requirements

Most scikit-learn estimators are CPU-oriented. A GPU is not normally required and many estimators do not use one. Strong multicore CPUs and sufficient RAM are usually more valuable. Use `n_jobs` where supported, but more workers increase memory consumption and can oversubscribe CPU threads.

### Operational cost

Include preprocessing in latency and memory benchmarks. A small classifier after a massive one-hot/vectorization step is not necessarily a small system. Measure:

- cold-start artifact loading;
- batch versus single-row inference;
- peak memory, not only artifact size;
- unknown-category and missing-value paths;
- serialization and dependency compatibility;
- throughput under real concurrency.

---

## 11. Common Use Cases

### 11.1 Tabular classification

Examples include churn prediction, credit-risk screening, lead conversion, equipment failure, medical triage, content moderation, and fraud detection. Scikit-learn is especially suitable when data fits in memory and inputs are structured numeric/categorical features.

Typical workflow:

```text
DataFrame -> ColumnTransformer -> classifier -> probability
-> calibrated/validated threshold -> business action
```

### 11.2 Tabular regression

Predict prices, demand, delivery duration, energy usage, insurance loss, customer lifetime value, or manufacturing measurements. Linear models provide interpretable baselines; tree ensembles model nonlinearities and interactions.

### 11.3 Text classification and retrieval features

`CountVectorizer`, `TfidfVectorizer`, linear SVMs, logistic regression, and naive Bayes form strong, inexpensive baselines for spam detection, intent classification, ticket routing, sentiment, language identification, and document tagging. Sparse linear models can be surprisingly competitive when labeled data is limited and vocabulary carries strong signal.

### 11.4 Clustering and segmentation

K-means, DBSCAN, HDBSCAN-like alternatives outside core sklearn, agglomerative clustering, spectral clustering, Gaussian mixtures, and clustering evaluation tools support customer segmentation, document grouping, image color quantization, and exploratory analysis. A cluster is useful only if it is stable, interpretable, and actionable; a high internal metric alone is insufficient.

### 11.5 Dimensionality reduction

PCA compresses correlated numeric features, Truncated SVD reduces sparse text matrices, and manifold methods visualize nonlinear structure. Applications include denoising, visualization, speeding downstream estimators, handling collinearity, and constructing compact features.

### 11.6 Anomaly and novelty detection

`IsolationForest`, `LocalOutlierFactor`, `OneClassSVM`, and robust covariance methods flag unusual transactions, sensor behavior, network traffic, or data-quality failures. Distinguish:

- **outlier detection:** training data may contain anomalies;
- **novelty detection:** training data represents normal behavior, and new points are tested for novelty.

Labels are often scarce, contamination rates uncertain, and distributions nonstationary, so threshold and slice evaluation matter more than attractive 2D plots.

### 11.7 Probability calibration

Risk scores used for pricing, prioritization, medical decision support, or expected-value calculations require reliable probabilities. Calibration tools can wrap classifiers using sigmoid or isotonic methods. Always fit calibration on data not used to fit the underlying model, or use a calibration procedure that performs internal cross-validation.

### 11.8 Feature selection and interpretability

Univariate selectors, recursive feature elimination, model-based selectors, sequential selection, permutation importance, partial dependence, and coefficients help reduce cost or understand behavior. Selection must be inside CV. Interpretability claims should account for correlation, preprocessing, regularization, and dataset shift.

### 11.9 Baselines for deep learning

For image embeddings, sentence embeddings, or frozen foundation-model representations, scikit-learn can train linear probes, k-NN classifiers, SVMs, clustering models, and calibration layers. A linear model on frozen embeddings is a valuable baseline before expensive end-to-end fine-tuning.

### 11.10 Batch and service inference

A fitted pipeline can power scheduled batch scoring or a lightweight API. Production infrastructure should add schema validation, artifact/version management, safe loading, observability, access control, rollback, and drift/performance monitoring. Scikit-learn supplies the model object, not the entire production platform.

---

## 12. Common Mistakes

### 12.1 Data leakage

**Mistake:** scaling, imputing, selecting features, oversampling, or learning categories on the full dataset before CV.

```python
# Wrong: the scaler sees validation-fold statistics.
X_scaled = StandardScaler().fit_transform(X)
scores = cross_val_score(LogisticRegression(), X_scaled, y, cv=5)

# Correct: each fold fits its own scaler.
model = make_pipeline(StandardScaler(), LogisticRegression())
scores = cross_val_score(model, X, y, cv=5)
```

Leakage also occurs through post-outcome features, future aggregates, duplicate entities across folds, preprocessing decisions based on the test set, and target-derived encodings calculated outside a fold-safe procedure.

### 12.2 Using `fit_transform` on the test set

```python
# Wrong
X_test_scaled = scaler.fit_transform(X_test)

# Correct
X_test_scaled = scaler.transform(X_test)
```

The test set must use the state learned from training. Refitting changes the coordinate system and leaks test distribution information.

### 12.3 Wrong metric for imbalance

A classifier predicting "not fraud" for every transaction may achieve 99.8% accuracy when fraud prevalence is 0.2%, while catching no fraud. Use a metric tied to the decision: recall at an acceptable false-alert rate, precision at review capacity, average precision, expected monetary value, or calibrated loss.

### 12.4 Selecting on the test set

Repeatedly comparing models, thresholds, features, or seeds on the test set turns it into a validation set. The reported score becomes optimistically biased. Reserve a new holdout or use nested CV if selection has already consumed the test set.

### 12.5 Ignoring groups or time

Random splitting records from the same customer across train and test measures memorization, not new-customer generalization. Random splitting time series lets the past model learn from the future. Choose the splitter from deployment semantics.

### 12.6 Encoding nominal categories as arbitrary integers

Mapping `{red: 0, blue: 1, green: 2}` implies ordering and spacing that do not exist. A tree may split `color <= 1.5`, and a linear model treats green as twice blue. Use one-hot or an encoding justified by the feature's semantics.

### 12.7 Failing on unseen categories

An encoder fitted on training categories may see a new country or device type in production. Define unknown handling, group rare categories when appropriate, log category drift, and test the behavior explicitly.

### 12.8 Scaling everything mechanically

Scaling is useful for distance-, margin-, variance-, and gradient-based models. It is usually irrelevant for tree splits. Scaling one-hot indicators is sometimes unnecessary and may densify or distort sparse workflows depending on the transformer. Preprocessing should match the estimator and data representation.

### 12.9 Sparse-to-dense explosions

Applying an incompatible transformer to a high-dimensional sparse matrix can create a dense matrix too large for RAM. Check `sparse_output`, transformer compatibility, output shape, and memory on realistic data.

### 12.10 Misreading `score`

`model.score` is estimator-specific. It is usually accuracy for classifiers and $R^2$ for regressors, not necessarily the metric desired by the project. State `scoring=` explicitly in CV/search and call named metric functions for final reports.

### 12.11 Misunderstanding negative loss scorers

`neg_mean_squared_error=-4` corresponds to MSE $4$, not $-4$. The sign exists because model-selection APIs maximize. Negate it before communicating the loss.

### 12.12 Assuming `predict_proba` is calibrated

A number between zero and one is not automatically a reliable probability. Ranking can be excellent while calibration is poor. Evaluate reliability curves, Brier score, and log loss; calibrate with a validation-safe method when probabilities drive costs.

### 12.13 Treating 0.5 as the optimal threshold

The optimal threshold depends on class priors, probability calibration, action costs, and capacity. Select it using validation data and retain it as a versioned part of the model artifact.

### 12.14 Confusing `class_weight` with resampling

Weights change contributions to the loss; over/undersampling changes the training distribution and sometimes neighborhood structure. Neither automatically improves probability calibration. Any resampling must occur within training folds, commonly through a compatible imbalanced-learning pipeline.

### 12.15 Oversubscribing parallel workers

Running an `n_jobs=-1` search around an `n_jobs=-1` forest can multiply processes/threads, increase memory, and slow training. Parallelize at one useful level and benchmark.

### 12.16 Ignoring convergence warnings

Increasing `max_iter` can help, but first inspect scaling, extreme values, solver/penalty compatibility, conditioning, duplicated features, and regularization. A warning may indicate a model that has not reached the intended optimum.

### 12.17 Comparing CV scores from different folds

Candidate A evaluated on one random partition and B on another cannot be cleanly paired. Reuse the same splitter/folds for fair comparison. Small differences below split variability are not convincing.

### 12.18 Reading impurity importance as truth

Tree impurity importance can favor continuous or high-cardinality features and may overstate training-specific patterns. Permutation importance on held-out data is often more informative, but correlated features still complicate attribution.

### 12.19 Assuming feature importance means causality

Predictive association does not establish an intervention effect. Confounding, proxies, selection bias, and feedback loops remain. Do not make causal or policy claims solely from model explanations.

### 12.20 Saving only the estimator

If preprocessing was performed manually, production may use different medians, column order, or categories. Persist the entire fitted pipeline and validate its expected raw schema.

### 12.21 Loading untrusted artifacts

Pickle-derived formats such as joblib can execute code on load. Never load artifacts from untrusted sources. Use access controls, integrity checks, trusted registries, and isolated build/deployment processes.

### 12.22 Assuming serialized models are version-independent

Artifacts are not guaranteed to load correctly under arbitrary future scikit-learn, NumPy, SciPy, or Python versions. Pin the environment and retain the training code/data lineage so a model can be rebuilt.

### 12.23 Hyperparameter grids without understanding

Searching every parameter wastes compute and increases selection overfitting. Search important parameters on sensible scales—often logarithmic for regularization or learning rates—and inspect whether boundaries indicate the range should expand.

### 12.24 Preprocessing pandas data by column position

Column order can change between training and inference. Prefer named columns with a validated DataFrame schema. Reject missing, duplicated, or unexpected critical fields deliberately.

### 12.25 Applying supervised feature selection before splitting

Selecting features using all labels leaks validation outcomes, even if the final model never sees those rows. Put the selector in the pipeline so it refits within every fold.

### 12.26 Reporting only one aggregate score

Overall performance can hide subgroup failures, temporal degradation, or operational overload. Report class/slice metrics, confusion matrices or residual plots, variability, calibration, and latency as the use case requires.

---

## 13. Edge Cases / Limitations

### 13.1 Data larger than memory

Many estimators assume in-memory arrays. Some support incremental `partial_fit`, mini-batches, memory mapping, or sparse inputs, but the library is not generally a distributed training system. For very large workloads, consider sampling, feature aggregation, out-of-core-capable estimators, distributed frameworks, or specialized libraries.

### 13.2 Very high-dimensional data

Text and genomics may have $d \gg n$. Sparse linear models, naive Bayes, feature hashing, univariate selection, or Truncated SVD can work. Dense polynomial expansion, kernel matrices, and ordinary covariance estimates may become infeasible or ill-conditioned.

### 13.3 High-cardinality categorical variables

One-hot encoding user IDs or millions of product codes explodes dimension and encourages memorization. Consider removing identifiers, grouping rare categories, hashing, carefully cross-fitted target encoding, learned embeddings outside sklearn, or models with native categorical handling. Every alternative has collision, leakage, interpretability, or complexity trade-offs.

### 13.4 Missing-not-at-random data

Median imputation assumes little about why values are missing and can blur useful patterns. An indicator can expose missingness, but if missingness is caused by policy, access, or an unobserved outcome, model behavior can be biased. This is a data-generating-process problem, not merely an imputer choice.

### 13.5 Distribution shift

Cross-validation estimates future performance only when validation resembles deployment. Covariate shift, concept drift, label-policy change, sensor replacement, seasonality, and strategic user adaptation can invalidate estimates. Use realistic temporal/geographic/domain holdouts and production monitoring.

### 13.6 Rare classes

With only a handful of positive examples, stratification cannot create informative positives in every fold. Metrics become unstable, probability calibration is difficult, and complex models can memorize. Gather labels, use domain-aware grouping, report uncertainty, and avoid claiming performance from tiny support.

### 13.7 Multi-label and multi-output targets

Some estimators support them directly; others require `OneVsRestClassifier`, `MultiOutputClassifier`, `ClassifierChain`, `MultiOutputRegressor`, or specialized methods. Metrics must match the target structure—subset accuracy can be excessively strict for multi-label tasks.

### 13.8 Non-IID dependence

Standard CV assumes a sampling structure that may fail for networks, households, repeated measures, spatial autocorrelation, and experiments. A custom splitter may be necessary. No choice of estimator repairs a fundamentally invalid evaluation design.

### 13.9 Extrapolation

Tree models generally predict from values represented in training leaves and extrapolate poorly beyond the training domain. Linear models extrapolate linearly but may be physically wrong. Test behavior at boundaries and encode domain constraints where needed.

### 13.10 Probability extremes

Separable data or flexible models can produce probabilities very close to 0 or 1. Under shift, confident mistakes yield large log loss and dangerous decisions. Use regularization, calibration, robust validation, and decision safeguards.

### 13.11 k-NN and distance concentration

In high dimension, distances can become similarly large, neighborhoods lose locality, and irrelevant features dominate. Scaling, selection, metric learning, dimensionality reduction, or a different model may be necessary.

### 13.12 PCA limitations

PCA is linear, scale-sensitive, variance-focused, and affected by outliers. Low-variance directions can still predict $y$, so unsupervised compression may reduce supervised accuracy. Components can be hard to explain to stakeholders.

### 13.13 K-means limitations

K-means expects Euclidean means to be meaningful, struggles with non-spherical or unequal-density clusters, is sensitive to scale/outliers, requires $K$, and can converge to local minima. It is inappropriate for arbitrary categorical data without a suitable representation.

### 13.14 Neural-network limitations

Scikit-learn's `MLPClassifier` and `MLPRegressor` are useful for small classical problems but do not provide the flexibility, GPU ecosystem, automatic differentiation workflows, or modern architecture tooling of PyTorch/JAX/TensorFlow.

### 13.15 Statistical inference limitations

Scikit-learn prioritizes prediction and model selection. It generally does not emphasize coefficient standard errors, hypothesis tests, likelihood tables, and rich residual diagnostics. Use a statistical-inference library when these are primary requirements.

### 13.16 Fairness and causal limitations

The library does not make a model fair, causal, private, or safe by default. Proxy variables, representation imbalance, historical bias, and feedback loops require domain-specific audits, governance, and sometimes dedicated toolkits.

### 13.17 Training-serving skew

A notebook pipeline does not guarantee production schema consistency. Differences in timezone handling, category spelling, default values, numeric units, text normalization, or feature availability can silently break predictions. Use shared transformation artifacts, schemas, contract tests, and monitoring.

---

## 14. Variations

### 14.1 `Pipeline` versus `make_pipeline`

- `Pipeline` uses explicit step names, improving readable parameter paths.
- `make_pipeline` automatically names steps from class names and is concise.
- Both provide the same composition idea.

**Use:** `make_pipeline` for short experiments; explicit names for reusable projects and interview demonstrations. **Placement importance:** high.

### 14.2 `ColumnTransformer` and `make_column_transformer`

The explicit form gives chosen names; the helper generates names. Column selectors can choose columns by name, dtype, pattern, or callable. Prefer stable schema-driven selection and validate it.

**Use:** mixed tabular data. **Placement/project importance:** very high.

### 14.3 Grid, random, and successive-halving search

| Search | What changes | When to use | Caveat |
|---|---|---|---|
| `GridSearchCV` | evaluates every listed combination | small, informed discrete grid | grows combinatorially |
| `RandomizedSearchCV` | samples a budgeted number | broad/continuous spaces | may miss narrow optimum |
| halving search | allocates more resources to promising candidates | expensive models with meaningful resource parameter | experimental API may need enabling; early ranking can be noisy |

For research-grade optimization, Bayesian optimization libraries outside core sklearn may use previous results to select candidates, but they add dependencies and do not fix invalid validation.

### 14.4 Ordinary versus nested cross-validation

Ordinary CV used during search estimates candidate performance and selects hyperparameters on the same folds. Nested CV adds an outer evaluation loop; each outer training split performs its own inner search. It estimates the full selection procedure with less optimistic bias but is computationally expensive.

**Use:** small datasets and high-stakes model comparison. **Research importance:** high; **routine production:** depends on cost and final holdout availability.

### 14.5 Batch versus incremental learning

Most estimators implement `fit` on a complete dataset. Some estimators such as `SGDClassifier`, `SGDRegressor`, `MiniBatchKMeans`, and several naive Bayes models support `partial_fit`.

Incremental learning requires careful handling of:

- consistent class lists on initial classification calls;
- online-compatible scaling, often `StandardScaler.partial_fit`;
- changing distributions and forgetting policies;
- shuffled batches and convergence schedules;
- checkpointing and evaluation on future data.

**Use:** data arriving in batches or exceeding memory. **Interview importance:** medium.

### 14.6 One-vs-rest, one-vs-one, and multinomial classification

- **One-vs-rest (OvR):** train one binary classifier per class.
- **One-vs-one (OvO):** train one classifier per class pair; common in SVM workflows.
- **Multinomial/softmax:** optimize all class probabilities jointly where supported.

Meta-estimators can add multiclass support to binary learners. Complexity, probability interpretation, and decision functions differ.

### 14.7 Bagging, random forests, extra trees, and boosting

- **Bagging:** average models trained on resampled data; mainly reduces variance.
- **Random forest:** bagged trees plus random feature subsets at splits.
- **Extra Trees:** adds more randomization to split construction, often reducing variance and training cost at possible bias cost.
- **Gradient boosting:** sequentially corrects current errors/gradients; often lower bias but more tuning-sensitive.
- **Histogram gradient boosting:** bins features for efficient tree boosting and can be strong on larger tabular datasets.

**Placement importance:** very high. Be able to compare parallel bagging with sequential boosting.

### 14.8 Feature selection methods

| Type | Examples | Key property |
|---|---|---|
| Filter | `SelectKBest`, variance threshold | evaluates features independently of final estimator |
| Wrapper | RFE, sequential selection | repeatedly trains a model; expensive |
| Embedded | Lasso, tree/model-based selection | selection occurs during fitting |

All supervised selection belongs inside CV. Stability across folds is often more informative than one selected list.

### 14.9 Calibration methods

- **Sigmoid/Platt-like calibration:** fits a logistic mapping; data-efficient and smooth.
- **Isotonic calibration:** flexible monotonic mapping; can overfit with limited calibration data.

Use calibration when probability values, not only rank, drive decisions. Evaluate calibration on independent data. **Project importance:** high in risk systems.

### 14.10 Transformation of the target

`TransformedTargetRegressor` applies a function to $y$ during training and reverses it at prediction. A log transform can make a positive, skewed target easier to model:

$$
z=\log(1+y), \qquad \hat y=\exp(\hat z)-1.
$$

Evaluate predictions in the original business units and consider retransformation bias. **Placement importance:** medium.

### 14.11 Feature unions

`FeatureUnion` runs several transformers on the same input and concatenates outputs. A text system might combine word TF-IDF and character TF-IDF. `ColumnTransformer` selects different input columns; `FeatureUnion` applies parallel representations to the same input.

### 14.12 Custom scoring

`make_scorer` adapts a metric for CV/search:

```python
from sklearn.metrics import make_scorer

def profit(y_true, y_pred):
    # Example only: encode domain-reviewed values in a real project.
    tp = ((y_true == 1) & (y_pred == 1)).sum()
    fp = ((y_true == 0) & (y_pred == 1)).sum()
    return 100 * tp - 10 * fp

profit_scorer = make_scorer(profit, greater_is_better=True)
```

A threshold-dependent custom score inside CV uses the estimator's default prediction rule unless a suitable response method or threshold-aware estimator is configured. Separate ranking/model selection from operating-threshold selection when appropriate.

### 14.13 Native missing-value handling

Some estimators can handle missing values directly, while many require imputation. Native handling may model missingness through splits rather than substituting a statistic. Compatibility is estimator-specific, so verify documentation and behavior for the exact version.

### 14.14 Model persistence choices

- **joblib/pickle:** convenient and preserves Python objects; trusted input only and version-sensitive.
- **cloudpickle:** can serialize more Python constructs but has similar trust/version concerns.
- **skops:** designed to make model persistence more inspectable and safer than arbitrary pickle loading, with compatibility constraints.
- **ONNX:** language/runtime-neutral inference for supported model graphs; conversion support and numerical parity must be tested.

**MLOps importance:** high. Persistence format is an operational decision, not a measure of predictive quality.

### 14.15 Configuration and outputs

Scikit-learn can be configured globally or in a context for display and, where supported, transformer output containers. These features improve notebook readability and feature lineage. Avoid relying on a hidden global setting in production code; make behavior explicit and test it.

---

## 15. Related Topics

### 15.1 Scikit-learn versus PyTorch

| Scikit-learn | PyTorch |
|---|---|
| classical ML and standardized workflows | deep learning and differentiable programming |
| high-level `fit/predict` API | explicit tensors, modules, losses, optimizers, loops |
| mainly CPU, some parallelism | mature GPU/accelerator ecosystem |
| strong preprocessing/CV/search tooling | flexible architectures and automatic differentiation |
| ideal for tabular baselines | ideal for CNNs, Transformers, custom neural models |

They complement each other: generate embeddings in PyTorch, then evaluate a linear probe or classical classifier in scikit-learn.

### 15.2 Scikit-learn versus statsmodels

Scikit-learn focuses on predictive pipelines, out-of-sample evaluation, and estimator interchangeability. Statsmodels emphasizes statistical inference, coefficient tables, tests, confidence intervals, and model diagnostics. Use the tool matching the question: prediction or inference.

### 15.3 Scikit-learn versus XGBoost/LightGBM/CatBoost

Scikit-learn contains strong tree ensembles and histogram gradient boosting. Specialized boosting libraries may offer additional performance, GPU/distributed features, categorical handling, or ecosystem-specific tooling. They often provide sklearn-compatible estimators, allowing use inside pipelines and searches. Benchmark fairly under the same splits, metrics, and resource budget.

### 15.4 `Pipeline` versus manual preprocessing

Manual preprocessing is easy to mismatch across folds and inference. A pipeline owns learned state and makes the entire workflow cloneable. Manual code is justified only when the transformation cannot reasonably follow the estimator protocol or happens upstream under a separately versioned data contract.

### 15.5 `Pipeline` versus `ColumnTransformer`

`Pipeline` is sequential: output of one step enters the next. `ColumnTransformer` is parallel by columns: different column subsets receive different transformations, then outputs are concatenated. In tabular ML, a `ColumnTransformer` commonly sits inside a `Pipeline`.

### 15.6 Logistic regression versus SVM

- Logistic regression optimizes log loss and naturally models probabilities.
- Linear SVM optimizes a margin/hinge objective and often provides a decision score.
- Both are linear in input features and benefit from scaling/regularization.
- Kernel SVM adds nonlinear boundaries but can scale poorly in sample count.
- SVM probabilities, when requested, require additional calibration-like work and cost.

### 15.7 Random forest versus gradient boosting

- Random forest builds trees largely independently and averages them, reducing variance.
- Gradient boosting builds trees sequentially to reduce current loss, often achieving stronger accuracy with more tuning sensitivity.
- Forests parallelize naturally and are robust defaults.
- Boosting trades learning rate against number/complexity of trees.

### 15.8 PCA versus feature selection

PCA creates new orthogonal combinations and can retain distributed variance but reduces direct interpretability. Feature selection retains original columns and can lower collection/inference cost. PCA is unsupervised unless used within a supervised pipeline; supervised selection uses $y$ and must be fold-safe.

### 15.9 Cross-validation versus bootstrap

Cross-validation repeatedly holds out partitions for validation and is central to model selection. Bootstrap resamples observations with replacement and is widely used for uncertainty estimation and bagging. Dependence, groups, and time require specialized resampling in either case.

### 15.10 Calibration versus discrimination

Discrimination asks whether positives rank above negatives; ROC-AUC measures this. Calibration asks whether events predicted at probability 0.8 occur about 80% of the time. A monotonic recalibration can improve calibration without changing ranking/AUC much.

### 15.11 Feature engineering versus representation learning

Classical sklearn workflows often depend on human-designed features and fixed transformations. Deep learning learns representations jointly with prediction. For modest tabular data, engineered variables and tree/linear models can outperform or simplify neural solutions.

### 15.12 Scikit-learn and MLOps

Scikit-learn handles training objects, not full lifecycle governance. An MLOps system wraps it with data/version tracking, reproducible environments, experiment tracking, registries, CI checks, deployment, monitoring, lineage, rollback, and approval workflows.

### 15.13 Scikit-learn and imbalanced learning

Core tools provide class/sample weights and metrics. Specialized imbalanced-learning packages add resampling algorithms and pipeline integration. Resampling belongs only in the training portion of each fold; applying it before splitting contaminates evaluation.

### 15.14 Scikit-learn and explainability libraries

Built-in inspection covers permutation importance and partial dependence. External libraries may add local or game-theoretic explanations. Explanations must operate on the correct transformed representation, be tested for stability, and never be presented as causal evidence by default.

---

## 16. Interview Questions

### 1. What is scikit-learn?

**Answer:** It is a Python machine-learning library focused on classical supervised and unsupervised learning, preprocessing, model selection, evaluation, and estimator composition. Its defining design is a consistent estimator API—`fit`, `transform`, `predict`, and parameter inspection—that lets pipelines, cross-validation, and search work across many algorithms.

### 2. What is the difference between an estimator and a transformer?

**Answer:** An estimator learns state through `fit`. A transformer is an estimator that additionally maps data through `transform`. `StandardScaler` learns means/scales and transforms features. A classifier is also an estimator, but exposes `predict` rather than necessarily exposing `transform`.

### 3. What does the trailing underscore in `coef_` or `mean_` mean?

**Answer:** It indicates an attribute learned during `fit`, unlike constructor hyperparameters such as `C` or `max_depth`. These attributes usually do not exist before fitting.

### 4. Why should preprocessing be inside a pipeline?

**Answer:** Cross-validation clones the full pipeline and fits preprocessing only on each training fold. This prevents validation statistics, categories, selected features, or imputations from leaking into training. It also guarantees that deployment applies the same learned transformations in the same order.

### 5. What is the difference between `fit`, `transform`, `fit_transform`, and `predict`?

**Answer:** `fit` learns state. `transform` applies a learned feature mapping. `fit_transform` learns and applies it to the same input, sometimes with an optimized implementation. `predict` applies a fitted predictive estimator to output labels or numeric targets. On validation/test data, call `transform`, never `fit_transform`.

### 6. How does `GridSearchCV` work?

**Answer:** It enumerates every specified parameter combination. For each combination and fold, it clones the estimator, fits on fold training data, scores on fold validation data, and aggregates scores. With default refitting behavior, it then trains the best parameter configuration on all data passed to `fit`. It does not protect against a bad splitter or leakage outside the estimator.

### 7. Grid search or randomized search?

**Answer:** Grid search is reasonable for a small, informed discrete grid. Randomized search is generally more compute-efficient for large spaces because it evaluates a fixed number of configurations and explores more distinct values per important dimension. Use suitable distributions, often log-uniform for parameters spanning orders of magnitude.

### 8. Why are some sklearn scoring names prefixed with `neg_`?

**Answer:** Model-selection APIs maximize scores. Losses such as MAE or MSE should be minimized, so sklearn returns their negative. Convert back to the positive loss when reporting.

### 9. What is data leakage? Give sklearn examples.

**Answer:** Leakage occurs when training uses information unavailable at prediction time or information from validation/test outcomes. Examples include scaling before CV, supervised feature selection on all labels, target encoding outside folds, oversampling before splitting, imputing from all data, and placing the same customer's rows across train and test.

### 10. Why set `random_state`?

**Answer:** It makes pseudorandom splits, initialization, sampling, or feature selection repeatable enough for debugging and fair comparisons. It does not guarantee identical output across every package version, platform, or parallel numerical execution.

### 11. When is scaling required?

**Answer:** It is important when the objective depends on distances, dot products, variances, coefficient penalties, margins, or gradient conditioning—for example k-NN, k-means, PCA, SVM, and regularized linear/logistic models. It is usually unnecessary for ordinary decision trees and tree ensembles because monotonic scaling preserves candidate split ordering.

### 12. How do you handle numeric and categorical columns differently?

**Answer:** Create one pipeline for numeric columns and another for categorical columns, combine them with `ColumnTransformer`, then place that transformer before the estimator in an outer `Pipeline`. Use column names and a validated schema.

### 13. What happens to an unseen category with `OneHotEncoder(handle_unknown="ignore")`?

**Answer:** The encoder does not raise an error; for that feature, an unseen category is represented without any known-category indicator active, usually all zeros for that block. This is operationally safe but loses distinctions between different unseen values, so drift should be monitored.

### 14. What is `class_weight="balanced"`?

**Answer:** It assigns larger loss weights to less frequent classes, commonly proportional to $n/(K n_c)$. It changes the fitting objective and can improve minority recall, but it does not generate new information, guarantee a better metric, or automatically preserve probability calibration.

### 15. `predict`, `predict_proba`, and `decision_function`—what is the difference?

**Answer:** `predict` returns the estimator's hard decision. `predict_proba` returns estimated class probabilities when implemented. `decision_function` returns an uncalibrated signed/multiclass score related to the decision boundary. Ranking metrics can often use either probabilities or decision scores; expected-value decisions require calibrated probabilities.

### 16. Why is accuracy poor for imbalanced classification?

**Answer:** The majority class dominates the count. A model can achieve high accuracy while missing every rare positive. Use metrics tied to the task, such as recall, precision, F-beta, average precision, balanced accuracy, or cost at a selected threshold.

### 17. ROC-AUC versus PR-AUC?

**Answer:** ROC-AUC measures the probability that a randomly chosen positive ranks above a randomly chosen negative and uses TPR/FPR. Under severe imbalance, FPR can look small despite many false positives; the precision-recall curve directly reflects positive purity and coverage. Average precision is often more informative for rare-positive retrieval, though metric choice remains task-dependent.

### 18. Why can test $R^2$ be negative?

**Answer:** $R^2=1-SSE/SST$. If predictions have larger squared error than predicting the test target mean, $SSE>SST$ and $R^2<0$. It is not bounded below.

### 19. What is nested cross-validation?

**Answer:** An outer CV loop estimates generalization, while each outer training fold runs an independent inner hyperparameter search. It evaluates the complete model-selection procedure and reduces selection optimism, at a high compute cost.

### 20. How do you avoid group leakage?

**Answer:** Provide entity IDs to a group-aware splitter so all rows from one entity appear in only one fold. If class balance also matters, use an appropriate stratified-group method. Do not use group IDs as predictive features unless deployment semantics justify it.

### 21. How should time-series data be validated?

**Answer:** Train on earlier periods and validate on later periods using expanding or rolling windows. Preserve feature/label availability and add a gap when look-ahead or delayed labels could leak. Random shuffled CV is generally invalid for forecasting-like deployment.

### 22. What is the difference between a parameter and a hyperparameter?

**Answer:** Model parameters are learned from training data, such as coefficients and tree splits. Hyperparameters configure the learning procedure before fitting, such as `C`, `alpha`, `max_depth`, and `n_estimators`. In sklearn, hyperparameters are constructor arguments and appear in `get_params`.

### 23. How do nested pipeline parameter names work?

**Answer:** Step names are joined with double underscores. For a `model` step, use `model__C`. For an imputer under a numeric transformer under preprocessing, use `preprocess__numeric__imputer__strategy`. `get_params(deep=True)` shows available paths.

### 24. What does `clone` do?

**Answer:** It creates a new unfitted estimator with the same constructor parameters. It does not copy learned fitted state. This is essential for independent CV folds and parameter candidates.

### 25. How do you detect overfitting from CV results?

**Answer:** Compare train and validation metrics across folds. Very strong train scores with weaker validation scores indicate high variance. Also inspect fold variability and learning curves. A gap is evidence, not a complete diagnosis—leakage, split mismatch, and distribution heterogeneity must also be checked.

### 26. What is permutation importance?

**Answer:** Measure a baseline validation score, shuffle one feature, and measure score degradation. Repeat to estimate variability. It is model-agnostic and should be calculated on held-out data, but correlated features can substitute for each other and hide importance.

### 27. How should a custom transformer be written?

**Answer:** Put only hyperparameters in `__init__`, perform data-dependent learning in `fit`, store learned state in trailing-underscore attributes, return `self`, and apply the mapping in `transform`. Validate inputs and fitted state, avoid mutating caller data, and support feature-name/sparse behavior if claimed.

### 28. Why might a logistic-regression solver fail to converge?

**Answer:** Poor scaling, strong collinearity, extreme values, weak regularization, incompatible solver/penalty choices, too few iterations, or a difficult/high-dimensional optimization problem. Diagnose these first, then adjust scaling, regularization, solver, tolerance, or iteration limit.

### 29. Why can parallel training become slower with `n_jobs=-1`?

**Answer:** Nested parallelism can oversubscribe CPU threads, multiple workers can duplicate large datasets in memory, scheduling and serialization add overhead, and memory bandwidth becomes the bottleneck. Benchmark and parallelize one level at a time.

### 30. How do you deploy a scikit-learn model safely?

**Answer:** Persist the complete validated pipeline and decision threshold; record dependency versions, code revision, schema, and training metadata; load only trusted artifacts; enforce input contracts; test numerical parity; benchmark latency; version artifacts; monitor drift, errors, calibration, slices, and delayed outcomes; retain rollback/retraining capability.

### 31. What is the difference between feature selection and PCA?

**Answer:** Feature selection keeps a subset of original variables, preserving their semantics. PCA constructs orthogonal linear combinations that maximize variance, often improving compression or conditioning but reducing direct interpretability. PCA is unsupervised and can discard low-variance predictive signal.

### 32. Why is target encoding risky?

**Answer:** Category statistics calculated using the same row's target or validation targets directly leak label information, especially for rare categories. It needs cross-fitting/out-of-fold computation, smoothing, unknown handling, and inclusion inside the validation procedure.

### 33. Can sklearn use GPUs?

**Answer:** The standard library is primarily CPU-oriented; most estimators do not use a GPU. Some surrounding libraries or compatible array/dispatch ecosystems may provide acceleration for particular workflows, but GPU support should be verified for the exact estimator and version. For custom deep learning, use a framework designed for accelerators.

### 34. When would you use `partial_fit`?

**Answer:** For streaming or out-of-core mini-batch learning with estimators that explicitly support it. Keep preprocessing online-compatible, initialize the full class list where required, manage learning-rate/order effects, and evaluate against future data to detect drift.

### 35. What would you check if CV is excellent but production performance is poor?

**Answer:** Split realism, duplicate/group/time leakage, feature availability at serving time, schema/unit/category mismatch, label definition differences, population drift, feedback loops, threshold mismatch, probability calibration, delayed labels, and differences between batch and online preprocessing.

---

## 17. Practice Tasks

### Task 1: Small coding task—mixed-data pipeline

Create a DataFrame with three numeric columns, two categorical columns, missing values, and a binary target. Build:

1. numeric median imputation and scaling;
2. categorical most-frequent imputation and one-hot encoding;
3. a logistic-regression estimator;
4. five-fold stratified CV with ROC-AUC and F1;
5. a final confusion matrix on an untouched test set.

**Success criterion:** no learned preprocessing occurs before the pipeline or outside CV.

### Task 2: Dataset-based project—breast cancer classification

Use `load_breast_cancer`.

- Compare `DummyClassifier`, logistic regression, RBF SVM, random forest, and histogram gradient boosting.
- Use the same repeated or stratified folds.
- Tune only two to four meaningful parameters per model.
- Compare ROC-AUC, recall, average precision, and calibration.
- Select a threshold that achieves a required recall, then report precision.
- Explain why medical claims require domain validation beyond the dataset.

### Task 3: Regression experiment—bias and variance

Use `load_diabetes` or a synthetic nonlinear dataset.

- Compare linear regression, ridge, polynomial ridge, decision tree, and random forest.
- Plot train and validation learning curves.
- Vary polynomial degree or tree depth.
- Explain where underfitting becomes overfitting.
- Report MAE, RMSE, and $R^2$ in original units.

### Task 4: Debugging task—find leakage

Given this code, identify and repair every evaluation flaw:

```python
X = df.drop(columns="target")
y = df["target"]

X = pd.get_dummies(X)
X = SimpleImputer().fit_transform(X)
X = StandardScaler().fit_transform(X)
X_train, X_test, y_train, y_test = train_test_split(X, y)

selector = SelectKBest(k=20).fit(X, y)
X_train = selector.transform(X_train)
X_test = selector.transform(X_test)

model = LogisticRegression().fit(X_train, y_train)
print(model.score(X_test, y_test))
```

**Expected findings:** preprocessing and supervised selection see all data, there is no stratification/group/time reasoning, only default accuracy is reported, and feature schema/unknown-category handling are fragile. Rebuild it as a pipeline.

### Task 5: Custom transformer

Implement `PercentileClipper` with input validation and `get_feature_names_out`. Place it inside a numeric pipeline and verify that bounds are learned separately in each CV fold. Compare it with `RobustScaler` on data containing outliers.

### Task 6: Text classification

Use a public sentiment or spam dataset.

- Compare word and character TF-IDF.
- Tune `ngram_range`, `min_df`, regularization, and class weights.
- Keep text vectorization inside the pipeline.
- Examine top positive and negative linear coefficients.
- Create adversarial examples with spelling errors or unseen vocabulary.

### Task 7: Clustering analysis

On customer-like numeric data:

- scale features;
- compare k-means, agglomerative clustering, and DBSCAN;
- examine silhouette scores and stability across samples/seeds;
- map clusters back to original business variables;
- explain whether each segment enables a distinct action.

### Task 8: Threshold and cost experiment

For an imbalanced classifier, define:

- profit per true positive;
- cost per false positive;
- cost per false negative;
- daily review capacity.

Plot expected validation value over thresholds. Compare the best-business threshold with 0.5 and the best-F1 threshold. Evaluate the frozen choice once on test data.

### Task 9: Nested-CV experiment

Compare ordinary CV search estimates with nested-CV estimates on a small dataset. Repeat the procedure over seeds. Explain selection optimism and the compute multiplier.

### Task 10: Serialization and parity

Train and save a full pipeline. In a new Python process:

- load the trusted artifact;
- validate raw column names and dtypes;
- score a fixed golden batch;
- assert predictions match expected values within tolerance;
- intentionally add an unseen category and a missing value;
- record environment versions.

### Task 11: Extension idea—model card

Create a concise model card containing target and intended use, exclusions, training/validation periods, split logic, features, metrics with uncertainty, subgroup results, threshold rationale, limitations, artifact versions, and monitoring plan.

### Task 12: Failure-analysis notebook

For any classifier, build a table containing raw inputs, true label, probability, prediction, error type, and relevant subgroup/time fields. Study the highest-confidence errors and propose data or labeling improvements before changing the algorithm.

---

## 18. Project Ideas

### Project 1: Customer Churn Decision System

**What it does:** Predicts churn probability, ranks at-risk customers, and chooses a contact threshold under a fixed retention-team capacity. Includes calibration, subgroup analysis, and batch scoring.

**Tech stack:** pandas, scikit-learn `ColumnTransformer`/`Pipeline`, logistic regression and histogram gradient boosting, joblib or a safer compatible persistence choice, FastAPI for an optional service, Docker, and an experiment/model registry if desired.

**Dataset suggestion:** IBM Telco Customer Churn or a synthetic temporal customer dataset. If using a static public dataset, be explicit that it cannot validate real temporal drift.

**Implementation milestones:**

1. define churn horizon and prediction time;
2. build group/time-aware split if identifiers/timestamps exist;
3. compare dummy, linear, and boosted baselines;
4. optimize average precision or expected retention value;
5. calibrate probabilities;
6. select a threshold under outreach capacity;
7. report segment performance and drift checks;
8. package the complete pipeline and a golden-batch test.

**Resume value:** Demonstrates mixed-data pipelines, imbalance, thresholding, calibration, business-metric translation, explainability limits, and deployment discipline. A strong resume bullet reports a validated result and operational constraint, not only "built a churn model."

### Project 2: Support Ticket Router with Sparse NLP

**What it does:** Classifies incoming support tickets into teams and estimates confidence. Low-confidence cases are routed to human triage. Combines word and character TF-IDF features to handle product terms and spelling variation.

**Tech stack:** scikit-learn `TfidfVectorizer`, `FeatureUnion`, logistic regression or linear SVM, calibration, pandas, FastAPI or batch inference, and monitoring for vocabulary/category drift.

**Dataset suggestion:** Consumer complaint narratives, a helpdesk ticket dataset, or a carefully generated labeled corpus. Remove direct routing labels embedded in signatures/templates to avoid leakage.

**Implementation milestones:**

1. deduplicate near-identical tickets before splitting;
2. use time-based or source-aware validation;
3. compare word, character, and combined features;
4. report macro F1 and per-team recall;
5. calibrate/validate an abstention threshold;
6. inspect confusion pairs and top coefficients;
7. test empty text, very long text, new product names, and misspellings.

**Resume value:** Shows sparse ML, multiclass evaluation, confidence-based abstention, error analysis, text leakage awareness, and lightweight production inference.

### Project 3: Predictive Maintenance and Anomaly Triage

**What it does:** Predicts whether equipment will fail within a future horizon and separately flags unusual sensor patterns. It evaluates performance by machine and future time window rather than random row splitting.

**Tech stack:** pandas, scikit-learn pipelines, `GroupKFold`/time-aware splitting, random forest or histogram gradient boosting, `IsolationForest` for exploratory anomalies, calibration, plotting, and batch-scoring infrastructure.

**Dataset suggestion:** AI4I 2020 Predictive Maintenance, NASA turbofan data after creating a clearly defined horizon, or synthetic sensor sequences. Avoid using post-failure fields or IDs that encode target collection.

**Implementation milestones:**

1. define failure horizon and label availability;
2. engineer rolling features using past values only;
3. split by machine and time;
4. compare supervised failure prediction with anomaly scores;
5. choose recall under a maintenance-inspection budget;
6. analyze sensor drift and unseen machines;
7. provide monitoring and retraining triggers.

**Resume value:** Demonstrates temporal leakage prevention, grouped validation, rare-event metrics, feature-window engineering, anomaly-detection limitations, and realistic operational costs.

---

## 19. Quick Revision

### Key idea

Scikit-learn standardizes ML components as cloneable estimators. Put every learned preprocessing step and the final estimator in one pipeline; evaluate the whole learning procedure with a split that matches deployment.

### Main API

```python
model.fit(X_train, y_train)
prediction = model.predict(X_test)
probability = model.predict_proba(X_test)  # only when supported

transformer.fit(X_train)
X_train_new = transformer.transform(X_train)
X_test_new = transformer.transform(X_test)
```

### Core composition pattern

```python
preprocess = ColumnTransformer([
    ("num", make_pipeline(SimpleImputer(strategy="median"), StandardScaler()), num_cols),
    ("cat", make_pipeline(SimpleImputer(strategy="most_frequent"),
                          OneHotEncoder(handle_unknown="ignore")), cat_cols),
])

model = Pipeline([
    ("preprocess", preprocess),
    ("model", LogisticRegression(max_iter=2000)),
])
```

### Essential formulas

Standardization:

$$z=(x-\mu_{train})/\sigma_{train}.$$

Logistic probability:

$$p=1/(1+e^{-(w^Tx+b)}).$$

Regularized objective:

$$\text{data loss}+\lambda\times\text{complexity penalty}.$$

Precision, recall, and F1:

$$P=TP/(TP+FP),\quad R=TP/(TP+FN),\quad F_1=2PR/(P+R).$$

Regression:

$$MAE=\frac1n\sum|y-\hat y|,\quad
RMSE=\sqrt{\frac1n\sum(y-\hat y)^2}.$$

### When to use scikit-learn

- classical supervised/unsupervised ML;
- small-to-medium tabular or sparse datasets on one machine;
- fast, reproducible experiments and strong baselines;
- preprocessing, CV, tuning, and inspection around compatible estimators;
- lightweight batch or API inference.

### Important metrics

- Balanced classification: accuracy/macro F1 when costs support them.
- Imbalanced detection: average precision, precision/recall at an operating point.
- Ranking: ROC-AUC or average precision.
- Probabilities: log loss, Brier score, calibration.
- Regression: MAE, RMSE, $R^2$, and a domain-specific cost metric.
- Clustering: internal scores plus stability and business usefulness.

### Common traps

- fitting preprocessing or selection before CV;
- random split despite users, groups, locations, or time;
- tuning or selecting a threshold on the test set;
- using accuracy for rare positives;
- assuming `predict_proba` is calibrated;
- ignoring unknown categories and schema changes;
- densifying huge sparse matrices;
- oversubscribing `n_jobs`;
- loading untrusted pickle/joblib files;
- interpreting importance as causality.

### Interview one-liner

> Scikit-learn's power is its estimator API: it lets me package fold-safe preprocessing and a model into one cloneable pipeline, validate it with the correct splitter and metric, tune nested parameters, and deploy the same learned transformations with the estimator.

### Ten facts to remember

1. Install `scikit-learn`; import `sklearn`.
2. Constructor arguments are hyperparameters; learned attributes end with `_`.
3. `fit` learns, `transform` maps, `predict` infers.
4. Pipelines prevent learned preprocessing from leaking across folds.
5. `ColumnTransformer` handles heterogeneous columns.
6. Nested parameters use `step__parameter`.
7. Loss scorers are negative because search maximizes.
8. Choose stratified, group, or temporal splits based on deployment.
9. Select classification thresholds on validation data.
10. Persist and monitor the complete decision pipeline, not just model weights.

---

## 20. Final Cheat Sheet

| Item | Scikit-learn summary |
|---|---|
| **Definition** | Python library for classical ML, preprocessing, model selection, evaluation, and estimator composition |
| **Package/import** | install `scikit-learn`; `import sklearn` |
| **Input** | usually NumPy arrays, pandas DataFrames/Series, SciPy sparse matrices, or raw text for vectorizers |
| **Output** | transformed features, labels, values, probabilities/scores, clusters, embeddings, metrics, or a fitted composite estimator |
| **Main protocol** | `fit`; then `transform`, `predict`, `predict_proba`, `decision_function`, or `score` as supported |
| **Learned state** | attributes ending in `_`, such as `coef_`, `classes_`, `mean_`, `categories_` |
| **Main composition** | `ColumnTransformer` for parallel column preprocessing inside a sequential `Pipeline` |
| **Validation** | split according to IID, class, group, time, or spatial structure; keep final test untouched |
| **Tuning** | `GridSearchCV`, `RandomizedSearchCV`, or appropriate advanced search; nested paths use `__` |
| **Classification metrics** | precision, recall, F1/F-beta, ROC-AUC, average precision, log loss, Brier score, confusion matrix |
| **Regression metrics** | MAE, RMSE/MSE, $R^2$, quantile/domain-specific error |
| **Clustering checks** | silhouette/internal metrics, stability, interpretability, and actionability |
| **Key hyperparameters** | regularization, model capacity, number of trees/iterations, learning rate, neighbors, kernel scale, components/clusters |
| **Scaling needed for** | k-NN, k-means, PCA, SVM, regularized/gradient-based linear models |
| **Scaling usually not needed for** | decision trees, random forests, ordinary tree boosting |
| **Pros** | consistent API, broad algorithm coverage, excellent pipeline/CV tooling, strong documentation, mature CPU implementations |
| **Cons** | not a full deep-learning or distributed platform; many estimators are in-memory/CPU-oriented; persistence can be version-sensitive |
| **Best use cases** | tabular ML, sparse text baselines, clustering/PCA, anomaly detection, model comparison, small/medium production pipelines |
| **Security rule** | never load pickle/joblib-style artifacts from untrusted sources |
| **Leakage rule** | anything that learns from data belongs inside the pipeline and inside each validation fold |
| **Deployment rule** | save model + preprocessing + threshold + schema + environment/data/code metadata |

### Minimal correct classification template

```python
from sklearn.compose import ColumnTransformer
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import StratifiedKFold, cross_validate, train_test_split
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.2, stratify=y, random_state=42
)

preprocess = ColumnTransformer([
    ("num", make_pipeline(SimpleImputer(strategy="median"), StandardScaler()), num_cols),
    ("cat", make_pipeline(
        SimpleImputer(strategy="most_frequent"),
        OneHotEncoder(handle_unknown="ignore"),
    ), cat_cols),
])

model = make_pipeline(preprocess, LogisticRegression(max_iter=2000))
cv = StratifiedKFold(5, shuffle=True, random_state=42)

result = cross_validate(
    model, X_train, y_train, cv=cv,
    scoring=["roc_auc", "average_precision", "f1"],
)

model.fit(X_train, y_train)
test_probability = model.predict_proba(X_test)[:, 1]
```

### Final interview checklist

Before presenting any scikit-learn solution, be ready to answer:

1. What is one row, and what exactly is the target?
2. Which features exist at prediction time?
3. Why is the split strategy valid for deployment?
4. Which steps learn from data, and are all inside the pipeline?
5. What dummy/simple baseline must the model beat?
6. Why does the metric match business error cost?
7. How were hyperparameters and the threshold selected without touching test data?
8. What do train-CV gaps, fold variance, and slice results show?
9. What happens for missing values, unknown categories, and schema drift?
10. How will the complete artifact be versioned, loaded safely, monitored, and rolled back?

If those answers are precise, the solution demonstrates ML engineering judgment rather than API memorization.
