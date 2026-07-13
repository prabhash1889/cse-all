# Validation in Machine Learning: Placement and Project Guide

Validation estimates how a model will behave on **unseen future data**. The central rule behind every method here is: decide the split first, then fit *every learned preprocessing step*—imputation, scaling, feature selection, PCA, resampling, and tuning—only with the training portion of that split.

Shared notation: a dataset is \(D=\{(x_i,y_i)\}_{i=1}^n\), a fitted model is \(\hat f\), loss is \(L(y,\hat f(x))\), and a validation estimate is an average loss on data not used to fit that instance of \(\hat f\). Use accuracy/F1/ROC-AUC/PR-AUC for classification and MAE/RMSE/\(R^2\) for regression according to the decision problem.

---

# Train/Test Split

## 1. Overview

A train/test split partitions labelled data into a development set used to build a model and a **held-out test set** used once for its final, unbiased performance estimate. It is the default evaluation protocol for IID data when the dataset is large enough. Production ML uses it for fraud, churn, vision, NLP, and tabular models because the test set simulates data that was unavailable while the model was chosen.

## 2. Intuition

Practising with old exam questions and taking a separate final exam is a train/test split. A high practice score alone proves little; the final exam tells whether you learned the ideas rather than memorised questions.

## 3. Prerequisites

Supervised learning, arrays/data frames, random sampling, loss/metrics, class imbalance, and the IID assumption (rows are independent and come from the same distribution).

## 4. Core Concepts

| Subtopic | Meaning and why it matters | Example / interview angle |
|---|---|---|
| Training set | Rows used to estimate parameters. | Fit a logistic-regression weight vector. Ask: can training accuracy measure generalisation? No. |
| Test set | Locked, unseen rows for final reporting. | Do not select `C` after seeing test AUC. Ask: why? It becomes validation data. |
| Split ratio | Commonly 80/20 or 70/30; larger data supports a smaller test fraction. | With 1M rows, 1–5% test may be enough. |
| Random state | Reproducible random partition. | It aids debugging, not statistical validity by itself. |
| Stratification | Preserve class proportions in classification. | Essential when 2% of transactions are fraud. |

## 5. Algorithm / Working Process

1. Define the deployment unit and cutoff: customer, group, or time—not merely a random row.
2. Reserve the test set before exploratory modelling.
3. Split the remaining data into training and optionally validation data.
4. Fit transformations and model on training data only; tune on validation/CV.
5. Freeze the selected pipeline, refit it on all development data, and evaluate once on the test set.

Input: \(X,y\). Processing: partition, fit on \(D_{train}\), predict \(X_{test}\). Output: test metric and uncertainty. Training is only on training rows; inference applies the frozen pipeline to new rows.

## 6. Mathematical Foundation

With test indices \(T\), the estimated generalisation risk is

\[
\widehat R_{test}(\hat f)=\frac{1}{|T|}\sum_{i\in T}L(y_i,\hat f(x_i)).
\]

For 0–1 classification loss, this is error rate; accuracy is \(1-\widehat R\). If test examples are IID and the model was fixed before testing, a rough standard error for accuracy \(\hat p\) is \(\sqrt{\hat p(1-\hat p)/n_{test}}\). This explains why tiny test sets give noisy scores.

## 7. Practical Implementation

```python
from sklearn.datasets import load_breast_cancer
from sklearn.model_selection import train_test_split
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import roc_auc_score

X, y = load_breast_cancer(return_X_y=True)
X_train, X_test, y_train, y_test = train_test_split(
    X, y, test_size=0.20, stratify=y, random_state=42)
model = make_pipeline(StandardScaler(), LogisticRegression(max_iter=2000))
model.fit(X_train, y_train)
print("held-out ROC-AUC:", roc_auc_score(y_test, model.predict_proba(X_test)[:, 1]))
```

## 8. Code Explanation

`stratify=y` preserves the malignant/benign ratio. `make_pipeline` calls `StandardScaler.fit` only on `X_train`, preventing test statistics from leaking into training. ROC-AUC uses predicted probabilities, not hard labels.

## 9. Training / Evaluation

Prepare a test set that matches deployment, including the right time period and entity granularity. Tune hyperparameters without it; then report appropriate metrics, confusion matrix/threshold metrics for classification, and error slices. A large train–test gap signals overfitting; a low score on both signals underfitting or weak data/features.

## 10. Complexity and Cost

The split costs \(O(n)\) time and stores index arrays, \(O(n)\) memory in the worst case. Training happens once, so it is much cheaper than CV. CPU is sufficient for splitting; model cost dominates.

## 11. Common Use Cases

Large IID tabular datasets, fixed image/text benchmarks, final offline evaluation before deployment, and a final safety gate after CV tuning.

## 12. Common Mistakes

* Scaling, imputing, oversampling, or selecting features before the split.
* Tuning repeatedly against the test score.
* Randomly splitting duplicate users, patients, documents, or adjacent video frames across sets.
* Omitting stratification for rare classes or using accuracy alone for imbalance.

## 13. Edge Cases / Limitations

A single split is high-variance on small data. Random splitting fails when data are ordered in time, correlated within groups, or shifted from deployment. It also allocates fewer rows to training than CV.

## 14. Variations

* **Train/validation/test (60/20/20, etc.):** tune on validation; placement-essential.
* **Group split:** keep every user/patient/device in one partition; important for projects.
* **Temporal split:** earlier data trains, later data tests; required for forecasting.
* **Repeated holdout:** average several random splits; useful exploratory alternative to CV.

## 15. Related Topics

Validation sets choose models, cross-validation reuses limited development data, and nested CV evaluates a tuned pipeline. Stratified and group splits alter *how* a holdout is drawn. Bootstrap estimates uncertainty rather than creating one permanent final test.

## 16. Interview Questions

1. **Why keep a test set?** To estimate performance on untouched data after all choices are fixed.
2. **Why not train on test data?** It leaks target information and makes the reported score optimistic.
3. **What split ratio is best?** No universal value; choose enough test examples for a stable estimate while preserving training data.
4. **Why set `random_state`?** Reproducibility, not better generalisation.
5. **When stratify?** Classification, especially with imbalanced labels.
6. **Can I tune on a test set?** No; reserve it and tune with a validation set or CV.
7. **What is leakage through preprocessing?** Learning scaler/imputer/PCA parameters from test rows.
8. **What replaces random splitting for users?** `GroupShuffleSplit` or group CV.
9. **What does a large train–test gap mean?** Usually high variance/overfitting or distribution shift.
10. **What if there is no test set?** Use nested CV for an internal estimate, but acquire a final external/temporal test set when possible.

## 17. Practice Tasks

1. Split an imbalanced Kaggle dataset with and without `stratify`; compare class counts.
2. Intentionally fit a scaler before splitting and explain the leakage.
3. Compare five random holdouts and plot score variation.
4. Build a group-safe split by customer ID and measure the difference from random split.
5. Refit the chosen pipeline on development data and score a locked test set exactly once.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Credit-default evaluator | Builds leakage-safe risk pipeline | pandas, scikit-learn; UCI Default | Demonstrates production-minded evaluation. |
| Patient-risk split audit | Compares random and patient-group splits | pandas, sklearn; MIMIC-style/public health data | Shows awareness of clinical leakage. |
| Image duplicate audit | Detects near duplicates crossing a split | Python, embeddings; CIFAR/custom images | Demonstrates dataset quality work. |

## 19. Quick Revision

Key idea: test once on unseen data. Formula: \(\widehat R=|T|^{-1}\sum L\). Use for large IID data. Metrics follow the task. Traps: preprocessing leakage, test-set tuning, duplicated/grouped rows. Interview one-liner: “The test set is an audit, not a tuning knob.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | One held-out partition estimates final generalisation. |
| Input/output | \(X,y\) → train/test indices, fitted model, held-out metric. |
| Main steps | Split → fit pipeline on train → tune elsewhere → test once. |
| Key choices | `test_size`, `stratify`, group/time boundary, random seed. |
| Pros / cons | Simple and cheap / noisy on small data; wastes training rows. |
| Best use | Large IID data plus a final external or temporal holdout. |

---

# Validation Set

## 1. Overview

A validation set is a third partition used during development to choose hyperparameters, architectures, thresholds, and early-stopping epochs. It separates model selection from final test reporting and is common in deep learning, where repeated retraining makes full CV expensive.

## 2. Intuition

Training is rehearsing, validation is a mock exam used to adjust your study plan, and testing is the final exam. If you repeatedly alter your plan after reading final-exam answers, the final score no longer measures you fairly.

## 3. Prerequisites

Train/test split, hyperparameters versus learned parameters, metrics, loss curves, and data leakage.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Model selection | Choose among candidates using validation score. | Select tree depth 3 vs 10. |
| Early stopping | Stop at lowest validation loss. | Avoids training after generalisation worsens. |
| Threshold tuning | Choose operating point on validation data. | Optimise recall subject to precision ≥ 0.9. |
| Validation overfitting | Many experiments adapt to the same validation set. | Use a fresh test set/nested CV. |

## 5. Algorithm / Working Process

1. Make train/validation/test partitions with valid stratification, groups, or time order.
2. Fit each candidate pipeline on train only.
3. Evaluate candidates on validation; choose architecture, hyperparameters, epoch, and threshold.
4. Refit the chosen configuration on train+validation if the protocol allows.
5. Run one final test evaluation.

## 6. Mathematical Foundation

For configurations \(\lambda\in\Lambda\), select
\[
\lambda^*=\arg\min_{\lambda\in\Lambda}\frac{1}{n_{val}}\sum_{i\in V}L(y_i,\hat f_{\lambda,train}(x_i)).
\]
Because \(\lambda^*\) is selected for good validation performance, its validation loss is biased downward as an estimate of final performance; the untouched test set corrects this selection bias.

## 7. Practical Implementation

```python
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import f1_score

X_dev, X_test, y_dev, y_test = train_test_split(X, y, test_size=.2, stratify=y, random_state=42)
X_tr, X_val, y_tr, y_val = train_test_split(X_dev, y_dev, test_size=.25, stratify=y_dev, random_state=42)
scores = {d: f1_score(y_val, RandomForestClassifier(max_depth=d, random_state=42).fit(X_tr, y_tr).predict(X_val))
          for d in (3, 6, None)}
best_depth = max(scores, key=scores.get)
final = RandomForestClassifier(max_depth=best_depth, random_state=42).fit(X_dev, y_dev)
print(best_depth, f1_score(y_test, final.predict(X_test)))
```

## 8. Code Explanation

The first split locks 20% as test; the second makes validation 20% of the original data. The dictionary compares only depth. `X_dev` is used for the final refit after selection; the printed test F1 was not used to pick depth.

## 9. Training / Evaluation

Track train and validation loss each epoch; save the checkpoint with best validation metric. Keep the validation pipeline identical to inference preprocessing. For imbalanced data, tune the threshold using PR-AUC/F1/recall—not validation accuracy. Use CV instead if data are scarce.

## 10. Complexity and Cost

Cost is roughly number of configurations \(m\) times training cost, plus validation predictions: \(O(m\,C_{fit})\). It stores one extra partition. Deep nets often require GPUs, but validation itself is inference-only.

## 11. Common Use Cases

Neural-network early stopping, choosing learning rate/batch size, selecting an LLM prompt/model, calibration and decision thresholds, and light hyperparameter search on large data.

## 12. Common Mistakes

* Calling the validation metric “test accuracy.”
* Selecting a checkpoint by test loss.
* Transforming validation data with a scaler fitted on all rows.
* Reusing the same validation set for hundreds of adaptive experiments.
* Refitting on validation data but forgetting to retain a test set.

## 13. Edge Cases / Limitations

On a small dataset, withholding a validation set harms training and yields a noisy choice. It is unreliable under temporal/group dependence unless the partition respects that structure.

## 14. Variations

* **Fixed validation holdout:** cheap; use on big datasets.
* **Development set with CV:** validation folds choose parameters; use on modest data.
* **Online validation:** recent labeled traffic; use under drift.
* **Early-stopping validation:** separate from final tuning validation for very high-stakes workflows.

## 15. Related Topics

Train/test split provides the outer final audit. K-fold CV replaces one validation set with several folds. Nested CV protects evaluation when both tuning and data scarcity matter. Bias–variance explains why one validation split can be noisy.

## 16. Interview Questions

1. **Train vs validation vs test?** Fit parameters; choose configuration; report final generalisation.
2. **Can validation data affect weights?** Not directly; early stopping/checkpoint selection indirectly uses it, so it is no longer independent.
3. **Why refit on train+validation?** After configuration is fixed, those labels can improve the final fit.
4. **What is validation leakage?** Any validation information influencing preprocessing or candidate design beyond legitimate model selection.
5. **Why can validation performance be optimistic?** We select the best of many noisy scores.
6. **What metric for early stopping?** The deployment-aligned validation metric or loss; use patience.
7. **Why not a validation set with huge data?** You still need it for tuning; its fraction can be small.
8. **How tune a threshold?** Choose it on validation based on costs/required precision-recall.
9. **When prefer CV?** Small or medium datasets where a single holdout is unstable.
10. **Should test data be used for early stopping?** Never.

## 17. Practice Tasks

1. Plot train/validation loss and implement patience-based early stopping.
2. Compare a 60/20/20 split with 80/10/10 on a small dataset.
3. Select a fraud threshold from validation PR curves; report test precision/recall.
4. Demonstrate optimistic validation selection by trying many random seeds.
5. Add a final untouched test report to a notebook that currently tunes on test data.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Early-stop image classifier | Saves best validation checkpoint | PyTorch; CIFAR-10 | Shows training-loop competence. |
| Cost-aware fraud model | Tunes threshold by validation cost | sklearn; credit-card fraud | Links ML metric to business decisions. |
| Prompt-selection benchmark | Validates prompts/models then locks a test set | Python, LLM API; QA dataset | Shows LLM evaluation discipline. |

## 19. Quick Revision

Key idea: validation chooses; test judges. Formula: \(\lambda^*=\arg\min R_{val}\). Use for tuning/early stopping. Trap: test-set tuning and repeated adaptive validation. One-liner: “Validation is part of development; test data is not.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Holdout used for model-selection decisions. |
| Input/output | candidates + validation rows → chosen configuration. |
| Main steps | Split three ways → train candidates → select on val → test once. |
| Key choices | Fraction, split strategy, metric, early-stop patience. |
| Pros / cons | Simple and fast / noisy and data-hungry on small sets. |
| Best use | Large datasets and deep-learning training. |

---

# Cross-Validation

## 1. Overview

Cross-validation (CV) evaluates a modelling *procedure* repeatedly on different held-out subsets, then averages the scores. It gives a more stable performance estimate than one validation split and makes better use of small and medium datasets.

## 2. Intuition

Instead of judging a chef from one taste, several diners each taste a different portion. Every row gets a chance to be judged as unseen data, so one unlucky split matters less.

## 3. Prerequisites

Train/validation/test roles, metrics, mean/standard deviation, pipelines, and split assumptions (IID, grouped, or temporal).

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Fold | One held-out validation portion. | A 5-fold CV produces five scores. |
| CV score | Mean held-out score across folds. | Report mean ± standard deviation, not only mean. |
| Out-of-fold prediction | Each prediction is made by a model not trained on that row. | Used for stacking/calibration. |
| Pipeline | Fits preprocessing inside each fold. | Prevents leakage in scaling/PCA/SMOTE. |

## 5. Algorithm / Working Process

Choose a splitter appropriate to data structure. For every split, clone the entire pipeline, fit it on the training indices, predict validation indices, and collect metric \(s_j\). Aggregate scores, select a configuration if required, then refit on all development data. Keep an external test set for final reporting when available.

## 6. Mathematical Foundation

For \(K\) folds,
\[
\widehat R_{CV}=\frac1K\sum_{j=1}^K\frac{1}{|V_j|}\sum_{i\in V_j}L(y_i,\hat f^{(-j)}(x_i)).
\]
\(\hat f^{(-j)}\) is trained without fold \(j\). Score dispersion is commonly reported as \(s=\sqrt{\sum_j(s_j-\bar s)^2/(K-1)}\); folds are correlated, so this is descriptive, not a perfect confidence interval.

## 7. Practical Implementation

```python
from sklearn.model_selection import StratifiedKFold, cross_validate
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
pipe = make_pipeline(StandardScaler(), LogisticRegression(max_iter=2000))
out = cross_validate(pipe, X, y, cv=cv, scoring=["accuracy", "roc_auc"], return_train_score=True)
print(out["test_roc_auc"].mean(), out["test_roc_auc"].std())
```

## 8. Code Explanation

`cross_validate` clones `pipe` for each fold; therefore the scaler never sees that fold’s validation rows. `test_` in the returned dictionary means fold-held-out, not a permanent final test set. `return_train_score` helps inspect overfitting.

## 9. Training / Evaluation

Use the same splitter for all comparable models and a pipeline for all learned transforms. Prefer stratified CV for classification and group/time-aware CV when required. Compare mean, spread, training scores, error slices, and runtime—not a single lucky fold.

## 10. Complexity and Cost

For \(K\) folds, cost is about \(K\) model fits and memory is roughly one fit plus stored scores: \(O(KC_{fit})\). Parallelise independent folds with `n_jobs=-1` only if memory allows. GPU models can make CV expensive.

## 11. Common Use Cases

Small tabular datasets, model comparison, hyperparameter tuning, feature-selection evaluation, and out-of-fold predictions for ensembles.

## 12. Common Mistakes

* Fitting preprocessing before calling CV.
* Using ordinary CV for users, patients, duplicate images, or time series.
* Calling fold average a final test result after tuning on it.
* Ignoring fold variance or failed folds.
* Using non-shuffled plain KFold on class-sorted data.

## 13. Edge Cases / Limitations

CV is slow for expensive models and can still leak via correlations or poor feature timestamps. Repeated hyperparameter search over CV folds can overfit their aggregate score. It does not replace an external distribution-shift test.

## 14. Variations

* **K-fold:** the usual partition scheme; placement-essential.
* **Stratified CV:** keeps label proportions; essential for classification.
* **Group CV:** isolates entities; important in real datasets.
* **Repeated CV:** reduces split randomness; useful for very small IID data.
* **Nested CV:** outer folds evaluate tuning; research/interview-important.

## 15. Related Topics

K-fold is a specific CV method. Bootstrap resamples with replacement rather than partitioning. Nested CV separates model selection and evaluation. Bias–variance frames the trade-off in the chosen number of folds.

## 16. Interview Questions

1. **What is CV?** Repeated holdout evaluation over multiple splits.
2. **Why use it?** More stable estimates and more efficient use of limited data.
3. **Does CV train one model?** It trains one temporary model per fold; then normally refits one final model.
4. **Why pipeline preprocessing?** To fit learned transforms only on each fold’s training data.
5. **What does CV standard deviation show?** Split sensitivity, though folds are correlated.
6. **Is CV a substitute for external testing?** No, especially under domain shift.
7. **Which splitter for imbalance?** StratifiedKFold.
8. **Can CV select features?** Yes, if feature selection lives inside the pipeline.
9. **Why is CV costly?** It repeats training \(K\) times per configuration.
10. **What are OOF predictions?** Predictions for rows from models that excluded those rows from fitting.

## 17. Practice Tasks

1. Compare one holdout with 5-fold mean and standard deviation.
2. Place `SelectKBest` inside a pipeline and verify leakage-safe CV.
3. Generate OOF probabilities for a stacking feature.
4. Compare KFold and StratifiedKFold class counts.
5. Measure CV runtime with 3, 5, and 10 folds.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Model-selection dashboard | Compares pipelines by fold score/spread | sklearn, Streamlit; UCI data | Demonstrates reproducible experimentation. |
| OOF ensemble | Builds stacking inputs safely | sklearn; Titanic/Adult | Demonstrates ensemble evaluation literacy. |
| Feature-leakage lab | Shows wrong vs pipeline CV results | sklearn; synthetic + real data | Strong interview teaching project. |

## 19. Quick Revision

Key idea: average several unseen-fold scores. Formula: \(\widehat R_{CV}=K^{-1}\sum R_j\). Use when data are limited. Trap: preprocess outside folds. One-liner: “CV evaluates the whole pipeline, not just the estimator.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Repeated fit/validate splits aggregated into a score. |
| Input/output | data + splitter + pipeline → mean and spread of scores. |
| Main steps | Split → fit per fold → score held-out fold → aggregate/refit. |
| Key choices | splitter, `n_splits`, metric, pipeline, random seed. |
| Pros / cons | Stable and data-efficient / \(K\)× training cost. |
| Best use | Small/medium IID development datasets. |

---

# K-fold Cross-Validation

## 1. Overview

K-fold CV divides the dataset into \(K\) disjoint folds. It trains on \(K-1\) folds and validates on the remaining fold, rotating until every row has been validation data once. It is the canonical CV method for IID regression and balanced classification.

## 2. Intuition

Split five flashcard piles; study four and quiz yourself on the fifth, then rotate. Every flashcard is tested exactly once and used for studying \(K-1\) times.

## 3. Prerequisites

Cross-validation, random shuffling, mean/variance, training pipelines, and representative sampling.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| \(K\) | Number of partitions. | 5 or 10 are conventional; there is no magic value. |
| Fold size | About \(n/K\). | Equal folds prevent score weighting issues. |
| Training fraction | \((K-1)/K\) per fit. | 10-fold trains on 90%; 5-fold on 80%. |
| Shuffle | Randomises row assignment before partitioning. | Use for IID data; do not shuffle time series. |

## 5. Algorithm / Working Process

1. Shuffle IID rows with a fixed seed, then partition indices into \(K\) nearly equal folds.
2. For fold \(j\), use \(F_j\) as validation and \(D\setminus F_j\) as training.
3. Fit the entire pipeline, score \(F_j\), and repeat for all \(j\).
4. Average scores (weighted by fold size if unequal), inspect variation, choose a model, and refit it on all available development rows.

## 6. Mathematical Foundation

Let \(F_1,\ldots,F_K\) partition \(D\). Then
\[
\widehat R_{KCV}=\frac{1}{K}\sum_{j=1}^K \frac{1}{|F_j|}\sum_{i\in F_j}L(y_i,\hat f_{D\setminus F_j}(x_i)).
\]

Increasing \(K\) raises each training-set size and generally lowers bias of the risk estimate, but fold scores become more correlated and computation rises; variance does not always decrease monotonically. Leave-one-out (\(K=n\)) is not automatically best.

## 7. Practical Implementation

```python
from sklearn.model_selection import KFold, cross_val_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Ridge

cv = KFold(n_splits=5, shuffle=True, random_state=42)
reg = make_pipeline(StandardScaler(), Ridge(alpha=1.0))
rmse = -cross_val_score(reg, X, y, cv=cv, scoring="neg_root_mean_squared_error")
print(f"RMSE: {rmse.mean():.3f} ± {rmse.std():.3f}")
```

## 8. Code Explanation

`KFold` is appropriate for IID regression. scikit-learn negates loss-like metrics because its scoring convention is “larger is better”; negate it back to obtain RMSE. The scaler is inside the pipeline for every fold.

## 9. Training / Evaluation

Use 5 folds as a strong default; use 10 for small, cheap IID datasets when extra compute is acceptable. Set `shuffle=True` for arbitrary IID row order. For classification use `StratifiedKFold`, not this generic splitter. Do not alter \(K\) after inspecting scores just to obtain a favourable result.

## 10. Complexity and Cost

\(K\) fits, each on \(n(K-1)/K\) examples. For a near-linear learner, total work is approximately \((K-1)\) times one full-data fit. Memory is mostly one estimator plus data; parallel folds multiply model memory.

## 11. Common Use Cases

Ridge/lasso/model comparisons on tabular regression, baseline classification with balanced labels, and coursework experiments where one split is too unstable.

## 12. Common Mistakes

* Using KFold on imbalanced or label-sorted classification data.
* Forgetting shuffle for IID data stored in an ordered way.
* Shuffling temporal data.
* Averaging a loss with the wrong sign in sklearn.
* Reporting only the best fold rather than the aggregate.

## 13. Edge Cases / Limitations

It assumes exchangeable/IID observations. It leaks subject/time information when records are correlated. With rare classes, a fold may contain no positives; stratification or fewer folds is needed.

## 14. Variations

* **5-fold:** standard practical default; placement-essential.
* **10-fold:** more training data per fit; useful when cheap/small.
* **LOOCV:** \(K=n\); low bias but costly and often high variance; research discussion.
* **Repeated K-fold:** repeats random partitions; use to stabilise IID comparison.

## 15. Related Topics

K-fold is the base form of CV. Stratified K-fold adds label balance; group K-fold adds entity isolation; time-series split abandons arbitrary rotation to preserve causality; nested K-fold wraps an outer evaluation loop.

## 16. Interview Questions

1. **How many models does 5-fold CV fit?** Five per candidate configuration.
2. **How much data trains each model?** Roughly 80%.
3. **Why not use 100 folds?** Higher compute and correlated folds; little practical gain.
4. **Why is 5-fold common?** Good empirical cost/stability compromise.
5. **What is LOOCV?** One validation row per fold, \(K=n\).
6. **Should KFold shuffle?** Yes for IID unordered rows; no for time order.
7. **How aggregate unequal folds?** Prefer sample-weighted loss or ensure equal folds.
8. **Why pipeline transformations?** To avoid validation statistics in training.
9. **Does K-fold provide a final model?** No; refit after selecting configuration.
10. **When is KFold invalid?** Groups, duplicates, spatial clusters, and time dependence.

## 17. Practice Tasks

1. Implement K-fold indices with NumPy and assert every row validates once.
2. Compare 3-, 5-, 10-fold RMSE and runtime.
3. Show why no shuffle harms a label-sorted dataset.
4. Compare LOOCV and 5-fold for a small regression set.
5. Plot per-fold error to locate unstable subsets.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| House-price model card | Reports K-fold RMSE and fold errors | pandas, sklearn; Ames Housing | Demonstrates reliable regression work. |
| CV-from-scratch notebook | Implements splitting and checks coverage | NumPy, sklearn | Demonstrates fundamentals beyond APIs. |
| Compute-vs-score study | Benchmarks \(K\) choices | sklearn, matplotlib; UCI | Shows practical experimentation judgement. |

## 19. Quick Revision

Key idea: every row validates once. Formula: average \(K\) held-out losses. Use for IID data. Trap: use stratified/group/time variants when data demand them. One-liner: “K raises training fraction per fold but also fit cost.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Partition into \(K\) rotating train/validation folds. |
| Input/output | IID data → \(K\) scores, mean/spread. |
| Main steps | shuffle → partition → fit \(K\) times → average → refit. |
| Key hyperparameters | `n_splits`, shuffle, random seed, metric. |
| Pros / cons | Data-efficient / costly, IID-only. |
| Best use | IID regression and balanced classification baselines. |

---

# Stratified Cross-Validation

## 1. Overview

Stratified CV makes each fold approximately preserve the class-label distribution of the full dataset. It is the default for single-label classification, especially when positives are rare, because every validation fold must meaningfully contain the classes whose performance is measured.

## 2. Intuition

If a school is 90% first-years and 10% final-years, every sample class should preserve that mix. A test class containing no final-years cannot tell you whether a policy works for them.

## 3. Prerequisites

K-fold CV, classification labels, class imbalance, class metrics, and random sampling.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Class proportion | Fraction of each label in a fold. | Overall 2% fraud → each fold near 2%. |
| Minority support | Positive examples per fold. | `n_splits` cannot exceed minority-class count. |
| Stratification target | Usually the class label. | Stratifying a continuous target needs binning, cautiously. |
| Multilabel limits | Multiple labels cannot be perfectly preserved by basic splitter. | Use iterative stratification if needed. |

## 5. Algorithm / Working Process

For each class, shuffle its indices and distribute them as evenly as possible among \(K\) folds. Construct fold \(j\) by combining that class’s allocated indices. Each iteration trains on all other folds, predicts fold \(j\), and aggregates metrics. Keep resampling methods such as SMOTE inside the training-fold pipeline.

## 6. Mathematical Foundation

If global class proportion for class \(c\) is \(p_c=n_c/n\), stratification targets
\[
\frac{n_{jc}}{|F_j|}\approx p_c \quad \text{for every fold }j.
\]

It reduces variability in metrics caused merely by changing label mix. It does **not** make a biased sample representative in every other feature, and it does not correct class imbalance in the learning objective; class weights or resampling may still be needed.

## 7. Practical Implementation

```python
from sklearn.model_selection import StratifiedKFold, cross_val_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

cv = StratifiedKFold(n_splits=5, shuffle=True, random_state=42)
model = make_pipeline(StandardScaler(), LogisticRegression(class_weight="balanced", max_iter=2000))
scores = cross_val_score(model, X, y, cv=cv, scoring="average_precision")
print("PR-AUC:", scores.mean(), "+/-", scores.std())
```

## 8. Code Explanation

`StratifiedKFold` balances labels across folds; `class_weight="balanced"` separately changes the training loss to give minority errors more weight. Average precision (PR-AUC) is often more informative than accuracy for rare positives.

## 9. Training / Evaluation

Count each class per fold before training. Select a metric aligned with the minority-class decision: recall, precision, F1, PR-AUC, cost, or calibration. Use `StratifiedGroupKFold` if the same entity can appear in several rows. Never oversample the full dataset before splitting.

## 10. Complexity and Cost

Split assignment is \(O(n)\); model cost remains \(K\) fits. Memory overhead is indices and labels. Stratification adds negligible cost compared with fitting.

## 11. Common Use Cases

Disease detection, fraud, spam, defect detection, rare-event NLP, and multiclass problems with unequal class counts.

## 12. Common Mistakes

* Believing stratification handles imbalance by itself.
* Setting folds greater than the number of minority examples.
* Applying SMOTE before CV.
* Using ROC-AUC alone when precision at low prevalence matters.
* Ignoring groups while stratifying patients/users.

## 13. Edge Cases / Limitations

Extremely rare classes may make reliable CV impossible; collect labels, reduce folds, or use a dedicated evaluation set. It is not appropriate for regression without carefully justified bins and does not preserve joint distributions of multiple sensitive variables.

## 14. Variations

* **StratifiedKFold:** standard single-label classification; placement-essential.
* **RepeatedStratifiedKFold:** repeated partitions; helpful for small IID classification.
* **StratifiedGroupKFold:** approximate label balance while keeping groups intact; project-important.
* **Iterative multilabel stratification:** preserves multilabel frequencies; useful in research/NLP.

## 15. Related Topics

K-fold supplies the rotation; stratification controls label composition. Class weighting and SMOTE address training imbalance, while PR-AUC/F1 assess it. Group and time splits take precedence when entity/time leakage exists.

## 16. Interview Questions

1. **Why stratify?** To keep label proportions and minority support comparable in each fold.
2. **Does it rebalance classes?** No; it preserves imbalance in every fold.
3. **What if only three positives exist?** At most three folds, but estimates are still unstable; obtain more positives.
4. **Why use PR-AUC for fraud?** It focuses on precision/recall under low prevalence.
5. **Can we stratify regression?** Not normally; optionally bin target with care.
6. **How combine with groups?** Use StratifiedGroupKFold where feasible.
7. **Why put SMOTE in a pipeline?** Synthetic points must be generated only from each training fold.
8. **Is `class_weight` a replacement for stratification?** No; one affects fitting, the other evaluation splits.
9. **What happens without stratification?** Some folds can have wildly different or absent class counts.
10. **Does it prevent all leakage?** No; timestamps, entities, duplicates, and preprocessing can still leak.

## 17. Practice Tasks

1. Print class distributions for KFold versus StratifiedKFold.
2. Create a 1%-positive dataset and compare accuracy, F1, ROC-AUC, and PR-AUC.
3. Put a resampler inside an imbalanced-learn pipeline and compare with the leaky version.
4. Try an impossible `n_splits` for a tiny minority class and explain the error.
5. Compare `class_weight="balanced"` with threshold tuning.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Fraud detection benchmark | Uses stratified CV, PR-AUC, thresholds | sklearn; Credit Card Fraud | Shows imbalanced-learning maturity. |
| Medical screening evaluator | Reports sensitivity/specificity by fold | sklearn; breast cancer | Demonstrates metric selection. |
| Toxic-comment multilabel split | Evaluates stratification methods | Python, sklearn; Jigsaw | Shows practical NLP data handling. |

## 19. Quick Revision

Key idea: preserve label mix in every fold. Formula: \(n_{jc}/|F_j|\approx n_c/n\). Use for classification. Trap: it is not a cure for imbalance or group leakage. One-liner: “Stratify evaluation; rebalance training separately.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | K-fold CV with approximately preserved class proportions. |
| Input/output | \(X,y\) → class-balanced fold scores. |
| Main steps | split labels per class → rotate folds → aggregate metric. |
| Key choices | folds ≤ smallest-class count, metric, shuffle, group constraint. |
| Pros / cons | Stable minority evaluation / does not solve rarity or dependence. |
| Best use | Imbalanced IID single-label classification. |

---

# Overfitting

## 1. Overview

Overfitting occurs when a model learns training-specific noise, accidental patterns, or leakage instead of transferable structure. It achieves unusually low training loss but worse validation/test loss. It is a central risk in flexible models such as deep neural networks, boosted trees, high-degree polynomials, and tiny datasets.

## 2. Intuition

Memorising the exact answers to last year’s questions can yield perfect practice marks while failing unfamiliar questions. Generalisation requires the rule, not the answer key.

## 3. Prerequisites

Loss functions, train/validation curves, model capacity, regularisation, probability/statistics, and valid data splitting.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Generalisation gap | Validation loss minus training loss. | Large positive gap suggests overfitting. |
| Capacity | Ability to fit complex functions. | A depth-30 tree can memorise IDs. |
| Noise fitting | Fitting random labels/features. | Deep nets can fit shuffled labels. |
| Regularisation | Constraints that discourage brittle solutions. | L2, dropout, pruning, data augmentation. |
| Leakage | Artificially good validation/test score. | It may look unlike ordinary overfitting but is worse. |

## 5. Algorithm / Working Process

Diagnose with a leakage-safe validation protocol. Train while recording training and validation loss. If training loss falls continuously while validation loss turns upward, stop at the best validation point and reduce effective capacity: add data/augmentation, regularise, simplify, or tune. Verify with a truly untouched test/temporal set.

## 6. Mathematical Foundation

Expected prediction error decomposes as
\[
\mathbb E[(Y-\hat f(X))^2]=\operatorname{Bias}[\hat f(X)]^2+\operatorname{Var}[\hat f(X)]+\sigma^2.
\]

Overfitting is primarily excessive variance. Regularised empirical risk minimisation is
\[
\min_\theta \frac1n\sum_i L(y_i,f_\theta(x_i))+\lambda\Omega(\theta),
\]
where \(\Omega(\theta)=||\theta||_2^2\) (weight decay) penalises extreme complexity. Early stopping is also a regulariser because it limits fitting of late-stage noise.

## 7. Practical Implementation

```python
from sklearn.model_selection import validation_curve
from sklearn.tree import DecisionTreeClassifier

depths = range(1, 21)
tr, va = validation_curve(DecisionTreeClassifier(random_state=42), X, y,
                          param_name="max_depth", param_range=depths,
                          cv=5, scoring="roc_auc")
best_depth = list(depths)[va.mean(axis=1).argmax()]
print("best depth:", best_depth, "train/val:", tr.mean(axis=1)[best_depth-1], va.mean(axis=1)[best_depth-1])
```

## 8. Code Explanation

The code fits trees with increasing capacity and evaluates each through CV. If training AUC keeps rising but validation AUC falls at large depth, the later trees overfit. Select the depth by validation mean, not maximum training AUC.

## 9. Training / Evaluation

Use learning curves: if train high/validation low, reduce variance; if both low, address underfitting. Use regularisation (`alpha`, weight decay), early stopping, pruning, dropout, augmentation, proper CV, and more representative data. Do not “fix” a genuine test gap by tuning to the test set.

## 10. Complexity and Cost

Overly flexible models often have greater training cost and memory: large trees, feature expansions, or deep networks. Regularisation typically adds little cost; augmentation and ensembles can add significant compute/GPU use.

## 11. Common Use Cases

It must be monitored in every supervised system: medical imaging with few labels, tabular competition models, fine-tuned LLMs, recommender systems, and computer vision.

## 12. Common Mistakes

* Declaring overfitting from a gap caused by distribution shift or noisy labels without investigation.
* Evaluating after leakage, which hides the problem.
* Reducing model size when training and validation are both poor.
* Using test loss for early stopping.
* Treating more epochs, features, or hyperparameter trials as guaranteed improvement.

## 13. Edge Cases / Limitations

Training loss can be higher than validation loss because of dropout, augmentation, or training-only regularisation; inspect comparable evaluation mode. A gap can also reflect non-IID test data rather than capacity. Overparameterised neural nets have nuanced double-descent behaviour, but held-out validation remains decisive.

## 14. Variations

* **Classical overfit:** too many parameters/features; placement-essential.
* **Validation overfit:** adaptively selecting from too many trials; use test/nested CV.
* **Data leakage:** information crosses split boundary; must fix data flow, not regularise.
* **Fine-tuning overfit:** model forgets/generalises poorly on limited domain labels; use low LR, PEFT, held-out set.

## 15. Related Topics

Underfitting is the opposite capacity error. Bias–variance formalises overfitting as high variance. CV detects it more reliably than one split; nested CV prevents hyperparameter-selection optimism. Data augmentation, dropout, weight decay, and early stopping are remedies.

## 16. Interview Questions

1. **What is overfitting?** Low train error but poor unseen-data performance from fitting noise/spurious patterns.
2. **How detect it?** Learning curves and leakage-safe validation/CV.
3. **Name remedies.** More data, augmentation, simpler model, regularisation, pruning, dropout, early stopping.
4. **Does more data help?** Usually it lowers variance if representative and labels are sound.
5. **Does L2 remove features?** It shrinks weights; L1 can set some to zero.
6. **Why is early stopping regularisation?** It prevents late fitting of noise.
7. **Can high test accuracy still mean leakage?** Yes; inspect timestamps/entities/features and deployment availability.
8. **What curve shape signals it?** Training loss decreases while validation loss rises.
9. **Why not trust train accuracy?** The model optimised it directly.
10. **Overfit vs distribution shift?** Overfit is instability from training sample; shift is changed deployment distribution—both need diagnosis.

## 17. Practice Tasks

1. Fit polynomial regressions of degrees 1–15; plot train/CV RMSE.
2. Train a tree at depths 1–30 and find the validation optimum.
3. Add L2 regularisation and compare gaps.
4. Create a deliberate ID leakage feature and explain the unrealistic score.
5. Implement PyTorch early stopping with a best-checkpoint restore.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Learning-curve diagnostic | Recommends high-bias/high-variance actions | sklearn, matplotlib; UCI | Shows debugging ability. |
| Regularised image classifier | Compares augmentation/dropout/weight decay | PyTorch; CIFAR-10 | Demonstrates deep-learning discipline. |
| Leakage detector | Flags suspicious feature availability and IDs | pandas, sklearn; synthetic + tabular | Strong ML-engineering story. |

## 19. Quick Revision

Key idea: memorises noise, fails unseen rows. Formula: error = bias² + variance + noise; overfit is high variance. Use validation curves. Trap: leakage and shift can mimic it. One-liner: “Optimise training loss, but choose capacity by held-out loss.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Excessive fit to training-specific signal/noise. |
| Input/output | train/validation curves → capacity/regularisation decision. |
| Main steps | detect gap → verify split → regularise/simplify/add data → retest. |
| Key hyperparameters | depth, \(\lambda\), dropout, epochs, learning rate. |
| Metrics | Train-vs-validation loss/metric, learning curves. |
| Pros / cons of fixes | Regularisation is cheap / may create underfitting if excessive. |
| Best use | A universal diagnostic, not a model. |

---

# Underfitting

## 1. Overview

Underfitting occurs when a model is too simple, insufficiently trained, poorly represented, or over-regularised to capture the usable structure in either training or unseen data. Both training and validation performance are poor. It is as important as overfitting because blindly adding regularisation can make a weak model worse.

## 2. Intuition

Trying to approximate a winding road with one straight line misses even the points you were shown. The issue is not memorisation; it is that the rule is too crude.

## 3. Prerequisites

Loss/metrics, model capacity, feature engineering, optimisation, regularisation, and learning curves.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| High bias | Systematic approximation error. | Linear model for a nonlinear target without features. |
| Capacity shortage | Too few parameters/depth/features. | Stump for complex fraud patterns. |
| Optimisation underfit | Model could fit but training failed. | Learning rate too low or too few epochs. |
| Representation underfit | Inputs omit predictive signal. | Predicting demand without calendar/weather features. |
| Excess regularisation | Penalty suppresses useful patterns. | Huge ridge alpha drives weights near zero. |

## 5. Algorithm / Working Process

Establish a valid baseline and inspect train and validation metrics. If both are poor and close, test whether the problem is capacity, optimisation, representation, labels, or metric/target definition. Increase useful capacity or features, train long enough, reduce excessive regularisation, and compare with a stronger baseline using the same split.

## 6. Mathematical Foundation

For squared error, bias at \(x\) is
\[
\operatorname{Bias}(x)=\mathbb E_D[\hat f_D(x)]-f(x).
\]

High bias contributes \(\operatorname{Bias}^2\) to expected test MSE. In regularised fitting, excessively large \(\lambda\) in \(\min \text{empirical loss}+\lambda||\theta||^2\) constrains parameters so strongly that training loss itself remains high.

## 7. Practical Implementation

```python
from sklearn.model_selection import learning_curve
from sklearn.linear_model import Ridge

sizes, train_s, val_s = learning_curve(Ridge(alpha=1e4), X, y, cv=5,
                                        scoring="neg_root_mean_squared_error",
                                        train_sizes=[.2, .5, .8, 1.0])
print("train RMSE:", -train_s.mean(axis=1))
print("valid RMSE:", -val_s.mean(axis=1))  # Compare with a lower alpha or nonlinear pipeline using the same CV.
```

## 8. Code Explanation

`learning_curve` trains on increasing fractions. Persistently high and similar train/validation RMSE suggests high bias. The intentionally large `alpha` illustrates over-regularisation; compare candidates through CV rather than guessing.

## 9. Training / Evaluation

Check data quality, target construction, label noise, feature availability, and baseline performance first. Then add nonlinear features/models, domain features, interaction terms, training epochs, or a suitable architecture; reduce only excessive regularisation. More data alone often does not cure high bias because the model still cannot represent the pattern.

## 10. Complexity and Cost

Fixes often increase cost: deeper trees, larger embeddings, more epochs, and feature pipelines. Start with the smallest stronger baseline (e.g., gradient boosting versus a linear model) and evaluate CPU/GPU/memory impact.

## 11. Common Use Cases

Baseline diagnosis in tabular ML, weak text bag-of-words models, low-resolution vision pipelines, forecasting without seasonality, and under-trained neural networks.

## 12. Common Mistakes

* Calling every low score overfitting.
* Adding more data before checking whether train error is already high.
* Increasing capacity without verifying labels/features.
* Removing regularisation entirely and causing a later overfit.
* Comparing models with different splits or metrics.

## 13. Edge Cases / Limitations

Irreducible noise, wrong labels, unavailable future features, and an impossible target cap achievable performance. A small train–validation gap can also occur when validation is much harder due to distribution shift, so inspect data slices.

## 14. Variations

* **Model underfit:** insufficient function complexity; placement-essential.
* **Feature underfit:** representation lacks signal; project-important.
* **Optimisation underfit:** inadequate training/convergence; deep-learning-essential.
* **Regularisation underfit:** penalty/dropout/pruning too strong; common interview follow-up.

## 15. Related Topics

Overfitting is high variance; underfitting is high bias. Bias–variance trade-off chooses a balance. Learning curves diagnose both, while CV makes diagnosis less split-dependent. Feature engineering and optimisation solve different underfit causes.

## 16. Interview Questions

1. **What is underfitting?** Poor fit even on training data because useful structure is missed.
2. **How does its curve differ from overfitting?** Train and validation scores are both poor and close.
3. **How fix it?** Improve features/capacity/training or reduce excessive regularisation.
4. **Will more data always help?** Usually little for pure high bias.
5. **Can a deep model underfit?** Yes, if under-trained, badly optimised, or inputs are weak.
6. **High bias means what?** Systematic error from an overly restrictive hypothesis class.
7. **What is an underfit baseline for nonlinear data?** Plain linear regression without transformations.
8. **Could data leakage cause underfit?** Less commonly; poor preprocessing/target mismatch can.
9. **How distinguish optimisation from capacity?** Try longer/better optimisation and a known stronger model; inspect training loss.
10. **What is the risk of reducing regularisation?** It can transition to overfitting.

## 17. Practice Tasks

1. Fit linear versus polynomial regression to nonlinear synthetic data.
2. Sweep ridge `alpha` and plot CV error.
3. Add a missing seasonal feature to a demand model.
4. Train a small neural network for too few epochs, then correct it.
5. Build a diagnostic checklist for low train and validation F1.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Demand baseline ladder | Adds calendar/weather features stepwise | pandas, sklearn; bike sharing | Shows feature-engineering reasoning. |
| Curve-based diagnosis tool | Labels high-bias/high-variance patterns | sklearn, matplotlib | Demonstrates ML debugging. |
| NLP representation study | Compares TF-IDF, embeddings, transformer | sklearn/PyTorch; sentiment data | Shows representation trade-offs. |

## 19. Quick Revision

Key idea: too simple or insufficiently trained to fit even train data. Formula: high \(\text{Bias}^2\). Use learning curves. Trap: more data rarely fixes pure bias. One-liner: “If training error is bad, first improve what the model can learn.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | High-bias failure to learn available structure. |
| Input/output | learning curves + baselines → capacity/feature/training action. |
| Main steps | validate data → inspect train/val → strengthen representation/fit. |
| Key hyperparameters | model size/depth, epochs, LR, regularisation. |
| Metrics | Both train and validation loss/score. |
| Pros / cons of fixes | More capacity captures patterns / can cause overfit/cost. |
| Best use | Universal model-diagnosis concept. |

---

# Bias-Variance Tradeoff

## 1. Overview

The bias–variance trade-off explains why expected test error can worsen when a model is either too simple or too sensitive to its training sample. It guides capacity, regularisation, data-collection, and ensembling decisions. It is most exact for squared-error regression but remains a useful qualitative tool for classification and deep learning.

## 2. Intuition

Ask many students to draw a curve through noisy points. A ruler gives nearly the same wrong line each time (high bias, low variance); a wiggly curve changes dramatically with every sample (low bias, high variance). A useful model balances both.

## 3. Prerequisites

Expectation, variance, MSE, noise, sampling, model capacity, regularisation, and train/validation curves.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Bias | Average systematic error of models trained on many datasets. | Linear fit to a quadratic truth. |
| Variance | Sensitivity of model predictions to the sampled training data. | Deep trees change after a few rows change. |
| Irreducible noise | Random outcome variation no model can predict from \(X\). | Measurement noise. |
| Regularisation | Trades a little bias for lower variance. | Ridge shrinks unstable coefficients. |
| Ensembles | Often reduce variance by averaging diverse models. | Random forest vs one tree. |

## 5. Algorithm / Working Process

Treat the trade-off as a diagnostic loop: create a valid validation/CV protocol; compare simple and flexible models; inspect train and validation learning curves; add capacity when bias dominates; regularise, gather data, or average models when variance dominates; select by held-out metric and operating cost.

## 6. Mathematical Foundation

For \(Y=f(X)+\epsilon\), with \(\mathbb E[\epsilon]=0\) and \(\operatorname{Var}(\epsilon)=\sigma^2\),
\[
\mathbb E_{D,\epsilon}[(Y-\hat f_D(X))^2]
=\underbrace{(f(X)-\mathbb E_D[\hat f_D(X)])^2}_{\text{bias}^2}
+\underbrace{\mathbb E_D[(\hat f_D(X)-\mathbb E_D[\hat f_D(X)])^2]}_{\text{variance}}
+\underbrace{\sigma^2}_{\text{noise}}.
\]

For an average of \(M\) identically distributed estimators with variance \(v\) and pairwise correlation \(\rho\), ensemble variance is approximately \(v[\rho+(1-\rho)/M]\). Diversity matters as much as number of models.

## 7. Practical Implementation

```python
from sklearn.model_selection import cross_val_score
from sklearn.tree import DecisionTreeRegressor

for depth in (1, 3, 6, None):
    model = DecisionTreeRegressor(max_depth=depth, random_state=42)
    rmse = -cross_val_score(model, X, y, cv=5, scoring="neg_root_mean_squared_error")
    print(depth, "CV RMSE", rmse.mean(), "spread", rmse.std())
```

## 8. Code Explanation

Depth controls tree capacity. Small depths tend toward bias; unlimited depth tends toward variance. CV RMSE identifies the useful compromise, while its standard deviation hints at split sensitivity.

## 9. Training / Evaluation

Low train and validation performance: reduce bias with features/capacity/better optimisation. Strong train but weak validation: reduce variance with regularisation, data, augmentation, pruning, dropout, or bagging. Validate each change; a lower bias model is not automatically better if its validation score falls.

## 10. Complexity and Cost

Reducing bias via richer models may increase training/inference compute. Variance reduction through bagging/ensembles multiplies training and model memory but can parallelise. Regularisation is often the cheapest first intervention.

## 11. Common Use Cases

Choosing tree depth, polynomial degree, neural-network size, ridge/lasso strength, random-forest size, dropout rate, and amount of training data.

## 12. Common Mistakes

* Treating bias as the training-set bias of one fitted model rather than an expectation over datasets.
* Assuming more complex always means better.
* Ignoring data leakage or shift, which the decomposition does not repair.
* Equating CV fold standard deviation exactly with model variance.
* Forgetting irreducible label/measurement noise.

## 13. Edge Cases / Limitations

The textbook decomposition is exact under squared loss and particular expectations; classification and modern deep networks need more care. Double descent can break the simple U-shaped story. The framework is diagnostic, not a formula that chooses every hyperparameter automatically.

## 14. Variations

* **Regularisation path:** sweep penalty/capacity; placement-essential.
* **Bagging:** average unstable learners to reduce variance; random forest is key.
* **Boosting:** often lowers bias, may overfit without regularisation; placement-important.
* **Data augmentation:** increases effective data diversity; deep-learning-essential.

## 15. Related Topics

Underfitting maps to high bias and overfitting maps to high variance. K-fold CV measures candidate performance reliably. Bootstrap can empirically study estimator variability. Regularisation, pruning, dropout, bagging, and boosting are practical levers.

## 16. Interview Questions

1. **State the decomposition.** Expected MSE = bias² + variance + irreducible noise.
2. **What is high bias?** Consistent systematic error from restrictive assumptions.
3. **What is high variance?** Predictions change strongly with training sample.
4. **How does ridge affect it?** Usually increases bias slightly and lowers variance.
5. **Why does random forest help?** Averages decorrelated high-variance trees.
6. **Does more data affect bias?** Usually variance more than approximation bias.
7. **What is irreducible error?** Outcome randomness/unobserved information unavailable in features.
8. **How diagnose from curves?** Both poor = bias; train good/val poor = variance.
9. **Can boosting reduce variance?** With regularisation/subsampling it can; its primary intuition is sequential bias reduction.
10. **Does the formula hold unchanged for accuracy?** No; it is most direct for squared loss.

## 17. Practice Tasks

1. Repeatedly sample synthetic data and visualise variance of linear and tree fits.
2. Sweep polynomial degree and plot train/CV MSE.
3. Compare one tree with a random forest.
4. Sweep ridge/lasso regularisation path.
5. Add noise and observe the nonzero error floor.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Bias–variance visual lab | Interactive capacity/noise simulations | NumPy, matplotlib/Streamlit | Excellent conceptual portfolio piece. |
| Tree-to-forest benchmark | Compares variance and calibration | sklearn; house/fraud data | Demonstrates model-choice reasoning. |
| Regularisation study | Documents lasso/ridge/elastic-net trade-offs | sklearn; gene-expression-like data | Shows statistical ML literacy. |

## 19. Quick Revision

Key idea: choose complexity that generalises. Formula: MSE = bias² + variance + noise. Use learning curves/CV. Trap: formula does not excuse leakage or shift. One-liner: “Regularisation deliberately buys a bit of bias to avoid brittle variance.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Framework for expected-error sources across training samples. |
| Input/output | candidate capacities → held-out error trade-off. |
| Main steps | diagnose curves → adjust capacity/regularisation/data → validate. |
| Key hyperparameters | depth, degree, \(\lambda\), dropout, ensemble size. |
| Metrics | CV loss, train–validation gap, calibration/task metric. |
| Pros / cons | Clear diagnostic / simplified outside squared-loss setting. |
| Best use | Capacity and regularisation decisions. |

---

# Nested Cross-Validation

## 1. Overview

Nested cross-validation uses an outer CV loop to estimate generalisation and an inner CV loop to tune hyperparameters or choose a model. It prevents the common optimistic mistake of reporting the same CV score that selected the best among many candidates. It is especially useful for small research datasets and rigorous model comparison.

## 2. Intuition

Each outer fold is a sealed final exam. Inside the remaining material, you run mock exams to choose study strategy. Only after strategy is fixed do you open that outer exam. Repeat so every portion serves as a sealed exam once.

## 3. Prerequisites

K-fold CV, validation/model selection, hyperparameter search, pipelines, metrics, and computational budgeting.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Outer loop | Evaluation folds never seen by tuning. | Produces honest scores for the full selection procedure. |
| Inner loop | CV only within each outer-training partition. | Chooses `C`, depth, feature set, etc. |
| Selection bias | Best of many noisy inner scores is optimistic. | Nested CV isolates it. |
| Final refit | After evaluation, tune on all data and fit deployment model. | This final model has no single outer score. |

## 5. Algorithm / Working Process

1. Choose outer splitter (e.g., stratified 5-fold) matching data structure.
2. For outer fold \(j\), hold out \(O_j\).
3. Run `GridSearchCV`/inner CV only on \(D\setminus O_j\); select \(\lambda_j^*\).
4. Fit that selected pipeline on the entire outer-training portion and score only \(O_j\).
5. Average outer scores. For deployment, perform one tuning search on all development data, then refit; evaluate an external test set if available.

## 6. Mathematical Foundation

The inner selector is
\[
\lambda_j^*=\arg\min_{\lambda\in\Lambda}\widehat R_{inner}(\lambda;D\setminus O_j).
\]
The estimate is the outer loss of the *selection algorithm*:
\[
\widehat R_{nested}=\frac1K\sum_{j=1}^K R(O_j,\hat f_{\lambda_j^*,D\setminus O_j}).
\]

Unlike non-nested CV, no outer example contributes to its own hyperparameter choice.

## 7. Practical Implementation

```python
from sklearn.model_selection import GridSearchCV, StratifiedKFold, cross_val_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

pipe = make_pipeline(StandardScaler(), LogisticRegression(max_iter=2000))
inner = StratifiedKFold(3, shuffle=True, random_state=1)
outer = StratifiedKFold(5, shuffle=True, random_state=42)
search = GridSearchCV(pipe, {"logisticregression__C": [0.01, 0.1, 1, 10]}, cv=inner, scoring="roc_auc")
scores = cross_val_score(search, X, y, cv=outer, scoring="roc_auc")
print("nested AUC:", scores.mean(), "+/-", scores.std())
```

## 8. Code Explanation

`cross_val_score` treats the entire `GridSearchCV` object as the estimator. In each outer fold, `search` performs its inner tuning using only outer-training rows. The output is an outer-fold estimate—not the optimistic best `search.best_score_` from a single full-data search.

## 9. Training / Evaluation

Use a small, justified search space to control cost. Put preprocessing, feature selection, resampling, and estimator in one pipeline. Select outer and inner splitters that respect labels/groups/time. If a real final test set exists, nested CV can be used for development selection and the final test remains the deployment audit.

## 10. Complexity and Cost

With \(K_o\) outer folds, \(K_i\) inner folds, and \(m\) candidates, cost is about \(K_oK_im\) fits, plus outer refits: \(O(K_oK_imC_{fit})\). It is often unsuitable for large deep models without reduced search/compute.

## 11. Common Use Cases

Small biomedical datasets, benchmark papers, algorithm comparisons, feature-selection pipelines, and tabular projects where reported performance must include tuning uncertainty.

## 12. Common Mistakes

* Calling a single `GridSearchCV.best_score_` an unbiased final score.
* Running feature selection or scaling outside inner folds.
* Using different split logic for inner and outer data when groups/time require protection.
* Reporting inner score instead of outer score.
* Forgetting the cost explosion from large grids.

## 13. Edge Cases / Limitations

Outer scores are still correlated and may be unstable for tiny minority classes. Nested CV does not solve domain shift or bad labels. It may be overkill for massive data with a large independent validation/test set, and deep-learning searches can be prohibitively expensive.

## 14. Variations

* **Nested K-fold:** usual approach; placement/research-important.
* **Nested stratified/group CV:** choose matching splitters; essential for classification/entities.
* **Nested time-series CV:** expanding temporal outer/inner windows; forecasting-important.
* **Repeated nested CV:** more stable but extremely costly; research only.

## 15. Related Topics

Validation sets and inner CV select a configuration. Outer CV acts like repeatedly rotated test sets. K-fold is the building block. Bootstrap can quantify uncertainty differently. Hyperparameter optimisation must remain entirely inside the inner loop.

## 16. Interview Questions

1. **Why nested CV?** To estimate performance after hyperparameter/model selection without selection bias.
2. **What happens in the inner loop?** Tune candidates using only outer-training data.
3. **What does outer CV measure?** The end-to-end model-selection procedure’s generalisation.
4. **Why is ordinary GridSearchCV score optimistic?** It is the maximum/minimum among tuned noisy validation estimates.
5. **How many fits for 5 outer, 3 inner, 10 candidates?** Roughly 150 candidate fits plus outer refits.
6. **Should scaling be outside nested CV?** No; include it in pipeline.
7. **Does nested CV replace external testing?** It is strong internal validation; external/temporal tests are still better for deployment claims.
8. **Can we use it with groups?** Yes, use compatible group-aware splitters and pass groups.
9. **Which score report?** Mean and spread of outer scores.
10. **When avoid it?** Huge data/expensive deep models when a stable independent holdout exists.

## 17. Practice Tasks

1. Compare non-nested and nested grid-search AUC on a small dataset.
2. Put PCA and feature selection inside the nested pipeline.
3. Count model fits for grid versus random search.
4. Use `GroupKFold` as outer splitter on repeated patient rows.
5. Save per-outer-fold chosen hyperparameters and study their stability.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Biomedical model comparison | Nested-CV compares pipelines honestly | sklearn; UCI/omics data | Research-grade evaluation signal. |
| Feature-selection study | Measures selection stability per outer fold | sklearn; gene-expression data | Demonstrates leakage-safe pipeline work. |
| Tuning-cost calculator | Estimates grid-search compute and suggests budgets | Python, sklearn | Shows ML platform pragmatism. |

## 19. Quick Revision

Key idea: inner selects, outer evaluates. Formula: average outer loss after inner \(\arg\min\). Use for rigorous tuning evaluation on limited data. Trap: report outer, not inner score. One-liner: “Nested CV validates the tuning process, not merely its winner.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | CV within CV to isolate model selection from evaluation. |
| Input/output | data + search + splitters → outer mean/spread. |
| Main steps | outer holdout → inner tune → outer score → aggregate. |
| Key hyperparameters | outer/inner folds, splitter, search space, metric. |
| Pros / cons | Honest internal estimate / very expensive. |
| Best use | Small datasets, benchmark/research model comparison. |

---

# Time-Series Validation

## 1. Overview

Time-series validation preserves temporal causality: train only on the past and validate on the future. Random CV is invalid for forecasting, demand, finance, telemetry, and event prediction because it allows future patterns to influence the past. The split design must also include realistic feature availability and forecast horizon.

## 2. Intuition

You cannot use tomorrow’s weather report to decide whether today’s demand forecast was good. Every simulated prediction must only know what would have been available at that timestamp.

## 3. Prerequisites

Train/test split, timestamps, lags, forecasting horizon, concept drift, leakage, and time-dependent features.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Temporal order | Train timestamps precede validation timestamps. | Never shuffle weekly sales. |
| Forecast horizon | Distance into future predicted. | One-day vs 30-day horizon have different difficulty. |
| Expanding window | Training history grows each split. | Suitable when old data remains relevant. |
| Sliding window | Fixed recent training window. | Suitable under drift/seasonal regime changes. |
| Gap/embargo | Exclude rows around boundary. | Prevent lag/label overlap leakage. |
| Walk-forward backtest | Repeated historical future simulations. | Main forecasting evaluation protocol. |

## 5. Algorithm / Working Process

1. Sort by timestamp and define deployment cutoff, horizon, and feature-availability time.
2. Reserve the latest period as final test.
3. Create sequential folds: train up to \(t_j\), validate \((t_j,t_j+h]\); optionally leave a gap.
4. For each fold, build features/scalers from past training rows only, fit, and forecast the next window.
5. Aggregate errors by fold, horizon, season, and recent period; refit on all allowed historical data for deployment.

## 6. Mathematical Foundation

For origins \(t_1,\dots,t_K\) and horizon \(h\), a walk-forward estimate is
\[
\widehat R=\frac{1}{K}\sum_{j=1}^K\frac1h\sum_{r=1}^{h} L(y_{t_j+r},\hat y_{t_j+r\mid t_j}).
\]

MAE is \(h^{-1}\sum|y-\hat y|\); RMSE is \(\sqrt{h^{-1}\sum(y-\hat y)^2}\). MAPE \(=100h^{-1}\sum |(y-\hat y)/y|\) is undefined or unstable near zero; use MAE, sMAPE, WAPE, or scaled errors when appropriate.

## 7. Practical Implementation

```python
from sklearn.model_selection import TimeSeriesSplit, cross_val_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Ridge

# X must already contain only features available at prediction time, sorted by time.
cv = TimeSeriesSplit(n_splits=5, test_size=30, gap=1)
model = make_pipeline(StandardScaler(), Ridge(alpha=1.0))
mae = -cross_val_score(model, X, y, cv=cv, scoring="neg_mean_absolute_error")
print("walk-forward MAE:", mae.mean(), "+/-", mae.std())
```

## 8. Code Explanation

`TimeSeriesSplit` makes each training fold earlier than its test fold. `test_size=30` evaluates a 30-row forecast block; it should correspond to the business horizon/granularity. `gap=1` removes boundary rows when features or labels overlap. You must create lag features using only past observations.

## 9. Training / Evaluation

Evaluate naive baselines (last value, seasonal last value) first. Match backtest folds to retraining cadence and horizon. Diagnose errors by horizon and regime, and monitor drift after deployment. For panel data, ensure each series’ history is available and prevent cross-entity future leakage. Tune only on historical training windows.

## 10. Complexity and Cost

Expanding-window CV refits \(K\) times on growing datasets, roughly \(O(\sum_j C_{fit}(n_j))\). Feature generation for many lags can dominate memory. Classical models are CPU-friendly; deep sequence models often need GPUs.

## 11. Common Use Cases

Retail demand, energy load, stock/financial risk (with strong caution), server metrics, traffic, predictive maintenance, churn/event models whose features evolve over time.

## 12. Common Mistakes

* Randomly shuffling temporal rows.
* Using a feature created with future data, global normalisation, or centred rolling windows.
* Testing one-step ahead while deployment requires 30 steps.
* Ignoring retraining schedule and data latency.
* Using MAPE with zeros or comparing only aggregate error across very different scales.

## 13. Edge Cases / Limitations

Nonstationarity, rare events, long seasonal cycles, few historical folds, and changed policies make backtests uncertain. TimeSeriesSplit alone does not generate lags, manage multiple series, or guarantee feature point-in-time correctness. It cannot validate unseen geographic/product entities without an additional entity split.

## 14. Variations

* **Expanding window:** uses all prior history; placement-essential.
* **Rolling/sliding window:** fixed history; use under drift.
* **Blocked holdout:** one past/future split; cheap final audit.
* **Purged CV with embargo:** removes overlapping labels in finance; advanced/research-important.
* **Rolling-origin multi-horizon:** evaluates each required horizon; forecasting-essential.

## 15. Related Topics

Train/test splitting becomes chronological. K-fold’s arbitrary rotation is replaced by forward splits. Group CV may be combined for panels. Drift monitoring, feature stores with point-in-time joins, and lag engineering are core MLOps connections.

## 16. Interview Questions

1. **Why is random CV wrong for time series?** Future observations can influence training, yielding look-ahead bias.
2. **What is walk-forward validation?** Repeatedly train on past data and evaluate the next future window.
3. **Expanding vs rolling window?** Growing history vs fixed recent history; choose based on relevance/drift.
4. **What is forecast horizon?** How far ahead predictions are needed; validation must match it.
5. **What is look-ahead leakage?** A feature/transform uses information not available at prediction time.
6. **Why use a gap?** To prevent overlap from lags, labels, or delayed information around a boundary.
7. **What baseline should be included?** Naive and seasonal-naive forecasts.
8. **Why can MAPE be bad?** Zero/near-zero targets explode percentage error.
9. **How select a final test?** Latest realistic period, untouched during modelling.
10. **Can old data hurt?** Yes under drift; use a rolling window or weighting.

## 17. Practice Tasks

1. Compare random KFold and TimeSeriesSplit on sales data; explain the gap.
2. Build leakage-safe lag and rolling features.
3. Backtest naive, ridge-lag, and seasonal-naive models.
4. Compare expanding and 90-day rolling windows after a regime change.
5. Evaluate MAE separately at horizons 1, 7, and 28.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Demand forecaster | Walk-forward backtesting with horizons | pandas, sklearn; M5/Rossmann | Strong forecasting + leakage awareness. |
| Energy-load monitor | Detects drift and schedules retraining | Python, MLflow; energy data | MLOps-ready time-series story. |
| Latency predictor | Forecasts service metrics from lags | pandas, sklearn; public telemetry | Practical AI-engineering application. |

## 19. Quick Revision

Key idea: past trains, future validates. Formula: average loss over forward origins/horizons. Use for any temporal deployment. Trap: point-in-time feature leakage and wrong horizon. One-liner: “A backtest must simulate the information available on prediction day.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Chronological validation that preserves causality. |
| Input/output | timestamped features/targets → forward-fold forecast metrics. |
| Main steps | sort → define horizon/cutoff → backtest forward → refit. |
| Key hyperparameters | folds, horizon/test size, gap, train-window length. |
| Metrics | MAE/RMSE/WAPE/sMAPE by horizon; compare naive baseline. |
| Pros / cons | Realistic forecasting estimate / less training data, expensive. |
| Best use | Forecasting and time-dependent prediction. |

---

# Bootstrap Validation

## 1. Overview

Bootstrap validation repeatedly samples \(n\) rows **with replacement** from a dataset, fits a model on each bootstrap sample, and evaluates on rows left out of that sample (out-of-bag, OOB) or through a corrected estimator. It is valuable for uncertainty estimation, confidence intervals, small-sample analysis, and bagging methods such as random forests.

## 2. Intuition

Imagine drawing 100 lottery slips from a box of 100, returning each slip after drawing. Some slips appear multiple times and some never appear. The unseen slips form a natural mini-test set for that draw. Repeat many times to see how unstable the result is.

## 3. Prerequisites

Sampling with replacement, empirical distributions, metrics, standard error/percentiles, train/test split, and model fitting.

## 4. Core Concepts

| Subtopic | Meaning and importance | Example / interview angle |
|---|---|---|
| Bootstrap sample | \(n\) draws with replacement from \(n\) rows. | Some rows repeat. |
| OOB set | Rows absent from one bootstrap sample. | About 36.8% are OOB on average. |
| Percentile interval | Quantiles of bootstrap estimates. | 2.5th–97.5th percentiles form an approximate 95% CI. |
| .632 estimator | Mixes resubstitution and OOB error. | Corrects pessimism from smaller OOB training sets. |
| Bagging | Average many bootstrap-fitted learners. | Random forests use bootstrap-like samples. |

## 5. Algorithm / Working Process

1. For \(b=1,\ldots,B\), draw \(n\) training indices with replacement.
2. Fit the complete pipeline on sampled rows only.
3. Evaluate on the OOB rows for that replicate; skip/retry only if an OOB set cannot support the metric.
4. Aggregate OOB errors and optionally create percentile intervals.
5. For deployment, fit a final model on all development data; keep an external test set where possible.

## 6. Mathematical Foundation

The chance a particular row is never selected in \(n\) draws is
\[
\left(1-\frac1n\right)^n\to e^{-1}\approx0.368,
\]
so each bootstrap training sample contains about 63.2% unique rows. Let \(E_{resub}\) be training/resubstitution error and \(E_{OOB}\) be OOB error. The .632 estimate is
\[
E_{.632}=0.368E_{resub}+0.632E_{OOB}.
\]

For a statistic \(T\), bootstrap standard error is \(\operatorname{SE}_{boot}(T)=\sqrt{\sum_{b=1}^B(T_b-\bar T)^2/(B-1)}\); percentile intervals use empirical quantiles of \(T_b\).

## 7. Practical Implementation

```python
import numpy as np
from sklearn.base import clone
from sklearn.metrics import roc_auc_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import LogisticRegression

rng, B, oob_auc = np.random.default_rng(42), 200, []
base = make_pipeline(StandardScaler(), LogisticRegression(max_iter=2000))
for _ in range(B):
    idx = rng.integers(0, len(y), len(y))          # sample with replacement
    oob = np.setdiff1d(np.arange(len(y)), np.unique(idx))
    if len(np.unique(y[oob])) == 2:                # AUC needs both classes
        model = clone(base).fit(X[idx], y[idx])
        oob_auc.append(roc_auc_score(y[oob], model.predict_proba(X[oob])[:, 1]))
print("OOB AUC mean/95% interval:", np.mean(oob_auc), np.percentile(oob_auc, [2.5, 97.5]))
```

## 8. Code Explanation

`rng.integers` creates a same-size sample with duplicates. `np.unique(idx)` identifies included rows; its complement is OOB. `clone` ensures each replicate starts unfitted. The class check avoids undefined binary AUC on an OOB set with one class; stratified bootstrap can reduce this issue in severe imbalance.

## 9. Training / Evaluation

Choose enough replicates for stable intervals (often 200–1,000; inspect convergence). Bootstrap the *entire pipeline*, not just the estimator after globally fitted preprocessing. Use stratified, group, or block bootstrap when IID row resampling is invalid. Report intervals alongside point metrics, but retain a chronological/external test set for deployment validity.

## 10. Complexity and Cost

Cost is \(B\) fits: \(O(BC_{fit})\); memory can remain near one model plus score list when processed sequentially. It parallelises naturally. Large \(B\), complex models, and high-dimensional data can be expensive; CPU suffices for most classical estimators.

## 11. Common Use Cases

Confidence intervals for AUC/accuracy/MAE, coefficient stability, small clinical datasets, out-of-bag estimates in random forests, and bagged ensembles.

## 12. Common Mistakes

* Sampling without replacement (that is a subsample, not bootstrap).
* Evaluating only on repeated training rows and calling it generalisation.
* Bootstrapping IID rows in time series or clustered patient data.
* Ignoring OOB folds with missing minority classes.
* Treating percentile intervals as guaranteed valid under severe bias/dependence.

## 13. Edge Cases / Limitations

Tiny or highly imbalanced datasets yield unstable OOB metrics. Non-IID data need block/group bootstrap. A bootstrap sample has only 63.2% unique rows, so its OOB estimate can differ from a full-data deployment fit. It is computationally demanding for deep nets and does not automatically handle distribution shift.

## 14. Variations

* **OOB bootstrap:** evaluate omitted rows; core concept/placement-important.
* **.632 / .632+:** combines resubstitution and OOB to correct bias; statistics/research-important.
* **Stratified bootstrap:** resample within class; use for imbalance.
* **Block bootstrap:** resample contiguous blocks; use for autocorrelation/time series.
* **Bayesian bootstrap:** random weights rather than resampled rows; advanced research.

## 15. Related Topics

Cross-validation partitions rows without replacement; bootstrap resamples with replacement and is stronger for uncertainty estimation. Random forest uses bootstrap samples plus feature randomness to reduce variance. Bias–variance explains why bagging works; time-series validation demands block bootstrap rather than independent rows.

## 16. Interview Questions

1. **What is bootstrap validation?** Repeated fit/evaluation using samples drawn with replacement.
2. **What percentage is OOB?** Approximately \(e^{-1}\approx36.8\%\).
3. **Why 63.2% unique rows?** A row is selected at least once with probability \(1-(1-1/n)^n\). 
4. **Bootstrap vs K-fold CV?** Replacement/resampling and uncertainty intervals versus disjoint rotating folds.
5. **What is .632 bootstrap?** \(0.368\) training error + \(0.632\) OOB error.
6. **Why can OOB AUC fail?** An OOB set may contain one class.
7. **How does random forest use it?** Each tree trains on a bootstrap sample; OOB rows estimate ensemble error.
8. **Can bootstrap handle time series?** Only with block/dependent bootstrap, not naive row resampling.
9. **How form a 95% CI?** Use 2.5th and 97.5th bootstrap percentiles, with assumptions/caveats.
10. **Does bootstrap replace an external test?** No; it estimates internal uncertainty, not domain shift.

## 17. Practice Tasks

1. Verify empirically that OOB fraction approaches 36.8%.
2. Bootstrap AUC and draw a percentile interval.
3. Compare 5-fold CV and OOB-bootstrap score distributions.
4. Bootstrap regression coefficients and plot their stability.
5. Implement a block bootstrap for autocorrelated daily sales.

## 18. Project Ideas

| Project | What it does | Stack / data | Resume value |
|---|---|---|---|
| Clinical-metric uncertainty | Reports AUC with bootstrap interval | sklearn; breast cancer | Shows statistically responsible reporting. |
| Feature-stability report | Bootstraps lasso coefficients | sklearn, pandas; genomics/tabular | Strong explainability/reliability project. |
| OOB forest monitor | Compares OOB and held-out performance | sklearn; churn/credit data | Connects validation to ensemble methods. |

## 19. Quick Revision

Key idea: resample rows with replacement to measure stability. Formula: OOB probability \((1-1/n)^n\to e^{-1}\). Use for uncertainty/OOB ensembles. Trap: IID assumption and small OOB minority counts. One-liner: “Bootstrap asks how the result changes if the observed dataset were sampled again.”

## 20. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Repeated replacement resampling with OOB evaluation. |
| Input/output | dataset + \(B\) replicates → metric distribution/interval. |
| Main steps | sample → fit pipeline → score OOB → aggregate quantiles. |
| Key hyperparameters | `B`, sampling scheme, metric, seed, block length. |
| Metrics | OOB loss/AUC/MAE, bootstrap SE and percentile interval. |
| Pros / cons | Quantifies uncertainty / \(B\) fits and IID-sensitive. |
| Best use | Small-sample uncertainty, stability, bagging/OOB analysis. |
