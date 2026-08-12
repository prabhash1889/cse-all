# MLOps

> An interview-focused, end-to-end guide to building, deploying, monitoring, and maintaining reliable machine-learning systems.

MLOps is broad: it combines machine learning, data engineering, software engineering, DevOps, security, governance, and product thinking. The goal is not merely to deploy a model. The goal is to operate a **repeatable and controlled system** that continues to produce useful predictions as code, data, models, infrastructure, and business requirements change.

---

## 1. Overview

### What is MLOps?

**Machine Learning Operations (MLOps)** is the set of engineering practices, processes, and tools used to take ML systems from experimentation to reliable production operation.

An ordinary software release primarily depends on source code and configuration. An ML release depends on at least four versioned components:

1. **Code**: preprocessing, feature engineering, training, evaluation, and serving logic.
2. **Data**: raw data, labels, splits, feature definitions, and data-quality assumptions.
3. **Model artifact**: learned parameters, architecture, preprocessing state, and decision threshold.
4. **Environment**: library versions, runtime, hardware, operating system, and infrastructure configuration.

This makes an ML system a useful mental equation:

\[
\text{ML system} = \text{code} + \text{data} + \text{model} + \text{configuration} + \text{infrastructure} + \text{feedback}
\]

A model may fail even when the application code is unchanged. Upstream data can change, user behavior can drift, labels can arrive late, feature logic can differ between training and serving, or model performance can degrade for one important user group.

### Why MLOps is useful

MLOps addresses recurring production problems:

- An experiment cannot be reproduced because the data or parameters were not recorded.
- A model performs well in a notebook but fails under production latency or memory limits.
- Training and serving calculate the same feature differently.
- A new model is deployed without a safe rollback path.
- Data drift goes unnoticed until business metrics decline.
- Teams do not know which data, code commit, and parameters produced a model.
- Retraining introduces a regression because evaluation gates are missing.
- Sensitive data or untrusted model artifacts are handled insecurely.

### Where MLOps is used

MLOps is relevant wherever predictions affect a product or business process:

| Domain | ML system | Important operational concern |
|---|---|---|
| Banking | Fraud detection, credit risk | Low latency, auditability, false-positive cost |
| E-commerce | Recommendations, ranking | Feature freshness, online experiments, feedback loops |
| Healthcare | Diagnosis support | Safety, privacy, human review, model governance |
| Manufacturing | Predictive maintenance | Sensor drift, edge deployment, delayed failures |
| Computer vision | Inspection, surveillance | GPU cost, image-quality drift, throughput |
| NLP/LLMs | Search, chat, summarization | Prompt/model versioning, safety, cost, evaluation |
| Logistics | ETA and demand forecasting | Time-based validation, seasonality, retraining cadence |
| Advertising | Click/conversion prediction | Real-time features, calibration, delayed labels |

### MLOps versus related disciplines

| Discipline | Main concern | Relationship to MLOps |
|---|---|---|
| DevOps | Build, test, release, and operate software | MLOps extends it to data, experiments, and models |
| DataOps | Reliable data ingestion and transformation | Supplies trustworthy, observable data to ML pipelines |
| ModelOps | Governance and operation of models from any source | Often emphasizes approval, risk, registry, and monitoring |
| AIOps | Uses AI to operate IT systems | Different direction: AI *for* operations rather than operations *for* AI |
| LLMOps | Operations for LLM applications | Specializes MLOps for prompts, retrieval, evals, safety, and token cost |

### The production objective

The best offline model is not always the best production model. A production choice is usually a constrained optimization problem:

\[
\begin{aligned}
\max_f \quad & \operatorname{ExpectedBusinessValue}(f) \\
\text{subject to} \quad
& \operatorname{Latency}_{p99}(f) \le L, \\
& \operatorname{CostPerPrediction}(f) \le C, \\
& \operatorname{Availability}(f) \ge A, \\
& \operatorname{Quality}(f, g) \ge q_g \quad \forall g, \\
& \operatorname{Risk}(f) \le R.
\end{aligned}
\]

Here, \(g\) denotes a critical slice such as region, device, or customer segment. A slightly less accurate model may be preferred if it is faster, cheaper, more interpretable, better calibrated, and easier to monitor.

---

## 2. Intuition

### The restaurant analogy

A notebook experiment is like creating one excellent dish in a home kitchen. A production ML system is like operating a restaurant chain:

- The **recipe** is the training and feature code.
- The **ingredients** are the data.
- The **trained chef** is the model artifact.
- The **kitchen setup** is the runtime and infrastructure.
- The **quality inspection** is testing and validation.
- The **menu rollout** is deployment.
- Customer reviews and health checks are **monitoring and feedback**.

One successful dish does not prove that every branch can reproduce it safely, quickly, and consistently. MLOps creates the process that makes this repeatability possible.

### A simple churn example

Suppose a telecom company predicts whether a customer will churn in the next 30 days.

Without MLOps:

1. A data scientist trains a model in a notebook.
2. The model reports 90% accuracy.
3. Someone manually copies a pickle file to a server.
4. The data schema changes from monthly charges in dollars to cents.
5. Predictions become wrong, but the API remains healthy and returns HTTP 200.

With MLOps:

1. A versioned pipeline reads a defined data snapshot.
2. Schema tests reject invalid units or extreme values.
3. The experiment records code commit, data hash, features, parameters, and metrics.
4. Evaluation checks recall, calibration, slices, and latency—not accuracy alone.
5. The approved artifact enters a registry.
6. A canary deployment receives a small fraction of traffic.
7. Monitoring detects input drift and output-rate changes.
8. The service rolls back automatically or through a documented runbook.

### The central feedback loop

The operating loop is:

```text
Business objective
      ↓
Data → Features → Train → Evaluate → Register → Deploy
 ↑                                           ↓
 └──────── Labels/feedback ← Monitor ← Predict
```

The loop matters because production changes the world that creates future training data. For example, a recommendation model promotes selected items, which generates more interactions for those items. This is a **feedback loop**; observed data is no longer independent of the deployed policy.

### Three kinds of correctness

An ML system must be correct at three levels:

1. **Software correctness**: Does the code run and satisfy its contract?
2. **Statistical correctness**: Does the model generalize under realistic assumptions?
3. **Operational correctness**: Does it meet latency, availability, cost, safety, and business requirements in production?

MLOps exists because passing only one of these is insufficient.

---

## 3. Prerequisites

### Machine learning

- Supervised and unsupervised learning.
- Training, validation, and test splits.
- Classification, regression, ranking, forecasting, and their metrics.
- Overfitting, regularization, hyperparameter tuning, and calibration.
- Data leakage, class imbalance, distribution shift, and uncertainty.
- Pipelines that apply identical preprocessing during training and inference.

### Mathematics and statistics

- Probability distributions, conditional probability, and expectation.
- Mean, variance, quantiles, covariance, and correlation.
- Hypothesis tests and confidence intervals.
- Loss functions and gradient-based optimization.
- Distance/divergence measures for comparing distributions.
- Experimental design and A/B testing.

### Programming and software engineering

- Python, packaging, virtual environments, and dependency management.
- Git commits, branches, pull requests, and semantic versioning.
- Unit, integration, contract, and end-to-end tests.
- REST/gRPC APIs, serialization, concurrency, and error handling.
- Logging, configuration, secrets, authentication, and authorization.

### Data engineering

- SQL, batch processing, streaming, partitioning, and data warehouses/lakes.
- Schemas, data contracts, validation, lineage, and orchestration.
- Idempotency: rerunning a job should not corrupt or duplicate results.
- Event time versus processing time and late-arriving data.

### Infrastructure and DevOps

- Linux basics, processes, ports, filesystems, and networking.
- Containers and image registries.
- CI/CD pipelines and infrastructure as code.
- Cloud object storage, compute, autoscaling, and access policies.
- Metrics, logs, traces, dashboards, alerts, SLOs, and incident response.

### Helpful tools—not mandatory concepts

Examples include MLflow or Weights & Biases for experiment tracking; DVC or lakeFS for data versioning; Airflow, Prefect, Dagster, or Kubeflow for orchestration; Docker and Kubernetes for packaging and serving; and Prometheus/Grafana or a managed observability platform for monitoring. Interviews usually reward understanding the **capability and trade-off**, not memorizing one vendor's commands.

---

## 4. Core Concepts

### 4.1 Problem framing and success criteria

**What it means:** Convert a vague business objective into a measurable prediction and decision problem. Define the prediction unit, target, horizon, action, constraints, and owner.

**Why it matters:** An excellent model for the wrong target produces no value. The model metric must connect to an action and a business KPI.

**Example:** Replace “reduce churn” with “every night, rank active customers by probability of voluntary churn within 30 days so the retention team can contact the top 2%.”

**Common interview angle:** “How do you select an offline metric?” Explain the error costs, operational capacity, class balance, and connection to the downstream decision.

### 4.2 Reproducibility and lineage

**What it means:** Given a run, identify the exact code, data, configuration, environment, and feature definitions that produced its artifact and metrics.

**Why it matters:** Debugging and auditing are impossible if a result cannot be reconstructed. Exact bit-for-bit determinism may be expensive, but lineage should always be preserved.

**Example:** A run records Git SHA `a1b2c3`, data snapshot `s3://bucket/train/2026-08-01`, data checksum, random seed, Docker digest, parameters, metrics, and parent model version.

**Common interview angle:** “What must be tracked for reproducibility?” Mention code, data, config, dependencies, seed, artifacts, metrics, feature definitions, environment, and hardware when it affects numerics.

### 4.3 Data versioning and data lineage

**What it means:** Treat datasets and transformations as versioned dependencies. Store immutable snapshots or versioned references plus hashes and lineage rather than blindly copying all data into Git.

**Why it matters:** Data changes more frequently than training code, and a reused filename may silently point to different bytes.

**Example:** The raw event partitions, label query, transformation commit, and output snapshot ID collectively define training dataset version 17.

**Common interview angle:** “Git versions code; why not data?” Large, mutable, private datasets need storage systems optimized for size, access control, lineage, and retention.

### 4.4 Data contracts and validation

**What it means:** A contract specifies schema, types, units, allowed ranges, null policy, category vocabulary, uniqueness, freshness, and ownership.

**Why it matters:** Most model failures begin upstream. A schema-compatible change can still be semantically wrong, such as dollars becoming cents.

**Example checks:**

- `customer_id` is non-null and unique per scoring date.
- `age` is integer and between 18 and 110.
- `country` belongs to an approved vocabulary or maps to `UNKNOWN`.
- event data is no more than two hours old.
- positive-label rate stays within a warning range.

**Common interview angle:** Distinguish schema validation from statistical validation and explain whether a failed check should warn, quarantine data, or block the pipeline.

### 4.5 Feature pipelines and feature stores

**What it means:** Feature code transforms raw data into model inputs. A feature store can manage definitions, reuse, access, offline training values, and low-latency online values.

**Why it matters:** The same feature must have consistent semantics during training and serving. Reuse can reduce duplication, but a feature store is not automatically needed for every project.

**Example:** `transactions_last_7d` is calculated as of an event-time cutoff. Historical training values use point-in-time joins; online serving reads the latest value keyed by customer.

**Common interview angle:** Explain **training-serving skew**, **point-in-time correctness**, feature freshness, and when a feature store is justified.

### 4.6 Experiment tracking

**What it means:** Record each run's inputs, parameters, metrics, artifacts, notes, and relationships.

**Why it matters:** A table of comparable runs prevents decisions based on memory or a notebook's current state.

**Example:** Compare logistic regression and gradient boosting using the same dataset version and split, logging AUROC, PR-AUC, recall at contact capacity, Brier score, latency, and artifact size.

**Common interview angle:** “Experiment tracking versus model registry?” Tracking describes attempts; a registry governs model versions eligible for deployment.

### 4.7 Model packaging and serialization

**What it means:** Bundle the fitted model with preprocessing, signature, dependencies, metadata, and loading logic.

**Why it matters:** Shipping only learned weights often omits category mappings, scalers, tokenizers, thresholds, or custom code.

**Example:** A scikit-learn `Pipeline` contains preprocessing and classifier together; its metadata declares input fields and the output meaning.

**Common interview angle:** Discuss portable formats, backward compatibility, unsafe deserialization, dependency pinning, and validating an artifact before loading it.

### 4.8 Model registry

**What it means:** A controlled catalog of immutable model versions, metadata, lineage, evaluation results, approvals, aliases, and lifecycle state.

**Why it matters:** Deployment should select a reviewed artifact by immutable identity, not “the latest file in a folder.”

**Example states:** candidate → validated → approved → production → archived. Modern registries often prefer mutable aliases such as `champion` and `challenger` over rigid stage names.

**Common interview angle:** Explain the difference between artifact storage and a registry, and what conditions promote a model.

### 4.9 Pipelines and orchestration

**What it means:** Encode data preparation, training, evaluation, registration, and deployment as tasks with dependencies, retries, schedules, and observable state.

**Why it matters:** A script says what to run; an orchestrator also manages when, where, after what, with which retries, and with what recorded state.

**Example DAG:** validate raw data → build features → train → evaluate → package → register. Deployment may require human approval for high-risk use cases.

**Common interview angle:** Ask how tasks are made idempotent, cached, retried, and backfilled without corrupting outputs.

### 4.10 CI, CD, and CT

| Practice | Meaning in ML | Typical trigger | Typical result |
|---|---|---|---|
| CI | Continuously validate code, data logic, and small model behavior | Pull request | Tested, reviewable change |
| CD | Continuously deliver or deploy approved artifacts | Merge/approval/registry event | Safe rollout to an environment |
| CT | Continuously retrain when justified | Schedule, new data, drift, or performance drop | New candidate model, not automatic production promotion |

**Why it matters:** Retraining and deployment are different risk decisions. New data should create a candidate; evaluation gates decide whether it is better and safe.

**Common interview angle:** “Should drift automatically trigger deployment?” Usually no. Drift may not hurt performance, and a retrained model can regress.

### 4.11 Testing ML systems

ML testing is layered:

| Test type | Example |
|---|---|
| Unit | Feature `account_age_days` handles leap dates |
| Schema/contract | Required columns, types, ranges, freshness |
| Data invariants | IDs unique, leakage column absent, label rate plausible |
| Pipeline integration | Raw fixture passes through training and emits an artifact |
| Model behavior | Probabilities in `[0,1]`; a known risky case scores above a safe case |
| Regression | Candidate metric does not fall beyond allowed tolerance |
| Slice/robustness | Quality meets gates by device, geography, and missingness |
| Serving contract | API input/output matches the declared model signature |
| Load/resilience | p99 latency and error rate remain within SLO under load |
| Security | Image scan, access checks, artifact provenance |

**Common interview angle:** Exact prediction assertions are brittle for stochastic models. Prefer invariants, tolerances, ranking relationships, and statistical gates.

### 4.12 Deployment modes

| Mode | Best for | Trade-off |
|---|---|---|
| Batch | Daily scores, reports, offline recommendations | Cheap and simple; predictions can become stale |
| Online synchronous | Fraud checks, interactive ranking | Fresh and low latency; harder reliability requirements |
| Asynchronous | Expensive image/NLP jobs | Handles long work; client needs job/result workflow |
| Streaming | Per-event scoring | Fresh continuous output; operationally complex |
| Edge/on-device | Privacy, offline use, very low latency | Tight compute/memory limits; difficult updates |

**Common interview angle:** Choose the least operationally complex mode that meets freshness and latency requirements.

### 4.13 Release strategies

- **Rolling update:** Gradually replace instances. Simple, but old and new versions coexist.
- **Blue-green:** Keep complete old and new environments; switch traffic. Fast rollback, higher temporary cost.
- **Canary:** Send a small percentage of live traffic to the candidate and expand after gates pass.
- **Shadow:** Copy requests to the candidate but do not use its outputs. Safe comparison, but doubles some serving cost and cannot measure user response.
- **A/B test:** Randomly assign users to alternatives to estimate causal business impact. Requires stable assignment and statistical design.
- **Champion-challenger:** Compare a deployed champion with one or more challengers offline, in shadow, or online.

**Common interview angle:** Shadow testing measures candidate behavior on real inputs; A/B testing measures the consequence of using candidate outputs.

### 4.14 Monitoring and observability

Monitor four layers:

1. **Service:** availability, throughput, latency, errors, saturation, queue depth.
2. **Data:** schema, missingness, ranges, categories, freshness, drift.
3. **Model:** score distribution, class rate, calibration, slice performance, drift, uncertainty.
4. **Business:** conversion, loss prevented, complaints, manual-review load, revenue, safety outcomes.

Observability uses **metrics** for trends and alerts, **logs** for event details, and **traces** for following a request across services.

**Common interview angle:** When labels are delayed, monitor proxies such as input quality, drift, output distribution, disagreement with a baseline, and operational/business signals; compute true performance after labels arrive.

### 4.15 Drift and feedback loops

- **Data/covariate drift:** \(P_{train}(X) \ne P_{prod}(X)\).
- **Prior/label drift:** \(P_{train}(Y) \ne P_{prod}(Y)\).
- **Concept drift:** \(P_{train}(Y\mid X) \ne P_{prod}(Y\mid X)\).
- **Feature drift:** A monitored feature's distribution changes.
- **Prediction drift:** The score or predicted-class distribution changes.
- **Feedback loop:** Model decisions influence future observations and labels.

Drift is a diagnostic signal, not proof of quality loss. A harmless feature can drift while predictions remain correct; concept drift can reduce quality without obvious marginal feature drift.

### 4.16 Governance, security, and responsible operation

**Governance** includes documentation, ownership, lineage, approvals, risk classification, audit logs, retention, fairness evaluation, explainability requirements, and retirement.

**Security** includes least-privilege access, encryption, secrets management, dependency and image scanning, artifact signing, network controls, input validation, rate limits, and protection against unsafe deserialization or model supply-chain attacks.

**Common interview angle:** A production system needs both technical gates and accountable owners. High-risk decisions may require human review, appeal paths, and conservative fallback behavior.

### 4.17 SLOs, incident response, and rollback

- **SLI:** measured indicator, such as successful requests divided by valid requests.
- **SLO:** target for an SLI, such as 99.9% successful predictions over 30 days.
- **SLA:** external agreement with consequences.
- **Error budget:** tolerated unreliability, approximately \(1-\text{SLO}\).

Every deployment needs an observable version identity, health checks, a rollback or fallback, an owner, and a runbook. A fallback may be the previous model, a rule-based baseline, cached predictions, or manual review.

---

## 5. Algorithm / Working Process

MLOps is not a single learning algorithm. It is an operational lifecycle with controlled state transitions.

### Step 1: Frame the decision

Define:

- the entity being scored;
- prediction target and horizon;
- when a prediction is made;
- who or what consumes it;
- action taken from it;
- cost of false positives and false negatives;
- business KPI, guardrails, privacy, fairness, latency, and cost limits;
- fallback and owner.

**Input:** business problem and constraints.  
**Output:** testable ML problem statement and acceptance criteria.

### Step 2: Define labels, data contracts, and split strategy

Specify label construction and the time at which each field becomes available. Establish schema, semantic checks, freshness, and ownership. Choose a split that simulates production:

- time split for future prediction;
- group split when the same user/patient/device appears repeatedly;
- geographical holdout for expansion;
- stratification when class balance must be preserved and observations are independent.

**Critical rule:** every feature for example \(i\) must be available at its prediction timestamp \(t_i\). Point-in-time joins must not read the future.

### Step 3: Build a baseline

Start with the current business rule, constant predictor, heuristic, or simple linear/tree model. The baseline verifies that the pipeline and metric are meaningful and establishes whether complexity adds value.

### Step 4: Create a reproducible training pipeline

The pipeline should:

1. resolve an immutable data version;
2. validate data;
3. build point-in-time-correct features;
4. create fixed or recorded splits;
5. fit preprocessing only on training data;
6. train the model;
7. evaluate overall and on slices;
8. package preprocessing and model together;
9. record lineage, environment, metrics, and artifacts.

### Step 5: Evaluate against gates

Evaluate more than an aggregate model metric:

- baseline improvement;
- confidence intervals or repeated validation when appropriate;
- calibration and threshold behavior;
- critical slices;
- robustness to missing, extreme, or shifted inputs;
- latency, throughput, memory, artifact size, and cost;
- explainability, fairness, privacy, and security requirements.

Failed gates stop promotion; they do not necessarily invalidate the experiment.

### Step 6: Register an immutable candidate

Store:

- artifact URI and cryptographic digest;
- model signature and output semantics;
- code commit, data version, config, and parent run;
- evaluation report;
- framework/runtime compatibility;
- owner, intended use, limitations, and approval state.

### Step 7: Validate in a production-like environment

Run smoke tests, contract tests, integration tests, load tests, and security scans against the packaged artifact. Compare offline and service predictions for identical inputs to detect packaging or preprocessing differences.

### Step 8: Release safely

Use blue-green, canary, shadow, or A/B rollout depending on risk. Pin deployments to an immutable artifact digest. Preserve the previous known-good version. Define automated or manual abort criteria before starting.

### Step 9: Serve predictions

**Online input:** validated request plus fresh online features.  
**Processing:** authentication → validation → feature lookup/transformation → inference → decision policy → response/logging.  
**Output:** prediction, confidence or score where appropriate, model version, and trace ID.

For batch inference, read a versioned input partition and write predictions atomically to a versioned output partition with model identity and scoring timestamp.

### Step 10: Monitor and respond

Monitor service, data, model, business, and cost metrics. Alerts must map to actions:

- bad upstream data → quarantine/stop pipeline and contact data owner;
- latency/error regression → scale, degrade gracefully, or roll back;
- drift → investigate slices and wait for labels where needed;
- confirmed quality loss → retrain, recalibrate, adjust policy, or roll back;
- safety violation → disable risky path and route to a safe fallback.

### Step 11: Retrain conditionally

Retraining can be triggered by schedule, sufficient new labels, confirmed degradation, distribution change, business change, or upstream feature change. Each retraining run creates a **challenger**, which must pass the same gates. “Newer” is not equivalent to “better.”

### Step 12: Retire responsibly

Stop traffic, remove unused infrastructure and credentials, archive required artifacts and audit records, update documentation, and confirm that downstream consumers no longer depend on the model.

### Reference lifecycle state machine

```text
EXPERIMENTED → VALIDATED → REGISTERED → APPROVED → DEPLOYED
                    ↓            ↓           ↓          ↓
                 REJECTED     ARCHIVED    REVOKED    ROLLED_BACK
                                                      ↓
                                                   RETIRED
```

State changes should be explicit and auditable. An artifact should not silently mutate while retaining the same version.

---

## 6. Mathematical Foundation

MLOps uses model mathematics plus statistics for comparison, drift, reliability, and business decisions.

### 6.1 Empirical risk and regularization

For training examples \((x_i,y_i)_{i=1}^{n}\), empirical risk minimization chooses parameters \(\theta\) that minimize average loss:

\[
\hat{R}(\theta)=\frac{1}{n}\sum_{i=1}^{n}L(f_\theta(x_i),y_i).
\]

With regularization:

\[
\theta^*=\arg\min_\theta\left[
\frac{1}{n}\sum_{i=1}^{n}L(f_\theta(x_i),y_i)+\lambda\Omega(\theta)
\right].
\]

MLOps must record the loss, regularization form, \(\lambda\), optimizer, data version, and stopping rule because all influence the artifact.

For binary classification, log loss is:

\[
L_{log}=-\frac{1}{n}\sum_{i=1}^{n}
\left[y_i\log p_i+(1-y_i)\log(1-p_i)\right].
\]

For regression, mean squared error is:

\[
\operatorname{MSE}=\frac{1}{n}\sum_{i=1}^{n}(y_i-\hat y_i)^2.
\]

### 6.2 Thresholding and expected decision cost

A probability is often converted into an action with threshold \(\tau\):

\[
\hat y=\mathbb{1}[P(Y=1\mid X=x)\ge\tau].
\]

The default \(0.5\) is rarely justified. Choose \(\tau\) using capacity, precision/recall requirements, or expected cost:

\[
\operatorname{ExpectedCost}(\tau)=
C_{FP}\,FP(\tau)+C_{FN}\,FN(\tau)+C_{action}\,N_{action}(\tau).
\]

Operationally, the threshold is a versioned part of the decision policy. Recalibrating or changing \(\tau\) can be a production change even if model weights stay fixed.

### 6.3 Classification metrics

\[
\operatorname{Precision}=\frac{TP}{TP+FP}, \qquad
\operatorname{Recall}=\frac{TP}{TP+FN}
\]

\[
F_1=2\frac{\operatorname{Precision}\cdot\operatorname{Recall}}
{\operatorname{Precision}+\operatorname{Recall}}.
\]

- **AUROC** measures ranking across thresholds but may look optimistic with rare positives.
- **PR-AUC** emphasizes positive-class retrieval and is often more informative for rare events.
- **Recall at K** or **precision at K** is useful when operational capacity is fixed.
- **Cost-weighted metrics** are useful when error costs are asymmetric.

### 6.4 Calibration

A calibrated model that predicts 0.8 should be correct roughly 80% of the time among similar predictions.

The Brier score is:

\[
\operatorname{Brier}=\frac{1}{n}\sum_{i=1}^{n}(p_i-y_i)^2.
\]

Expected Calibration Error (ECE) partitions probabilities into bins \(B_m\):

\[
\operatorname{ECE}=\sum_{m=1}^{M}\frac{|B_m|}{n}
\left|\operatorname{acc}(B_m)-\operatorname{conf}(B_m)\right|.
\]

ECE depends on the binning scheme, so a reliability diagram should accompany it. Calibration matters when probabilities drive pricing, prioritization, or expected-value calculations.

### 6.5 Sampling uncertainty and confidence intervals

An observed metric is an estimate, not a constant. If \(\hat p\) is a proportion estimated from \(n\) independent examples, an approximate standard error is:

\[
SE(\hat p)=\sqrt{\frac{\hat p(1-\hat p)}{n}}.
\]

An approximate 95% confidence interval is \(\hat p\pm1.96SE\), though Wilson or bootstrap intervals are often better. For complicated metrics, bootstrap the evaluation units while respecting grouping or time dependence.

A candidate should not be promoted because of a tiny apparent gain inside measurement noise.

### 6.6 Population Stability Index (PSI)

Divide a reference and current distribution into the same bins. If reference proportion is \(e_i\) and current proportion is \(a_i\), then:

\[
\operatorname{PSI}=\sum_{i=1}^{k}(a_i-e_i)\ln\left(\frac{a_i}{e_i}\right).
\]

PSI is easy to explain and commonly used, but results depend on bins and sample size. Zero proportions require smoothing. Rules such as 0.1 or 0.25 are conventions, not universal laws; establish thresholds from historical variation and operational cost.

### 6.7 KL and Jensen-Shannon divergence

For discrete distributions \(P\) and \(Q\):

\[
D_{KL}(P\|Q)=\sum_xP(x)\log\frac{P(x)}{Q(x)}.
\]

KL divergence is asymmetric and can become infinite when \(Q(x)=0\) while \(P(x)>0\).

Jensen-Shannon divergence uses \(M=(P+Q)/2\):

\[
D_{JS}(P,Q)=\frac{1}{2}D_{KL}(P\|M)+\frac{1}{2}D_{KL}(Q\|M).
\]

It is symmetric and bounded when the log base is fixed, making it convenient for dashboards.

### 6.8 Kolmogorov-Smirnov statistic

For one-dimensional continuous distributions with empirical CDFs \(F_n\) and \(G_m\):

\[
D_{n,m}=\sup_x|F_n(x)-G_m(x)|.
\]

The KS test detects whether samples likely come from different distributions. With very large samples, tiny unimportant differences become statistically significant; always pair p-values with effect size and business relevance.

### 6.9 Wasserstein distance

For one-dimensional distributions with inverse CDFs:

\[
W_1(P,Q)=\int_0^1|F_P^{-1}(u)-F_Q^{-1}(u)|\,du.
\]

Unlike bin-based measures, it retains the feature's scale. A shift of temperature by 2°C has an interpretable Wasserstein distance of about 2°C under a pure translation.

### 6.10 Drift does not imply performance degradation

Data drift is:

\[
P_{train}(X)\ne P_{prod}(X).
\]

Concept drift is:

\[
P_{train}(Y\mid X)\ne P_{prod}(Y\mid X).
\]

The deployed risk is:

\[
R_{prod}(f)=\mathbb{E}_{(X,Y)\sim P_{prod}}[L(f(X),Y)].
\]

Monitoring \(P(X)\) alone cannot fully determine \(R_{prod}\), because labels and the conditional relationship matter. Drift alerts should initiate investigation, not blind retraining.

### 6.11 Online experiments

For conversion rates \(\hat p_A\) and \(\hat p_B\), the estimated treatment effect is:

\[
\hat\Delta=\hat p_B-\hat p_A.
\]

Under an independent normal approximation:

\[
SE(\hat\Delta)=
\sqrt{\frac{\hat p_A(1-\hat p_A)}{n_A}+
\frac{\hat p_B(1-\hat p_B)}{n_B}}.
\]

Use power analysis before the experiment, stable user-level randomization, guardrail metrics, and a predeclared stopping rule. Repeatedly checking significance and stopping when favorable inflates false positives unless sequential methods are used.

### 6.12 Reliability, SLOs, and error budgets

Availability over a window is:

\[
\operatorname{Availability}=
\frac{\text{successful valid requests}}
{\text{total valid requests}}.
\]

For a 99.9% availability SLO, the error-budget fraction is:

\[
1-0.999=0.001=0.1\%.
\]

Latency should be reported with percentiles. If \(T\) is request latency, p99 is a value \(t\) such that approximately 99% of requests satisfy \(T\le t\). A low mean can hide a harmful tail.

### 6.13 Throughput and capacity

Little's Law relates average number of requests in a stable system \(L\), arrival rate \(\lambda\), and average time \(W\):

\[
L=\lambda W.
\]

If traffic is 200 requests/second and average time in the system is 0.1 seconds, approximately 20 requests are in flight on average. Real capacity planning also accounts for bursts, p99 latency, resource saturation, failures, and headroom.

### 6.14 Business value

For a decision system:

\[
\begin{aligned}
\operatorname{Value} ={}& TP\cdot V_{TP}
-FP\cdot C_{FP}
-FN\cdot C_{FN} \\
&-C_{compute}-C_{review}-C_{maintenance}.
\end{aligned}
\]

This connects model behavior to real consequences. Values should include downstream workload: increasing recall may overload human reviewers and reduce total benefit.

---

## 7. Practical Implementation

This compact project demonstrates the complete path from training to an API: reproducible data generation, leakage-safe preprocessing, evaluation gates, artifact metadata, request validation, model-version reporting, tests, containerization, and CI. It is deliberately small enough to explain in an interview.

### 7.1 Project layout

```text
mlops-demo/
├── train.py
├── app.py
├── test_system.py
├── requirements.txt
├── Dockerfile
├── artifacts/                 # generated, stored in artifact storage in production
│   ├── churn_model.joblib
│   └── metadata.json
└── .github/workflows/ci.yml
```

### 7.2 Reproducible training pipeline

```python
# train.py
from __future__ import annotations

import hashlib
import json
import os
import platform
import subprocess
from datetime import datetime, timezone
from pathlib import Path

import joblib
import numpy as np
import pandas as pd
from sklearn.compose import ColumnTransformer
from sklearn.datasets import make_classification
from sklearn.impute import SimpleImputer
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import (
    average_precision_score,
    brier_score_loss,
    classification_report,
    roc_auc_score,
)
from sklearn.model_selection import train_test_split
from sklearn.pipeline import Pipeline
from sklearn.preprocessing import OneHotEncoder, StandardScaler

SEED = 42
ARTIFACT_DIR = Path("artifacts")
MODEL_PATH = ARTIFACT_DIR / "churn_model.joblib"
METADATA_PATH = ARTIFACT_DIR / "metadata.json"


def git_sha() -> str:
    """Return the current commit when available, otherwise an explicit marker."""
    try:
        return subprocess.check_output(
            ["git", "rev-parse", "HEAD"], text=True, stderr=subprocess.DEVNULL
        ).strip()
    except (FileNotFoundError, subprocess.CalledProcessError):
        return "unknown"


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def make_demo_data(n_samples: int = 5_000) -> pd.DataFrame:
    """Create deterministic data so the example runs without a download."""
    x, y = make_classification(
        n_samples=n_samples,
        n_features=4,
        n_informative=3,
        n_redundant=0,
        weights=[0.78, 0.22],
        class_sep=1.1,
        random_state=SEED,
    )
    rng = np.random.default_rng(SEED)
    frame = pd.DataFrame(
        x,
        columns=["tenure_signal", "usage_signal", "support_signal", "price_signal"],
    )
    frame["contract_type"] = rng.choice(
        ["monthly", "annual", "two_year"], size=n_samples, p=[0.55, 0.30, 0.15]
    )
    frame["churn"] = y
    return frame


def validate_training_data(frame: pd.DataFrame) -> None:
    """Fail early on contract violations at the training trust boundary."""
    expected = {
        "tenure_signal",
        "usage_signal",
        "support_signal",
        "price_signal",
        "contract_type",
        "churn",
    }
    if set(frame.columns) != expected:
        raise ValueError(f"Schema mismatch: expected {sorted(expected)}")
    if frame.empty or frame["churn"].isna().any():
        raise ValueError("Training data or labels are missing")
    if not set(frame["churn"].unique()) <= {0, 1}:
        raise ValueError("churn must be binary")
    if not frame["contract_type"].isin({"monthly", "annual", "two_year"}).all():
        raise ValueError("Unknown contract_type")
    positive_rate = float(frame["churn"].mean())
    if not 0.05 <= positive_rate <= 0.50:
        raise ValueError(f"Implausible positive rate: {positive_rate:.3f}")


def build_pipeline() -> Pipeline:
    numeric = ["tenure_signal", "usage_signal", "support_signal", "price_signal"]
    categorical = ["contract_type"]

    numeric_steps = Pipeline(
        [
            ("impute", SimpleImputer(strategy="median")),
            ("scale", StandardScaler()),
        ]
    )
    categorical_steps = Pipeline(
        [
            ("impute", SimpleImputer(strategy="most_frequent")),
            ("encode", OneHotEncoder(handle_unknown="ignore")),
        ]
    )
    preprocessing = ColumnTransformer(
        [
            ("numeric", numeric_steps, numeric),
            ("categorical", categorical_steps, categorical),
        ]
    )
    return Pipeline(
        [
            ("preprocessing", preprocessing),
            ("model", LogisticRegression(max_iter=1_000, random_state=SEED)),
        ]
    )


def main() -> None:
    frame = make_demo_data()
    validate_training_data(frame)

    features = frame.drop(columns="churn")
    labels = frame["churn"]
    x_train, x_test, y_train, y_test = train_test_split(
        features,
        labels,
        test_size=0.20,
        stratify=labels,
        random_state=SEED,
    )

    pipeline = build_pipeline()
    pipeline.fit(x_train, y_train)  # preprocessing is fitted only on training data
    probabilities = pipeline.predict_proba(x_test)[:, 1]
    predictions = (probabilities >= 0.50).astype(int)

    metrics = {
        "roc_auc": float(roc_auc_score(y_test, probabilities)),
        "pr_auc": float(average_precision_score(y_test, probabilities)),
        "brier": float(brier_score_loss(y_test, probabilities)),
    }
    print(json.dumps(metrics, indent=2))
    print(classification_report(y_test, predictions, digits=3))

    # A real project chooses gates from business and historical evidence.
    if metrics["roc_auc"] < 0.75 or metrics["pr_auc"] < 0.45:
        raise RuntimeError(f"Candidate failed quality gates: {metrics}")

    ARTIFACT_DIR.mkdir(parents=True, exist_ok=True)
    temporary_path = MODEL_PATH.with_suffix(".tmp")
    joblib.dump(pipeline, temporary_path)
    os.replace(temporary_path, MODEL_PATH)  # atomic replacement on one filesystem

    metadata = {
        "model_name": "churn-demo",
        "model_version": datetime.now(timezone.utc).strftime("%Y%m%dT%H%M%SZ"),
        "created_at": datetime.now(timezone.utc).isoformat(),
        "git_sha": git_sha(),
        "python_version": platform.python_version(),
        "data_version": "synthetic-v1-seed-42",
        "random_seed": SEED,
        "decision_threshold": 0.50,
        "metrics": metrics,
        "signature": {
            "inputs": {
                "tenure_signal": "float",
                "usage_signal": "float",
                "support_signal": "float",
                "price_signal": "float",
                "contract_type": ["monthly", "annual", "two_year"],
            },
            "outputs": {"churn_probability": "float in [0, 1]"},
        },
        "artifact_sha256": sha256(MODEL_PATH),
    }
    METADATA_PATH.write_text(json.dumps(metadata, indent=2), encoding="utf-8")
    print(f"Saved {MODEL_PATH} and {METADATA_PATH}")


if __name__ == "__main__":
    main()
```

### 7.3 FastAPI inference service

```python
# app.py
from __future__ import annotations

import hashlib
import json
import logging
import time
import uuid
from contextlib import asynccontextmanager
from pathlib import Path

import joblib
import pandas as pd
from fastapi import FastAPI, HTTPException, Request
from pydantic import BaseModel, ConfigDict, Field

MODEL_PATH = Path("artifacts/churn_model.joblib")
METADATA_PATH = Path("artifacts/metadata.json")
logger = logging.getLogger("churn_service")
logging.basicConfig(level=logging.INFO)


def sha256(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as file:
        for chunk in iter(lambda: file.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


class ChurnRequest(BaseModel):
    model_config = ConfigDict(extra="forbid")

    tenure_signal: float = Field(ge=-20, le=20)
    usage_signal: float = Field(ge=-20, le=20)
    support_signal: float = Field(ge=-20, le=20)
    price_signal: float = Field(ge=-20, le=20)
    contract_type: str = Field(pattern="^(monthly|annual|two_year)$")


class ChurnResponse(BaseModel):
    churn_probability: float
    churn_prediction: int
    model_version: str
    trace_id: str


@asynccontextmanager
async def lifespan(app: FastAPI):
    if not MODEL_PATH.exists() or not METADATA_PATH.exists():
        raise RuntimeError("Run train.py before starting the API")

    metadata = json.loads(METADATA_PATH.read_text(encoding="utf-8"))
    if sha256(MODEL_PATH) != metadata["artifact_sha256"]:
        raise RuntimeError("Model digest does not match approved metadata")

    # Only load artifacts from a trusted build pipeline. joblib/pickle is unsafe
    # for untrusted files because deserialization can execute arbitrary code.
    app.state.model = joblib.load(MODEL_PATH)
    app.state.metadata = metadata
    yield


app = FastAPI(title="Churn Prediction API", version="1.0", lifespan=lifespan)


@app.middleware("http")
async def observe_request(request: Request, call_next):
    trace_id = request.headers.get("X-Trace-ID", str(uuid.uuid4()))
    request.state.trace_id = trace_id
    started = time.perf_counter()
    response = await call_next(request)
    latency_ms = (time.perf_counter() - started) * 1_000
    response.headers["X-Trace-ID"] = trace_id
    logger.info(
        "request path=%s status=%s latency_ms=%.2f trace_id=%s",
        request.url.path,
        response.status_code,
        latency_ms,
        trace_id,
    )
    return response


@app.get("/health/live")
def liveness() -> dict[str, str]:
    return {"status": "alive"}


@app.get("/health/ready")
def readiness(request: Request) -> dict[str, str]:
    if not hasattr(request.app.state, "model"):
        raise HTTPException(status_code=503, detail="Model is not loaded")
    return {
        "status": "ready",
        "model_version": request.app.state.metadata["model_version"],
    }


@app.post("/predict", response_model=ChurnResponse)
def predict(payload: ChurnRequest, request: Request) -> ChurnResponse:
    row = pd.DataFrame([payload.model_dump()])
    probability = float(request.app.state.model.predict_proba(row)[0, 1])
    threshold = float(request.app.state.metadata["decision_threshold"])
    return ChurnResponse(
        churn_probability=probability,
        churn_prediction=int(probability >= threshold),
        model_version=request.app.state.metadata["model_version"],
        trace_id=request.state.trace_id,
    )
```

Run locally:

```bash
python train.py
uvicorn app:app --host 0.0.0.0 --port 8000
```

Example request:

```bash
curl -X POST http://localhost:8000/predict \
  -H "Content-Type: application/json" \
  -d '{
    "tenure_signal": 0.2,
    "usage_signal": -1.1,
    "support_signal": 1.7,
    "price_signal": 0.8,
    "contract_type": "monthly"
  }'
```

Example response:

```json
{
  "churn_probability": 0.731,
  "churn_prediction": 1,
  "model_version": "20260812T103000Z",
  "trace_id": "48e7a2d4-42d2-482a-ae5c-d6df7a99d470"
}
```

### 7.4 Small system tests

```python
# test_system.py
import importlib
import json

import joblib
import pandas as pd
from fastapi.testclient import TestClient

import train


def ensure_artifact() -> None:
    if not train.MODEL_PATH.exists():
        train.main()


def test_training_artifact_contract() -> None:
    ensure_artifact()
    metadata = json.loads(train.METADATA_PATH.read_text(encoding="utf-8"))
    model = joblib.load(train.MODEL_PATH)
    row = pd.DataFrame(
        [
            {
                "tenure_signal": 0.0,
                "usage_signal": 0.0,
                "support_signal": 0.0,
                "price_signal": 0.0,
                "contract_type": "monthly",
            }
        ]
    )
    probability = float(model.predict_proba(row)[0, 1])
    assert 0.0 <= probability <= 1.0
    assert metadata["metrics"]["roc_auc"] >= 0.75


def test_prediction_api() -> None:
    ensure_artifact()
    app_module = importlib.import_module("app")
    with TestClient(app_module.app) as client:
        response = client.post(
            "/predict",
            json={
                "tenure_signal": 0.2,
                "usage_signal": -1.1,
                "support_signal": 1.7,
                "price_signal": 0.8,
                "contract_type": "monthly",
            },
        )
        assert response.status_code == 200
        body = response.json()
        assert 0.0 <= body["churn_probability"] <= 1.0
        assert body["churn_prediction"] in (0, 1)
        assert body["model_version"]


def test_invalid_category_is_rejected() -> None:
    ensure_artifact()
    app_module = importlib.import_module("app")
    with TestClient(app_module.app) as client:
        response = client.post(
            "/predict",
            json={
                "tenure_signal": 0,
                "usage_signal": 0,
                "support_signal": 0,
                "price_signal": 0,
                "contract_type": "weekly",
            },
        )
        assert response.status_code == 422
```

### 7.5 Dependencies

```text
# requirements.txt -- pin exact tested versions in a real release lock file
fastapi
httpx
joblib
numpy
pandas
pydantic
pytest
scikit-learn
uvicorn[standard]
```

Exact version pins or a resolved lock file should be produced by the project's dependency tool. Unbounded dependencies in a production image make future rebuilds non-reproducible.

### 7.6 Container image

```dockerfile
# Dockerfile
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /service

RUN useradd --create-home --uid 10001 appuser
COPY requirements.txt .
RUN pip install --requirement requirements.txt

COPY app.py ./app.py
COPY artifacts ./artifacts

USER appuser
EXPOSE 8000

CMD ["uvicorn", "app:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
```

Build and run:

```bash
docker build -t churn-api:1.0 .
docker run --rm -p 8000:8000 churn-api:1.0
```

For large artifacts, a startup process may securely fetch a registry-approved artifact instead of copying it into the image. Pin the model by digest and fail readiness until validation and loading complete.

### 7.7 CI pipeline

```yaml
# .github/workflows/ci.yml
name: ml-ci

on:
  pull_request:
  push:
    branches: [main]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: pip
      - run: pip install --requirement requirements.txt
      - run: python train.py
      - run: pytest -q
      - run: docker build -t churn-api:${{ github.sha }} .
```

Production CI should also lint, type-check, scan dependencies and images, generate an SBOM, verify licenses, sign artifacts/images, and upload outputs to controlled storage. Deployment credentials should not be exposed to untrusted pull-request code.

### 7.8 MLflow experiment tracking example

The local JSON metadata above teaches the concept without requiring a server. If MLflow is available, a run can be recorded as follows:

```python
import mlflow
import mlflow.sklearn

with mlflow.start_run(run_name="logistic-churn") as run:
    mlflow.log_params(
        {
            "model": "logistic_regression",
            "max_iter": 1000,
            "data_version": "synthetic-v1-seed-42",
            "seed": 42,
        }
    )
    pipeline.fit(x_train, y_train)
    probabilities = pipeline.predict_proba(x_test)[:, 1]
    metrics = {
        "roc_auc": roc_auc_score(y_test, probabilities),
        "pr_auc": average_precision_score(y_test, probabilities),
        "brier": brier_score_loss(y_test, probabilities),
    }
    mlflow.log_metrics(metrics)
    signature = mlflow.models.infer_signature(
        x_train.head(), pipeline.predict_proba(x_train.head())[:, 1]
    )
    mlflow.sklearn.log_model(
        pipeline,
        name="model",
        signature=signature,
        input_example=x_train.head(3),
    )
    print("run_id:", run.info.run_id)
```

An organization can register the logged artifact after gates pass. Registration and production promotion should be separate events with separate permissions where risk requires it.

### 7.9 A minimal drift report

```python
import numpy as np
import pandas as pd


def population_stability_index(
    reference: pd.Series,
    current: pd.Series,
    bins: int = 10,
    epsilon: float = 1e-6,
) -> float:
    """Compute PSI using quantile bins learned only from the reference data."""
    reference = reference.dropna().to_numpy()
    current = current.dropna().to_numpy()
    if len(reference) == 0 or len(current) == 0:
        raise ValueError("Both samples need non-null observations")

    edges = np.unique(np.quantile(reference, np.linspace(0, 1, bins + 1)))
    if len(edges) < 3:
        raise ValueError("Reference feature has too few distinct values")
    edges[0], edges[-1] = -np.inf, np.inf

    expected, _ = np.histogram(reference, bins=edges)
    actual, _ = np.histogram(current, bins=edges)
    expected = np.clip(expected / expected.sum(), epsilon, None)
    actual = np.clip(actual / actual.sum(), epsilon, None)
    return float(np.sum((actual - expected) * np.log(actual / expected)))


if __name__ == "__main__":
    rng = np.random.default_rng(42)
    baseline = pd.Series(rng.normal(0, 1, 10_000))
    unchanged = pd.Series(rng.normal(0, 1, 10_000))
    shifted = pd.Series(rng.normal(1.0, 1, 10_000))

    assert population_stability_index(baseline, unchanged) < 0.1
    assert population_stability_index(baseline, shifted) > 0.1
```

For categorical features, align category counts across reference and current windows, explicitly track unseen and missing categories, smooth zero proportions, and monitor both per-category rates and an aggregate distance.

### 7.10 Batch prediction pattern

```python
from pathlib import Path
import json

import joblib
import pandas as pd


def score_partition(input_path: str, output_path: str) -> None:
    model = joblib.load("artifacts/churn_model.joblib")
    metadata = json.loads(Path("artifacts/metadata.json").read_text())
    frame = pd.read_parquet(input_path)

    # Production code applies the same contract used for online requests.
    scores = model.predict_proba(frame)[:, 1]
    result = pd.DataFrame(
        {
            "customer_id": frame["customer_id"],
            "churn_probability": scores,
            "model_version": metadata["model_version"],
            "scored_at": pd.Timestamp.now(tz="UTC"),
        }
    )

    temporary = f"{output_path}.tmp"
    result.to_parquet(temporary, index=False)
    Path(temporary).replace(output_path)  # readers never see a partial local file
```

Distributed/object-storage jobs normally write a versioned output prefix and publish a success manifest after all partitions succeed rather than relying on a local filesystem rename.

---

## 8. Code Explanation

### Training data and validation

`make_demo_data` is deterministic because the same seed controls both scikit-learn and NumPy generation. In a real project, replace the string data version with an immutable table snapshot, object-store version, or manifest of partitions and hashes.

`validate_training_data` is intentionally executed before splitting or fitting. It enforces the contract at the boundary where untrusted upstream data enters training. Structural checks alone are insufficient, so it also checks label semantics and a plausible positive rate.

### Leakage-safe pipeline

`ColumnTransformer` applies numeric and categorical transformations. `SimpleImputer`, `StandardScaler`, `OneHotEncoder`, and `LogisticRegression` are wrapped in one scikit-learn `Pipeline`.

This has two operational benefits:

1. calling `fit(x_train, y_train)` fits imputation, scaling, encoding, and the model only from training data;
2. serializing the pipeline keeps preprocessing and prediction together, reducing training-serving skew.

`handle_unknown="ignore"` prevents a new category from crashing inference. That is not a substitute for monitoring: unseen-category rates should still be measured, and important new categories may require retraining.

### Evaluation gates

The example measures ranking with ROC-AUC and PR-AUC and probability quality with the Brier score. The fixed numerical gate demonstrates the mechanism, not a universal threshold. A real gate should compare the candidate with a versioned baseline and allow only a justified tolerance on overall, slice, and operational metrics.

### Atomic artifact and metadata writing

The model first writes to a temporary path, then `os.replace` publishes it atomically on the same filesystem. This prevents another process from reading a partially written file. Distributed storage requires its own commit/manifest protocol.

The metadata connects the artifact to code, data, environment, metrics, signature, decision threshold, and checksum. The checksum detects corruption or accidental substitution; it does not prove who created the artifact. Artifact signing and provenance attestations address authenticity.

### API lifespan and validation

The FastAPI lifespan handler loads the artifact once when the process starts, rather than on every request. It verifies the checksum before loading and refuses to start if the model or metadata is missing.

Pydantic validates types, ranges, allowed categories, and extra fields at the request boundary. These ranges should come from a maintained data contract. Authentication, authorization, rate limiting, request-size limits, and privacy-safe logging would normally be handled by the application or platform.

### Health endpoints

- **Liveness** answers whether the process is alive. Repeated failure generally restarts it.
- **Readiness** answers whether the process can receive traffic. It stays false until the model is validated and loaded.

Conflating the two can cause a restart loop during slow model loading or send traffic to an unready instance.

### Observability middleware

The middleware assigns or propagates a trace ID and measures request latency. Production systems expose aggregated counters and histograms rather than deriving dashboards only from text logs. Do not log raw sensitive features; log a privacy-reviewed subset, hashes where appropriate, aggregate statistics, model version, and trace identifiers.

### System tests

The tests leave three compact guarantees:

1. training emits an artifact that meets the declared quality gate;
2. a valid API request returns a bounded probability and version identity;
3. an invalid category is rejected at the trust boundary.

Large model projects should separate fast pull-request tests from expensive scheduled evaluation, but both should produce auditable reports.

### Docker image

The image uses a small runtime base, deterministic working directory, unbuffered logs, and a non-root user. The image contains serving code and artifact, making the pair immutable. The same principle also works when the image contains only serving code and securely resolves a pinned artifact digest on startup.

### CI workflow

The workflow checks out the exact commit, installs dependencies, trains, tests, and builds the serving image. A mature workflow promotes the same tested image digest across environments; it does not rebuild independently for staging and production because different rebuilds can resolve different bytes.

### Drift code

The PSI function learns quantile-bin edges from the reference sample only, then applies identical edges to current data. Infinite endpoints capture observations beyond the old range, while epsilon smoothing prevents division by zero. The assertions are a small runnable check that an unchanged sample scores low and a clearly shifted sample scores higher.

---

## 9. Training / Evaluation

### 9.1 Dataset preparation

Start with the prediction timestamp. For every row, ask: “Could this value have been known when the prediction was made?” This prevents target leakage from post-outcome information.

Recommended preparation sequence:

1. define entity, event time, label window, and observation window;
2. freeze or record raw source versions;
3. deduplicate using a documented business key;
4. validate schema and semantics;
5. create labels with explicit censoring rules;
6. build features using point-in-time joins;
7. record excluded rows and reasons;
8. produce immutable split assignments;
9. fit learned preprocessing on the training split only.

For delayed outcomes, do not label recent examples as negatives merely because their outcome window has not completed. They are **censored** or not yet label-ready.

### 9.2 Train/validation/test split

| Situation | Suitable split | Leakage prevented |
|---|---|---|
| IID tabular examples | Random, often stratified | Class imbalance across partitions |
| Repeated users/patients | Group split | Same entity in train and test |
| Forecasting/future behavior | Temporal split | Training on the future |
| Images from same video/scene | Group by source | Near-duplicate frames across splits |
| Geographic expansion | Geographic holdout | Overestimating transfer to a new region |
| Recommendation/ranking | User/time-aware split | Future interactions and duplicated users/items |

Use training data to fit parameters, validation data to tune hyperparameters and thresholds, and test data for a final unbiased estimate. Repeatedly selecting based on the test set turns it into another validation set.

### 9.3 Offline metrics

Select metrics from the decision:

- **Rare-event classification:** PR-AUC, recall at fixed precision, precision/recall at capacity.
- **Balanced classification:** accuracy can be useful, but still inspect class-specific errors.
- **Probabilistic decision:** log loss, Brier score, reliability plots, calibration-in-the-large.
- **Regression:** MAE for linear error cost, RMSE when large errors matter more, quantile loss for asymmetric decisions.
- **Ranking/recommendation:** NDCG@K, MAP@K, recall@K, coverage, diversity, and online impact.
- **Forecasting:** horizon-specific MAE/RMSE, MASE, bias, interval coverage, and time-slice stability.

Always compare with the existing system or a simple baseline. Report slices and confidence intervals, not only a single average.

### 9.4 Operational evaluation

Before deployment, measure:

- cold-start and warmed latency at p50/p95/p99;
- throughput under expected and burst load;
- CPU/GPU and memory utilization;
- model-loading time and artifact size;
- response behavior for invalid, missing, extreme, and unseen inputs;
- dependency failure behavior and timeouts;
- cost per 1,000 predictions;
- consistency between offline and service predictions.

Load testing should use realistic payload distributions and concurrency. Average latency from sequential local calls does not predict p99 under production contention.

### 9.5 Online evaluation

Use a staged progression:

1. offline backtest;
2. production-like integration test;
3. shadow traffic;
4. small canary with operational gates;
5. A/B test for causal product impact when appropriate;
6. gradual ramp with rollback available.

Track primary business outcome, model/decision metric, service metrics, cost, and guardrails such as complaints, fairness, or manual-review burden.

### 9.6 Overfitting and underfitting

- **Underfitting:** poor training and validation quality. Improve features, model capacity, optimization, or label quality.
- **Classical overfitting:** strong training quality and weak validation quality. Add data, regularize, simplify, stop earlier, or fix leakage/split issues.
- **Validation overfitting:** repeated tuning against one validation set. Use nested validation, a fresh holdout, or reduce search degrees of freedom.
- **Operational overfitting:** optimize the model metric while ignoring latency, cost, slices, or business impact.
- **Feedback overfitting:** learn from selectively observed outcomes produced by the previous policy.

### 9.7 Hyperparameters and configuration

Version all behavior-changing configuration:

- model parameters and architecture;
- optimizer, learning rate, batch size, epochs, early stopping;
- feature list and preprocessing parameters;
- train/validation/test boundaries;
- random seed;
- class/sample weights;
- calibration method and decision threshold;
- serving batch size, timeout, and numeric precision.

Secrets are configuration but must be referenced from a secret manager, never committed or logged.

### 9.8 Improving performance safely

Prioritize improvements in this order:

1. verify label and metric correctness;
2. fix leakage and split design;
3. improve data quality and coverage;
4. analyze errors and important slices;
5. improve features or representation;
6. tune threshold/calibration for the decision;
7. tune the model;
8. increase model complexity only if gains justify operational cost.

Every change should be evaluated on the same versioned comparison set or with a documented new benchmark.

### 9.9 Promotion policy example

A candidate can be promoted only if all conditions hold:

```text
PR-AUC(candidate) >= PR-AUC(champion) + 0.01
Recall_at_capacity(candidate) >= Recall_at_capacity(champion)
Brier(candidate) <= Brier(champion) + 0.005
Recall(each critical slice) >= agreed minimum
p99_latency <= 80 ms at target load
artifact_size <= 300 MB
no critical security findings
schema and serving-contract tests pass
human approval present for high-risk model
```

Gates should include a permissible regression tolerance because metrics fluctuate. A Pareto decision may be better than requiring strict improvement on every metric.

---

## 10. Complexity and Cost

### 10.1 Training complexity

Training cost is model-specific. For \(n\) rows, \(d\) features, and \(E\) epochs:

- a rough linear-model gradient cost is \(O(End)\);
- tree ensembles depend on trees, depth, rows, features sampled, and split algorithm;
- deep-network training is dominated by forward/backward tensor operations and stored activations;
- hyperparameter search multiplies cost by the number of trials, though parallelism reduces wall-clock time rather than total compute.

The full pipeline also spends time on reading data, joins, feature computation, validation, serialization, network transfer, and queue delay. In tabular systems, data processing can cost more than model fitting.

### 10.2 Inference complexity

- Linear model: approximately \(O(d)\) operations per example.
- Balanced tree ensemble: roughly \(O(TD)\), where \(T\) is number of trees and \(D\) average depth.
- Transformer: self-attention is approximately \(O(s^2h)\) in sequence length \(s\) and hidden dimension \(h\), plus projection/feed-forward costs; KV caching changes autoregressive generation cost and memory behavior.

For online serving, batch size trades throughput against per-request latency. Dynamic batching improves accelerator utilization but adds queue time.

### 10.3 Memory

Serving memory includes:

\[
M_{total}\approx M_{weights}+M_{runtime}+M_{features}+M_{activations/cache}+M_{workers}.
\]

Multiple process workers may each hold a model copy. Memory-mapping or a shared model server can reduce duplication for compatible workloads. GPU memory must include weights, activations, attention/KV cache, framework workspace, and fragmentation headroom.

### 10.4 Storage and lineage cost

Naively copying every dataset and checkpoint is expensive. Common controls are:

- immutable object storage with lifecycle/retention policies;
- content-addressed deduplication;
- manifests referencing existing partitions;
- keeping only policy-required checkpoints;
- separating metadata retention from bulk artifact retention;
- compressing artifacts and using appropriate columnar formats.

Do not delete artifacts required for audits, reproducibility, rollback, or legal retention merely to reduce cost.

### 10.5 Serving cost

Approximate cost per prediction:

\[
C_{prediction}=\frac{C_{compute}+C_{memory}+C_{network}+C_{platform}+C_{idle}}
{N_{predictions}}.
\]

Batch inference often has lower unit cost because it uses larger batches and avoids always-on replicas. Online inference pays for readiness, redundancy, autoscaling headroom, and tail-latency limits.

### 10.6 CPU versus GPU

Use CPU when the model is small, traffic is moderate, latency is already acceptable, or preprocessing dominates. Use GPU/accelerators when tensor operations are large enough and batching/traffic can utilize them. A GPU can be slower or more expensive for tiny requests with transfer and queue overhead.

### 10.7 Total cost of ownership

Infrastructure is only part of cost:

\[
TCO = C_{build}+C_{train}+C_{serve}+C_{store}+C_{observe}+C_{people}+C_{risk}.
\]

A highly optimized custom platform may save compute yet cost more in engineering and incidents. Managed services trade direct price for reduced operational burden. The right choice depends on scale, regulatory needs, team expertise, and opportunity cost.

### 10.8 Cost-control techniques

- batch predictions when freshness permits;
- autoscale with safe minimum capacity;
- use spot/preemptible workers for restartable training jobs;
- cache deterministic repeated results with a version-aware key;
- choose smaller models, quantization, pruning, or distillation when quality holds;
- use early stopping and efficient hyperparameter search;
- reuse versioned features instead of recomputing them unnecessarily;
- set storage lifecycle policies;
- tag costs by team, model, environment, and version;
- monitor cost per successful prediction and cost per business outcome.

---

## 11. Common Use Cases

### 11.1 Fraud detection

Transactions are scored synchronously before authorization. The system needs fresh account/device features, strict p99 latency, high availability, calibrated risk, and a rule/manual-review fallback. Labels arrive after investigation or chargeback, so early monitoring relies on score distribution, rule disagreement, review outcomes, and data quality.

### 11.2 Recommendation and ranking

Candidate generation may run in batch, while ranking runs online. Feature freshness and low latency matter; online behavior is affected by what the model previously displayed. Teams use stable user-level experiments, monitor diversity and coverage, and correct for exposure and position bias when learning from feedback.

### 11.3 Customer churn and propensity scoring

Daily or weekly batch scoring is often sufficient. Key concerns are label-window correctness, time-based validation, campaign capacity, probability calibration, and measuring incremental benefit rather than merely contacting users who would have stayed anyway.

### 11.4 Demand forecasting

Training and backtesting must respect time. Monitoring includes horizon-specific error, bias, interval coverage, stockout/waste cost, seasonality, and structural breaks. Retraining may be scheduled, but holidays and promotions often require explicit future covariates and human overrides.

### 11.5 Predictive maintenance

Sensor data is streamed or processed at the edge. The pipeline must handle missing/out-of-order events, sensor recalibration, equipment-specific slices, rare failure labels, and a lead-time metric: a correct alert that arrives too late has little value.

### 11.6 Medical imaging or clinical decision support

The model and data require strong provenance, versioned preprocessing, subgroup evaluation, privacy controls, human oversight, and audit logs. Site/scanner drift can be significant. Safe deployment may use silent prospective validation before any output affects decisions.

### 11.7 Computer-vision quality inspection

Images are checked on a production line. Monitor camera position, illumination, resolution, focus, class mix, line speed, latency, and false rejects. Edge hardware may require quantization and a compact model; a safe fallback can divert uncertain items for manual review.

### 11.8 Search and information retrieval

Index building is usually batch or streaming; query serving is online. MLOps versions documents, analyzers, embeddings, index snapshots, rankers, and relevance judgments. Evaluation combines recall of retrieval, ranking metrics, latency, freshness, and online satisfaction.

### 11.9 LLM and RAG applications

The operational unit includes prompts, system policies, foundation-model version, decoding parameters, retrieval corpus, embedding model, chunking, index, tools, and safety filters. Monitoring includes answer quality, groundedness, retrieval recall, tool errors, safety, latency, and token/currency cost.

### 11.10 Edge and mobile inference

Models are packaged for constrained devices and may run offline. Evaluation covers hardware-specific latency, memory, battery, thermal behavior, quantization loss, compatibility, secure updates, and rollback. Model telemetry may be sampled or delayed because of privacy and connectivity.

### 11.11 Human-in-the-loop systems

The model prioritizes or recommends; a reviewer decides. Monitor reviewer load, agreement, turnaround time, automation bias, override reasons, and label quality. Randomly audited cases can reveal errors that selective review would otherwise hide.

### 11.12 Regulated decision systems

Credit, insurance, employment, and other high-impact domains need model inventories, documented intended use, lineage, approvals, access controls, explainability where required, fairness evaluation, change management, audit evidence, and an appeal or human-review process.

---

## 12. Common Mistakes

### 12.1 Treating deployment as the end

**Mistake:** Success is defined as exposing `/predict`.  
**Failure:** No one owns drift, labels, incidents, rollback, or retirement.  
**Correction:** Design monitoring, feedback, retraining criteria, fallback, and ownership before release.

### 12.2 Data leakage

**Mistake:** Features include values produced after the prediction timestamp, preprocessing is fitted before splitting, or duplicates cross partitions.  
**Failure:** Offline results are unrealistically high.  
**Correction:** Track event/availability time, use point-in-time joins, split before fitting transforms, group related samples, and review suspiciously predictive features.

### 12.3 Random split for temporal data

**Mistake:** Shuffle historical events when predicting the future.  
**Failure:** Training sees future regimes and near-duplicate histories.  
**Correction:** Backtest chronologically with a gap when leakage through delayed features is possible.

### 12.4 Wrong metric choice

**Mistake:** Report accuracy for 0.5% fraud or optimize AUROC when only the top 500 cases can be reviewed.  
**Failure:** A strong-looking model does not improve the real decision.  
**Correction:** Use PR-AUC, recall/precision at capacity, calibration, expected cost, and business guardrails.

### 12.5 Training-serving skew

**Mistake:** Reimplement features in the serving service or use different category handling.  
**Failure:** The deployed model sees values unlike those used for training.  
**Correction:** Reuse transformation code/artifacts, define one feature contract, compare offline and service predictions, and monitor feature parity.

### 12.6 Versioning the model but not the data

**Mistake:** Record `model_v5.pkl` without the data snapshot, label query, split, or features.  
**Failure:** Results cannot be reproduced or audited.  
**Correction:** Record complete lineage and use immutable or content-addressed references.

### 12.7 Mutable “latest” artifacts

**Mistake:** Production downloads `latest/model.pkl`.  
**Failure:** Rollback, audit, and incident correlation become ambiguous.  
**Correction:** Deploy immutable versions/digests; use `champion` only as a controlled alias resolving to an immutable artifact.

### 12.8 Uncontrolled pickle/joblib loading

**Mistake:** Load a user-uploaded or unauthenticated pickle.  
**Failure:** Pickle deserialization may execute arbitrary code.  
**Correction:** Load only trusted, access-controlled, integrity-checked artifacts; sign provenance; use safer portable formats when practical.

### 12.9 Monitoring only infrastructure

**Mistake:** Dashboards show CPU and HTTP errors, but not data or model behavior.  
**Failure:** The service can be perfectly healthy while returning incorrect predictions.  
**Correction:** Monitor service, data, model, business, slices, and cost.

### 12.10 Monitoring drift without actionability

**Mistake:** Alert on dozens of features using arbitrary PSI thresholds.  
**Failure:** Alert fatigue; harmless drift creates noise.  
**Correction:** Prioritize impactful features, calibrate thresholds from normal variability, require persistence/sample size, and attach a runbook.

### 12.11 Blind automatic retraining

**Mistake:** Any drift triggers retraining and immediate deployment.  
**Failure:** Drift may be harmless; new data may be corrupted; the candidate may regress.  
**Correction:** Retraining creates a candidate that must pass data, model, operational, and governance gates.

### 12.12 Ignoring delayed labels

**Mistake:** Monitor only real-time accuracy when ground truth arrives in 60 days, or treat unresolved outcomes as negative.  
**Failure:** Metrics are missing, biased, or falsely optimistic.  
**Correction:** Track label maturity, compute cohort-based delayed metrics, and use clearly named proxies in the interim.

### 12.13 Excessive dependence on notebooks

**Mistake:** Hidden notebook state, manual cell order, and local paths define training.  
**Failure:** Runs are difficult to reproduce and automate.  
**Correction:** Keep exploration in notebooks, then move the repeatable path to parameterized modules or scripts invoked by the pipeline.

### 12.14 Rebuilding between environments

**Mistake:** Build one container for staging and a new one for production from the same branch.  
**Failure:** Dependency resolution or base images may differ.  
**Correction:** Build once, test once, and promote the identical signed image digest.

### 12.15 Conflating liveness and readiness

**Mistake:** One health endpoint reports healthy before model loading or kills a process because a dependency is briefly unavailable.  
**Failure:** Traffic reaches unready instances or causes restart storms.  
**Correction:** Separate process liveness from ability to serve.

### 12.16 Unstable experiments

**Mistake:** Compare runs with different splits, data windows, metrics, or unrecorded seeds.  
**Failure:** The apparent model gain may be caused by experimental variation.  
**Correction:** Fix the comparison protocol and record every behavior-changing input.

### 12.17 Average-only evaluation

**Mistake:** Approve a model on aggregate accuracy.  
**Failure:** It may fail for an important region, device, language, or protected group.  
**Correction:** Define critical slices before evaluation, report sample sizes/uncertainty, and gate safety-critical slices.

### 12.18 Logging sensitive payloads

**Mistake:** Log raw requests and predictions for debugging.  
**Failure:** Privacy, compliance, and security exposure.  
**Correction:** Minimize fields, redact/tokenize, aggregate, restrict access, encrypt, and apply retention policies.

### 12.19 No rollback or fallback

**Mistake:** The only recovery is to train or rebuild.  
**Failure:** Incidents last much longer.  
**Correction:** Keep a previous known-good artifact, immutable deployment config, tested rollback, and safe non-ML fallback.

### 12.20 Building a platform before proving the need

**Mistake:** A small team builds a custom feature store, registry, orchestrator, and serving mesh before one model has production requirements.  
**Failure:** Platform maintenance replaces product learning.  
**Correction:** Begin with versioned scripts, CI, artifact storage, and monitoring; adopt shared infrastructure when repeated pain and scale justify it.

---

## 13. Edge Cases / Limitations

### 13.1 No labels or severely delayed labels

True performance cannot be measured immediately. Input/output drift and proxy outcomes can detect anomalies but do not prove correctness. Use mature cohorts, targeted labeling, random audits, weak labels with explicit caveats, and human review.

### 13.2 Selective labels

Ground truth is observed only for cases where the existing policy took an action—for example, repayment is observed only for approved loans. Training directly on observed outcomes creates selection bias. Exploration, randomized audits, causal methods, rejection inference, or carefully justified assumptions may be needed.

### 13.3 Rare events and small slices

Fraud, failures, and safety incidents may be extremely rare. Metrics have high variance, and slice estimates can be unstable. Report counts and intervals, pool time windows carefully, use stress/simulation tests, and avoid declaring safety from zero observed failures in a tiny sample.

### 13.4 Sudden regime change

Pandemics, regulation, pricing changes, new fraud attacks, or upstream redesigns can invalidate historical relationships. Scheduled retraining may adapt too slowly or learn contaminated data. Use change management, feature/data alarms, conservative fallbacks, explicit event indicators, and human incident response.

### 13.5 Cold start

New users, products, regions, or devices have little history. Backoff features, content-based models, priors, exploration, or rules are needed. Evaluation should include a cold-start slice rather than averaging it away.

### 13.6 Correlated or duplicated traffic

Monitoring formulas often assume independent samples, but requests from the same user/device are correlated. Confidence intervals become too narrow. Aggregate or bootstrap at the independent unit—often user, session, device, site, or time block.

### 13.7 Out-of-order and late events

Streaming features can differ depending on event time, arrival time, and watermark policy. Define late-data behavior, idempotent event IDs, correction/backfill logic, and parity between historical replay and online computation.

### 13.8 Unseen categories and schema evolution

Ignoring an unseen category prevents a crash but can hide a significant population change. Track unknown-category rates, support backward-compatible schema evolution, and require coordinated rollout for breaking changes.

### 13.9 Multi-model dependencies

One service may call an embedding model, retriever, ranker, and policy model. A component update changes system behavior even when others are fixed. Version the complete dependency graph and evaluate end to end as well as component by component.

### 13.10 Non-deterministic hardware and training

GPU kernels, distributed reductions, asynchronous data loading, and mixed precision can create run variation. Fix seeds and deterministic settings where reasonable, record hardware/runtime, and evaluate distributional reproducibility rather than promising bitwise equality when it is impractical.

### 13.11 Edge connectivity

Devices may be offline during rollout or telemetry collection. Maintain compatible model formats, staged updates, local rollback, integrity checks, and a policy for old versions that remain in the field.

### 13.12 Privacy restrictions

The best predictive features may not be legally or ethically usable. Data minimization, purpose limitation, consent, retention/deletion, residency, and access requirements constrain collection and observability. Privacy-preserving telemetry may reduce debugging detail.

### 13.13 Feedback loops and performative prediction

Predictions change user/system behavior, which changes future data. Recommendation exposure, policing allocation, and pricing are examples. Offline IID evaluation becomes insufficient; maintain exploration where safe, log propensities/exposure, and use causal or counterfactual evaluation carefully.

### 13.14 Dependency or artifact supply-chain risk

Models can contain executable serialization, custom operators, or compromised dependencies. Restrict producers and consumers, verify signatures and hashes, scan images/dependencies, generate provenance/SBOMs, and isolate loading/runtime where appropriate.

### 13.15 MLOps cannot repair a bad objective

Automation reliably repeats the specified process—even if the label, metric, incentive, or decision is wrong. Product, domain, legal, and ethical review remains necessary. Operational maturity is not evidence that a model should exist.

---

## 14. Variations

### 14.1 MLOps maturity levels

| Level | What changes | When to use | Placement importance |
|---|---|---|---|
| Manual | Notebook/script, manual artifact handoff | Prototype only; short lifetime | Know its risks |
| Repeatable pipeline | Versioned code/data/config, automated training/evaluation | First serious production model | Essential |
| CI/CD | Tests and controlled artifact/image promotion | Multiple releases and owners | Essential |
| Continuous training | Triggered retraining creates gated candidates | Fast-changing data with reliable labels | Common advanced topic |
| Platform/self-service | Shared templates, registry, feature/serving infrastructure | Many teams/models with repeated needs | System-design topic |

Maturity is not a contest. A batch model retrained quarterly may not need Kubernetes or continuous training. Use the least complex operating model that satisfies reliability and governance.

### 14.2 Batch MLOps

**What changes:** Predictions are materialized on a schedule; orchestration, partitioning, backfills, and idempotency dominate.  
**When to use:** Freshness can be minutes to days, and consumers read a table/file.  
**Importance:** Very high for placements because many real ML systems are batch systems.

### 14.3 Real-time MLOps

**What changes:** Online feature access, low latency, autoscaling, timeouts, load shedding, and high availability become primary.  
**When to use:** The decision must use current context and return immediately.  
**Importance:** High for AI/ML system-design interviews.

### 14.4 Streaming MLOps

**What changes:** Event-time semantics, windows, watermarks, state, replay, exactly-once/effectively-once behavior, and late data matter.  
**When to use:** Continuous events need near-real-time features or predictions.  
**Importance:** Useful for data/ML platform roles.

### 14.5 Edge MLOps

**What changes:** Hardware compatibility, compression, offline operation, fleet segmentation, privacy, update safety, and limited telemetry matter.  
**When to use:** Latency, connectivity, privacy, or bandwidth requires local inference.  
**Importance:** High for computer-vision/IoT projects and specialized roles.

### 14.6 LLMOps

**What changes:** Version prompts, foundation model/provider, adapters, decoding, tools, safety policies, eval datasets, and token cost. Evaluation is often multi-dimensional and may use human or model judges with calibration.  
**When to use:** Chat, extraction, agents, summarization, or generative workflows.  
**Importance:** High for current AI engineering interviews.

### 14.7 RAGOps

**What changes:** Version document corpus, parser, chunking, embedding model, vector index, metadata filters, retriever/reranker, prompt, and generator. Monitor retrieval and generation separately.  
**When to use:** Answers require fresh/private knowledge or citations.  
**Importance:** High for GenAI projects; interviewers expect retrieval recall and groundedness, not only final-answer ratings.

### 14.8 Federated MLOps

**What changes:** Training runs across decentralized devices/silos; client selection, secure aggregation, privacy, heterogeneous hardware/data, and model distribution are central.  
**When to use:** Data cannot be centralized and federation is technically and legally appropriate.  
**Importance:** More research/specialized than general placements.

### 14.9 Multi-cloud or hybrid MLOps

**What changes:** Portable artifacts, identity federation, data locality, network cost, duplicated control planes, and consistent governance matter.  
**When to use:** Regulation, acquisition, resilience, or existing infrastructure requires it.  
**Importance:** Senior/platform design; avoid claiming it is automatically more reliable.

### 14.10 Serverless inference

**What changes:** Infrastructure management decreases, but cold starts, package limits, execution duration, concurrency, and vendor constraints appear.  
**When to use:** Bursty, low-to-medium traffic and models small enough for the platform.  
**Importance:** Useful deployment trade-off question.

### 14.11 Managed versus self-hosted platform

**Managed:** Faster setup and less operational work, with vendor cost, constraints, and potential lock-in.  
**Self-hosted:** More control and portability, with substantial maintenance and on-call burden.  
**Interview answer:** Decide using scale, compliance, existing cloud, team skill, customization, reliability requirements, and total cost—not ideology.

### 14.12 GitOps for ML deployment

**What changes:** Desired deployment state is declared in Git; an automated controller reconciles the environment. Model/image digests and rollout configuration are reviewed changes.  
**When to use:** Kubernetes or declarative infrastructure environments requiring auditable changes.  
**Importance:** Helpful for ML platform/DevOps roles.

### 14.13 Shadow, canary, and A/B as distinct variants

| Method | Candidate affects users? | Measures business causality? | Primary purpose |
|---|---:|---:|---|
| Shadow | No | No | Real-input correctness, latency, disagreement |
| Canary | Yes, small share | Not necessarily | Limit operational/model risk during rollout |
| A/B test | Yes, randomized groups | Yes, with sound design | Estimate incremental product impact |

---

## 15. Related Topics

### MLOps versus DevOps

DevOps versions and operates software. MLOps inherits CI/CD, infrastructure automation, observability, and incident response, then adds data lineage, experiment tracking, statistical tests, model registry, drift, delayed labels, and continuous training.

### MLOps versus DataOps

DataOps ensures reliable, tested, discoverable data pipelines. MLOps consumes those outputs and adds feature/label construction, training, evaluation, packaging, serving, and model monitoring. A data-contract failure is often handled by DataOps and MLOps jointly.

### Experiment tracking versus model registry

Experiment tracking answers, “What did we try, with which inputs, and what happened?” A registry answers, “Which immutable model versions are governed candidates or approved for deployment?” Tracking has many failed runs; the registry contains curated release artifacts.

### Data versioning versus database backup

A backup restores storage after failure. Data versioning identifies the exact logical training input and its lineage. A nightly backup does not necessarily reveal which rows, partitions, filters, and label query produced a model.

### Feature store versus data warehouse

A warehouse stores analytical data. A feature store adds ML-specific feature definitions, entity keys, point-in-time historical retrieval, freshness, discovery, and sometimes low-latency online serving. Many teams can begin with warehouse transformations and add a feature store only when reuse or online consistency requires it.

### Model monitoring versus application monitoring

Application monitoring detects errors, latency, saturation, and availability. Model monitoring detects invalid/drifting inputs, changing predictions, delayed quality loss, calibration, and slice behavior. Both are necessary because an HTTP-healthy model can be statistically wrong.

### Data drift versus concept drift

Data drift changes \(P(X)\); concept drift changes \(P(Y\mid X)\). Feature-distribution checks can observe the former. Confirming the latter generally requires labels or a credible outcome proxy.

### Continuous delivery versus continuous deployment

Continuous **delivery** keeps an approved artifact ready for a production decision; continuous **deployment** automatically releases every qualifying change. High-risk ML often uses continuous delivery with a human approval gate.

### Continuous training versus online learning

Continuous training periodically/event-triggeredly creates a new artifact from accumulated data. Online learning updates parameters incrementally as observations arrive. Online learning adapts faster but makes reproducibility, rollback, poisoning defense, and evaluation harder.

### Canary release versus A/B testing

A canary limits blast radius and asks, “Is this version safe enough to ramp?” An A/B test asks, “Does using this version causally improve outcomes?” A canary may be non-random and too short for business-label measurement.

### Docker versus virtual machine

Containers package application dependencies while sharing the host kernel; they are lightweight and portable but not identical to strong VM isolation. VMs package a full guest OS and have higher overhead. ML deployment commonly uses containers on VMs or managed container platforms.

### Docker versus Kubernetes

Docker/container tooling packages and runs an image. Kubernetes schedules and operates containers across machines with desired replicas, health checks, service discovery, rollouts, and autoscaling. A single service does not automatically need Kubernetes.

### Orchestration versus workflow code

A Python script defines sequential logic. An orchestrator manages dependencies, schedules/events, retries, state, caching, backfills, credentials, resources, and visibility. Keep the business logic runnable outside the orchestrator so it remains testable.

### Model compression versus serving optimization

Quantization, pruning, and distillation change the model representation or training. Serving optimization also includes batching, compilation, caching, concurrency, hardware choice, and topology. Any optimization must be evaluated for quality, slices, numerical differences, and latency under realistic load.

### MLOps and responsible AI

Responsible AI defines objectives such as fairness, privacy, safety, transparency, and accountability. MLOps makes them operational through versioned evaluations, approval gates, audit logs, monitoring, access controls, and incident processes.

### MLOps and causal inference

Predictive metrics estimate association/generalization; deployment value often requires causal effect. A churn model may identify likely churners but not users whose churn can be prevented. A/B tests, uplift modeling, or causal analysis connects predictions to interventions.

### LLMOps versus classical MLOps

Classical MLOps usually treats a trained model and structured metric as the central artifact. LLMOps may depend on an external foundation model plus prompt, retrieval, tools, and policy. Outputs are open-ended, evaluation is less deterministic, and safety/token cost are first-class—but lineage, testing, rollout, monitoring, and governance principles remain the same.

---

## 16. Interview Questions

### Q1. What is MLOps, and why is it needed?

**Answer:** MLOps is the engineering discipline for reproducibly training, validating, releasing, monitoring, and governing ML systems. It is needed because production behavior depends on code, data, learned parameters, preprocessing, environment, and feedback. A model can degrade without a code change, so ordinary software CI/CD alone does not cover data lineage, statistical evaluation, drift, delayed labels, or retraining.

**Strong follow-up:** MLOps is not a list of tools. The essential properties are reproducibility, automation, safe promotion, observability, ownership, and controlled change.

### Q2. How is MLOps different from DevOps?

**Answer:** DevOps focuses on reliably building and operating software. MLOps reuses those practices but versions and validates additional artifacts: datasets, feature definitions, labels, splits, model parameters, thresholds, and evaluation reports. It must handle stochastic training, training-serving skew, distribution shift, delayed ground truth, slice performance, and continuous training.

### Q3. What should be recorded to reproduce a model?

**Answer:** Record:

- source-code commit and dirty-state/patch if applicable;
- immutable raw/training data version and label query;
- feature definitions and split assignments;
- configuration and hyperparameters;
- random seeds and determinism settings;
- dependency lock or container digest;
- framework, runtime, hardware when numerically relevant;
- training/evaluation artifacts and metrics;
- preprocessing state, model signature, threshold, and model checksum;
- parent run/model and approval history.

Reproducibility can mean exact bytes or statistically equivalent results. The required level depends on risk and platform capabilities, but lineage is non-negotiable.

### Q4. What is training-serving skew? How do you prevent it?

**Answer:** Training-serving skew occurs when production features or preprocessing differ from training. Causes include duplicated implementations, different time windows, category mappings, defaults, library versions, and online/offline data freshness.

Prevent it by packaging preprocessing with the model, sharing versioned feature definitions, using point-in-time-correct offline retrieval, declaring a schema/signature, replaying identical examples through offline and service paths, and monitoring feature parity and unknown/default rates.

### Q5. What is the difference between experiment tracking and a model registry?

**Answer:** Experiment tracking stores many runs—their parameters, data references, metrics, and artifacts—to compare attempts. A model registry is a governed inventory of selected immutable model versions with lineage, signatures, evaluation evidence, owners, approvals, aliases, and deployment/retirement status. A failed experiment belongs in tracking but generally not in the production registry.

### Q6. Explain CI, CD, and CT in MLOps.

**Answer:**

- **CI** validates changes with code tests, data/feature tests, small training checks, model invariants, and security checks.
- **Continuous delivery/deployment** packages and promotes an approved immutable artifact and image through environments using safe rollout and rollback.
- **CT** retrains on a schedule or trigger to produce a new candidate.

CT should not bypass validation. Retrain, evaluate, approve, and deploy are separate state transitions.

### Q7. How would you test an ML pipeline?

**Answer:** Use layers: unit tests for feature logic; schema and semantic data tests; point-in-time/leakage checks; integration tests from a small raw fixture to artifact; model invariants and baseline-regression gates; slice, robustness, fairness, and calibration evaluation; serving-contract parity; load/resilience tests; and security/provenance checks. Keep fast deterministic tests on pull requests and run expensive evaluations on controlled data or schedules.

### Q8. Data drift versus concept drift—what is the difference?

**Answer:** Data drift means \(P(X)\) changes. Concept drift means \(P(Y\mid X)\) changes, so the relationship used for prediction has changed. Input monitoring can observe data drift without labels; concept drift usually requires ground truth or a strong proxy. Drift does not necessarily reduce model quality, and performance can decline without obvious marginal feature drift.

### Q9. How do you monitor a model when labels arrive after 60 days?

**Answer:** Immediately monitor schema, missingness, freshness, category/range violations, feature/prediction distributions, uncertainty, baseline or champion disagreement, service health, cost, and early business proxies. Store prediction IDs, timestamps, version, and privacy-safe join keys so mature labels can be joined later. Compute cohort-based performance only after each cohort's label window closes, and keep proxies clearly separate from true quality metrics.

### Q10. What metrics would you put on an ML monitoring dashboard?

**Answer:**

1. **Service:** request rate, errors, p50/p95/p99 latency, availability, CPU/GPU/memory, queue depth.
2. **Data:** volume, schema errors, null/default/unknown rates, freshness, range violations, drift by important feature.
3. **Model:** score/class distribution, abstention, calibration and performance when labels mature, critical slices, champion-challenger disagreement.
4. **Business/safety:** conversion, loss prevented, review workload, complaints, fairness/safety guardrails.
5. **Cost:** cost per prediction/outcome and token/accelerator usage where relevant.

Every alert should identify an owner, severity, and runbook action.

### Q11. When should a model be retrained?

**Answer:** Retrain when enough new representative labels exist, confirmed performance/calibration declines, a meaningful distribution or business-policy change occurs, feature/label definitions change, or a justified schedule reflects known seasonality. Do not retrain solely because time passed or a drift statistic crossed an arbitrary threshold. The retrained model is a challenger and must pass promotion gates.

### Q12. Compare batch and online inference.

**Answer:** Batch inference processes many rows periodically and writes results to storage. It is simpler, cheaper per prediction, and easier to retry, but outputs can be stale. Online inference handles each request synchronously with fresh context and low latency, requiring high availability, online features, scaling, timeouts, and graceful degradation. Choose batch unless the action genuinely requires online freshness.

### Q13. Compare blue-green, canary, shadow, and A/B deployment.

**Answer:** Blue-green maintains full old and new environments and switches traffic, enabling fast rollback at additional cost. Canary gradually exposes live decisions to a small traffic share to limit blast radius. Shadow copies real requests to the candidate but discards its decisions, enabling safe behavior comparison. A/B randomly assigns users and uses the alternatives' decisions to estimate causal business impact. They solve related but different questions.

### Q14. Why is a model checksum useful, and what does it not guarantee?

**Answer:** A cryptographic checksum detects whether artifact bytes changed or were corrupted and provides an immutable identity for lineage and caching. It does not prove who produced the artifact or that it is safe. Authenticity requires access controls, signatures/attestations, trusted build provenance, and secure storage. Unsafe formats can remain malicious even with a matching published hash if the publisher is untrusted.

### Q15. Why can pickle or joblib model artifacts be dangerous?

**Answer:** Python pickle-based deserialization can execute arbitrary code. Never load an artifact from an untrusted source. Restrict artifact writers/readers, verify provenance and integrity, scan the supply chain, isolate runtime where needed, and prefer a safer interoperable model format when it supports the model correctly. A file extension is not a security boundary.

### Q16. What is point-in-time correctness?

**Answer:** For a training example scored at time \(t\), every feature must use only data that would have been available by \(t\), including realistic ingestion delay. Historical joins should select the latest eligible feature value at or before the cutoff, not the latest value in today's table. It prevents future leakage and makes offline training consistent with online feature availability.

### Q17. How would you choose a classification threshold in production?

**Answer:** Do not default blindly to 0.5. On validation data, evaluate thresholds against error cost, operating capacity, recall/precision constraints, calibration, critical slices, and downstream workload. Choose a documented threshold/policy, validate it on the test set, version it with the release, and monitor whether calibration or base rate changes invalidate it.

For calibrated probabilities and only false-positive/false-negative costs, a theoretical rule can be derived from expected cost, but real systems also include action capacity and benefits, so empirical policy evaluation is common.

### Q18. A new model has better AUROC but worse calibration and double the p99 latency. Would you deploy it?

**Answer:** Not from AUROC alone. Determine whether ranking improvement increases business value at the actual operating threshold, whether recalibration restores probability quality, and whether latency still meets the SLO and cost budget. Compare critical slices and online guardrails. The decision is multi-objective; reject, recalibrate, optimize, or deploy only if the total constrained value improves.

### Q19. Your API latency and errors are healthy, but conversions suddenly drop. How do you investigate?

**Answer:**

1. Confirm metric definition, experiment assignment, and dashboard correctness.
2. Segment by model version, client, region, time, and traffic source.
3. Check upstream schema, freshness, null/default/unknown rates, and feature distributions.
4. Compare prediction and action distributions with previous periods/champion.
5. Trace representative requests end to end, including feature lookup and downstream policy.
6. Check recent model, threshold, feature, product, pricing, and traffic changes.
7. Roll back or use fallback if harm is material while preserving evidence.
8. Join labels/outcomes when available and write a post-incident action plan.

This demonstrates that operational health is not model or business health.

### Q20. How would you design MLOps for a fraud model with 50 ms p99 latency and 30-day labels?

**Answer:** Use streaming or low-latency online features with freshness contracts; package a compact calibrated model and policy; deploy redundant instances with strict timeouts and a rule/manual-review fallback; return model/version/trace identity; use canary release and immediate rollback. Monitor latency/errors, feature freshness, missing/default rates, score/action distribution, rule disagreement, and review outcomes immediately. Log privacy-safe join keys, then compute mature cohort precision/recall/calibration after 30 days. Retraining produces a gated challenger. Protect artifacts and features with least privilege and audit approvals because fraud models face adversarial adaptation.

### Q21. How do you prevent a retraining pipeline from replacing a good model with a worse one?

**Answer:** Keep champion and candidate immutable. Evaluate both on the same versioned comparison set and important slices; require data-quality, performance, calibration, operational, fairness, and security gates; account for uncertainty and permissible regression tolerances; require approval where appropriate; deploy through shadow/canary; and retain automatic/manual rollback. Promotion must update a controlled alias or deployment manifest atomically.

### Q22. When is a feature store worth using?

**Answer:** It is valuable when many models reuse features, online serving needs fresh low-latency values, training/serving consistency repeatedly causes failures, or feature discovery/ownership/lineage needs central control. It may be unnecessary for one batch model whose warehouse query and pipeline already provide correct reproducible features. State the problem first, then justify the platform.

### Q23. How do you handle model rollback when the feature schema also changed?

**Answer:** Model rollback alone may fail if the previous model cannot consume the new schema. Use backward-compatible schema evolution, versioned feature views/contracts, expand-migrate-contract releases, and keep old feature computation available for the rollback window. Test the rollback path before rollout. Deployment metadata should pin compatible model, preprocessing, feature view, and service versions as one release unit.

### Q24. Design an idempotent batch scoring job.

**Answer:** Identify work by immutable input partition, scoring date, and model digest. Write to a unique temporary/versioned output path, include model version and scoring timestamp, and publish a success manifest/transaction only after all partitions complete. On retry, detect a completed identical key and return it, or safely overwrite only the uncommitted temporary output. Never append blindly. Record counts, schema, input/output checksums, and failure state for audit and backfill.

### Q25. What would you say if an interviewer asks for the “best MLOps tool stack”?

**Answer:** There is no universal best stack. First ask about number of models/teams, batch versus online needs, data platform, cloud, compliance, scale, skill set, and current pain. Then map required capabilities—versioning, tracking, orchestration, registry, serving, monitoring, governance—to existing platform features before adding tools. Prefer an integrated, supportable path with clear ownership over a collection of fashionable components.

---

## 17. Practice Tasks

### Task 1: Small coding task—reproducible trainer

Build a command-line training script for a public tabular dataset.

**Requirements:**

- accept data path, seed, and model parameters as arguments;
- validate required columns and target values;
- split before fitting preprocessing;
- save one pipeline artifact plus JSON metadata;
- record Git SHA, data SHA-256, parameters, metrics, signature, and artifact hash;
- fail if the candidate does not beat a constant/simple baseline;
- include one runnable test for probability bounds and schema.

**Interview extension:** Explain what still prevents exact reproduction on another machine.

### Task 2: Dataset-based project—time-aware churn pipeline

Use a telecom churn dataset and assign a synthetic snapshot date if real event times are absent.

**Work:**

1. define prediction unit, label, action, horizon, and contact capacity;
2. create group/time-aware train, validation, and test sets;
3. build a simple baseline and a tree-based challenger;
4. compare PR-AUC, recall at capacity, Brier score, and two important slices;
5. calibrate the selected model using validation data;
6. write a model card and promotion report;
7. expose batch scoring or a FastAPI endpoint.

**Deliverable:** Reproducible command plus artifacts—not only a notebook.

### Task 3: Experiment—drift sensitivity

Train a classifier, then create controlled production shifts:

- shift a high-impact numeric feature;
- shift an irrelevant feature;
- change class prior;
- change \(P(Y\mid X)\) without large marginal feature drift.

For each scenario, measure PSI, KS/Wasserstein distance, score drift, AUROC, PR-AUC, and calibration. Plot drift magnitude against performance change.

**Learning objective:** Demonstrate empirically why input drift is neither necessary nor sufficient evidence of model degradation.

### Task 4: Debugging/analysis—leakage hunt

Create or inspect a dataset containing:

- a post-outcome field;
- a rolling feature computed past the cutoff;
- duplicate users across random splits;
- scaling performed before splitting;
- recent examples incorrectly labeled negative before their outcome window closes.

Identify each leak, explain why the reported metric is biased, fix the pipeline, and quantify the change. In an interview, a credible lower score after fixing leakage is a success.

### Task 5: Serving and load test

Containerize the example API and test it at increasing concurrency.

Measure:

- cold-start time;
- p50/p95/p99 latency;
- throughput and error rate;
- CPU and memory;
- behavior with invalid and oversized requests;
- behavior when a feature dependency times out.

Implement a timeout and safe fallback, then show the new latency/error trade-off.

### Task 6: Monitoring design

Design a dashboard and alert policy for a fraud or churn system with labels delayed by 30 days.

Include service, data, prediction, proxy, mature-label, business, slice, and cost metrics. For every alert specify:

- exact signal and window;
- minimum sample size and persistence;
- severity;
- owner;
- diagnostic links;
- rollback/fallback/escalation action.

### Task 7: CI/CD extension

Extend a repository pipeline so a pull request runs fast tests, the main branch builds one immutable image, an approved model is scanned and registered, staging uses shadow traffic, and production uses a canary.

Write explicit gates and show that production promotes the same image/model digests tested in staging.

### Task 8: Failure game day

Inject one fault at a time:

- missing column;
- unit change;
- unseen category spike;
- corrupt model file;
- slow feature lookup;
- candidate output-rate jump;
- unavailable monitoring backend.

Record whether validation blocks the change, serving degrades safely, alerts fire, and rollback works. Turn each discovered weakness into a test or runbook improvement.

### Task 9: Extension—champion/challenger service

Send each validated request to a champion and asynchronously to a challenger. Store versioned predictions and latency without affecting the user's response. Build a comparison report for disagreement, score distribution, candidate failures, and later label metrics.

**Important:** Sample traffic and control sensitive-data retention; shadowing can double compute and data exposure.

### Task 10: LLMOps/RAGOps adaptation

Adapt the lifecycle to a RAG question-answering system. Version corpus snapshot, parser, chunker, embedding model, index, retrieval parameters, prompt, generator, decoding, and safety policy. Evaluate retrieval recall@K, groundedness, citation accuracy, answer quality, latency, and cost. Create regression cases for prompt injection and missing evidence.

---

## 18. Project Ideas

### Project 1: Production Churn Intelligence Platform

**What it does:** Trains a churn model, scores customers, explains risk factors, monitors feature/prediction drift, joins delayed outcomes, and promotes challengers only after gates pass.

**Tech stack:**

- Python, Pandas, scikit-learn or XGBoost;
- MLflow for tracking/registry or a well-designed local artifact manifest;
- FastAPI for online demonstration or scheduled Parquet batch scoring;
- Docker, GitHub Actions, PostgreSQL/object storage;
- Prometheus/Grafana or a generated monitoring report.

**Dataset suggestion:** IBM Telco Customer Churn, a public bank churn dataset, or a synthetic time-indexed dataset. Document limitations if event timestamps are not real.

**Key implementation points:**

- fit all transforms inside one pipeline;
- compare simple baseline and challenger;
- measure PR-AUC, recall at campaign capacity, Brier score, and contract/tenure slices;
- version threshold separately from probability model;
- simulate a category and numeric-feature drift event;
- expose model version and trace ID;
- include rollback instructions.

**Resume value:** Demonstrates the entire tabular ML lifecycle, not only modeling. A strong resume line quantifies quality, p99 latency, reproducibility, and failure detection, for example: “Built a versioned churn pipeline with gated model promotion, 70 ms p99 API latency, and drift/data-contract alerts.” Use only measurements you actually obtained.

### Project 2: Real-Time Fraud Scoring with Delayed-Label Monitoring

**What it does:** Scores transactions in real time, combines a model with decision rules, routes uncertain cases for manual review, and evaluates mature 30-day outcome cohorts.

**Tech stack:**

- Python, FastAPI, scikit-learn/LightGBM;
- Redis or an in-memory substitute for online feature demonstration;
- Kafka/Redpanda optionally for event streaming;
- Docker Compose;
- Prometheus/Grafana or OpenTelemetry;
- MLflow or immutable artifact metadata.

**Dataset suggestion:** Kaggle/ULB Credit Card Fraud, IEEE-CIS Fraud Detection, PaySim, or a carefully documented synthetic stream.

**Key implementation points:**

- time-based split and strong imbalance metrics;
- threshold selected from review capacity and asymmetric cost;
- event-time rolling features without future leakage;
- strict input validation and idempotent transaction ID;
- p99 latency budget and safe rule fallback;
- immediate proxy dashboard plus delayed cohort precision/recall/calibration;
- canary or shadow challenger comparison;
- adversarial drift simulation.

**Resume value:** Strong for ML engineer, backend/AI engineer, and platform roles because it shows low-latency system design, streaming concepts, delayed labels, security, and incident thinking.

### Project 3: Observable RAG Release Pipeline

**What it does:** Ingests documents, builds a versioned vector index, answers questions with citations, evaluates each candidate configuration, and deploys only if retrieval, groundedness, safety, latency, and cost gates pass.

**Tech stack:**

- Python, FastAPI;
- sentence-transformers or a hosted embedding API;
- FAISS/pgvector/Qdrant for retrieval;
- an LLM API or local Hugging Face model;
- MLflow or a structured evaluation database;
- Docker and CI;
- OpenTelemetry plus a dashboard/report.

**Dataset suggestion:** A versioned collection of public technical documentation plus a hand-written question/evidence set; BEIR subsets for retrieval; or a public-domain policy/document corpus. Keep source licenses and document versions.

**Key implementation points:**

- version parser, chunking, embedding model, corpus, index, prompt, generator, and decoding;
- evaluate retrieval recall@K independently from final answers;
- score groundedness, citation correctness, refusal, safety, latency, and cost;
- create regression tests for empty retrieval, stale index, prompt injection, conflicting sources, and provider failure;
- use a fallback that returns sources/search results or abstains rather than inventing an answer;
- compare candidate in shadow before canary rollout.

**Resume value:** Shows that GenAI engineering is a measurable system discipline rather than prompt experimentation. It is especially valuable when the repository includes evaluation data, release gates, traces, cost analysis, and a clear failure policy.

### How to present any MLOps project in an interview

Use this order:

1. **Decision:** Who uses the prediction and what action follows?
2. **Constraints:** Freshness, latency, cost, privacy, and error consequences.
3. **Data:** Label definition, availability time, split, and leakage controls.
4. **Model:** Baseline, metric, threshold, calibration, and slices.
5. **System:** Pipeline, artifacts, serving mode, and version identity.
6. **Release:** Tests, gates, rollout, and rollback.
7. **Operation:** Monitoring, delayed labels, incident response, and retraining.
8. **Evidence:** Actual measured quality, latency, cost, and failure tests.

Avoid spending the whole explanation listing tools. Interviewers care more about why the design is correct and how it fails.

---

## 19. Quick Revision

### Key idea

MLOps makes ML systems **reproducible, testable, deployable, observable, governable, and safely changeable** across code, data, features, models, configuration, and infrastructure.

### Main lifecycle

```text
Frame → Contract/version data → Build features → Train → Evaluate/gate
→ Package/register → Validate service → Release safely → Monitor
→ Investigate → Retrain/promote or rollback → Retire
```

### Main formulas

Empirical risk:

\[
\hat R(f)=\frac{1}{n}\sum_{i=1}^{n}L(f(x_i),y_i)
\]

PSI:

\[
\operatorname{PSI}=\sum_i(a_i-e_i)\ln(a_i/e_i)
\]

Brier score:

\[
\operatorname{Brier}=\frac{1}{n}\sum_i(p_i-y_i)^2
\]

Availability:

\[
\operatorname{Availability}=\frac{\text{successful valid requests}}
{\text{valid requests}}
\]

Expected decision cost:

\[
C(\tau)=C_{FP}FP(\tau)+C_{FN}FN(\tau)+C_{action}N_{action}(\tau)
\]

### When to use

Use MLOps practices as soon as an ML result must be repeated, reviewed, shared, deployed, monitored, audited, or maintained. The implementation can be lightweight for one low-risk batch model and more automated/governed for many real-time or high-risk models.

### Important metrics

| Layer | Remember |
|---|---|
| Data | freshness, schema errors, missing/default/unknown rate, drift |
| Model | decision-aligned metric, calibration, slices, score distribution |
| Service | availability, error rate, throughput, p50/p95/p99 latency, saturation |
| Business | incremental value, workload, safety/fairness guardrails |
| Cost | cost per prediction and per successful outcome |

### Common traps

- leakage and unrealistic splits;
- wrong metric or default 0.5 threshold;
- preprocessing outside the fitted pipeline;
- mutable/untraceable artifacts;
- training-serving skew;
- infrastructure-only monitoring;
- drift alert interpreted as proven quality loss;
- blind automatic retraining/deployment;
- no delayed-label design;
- no rollback/fallback;
- average metrics hiding bad slices;
- raw sensitive request logging;
- adding platforms before repeated need exists.

### Interview one-liners

- “A production model is a versioned dependency graph of code, data, features, artifact, configuration, and environment.”
- “Retraining produces a candidate; gates and rollout decide whether it becomes production.”
- “Drift is a diagnostic signal, not proof of degradation.”
- “Shadow tests behavior on real inputs; A/B tests causal user impact.”
- “Build once and promote the same immutable image and model digests.”
- “Monitor service health, data health, model behavior, business outcome, and cost.”
- “Every alert needs an owner and action; every release needs rollback.”
- “Choose the least complex serving mode that meets freshness and latency.”

---

## 20. Final Cheat Sheet

### Definition

**MLOps** is the discipline of operating ML systems through reproducible data/model pipelines, automated validation, controlled deployment, continuous observability, governance, and feedback-driven maintenance.

### Input and output

| Item | Description |
|---|---|
| Inputs to training | Versioned data/labels, feature definitions, code, config, environment |
| Training output | Immutable model package, metadata, signature, metrics, lineage |
| Inputs to inference | Contract-valid request/batch plus correctly timed features |
| Inference output | Prediction/score/decision plus model version, timestamp, trace identity |
| Operational output | Metrics, logs, traces, feedback, alerts, audit records, retraining evidence |

### Main steps

1. Frame decision, metric, constraints, owner, and fallback.
2. Version and validate data; create leakage-safe splits/features.
3. Train a reproducible baseline and candidates.
4. Evaluate quality, calibration, slices, robustness, latency, cost, and risk.
5. Package preprocessing with model; record signature, lineage, and digest.
6. Register and approve an immutable candidate.
7. Test in a production-like environment.
8. Release through shadow/canary/blue-green/A-B as appropriate.
9. Monitor service, data, model, business, and cost.
10. Investigate, retrain through gates, roll back/fallback, and retire when needed.

### Key hyperparameters and versioned configuration

- feature list and preprocessing;
- dataset/split version and random seed;
- model architecture/parameters;
- optimizer, learning rate, batch size, epochs, regularization;
- calibration method and decision threshold;
- online feature freshness and default policy;
- inference batch size, timeout, concurrency, precision;
- rollout percentage and abort criteria;
- monitoring windows, reference data, minimum sample, alert thresholds.

### Metrics

- **Quality:** task metric aligned to decision; baseline comparison; confidence interval.
- **Probability:** log loss, Brier score, reliability/calibration.
- **Slices:** quality and calibration for critical populations plus sample size.
- **Data:** schema, missingness, unknowns, freshness, PSI/KS/JS/Wasserstein.
- **Service:** availability, errors, throughput, p50/p95/p99 latency, saturation.
- **Business:** causal/incremental outcome, review load, complaints, safety.
- **Cost:** training cost, cost per prediction, cost per successful outcome.

### Pros

- reproducible experiments and releases;
- faster, safer model delivery;
- traceable code-data-model lineage;
- early detection of data, service, and quality failures;
- controlled rollback and retraining;
- collaboration across data science, engineering, operations, risk, and product;
- better security, governance, and auditability.

### Cons / trade-offs

- infrastructure and maintenance cost;
- added process can slow early experiments;
- monitoring true quality is difficult with delayed/missing labels;
- reproducibility can be limited by nondeterministic systems;
- too many poorly integrated tools create operational burden;
- automation can repeatedly execute a flawed objective;
- platform investment pays off only when scale or risk justifies it.

### Best use cases

- models repeatedly retrained or released;
- online or business-critical decisions;
- many models, teams, or shared features;
- changing data distributions;
- regulated, audited, privacy-sensitive, or safety-relevant systems;
- systems needing strict latency, availability, or cost control;
- LLM/RAG systems with versioned prompts, knowledge, evaluations, safety, and cost.

### Final placement answer

> MLOps extends software operations to the full ML dependency graph. I would version code, data, features, model, threshold, and environment; automate leakage-safe training and multi-layer evaluation; register immutable artifacts; promote the same tested digests through a safe rollout; monitor service, data, model, business, slices, and cost; join delayed labels; and retrain only into a gated challenger with a tested rollback and accountable owner.
