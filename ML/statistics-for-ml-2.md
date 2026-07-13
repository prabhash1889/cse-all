# Statistics for ML — Inference, Experimentation, and Causality

This guide is for ML placements, AI engineering roles, research internships, and projects. It separates **estimation**, **hypothesis testing**, and **causal effects**. Examples use Python 3 with NumPy, SciPy, pandas, and scikit-learn.

---

# Confidence Interval

## 1. Overview

A confidence interval (CI) is a range of plausible population values around an estimate. In ML it makes accuracy, conversion lift, latency, and regression estimates honest about sampling noise.

## 2. Intuition

Repeated samples give different intervals. A 95% CI procedure covers the fixed truth in about 95% of repeated samples; it is not a 95% posterior probability for one computed interval.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Point estimate: a sample mean/proportion targeting a population parameter.
* Standard error (SE): sampling spread, often `s / sqrt(n)`; it determines precision.
* Confidence level: long-run coverage target; higher confidence means a wider interval.
* Margin of error: critical value times SE; it decreases only as `1 / sqrt(n)`.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

Mean CI: `x_bar ± t_(n-1, 1-alpha/2) * s / sqrt(n)`. Use z only with known variance or a justified large-sample approximation.

## 7. Practical Implementation

```python
from scipy import stats
import numpy as np
x = np.array([3.1, 2.9, 3.4, 3.0, 3.2])
se = x.std(ddof=1) / np.sqrt(len(x))
q = stats.t.ppf(.975, len(x) - 1)
print(x.mean() - q * se, x.mean() + q * se)
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

A/B lift, model-metric uncertainty, forecast error, mean latency, and regression coefficients.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Wilson intervals are safer for rare binary rates. Bootstrap CIs work for medians, F1, and other complex metrics. Bayesian credible intervals condition on a prior.

## 15. Related Topics

CIs are dual to two-sided hypothesis tests; the CLT motivates normal approximations and bootstrap estimates uncertainty without a closed-form SE.

## 16. Interview Questions

1. **What is Confidence Interval?** A confidence interval (CI) is a range of plausible population values around an estimate.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** Mean CI: `x_bar ± t_(n-1, 1-alpha/2) * s / sqrt(n)`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Confidence Interval from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Confidence Interval analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Repeated samples give different intervals. A 95% CI procedure covers the fixed truth in about 95% of repeated samples; it is not a 95% posterior probability for one computed interval. Main formula: Mean CI: `x_bar ± t_(n-1, 1-alpha/2) * s / sqrt(n)`. Use z only with known variance or a justified large-sample approximation. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Confidence Interval |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | A/B lift, model-metric uncertainty, forecast error, mean latency, and regression coefficients. |


---

# Central Limit Theorem

## 1. Overview

The central limit theorem (CLT) says that means or sums of many independent finite-variance observations are approximately normal. It underlies standard errors, CIs, tests, and MLE uncertainty.

## 2. Intuition

Individual purchases may be right-skewed, but averages of many independent purchases look bell-shaped because highs and lows cancel.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Sampling distribution: distribution of a statistic over repeated samples, not the raw data distribution.
* Standardization: subtract its mean and divide by its SE.
* Finite variance: required by the classical theorem; extreme heavy tails can fail.
* Effective sample size: correlation means n rows may carry far less than n independent observations.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

`sqrt(n) * (x_bar - mu) / sigma -> N(0,1)`. Therefore `x_bar` is approximately `N(mu, sigma^2/n)`; no universal rule says n=30 is always sufficient.

## 7. Practical Implementation

```python
import numpy as np
rng = np.random.default_rng(0)
means = rng.exponential(1, size=(10_000, 50)).mean(axis=1)
print(means.mean(), means.std(), 1 / np.sqrt(50))
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Approximate inference, aggregate monitoring, sample-size planning, SGD-gradient reasoning, and MLE confidence intervals.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Multivariate CLT handles vectors such as gradients. The delta method handles smooth transforms/ratios. Block CLTs and block bootstrap address time dependence.

## 15. Related Topics

The law of large numbers gives convergence; the CLT gives an approximate distribution and rate. It supports z-tests, t-tests, and asymptotic MLE theory.

## 16. Interview Questions

1. **What is Central Limit Theorem?** The central limit theorem (CLT) says that means or sums of many independent finite-variance observations are approximately normal.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** `sqrt(n) * (x_bar - mu) / sigma -> N(0,1)`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Central Limit Theorem from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Central Limit Theorem analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Individual purchases may be right-skewed, but averages of many independent purchases look bell-shaped because highs and lows cancel. Main formula: `sqrt(n) * (x_bar - mu) / sigma -> N(0,1)`. Therefore `x_bar` is approximately `N(mu, sigma^2/n)`; no universal rule says n=30 is always sufficient. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Central Limit Theorem |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Approximate inference, aggregate monitoring, sample-size planning, SGD-gradient reasoning, and MLE confidence intervals. |


---

# Z-Test and t-Test

## 1. Overview

Z-tests and t-tests test claims about means; large-sample z-tests also cover proportions. A t-test estimates variance from data, while a z-test assumes known variance or uses a valid asymptotic approximation.

## 2. Intuition

Ask how many standard errors separate the observed effect from the null. A 4-SE difference is much less compatible with 'no effect' than a 0.2-SE difference.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Null and alternative: choose the scientific claim and tail before observing results.
* Test statistic: observed effect divided by its null SE.
* p-value: probability, under H0, of this-or-more-extreme data; not `P(H0 | data)`.
* Power: chance to detect a specified real effect; it is tied to sample size and noise.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

One-sample t: `t=(x_bar-mu0)/(s/sqrt(n))`. Welch two-sample t: `(x_bar1-x_bar2)/sqrt(s1^2/n1+s2^2/n2)` with approximate degrees of freedom.

## 7. Practical Implementation

```python
from scipy import stats
control = [10, 11, 9, 10, 12]
treatment = [12, 13, 11, 12, 14]
r = stats.ttest_ind(treatment, control, equal_var=False)
print(r.statistic, r.pvalue)  # Welch t-test
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Two-group A/B outcomes, latency regressions, paired model scores, and scientific measurements.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Paired t-tests use within-pair differences for before/after or same-test-set comparisons. Welch is the unequal-variance default. Permutation tests help with unusual metrics.

## 15. Related Topics

CIs express the same two-sided conclusion; ANOVA generalizes mean tests to more groups; A/B testing adds randomization and power planning.

## 16. Interview Questions

1. **What is Z-Test and t-Test?** Z-tests and t-tests test claims about means; large-sample z-tests also cover proportions.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** One-sample t: `t=(x_bar-mu0)/(s/sqrt(n))`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Z-Test and t-Test from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Z-Test and t-Test analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Ask how many standard errors separate the observed effect from the null. A 4-SE difference is much less compatible with 'no effect' than a 0.2-SE difference. Main formula: One-sample t: `t=(x_bar-mu0)/(s/sqrt(n))`. Welch two-sample t: `(x_bar1-x_bar2)/sqrt(s1^2/n1+s2^2/n2)` with approximate degrees of freedom. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Z-Test and t-Test |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Two-group A/B outcomes, latency regressions, paired model scores, and scientific measurements. |


---

# Chi-Square Test

## 1. Overview

Chi-square tests analyze categorical counts. Goodness-of-fit checks a target distribution; independence tests check whether two categorical variables are associated.

## 2. Intuition

If device type and conversion are independent, each table cell should be close to the count implied by its row and column totals. Large discrepancies create evidence against independence.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Observed and expected counts: expected under H0 is `row_total * column_total / grand_total`.
* Independence: detects association, never causality.
* Goodness-of-fit: compares one categorical distribution with expected proportions.
* Cramer's V: association magnitude; p-values alone exaggerate trivial large-sample effects.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

`chi2 = sum((O-E)^2/E)`. For an r-by-c independence table, `df=(r-1)(c-1)`; the approximation needs sufficiently large expected cells.

## 7. Practical Implementation

```python
import numpy as np
from scipy.stats import chi2_contingency
table = np.array([[40, 60], [70, 30]])
chi2, p, dof, expected = chi2_contingency(table)
print(chi2, p, expected)
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Categorical drift, demographic audits, survey analysis, click/conversion association, and feature screening.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Fisher's exact test is safer for small 2-by-2 tables. McNemar's test compares paired binary classifier outcomes. Residual analysis identifies responsible cells.

## 15. Related Topics

Logistic regression models categorical outcomes; mutual information is another dependence measure; binary A/B conversion may use chi-square or a two-proportion test.

## 16. Interview Questions

1. **What is Chi-Square Test?** Chi-square tests analyze categorical counts.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** `chi2 = sum((O-E)^2/E)`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Chi-Square Test from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Chi-Square Test analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: If device type and conversion are independent, each table cell should be close to the count implied by its row and column totals. Large discrepancies create evidence against independence. Main formula: `chi2 = sum((O-E)^2/E)`. For an r-by-c independence table, `df=(r-1)(c-1)`; the approximation needs sufficiently large expected cells. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Chi-Square Test |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Categorical drift, demographic audits, survey analysis, click/conversion association, and feature screening. |


---

# A/B Testing

## 1. Overview

A/B testing is a randomized controlled experiment comparing a treatment with a control. It estimates the causal effect of a product, model, prompt, or UI change on a predeclared outcome.

## 2. Intuition

Random assignment makes groups similar on average, so a post-assignment outcome gap can be attributed to the variant rather than pre-existing user differences.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Randomization: balances observed and unobserved confounders in expectation.
* Primary metric and guardrails: optimize one decision metric while protecting safety/latency/revenue.
* Sample ratio mismatch: assigned traffic should match planned allocation; mismatch can signal instrumentation bugs.
* Power/MDE: plan enough users to detect a practically meaningful effect.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

Average treatment effect estimate: `delta = mean(Y|T=1)-mean(Y|T=0)`. For conversion, use a two-proportion z-test or CI; randomization supports causal interpretation.

## 7. Practical Implementation

```python
from scipy.stats import norm
p_a, n_a, p_b, n_b = 0.10, 10_000, 0.11, 10_000
se = (p_a*(1-p_a)/n_a + p_b*(1-p_b)/n_b) ** .5
z = (p_b-p_a) / se
print('lift=', p_b-p_a, 'two-sided p=', 2*norm.sf(abs(z)))
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Ranking models, onboarding flows, ads, pricing, prompts, notification policies, and feature launches.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Sequential testing supports monitored experiments with valid stopping rules. CUPED reduces variance with pre-period covariates. Multi-armed bandits trade strict inference for adaptive allocation.

## 15. Related Topics

Hypothesis tests/CIs quantify uncertainty; causal inference explains why randomization identifies effects; ANOVA handles multiple variants.

## 16. Interview Questions

1. **What is A/B Testing?** A/B testing is a randomized controlled experiment comparing a treatment with a control.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** Average treatment effect estimate: `delta = mean(Y|T=1)-mean(Y|T=0)`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement A/B Testing from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **A/B Testing analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Random assignment makes groups similar on average, so a post-assignment outcome gap can be attributed to the variant rather than pre-existing user differences. Main formula: Average treatment effect estimate: `delta = mean(Y|T=1)-mean(Y|T=0)`. For conversion, use a two-proportion z-test or CI; randomization supports causal interpretation. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | A/B Testing |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Ranking models, onboarding flows, ads, pricing, prompts, notification policies, and feature launches. |


---

# ANOVA

## 1. Overview

Analysis of variance (ANOVA) tests whether three or more group means are all equal. It compares between-group signal with within-group noise.

## 2. Intuition

If several teaching methods truly perform equally, their group averages should differ only by normal within-class variation. ANOVA asks whether the observed spread among averages is too large for that story.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Between-group variation: movement of group means around the grand mean.
* Within-group variation: noise among members of each group.
* F statistic: ratio of between- to within-group mean squares.
* Post-hoc testing: ANOVA says at least one group differs, not which pairs differ.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

`F = MS_between / MS_within`; under H0 it follows an F distribution. One-way ANOVA assumes independent observations, normal residuals, and roughly equal variances.

## 7. Practical Implementation

```python
from scipy.stats import f_oneway
a = [8, 9, 7, 10]; b = [11, 12, 10, 13]; c = [9, 8, 10, 9]
print(f_oneway(a, b, c))
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Comparing multiple model variants, ads, dosage levels, preprocessing choices, and experimental treatments.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Welch ANOVA relaxes equal variance. Repeated-measures ANOVA handles matched subjects. Two-way ANOVA studies two factors and interactions; post-hoc Tukey controls pairwise error.

## 15. Related Topics

A t-test is two-group ANOVA. Linear regression represents ANOVA with categorical features; multiple-testing correction is essential after post-hoc comparisons.

## 16. Interview Questions

1. **What is ANOVA?** Analysis of variance (ANOVA) tests whether three or more group means are all equal.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** `F = MS_between / MS_within`; under H0 it follows an F distribution.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement ANOVA from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **ANOVA analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: If several teaching methods truly perform equally, their group averages should differ only by normal within-class variation. ANOVA asks whether the observed spread among averages is too large for that story. Main formula: `F = MS_between / MS_within`; under H0 it follows an F distribution. One-way ANOVA assumes independent observations, normal residuals, and roughly equal variances. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | ANOVA |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Comparing multiple model variants, ads, dosage levels, preprocessing choices, and experimental treatments. |


---

# Bootstrap

## 1. Overview

Bootstrap is a resampling method that estimates an estimator's sampling variability by sampling the observed dataset with replacement many times.

## 2. Intuition

Treat the observed dataset as a small stand-in population: repeatedly draw similarly sized datasets from it and see how much the statistic moves.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Resample with replacement: each bootstrap sample has n draws and duplicates.
* Bootstrap distribution: values of the statistic across resamples.
* Percentile CI: take empirical alpha/2 and 1-alpha/2 quantiles.
* Unit of resampling: resample independent users/groups, not correlated events.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

For samples `x*_(1),...,x*_(B)`, estimate SE by `sd(T(x*))`; percentile CI is `[quantile_alpha/2, quantile_1-alpha/2]`.

## 7. Practical Implementation

```python
import numpy as np
rng = np.random.default_rng(0)
x = np.array([2, 3, 3, 4, 20])
boot = [rng.choice(x, len(x), replace=True).mean() for _ in range(5000)]
print(np.quantile(boot, [.025, .975]))
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

CIs for F1/AUC/medians, model comparison, uncertainty in pipelines, and nonparametric inference.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

BCa intervals improve coverage for biased/skewed statistics. Block bootstrap handles time series. Stratified bootstrap preserves class proportions.

## 15. Related Topics

The CLT offers analytic approximations; bootstrap empirically approximates sampling distributions. Jackknife is a related leave-one-out method.

## 16. Interview Questions

1. **What is Bootstrap?** Bootstrap is a resampling method that estimates an estimator's sampling variability by sampling the observed dataset with replacement many times.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** For samples `x*_(1),.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Bootstrap from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Bootstrap analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Treat the observed dataset as a small stand-in population: repeatedly draw similarly sized datasets from it and see how much the statistic moves. Main formula: For samples `x*_(1),...,x*_(B)`, estimate SE by `sd(T(x*))`; percentile CI is `[quantile_alpha/2, quantile_1-alpha/2]`. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Bootstrap |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | CIs for F1/AUC/medians, model comparison, uncertainty in pipelines, and nonparametric inference. |


---

# Bayesian Statistics Basics

## 1. Overview

Bayesian statistics represents uncertainty about unknown quantities with probability distributions and updates prior beliefs using data. It is useful when data are scarce, uncertainty matters, or hierarchical sharing is valuable.

## 2. Intuition

Start with a belief about an uncertain coin bias; every observed flip updates that belief. The output is a full distribution, not just one estimate.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Prior: belief before current data; it can regularize small samples.
* Likelihood: probability of observed data for each parameter value.
* Posterior: updated belief after data.
* Posterior predictive: uncertainty-aware distribution for future observations.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

`p(theta|D) = p(D|theta)p(theta)/p(D)`. The evidence `p(D)` normalizes the posterior; posterior predictive is `integral p(y_new|theta)p(theta|D)dtheta`.

## 7. Practical Implementation

```python
import numpy as np
# Beta(2,2) prior, then 8 successes and 2 failures
alpha, beta = 2 + 8, 2 + 2
print('posterior mean', alpha / (alpha + beta))
print('95% draws', np.quantile(np.random.beta(alpha, beta, 50_000), [.025, .975]))
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Small-data conversion estimation, uncertainty-aware forecasting, medical decisions, A/B analysis, and hierarchical recommender models.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Conjugate models allow closed-form updates. Hierarchical Bayes shares strength across groups. Variational inference is fast approximate posterior inference; MCMC is more accurate but slower.

## 15. Related Topics

MAP is posterior-mode estimation; MLE ignores the prior. Bayesian credible intervals differ conceptually from frequentist CIs; MCMC samples difficult posteriors.

## 16. Interview Questions

1. **What is Bayesian Statistics Basics?** Bayesian statistics represents uncertainty about unknown quantities with probability distributions and updates prior beliefs using data.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** `p(theta|D) = p(D|theta)p(theta)/p(D)`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Bayesian Statistics Basics from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Bayesian Statistics Basics analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Start with a belief about an uncertain coin bias; every observed flip updates that belief. The output is a full distribution, not just one estimate. Main formula: `p(theta|D) = p(D|theta)p(theta)/p(D)`. The evidence `p(D)` normalizes the posterior; posterior predictive is `integral p(y_new|theta)p(theta|D)dtheta`. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Bayesian Statistics Basics |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Small-data conversion estimation, uncertainty-aware forecasting, medical decisions, A/B analysis, and hierarchical recommender models. |


---

# Maximum Likelihood Estimation

## 1. Overview

Maximum likelihood estimation (MLE) chooses model parameters that make the observed training data most probable. It is the basis of many ML losses, including least squares, logistic regression, and neural-network cross-entropy.

## 2. Intuition

Choose the parameter setting under which seeing the actual data would be least surprising. It fits the data distribution rather than guessing parameters directly.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Likelihood: `p(D|theta)` viewed as a function of theta.
* Log-likelihood: sum of log probabilities; numerically stable and turns products into sums.
* Negative log-likelihood (NLL): minimization form used by optimizers.
* Identifiability: different parameters must imply distinguishable distributions.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

`theta_hat_MLE = argmax_theta product_i p(x_i|theta) = argmin_theta -sum_i log p(x_i|theta)`. Gaussian fixed-variance MLE yields squared-error loss; Bernoulli yields cross-entropy.

## 7. Practical Implementation

```python
import numpy as np
x = np.array([2.0, 3.0, 4.0, 5.0])
mu_mle = x.mean()
var_mle = ((x - mu_mle) ** 2).mean()  # divide by n
print(mu_mle, var_mle)
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Linear/logistic regression, Gaussian mixtures, Naive Bayes, HMMs, language models, and neural-network training.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Regularized MLE adds penalties; generalized MLE covers non-iid structured likelihoods; EM optimizes latent-variable likelihoods.

## 15. Related Topics

MAP adds a prior/regularizer. Cross-entropy is Bernoulli/categorical NLL. KL minimization connects MLE to distribution matching.

## 16. Interview Questions

1. **What is Maximum Likelihood Estimation?** Maximum likelihood estimation (MLE) chooses model parameters that make the observed training data most probable.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** `theta_hat_MLE = argmax_theta product_i p(x_i|theta) = argmin_theta -sum_i log p(x_i|theta)`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Maximum Likelihood Estimation from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Maximum Likelihood Estimation analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Choose the parameter setting under which seeing the actual data would be least surprising. It fits the data distribution rather than guessing parameters directly. Main formula: `theta_hat_MLE = argmax_theta product_i p(x_i|theta) = argmin_theta -sum_i log p(x_i|theta)`. Gaussian fixed-variance MLE yields squared-error loss; Bernoulli yields cross-entropy. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Maximum Likelihood Estimation |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Linear/logistic regression, Gaussian mixtures, Naive Bayes, HMMs, language models, and neural-network training. |


---

# Maximum a Posteriori Estimation

## 1. Overview

Maximum a posteriori (MAP) estimation chooses the single parameter value with highest posterior probability. It blends observed data with a prior and is often equivalent to regularized MLE.

## 2. Intuition

MLE trusts only current data; MAP also uses a reasonable starting belief. With little data, the prior prevents extreme estimates; with much data, likelihood dominates.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Posterior mode: one best theta, not full Bayesian uncertainty.
* Prior as regularizer: encodes preferred parameters or domain knowledge.
* Data-prior trade-off: prior influence declines as evidence grows.
* Hyperparameters: prior scale controls regularization strength.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

`theta_MAP = argmax p(D|theta)p(theta) = argmin[-log p(D|theta)-log p(theta)]`. Gaussian prior on weights gives L2 regularization; Laplace prior gives L1.

## 7. Practical Implementation

```python
import numpy as np
# Bernoulli successes/failures and Beta(a,b) prior: posterior mode
successes, failures, a, b = 2, 0, 2, 2
map_p = (successes + a - 1) / (successes + failures + a + b - 2)
print(map_p)
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Regularized regression, smoothing probabilities, computer vision priors, Bayesian classification, and small-data models.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Empirical Bayes learns prior hyperparameters from data. Hierarchical MAP shares information across groups. Full Bayes keeps posterior uncertainty rather than only the mode.

## 15. Related Topics

MLE is MAP with a flat prior. L1/L2 regularization have Bayesian prior interpretations. MCMC/VI estimate full posteriors.

## 16. Interview Questions

1. **What is Maximum a Posteriori Estimation?** Maximum a posteriori (MAP) estimation chooses the single parameter value with highest posterior probability.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** `theta_MAP = argmax p(D|theta)p(theta) = argmin[-log p(D|theta)-log p(theta)]`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Maximum a Posteriori Estimation from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Maximum a Posteriori Estimation analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: MLE trusts only current data; MAP also uses a reasonable starting belief. With little data, the prior prevents extreme estimates; with much data, likelihood dominates. Main formula: `theta_MAP = argmax p(D|theta)p(theta) = argmin[-log p(D|theta)-log p(theta)]`. Gaussian prior on weights gives L2 regularization; Laplace prior gives L1. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Maximum a Posteriori Estimation |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Regularized regression, smoothing probabilities, computer vision priors, Bayesian classification, and small-data models. |


---

# Markov Chain Monte Carlo

## 1. Overview

Markov Chain Monte Carlo (MCMC) draws dependent samples whose long-run distribution is a target posterior. It enables Bayesian inference when integrals are analytically intractable.

## 2. Intuition

A random walker explores likely parameter regions more often than unlikely ones. After warm-up, the visited locations approximate posterior draws.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Markov chain: next state depends only on current state.
* Stationary distribution: desired target distribution after convergence.
* Burn-in/warm-up: discard early nonrepresentative draws.
* Mixing/convergence: chains must explore efficiently; diagnostics are essential.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

Metropolis-Hastings accepts proposal `theta'` with probability `min(1, [p(theta'|D)q(theta|theta')]/[p(theta|D)q(theta'|theta)])`. Monte Carlo estimate: `E[f(theta)] ≈ mean(f(theta_s))`.

## 7. Practical Implementation

```python
import numpy as np
rng = np.random.default_rng(0); x = 0.; draws = []
for _ in range(20_000):
    proposal = x + rng.normal()
    if rng.random() < min(1, np.exp(-(proposal**2-x**2)/2)):
        x = proposal
    draws.append(x)
print(np.mean(draws[2_000:]), np.std(draws[2_000:]))
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Bayesian regression, uncertainty quantification, probabilistic programming, latent-variable models, and scientific ML.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Gibbs sampling updates conditional variables. Hamiltonian Monte Carlo/NUTS uses gradients and is widely important. Sequential Monte Carlo suits streaming/state-space settings.

## 15. Related Topics

Bayes defines the posterior; MCMC approximates it. Variational inference is faster but biased; bootstrap estimates frequentist sampling uncertainty.

## 16. Interview Questions

1. **What is Markov Chain Monte Carlo?** Markov Chain Monte Carlo (MCMC) draws dependent samples whose long-run distribution is a target posterior.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** Metropolis-Hastings accepts proposal `theta'` with probability `min(1, [p(theta'|D)q(theta|theta')]/[p(theta|D)q(theta'|theta)])`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Markov Chain Monte Carlo from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Markov Chain Monte Carlo analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: A random walker explores likely parameter regions more often than unlikely ones. After warm-up, the visited locations approximate posterior draws. Main formula: Metropolis-Hastings accepts proposal `theta'` with probability `min(1, [p(theta'|D)q(theta|theta')]/[p(theta|D)q(theta'|theta)])`. Monte Carlo estimate: `E[f(theta)] ≈ mean(f(theta_s))`. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Markov Chain Monte Carlo |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Bayesian regression, uncertainty quantification, probabilistic programming, latent-variable models, and scientific ML. |


---

# Causal Inference

## 1. Overview

Causal inference estimates the effect of changing one variable on another, rather than merely predicting or associating them. It guides trustworthy product, policy, medical, and ML intervention decisions.

## 2. Intuition

Ice-cream sales and drowning correlate because temperature affects both. A causal method asks what happens if we force ice-cream sales to change, not merely observe their co-movement.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* Potential outcomes: each unit has treatment and control outcomes, but only one is observed.
* Confounding: a common cause creates misleading associations.
* Identification: assumptions/design that make a causal effect recoverable.
* ATE: average treatment effect; define the target population explicitly.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

`ATE = E[Y(1)-Y(0)]`. Under conditional exchangeability, positivity, and consistency: `ATE = E_X[E(Y|T=1,X)-E(Y|T=0,X)]`.

## 7. Practical Implementation

```python
import numpy as np
# randomized experiment estimate
outcome = np.array([1,0,1,1,0, 1,1,1,0,1])
treat = np.array([0,0,0,0,0, 1,1,1,1,1])
print(outcome[treat==1].mean() - outcome[treat==0].mean())
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

A/B testing, ads, healthcare, pricing, recommendations, policy evaluation, and debiasing observational ML.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Randomized trials are gold standard. Matching/propensity scores adjust observed confounders. Difference-in-differences, IV, regression discontinuity, and causal forests address particular designs.

## 15. Related Topics

A/B tests identify causal effects via randomization. DAGs expose confounding; do-calculus formalizes intervention reasoning; prediction can be accurate without causal validity.

## 16. Interview Questions

1. **What is Causal Inference?** Causal inference estimates the effect of changing one variable on another, rather than merely predicting or associating them.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** `ATE = E[Y(1)-Y(0)]`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Causal Inference from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Causal Inference analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: Ice-cream sales and drowning correlate because temperature affects both. A causal method asks what happens if we force ice-cream sales to change, not merely observe their co-movement. Main formula: `ATE = E[Y(1)-Y(0)]`. Under conditional exchangeability, positivity, and consistency: `ATE = E_X[E(Y|T=1,X)-E(Y|T=0,X)]`. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Causal Inference |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | A/B testing, ads, healthcare, pricing, recommendations, policy evaluation, and debiasing observational ML. |


---

# Do-Calculus

## 1. Overview

Do-calculus is Pearl's formal rule system for transforming interventional probabilities such as `P(Y|do(X=x))` using a causal DAG and conditional independencies. It answers when causal effects are identifiable from observational/interventional data.

## 2. Intuition

`P(Y|X=x)` observes people with X=x; `P(Y|do(X=x))` forces X=x, cutting incoming causes of X. Do-calculus specifies when observations can substitute for interventions.

## 3. Prerequisites

Basic probability, descriptive statistics, Python/NumPy, and the listed assumptions. Helpful extensions are linear algebra and optimization where the method estimates parameters.

## 4. Core Concepts

* do-operator: intervention that sets a variable and removes incoming edges.
* Causal DAG: directed graph encoding causal assumptions.
* Graph mutilation: remove edges into intervened variables.
* d-separation: graphical conditional-independence criterion used by the three rules.

## 5. Algorithm / Working Process

1. Define the estimand/question and independent unit. 2. Validate design and assumptions. 3. Compute the relevant statistic or fit the model. 4. Quantify uncertainty/diagnostics. 5. Make a decision using both practical and statistical evidence.

## 6. Mathematical Foundation

Key adjustment result: if Z blocks all backdoor paths from X to Y and contains no descendant of X, `P(Y|do(X)) = sum_z P(Y|X,z)P(z)`. Do-calculus has insertion/deletion, action/observation exchange, and action insertion/deletion rules.

## 7. Practical Implementation

```python
# Backdoor adjustment from observational samples
def adjusted_effect(df, x, y, confounder):
    weighted = 0.0
    for z, group in df.groupby(confounder):
        weighted += (group[x].eq(1).mean() *
                     (group.loc[group[x].eq(1), y].mean() -
                      group.loc[group[x].eq(0), y].mean()))
    return weighted
# In practice use a causal-DAG library and verify positivity/cell support.
```

## 8. Code Explanation

The code uses a small reproducible example. In a project, replace toy arrays with validated data, keep the analysis unit aligned with sampling/randomization, and log assumptions alongside the result.

## 9. Training / Evaluation

This is primarily an inference/evaluation tool rather than a trainable ML model. Split or sample at the independent unit; prevent target leakage; use a fixed holdout or valid resampling; report effect size, uncertainty, and diagnostics.

## 10. Complexity and Cost

Most analytic versions take `O(n)` time and `O(1)` to `O(n)` memory. Resampling/MCMC variants cost roughly `O(Bn)` or more. They are normally CPU tasks; GPU helps only for expensive model likelihoods.

## 11. Common Use Cases

Observational treatment-effect estimation, policy analysis, fairness, medicine, ad attribution, and causal ML research.

## 12. Common Mistakes

Confusing association with causation; using the wrong independent unit; ignoring assumptions; reporting only a p-value; uncorrected multiple comparisons; data leakage; post-hoc metric/tail selection; and treating a statistical result as a product decision.

## 13. Edge Cases / Limitations

Small samples, outliers, dependence, missing-not-at-random data, distribution shift, and selection bias may invalidate results. A valid calculation cannot repair a bad data-generating process.

## 14. Variations

Backdoor adjustment is the common placement-level application. Front-door adjustment identifies effects through a mediator. ID algorithm automates identification for broader graphs; counterfactual SCMs are research-level.

## 15. Related Topics

Causal inference supplies estimands/assumptions. DAGs and structural causal models encode them. A/B testing implements `do(X)` by randomization.

## 16. Interview Questions

1. **What is Do-Calculus?** Do-calculus is Pearl's formal rule system for transforming interventional probabilities such as `P(Y|do(X=x))` using a causal DAG and conditional independencies.
2. **What is the central assumption?** Independence/random sampling or the method-specific design assumptions must be defensible.
3. **What is the key quantity?** Key adjustment result: if Z blocks all backdoor paths from X to Y and contains no descendant of X, `P(Y|do(X)) = sum_z P(Y|X,z)P(z)`.
4. **What does a small p-value mean?** It is evidence against a specified null, not probability that the null is false.
5. **Why report an effect size?** Statistical significance alone does not establish practical value.
6. **What is a common data issue?** Correlation, leakage, selection bias, or poor assignment can invalidate conclusions.
7. **How should ML evaluation use it?** Apply it to independent held-out units and report uncertainty.
8. **When is resampling useful?** When the statistic has no reliable simple sampling formula.
9. **What should be pre-specified?** Outcome, population/unit, assumptions, decision threshold, and validation plan.
10. **What is the strongest interview answer?** State the estimand, assumptions, method, effect, uncertainty, and limitation.

## 17. Practice Tasks

Implement Do-Calculus from a CSV; compare an analytic and resampling approach; simulate one assumption violation; create an uncertainty/effect-size report; and write a short decision memo that separates statistical from practical significance.

## 18. Project Ideas

* **Do-Calculus analyzer:** pandas, SciPy, and Streamlit; analyze a public product/health dataset; resume value: statistically defensible analytics.
* **ML evaluation report:** scikit-learn plus this method; quantify model metric uncertainty; resume value: trustworthy model comparison.
* **Monitoring notebook:** pandas/Plotly; detect change and document assumptions; resume value: production ML awareness.

## 19. Quick Revision

Key idea: `P(Y|X=x)` observes people with X=x; `P(Y|do(X=x))` forces X=x, cutting incoming causes of X. Do-calculus specifies when observations can substitute for interventions. Main formula: Key adjustment result: if Z blocks all backdoor paths from X to Y and contains no descendant of X, `P(Y|do(X)) = sum_z P(Y|X,z)P(z)`. Do-calculus has insertion/deletion, action/observation exchange, and action insertion/deletion rules. Use it when its assumptions and independent unit match the question. Main trap: applying a correct formula to an invalid study design.

## 20. Final Cheat Sheet

| Item | Notes |
|---|---|
| Definition | Do-Calculus |
| Input/output | Data/assumptions → estimate, test, samples, or causal effect |
| Main steps | Define estimand; validate design; compute; quantify uncertainty; report |
| Key choices | Sampling unit, assumptions, threshold, method variant |
| Metrics | Effect size, CI/uncertainty, diagnostic or p-value where relevant |
| Pros | Makes uncertainty and assumptions explicit |
| Cons | Cannot overcome biased/dependent/nonrepresentative data |
| Best use cases | Observational treatment-effect estimation, policy analysis, fairness, medicine, ad attribution, and causal ML research. |


