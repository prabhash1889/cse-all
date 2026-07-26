# Optimization for ML: Interview-Focused Guide

Optimization is the engine behind model training. Given data `D={(x_i,y_i)}_{i=1}^n`, model parameters `theta`, predictions `f_theta(x)`, and loss `ell`, most supervised ML training solves:

```text
min_theta J(theta) = (1/n) * sum_i ell(f_theta(x_i), y_i) + lambda * Omega(theta)
```

This guide covers the optimization topics most commonly tested in ML placements, AI engineer interviews, research internships, and deep learning project discussions.

---

# Loss Functions

## 1. Overview

A loss function measures how bad a model prediction is compared with the target. Training minimizes the average loss, while evaluation may use task metrics such as accuracy, F1, RMSE, AUROC, BLEU, or business cost. Loss functions are used in regression, classification, object detection, language modelling, ranking, recommendation, and reinforcement learning.

## 2. Intuition

Loss is a penalty. If a house price model predicts `90 lakh` when the true price is `92 lakh`, the penalty should be small. If it predicts `20 lakh`, the penalty should be large. The optimizer uses this penalty to decide which parameter direction improves predictions.

## 3. Prerequisites

Derivatives, gradients, probability, logits, sigmoid, softmax, train/validation/test split, overfitting, and basic PyTorch or scikit-learn.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Per-example loss | Penalty for one sample | Backprop starts here | One wrong image label | Loss vs metric |
| Empirical risk | Average loss over data | Main training objective | Mean cross-entropy | Why average over batch? |
| Regression loss | Penalizes numeric error | Fits continuous targets | MSE for price | MSE vs MAE |
| Classification loss | Penalizes wrong probabilities | Trains class probability models | Cross-entropy | Why use logits? |
| Regularized objective | Data loss plus penalty | Improves generalization | L2 penalty | Bias-variance trade-off |

## 5. Algorithm / Working Process

1. Feed input `x` into the model.
2. Get prediction `y_hat` or logits `z`.
3. Compare prediction with target `y` using a loss.
4. Average loss over the batch.
5. Backpropagate gradients.
6. Optimizer updates parameters.
7. Track validation loss and task metrics.

## 6. Mathematical Foundation

For regression:

```text
MSE = (1/n) * sum_i (y_hat_i - y_i)^2
MAE = (1/n) * sum_i |y_hat_i - y_i|
Huber_delta(r) = 0.5r^2 if |r| <= delta, else delta(|r| - 0.5delta)
```

For binary classification:

```text
BCE = -(1/n) * sum_i [y_i log(p_i) + (1-y_i) log(1-p_i)]
p_i = sigmoid(z_i)
```

For multiclass classification:

```text
softmax(z)_k = exp(z_k) / sum_j exp(z_j)
CE = -sum_k y_k log(softmax(z)_k)
dCE/dz_k = p_k - y_k
```

## 7. Practical Implementation

```python
import torch
from torch import nn

logits = torch.tensor([[2.0, -1.0], [-0.5, 1.0]], requires_grad=True)
labels = torch.tensor([0, 1])

loss_fn = nn.CrossEntropyLoss()
loss = loss_fn(logits, labels)
loss.backward()

print("loss:", loss.item())
print("gradient wrt logits:", logits.grad)
```

## 8. Code Explanation

`CrossEntropyLoss` expects raw logits and integer class labels. It internally applies a numerically stable `log_softmax` and negative log-likelihood. `backward()` computes gradients; in a real model, gradients flow into weights.

## 9. Training / Evaluation

Use train loss for optimization and validation metrics for model selection. For regression, evaluate RMSE, MAE, or R2. For classification, evaluate accuracy only when classes are balanced; otherwise prefer F1, precision-recall, AUROC, or calibration metrics. If training loss decreases but validation loss rises, the model is overfitting.

## 10. Complexity and Cost

Loss computation is usually cheap compared with model forward/backward. Regression losses cost `O(B)`. Multiclass cross-entropy costs `O(BK)` for batch size `B` and classes `K`. In LLMs, vocabulary softmax can become expensive.

## 11. Common Use Cases

MSE for forecasting, MAE for robust regression, BCE for binary classification, cross-entropy for image/text classification, focal loss for object detection, contrastive loss for retrieval embeddings.

## 12. Common Mistakes

Using MSE for class IDs, applying softmax before `CrossEntropyLoss`, mixing logits and probabilities, ignoring class imbalance, optimizing one metric while reporting another, and choosing thresholds on the test set.

## 13. Edge Cases / Limitations

MSE is outlier-sensitive. MAE is less smooth near zero. Cross-entropy can produce overconfident models. Non-differentiable business metrics such as F1 cannot usually be optimized directly with gradient descent.

## 14. Variations

| Variation | What changes | When to use | Importance |
|---|---|---|---|
| Weighted CE/BCE | Class weights added | Imbalanced data | High for placements |
| Focal loss | Downweights easy examples | Detection, imbalance | Medium-high |
| Label smoothing | Softens one-hot labels | Deep classifiers, LLMs | High |
| Contrastive loss | Compares pairs | Search, retrieval | High for AI roles |
| Triplet loss | Anchor-positive-negative | Face/product matching | Medium |

## 15. Related Topics

Maximum likelihood explains cross-entropy. Regularization modifies the objective. Gradient descent optimizes the loss. Calibration checks whether predicted probabilities match real frequencies.

## 16. Interview Questions

1. **What is a loss function?** A differentiable penalty used to train model parameters.
2. **Loss vs metric?** Loss drives training; metric measures task success.
3. **Why cross-entropy for classification?** It matches maximum likelihood for categorical labels and gives useful gradients.
4. **Why not use accuracy as loss?** It is non-differentiable and insensitive to confidence.
5. **MSE vs MAE?** MSE penalizes large errors more; MAE is more robust to outliers.
6. **What are logits?** Raw unnormalized model scores before sigmoid or softmax.
7. **Why pass logits to PyTorch CE?** For numerical stability.
8. **What happens with class imbalance?** Loss can be dominated by majority class.
9. **What is label smoothing?** Replace hard labels with slightly soft targets to reduce overconfidence.
10. **Can lower train loss hurt deployment?** Yes, if it overfits or optimizes the wrong objective.

## 17. Practice Tasks

Implement MSE, MAE, BCE, and CE in NumPy. Train a logistic regression classifier and compare BCE with accuracy. Debug a model where softmax is incorrectly applied before CE. Try weighted CE on an imbalanced dataset. Add label smoothing and compare calibration.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Loss Zoo Lab | Compares losses on noisy data | NumPy, PyTorch | Synthetic regression | Shows optimization intuition |
| Imbalanced Fraud Classifier | Tests BCE, weighted BCE, focal loss | PyTorch, sklearn | Credit Card Fraud | Practical metric thinking |
| Calibration Dashboard | Plots reliability diagrams | PyTorch, matplotlib | CIFAR-10 | Strong interview discussion |

## 19. Quick Revision

Key idea: loss converts prediction error into an optimization signal. Main formula: `J=(1/n)sum ell_i`. Use differentiable losses for training and task metrics for evaluation. Common trap: feeding probabilities into a loss that expects logits. Interview one-liner: "The loss is the objective the optimizer sees; the metric is what the user cares about."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Penalty minimized during training |
| Input/output | Prediction + target -> scalar |
| Main steps | forward, loss, backward, update |
| Key hyperparameters | class weights, reduction, label smoothing |
| Metrics | RMSE, MAE, accuracy, F1, AUROC |
| Pros | Makes learning differentiable |
| Cons | May not match business objective |
| Best use cases | All supervised and many self-supervised systems |

---

# Gradient Descent

## 1. Overview

Gradient descent is an iterative optimization method that updates parameters in the direction that most reduces the objective locally. It is the foundation of training linear models, neural networks, embeddings, recommender systems, and large language models.

## 2. Intuition

Imagine standing on a hill in fog and wanting to reach the valley. You feel the slope under your feet and step downhill. The gradient points uphill, so gradient descent steps in the opposite direction.

## 3. Prerequisites

Calculus, partial derivatives, vectors, chain rule, loss functions, feature scaling, and basic linear algebra.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Objective function | Function to minimize | Defines training goal | MSE or CE | What exactly is optimized? |
| Gradient | Direction of steepest increase | Update direction | `dJ/dw` | Why negative gradient? |
| Step size | Learning rate | Controls progress | `0.01` | Too high vs too low |
| Iteration | Repeated update | Gradual convergence | Epochs | Stopping criteria |
| Local minimum | Point lower than neighbors | Common in deep nets | Neural loss landscape | Convex vs non-convex |

## 5. Algorithm / Working Process

1. Initialize parameters `theta`.
2. Compute loss `J(theta)`.
3. Compute gradient `grad J(theta)`.
4. Update `theta <- theta - eta * grad J(theta)`.
5. Repeat until convergence, max epochs, or early stopping.

## 6. Mathematical Foundation

```text
theta_{t+1} = theta_t - eta * nabla_theta J(theta_t)
```

For linear regression with MSE:

```text
J(w,b) = (1/n) * ||Xw + b - y||^2
grad_w J = (2/n) * X^T(Xw + b - y)
```

The learning rate `eta` controls update magnitude.

## 7. Practical Implementation

```python
import numpy as np

X = np.array([[1.0], [2.0], [3.0], [4.0]])
y = np.array([2.0, 4.0, 6.0, 8.0])

w, b = 0.0, 0.0
lr = 0.05

for _ in range(200):
    y_hat = X[:, 0] * w + b
    error = y_hat - y
    grad_w = 2 * np.mean(error * X[:, 0])
    grad_b = 2 * np.mean(error)
    w -= lr * grad_w
    b -= lr * grad_b

print(round(w, 3), round(b, 3))
```

## 8. Code Explanation

The code fits `y=2x` by computing MSE gradients manually. `grad_w` measures how much the loss changes with the slope, and `grad_b` measures how much it changes with the intercept. The update subtracts gradients because we minimize.

## 9. Training / Evaluation

Scale features before gradient descent, especially for linear/logistic regression. Monitor train and validation loss. Stop when validation loss stops improving or gradients become tiny. Tune `lr`, epochs, batch size, initialization, and regularization.

## 10. Complexity and Cost

For `n` samples and `d` features, one full gradient step in linear regression costs `O(nd)`. Neural network cost is roughly one forward plus one backward pass per step. Memory cost includes model parameters, gradients, and optimizer state.

## 11. Common Use Cases

Linear regression, logistic regression, neural network training, matrix factorization, embeddings, and differentiable simulation.

## 12. Common Mistakes

Using unscaled features, wrong gradient sign, learning rate too high, not shuffling data for stochastic methods, training without validation, and assuming every loss is convex.

## 13. Edge Cases / Limitations

Gradient descent can be slow in narrow curved valleys, stuck near saddle points, unstable with poor learning rates, and sensitive to feature scaling.

## 14. Variations

Batch GD uses all data per update. SGD uses one example. Mini-batch GD uses a small batch. Momentum accelerates updates. Adam adapts learning rates. L-BFGS approximates second-order curvature.

## 15. Related Topics

Backpropagation computes gradients efficiently. Learning rate schedules change `eta`. Regularization changes the objective. Convex optimization gives stronger convergence guarantees.

## 16. Interview Questions

1. **What is gradient descent?** Iterative parameter update opposite the gradient.
2. **Why negative gradient?** The gradient points toward steepest increase.
3. **What if learning rate is too high?** Divergence or oscillation.
4. **Too low?** Slow convergence.
5. **Why scale features?** Unequal scales create poorly conditioned contours.
6. **Is GD guaranteed to find global optimum?** Only under conditions such as convexity.
7. **What is an epoch?** One full pass over training data.
8. **What is convergence?** Loss or parameters stop changing meaningfully.
9. **How does backprop relate?** Backprop computes gradients used by GD.
10. **Why use mini-batches?** Efficient and noisy enough to generalize well.

## 17. Practice Tasks

Implement gradient descent for linear regression. Plot loss over iterations for different learning rates. Add feature scaling and compare convergence. Debug a wrong-sign update. Train logistic regression from scratch with BCE.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Optimizer Visualizer | Shows descent paths | Python, matplotlib | Synthetic functions | Strong intuition |
| Linear Model from Scratch | Implements GD training | NumPy | Boston/California Housing | Fundamentals |
| Learning Rate Lab | Compares lr values | PyTorch | MNIST | Practical tuning |

## 19. Quick Revision

Key idea: repeatedly step downhill. Main formula: `theta <- theta - eta grad J`. Use when objective is differentiable. Trap: bad learning rate or unscaled features. Interview one-liner: "Gradient descent turns derivatives into parameter updates."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | First-order iterative optimizer |
| Input/output | Objective + gradients -> improved parameters |
| Main steps | compute loss, gradient, update |
| Key hyperparameters | learning rate, epochs, batch size |
| Metrics | train/validation loss |
| Pros | Simple, scalable |
| Cons | Sensitive to lr and conditioning |
| Best use cases | Differentiable ML objectives |

---

# Batch Gradient Descent

## 1. Overview

Batch gradient descent computes the gradient using the entire training dataset before each update. It is mathematically clean and stable, but often too slow for large modern datasets.

## 2. Intuition

Before taking one step, you ask every training example for its opinion about the downhill direction. The average opinion is accurate but expensive.

## 3. Prerequisites

Gradient descent, vectorized computation, empirical risk, matrix operations, and convergence basics.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Full gradient | Uses all `n` examples | Low-noise update | Full MSE gradient | Stable but slow |
| Deterministic update | Same data gives same step | Easier debugging | Fixed dataset | Why convergence is smoother |
| Epoch-step equivalence | One update per full pass | Fewer updates | 100 epochs = 100 updates | Compare with SGD |
| Memory pressure | Full data may not fit | Limits use | Large image dataset | Why mini-batch dominates |

## 5. Algorithm / Working Process

1. Load all training data.
2. Run full forward pass.
3. Compute average loss.
4. Compute gradient over all examples.
5. Apply one update.
6. Repeat until convergence.

## 6. Mathematical Foundation

```text
J(theta) = (1/n) * sum_{i=1}^n ell_i(theta)
grad J(theta) = (1/n) * sum_{i=1}^n grad ell_i(theta)
theta_{t+1} = theta_t - eta * grad J(theta_t)
```

The gradient is exact for the empirical training objective.

## 7. Practical Implementation

```python
import torch
from torch import nn

X = torch.randn(200, 5)
y = (X[:, 0] + X[:, 1] > 0).long()

model = nn.Linear(5, 2)
opt = torch.optim.SGD(model.parameters(), lr=0.1)
loss_fn = nn.CrossEntropyLoss()

for _ in range(100):
    opt.zero_grad()
    loss = loss_fn(model(X), y)   # whole dataset in one batch
    loss.backward()
    opt.step()
```

## 8. Code Explanation

The full dataset `X` is passed at once. Each optimizer step uses the exact training gradient. This is fine for tiny data but unrealistic for large datasets.

## 9. Training / Evaluation

Batch GD can be useful for small tabular datasets and convex problems. It may converge smoothly but slowly. Monitor validation loss and use early stopping. Feature scaling remains important.

## 10. Complexity and Cost

Each update costs `O(n)` examples. Memory may be `O(n*d)` if all data is loaded. It often underuses stochasticity that helps escape shallow local behavior in deep learning.

## 11. Common Use Cases

Small linear regression, logistic regression demonstrations, convex optimization homework, and full-batch fine-tuning on tiny datasets.

## 12. Common Mistakes

Calling full-batch training "one epoch per mini-batch", expecting it to scale to millions of samples, ignoring memory limits, and assuming stable updates always generalize better.

## 13. Edge Cases / Limitations

Too expensive for large datasets, slow wall-clock progress, poor fit for streaming data, and less hardware-friendly than mini-batches.

## 14. Variations

Mini-batch GD approximates the full gradient with a subset. SGD uses one example. Distributed data-parallel training computes large effective batches across devices.

## 15. Related Topics

SGD trades exactness for speed. Mini-batch GD is the practical middle. Second-order methods often assume full-batch or large-batch gradients.

## 16. Interview Questions

1. **What is batch GD?** Gradient descent using the full dataset per update.
2. **Why is it stable?** The gradient has no sampling noise.
3. **Why is it slow?** Each update scans all examples.
4. **Where is it useful?** Small convex or tabular problems.
5. **Does it need shuffling?** Not for the gradient itself, though data handling may.
6. **Batch GD vs SGD?** Exact but expensive vs noisy but frequent.
7. **Can it overfit?** Yes, optimization method does not prevent overfitting.
8. **Memory issue?** Full data may not fit GPU/CPU memory.
9. **Does it guarantee global optimum?** Only for convex objectives with proper settings.
10. **Why mini-batch in DL?** Better compute utilization and scalable updates.

## 17. Practice Tasks

Train linear regression with full-batch GD. Compare loss curves with SGD. Increase dataset size and measure runtime. Show memory limits by increasing matrix dimensions. Add L2 regularization.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Full vs Mini-batch Benchmark | Measures convergence and time | PyTorch | MNIST subset | Optimizer comparison |
| Convex Solver Demo | Solves logistic regression | NumPy | Breast Cancer | Math clarity |
| Batch Size Study | Tests generalization | PyTorch | CIFAR-10 subset | Practical insight |

## 19. Quick Revision

Key idea: one exact gradient per full dataset pass. Formula: `grad J=(1/n)sum grad ell_i`. Use for small datasets. Trap: very slow updates on large data. Interview one-liner: "Batch GD is stable but usually not scalable."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Full-dataset gradient update |
| Input/output | All training data -> one gradient |
| Main steps | full forward, full backward, update |
| Key hyperparameters | learning rate, epochs |
| Metrics | validation loss, runtime |
| Pros | Stable, deterministic |
| Cons | Expensive, memory-heavy |
| Best use cases | Small convex problems |

---

# Stochastic Gradient Descent

## 1. Overview

Stochastic gradient descent, or SGD, updates parameters using one randomly selected training example at a time. In practice, people often say "SGD" to include mini-batch SGD, but pure SGD uses batch size 1.

## 2. Intuition

Instead of asking every example before stepping, you ask one random example and take a noisy step. Many noisy steps can reach good regions faster than fewer exact steps.

## 3. Prerequisites

Gradient descent, random sampling, unbiased estimators, learning rate, epochs, shuffling, and variance.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Stochastic gradient | Gradient from one sample | Cheap update | One image loss | Is it unbiased? |
| Gradient noise | Random update variation | Helps escape flats, hurts stability | Zig-zag path | Noise vs convergence |
| Online learning | Update as data arrives | Streaming-friendly | Recommendation logs | Why SGD for big data? |
| Shuffling | Randomizes order | Avoids cyclic bias | Shuffle each epoch | What if data sorted? |

## 5. Algorithm / Working Process

1. Shuffle training data.
2. Pick one example `(x_i,y_i)`.
3. Compute loss and gradient for that example.
4. Update parameters.
5. Repeat for all examples and epochs.

## 6. Mathematical Foundation

```text
g_t = grad ell_i(theta_t), where i is sampled randomly
E[g_t] = grad J(theta_t)
theta_{t+1} = theta_t - eta_t * g_t
```

The stochastic gradient is an unbiased estimate of the full gradient if samples are drawn uniformly.

## 7. Practical Implementation

```python
import torch
from torch import nn
from torch.utils.data import DataLoader, TensorDataset

X = torch.randn(200, 10)
y = (X[:, 0] > 0).long()
loader = DataLoader(TensorDataset(X, y), batch_size=1, shuffle=True)

model = nn.Linear(10, 2)
opt = torch.optim.SGD(model.parameters(), lr=0.05)
loss_fn = nn.CrossEntropyLoss()

for _ in range(5):
    for xb, yb in loader:
        opt.zero_grad()
        loss = loss_fn(model(xb), yb)
        loss.backward()
        opt.step()
```

## 8. Code Explanation

`batch_size=1` makes each update stochastic. `shuffle=True` prevents the model from seeing examples in a harmful fixed order. Each loop iteration performs one forward pass, backward pass, and update.

## 9. Training / Evaluation

SGD often needs learning rate decay. Loss curves are noisy, so monitor moving averages and validation metrics. It may generalize well because noise acts as implicit regularization.

## 10. Complexity and Cost

Each update is cheap, but many updates are needed. Pure SGD underuses GPU parallelism because a single example does not fill the device efficiently.

## 11. Common Use Cases

Large-scale linear models, online learning, streaming recommendation systems, and conceptual ML interviews.

## 12. Common Mistakes

Not shuffling, using too high a learning rate, interpreting noisy batch loss as failure, evaluating on training examples during updates, and using batch size 1 on GPU when mini-batch is faster.

## 13. Edge Cases / Limitations

High gradient variance can prevent convergence near minima. It is inefficient on modern accelerators. Sensitive examples or outliers can cause wild updates.

## 14. Variations

Mini-batch SGD reduces variance and uses hardware better. Momentum smooths noisy updates. Averaged SGD averages parameters for stability. SGD with Nesterov momentum looks ahead before correcting.

## 15. Related Topics

Learning rate schedules are important for SGD. Momentum improves stability. Gradient clipping prevents rare huge updates.

## 16. Interview Questions

1. **What is SGD?** Gradient descent using one random sample per update.
2. **Why is it noisy?** One sample only approximates the full gradient.
3. **Why can noise help?** It may escape saddle points and flat poor regions.
4. **Why shuffle?** To avoid biased update order.
5. **SGD vs batch GD?** Cheap noisy updates vs expensive exact updates.
6. **Does SGD converge?** Under assumptions and decaying learning rates.
7. **Why not pure SGD for GPUs?** Poor parallel utilization.
8. **What is online learning?** Updating as examples arrive.
9. **How reduce variance?** Use mini-batches or momentum.
10. **Why decay learning rate?** Large early steps, stable later convergence.

## 17. Practice Tasks

Implement pure SGD for linear regression. Compare shuffled vs unshuffled training. Plot noisy loss. Add momentum. Test learning rate decay.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Online Click Predictor | Updates from streaming samples | Python, sklearn-style NumPy | Criteo subset | Real-time ML |
| SGD Noise Visualizer | Shows noisy paths | NumPy, matplotlib | Synthetic function | Interview intuition |
| SGD vs Adam Study | Compares optimizers | PyTorch | Fashion-MNIST | Practical tuning |

## 19. Quick Revision

Key idea: cheap noisy update from one sample. Formula: `theta <- theta - eta grad ell_i`. Use for streaming or theory; mini-batch for most DL. Trap: forgetting shuffle. Interview one-liner: "SGD replaces the exact gradient with an unbiased noisy estimate."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Single-example gradient descent |
| Input/output | One example -> parameter update |
| Main steps | sample, forward, loss, backward, update |
| Key hyperparameters | lr, schedule, momentum |
| Metrics | validation loss, moving train loss |
| Pros | Fast updates, scalable in data |
| Cons | Noisy, GPU-inefficient |
| Best use cases | Online learning, optimizer fundamentals |

---

# Mini-batch Gradient Descent

## 1. Overview

Mini-batch gradient descent updates parameters using a small subset of examples, typically 16 to thousands depending on model and hardware. It is the default optimization style for deep learning.

## 2. Intuition

Instead of one noisy opinion or every expensive opinion, ask a small group. The group average is useful, cheaper than the full dataset, and efficient on GPUs.

## 3. Prerequisites

SGD, tensors, batch dimension, data loaders, GPU memory, gradient averaging, and epochs.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Batch size | Examples per update | Affects noise and memory | `B=32` | Large vs small batch |
| Gradient estimate | Average over mini-batch | Balances cost and stability | CE over 64 images | Why unbiased? |
| Epoch | Full pass through data | Training progress unit | All batches once | Steps vs epochs |
| Hardware utilization | Parallel tensor compute | Faster training | GPU matrix ops | Why mini-batch dominates |
| Generalization | Batch noise affects solution | Small batches may generalize better | Vision training | Sharp vs flat minima |

## 5. Algorithm / Working Process

1. Shuffle training data each epoch.
2. Split into mini-batches.
3. For each mini-batch, compute predictions.
4. Compute average mini-batch loss.
5. Backpropagate gradients.
6. Update parameters.
7. Validate after one or more epochs.

## 6. Mathematical Foundation

For mini-batch `B_t`:

```text
g_t = (1/|B_t|) * sum_{i in B_t} grad ell_i(theta_t)
theta_{t+1} = theta_t - eta * g_t
```

Larger batches reduce gradient variance but increase memory and may require learning rate tuning.

## 7. Practical Implementation

```python
import torch
from torch import nn
from torch.utils.data import DataLoader, TensorDataset

X = torch.randn(1024, 20)
y = (X[:, :3].sum(dim=1) > 0).long()
loader = DataLoader(TensorDataset(X, y), batch_size=64, shuffle=True)

model = nn.Sequential(nn.Linear(20, 32), nn.ReLU(), nn.Linear(32, 2))
opt = torch.optim.SGD(model.parameters(), lr=0.1)
loss_fn = nn.CrossEntropyLoss()

for epoch in range(10):
    for xb, yb in loader:
        opt.zero_grad()
        loss = loss_fn(model(xb), yb)
        loss.backward()
        opt.step()
```

## 8. Code Explanation

`DataLoader` creates shuffled mini-batches. `CrossEntropyLoss` averages over the batch by default. One optimizer step occurs per mini-batch, not per epoch.

## 9. Training / Evaluation

Tune batch size with learning rate. If increasing batch size, learning rate may need adjustment. Use validation data, not train loss alone. Watch for GPU out-of-memory errors.

## 10. Complexity and Cost

Each step costs `O(B)` examples, and one epoch costs `O(n)`. Memory grows with batch size because activations must be stored for backpropagation.

## 11. Common Use Cases

CNNs, Transformers, tabular neural networks, autoencoders, GANs, recommender models, and LLM fine-tuning.

## 12. Common Mistakes

Confusing batch size with epochs, using batch size too large for memory, not shuffling training data, evaluating with dropout still enabled, and changing batch size without retuning learning rate.

## 13. Edge Cases / Limitations

Very small batches can have unstable BatchNorm statistics. Very large batches may converge to sharper minima or require warmup. Last batch may be smaller unless `drop_last=True`.

## 14. Variations

Gradient accumulation simulates large batches under memory limits. Distributed data parallelism increases effective batch size. Curriculum batching changes sample order by difficulty.

## 15. Related Topics

BatchNorm depends on batch statistics. Learning rate scaling is tied to batch size. Gradient clipping is often applied per mini-batch.

## 16. Interview Questions

1. **What is mini-batch GD?** Gradient descent using a subset per update.
2. **Why use it?** Good trade-off between noise, speed, and hardware use.
3. **What is batch size?** Number of examples per update.
4. **Batch size vs epoch?** Batch size controls update granularity; epoch is one dataset pass.
5. **What if batch too large?** Memory issues and possible generalization changes.
6. **What if batch too small?** Noisy updates and poor hardware utilization.
7. **Why shuffle?** To make batches representative.
8. **What is gradient accumulation?** Sum gradients across mini-batches before stepping.
9. **How does batch size affect lr?** Larger batches often tolerate larger lr with warmup.
10. **Why default in DL?** Matrix operations are efficient and scalable.

## 17. Practice Tasks

Train MNIST with batch sizes 16, 64, and 512. Record runtime and validation accuracy. Implement gradient accumulation. Compare BatchNorm behavior with small batches. Plot train loss per step.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Batch Size Benchmark | Measures speed/accuracy trade-off | PyTorch | Fashion-MNIST | Practical training skill |
| Gradient Accumulation Trainer | Handles memory-limited training | PyTorch | CIFAR-10 | Useful for GPUs |
| DataLoader Profiler | Finds input pipeline bottlenecks | PyTorch | ImageFolder data | AI engineering value |

## 19. Quick Revision

Key idea: update from a small random subset. Formula: `g=(1/B)sum grad ell_i`. Use for almost all neural network training. Trap: changing batch size without retuning lr. Interview one-liner: "Mini-batch GD is the practical compromise between batch GD and SGD."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Batch-subset gradient update |
| Input/output | Mini-batch -> parameter update |
| Main steps | shuffle, batch, forward, backward, step |
| Key hyperparameters | batch size, lr, epochs |
| Metrics | validation metric, throughput |
| Pros | Efficient, scalable |
| Cons | Needs tuning, memory-limited |
| Best use cases | Deep learning |

---

# Learning Rate

## 1. Overview

The learning rate controls how far parameters move in response to gradients. It is often the most important optimization hyperparameter.

## 2. Intuition

Learning rate is step size. Tiny steps are safe but slow. Huge steps may jump over the valley or explode. Good training uses large enough steps to learn quickly and small enough steps to settle.

## 3. Prerequisites

Gradient descent, loss curves, numerical scale, normalization, optimizer basics, and validation tuning.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Step size | Multiplier on gradient | Controls update magnitude | `lr=1e-3` | Most important hyperparameter |
| Stability | Avoid divergence | Prevents exploding loss | NaN loss | Too high lr |
| Convergence speed | Learning progress | Saves compute | Slow plateau | Too low lr |
| Schedules | Change lr over time | Better final minima | cosine decay | Why decay? |
| Warmup | Gradually increase lr | Stabilizes large models | Transformers | Why LLM warmup? |

## 5. Algorithm / Working Process

1. Choose optimizer and initial learning rate.
2. Train for a few epochs or use an LR finder.
3. Watch loss behavior.
4. If loss diverges, reduce lr.
5. If loss decreases very slowly, increase lr.
6. Apply schedule or early stopping.

## 6. Mathematical Foundation

```text
theta_{t+1} = theta_t - eta_t * g_t
```

For smooth convex functions, convergence typically requires `eta` to be small enough relative to curvature. If curvature is high, a large step overshoots.

## 7. Practical Implementation

```python
import torch

model = torch.nn.Linear(10, 2)
optimizer = torch.optim.AdamW(model.parameters(), lr=3e-4)
scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(optimizer, T_max=20)

for epoch in range(20):
    # train_one_epoch(...)
    current_lr = optimizer.param_groups[0]["lr"]
    print("epoch", epoch, "lr", current_lr)
    scheduler.step()
```

## 8. Code Explanation

The optimizer stores `lr` inside parameter groups. The scheduler changes it after each epoch. Cosine annealing gradually lowers the learning rate.

## 9. Training / Evaluation

Track train and validation loss. A good lr usually gives steady early loss reduction. Divergence, NaNs, or wild oscillation suggest high lr. Flat loss may mean low lr, bad initialization, bad preprocessing, or a bug.

## 10. Complexity and Cost

Learning rate itself adds no computation. Poor lr wastes training compute or destroys training runs. LR search can cost multiple short experiments.

## 11. Common Use Cases

All gradient-based models, especially neural networks, fine-tuning, transfer learning, and large-batch training.

## 12. Common Mistakes

Using default lr blindly, changing optimizer without retuning lr, no warmup for large Transformers, using the same lr for scratch training and fine-tuning, and ignoring batch size interactions.

## 13. Edge Cases / Limitations

Adaptive optimizers reduce but do not eliminate lr sensitivity. Different layers may need different rates. Fine-tuning pretrained models often needs smaller lr than training a new head.

## 14. Variations

Constant lr, step decay, exponential decay, cosine decay, one-cycle policy, cyclic lr, linear warmup, and layer-wise learning rate decay.

## 15. Related Topics

Learning rate schedules, Adam, momentum, gradient clipping, normalization, and batch size scaling.

## 16. Interview Questions

1. **What is learning rate?** Multiplier controlling update size.
2. **Too high?** Divergence, oscillation, NaNs.
3. **Too low?** Slow or stuck training.
4. **Why decay lr?** Large early progress, stable final convergence.
5. **What is warmup?** Gradual lr increase at training start.
6. **Does Adam remove lr tuning?** No.
7. **Why smaller lr for fine-tuning?** Avoid destroying pretrained representations.
8. **How batch size affects lr?** Larger batches often use larger lr with warmup.
9. **How find lr?** Range test or short sweeps.
10. **Can lr vary by layer?** Yes, common in transfer learning.

## 17. Practice Tasks

Train the same model with `1e-1`, `1e-3`, and `1e-5`. Implement an LR range test. Compare constant and cosine schedules. Fine-tune only a classifier head with high lr and backbone with low lr.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| LR Finder Tool | Suggests stable lr range | PyTorch | Any classifier | Training engineering |
| Scheduler Benchmark | Compares decay policies | PyTorch | CIFAR-10 | Practical experiments |
| Fine-tuning LR Study | Tests layer-wise lr | torchvision | Flowers/Cats-Dogs | Transfer learning depth |

## 19. Quick Revision

Key idea: controls update size. Formula: `theta <- theta - eta g`. Use schedules for long training. Trap: using one default lr everywhere. Interview one-liner: "Learning rate decides whether gradients become progress, noise, or disaster."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Gradient step-size hyperparameter |
| Input/output | Gradient -> scaled update |
| Main steps | choose, monitor, tune, schedule |
| Key hyperparameters | initial lr, min lr, warmup |
| Metrics | loss curve, validation score |
| Pros | Simple powerful control |
| Cons | Highly sensitive |
| Best use cases | Every gradient optimizer |

---

# Momentum

## 1. Overview

Momentum accelerates gradient descent by accumulating a velocity from previous gradients. It helps training move faster in consistent directions and reduces zig-zagging in noisy or poorly conditioned landscapes.

## 2. Intuition

Momentum is like rolling a ball downhill. The ball does not forget the previous direction immediately; it builds speed where slopes consistently agree.

## 3. Prerequisites

Gradient descent, vectors, learning rate, exponential moving averages, and loss landscapes.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Velocity | Running gradient direction | Smooths updates | `v_t` | Why faster? |
| Momentum coefficient | Memory strength | Controls smoothing | `beta=0.9` | What does 0.9 mean? |
| Dampening oscillations | Cancels alternating gradients | Helps narrow valleys | Ravine loss | Conditioning |
| Nesterov momentum | Lookahead gradient | Often better correction | NAG | Difference from classical |

## 5. Algorithm / Working Process

1. Initialize velocity `v=0`.
2. Compute gradient `g_t`.
3. Update velocity from old velocity and new gradient.
4. Update parameters using velocity.
5. Repeat.

## 6. Mathematical Foundation

Classical momentum:

```text
v_t = beta * v_{t-1} + g_t
theta_{t+1} = theta_t - eta * v_t
```

Alternative sign convention:

```text
v_t = beta * v_{t-1} - eta * g_t
theta_{t+1} = theta_t + v_t
```

`beta` is commonly `0.9`.

## 7. Practical Implementation

```python
import torch

model = torch.nn.Sequential(torch.nn.Linear(20, 64), torch.nn.ReLU(), torch.nn.Linear(64, 2))
optimizer = torch.optim.SGD(model.parameters(), lr=0.01, momentum=0.9, nesterov=True)
```

## 8. Code Explanation

PyTorch's SGD can use momentum directly. `momentum=0.9` means past velocity contributes strongly. `nesterov=True` uses a lookahead-style gradient correction.

## 9. Training / Evaluation

Momentum often allows faster training than plain SGD. Tune learning rate and momentum together. High momentum plus high lr can overshoot. Track validation performance, not just faster loss decrease.

## 10. Complexity and Cost

Momentum stores one extra velocity tensor per parameter, so optimizer state memory is about one additional copy of model weights. Compute overhead is small.

## 11. Common Use Cases

CNN training, classical deep learning pipelines, large-scale supervised vision, and cases where SGD generalization is preferred over Adam.

## 12. Common Mistakes

Using high lr and high momentum without warmup, forgetting that momentum adds state, assuming it always beats Adam, and not resetting optimizer state when restarting training differently.

## 13. Edge Cases / Limitations

Momentum can overshoot minima. It may be less convenient than Adam for sparse or badly scaled gradients. It does not fix incorrect preprocessing or loss design.

## 14. Variations

Nesterov accelerated gradient computes a corrective lookahead gradient. Heavy-ball momentum is the classical form. Adam uses momentum-like first moment plus adaptive second moment.

## 15. Related Topics

SGD, Adam, RMSProp, learning rate schedules, convex optimization, and conditioning.

## 16. Interview Questions

1. **What is momentum?** Accumulated velocity from past gradients.
2. **Why useful?** Speeds consistent directions and reduces zig-zag.
3. **Formula?** `v=beta v + g`, `theta=theta-lr v`.
4. **Common beta?** `0.9`.
5. **What is Nesterov?** Lookahead variant of momentum.
6. **Memory cost?** One extra tensor per parameter.
7. **Can it overshoot?** Yes.
8. **Momentum vs Adam?** Adam adds adaptive scaling with moment estimates.
9. **When prefer SGD momentum?** Often vision models with strong generalization.
10. **Does momentum remove lr tuning?** No.

## 17. Practice Tasks

Train a CNN with SGD and SGD+momentum. Plot loss oscillations. Try `momentum=0`, `0.5`, `0.9`, `0.99`. Compare Nesterov on/off.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Momentum Path Visualizer | Shows ravine optimization | NumPy | Synthetic bowl | Mathematical intuition |
| SGD Momentum CNN | Trains image classifier | PyTorch | CIFAR-10 | Core DL skill |
| Optimizer State Inspector | Logs velocity norms | PyTorch | MNIST | Debugging depth |

## 19. Quick Revision

Key idea: use past gradients to build velocity. Formula: `v_t=beta v_{t-1}+g_t`. Use for faster SGD. Trap: overshooting with high lr. Interview one-liner: "Momentum smooths noisy gradients and accelerates directions that keep agreeing."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Gradient descent with velocity |
| Input/output | Gradients -> smoothed update |
| Main steps | update velocity, update weights |
| Key hyperparameters | lr, momentum, nesterov |
| Metrics | convergence speed, validation |
| Pros | Faster, less zig-zag |
| Cons | Extra state, can overshoot |
| Best use cases | SGD training, CNNs |

---

# Adam Optimizer

## 1. Overview

Adam, short for Adaptive Moment Estimation, combines momentum with per-parameter adaptive learning rates. It is a default optimizer for many deep learning tasks, especially NLP, Transformers, and quick prototyping.

## 2. Intuition

Adam remembers two things: the average direction of recent gradients and how large gradients usually are for each parameter. Parameters with consistently large gradients get smaller effective steps; parameters with small gradients get relatively larger steps.

## 3. Prerequisites

SGD, momentum, RMSProp, moving averages, bias correction, learning rate, and backpropagation.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| First moment | EMA of gradients | Momentum direction | `m_t` | Adam vs momentum |
| Second moment | EMA of squared gradients | Adaptive scaling | `v_t` | Adam vs RMSProp |
| Bias correction | Fixes zero initialization bias | Important early steps | `m_hat`, `v_hat` | Why correction? |
| Epsilon | Numerical stability | Prevents divide by zero | `1e-8` | Why epsilon? |
| AdamW | Decoupled weight decay | Better regularization | Transformers | Adam vs AdamW |

## 5. Algorithm / Working Process

1. Compute gradient `g_t`.
2. Update first moment `m_t`.
3. Update second moment `v_t`.
4. Bias-correct both estimates.
5. Scale update by `m_hat / sqrt(v_hat)`.
6. Apply parameter update.

## 6. Mathematical Foundation

```text
m_t = beta1*m_{t-1} + (1-beta1)*g_t
v_t = beta2*v_{t-1} + (1-beta2)*g_t^2
m_hat_t = m_t / (1-beta1^t)
v_hat_t = v_t / (1-beta2^t)
theta_{t+1} = theta_t - eta * m_hat_t / (sqrt(v_hat_t) + eps)
```

Common defaults: `beta1=0.9`, `beta2=0.999`, `eps=1e-8`.

## 7. Practical Implementation

```python
import torch
from torch import nn

model = nn.Sequential(nn.Linear(30, 64), nn.ReLU(), nn.Linear(64, 2))
optimizer = torch.optim.AdamW(model.parameters(), lr=3e-4, weight_decay=1e-2)
loss_fn = nn.CrossEntropyLoss()
```

## 8. Code Explanation

`AdamW` is commonly preferred over `Adam` when using weight decay. It keeps adaptive optimization and regularization cleaner by decoupling decay from the gradient update.

## 9. Training / Evaluation

Adam trains quickly with less tuning than SGD, but learning rate still matters. For Transformers, use warmup and AdamW. Evaluate generalization because Adam may fit training data quickly.

## 10. Complexity and Cost

Adam stores two extra tensors per parameter: first and second moments. Optimizer state memory is roughly `2x` parameter size, plus parameters and gradients.

## 11. Common Use Cases

Transformers, LLM fine-tuning, NLP, tabular deep learning, recommendation models, autoencoders, GAN prototyping, and sparse-gradient settings.

## 12. Common Mistakes

Using Adam with coupled L2 when AdamW is intended, not tuning lr, applying weight decay to bias and normalization parameters, forgetting memory overhead, and assuming Adam always generalizes best.

## 13. Edge Cases / Limitations

Adam can be memory-heavy for large models. It may generalize worse than SGD in some vision tasks. Adaptive updates can behave poorly with bad hyperparameters or noisy gradients.

## 14. Variations

AdamW decouples weight decay. AMSGrad modifies second-moment behavior for convergence guarantees. AdaFactor reduces memory for huge models. Lion uses sign-based momentum updates.

## 15. Related Topics

Momentum supplies first moment intuition. RMSProp supplies second moment intuition. Weight decay is usually implemented with AdamW. Learning rate warmup is common for Adam in Transformers.

## 16. Interview Questions

1. **What is Adam?** Adaptive optimizer using first and second gradient moments.
2. **Formula components?** `m`, `v`, bias correction, scaled update.
3. **Default betas?** `0.9` and `0.999`.
4. **Why bias correction?** Moment estimates start at zero and are biased early.
5. **Why epsilon?** Numerical stability.
6. **Adam vs RMSProp?** Adam adds momentum and bias correction.
7. **Adam vs SGD?** More adaptive and often faster, but more memory.
8. **Adam vs AdamW?** AdamW decouples weight decay.
9. **Where used?** Transformers and fine-tuning.
10. **Main downside?** Optimizer memory and possible generalization issues.

## 17. Practice Tasks

Train the same MLP with SGD, RMSProp, Adam, and AdamW. Log moment norms. Try different `beta1` and `beta2`. Fine-tune a small Transformer with AdamW and warmup.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Adam from Scratch | Implements equations | NumPy | Synthetic regression | Deep optimizer knowledge |
| Optimizer Shootout | Compares training curves | PyTorch | Fashion-MNIST | Practical insight |
| Transformer Fine-tuning | Uses AdamW + warmup | Hugging Face | IMDb/SST-2 | AI engineer relevance |

## 19. Quick Revision

Key idea: momentum plus adaptive per-parameter scaling. Formula: `theta -= lr*m_hat/(sqrt(v_hat)+eps)`. Use as a strong default for DL. Trap: AdamW vs Adam weight decay confusion. Interview one-liner: "Adam adapts each parameter's step using moving averages of gradients and squared gradients."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Adaptive first-order optimizer |
| Input/output | Gradients -> moment-scaled updates |
| Main steps | update moments, bias-correct, step |
| Key hyperparameters | lr, beta1, beta2, eps, weight_decay |
| Metrics | validation loss, memory |
| Pros | Fast, robust default |
| Cons | More memory, not always best generalization |
| Best use cases | Transformers, NLP, prototyping |

---

# RMSProp

## 1. Overview

RMSProp is an adaptive optimizer that divides gradients by a running root mean square of recent squared gradients. It was designed to handle non-stationary objectives and reduce learning-rate sensitivity.

## 2. Intuition

If a parameter usually receives large gradients, RMSProp takes smaller steps for it. If another parameter receives small gradients, it allows relatively larger steps.

## 3. Prerequisites

Gradient descent, moving averages, element-wise operations, learning rate, and non-convex optimization.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Squared gradient EMA | Tracks recent gradient magnitude | Adaptive scaling | `s_t` | Why square gradients? |
| Decay rate | Memory of past squares | Smoothness | `alpha=0.99` | Effect of alpha |
| Per-parameter lr | Different effective step sizes | Handles scaling | Sparse features | Compare with AdaGrad |
| Epsilon | Avoids divide by zero | Numerical stability | `1e-8` | Why needed? |

## 5. Algorithm / Working Process

1. Compute gradient `g_t`.
2. Update running squared average.
3. Divide gradient by root average.
4. Apply learning-rate-scaled update.

## 6. Mathematical Foundation

```text
s_t = rho*s_{t-1} + (1-rho)*g_t^2
theta_{t+1} = theta_t - eta * g_t / (sqrt(s_t) + eps)
```

`rho` is often near `0.9` or `0.99`.

## 7. Practical Implementation

```python
import torch

model = torch.nn.Linear(20, 2)
optimizer = torch.optim.RMSprop(model.parameters(), lr=1e-3, alpha=0.99, eps=1e-8)
```

## 8. Code Explanation

`alpha` controls the moving average decay. RMSProp rescales each parameter's gradient by its recent magnitude, helping with uneven gradient scales.

## 9. Training / Evaluation

RMSProp can be effective for RNNs and reinforcement learning. Tune `lr` and `alpha`. Compare with Adam because Adam often performs better by adding momentum.

## 10. Complexity and Cost

RMSProp stores one extra squared-gradient average per parameter. Compute overhead is small.

## 11. Common Use Cases

RNNs, reinforcement learning baselines, non-stationary objectives, and educational comparison with AdaGrad/Adam.

## 12. Common Mistakes

Confusing RMSProp with momentum, using too high lr, forgetting epsilon, and assuming adaptivity means no preprocessing or normalization is needed.

## 13. Edge Cases / Limitations

Can still diverge with poor lr. Usually less popular than Adam for Transformers. Adaptive scaling may reduce but not eliminate sensitivity to bad gradients.

## 14. Variations

Centered RMSProp normalizes by estimated variance. RMSProp with momentum adds velocity. Adam can be viewed as RMSProp plus momentum and bias correction.

## 15. Related Topics

AdaGrad accumulates all squared gradients; RMSProp uses a decaying average. Adam extends RMSProp. Gradient clipping is often paired with RNN optimizers.

## 16. Interview Questions

1. **What is RMSProp?** Adaptive optimizer using EMA of squared gradients.
2. **Formula?** `s=rho s+(1-rho)g^2`, update `g/sqrt(s)`.
3. **Why useful?** Handles different gradient scales.
4. **RMSProp vs AdaGrad?** RMSProp forgets old gradients.
5. **RMSProp vs Adam?** Adam adds first-moment momentum and bias correction.
6. **What is alpha/rho?** Decay rate for squared gradient average.
7. **Why epsilon?** Avoid division by zero.
8. **Where used?** RNNs and RL.
9. **Memory cost?** One extra tensor per parameter.
10. **Does it guarantee global optimum?** No for non-convex deep nets.

## 17. Practice Tasks

Implement RMSProp in NumPy. Train an RNN-like toy model with SGD and RMSProp. Compare with Adam. Vary `alpha` and plot update magnitudes.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| RMSProp from Scratch | Implements optimizer | NumPy | Synthetic regression | Formula mastery |
| RNN Optimizer Compare | Tests SGD/RMSProp/Adam | PyTorch | Character names | Sequence training |
| RL Optimizer Study | Compares stability | PyTorch | CartPole | RL awareness |

## 19. Quick Revision

Key idea: divide gradient by recent RMS magnitude. Formula: `theta -= lr*g/(sqrt(s)+eps)`. Use for adaptive scaling. Trap: thinking it has momentum by default. Interview one-liner: "RMSProp adapts step sizes using a moving average of squared gradients."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Squared-gradient adaptive optimizer |
| Input/output | Gradient -> normalized update |
| Main steps | update square avg, scale gradient, step |
| Key hyperparameters | lr, alpha/rho, eps, momentum |
| Metrics | loss stability |
| Pros | Handles uneven gradient scales |
| Cons | Less common than Adam |
| Best use cases | RNNs, RL, optimizer learning |

---

# Regularization

## 1. Overview

Regularization reduces overfitting by discouraging unnecessary model complexity. It is used across linear models, tree models, CNNs, Transformers, recommendation systems, and LLM fine-tuning.

## 2. Intuition

Regularization is a complexity tax. The model may use a complex pattern only if that pattern reduces data loss enough to justify the penalty.

## 3. Prerequisites

Train/validation/test split, bias-variance trade-off, loss functions, model capacity, gradients, and hyperparameter tuning.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Overfitting | Learns noise | Poor test performance | Memorized labels | Train vs validation gap |
| Explicit penalty | Added to objective | Direct control | L1/L2 | What does lambda do? |
| Implicit regularization | Training process helps | No explicit penalty | Early stopping | Is dropout the only way? |
| Capacity control | Limits model flexibility | Reduces variance | Smaller network | Underfitting risk |
| Data augmentation | Adds realistic variations | Improves invariance | Image crops | Is augmentation regularization? |

## 5. Algorithm / Working Process

1. Define train, validation, and test split.
2. Choose baseline model and loss.
3. Add regularization method.
4. Tune strength on validation data.
5. Select best validation checkpoint.
6. Evaluate test set once.

## 6. Mathematical Foundation

```text
L_total(theta) = L_data(theta) + lambda * Omega(theta)
```

`Omega(theta)` may be `||theta||_1`, `||theta||_2^2`, dropout noise, data augmentation, or stopping time. Larger `lambda` usually increases bias and reduces variance.

## 7. Practical Implementation

```python
import torch
from torch import nn

model = nn.Sequential(
    nn.Linear(100, 64),
    nn.ReLU(),
    nn.Dropout(0.3),
    nn.Linear(64, 2),
)
optimizer = torch.optim.AdamW(model.parameters(), lr=3e-4, weight_decay=1e-2)
loss_fn = nn.CrossEntropyLoss()
```

## 8. Code Explanation

Dropout randomly masks activations during training. `AdamW` applies decoupled weight decay. Both reduce overfitting in different ways.

## 9. Training / Evaluation

Use validation data to tune regularization. If train score is poor, reduce regularization or increase capacity. If train is strong but validation is weak, increase regularization, add data, augment, or stop earlier.

## 10. Complexity and Cost

L1/L2 costs `O(p)` for `p` parameters. Dropout adds small training overhead and no deterministic inference cost. Data augmentation can increase data loading cost.

## 11. Common Use Cases

Linear models with L1/L2, CNNs with augmentation and weight decay, Transformers with dropout/AdamW/early stopping, and small-data fine-tuning.

## 12. Common Mistakes

Tuning on test data, using validation augmentations incorrectly, applying weight decay to bias/norm parameters blindly, over-regularizing, and using regularization to hide data leakage.

## 13. Edge Cases / Limitations

Regularization cannot fix wrong labels, leakage, distribution shift, or invalid metrics. Too much regularization underfits.

## 14. Variations

L1, L2, elastic net, dropout, label smoothing, augmentation, early stopping, stochastic depth, mixup, cutmix, SAM, and weight decay.

## 15. Related Topics

L1 and L2 are explicit penalties. Weight decay implements L2-like shrinkage. Early stopping is implicit regularization. SAM targets flatter minima.

## 16. Interview Questions

1. **What is regularization?** Techniques that improve generalization by controlling complexity.
2. **Why use it?** To reduce overfitting.
3. **What is lambda?** Regularization strength.
4. **Over-regularization?** Underfitting.
5. **Is dropout regularization?** Yes.
6. **Is augmentation regularization?** Yes, often.
7. **Can regularization fix leakage?** No.
8. **How tune it?** Validation or cross-validation.
9. **Train high, val low means?** Overfitting.
10. **Train low, val low means?** Underfitting or bad setup.

## 17. Practice Tasks

Train a model with no regularization, L2, dropout, and early stopping. Plot train/validation gap. Try augmentation. Tune `lambda` on validation only.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Overfit Lab | Demonstrates train/val gaps | PyTorch | MNIST subset | Core ML intuition |
| Regularization Benchmark | Compares L1/L2/dropout | sklearn, PyTorch | Tabular + image | Broad knowledge |
| Small Data Fine-tuning | Prevents overfit | Hugging Face | IMDb subset | AI role relevance |

## 19. Quick Revision

Key idea: reduce overfitting by controlling complexity. Formula: `L_total=L_data+lambda Omega`. Trap: tuning on test set. Interview one-liner: "Regularization trades a little training fit for better unseen-data performance."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Generalization control |
| Input/output | Model/training setup -> less overfit |
| Main steps | add control, tune strength, validate |
| Key hyperparameters | lambda, dropout rate, weight_decay |
| Metrics | validation gap |
| Pros | Better generalization |
| Cons | Can underfit |
| Best use cases | Small data, high-capacity models |

---

# L1 Regularization

## 1. Overview

L1 regularization adds the absolute value of parameters to the loss. It encourages sparsity, meaning some weights become exactly zero or close to zero. It is common in feature selection and interpretable linear models.

## 2. Intuition

L1 asks the model to pay for every nonzero weight. If a feature is not very useful, the model may set its weight to zero and ignore it.

## 3. Prerequisites

Regularization, linear models, absolute value, subgradients, feature scaling, and validation tuning.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Sparsity | Many weights zero | Feature selection | Lasso | Why L1 selects features |
| Absolute penalty | Sum of absolute weights | Different geometry from L2 | `||w||_1` | Non-differentiable at zero |
| Lambda | Penalty strength | Controls sparsity | `alpha` in sklearn | Tune on validation |
| Scale sensitivity | Feature scale affects penalty | Needs standardization | Age vs income | Why scale features? |

## 5. Algorithm / Working Process

1. Standardize features.
2. Add L1 penalty to data loss.
3. Optimize with solver that handles non-smooth penalty.
4. Tune regularization strength.
5. Inspect zero/nonzero coefficients.

## 6. Mathematical Foundation

```text
L_total(w) = L_data(w) + lambda * ||w||_1
||w||_1 = sum_j |w_j|
```

At `w_j=0`, L1 is not differentiable, so solvers use subgradients or proximal methods.

## 7. Practical Implementation

```python
from sklearn.datasets import make_classification
from sklearn.linear_model import LogisticRegression
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

X, y = make_classification(n_samples=1000, n_features=30, n_informative=5, random_state=0)

model = make_pipeline(
    StandardScaler(),
    LogisticRegression(penalty="l1", solver="liblinear", C=0.2, max_iter=1000),
)
model.fit(X, y)

coef = model.named_steps["logisticregression"].coef_[0]
print("selected features:", (coef != 0).sum())
```

## 8. Code Explanation

`StandardScaler` prevents feature scale from unfairly affecting the penalty. `C` is inverse regularization strength in scikit-learn: smaller `C` means stronger L1. `liblinear` supports L1 logistic regression.

## 9. Training / Evaluation

Use cross-validation for `C` or `lambda`. Check both performance and selected features. L1 can improve interpretability but may drop correlated useful features arbitrarily.

## 10. Complexity and Cost

L1 solvers can be slower than L2 because the objective is non-smooth. Sparse solutions can reduce inference cost when many features are removed.

## 11. Common Use Cases

Feature selection, high-dimensional tabular data, text classification with bag-of-words, bioinformatics, and interpretable risk models.

## 12. Common Mistakes

Not scaling features, interpreting selected features as causal, using L1 when correlated features should be grouped, setting too strong penalty, and expecting neural nets to become cleanly sparse without special training.

## 13. Edge Cases / Limitations

With correlated features, L1 may pick one and drop others unpredictably. It can underfit when signal is distributed across many weak features.

## 14. Variations

Lasso is L1 linear regression. L1 logistic regression handles classification. Elastic net combines L1 and L2. Group lasso selects feature groups.

## 15. Related Topics

L2 shrinks weights smoothly. Elastic net balances sparsity and stability. Feature selection and interpretability connect strongly to L1.

## 16. Interview Questions

1. **What is L1?** Sum of absolute weights added to loss.
2. **Why sparse?** Absolute penalty has geometry that encourages zero coefficients.
3. **Formula?** `lambda sum |w_j|`.
4. **Why scale features?** Penalty depends on coefficient scale.
5. **L1 vs L2?** L1 sparsifies; L2 shrinks.
6. **What is Lasso?** Linear regression with L1.
7. **What is C in sklearn?** Inverse regularization strength.
8. **Problem at zero?** Non-differentiability.
9. **Good for deep nets?** Less common alone; sparsity may need pruning methods.
10. **Correlated features issue?** L1 may choose one arbitrarily.

## 17. Practice Tasks

Fit L1 logistic regression on high-dimensional data. Plot number of selected features vs `C`. Compare with L2. Add correlated duplicate features and observe selection instability.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Sparse Spam Classifier | Selects words | sklearn | SMS Spam | Interpretable NLP |
| Medical Feature Selector | Finds predictive features | sklearn | Breast Cancer | Placement-friendly |
| L1 Path Visualizer | Shows coefficients vs lambda | NumPy/sklearn | Synthetic data | Math depth |

## 19. Quick Revision

Key idea: penalize absolute weights to encourage sparsity. Formula: `L+lambda||w||_1`. Use for feature selection. Trap: no feature scaling. Interview one-liner: "L1 regularization can make models sparse by pushing weak coefficients to zero."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Absolute-value weight penalty |
| Input/output | Weights -> sparse model |
| Main steps | scale, fit, tune lambda |
| Key hyperparameters | lambda or C |
| Metrics | validation score, sparsity |
| Pros | Feature selection |
| Cons | Unstable with correlated features |
| Best use cases | High-dimensional tabular/text |

---

# L2 Regularization

## 1. Overview

L2 regularization adds the squared magnitude of weights to the loss. It discourages large weights and usually improves stability and generalization.

## 2. Intuition

L2 asks the model to keep weights small unless large weights clearly reduce prediction error. Instead of deleting features, it spreads responsibility more smoothly.

## 3. Prerequisites

Regularization, Euclidean norm, gradients, linear models, neural network weights, and validation tuning.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Weight shrinkage | Pulls weights toward zero | Controls variance | Ridge regression | Why not sparse? |
| Squared penalty | Penalizes large weights more | Smooth objective | `||w||_2^2` | Gradient form |
| Lambda | Strength | Bias-variance control | `alpha` | Tune carefully |
| Weight decay link | Multiplicative shrinkage | Optimizer implementation | SGD decay | L2 vs AdamW |

## 5. Algorithm / Working Process

1. Define task loss.
2. Add squared weight penalty.
3. Compute gradients of combined objective.
4. Update weights.
5. Tune penalty strength using validation data.

## 6. Mathematical Foundation

```text
L_total(w) = L_data(w) + lambda * ||w||_2^2
||w||_2^2 = sum_j w_j^2
grad_w lambda||w||_2^2 = 2lambda w
```

For SGD:

```text
w <- w - eta(grad L_data + 2lambda w)
```

## 7. Practical Implementation

```python
from sklearn.linear_model import Ridge
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler

model = make_pipeline(
    StandardScaler(),
    Ridge(alpha=1.0)
)
model.fit([[1, 2], [2, 1], [3, 3]], [3, 3, 6])
```

## 8. Code Explanation

Ridge regression is linear regression with L2 regularization. `alpha` controls penalty strength. Scaling features makes the penalty fair across dimensions.

## 9. Training / Evaluation

Tune `alpha` or `lambda` with validation/cross-validation. L2 is useful when many features contribute small signal. It often improves numerical conditioning.

## 10. Complexity and Cost

The penalty adds `O(p)` computation. Inference cost usually does not change because weights are rarely exactly zero.

## 11. Common Use Cases

Ridge regression, logistic regression, neural networks, recommender embeddings, and weight decay in deep learning.

## 12. Common Mistakes

Not scaling features, over-regularizing, assuming L2 performs feature selection, applying decay to biases/norm scales without thought, and confusing L2 penalty with decoupled weight decay in AdamW.

## 13. Edge Cases / Limitations

L2 does not produce sparse models. It may underfit if strong. It may not handle irrelevant high-dimensional features as cleanly as L1.

## 14. Variations

Ridge regression, L2 logistic regression, elastic net, decoupled weight decay, and Tikhonov regularization.

## 15. Related Topics

L1 creates sparsity. Weight decay is closely related but optimizer-dependent. Bias-variance trade-off explains why L2 helps.

## 16. Interview Questions

1. **What is L2?** Squared weight penalty.
2. **Formula?** `lambda sum w_j^2`.
3. **Gradient?** `2lambda w`.
4. **L2 vs L1?** L2 shrinks; L1 sparsifies.
5. **Why scale features?** Penalty depends on coefficient scale.
6. **What is Ridge?** Linear regression with L2.
7. **Does L2 select features?** Usually no.
8. **How tune lambda?** Validation or cross-validation.
9. **Can it underfit?** Yes if too strong.
10. **L2 vs weight decay?** Equivalent for simple SGD, not always for adaptive optimizers.

## 17. Practice Tasks

Compare Ridge and unregularized regression on noisy data. Plot coefficients as `alpha` increases. Train logistic regression with L2 on scaled vs unscaled features.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Ridge Housing Predictor | Robust price regression | sklearn | California Housing | Classical ML |
| L2 Neural Classifier | Tests weight decay | PyTorch | MNIST | DL training |
| Bias-Variance Demo | Shows regularization trade-off | NumPy | Synthetic polynomial | Interview visual |

## 19. Quick Revision

Key idea: discourage large weights. Formula: `L+lambda||w||_2^2`. Use when many features may matter. Trap: expecting sparsity. Interview one-liner: "L2 improves generalization by smoothly shrinking weights."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Squared weight penalty |
| Input/output | Weights -> shrunk weights |
| Main steps | add penalty, tune lambda |
| Key hyperparameters | alpha/lambda |
| Metrics | validation loss |
| Pros | Stable, smooth |
| Cons | No sparsity |
| Best use cases | Ridge, logistic regression, DL weight control |

---

# Learning Rate Schedules

## 1. Overview

Learning rate schedules change the learning rate during training. They help combine fast early learning with stable final convergence.

## 2. Intuition

At the start, take bigger steps to move quickly. Near a good solution, take smaller steps to avoid bouncing around.

## 3. Prerequisites

Learning rate, epochs, validation loss, optimizer state, warmup, and training loops.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Decay | Lower lr over time | Stabilizes convergence | Step decay | Why decay? |
| Warmup | Raise lr gradually | Stabilizes early training | Transformer warmup | Why large models need it |
| Cosine | Smooth decay curve | Strong default | CosineAnnealingLR | Why popular? |
| Plateau schedule | Reduce on no improvement | Reactive tuning | ReduceLROnPlateau | Train vs validation |
| One-cycle | Increase then decrease | Fast training | Super-convergence | Practical use |

## 5. Algorithm / Working Process

1. Pick initial lr and scheduler.
2. Train one step or epoch.
3. Update scheduler according to step count or validation metric.
4. Log current lr.
5. Stop by max epochs or early stopping.

## 6. Mathematical Foundation

Step decay:

```text
eta_t = eta_0 * gamma^floor(t / s)
```

Exponential decay:

```text
eta_t = eta_0 * gamma^t
```

Cosine decay:

```text
eta_t = eta_min + 0.5(eta_0 - eta_min)(1 + cos(pi*t/T))
```

## 7. Practical Implementation

```python
import torch

model = torch.nn.Linear(10, 2)
optimizer = torch.optim.AdamW(model.parameters(), lr=1e-3)
scheduler = torch.optim.lr_scheduler.ReduceLROnPlateau(
    optimizer, mode="min", factor=0.5, patience=2
)

for epoch in range(10):
    train_loss = 1.0 / (epoch + 1)
    val_loss = 1.0 / (epoch + 1) + 0.02
    scheduler.step(val_loss)
    print(optimizer.param_groups[0]["lr"])
```

## 8. Code Explanation

`ReduceLROnPlateau` watches validation loss and lowers lr when improvement stalls. Unlike step schedulers, it needs a metric passed to `scheduler.step`.

## 9. Training / Evaluation

Use warmup for Transformers and large-batch training. Use cosine or one-cycle for many deep learning projects. Use plateau schedules when training length is uncertain.

## 10. Complexity and Cost

Schedules add negligible compute. Bad schedules can waste full training runs.

## 11. Common Use Cases

CNN training, Transformer pretraining/fine-tuning, large-batch training, transfer learning, and long-running experiments.

## 12. Common Mistakes

Calling `scheduler.step()` at the wrong time, using validation metric with a scheduler that expects epoch count, no warmup for unstable large models, and decaying too aggressively.

## 13. Edge Cases / Limitations

Schedules are hyperparameters. A schedule that works for one batch size or optimizer may fail for another. Too-low final lr can stop useful learning early.

## 14. Variations

Constant, step, exponential, cosine, cosine with warm restarts, linear warmup, polynomial decay, one-cycle, cyclic lr, and reduce-on-plateau.

## 15. Related Topics

Learning rate, AdamW, SGD momentum, early stopping, large-batch training, and LLM fine-tuning.

## 16. Interview Questions

1. **What is lr schedule?** A rule for changing lr during training.
2. **Why decay lr?** Stabilize final convergence.
3. **What is warmup?** Gradual lr increase.
4. **Why warmup in Transformers?** Avoid unstable early updates.
5. **Step vs cosine?** Step drops abruptly; cosine decays smoothly.
6. **ReduceLROnPlateau uses what?** Validation metric.
7. **What is one-cycle?** Increase then decrease lr.
8. **Can schedule hurt?** Yes, wrong timing or magnitude.
9. **Does Adam need schedules?** Often yes.
10. **How choose?** Validate or use known defaults for architecture.

## 17. Practice Tasks

Train a model with constant, step, cosine, and plateau schedules. Plot lr vs epoch. Add warmup manually. Compare final validation accuracy.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Scheduler Dashboard | Visualizes lr curves | Python, matplotlib | None | Teaching artifact |
| CIFAR Schedule Study | Benchmarks schedules | PyTorch | CIFAR-10 | Practical DL |
| Transformer Warmup Demo | Fine-tunes with/without warmup | Hugging Face | IMDb | LLM relevance |

## 19. Quick Revision

Key idea: change lr over time. Formula: cosine decay is a common default. Use warmup for large models. Trap: stepping scheduler incorrectly. Interview one-liner: "Schedules make learning fast early and careful late."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Time-varying learning rate |
| Input/output | Step/metric -> lr |
| Main steps | choose schedule, step it, log lr |
| Key hyperparameters | initial lr, gamma, patience, warmup |
| Metrics | val loss, convergence |
| Pros | Better convergence |
| Cons | More tuning |
| Best use cases | Long DL training |

---

# Weight Decay

## 1. Overview

Weight decay shrinks weights during optimization to reduce overfitting. For SGD, it is closely related to L2 regularization; for adaptive optimizers, decoupled weight decay such as AdamW is usually preferred.

## 2. Intuition

After every update, weights are gently pulled toward zero. The model must keep a large weight only if it continues to help enough.

## 3. Prerequisites

Regularization, L2 penalty, optimizer updates, Adam vs AdamW, and parameter groups.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Shrinkage | Reduces weight magnitude | Controls complexity | `w <- 0.999w` | Why helps generalization |
| Coupled L2 | Penalty inside gradient | Equivalent to decay for SGD | SGD + L2 | When equivalent? |
| Decoupled decay | Separate shrink step | Cleaner with Adam | AdamW | Why AdamW? |
| Exclusions | Do not decay all params | Better practice | bias, LayerNorm | Which params excluded? |

## 5. Algorithm / Working Process

1. Choose optimizer with weight decay.
2. Optionally separate decay and no-decay parameters.
3. Train normally.
4. Tune `weight_decay` on validation data.

## 6. Mathematical Foundation

SGD with L2:

```text
w <- w - eta(grad L + lambda w)
```

Decoupled weight decay:

```text
w <- (1 - eta*lambda)w - eta*update_from_gradient
```

The distinction matters for Adam because adaptive scaling changes coupled L2 behavior.

## 7. Practical Implementation

```python
import torch

model = torch.nn.Sequential(torch.nn.Linear(10, 20), torch.nn.LayerNorm(20), torch.nn.Linear(20, 2))

decay, no_decay = [], []
for name, param in model.named_parameters():
    if param.ndim == 1 or name.endswith(".bias"):
        no_decay.append(param)
    else:
        decay.append(param)

optimizer = torch.optim.AdamW(
    [{"params": decay, "weight_decay": 1e-2}, {"params": no_decay, "weight_decay": 0.0}],
    lr=3e-4,
)
```

## 8. Code Explanation

Weights in matrices are decayed. Biases and one-dimensional scale parameters such as LayerNorm weights are excluded, a common Transformer practice.

## 9. Training / Evaluation

Tune weight decay with learning rate. Too little may overfit; too much underfits. For fine-tuning, typical values are smaller than pretraining or full training.

## 10. Complexity and Cost

Adds negligible compute. Parameter grouping adds no inference cost. Memory cost is optimizer-dependent, not weight-decay-dependent.

## 11. Common Use Cases

AdamW for Transformers, SGD weight decay for CNNs, recommender embeddings, and tabular neural networks.

## 12. Common Mistakes

Confusing L2 and AdamW, decaying biases/norms blindly, using extreme values, and copying `weight_decay=0.01` without validation.

## 13. Edge Cases / Limitations

Weight decay may harm models where parameter scale has special meaning. It cannot fix data leakage or bad labels. Very small models may underfit with strong decay.

## 14. Variations

Coupled L2, decoupled AdamW/SGDW, layer-wise decay, selective decay, and scheduled decay.

## 15. Related Topics

L2 regularization, AdamW, regularization, early stopping, dropout, and learning rate.

## 16. Interview Questions

1. **What is weight decay?** Shrinkage of weights during optimization.
2. **Why use it?** Reduce overfitting.
3. **L2 vs weight decay?** Equivalent for simple SGD, not always for Adam.
4. **Why AdamW?** Decouples decay from adaptive gradient scaling.
5. **Should biases decay?** Often no.
6. **Should LayerNorm decay?** Usually no.
7. **What if too high?** Underfitting.
8. **Does it add inference cost?** No.
9. **Tune with what?** Validation metrics.
10. **Common value?** `1e-2` is common for AdamW, but task-dependent.

## 17. Practice Tasks

Train Adam and AdamW with the same nominal decay. Exclude biases and norms. Sweep `weight_decay`. Inspect weight norms over epochs.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Adam vs AdamW | Demonstrates decay difference | PyTorch | MNIST | Optimizer depth |
| Norm Tracking Tool | Logs parameter norms | PyTorch | CIFAR-10 | Debugging skill |
| Transformer Fine-tune | Uses no-decay groups | Hugging Face | SST-2 | Industry practice |

## 19. Quick Revision

Key idea: shrink weights to reduce overfit. Formula: `w <- (1-lr*lambda)w - lr*update`. Use AdamW for adaptive optimizers. Trap: decaying biases/norms blindly. Interview one-liner: "Weight decay is regularization implemented as parameter shrinkage."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Weight shrinkage during training |
| Input/output | Parameters -> smaller parameters |
| Main steps | group params, set decay, train |
| Key hyperparameters | weight_decay, lr |
| Metrics | validation gap, weight norms |
| Pros | Simple regularization |
| Cons | Needs tuning |
| Best use cases | AdamW/SGD neural training |

---

# Early Stopping

## 1. Overview

Early stopping stops training when validation performance stops improving. It is an implicit regularization method that prevents unnecessary overfitting and saves compute.

## 2. Intuition

At first, the model learns general patterns. Later, it may start memorizing training noise. Early stopping keeps the checkpoint before memorization dominates.

## 3. Prerequisites

Train/validation split, validation loss, overfitting, checkpoints, patience, and model selection.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Validation monitor | Metric used to stop | Prevents train-set bias | val loss | Why not train loss? |
| Patience | Wait before stopping | Handles noise | 5 epochs | Why patience? |
| Best checkpoint | Restore best model | Avoid final overfit | min val loss | Important detail |
| Min delta | Required improvement | Avoid tiny noise wins | `1e-4` | Stable stopping |

## 5. Algorithm / Working Process

1. Train for one epoch.
2. Evaluate validation metric.
3. If improved, save checkpoint.
4. If not improved, increment counter.
5. Stop when counter reaches patience.
6. Restore best checkpoint.

## 6. Mathematical Foundation

Early stopping chooses:

```text
t* = argmin_t L_val(theta_t)
theta_final = theta_{t*}
```

It behaves like regularization because training time controls effective complexity.

## 7. Practical Implementation

```python
best_loss = float("inf")
best_state = None
bad_epochs = 0
patience = 3

for epoch in range(50):
    train_loss = 1.0 / (epoch + 1)          # replace with real training
    val_loss = 1.0 / (epoch + 1) + epoch * 0.002

    if val_loss < best_loss - 1e-4:
        best_loss = val_loss
        best_state = {"epoch": epoch}
        bad_epochs = 0
    else:
        bad_epochs += 1

    if bad_epochs >= patience:
        break

print("restore checkpoint from epoch", best_state["epoch"])
```

## 8. Code Explanation

The loop tracks the best validation loss, waits through a few bad epochs, then stops. Real code should save `model.state_dict()` and restore it after stopping.

## 9. Training / Evaluation

Use a clean validation split. Do not use test data for stopping. For noisy metrics, increase patience or use smoothed validation. Restore the best checkpoint, not the last checkpoint.

## 10. Complexity and Cost

Validation adds evaluation cost, but early stopping often saves total training compute. It adds negligible inference cost.

## 11. Common Use Cases

Small datasets, neural network training, gradient boosting, transfer learning, hyperparameter tuning, and AutoML.

## 12. Common Mistakes

Stopping on training loss, not restoring best checkpoint, using test set for stopping, patience too small, and monitoring a metric that does not match the task.

## 13. Edge Cases / Limitations

Validation noise can stop too early. Long plateaus may precede improvement. Repeatedly tuning on the same validation set can overfit validation.

## 14. Variations

Patience-based stopping, moving-average stopping, metric-based checkpointing, budget-based stopping, and successive halving/Hyperband.

## 15. Related Topics

Regularization, validation, learning rate schedules, checkpointing, hyperparameter tuning, and overfitting.

## 16. Interview Questions

1. **What is early stopping?** Stop when validation stops improving.
2. **Why regularization?** Limits training time and memorization.
3. **What is patience?** Allowed non-improving epochs.
4. **Why restore best checkpoint?** Last model may be worse.
5. **Use test set?** No.
6. **What metric monitor?** Task-relevant validation metric.
7. **Can it stop too early?** Yes with noisy validation.
8. **Does it add inference cost?** No.
9. **How tune patience?** Validation behavior and compute budget.
10. **Works with boosting?** Yes, commonly.

## 17. Practice Tasks

Add early stopping to a PyTorch loop. Compare final vs best checkpoint. Try patience values. Use validation F1 instead of loss for imbalanced classification.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Early Stop Trainer | Reusable trainer callback | PyTorch | Any | Engineering utility |
| Overfit Prevention Demo | Shows best checkpoint | PyTorch | MNIST subset | Interview clarity |
| Boosting Stop Study | Uses early stopping rounds | XGBoost/sklearn | Tabular | Classical ML relevance |

## 19. Quick Revision

Key idea: stop at best validation point. Formula: `t*=argmin L_val(theta_t)`. Trap: using test set. Interview one-liner: "Early stopping regularizes by selecting the training time that generalizes best."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Stop based on validation stagnation |
| Input/output | Validation history -> best checkpoint |
| Main steps | monitor, save best, patience, restore |
| Key hyperparameters | patience, min_delta, metric |
| Metrics | validation loss/F1/AUROC |
| Pros | Saves compute, reduces overfit |
| Cons | Sensitive to noisy validation |
| Best use cases | Neural nets, boosting, fine-tuning |

---

# Gradient Clipping

## 1. Overview

Gradient clipping limits gradient magnitude before the optimizer update. It prevents unstable huge updates, especially in RNNs, Transformers, reinforcement learning, and mixed-precision training.

## 2. Intuition

If a gradient step is dangerously large, clip it to a maximum allowed size. Normal gradients pass unchanged; extreme gradients are restrained.

## 3. Prerequisites

Gradients, norms, backpropagation, exploding gradients, optimizers, and training loops.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Exploding gradient | Huge gradient norm | Causes NaN/divergence | RNN long sequence | Why happens? |
| Norm clipping | Scale whole gradient vector | Preserves direction | max norm 1.0 | Clip by norm |
| Value clipping | Clamp each component | Simple but distorts direction | `[-1,1]` | Norm vs value |
| Threshold | Max allowed magnitude | Needs tuning | `1.0` | Too low undertrains |

## 5. Algorithm / Working Process

1. Compute loss.
2. Run `loss.backward()`.
3. Clip gradients.
4. Optimizer step.
5. Zero gradients for next iteration.

## 6. Mathematical Foundation

For gradient vector `g` and threshold `c`:

```text
if ||g||_2 > c:
    g <- c * g / ||g||_2
else:
    g <- g
```

This keeps direction but limits norm.

## 7. Practical Implementation

```python
import torch

model = torch.nn.Linear(10, 2)
optimizer = torch.optim.AdamW(model.parameters(), lr=1e-3)
x = torch.randn(32, 10)
y = torch.randint(0, 2, (32,))
loss_fn = torch.nn.CrossEntropyLoss()

optimizer.zero_grad()
loss = loss_fn(model(x), y)
loss.backward()
torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
optimizer.step()
```

## 8. Code Explanation

Clipping happens after gradients are computed and before the optimizer step. `clip_grad_norm_` rescales gradients in place if the total norm exceeds `1.0`.

## 9. Training / Evaluation

Track gradient norms when debugging instability. Clipping helps with exploding gradients but does not fix bad labels, too-high learning rates, or incorrect loss scaling.

## 10. Complexity and Cost

Computing gradient norm costs `O(p)` for `p` parameters. Memory overhead is negligible.

## 11. Common Use Cases

RNNs/LSTMs, Transformers, LLM fine-tuning, reinforcement learning, GANs, and mixed-precision training.

## 12. Common Mistakes

Clipping before `backward`, clipping after `optimizer.step`, setting threshold too low, using clipping to hide an excessive learning rate, and not unscaling gradients before clipping in mixed precision.

## 13. Edge Cases / Limitations

Too much clipping slows or prevents learning. Value clipping can distort gradient direction. Clipping treats symptoms of instability, not always root causes.

## 14. Variations

Global norm clipping, per-parameter norm clipping, value clipping, adaptive gradient clipping, and percentile-based clipping.

## 15. Related Topics

Exploding gradients, RNNs, Transformers, learning rate, mixed precision, and optimizer stability.

## 16. Interview Questions

1. **What is gradient clipping?** Limiting gradient magnitude before update.
2. **Why use it?** Prevent exploding gradients and unstable updates.
3. **Where common?** RNNs, Transformers, RL.
4. **Norm vs value clipping?** Norm preserves direction; value clamps components.
5. **When apply?** After backward, before optimizer step.
6. **Formula?** `g <- c*g/||g||` if norm exceeds `c`.
7. **Can clipping hurt?** Yes, if threshold too low.
8. **Does it fix high lr?** Not fully.
9. **Mixed precision detail?** Unscale before clipping.
10. **How debug threshold?** Log gradient norms.

## 17. Practice Tasks

Train an RNN with and without clipping. Log gradient norms. Try thresholds `0.1`, `1.0`, `5.0`. Create a too-high lr instability and see how clipping behaves.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Gradient Norm Monitor | Logs and plots norms | PyTorch | Any | Debugging tool |
| Stable RNN Trainer | Uses clipping | PyTorch | Text8 subset | Sequence modeling |
| RL Stabilization Study | Compares clipping thresholds | PyTorch | CartPole | RL training insight |

## 19. Quick Revision

Key idea: cap gradient magnitude. Formula: `g <- c*g/||g||`. Use when gradients explode. Trap: clipping at wrong time. Interview one-liner: "Gradient clipping prevents rare huge gradients from causing destructive parameter updates."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Gradient magnitude limiter |
| Input/output | Raw gradients -> clipped gradients |
| Main steps | backward, clip, step |
| Key hyperparameters | max_norm, clip_value |
| Metrics | gradient norm, validation |
| Pros | Stabilizes training |
| Cons | Can slow learning |
| Best use cases | RNNs, Transformers, RL |

---

# Convex vs Non-convex Optimization

## 1. Overview

Convex optimization has objectives where any local minimum is also global. Non-convex optimization can have many local minima, saddle points, and flat regions. Classical ML often has convex objectives; deep learning is usually non-convex.

## 2. Intuition

A convex bowl has one valley bottom. A non-convex mountain landscape has many valleys, plateaus, and passes. Deep learning trains in the second kind of landscape.

## 3. Prerequisites

Functions, gradients, Hessians, linear algebra, loss functions, and basic optimization.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Convex function | Line segment lies above graph | Global guarantees | Linear regression MSE | Why easier? |
| Non-convex function | Multiple basins/saddles possible | Deep nets | Neural network loss | Why still works? |
| Local minimum | Lower than nearby points | May not be global | Bad basin | Local vs global |
| Saddle point | Gradient zero, not min/max | Common in high dimensions | Flat direction | Why slow? |
| Initialization | Starting point matters | Affects solution | random seeds | Reproducibility |

## 5. Algorithm / Working Process

For convex problems, choose a solver and convergence criterion. For non-convex problems, use initialization, normalization, stochastic optimization, schedules, regularization, and multiple runs if needed.

## 6. Mathematical Foundation

Convexity:

```text
f(alpha x + (1-alpha)y) <= alpha f(x) + (1-alpha)f(y), for alpha in [0,1]
```

Second-order condition:

```text
f is convex if Hessian H(x) is positive semidefinite for all x
```

For convex differentiable `f`, `nabla f(x*)=0` implies global optimum.

## 7. Practical Implementation

```python
import numpy as np

def convex(x):
    return x**2

def nonconvex(x):
    return x**4 - 3*x**2 + x

xs = np.linspace(-3, 3, 200)
print("convex min approx:", xs[np.argmin(convex(xs))])
print("nonconvex min approx:", xs[np.argmin(nonconvex(xs))])
```

## 8. Code Explanation

`x^2` has one global minimum. The polynomial `x^4 - 3x^2 + x` can have multiple stationary regions, illustrating why initialization matters.

## 9. Training / Evaluation

For convex models, optimization failure is easier to diagnose. For deep nets, validation performance matters more than proving global optimality. Use seeds, checkpoints, and robust training recipes.

## 10. Complexity and Cost

Convex problems may have strong convergence guarantees. Non-convex training usually relies on empirical compute, repeated experiments, and large datasets.

## 11. Common Use Cases

Convex: linear regression, logistic regression, SVM dual forms. Non-convex: neural networks, matrix factorization, GANs, reinforcement learning.

## 12. Common Mistakes

Calling every ML objective convex, assuming local minima always ruin deep learning, ignoring saddle points, and using convex guarantees for neural nets incorrectly.

## 13. Edge Cases / Limitations

Some objectives are convex only under fixed features or fixed architecture. Regularization can preserve or break convexity depending on form.

## 14. Variations

Strongly convex functions have stronger guarantees. Quasi-convex functions generalize convexity. Non-smooth convex optimization handles L1/SVM hinge losses.

## 15. Related Topics

Gradient descent, second-order optimization, L-BFGS, initialization, normalization, and SAM.

## 16. Interview Questions

1. **What is convexity?** A function whose line segment upper-bounds the graph.
2. **Why important?** Local minimum is global.
3. **Example convex ML loss?** Linear regression MSE.
4. **Is logistic regression convex?** Yes for linear logistic regression.
5. **Are neural nets convex?** Usually no.
6. **What is saddle point?** Zero gradient but not an optimum.
7. **Why deep learning works anyway?** Overparameterization, SGD, initialization, normalization, data.
8. **Hessian condition?** Positive semidefinite Hessian.
9. **Does regularization make non-convex convex?** Usually no for deep nets.
10. **Why initialization matters?** Non-convex paths depend on start.

## 17. Practice Tasks

Plot convex and non-convex functions. Run GD from different initial points. Train logistic regression and a small neural net; compare sensitivity to seed.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Loss Landscape Visualizer | Plots 2D surfaces | NumPy, matplotlib | Synthetic | Optimization intuition |
| Seed Sensitivity Study | Measures run variation | PyTorch | MNIST | Reproducibility |
| Convex Solver Demo | Shows global convergence | sklearn/NumPy | Breast Cancer | Classical ML clarity |

## 19. Quick Revision

Key idea: convex has global guarantees; non-convex does not. Formula: `f(ax+(1-a)y)<=af(x)+(1-a)f(y)`. Trap: calling deep learning convex. Interview one-liner: "Convex optimization is guarantee-friendly; deep learning is non-convex but empirically trainable."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Shape class of objective |
| Input/output | Objective -> guarantee level |
| Main steps | check convexity, choose optimizer |
| Key hyperparameters | lr, init, regularization |
| Metrics | convergence, validation |
| Pros | Convex gives global optimum |
| Cons | Non-convex lacks guarantees |
| Best use cases | Theory and optimizer choice |

---

# Second-order Optimization

## 1. Overview

Second-order optimization uses curvature information, usually the Hessian matrix, in addition to gradients. It can converge faster than first-order methods on some problems but is expensive for large neural networks.

## 2. Intuition

Gradient tells slope. Curvature tells how the slope changes. If you know the valley shape, you can choose smarter step sizes and directions.

## 3. Prerequisites

Gradients, Hessian matrix, Taylor expansion, linear algebra, matrix inverse, convex optimization, and Newton's method.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Hessian | Matrix of second derivatives | Captures curvature | `d2L/dw_i dw_j` | Why expensive? |
| Newton step | Uses inverse Hessian | Fast near optimum | Logistic regression | Formula |
| Conditioning | Curvature ratio | Affects convergence | narrow valley | Why second-order helps |
| Approximation | Avoid full Hessian | Scalability | L-BFGS | Practical use |

## 5. Algorithm / Working Process

1. Compute gradient.
2. Compute or approximate Hessian.
3. Solve for curvature-adjusted direction.
4. Choose step length, often with line search.
5. Update parameters.

## 6. Mathematical Foundation

Second-order Taylor approximation:

```text
J(theta + delta) approx J(theta) + g^T delta + 0.5 delta^T H delta
```

Newton update:

```text
theta_{t+1} = theta_t - H_t^{-1} g_t
```

where `g_t = grad J(theta_t)` and `H_t = grad^2 J(theta_t)`.

## 7. Practical Implementation

```python
import torch

x = torch.tensor(2.0, requires_grad=True)
loss = (x - 5) ** 2
grad = torch.autograd.grad(loss, x, create_graph=True)[0]
hess = torch.autograd.grad(grad, x)[0]

newton_x = x - grad / hess
print(newton_x.item())
```

## 8. Code Explanation

For a one-dimensional quadratic, Newton's method jumps to the optimum in one step. `create_graph=True` keeps the computation graph so PyTorch can differentiate the gradient.

## 9. Training / Evaluation

Second-order methods are attractive for small/medium convex problems. For large deep nets, full Hessian storage is impossible, so approximations are used.

## 10. Complexity and Cost

For `p` parameters, Hessian storage costs `O(p^2)` and inversion costs roughly `O(p^3)`. This is infeasible for models with millions or billions of parameters.

## 11. Common Use Cases

Logistic regression solvers, small neural networks, scientific ML, meta-learning research, and optimization diagnostics.

## 12. Common Mistakes

Trying full Hessian for large networks, ignoring Hessian indefiniteness in non-convex problems, assuming Newton always descends, and forgetting line search/trust regions.

## 13. Edge Cases / Limitations

Hessian may be singular, indefinite, or noisy. Newton steps can move uphill for non-convex objectives unless modified.

## 14. Variations

Newton's method, quasi-Newton, L-BFGS, Gauss-Newton, Hessian-free optimization, conjugate gradient, K-FAC, and natural gradient.

## 15. Related Topics

L-BFGS approximates inverse Hessian. Natural gradient uses information geometry. Sharpness analysis uses Hessian eigenvalues.

## 16. Interview Questions

1. **What is second-order optimization?** Uses gradients and curvature.
2. **What is Hessian?** Matrix of second derivatives.
3. **Newton formula?** `theta <- theta - H^{-1}g`.
4. **Why faster?** Curvature-adjusted steps.
5. **Why not for big DL?** Hessian memory and inversion cost.
6. **What if Hessian indefinite?** Step may not be descent.
7. **What is quasi-Newton?** Approximates Hessian/inverse Hessian.
8. **What is line search?** Chooses step length along direction.
9. **Cost of Hessian?** `O(p^2)` storage.
10. **Where used?** Small/convex optimization and research.

## 17. Practice Tasks

Implement Newton's method for a quadratic. Compare GD and Newton on logistic regression. Compute Hessian eigenvalues for a tiny neural network.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Newton Solver | Optimizes convex functions | NumPy | Synthetic | Math strength |
| Hessian Inspector | Computes curvature | PyTorch | Tiny MLP | Research depth |
| GD vs Newton Demo | Compares convergence | Python | Logistic toy data | Interview clarity |

## 19. Quick Revision

Key idea: use curvature. Formula: `theta <- theta - H^{-1}g`. Use for small problems or approximations. Trap: full Hessian is huge. Interview one-liner: "Second-order methods replace blind downhill steps with curvature-aware steps."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Curvature-aware optimization |
| Input/output | Gradient + Hessian -> update |
| Main steps | compute g, compute/approx H, solve, step |
| Key hyperparameters | damping, line search |
| Metrics | convergence, cost |
| Pros | Fast near optimum |
| Cons | Expensive, unstable if Hessian bad |
| Best use cases | Small convex, research approximations |

---

# Natural Gradient

## 1. Overview

Natural gradient modifies gradient descent by accounting for the geometry of the model's probability distribution. It uses the Fisher Information Matrix to take steps that change the model distribution efficiently rather than just changing parameter values.

## 2. Intuition

Two parameter changes of the same Euclidean size can change predictions very differently. Natural gradient asks: "How much does this step change the model's output distribution?"

## 3. Prerequisites

Gradient descent, probability distributions, log-likelihood, KL divergence, Fisher information, and matrix-vector products.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Parameter geometry | Euclidean distance may mislead | Better update direction | softmax model | Why natural? |
| Fisher matrix | Expected gradient outer product | Local distribution curvature | `F` | Formula |
| KL constraint | Step limits distribution change | Stable learning | policy updates | RL connection |
| Invariance | Less sensitive to reparameterization | Theoretical appeal | equivalent models | Advanced follow-up |

## 5. Algorithm / Working Process

1. Compute ordinary gradient `g`.
2. Estimate Fisher Information Matrix `F`.
3. Solve `F d = g`.
4. Update `theta <- theta - eta d`.
5. Use damping/approximation for stability.

## 6. Mathematical Foundation

Natural gradient:

```text
theta_{t+1} = theta_t - eta * F(theta_t)^{-1} * grad J(theta_t)
```

Fisher Information Matrix:

```text
F = E[grad_theta log p(y|x;theta) grad_theta log p(y|x;theta)^T]
```

It often arises from minimizing loss under a small KL-divergence constraint.

## 7. Practical Implementation

```python
import torch

# Tiny diagonal-Fisher approximation for illustration.
model = torch.nn.Linear(4, 2)
x = torch.randn(8, 4)
y = torch.randint(0, 2, (8,))
loss = torch.nn.CrossEntropyLoss()(model(x), y)

grads = torch.autograd.grad(loss, model.parameters(), create_graph=False)
lr, damping = 1e-2, 1e-3

with torch.no_grad():
    for p, g in zip(model.parameters(), grads):
        fisher_diag = g.pow(2) + damping
        p -= lr * g / fisher_diag
```

## 8. Code Explanation

This is only a diagonal approximation. Real natural-gradient methods estimate Fisher structure more carefully. The update divides by approximate curvature, similar in spirit to adaptive optimizers but with probabilistic grounding.

## 9. Training / Evaluation

Natural gradient is mostly research/advanced practice. Evaluate stability, sample efficiency, and wall-clock cost. In RL, KL constraints and natural-gradient ideas appear in TRPO/PPO-style methods.

## 10. Complexity and Cost

Full Fisher storage is `O(p^2)` and inversion is expensive. Practical methods use diagonal, block-diagonal, Kronecker-factored, or implicit approximations.

## 11. Common Use Cases

Reinforcement learning policy optimization, probabilistic models, variational inference, and research optimizers such as K-FAC.

## 12. Common Mistakes

Thinking Adam is exactly natural gradient, trying to invert full Fisher for large models, ignoring damping, and confusing Hessian with Fisher.

## 13. Edge Cases / Limitations

Fisher estimates can be noisy. Approximations may be inaccurate. Implementation complexity is high compared with AdamW.

## 14. Variations

K-FAC approximates Fisher blocks. TRPO uses KL-constrained policy updates. PPO uses clipped objectives inspired by stable policy updates. Diagonal natural gradient is cheaper but cruder.

## 15. Related Topics

Second-order optimization, Fisher information, KL divergence, reinforcement learning, variational inference, and adaptive optimizers.

## 16. Interview Questions

1. **What is natural gradient?** Gradient preconditioned by inverse Fisher information.
2. **Formula?** `F^{-1}g`.
3. **Why Fisher?** Captures distribution geometry.
4. **What distance matters?** KL divergence between model distributions.
5. **Why expensive?** Fisher is huge.
6. **Natural gradient vs Newton?** Fisher vs Hessian curvature.
7. **Where used?** RL and probabilistic models.
8. **What is K-FAC?** Kronecker-factored Fisher approximation.
9. **Is Adam natural gradient?** Not exactly.
10. **Why damping?** Stabilizes matrix inversion/preconditioning.

## 17. Practice Tasks

Derive Fisher for logistic regression. Implement diagonal natural gradient. Compare with SGD on a tiny classifier. Read how TRPO constrains KL.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| Diagonal Fisher Optimizer | Implements natural-gradient approximation | PyTorch | Synthetic classifier | Research signal |
| RL KL Update Demo | Shows policy step constraints | PyTorch | CartPole | RL relevance |
| Fisher Geometry Notes | Visualizes parameter vs distribution distance | NumPy | Bernoulli model | Advanced intuition |

## 19. Quick Revision

Key idea: update according to distribution geometry. Formula: `theta <- theta - eta F^{-1}g`. Use for advanced probabilistic/RL settings. Trap: full Fisher is infeasible. Interview one-liner: "Natural gradient takes steps that are natural in probability-distribution space, not raw parameter space."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Fisher-preconditioned gradient |
| Input/output | Gradient + Fisher -> natural update |
| Main steps | estimate Fisher, solve, step |
| Key hyperparameters | lr, damping, Fisher approximation |
| Metrics | stability, sample efficiency |
| Pros | Geometry-aware |
| Cons | Expensive, complex |
| Best use cases | RL, probabilistic models, research |

---

# L-BFGS

## 1. Overview

L-BFGS, Limited-memory Broyden-Fletcher-Goldfarb-Shanno, is a quasi-Newton optimizer that approximates inverse Hessian information using a small history of recent updates. It is useful for smooth deterministic objectives and small/medium problems.

## 2. Intuition

Instead of storing the full curvature map, L-BFGS remembers the last few steps and how gradients changed. From that history, it guesses a better direction than plain gradient descent.

## 3. Prerequisites

Gradient descent, Hessian, Newton method, line search, smooth objectives, and deterministic closures.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Quasi-Newton | Approximates Hessian | Avoids full Hessian | BFGS | Why cheaper? |
| Limited memory | Stores recent pairs | Scales better | history size 10 | What is limited? |
| Curvature pairs | `s_t`, `y_t` | Learn inverse Hessian | step and grad diff | Formula intuition |
| Closure | Recomputes loss/grad | Needed in PyTorch | LBFGS closure | Practical gotcha |

## 5. Algorithm / Working Process

1. Compute loss and gradient.
2. Store recent parameter differences and gradient differences.
3. Use two-loop recursion to estimate inverse-Hessian-vector product.
4. Perform line search or step.
5. Repeat.

## 6. Mathematical Foundation

Curvature pairs:

```text
s_t = theta_{t+1} - theta_t
y_t = g_{t+1} - g_t
```

BFGS approximates inverse Hessian `H^{-1}` without forming the true Hessian. L-BFGS stores only the last `m` pairs.

## 7. Practical Implementation

```python
import torch

X = torch.randn(100, 3)
y = X @ torch.tensor([[2.0], [-1.0], [0.5]]) + 0.1
model = torch.nn.Linear(3, 1)
loss_fn = torch.nn.MSELoss()
optimizer = torch.optim.LBFGS(model.parameters(), lr=1.0, max_iter=20)

def closure():
    optimizer.zero_grad()
    loss = loss_fn(model(X), y)
    loss.backward()
    return loss

optimizer.step(closure)
print(loss_fn(model(X), y).item())
```

## 8. Code Explanation

PyTorch L-BFGS needs a closure because it may evaluate the objective multiple times during one step. This example uses full-batch data, which suits L-BFGS better than noisy mini-batches.

## 9. Training / Evaluation

Use L-BFGS for small smooth problems, neural style transfer, logistic regression-like objectives, or final polishing. It is usually not the default for large mini-batch deep learning.

## 10. Complexity and Cost

Memory is `O(mp)` for `m` history size and `p` parameters. Each step can require multiple loss/gradient evaluations.

## 11. Common Use Cases

Small neural networks, physics-informed neural networks, style transfer, logistic regression, and optimization baselines.

## 12. Common Mistakes

Using L-BFGS with noisy mini-batches, forgetting the closure, expecting it to scale like Adam, and using it on non-smooth objectives.

## 13. Edge Cases / Limitations

Poor fit for huge models and stochastic training. Requires smooth losses. Multiple closure calls can surprise logging or data-loader code.

## 14. Variations

BFGS stores full approximation. L-BFGS stores limited history. L-BFGS-B supports box constraints. OWL-QN handles L1-like objectives.

## 15. Related Topics

Second-order optimization, Hessian approximation, line search, convex optimization, and neural style transfer.

## 16. Interview Questions

1. **What is L-BFGS?** Limited-memory quasi-Newton optimizer.
2. **What does it approximate?** Inverse Hessian.
3. **Why limited memory?** Avoid storing full Hessian approximation.
4. **What are curvature pairs?** Parameter and gradient differences.
5. **Why closure in PyTorch?** Optimizer may reevaluate loss.
6. **Good for mini-batch DL?** Usually no.
7. **Where useful?** Smooth full-batch small/medium problems.
8. **L-BFGS vs Adam?** Curvature approximation vs adaptive moments.
9. **Memory cost?** `O(mp)`.
10. **What is L-BFGS-B?** Bound-constrained variant.

## 17. Practice Tasks

Optimize a quadratic with L-BFGS. Compare with Adam on full-batch regression. Use PyTorch closure correctly. Try different history sizes.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| L-BFGS Regression Solver | Trains full-batch model | PyTorch | Synthetic regression | Optimizer depth |
| Style Transfer Optimizer | Uses L-BFGS on image pixels | PyTorch | Any image pair | CV portfolio |
| PINN Optimizer Compare | Adam then L-BFGS | PyTorch | Simple PDE | Research internship value |

## 19. Quick Revision

Key idea: approximate inverse Hessian with limited history. Formula uses `s_t` and `y_t` curvature pairs. Use for smooth full-batch problems. Trap: noisy mini-batches and missing closure. Interview one-liner: "L-BFGS is a memory-efficient quasi-Newton method."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Limited-memory quasi-Newton optimizer |
| Input/output | Grad history -> curvature-aware step |
| Main steps | closure, store pairs, line search, step |
| Key hyperparameters | lr, max_iter, history_size |
| Metrics | loss, evaluations |
| Pros | Fast on smooth small problems |
| Cons | Poor fit for huge stochastic DL |
| Best use cases | Full-batch smooth optimization |

---

# Sharpness-aware Minimization

## 1. Overview

Sharpness-aware minimization, or SAM, trains models to find parameters whose nearby neighborhoods also have low loss. It aims to improve generalization by avoiding sharp minima.

## 2. Intuition

A sharp minimum is like a narrow pit: tiny parameter changes make loss much worse. A flat minimum is a broad valley: nearby models still perform well. SAM prefers broad valleys.

## 3. Prerequisites

Gradient descent, generalization, loss landscapes, adversarial perturbations, weight decay, and PyTorch training loops.

## 4. Core Concepts

| Subtopic | Meaning | Why it matters | Example | Interview angle |
|---|---|---|---|---|
| Sharpness | Loss increase nearby | Linked to generalization | narrow minimum | Why flat minima? |
| Neighborhood objective | Minimize worst nearby loss | Robust parameters | radius `rho` | SAM objective |
| Two-step update | Perturb then update | Core algorithm | ascent then descent | Cost doubles |
| Rho | Perturbation radius | Controls strength | `0.05` | Tune carefully |

## 5. Algorithm / Working Process

1. Compute gradient at current weights.
2. Perturb weights in gradient direction to increase loss locally.
3. Compute loss/gradient at perturbed weights.
4. Restore original weights.
5. Apply optimizer step using perturbed-gradient information.

## 6. Mathematical Foundation

SAM objective:

```text
min_w max_{||epsilon|| <= rho} L(w + epsilon)
```

Approximate adversarial weight perturbation:

```text
epsilon_hat = rho * g / ||g||_2
```

Then update using gradient at `w + epsilon_hat`.

## 7. Practical Implementation

```python
import torch

def sam_step(model, loss_fn, optimizer, x, y, rho=0.05):
    optimizer.zero_grad()
    loss = loss_fn(model(x), y)
    loss.backward()

    grad_norm = torch.norm(torch.stack([
        p.grad.norm() for p in model.parameters() if p.grad is not None
    ]))

    perturbations = []
    with torch.no_grad():
        for p in model.parameters():
            if p.grad is None:
                perturbations.append(None)
                continue
            e_w = rho * p.grad / (grad_norm + 1e-12)
            p.add_(e_w)
            perturbations.append(e_w)

    optimizer.zero_grad()
    sharp_loss = loss_fn(model(x), y)
    sharp_loss.backward()

    with torch.no_grad():
        for p, e_w in zip(model.parameters(), perturbations):
            if e_w is not None:
                p.sub_(e_w)

    optimizer.step()
    return sharp_loss.item()
```

## 8. Code Explanation

The function first finds the direction that increases loss locally, perturbs weights by radius `rho`, computes gradients at the worse nearby point, restores weights, and performs the optimizer step.

## 9. Training / Evaluation

SAM often improves validation accuracy but roughly doubles forward/backward cost. Tune `rho`, base optimizer, learning rate, and weight decay. Compare against a strong baseline because SAM is not always worth the compute.

## 10. Complexity and Cost

SAM usually requires two forward/backward passes per update, nearly doubling training time. Memory overhead is small except for storing perturbations.

## 11. Common Use Cases

Image classification, robustness-sensitive training, small/medium deep networks, and research projects on generalization.

## 12. Common Mistakes

Forgetting to restore weights, not zeroing gradients between passes, using too large `rho`, comparing SAM to a weak baseline, and ignoring doubled compute.

## 13. Edge Cases / Limitations

SAM can be expensive for LLMs. It may interact strongly with BatchNorm and distributed training. Sharpness is scale-sensitive, so interpretation needs care.

## 14. Variations

ASAM adapts perturbation by parameter scale. GSAM modifies gradient decomposition. Efficient SAM variants reduce compute. LookSAM reuses perturbation less frequently.

## 15. Related Topics

Regularization, flat minima, weight decay, adversarial training, generalization, Hessian sharpness, and learning rate schedules.

## 16. Interview Questions

1. **What is SAM?** Optimizer method that minimizes worst nearby loss.
2. **Objective?** `min_w max_{||eps||<=rho} L(w+eps)`.
3. **Why flat minima?** They may generalize better and be robust to perturbations.
4. **How many passes?** Usually two forward/backward passes per step.
5. **What is rho?** Perturbation radius.
6. **Main downside?** Extra training cost.
7. **Is SAM regularization?** Yes, optimization-based regularization.
8. **What if rho too high?** Underfitting or instability.
9. **SAM vs adversarial training?** Perturbs weights, not inputs.
10. **Where useful?** Vision and generalization research.

## 17. Practice Tasks

Implement SAM for a small MLP. Compare validation accuracy with AdamW. Sweep `rho`. Plot train/validation gap. Try SAM on noisy labels.

## 18. Project Ideas

| Project | What it does | Tech stack | Dataset | Resume value |
|---|---|---|---|---|
| SAM Image Classifier | Tests flat-minima training | PyTorch | CIFAR-10 | Research-friendly |
| Sharpness Probe | Measures loss around weights | PyTorch | MNIST | Generalization insight |
| SAM vs AdamW Report | Benchmarks cost/accuracy | PyTorch | Fashion-MNIST | Strong interview artifact |

## 19. Quick Revision

Key idea: minimize loss in a neighborhood, not only at current weights. Formula: `min_w max_{||eps||<=rho} L(w+eps)`. Use when generalization gain justifies compute. Trap: forgetting the restore step. Interview one-liner: "SAM searches for parameters in flat neighborhoods rather than sharp pits."

## 20. Final Cheat Sheet

| Item | Summary |
|---|---|
| Definition | Sharpness-aware training objective |
| Input/output | Weights + batch -> flat-minimum update |
| Main steps | gradient, perturb, gradient, restore, step |
| Key hyperparameters | rho, base lr, weight decay |
| Metrics | validation score, train cost |
| Pros | Better generalization sometimes |
| Cons | Nearly double training cost |
| Best use cases | Vision/generalization research |

