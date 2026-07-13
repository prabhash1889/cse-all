# Optimization and Generalization: Placement Guide

All examples use Python/PyTorch unless noted. Tune every choice on validation data and report the test score only once.

# Regularization

## 1. Overview
Regularization constrains a model so it learns repeatable signal instead of training-set noise. It is used in linear models, CNNs, Transformers, recommenders, and LLM fine-tuning.

## 2. Intuition
It is a complexity tax: a model may add complexity only when it earns enough reduction in data error.

## 3. Prerequisites
Loss functions, train/validation/test splits, gradients, parameters, and the bias-variance trade-off.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Explicit penalty | Add L1/L2 to cross-entropy. Ask: why does this reduce variance? |
| Implicit control | Early stopping, SGD noise, and augmentation favor simpler solutions. Ask: must regularization be a penalty? No. |
| Capacity control | Smaller network, dropout, or pruning limits memorization. Ask: can it underfit? Yes. |

## 5. Algorithm / Working Process
1. Split data correctly. 2. Pick a task loss. 3. Add one or more controls. 4. Tune strength on validation data. 5. Restore/select the best validation checkpoint, then test once.

## 6. Mathematical Foundation
\[
\mathcal L_{\rm total}(\theta)=\frac1n\sum_{i=1}^n\ell(f_\theta(x_i),y_i)+\lambda\Omega(\theta).
\]
\(\Omega\) describes the desired simplicity; larger \(\lambda\) normally increases bias and reduces variance.

## 7. Practical Implementation
~~~python
import torch
from torch import nn
model = nn.Sequential(nn.Linear(20, 64), nn.ReLU(), nn.Dropout(0.2), nn.Linear(64, 3))
loss_fn = nn.CrossEntropyLoss()
optimizer = torch.optim.AdamW(model.parameters(), lr=3e-4, weight_decay=1e-2)
def step(x, y):
    optimizer.zero_grad(); loss = loss_fn(model(x), y)
    loss.backward(); optimizer.step()
    return loss.item()
~~~

## 8. Code Explanation
Dropout masks hidden units only in training. AdamW supplies decoupled weight decay; switch to evaluation mode before validation so dropout is disabled.

## 9. Training / Evaluation
Use stratified splits for classification and chronological splits for time series. Track validation loss plus accuracy, F1, AUROC, or RMSE. Poor train and validation scores mean underfit; a large gap means overfit.

## 10. Complexity and Cost
L1/L2 adds \(O(p)\) work for \(p\) parameters. Dropout has small training overhead and no inference-time sampling.

## 11. Common Use Cases
CNNs with augmentation/decay, tabular models with feature selection, and Transformer fine-tuning with AdamW, dropout, and early stopping.

## 12. Common Mistakes
Tuning on test data, regularizing every bias/norm scale, augmenting validation data, and selecting the lowest training loss.

## 13. Edge Cases / Limitations
Too much control removes weak real signals. It cannot fix label leakage, wrong splits, or distribution shift.

## 14. Variations
L1, L2, dropout, augmentation, label smoothing, early stopping, and SAM. L1/L2/dropout are placement essentials; SAM is useful research depth.

## 15. Related Topics
Bias-variance explains the goal; weight decay implements L2-like control; early stopping is implicit regularization.

## 16. Interview Questions
1. **What is regularization?** A constraint improving unseen-data performance.  
2. **Why can training loss rise?** The objective pays complexity cost.  
3. **Can smaller models regularize?** Yes, by lowering capacity.  
4. **Does it fix leakage?** No.  
5. **How tune it?** Validation or cross-validation.  
6. **Over-regularization?** High bias and poor train/validation scores.  
7. **Dropout at inference?** No.  
8. **Is augmentation regularization?** Yes.  
9. **Why not retune indefinitely on validation?** It overfits validation.  
10. **Time-series difference?** Preserve temporal order.

## 17. Practice Tasks
Compare no regularization, dropout, and AdamW; plot train/validation curves. Repeat with much less data and explain the change.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| Plant classifier | PyTorch, PlantVillage | Generalization analysis |
| Sparse credit model | sklearn, UCI Adult | Explainable selection |
| Fine-tuning study | Transformers, IMDB | Training ablation |

## 19. Quick Revision
**Idea:** penalize complexity. **Formula:** \(\mathcal L+\lambda\Omega\). **Use:** large validation gap. **Trap:** test-set tuning. **One-liner:** trade slight fit for stronger generalization.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | training data to constrained model |
| Hyperparameters | \(\lambda\), dropout, augmentation strength |
| Pros/cons | less overfit / can underfit |
| Best use | high-capacity models, limited/noisy data |

# L1 Regularization

## 1. Overview
L1 regularization adds absolute coefficient magnitude to the loss. It is valuable for sparse, interpretable linear models and high-dimensional text/genomics features.

## 2. Intuition
Every nonzero weight pays a fixed fee, so weak features are often set exactly to zero.

## 3. Prerequisites
Linear/logistic regression, subgradients, feature scaling, and convex optimization.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Sparsity | Exact zero coefficients; why it performs feature selection. |
| Subgradient | Absolute value is nondifferentiable at zero; subgradient there is \([-1,1]\). |
| Scaling | Standardize features; otherwise units change penalty fairness. |

## 5. Algorithm / Working Process
Standardize numerical columns, train Lasso/L1-logistic models over candidate strengths, select with validation, and inspect coefficient stability.

## 6. Mathematical Foundation
\[
\min_w\frac1n\sum_i\ell(x_i^\top w,y_i)+\lambda\|w\|_1,\qquad\|w\|_1=\sum_j|w_j|.
\]
The proximal soft threshold is
\[
w_j\leftarrow{\rm sign}(z_j)\max(|z_j|-\eta\lambda,0).
\]

## 7. Practical Implementation
~~~python
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Lasso
lasso = make_pipeline(StandardScaler(), Lasso(alpha=0.03, max_iter=10_000))
lasso.fit(X_train, y_train)
print("selected:", (lasso[-1].coef_ != 0).sum())
~~~

## 8. Code Explanation
The pipeline fits scaling on training data only. In sklearn regression, alpha is L1 strength; nonzero coefficients are selected features.

## 9. Training / Evaluation
Use CV when data is scarce; report RMSE/MAE for regression or F1/AUROC for classification. Check selection stability across folds.

## 10. Complexity and Cost
Coordinate descent works well with sparse matrices. Sparse coefficients reduce storage and inference multiplications.

## 11. Common Use Cases
Spam keywords, gene-expression models, marketing models with many engineered features, and compact linear scorers.

## 12. Common Mistakes
Skipping scaling, treating selected features as causal, expecting all correlated features to survive, and applying L1 blindly to dense embeddings.

## 13. Edge Cases / Limitations
With correlated predictors L1 may select one arbitrarily. It may discard weak but jointly useful features.

## 14. Variations
Elastic Net mixes L1/L2 for correlated features; Group Lasso removes whole groups. Elastic Net is important for placements.

## 15. Related Topics
L2 shrinks rather than selects; proximal methods optimize nonsmooth penalties; sparse matrices exploit L1 outputs.

## 16. Interview Questions
1. **Why zeros?** Constant shrinkage and L1 geometry make crossing zero optimal.  
2. **L1 versus L2?** L1 selects; L2 smoothly shrinks.  
3. **Why scale?** Coefficients depend on units.  
4. **Differentiable?** Not at zero.  
5. **Correlated variables?** L1 chooses unstably.  
6. **What is Lasso?** L1-regularized regression.  
7. **Inference benefit?** Sparse multiplication.  
8. **Higher lambda?** Fewer features.  
9. **Proximal operator?** Exact nonsmooth penalty step.  
10. **When Elastic Net?** Correlated useful predictors.

## 17. Practice Tasks
Add 500 noise columns to a regression task; compare Ridge/Lasso selection before and after scaling.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| Spam selector | sklearn, SMS Spam | Sparse NLP |
| Gene screener | sklearn, public genomic data | High-dimensional ML |
| Churn scorecard | Pandas/sklearn, Telco | Interpretability |

## 19. Quick Revision
**Formula:** \(\mathcal L+\lambda\sum|w_j|\). **Use:** sparse interpretable coefficients. **Trap:** unscaled columns. **One-liner:** L1 can zero parameters exactly.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | standardized features to sparse weights |
| Hyperparameter | lambda/alpha |
| Pros/cons | selection and compactness / unstable correlation behavior |
| Best use | high-dimensional linear models |

# L2 Regularization

## 1. Overview
L2 penalizes squared parameter magnitude. It is a default regularizer for stable dense models, including neural networks and multicollinear tabular regression.

## 2. Intuition
Large weights stretch a rubber band; many small cooperating weights remain possible.

## 3. Prerequisites
Norms, derivatives, linear regression, gradient descent, and feature normalization.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Ridge penalty | Sum of squared weights; prevents extremes. |
| Smoothness | Derivative exists everywhere; derive \(2\lambda w\). |
| Correlation | Shares weight among related variables; contrast Lasso. |

## 5. Algorithm / Working Process
Scale features, validate a strength, optimize the loss, and inspect task metric/calibration. In neural networks use SGD or AdamW, normally excluding biases and norm scales.

## 6. Mathematical Foundation
\[
\mathcal L(w)=\frac1n\|Xw-y\|_2^2+\lambda\|w\|_2^2,\qquad\nabla(\lambda\|w\|_2^2)=2\lambda w.
\]
Ridge solution:
\[
\hat w=(X^\top X+\lambda I)^{-1}X^\top y.
\]
The diagonal addition improves conditioning.

## 7. Practical Implementation
~~~python
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler
from sklearn.linear_model import Ridge
ridge = make_pipeline(StandardScaler(), Ridge(alpha=1.0))
ridge.fit(X_train, y_train)
valid_prediction = ridge.predict(X_valid)
~~~

## 8. Code Explanation
Standardization makes penalty comparable across units. Ridge alpha controls the squared-weight penalty.

## 9. Training / Evaluation
Search lambda logarithmically, for example \(10^{-5}\) to \(10^3\). Plot validation error against log lambda and choose with RMSE/MAE or classification metric.

## 10. Complexity and Cost
Dense direct Ridge solving is about \(O(p^3)\); iterative solvers suit high dimensions. Neural L2 adds \(O(p)\) per step.

## 11. Common Use Cases
Multicollinear regression, logistic models, CNN/Transformer training, and noisy sensor inputs.

## 12. Common Mistakes
Penalizing intercepts, confusing L2 loss with L2 regularization, tuning on training loss, and explicitly inverting matrices.

## 13. Edge Cases / Limitations
L2 does not hard-select features; large lambda collapses weights and underfits; it cannot correct nonlinear misspecification.

## 14. Variations
Ridge, Tikhonov regularization, Gaussian-prior MAP, and decoupled AdamW. The Bayesian interpretation is strong interview depth.

## 15. Related Topics
Weight decay matches L2 only under specific optimizer updates. L1 selects; Elastic Net blends both.

## 16. Interview Questions
1. **L2 gradient?** \(2\lambda w\).  
2. **Why stable?** Lambda I improves conditioning.  
3. **Zeros?** Rarely exact zeros.  
4. **Intercept penalty?** Usually exclude it.  
5. **Prior?** Zero-mean Gaussian.  
6. **Ridge under correlation?** Shares weights.  
7. **Higher lambda?** More shrinkage/bias.  
8. **Variance effect?** Reduces sensitivity to samples.  
9. **Why standardize?** Units affect coefficients.  
10. **Tune it?** Validation/CV.

## 17. Practice Tasks
Create nearly duplicate columns and compare ordinary least squares versus Ridge coefficients and validation RMSE.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| House-price baseline | sklearn, Ames | Robust regression |
| Energy predictor | sklearn, UCI Energy | Multicollinearity |
| Sensor calibration | NumPy/sklearn | Conditioning analysis |

## 19. Quick Revision
**Formula:** \(\mathcal L+\lambda\|w\|_2^2\). **Use:** stable dense weights. **Trap:** unscaled inputs. **One-liner:** L2 smoothly shrinks coefficients.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | scaled features to dense shrunken weights |
| Hyperparameter | lambda |
| Pros/cons | stable/smooth / no hard selection |
| Best use | multicollinearity, high variance |

# Learning Rate Schedules

## 1. Overview
A learning-rate schedule changes step size during training. Deep models need large enough early steps to progress and small enough late steps to converge.

## 2. Intuition
Take broad strides to find a good valley, then short steps to settle into it: training gears.

## 3. Prerequisites
Gradient descent, epochs versus steps, optimizers, validation curves, and learning rate.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Warm-up | Increase LR from near zero; vital for Transformers/large batches. |
| Decay | Reduce LR by time or plateau; enables fine convergence. |
| Cosine/cyclic | Smoothly or periodically vary LR; explain cosine annealing. |
| One-cycle | Raise then lower LR once; why can it train quickly? |

## 5. Algorithm / Working Process
Set base LR from an established recipe or LR range test; warm up if needed; decay per batch, epoch, or validation plateau; log LR; save scheduler state with checkpoints.

## 6. Mathematical Foundation
Step decay:
\[
\eta_t=\eta_0\gamma^{\lfloor t/s\rfloor}.
\]
Cosine decay over \(T\) steps:
\[
\eta_t=\eta_{\min}+\tfrac12(\eta_{\max}-\eta_{\min})[1+\cos(\pi t/T)].
\]
Linear warm-up for \(W\) steps: \(\eta_t=\eta_{\max}t/W\) when \(t<W\).

## 7. Practical Implementation
~~~python
import torch
optimizer = torch.optim.AdamW(model.parameters(), lr=3e-4, weight_decay=1e-2)
scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(
    optimizer, T_max=20, eta_min=1e-6)
for epoch in range(20):
    train_one_epoch(model, train_loader, optimizer)
    validate(model, valid_loader)
    scheduler.step()
    print(optimizer.param_groups[0]["lr"])
~~~

## 8. Code Explanation
The scheduler mutates the optimizer's LR. Here it steps once per epoch, so T_max is epochs; a per-batch scheduler needs T_max in batches.

## 9. Training / Evaluation
Plot LR with loss. Exploding/oscillatory loss suggests LR is high; extremely slow improvement suggests it is low. Use warm-up with large effective batch sizes and mixed precision.

## 10. Complexity and Cost
Schedules cost \(O(1)\) per update and may reduce total epochs.

## 11. Common Use Cases
Cosine in vision, warm-up plus linear/cosine decay in Transformers, ReduceLROnPlateau for smaller tabular models, one-cycle for fast experiments.

## 12. Common Mistakes
Stepping at wrong frequency, losing scheduler state on resume, reacting to noisy training loss, or choosing a duration never reached.

## 13. Edge Cases / Limitations
No schedule repairs bad labels, broken gradients, or an intrinsically unsuitable initial LR. Plateau detection is noisy on small validation sets.

## 14. Variations
Constant plus warm-up, step, exponential, cosine warm restarts, plateau, and one-cycle. Warm-up/cosine are key modern interview topics.

## 15. Related Topics
Batch size affects usable LR. Gradient clipping prevents extreme steps; early stopping ends training rather than changing LR.

## 16. Interview Questions
1. **Why decay LR?** Late updates need precision.  
2. **Why warm-up?** Avoid unstable initial updates.  
3. **Cosine versus step?** Smooth fixed decay versus abrupt drops.  
4. **Plateau scheduler input?** Validation metric.  
5. **Per batch or epoch?** Match scheduler design.  
6. **LR too high signal?** Divergence/NaNs/oscillation.  
7. **Too low?** Slow stagnation.  
8. **Why save state?** Resetting LR changes resumed training.  
9. **Generalization effect?** Update noise/final basin changes.  
10. **One-cycle?** LR rises then anneals very low once.

## 17. Practice Tasks
Compare fixed LR, step, and cosine schedules with identical epochs; plot LR and validation loss.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| CIFAR schedule benchmark | PyTorch, CIFAR-10 | Controlled optimization experiment |
| BERT recipe | Transformers, AG News | Warm-up scheduling |
| LR finder | PyTorch | Training diagnostics tool |

## 19. Quick Revision
**Idea:** broad early, precise late. **Formula:** \(\eta_t\) schedule. **Trap:** wrong stepping frequency. **One-liner:** schedules allocate optimization precision over time.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | time or metric to current LR |
| Hyperparameters | base/min LR, warm-up, duration |
| Cost | negligible |
| Best use | almost every deep-learning run |

# Weight Decay

## 1. Overview
Weight decay shrinks weights a little at each update. For plain SGD it matches common L2 formulations; AdamW decouples it from adaptive gradient scaling.

## 2. Intuition
Unused parameter magnitude slowly evaporates. A gradient must repeatedly justify large weights.

## 3. Prerequisites
SGD, Adam, L2 penalties, optimizer parameter groups, and neural-network parameter types.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Coupled L2 | Add L2 gradient to gradient; when equivalent to SGD decay? |
| Decoupled decay | Shrink independently of Adam moments; why AdamW? |
| Parameter groups | Decay matrices, commonly exclude bias and normalization scale. |

## 5. Algorithm / Working Process
Split decayed/non-decayed parameters; compute gradients; update with optimizer; shrink selected weights; tune decay jointly with LR and data augmentation.

## 6. Mathematical Foundation
\[
w_{t+1}=(1-\eta\lambda)w_t-\eta g_t.
\]
For SGD, adding \(\lambda\|w\|_2^2/2\) gives gradient \(g_t+\lambda w_t\), the same update. Adam rescales gradient coordinates, so coupled L2 differs; AdamW applies shrinkage separately.

## 7. Practical Implementation
~~~python
decay, no_decay = [], []
for name, p in model.named_parameters():
    (no_decay if p.ndim == 1 or name.endswith("bias") else decay).append(p)
optimizer = torch.optim.AdamW(
    [{"params": decay, "weight_decay": 1e-2},
     {"params": no_decay, "weight_decay": 0.0}], lr=3e-4)
~~~

## 8. Code Explanation
Matrix weights decay; one-dimensional bias and scale vectors do not. AdamW applies decay independently of its moment-normalized gradient.

## 9. Training / Evaluation
Search on a log scale, often \(10^{-4}\) through \(10^{-1}\), but start from an architecture recipe. Compare validation metric, calibration, norms, and train-validation gap.

## 10. Complexity and Cost
One multiply per decayed parameter per update, \(O(p)\), negligible beside backpropagation.

## 11. Common Use Cases
CNNs, ViTs, LLM pretraining/fine-tuning, and high-capacity tabular MLPs.

## 12. Common Mistakes
Claiming Adam decay always equals L2, decaying every bias/LayerNorm scale, copying LR without compatible decay, and selecting decay on test data.

## 13. Edge Cases / Limitations
It may hurt small models or tasks requiring precise large embeddings. It cannot independently solve distribution shift.

## 14. Variations
Coupled SGD L2, AdamW, layer-wise decay, and selective no-decay groups. AdamW groups are essential for Transformer work.

## 15. Related Topics
L2 is an objective penalty; weight decay is an update rule. SAM and dropout also affect generalization by different mechanisms.

## 16. Interview Questions
1. **What is weight decay?** Multiplicative parameter shrinkage.  
2. **SGD relation to L2?** Equivalent under matching conventions.  
3. **Why AdamW?** Decouples decay from adaptive scaling.  
4. **Decay bias?** Usually no.  
5. **Decay LayerNorm?** Usually no.  
6. **Higher decay?** Smaller weights, possible underfit.  
7. **Tune with LR?** Yes.  
8. **Exact zero weights?** No, unlike L1.  
9. **Why groups?** Parameters have different roles.  
10. **Inference cost?** None.

## 17. Practice Tasks
Fine-tune a text classifier with Adam and AdamW; compare F1, calibration, and average weight norm.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| ViT sweep | PyTorch/timm, CIFAR-100 | Modern vision recipe |
| Sentiment fine-tune | Transformers, SST-2 | Correct optimizer groups |
| Norm dashboard | PyTorch/TensorBoard | Experiment observability |

## 19. Quick Revision
**Update:** \(w\leftarrow(1-\eta\lambda)w-\eta g\). **Use:** neural-network training. **Trap:** decay all parameters. **One-liner:** AdamW is decoupled weight decay.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Hyperparameters | LR, decay |
| Main step | shrink selected weights each update |
| Pros/cons | simple robust control / may underfit |
| Best use | CNNs and Transformers |

# Early Stopping

## 1. Overview
Early stopping ends training after validation performance stops improving and restores best weights. It saves compute and implicitly regularizes iterative learners.

## 2. Intuition
Validation data is the referee: stop when it sees no material improvement for several checks, even if training loss still declines.

## 3. Prerequisites
Validation sets, metrics, evaluation mode, checkpoints, and overfitting curves.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Monitor | Validation loss/F1/AUROC; why not training loss? |
| Patience | Allowed non-improving checks; handles noise. |
| Restore best | Return best rather than last weights; common bug. |

## 5. Algorithm / Working Process
Evaluate each epoch; save state on improvement beyond min_delta; otherwise increment counter; stop at patience; restore saved state; evaluate test set once.

## 6. Mathematical Foundation
For minimized validation metric \(m_t\), save if
\[
m_t<m_{\rm best}-\delta.
\]
Stop after \(k\) consecutive failures. Limited optimization time can act like shrinkage in some linear settings.

## 7. Practical Implementation
~~~python
import copy
best, bad_epochs, patience, best_state = float("inf"), 0, 5, None
for epoch in range(100):
    train_one_epoch(model, train_loader, optimizer)
    score = validate_loss(model, valid_loader)
    if score < best - 1e-4:
        best, bad_epochs, best_state = score, 0, copy.deepcopy(model.state_dict())
    else:
        bad_epochs += 1
        if bad_epochs >= patience: break
model.load_state_dict(best_state)
~~~

## 8. Code Explanation
Deep-copy prevents the saved state mutating during future epochs. Validation must use evaluation mode and no gradient tracking.

## 9. Training / Evaluation
Monitor a metric matching the goal: loss for probabilities, macro-F1 for balanced class importance, PR-AUC for rare positives. Small validation sets need more patience or CV.

## 10. Complexity and Cost
Validation adds evaluation passes but often reduces total cost. Best checkpoint needs one extra model state.

## 11. Common Use Cases
Gradient boosting, transfer learning, small/medium neural networks, and resource-limited sweeps.

## 12. Common Mistakes
Stopping on training loss, failing to restore best state, monitoring the wrong metric, and using the test set as monitor.

## 13. Edge Cases / Limitations
Small patience can stop before delayed gains; noisy validation can cause false stops; it does not eliminate need for a final test set.

## 14. Variations
Patience, smoothed/EMA metrics, multi-metric rules, and budgeted stopping. Patience plus restoration is placement core.

## 15. Related Topics
It is implicit regularization. ReduceLROnPlateau lowers LR before stopping; both should have independent patience accounting.

## 16. Interview Questions
1. **Why validation?** Training loss rewards memorization.  
2. **Patience?** Consecutive non-improvements permitted.  
3. **Restore best?** Last epoch can be worse.  
4. **Min delta?** Minimum meaningful change.  
5. **Can it underfit?** Yes.  
6. **Need test set?** Yes.  
7. **Loss versus accuracy?** Confidence can improve while accuracy stays.  
8. **Imbalanced monitor?** Macro-F1/PR-AUC as appropriate.  
9. **What save?** Model, optimizer, scheduler, epoch, metric.  
10. **Regularization relation?** Fewer fitting iterations reduce overfit.

## 17. Practice Tasks
Implement it from scratch and compare last-epoch versus restored-best validation/test scores under noisy labels.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| Callback library | PyTorch | Reproducible training control |
| Medical classifier | PyTorch, X-ray subset | Metric-driven stopping |
| Boosting benchmark | XGBoost, tabular data | Compute-aware selection |

## 19. Quick Revision
**Idea:** stop on held-out metric, restore best. **Trap:** use final weights. **One-liner:** early stopping is a compute-saving implicit regularizer.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | validation history to best checkpoint |
| Hyperparameters | monitor, mode, patience, min_delta |
| Pros/cons | saves compute / noise sensitive |
| Best use | iterative models with validation data |

# Gradient Clipping

## 1. Overview
Gradient clipping limits gradient magnitude before an update. It prevents exploding gradients in RNNs, Transformers, reinforcement learning, and mixed-precision training.

## 2. Intuition
It is a speed limit for dangerous updates: norm clipping preserves direction but caps length.

## 3. Prerequisites
Backpropagation, vector norms, chain rule, optimizer steps, and mixed precision.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Norm clipping | Rescale all gradients if global norm exceeds threshold; does direction change? No. |
| Value clipping | Clamp each component; can distort direction. |
| Exploding gradient | Repeated Jacobian products grow; why common in long RNNs? |

## 5. Algorithm / Working Process
Backpropagate; unscale if AMP is used; measure global norm; clip before optimizer step; log norm and clip frequency to find underlying instability.

## 6. Mathematical Foundation
\[
\tilde g=g\min\left(1,\frac{c}{\|g\|_2+\epsilon}\right).
\]
Below threshold \(c\), gradient is unchanged; above it, \(\|\tilde g\|_2=c\). Value clipping uses \(\tilde g_j={\rm clip}(g_j,-c,c)\).

## 7. Practical Implementation
~~~python
scaler = torch.amp.GradScaler("cuda", enabled=torch.cuda.is_available())
optimizer.zero_grad()
with torch.autocast("cuda", enabled=torch.cuda.is_available()):
    loss = criterion(model(x), y)
scaler.scale(loss).backward()
scaler.unscale_(optimizer)
norm = torch.nn.utils.clip_grad_norm_(model.parameters(), max_norm=1.0)
scaler.step(optimizer); scaler.update()
~~~

## 8. Code Explanation
Clipping is after backward and before step. AMP scales gradients, so unscale first. Returned norm should be logged.

## 9. Training / Evaluation
Start near 1.0 for Transformer fine-tuning, then inspect trigger rate. Clipping every step means investigate LR, data, initialization, or loss.

## 10. Complexity and Cost
Global clipping scans gradients: \(O(p)\), negligible memory and compute relative to backprop.

## 11. Common Use Cases
Long sequence RNNs, LLM fine-tuning, policy gradients, GANs, and AMP GPU runs.

## 12. Common Mistakes
Clipping after step, clipping scaled AMP values, tiny thresholds that block learning, and using clipping to hide persistent NaNs.

## 13. Edge Cases / Limitations
It does not fix vanishing gradients, bad labels, or poor objectives. Value clipping can severely change direction in high dimensions.

## 14. Variations
Global norm, per-layer norm, per-example clipping for differential privacy, adaptive clipping, and value clipping. Global norm is the standard answer.

## 15. Related Topics
LR controls ordinary update size; clipping handles rare extremes. Gradient accumulation determines when clipping is applied.

## 16. Interview Questions
1. **What does norm clipping do?** Caps global norm by rescaling.  
2. **Direction changed?** No for norm clipping.  
3. **When apply?** After backward, before step.  
4. **Why RNNs?** Jacobian products explode.  
5. **Value versus norm?** Component clamp versus direction-preserving scale.  
6. **Fix vanishing?** No.  
7. **AMP order?** Unscale then clip.  
8. **Always triggers?** Diagnose model/LR/threshold.  
9. **Can it hurt?** Yes if too aggressive.  
10. **Regularization?** Mostly stability control.

## 17. Practice Tasks
Train a long-sequence RNN with/without clipping and plot gradient norms and divergence.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| Character RNN lab | PyTorch, Tiny Shakespeare | Stability diagnosis |
| AMP fine-tune template | PyTorch/Transformers | GPU training skill |
| RL norm monitor | Gymnasium/PyTorch | Optimizer observability |

## 19. Quick Revision
**Formula:** \(\tilde g=g\min(1,c/\|g\|)\). **Use:** exploding gradients. **Trap:** clip after step. **One-liner:** clipping caps update magnitude.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | raw gradients to bounded gradients |
| Hyperparameter | max norm \(c\) |
| Pros/cons | prevents spikes / can conceal root cause |
| Best use | RNNs, Transformers, RL, AMP |

# Convex vs Non-convex Optimization

## 1. Overview
Optimization minimizes a loss. Convex losses offer global-optimum structure; neural-network losses are non-convex, so practice relies on SGD, validation, and robustness across seeds.

## 2. Intuition
A convex bowl has no deceptive dip. A non-convex mountain range has valleys, plateaus, local minima, and saddles.

## 3. Prerequisites
Derivatives, Hessians, eigenvalues, gradient descent, linear algebra, and losses.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Convexity | Chord lies above function; state inequality. |
| Global optimum | Best everywhere; local minimum suffices for convex loss. |
| Saddle | Zero gradient but neither min nor max; important in deep nets. |
| Conditioning | Curvature ratio governs speed; why standardize inputs? |

## 5. Algorithm / Working Process
For convex tasks, verify domain/objective assumptions and use a solver with stopping diagnostics. For neural losses, initialize, train with SGD/Adam and schedules, validate across seeds, and select by held-out metrics.

## 6. Mathematical Foundation
\[
f(\alpha x+(1-\alpha)y)\le\alpha f(x)+(1-\alpha)f(y),\quad\alpha\in[0,1].
\]
For twice-differentiable functions, \(H=\nabla^2f\succeq0\) everywhere implies convexity. For differentiable convex objectives, \(\nabla f(x^*)=0\) is globally optimal.

## 7. Practical Implementation
~~~python
def descend(grad, x, lr=0.05, steps=100):
    for _ in range(steps): x -= lr * grad(x)
    return x
solution = descend(lambda x: 2 * (x - 2), 10.0)
assert abs(solution - 2) < 1e-3
grad_nonconvex = lambda x: 4*x**3 - 6*x + 0.2  # try several starts
~~~

## 8. Code Explanation
The quadratic is convex and all reasonable starts reach 2. The polynomial gradient can settle at different stationary points from different initializations.

## 9. Training / Evaluation
Convex tasks use convergence gap and constraint violation. Non-convex ML uses validation metrics, calibration, seed stability, and cost rather than only final train loss.

## 10. Complexity and Cost
Convex problems can still be huge. Modern non-convex training cost is forward/backward computation; full Hessian inspection is impractical.

## 11. Common Use Cases
Ridge, logistic regression, and SVMs are convex; neural networks, matrix factorization, GANs, and RL are non-convex.

## 12. Common Mistakes
Equating non-convex with failure, saying all local minima are bad, treating zero gradient as a minimum, and ignoring saddles.

## 13. Edge Cases / Limitations
Convex guarantees need assumptions/step sizes. Non-convex theory often cannot predict generalization; random seeds can vary outcomes.

## 14. Variations
Strong convexity gives faster rates; quasi-convex/biconvex objectives have partial structure; stochastic non-convex optimization is the deep-learning norm.

## 15. Related Topics
Second-order methods use curvature; L-BFGS approximates it; SAM searches local neighborhoods of non-convex losses.

## 16. Interview Questions
1. **Define convexity.** Chord inequality above.  
2. **Local equals global when?** Convex objective and domain.  
3. **Hessian test?** PSD everywhere.  
4. **Why neural non-convex?** Composed nonlinear layers and symmetry.  
5. **Saddle?** Zero gradient with mixed curvature.  
6. **Does SGD guarantee global deep-net optimum?** No.  
7. **Why works anyway?** Many useful basins plus stochasticity.  
8. **Strong convexity?** Positive curvature lower bound.  
9. **Why scale?** Better conditioning.  
10. **Logistic regression convex?** Yes in standard linear form.

## 17. Practice Tasks
Plot convex/non-convex 2-D losses and trajectories from five starts; compute Hessian eigenvalues at a saddle.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| Landscape explorer | NumPy/Matplotlib | Optimization visualization |
| Seed report | PyTorch, CIFAR-10 | Empirical robustness |
| Convex baseline suite | sklearn, tabular benchmark | Model selection |

## 19. Quick Revision
**Convex:** local equals global. **Test:** Hessian PSD. **Trap:** stationary can be saddle. **One-liner:** deep learning works without global-optimality guarantees.

## 20. Final Cheat Sheet
| Item | Convex | Non-convex |
|---|---|---|
| Landscape | bowl-like | valleys/saddles |
| Guarantee | local equals global | none generally |
| Examples | Ridge, logistic | neural networks, GANs |

# Second-order Optimization

## 1. Overview
Second-order methods use Hessian curvature to scale updates. Newton-like methods converge quickly near smooth optima but full curvature is too expensive for large deep networks.

## 2. Intuition
Gradient says downhill; curvature says whether each direction is narrow or wide.

## 3. Prerequisites
Hessians, Taylor expansion, positive definiteness, eigenvalues, and linear-system solving.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Hessian | Second derivative matrix; eigenvalues are local curvatures. |
| Newton step | Curvature-scaled descent; derive from Taylor approximation. |
| Damping | Add diagonal curvature; why Levenberg-Marquardt? |
| HVP | Compute \(Hv\) without building \(H\); why scalable? |

## 5. Algorithm / Working Process
Compute gradient and curvature approximation; solve for step; use damping/line search or trust region; accept safe steps; repeat to tolerance.

## 6. Mathematical Foundation
\[
f(\theta+\Delta)\approx f(\theta)+g^\top\Delta+\tfrac12\Delta^\top H\Delta,
\qquad \Delta=-H^{-1}g.
\]
For non-convex curvature use \(H+\mu I\) or a trust region to avoid unstable ascent directions.

## 7. Practical Implementation
~~~python
import numpy as np
def newton_quadratic(A, b, x):
    g = A @ x - b
    return x - np.linalg.solve(A, g)
A = np.array([[4., 1.], [1., 3.]])
x = newton_quadratic(A, np.array([1., 2.]), np.zeros(2))
assert np.allclose(A @ x, [1., 2.])
~~~

## 8. Code Explanation
For a positive-definite quadratic, Newton reaches the exact optimum in one step. Linear solve is safer than computing a matrix inverse.

## 9. Training / Evaluation
Use for smooth low/medium dimensions or final refinement. Measure line-search acceptance, gradient norm, conditioning, and wall-clock time.

## 10. Complexity and Cost
Dense Hessian storage is \(O(p^2)\), solve is \(O(p^3)\). HVP methods save storage but need iterative solves.

## 11. Common Use Cases
Classical estimation, logistic regression, least squares, small physics models, and second-order research.

## 12. Common Mistakes
Explicit inverses, assuming indefinite Hessian is safe, omitting damping, and comparing iterations instead of elapsed compute.

## 13. Edge Cases / Limitations
Near-singular Hessians create huge steps; mini-batch curvature is noisy; memory prohibits large neural nets.

## 14. Variations
Newton, Gauss-Newton, Levenberg-Marquardt, trust-region Newton, conjugate-gradient Newton, and K-FAC. Newton/Gauss-Newton are key interviews.

## 15. Related Topics
L-BFGS approximates inverse curvature; natural gradient uses Fisher geometry; convexity determines stronger guarantees.

## 16. Interview Questions
1. **Hessian?** Second partial derivative matrix.  
2. **Newton update?** \(-H^{-1}g\).  
3. **Why fast near optimum?** Quadratic local convergence under assumptions.  
4. **Why not deep nets?** Memory/solve cost.  
5. **Damping?** Stabilize/invert curvature.  
6. **Gauss-Newton?** PSD least-squares curvature approximation.  
7. **Why solve not inverse?** More stable/efficient.  
8. **Can it ascend?** Yes with indefinite Hessian.  
9. **HVP?** Hessian times vector without storage.  
10. **Conditioning effect?** Convergence and numerical stability.

## 17. Practice Tasks
Implement damped Newton logistic regression and compare iterations/time to gradient descent on well- and ill-conditioned data.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| Newton logistic solver | NumPy | Numerical optimization |
| Curvature diagnostic | PyTorch | HVP/spectrum skills |
| Least-squares fitter | SciPy | Applied optimization |

## 19. Quick Revision
**Formula:** \(\Delta=-H^{-1}g\). **Use:** smooth small problems. **Trap:** inverse/indefinite H. **One-liner:** curvature preconditions gradient descent.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | gradient and curvature to second-order step |
| Cost | \(O(p^2)\) memory, \(O(p^3)\) dense solve |
| Pros/cons | few iterations / expensive, unstable curvature |
| Best use | smooth moderate-size tasks |

# Natural Gradient

## 1. Overview
Natural gradient changes parameters according to how much the model probability distribution changes, rather than raw coordinate distance. It is used in probabilistic models, variational inference, and policy optimization.

## 2. Intuition
Equal parameter movements need not produce equal prediction changes. Natural gradient takes equally meaningful moves in distribution space.

## 3. Prerequisites
Probability, log-likelihood, KL divergence, gradients, matrices, and Fisher information.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Fisher matrix | Local distribution sensitivity; state its expectation. |
| Invariance | Similar behavior after smooth parameter reparameterization. |
| KL trust region | Limit output-distribution change; connection to TRPO. |

## 5. Algorithm / Working Process
Compute ordinary gradient; estimate/approximate Fisher; solve \(Fv=g\); use \(-\eta v\); add damping because Fisher may be singular/noisy.

## 6. Mathematical Foundation
\[
F(\theta)=\mathbb E_{x,y\sim p_\theta}
[\nabla_\theta\log p_\theta(y|x)\nabla_\theta\log p_\theta(y|x)^\top],
\quad \tilde\nabla\mathcal L=F^{-1}\nabla\mathcal L.
\]
The update \(\theta\leftarrow\theta-\eta\tilde\nabla\mathcal L\) follows from minimizing first-order loss change under a small local KL constraint.

## 7. Practical Implementation
~~~python
loss = torch.nn.functional.cross_entropy(model(x), y)
grads = torch.autograd.grad(loss, model.parameters())
with torch.no_grad():
    for p, g in zip(model.parameters(), grads):
        fisher_diag = g.square() + 1e-6  # pedagogical diagonal estimate
        p.addcdiv_(g, fisher_diag, value=-1e-3)
~~~

## 8. Code Explanation
The diagonal estimate scales each coordinate by local sensitivity. Production natural-gradient methods use many samples, damping, and structured solvers; a one-batch squared gradient is noisy.

## 9. Training / Evaluation
Compare against Adam at equal compute budget. Track objective, validation metric, and KL change. In RL, constrain KL to control policy/data drift.

## 10. Complexity and Cost
Dense Fisher costs \(O(p^2)\) memory and \(O(p^3)\) inversion. Diagonal, block, Kronecker, and conjugate-gradient approximations make it practical.

## 11. Common Use Cases
Variational Bayes, exponential-family models, RL policy updates, and K-FAC deep-learning research.

## 12. Common Mistakes
Calling Fisher the Hessian, inverting dense Fisher, failing to mention empirical approximations, and omitting damping.

## 13. Edge Cases / Limitations
Redundant parameters make Fisher singular; estimates are noisy; approximation overhead can exceed gains in ordinary supervised deep learning.

## 14. Variations
Exact/empirical/diagonal Fisher, K-FAC, and trust-region policy optimization. Fisher definition is research-interview depth; TRPO/K-FAC are useful extensions.

## 15. Related Topics
Newton uses loss Hessian; natural gradient uses distribution geometry. KL divergence supplies the local metric.

## 16. Interview Questions
1. **Natural gradient?** Gradient preconditioned by inverse Fisher.  
2. **Why Fisher?** Local change in predicted distribution.  
3. **Benefit?** Reparameterization invariance.  
4. **Why expensive?** Fisher is \(p\) by \(p\).  
5. **Fisher vs Hessian?** Distribution metric versus loss curvature.  
6. **Damping?** Add lambda I for stable solve.  
7. **Empirical Fisher?** Gradient outer-product approximation.  
8. **Where used?** VI and RL.  
9. **KL relation?** Fisher is local quadratic KL form.  
10. **Why not everywhere?** Cost/noise.

## 17. Practice Tasks
Compute a small logistic-regression Fisher explicitly and compare ordinary/natural updates after rescaling parameters.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| Fisher visualizer | NumPy/sklearn | Information geometry |
| Variational Gaussian | PyTorch | Probabilistic optimization |
| KL policy demo | Gymnasium/PyTorch | RL optimization depth |

## 19. Quick Revision
**Formula:** \(F^{-1}\nabla\mathcal L\). **Use:** distributional models. **Trap:** dense inverse. **One-liner:** steepest descent in probability space.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | gradient plus Fisher to distribution-aware update |
| Hyperparameters | LR, damping, Fisher approximation |
| Pros/cons | invariant / costly and noisy |
| Best use | VI, RL, research |

# L-BFGS

## 1. Overview
Limited-memory BFGS is a quasi-Newton optimizer that approximates inverse Hessian information from a short history of parameter/gradient changes. It is strong for smooth full-batch objectives.

## 2. Intuition
It remembers a few observations of how gradients changed after movement, rather than storing a full curvature matrix.

## 3. Prerequisites
Gradients, Hessians, line search, dot products, and full versus mini-batch optimization.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Secant pairs | \(s_k=\theta_{k+1}-\theta_k,\;y_k=g_{k+1}-g_k\). |
| Limited memory | Keep last \(m\) pairs; why this avoids dense Hessian storage. |
| Closure | PyTorch reevaluates loss/gradient for line search. |

## 5. Algorithm / Working Process
Evaluate deterministic full loss/gradient; save recent secant pairs; use two-loop recursion for direction; line-search; update history. Avoid stochastic mini-batch closures.

## 6. Mathematical Foundation
BFGS inverse update:
\[
B_{k+1}=(I-\rho sy^\top)B_k(I-\rho ys^\top)+\rho ss^\top,\qquad
\rho=(y^\top s)^{-1}.
\]
It satisfies \(B_{k+1}y=s\). L-BFGS uses the last \(m\) pairs implicitly; \(y^\top s>0\) is supported by line search.

## 7. Practical Implementation
~~~python
optimizer = torch.optim.LBFGS(model.parameters(), lr=1.0, max_iter=20,
    history_size=10, line_search_fn="strong_wolfe")
def closure():
    optimizer.zero_grad()
    loss = torch.nn.functional.mse_loss(model(X_train), y_train)
    loss.backward()
    return loss
for _ in range(10):
    loss = optimizer.step(closure)
~~~

## 8. Code Explanation
The closure recomputes loss/gradients from the same full data because L-BFGS tests candidate steps repeatedly. History size controls memory versus curvature richness.

## 9. Training / Evaluation
Use stable full-batch objectives. Compare final validation loss and wall-clock time with Adam/SGD. It can refine a region found by Adam in small fitting/PINN tasks.

## 10. Complexity and Cost
Memory is \(O(mp)\), not \(O(p^2)\). One outer step can require several full forward/backward passes, so it is unsuitable for huge datasets.

## 11. Common Use Cases
Logistic regression, small full-batch neural nets, PINNs, style transfer, and scientific curve fitting.

## 12. Common Mistakes
Random mini-batches in closure, dropout/augmentation during line search, missing zero_grad, and equating one step with one model evaluation.

## 13. Edge Cases / Limitations
Noisy gradients violate secant assumptions; huge data makes repeated evaluations costly; non-smooth objectives weaken line-search reliability.

## 14. Variations
BFGS, L-BFGS, L-BFGS-B bounds, stochastic quasi-Newton, and Adam-to-L-BFGS hybrid. L-BFGS basics are optimization-interview material.

## 15. Related Topics
It approximates Newton curvature without a Hessian. Line search chooses step size; smooth convex tasks fit its assumptions best.

## 16. Interview Questions
1. **What does it approximate?** Inverse Hessian.  
2. **Why limited memory?** Avoid \(O(p^2)\) storage.  
3. **s and y?** Parameter and gradient differences.  
4. **Why full batch?** Consistent curvature and line search.  
5. **Why closure?** Repeated evaluation.  
6. **Memory?** \(O(mp)\).  
7. **BFGS vs L-BFGS?** Full matrix versus short history.  
8. **Why line search?** Safe useful step length.  
9. **Billion-parameter LLMs?** Generally impractical.  
10. **After Adam?** Smooth local refinement.

## 17. Practice Tasks
Fit a sine curve using Adam, L-BFGS, and Adam then L-BFGS; count forward/backward calls and time.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| PINN study | PyTorch, PDE data | Scientific ML comparison |
| Logistic solver | NumPy/PyTorch | Quasi-Newton knowledge |
| Curve-fit benchmark | PyTorch | Full-batch diagnostics |

## 19. Quick Revision
**Data:** \(s_k,y_k\). **Cost:** \(O(mp)\), repeated full passes. **Trap:** stochastic closure. **One-liner:** Newton-like direction from short history.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | full gradients/history to quasi-Newton step |
| Hyperparameters | history size, line search, max iterations |
| Pros/cons | curvature aware / bad for noisy huge data |
| Best use | smooth deterministic moderate tasks |

# Sharpness-Aware Minimization

## 1. Overview
SAM minimizes loss robustly in a neighborhood of weights rather than at one point. It can improve deep-model generalization, notably in vision experiments.

## 2. Intuition
Two valleys can have equal floor loss; a wide valley remains good after small weight perturbations, while a narrow one does not.

## 3. Prerequisites
Gradients, norms, regularization, loss landscapes, adversarial perturbations, and PyTorch loops.

## 4. Core Concepts
| Concept | Meaning, example, interview angle |
|---|---|
| Sharpness | Worst local loss increase; why linked imperfectly to generalization. |
| Inner maximum | Find harmful nearby perturbation; what does rho control? |
| Two passes | Find perturbation then gradient there; why slower? |

## 5. Algorithm / Working Process
Compute gradient at weights; perturb along normalized gradient by radius rho; compute gradient at perturbed weights; restore original weights; update original weights using the second gradient.

## 6. Mathematical Foundation
\[
\min_\theta\max_{\|\epsilon\|_2\le\rho}\mathcal L(\theta+\epsilon).
\]
First-order inner solution:
\[
\epsilon^*\approx\rho\frac{\nabla\mathcal L(\theta)}
{\|\nabla\mathcal L(\theta)\|_2}.
\]
Update using \(\nabla\mathcal L(\theta+\epsilon^*)\). Large rho makes training overly conservative.

## 7. Practical Implementation
~~~python
optimizer.zero_grad(); criterion(model(x), y).backward()
norm = torch.norm(torch.stack([p.grad.norm() for p in model.parameters() if p.grad is not None]))
saved = []
with torch.no_grad():
    for p in model.parameters():
        e = 0 if p.grad is None else 0.05 * p.grad / (norm + 1e-12)
        saved.append(e); p.add_(e)
optimizer.zero_grad(); criterion(model(x), y).backward()
with torch.no_grad():
    for p, e in zip(model.parameters(), saved): p.sub_(e)
optimizer.step()
~~~

## 8. Code Explanation
First pass finds locally harmful direction; second pass supplies a robust gradient. This educational form needs parameter-group, AMP, distributed, and skipped-gradient handling in production.

## 9. Training / Evaluation
Compare to a tuned baseline at equal epochs and equal wall-clock budgets. Evaluate accuracy/F1, calibration, robustness, and GPU hours; tune rho, LR, decay, and schedule together.

## 10. Complexity and Cost
About two forward/backward passes per batch; nearly double training time. Inference is unchanged.

## 11. Common Use Cases
Image classification, robust transfer learning, and research benchmarks with a serious generalization gap.

## 12. Common Mistakes
Not restoring weights, measuring parameterization-dependent flatness as absolute truth, expecting guaranteed gains, and comparing to an untuned baseline.

## 13. Edge Cases / Limitations
Flatness is not fully reparameterization-invariant. SAM may lose when compute is limited, labels are noisy, or rho is wrong.

## 14. Variations
ASAM adapts perturbation to parameter scale; GSAM changes surrogate; Fisher-SAM adds curvature. SAM/ASAM are good research-project extensions.

## 15. Related Topics
SAM is local robustness regularization, like adversarial training in parameter rather than input space. It costs more than weight decay or early stopping.

## 16. Interview Questions
1. **SAM objective?** Lowest worst-case nearby parameter loss.  
2. **rho?** Perturbation radius.  
3. **Why two passes?** Find perturbation, then differentiate there.  
4. **Cost?** Roughly double train cost, same inference.  
5. **Why generalize?** Prefers locally robust solutions.  
6. **Flatness invariant?** Not fully.  
7. **Versus adversarial training?** Weights versus inputs.  
8. **Huge rho?** Over-conservative/unstable.  
9. **Replace augmentation?** No.  
10. **Variant?** ASAM.

## 17. Practice Tasks
Run ResNet on CIFAR-10 baseline/SAM at equal epochs and equal GPU budget; compare accuracy, loss, rho, and cost.

## 18. Project Ideas
| Project | Stack/data | Resume value |
|---|---|---|
| SAM vision benchmark | PyTorch, CIFAR-10/100 | Controlled research ablation |
| Flatness experiment | PyTorch/Hessian tools | Theory-practice link |
| Transfer study | timm, Flowers-102 | Compute-quality trade-off |

## 19. Quick Revision
**Objective:** \(\min_\theta\max_{\|\epsilon\|\le\rho}\mathcal L(\theta+\epsilon)\). **Trap:** restore bug. **One-liner:** SAM learns weights whose neighbors also have low loss.

## 20. Final Cheat Sheet
| Item | Summary |
|---|---|
| Input/output | batch/weights to neighborhood-robust update |
| Hyperparameters | rho, LR, decay, schedule |
| Pros/cons | stronger generalization possible / about 2x training |
| Best use | well-budgeted vision/research |
