# Cooperative Game Theory for SDE Placements

Cooperative game theory studies what groups can achieve together and how the resulting value should be divided. Each chapter below follows the same interview-oriented path: model the game, calculate the solution concept, connect it to computing systems, and identify the assumptions that make the answer valid.

---

# Coalitions

## 1. Overview

### Definition

A **coalition** is any subset of players that coordinates its actions. If the player set is `N = {1,2,...,n}`, a coalition is `S subseteq N`; the empty coalition is `emptyset`, a one-player coalition is a singleton, and `N` is the **grand coalition**. A **coalition structure** or partition divides all players into disjoint coalitions.

### Why it matters

Coalitions capture the central cooperative question: can some participants obtain more by acting together than separately? They let us reason about team formation, resource pooling, side payments, alliances, and whether a proposed division will survive group deviations.

### Where it is used in real systems

- cloud tenants pool reserved capacity;
- distributed nodes share storage, bandwidth, or computation;
- federated-learning clients contribute datasets and compute;
- logistics providers combine routes;
- services jointly purchase infrastructure or negotiate an SLA.

### Why interviewers ask about it

Coalition questions test set modeling, combinatorics (`2^n` possible coalitions), value-versus-allocation reasoning, and the distinction between unilateral stability in Nash equilibrium and group stability in cooperative games.

## 2. Core Idea

### Intuition and analogy

Three developers can bid separately for projects or form teams. A mobile developer and backend developer may together complete work neither can deliver alone. Coalition theory records the value of every possible team without first deciding how that value is shared.

### Small example

Let `N={A,B,C}`. Alone, A, B, and C create values `2, 2, 1`. Pair values are `v(AB)=7`, `v(AC)=4`, `v(BC)=5`; together they create `v(ABC)=9`.

### Step-by-step

1. Enumerate `emptyset, A, B, C, AB, AC, BC, ABC`.
2. Assign feasible coalition values.
3. Compare synergy: `v(AB)-v(A)-v(B)=3`.
4. Choose whether the grand coalition or a partition such as `{AB},{C}` creates more total value.
5. Only then divide that value and test whether a subgroup wants to leave.

## 3. Important Subtopics

### 3.1 Grand and proper coalitions

`N` contains everyone; any nonempty `S != N` is proper. The grand coalition is attractive when cooperation has increasing returns, but it is not automatically stable. Interview angle: distinguish **efficient formation** from **stable payoff division**.

### 3.2 Coalition structures

A partition such as `{{A,B},{C}}` says A and B cooperate while C acts alone. Coalitional-form games often assume the grand coalition; coalition-formation games compare partitions. Interview angle: coalitions in a partition must be disjoint and cover `N`.

### 3.3 Synergy and superadditivity

Disjoint coalitions have synergy when `v(S union T) > v(S)+v(T)`. A game is superadditive if `v(S union T) >= v(S)+v(T)` for every disjoint `S,T`; merging then never destroys value. This supports, but does not prove, a stable grand-coalition allocation.

### 3.4 Transferable utility

In a **TU game**, coalition value is a single divisible number, so transfers can compensate members. In a non-transferable-utility game, feasible utility combinations must be represented directly. Interview angle: money-like value does not always mean utility is freely transferable.

### 3.5 Blocking coalitions

A coalition blocks allocation `x` if it can give each member more using its own value. With TU, `S` blocks when `sum(i in S)x_i < v(S)` (a strict-improvement allocation can then be constructed). Blocking is the basis of the core.

## 4. Real-World Example

Suppose three backend teams can buy capacity separately for savings `2,2,1`, or share deployments. AB saves `7`, AC saves `4`, BC saves `5`, and ABC saves `9`. The platform should first compare partitions: grand coalition `9` beats `AB + C = 8`, `AC + B = 6`, and `BC + A = 7`. A proposed split `(2,2,5)` is efficient but AB receives only `4`, below the `7` it can make alone, so AB will leave.

## 5. Diagrams / Mental Models

```text
Players N={A,B,C}
   |-- singletons: A  B  C
   |-- pairs:      AB AC BC
   `-- grand:      ABC

formation question: which groups form?
allocation question: how is formed value divided?
stability question: can any subgroup improve by leaving?
```

| Object | Meaning |
|---|---|
| `S` | one coalition |
| `P={S1,...,Sk}` | coalition structure/partition |
| `v(S)` | value S guarantees itself |
| `x_i` | payoff allocated to player i |

## 6. Common Interview Questions

### Q1. What is a coalition?
**Answer:** A subset of players that coordinates and can act as a unit. **Expected:** subset, joint action, possibly transfers. **Mistake:** requiring a majority or at least two players.

### Q2. How many coalitions can `n` players form?
**Answer:** `2^n`, including `emptyset` and `N`; `2^n-1` nonempty. **Expected:** subset counting. **Mistake:** answering `n!`.

### Q3. What is the grand coalition?
**Answer:** `N`, the coalition of all players. **Expected:** it need not be stable. **Mistake:** assuming it always forms.

### Q4. Coalition versus coalition structure?
**Answer:** A coalition is one subset; a structure is a partition of every player into disjoint coalitions. **Expected:** disjoint cover. **Mistake:** allowing overlapping blocks in an ordinary partition.

### Q5. What is superadditivity?
**Answer:** `v(S union T)>=v(S)+v(T)` for disjoint coalitions. **Expected:** merging does not reduce value. **Mistake:** forgetting disjointness.

### Q6. Does superadditivity guarantee stability?
**Answer:** No. It makes the grand coalition value-efficient, but a poor division may still be blocked. **Expected:** formation versus allocation. **Mistake:** equating maximum value with the core.

### Q7. What is a blocking coalition?
**Answer:** A group able to make all its members better off using its own resources. **Expected:** compare `x(S)` with `v(S)`. **Mistake:** comparing only total grand-coalition value.

### Q8. What is a singleton coalition useful for?
**Answer:** It represents a player's outside option and yields individual-rationality constraints `x_i>=v({i})`. **Expected:** credible exit payoff. **Mistake:** setting it to zero without justification.

### Q9. What does transferable utility change?
**Answer:** It permits coalition value to be redistributed through side payments, so a scalar `v(S)` suffices. **Expected:** contrast NTU feasible sets. **Mistake:** assuming all preferences are quasilinear.

### Q10. Why is coalition enumeration hard?
**Answer:** There are exponentially many subsets, so explicit evaluation becomes infeasible. **Expected:** `2^n`; exploit structure/oracles. **Mistake:** calling it polynomial because each subset is easy to score.

## 7. Deep-Dive Questions

### Q1. Can coalitions overlap?
In standard coalition structures they cannot; the structure is a partition. Overlapping-coalition models exist when players can split resources across teams, but they require a richer payoff model.

### Q2. Why can the grand coalition fail to form in a non-superadditive game?
Merging can destroy value through coordination overhead or incompatibility. A partition may create more total value, so assuming `N` would mis-model the system.

### Q3. How would you compute the best coalition structure?
Maximize `sum(S in P)v(S)` over partitions `P`. The number of partitions is the Bell number, so practical solvers use dynamic programming, integer programming, or domain-specific structure.

### Q4. Does `x(S)<v(S)` always mean every member can be strictly better?
Under TU with divisible value, yes: the positive surplus can be distributed so all members gain. Under NTU, total-value comparison is insufficient.

### Q5. How are coalitions different from coordinated deviations in Nash equilibrium?
Nash checks one player at a time. Coalitional concepts such as strong equilibrium or the core allow groups to deviate jointly.

## 8. Comparison Tables

| Feature | Individual action | Coalition action |
|---|---|---|
| Deviators | one player | any subset |
| Coordination | none required | binding coordination assumed |
| Stability concept | Nash-style | core/strong stability |
| Computational checks | often `n` deviations | up to `2^n` coalitions |

| Feature | TU | NTU |
|---|---|---|
| Coalition representation | scalar `v(S)` | feasible utility set |
| Side payments | unrestricted in model | limited/absent |
| Main arithmetic | sums of payoffs | vector feasibility |

## 9. Common Mistakes

- Confusing coalition value with each member's payoff.
- Assuming coalitions are always pairs.
- Assuming the most productive coalition structure is stable.
- Ignoring outside options and coordination costs.
- Using superadditivity where coalitions overlap.

## 10. Edge Cases / Special Cases

- `v(emptyset)=0` is the standard normalization.
- Negative singleton values may represent unavoidable costs; participation assumptions matter.
- Tied partitions can create a coalition-selection problem.
- Externalities between coalitions require partition-function games, because `v(S)` alone is insufficient.
- Overlapping or dynamic membership needs a model beyond static partitions.

## 11. How to Explain in Interview

> A coalition is any subset of players that can coordinate. I use `v(S)` to record what that group can guarantee itself, compare partitions to study which groups should form, and compare allocated payoff `x(S)` with `v(S)` to see whether the coalition would block the proposed outcome.

## 12. Quick Revision Notes

- `2^n` coalitions; grand coalition is `N`.
- Structure = partition, not one coalition.
- Superadditive means disjoint mergers do not lose value.
- TU permits side payments; blocking compares `x(S)` and `v(S)`.
- Trap: efficient grand coalition does not imply a stable allocation.

## 13. Practice Tasks

1. Enumerate all coalitions for four players.
2. Test the example game for superadditivity.
3. List all five partitions of three players and score them.
4. Find which coalitions block `(2,2,5)`.
5. Implement subset enumeration with bitmasks in C++ and find maximum synergy.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | coordinating subset of players |
| Why it matters | models joint production and group deviation |
| Most asked | `2^n`, grand coalition, superadditivity, blocking |
| Key comparison | coalition vs partition; TU vs NTU |
| One line | “A coalition is a subset that acts jointly and can threaten to leave if its allocated payoff is below its standalone value.” |

---

# Characteristic Functions

## 1. Overview

### Definition

A **characteristic function** maps every coalition to the value it can guarantee: `v:2^N -> R`, normally with `v(emptyset)=0`. The pair `(N,v)` is a transferable-utility coalitional game.

### Why it matters, uses, and interview relevance

It compresses operational detail into the quantity needed for core and Shapley calculations. It appears in shared-cost allocation, data valuation, network reliability, joint procurement, and resource pooling. Interviewers use it to test whether candidates can build the right model, distinguish total value from marginal contribution, and recognize exponential input size and modeling assumptions.

## 2. Core Idea

### Intuition and analogy

Think of `v` as an API: submit a set of participants and receive the maximum surplus that set can create without outsiders.

```text
v({A})=2, v({B})=2, v({C})=1
v({A,B})=7, v({A,C})=4, v({B,C})=5
v({A,B,C})=9
```

For A joining BC, the marginal contribution is `v(ABC)-v(BC)=4`; joining B alone gives `v(AB)-v(B)=5`. Contribution depends on context.

### Step-by-step

1. Fix players and what resources they own.
2. Define what a coalition can achieve without outsiders.
3. Choose gross value or net surplus consistently.
4. Evaluate all required subsets or provide a value oracle.
5. Check normalization, monotonicity, superadditivity, and whether externalities invalidate characteristic form.

## 3. Important Subtopics

### 3.1 Normalization and monotonicity

Normalization sets `v(emptyset)=0`. Monotonicity means `S subseteq T => v(S)<=v(T)`; it is plausible when extra members can be ignored, but false when membership adds mandatory cost.

### 3.2 Marginal contribution

Player `i` contributes `v(S union {i})-v(S)` to predecessor coalition `S`. It drives the Shapley value. Interview trap: it is not a single fixed number.

### 3.3 Additive, superadditive, and convex games

Additive games have no synergy. Superadditive games reward disjoint merging. Convex games have increasing marginal contributions: joining a larger coalition is at least as valuable. Convexity is stronger and implies a nonempty core.

### 3.4 Cost games

A cost characteristic `c(S)` records the minimum cost for serving S. Savings can be converted to value, for example `v(S)=sum(i in S)c({i})-c(S)`. Cost-core inequalities reverse if expressed directly in costs.

### 3.5 Characteristic versus partition function

Characteristic form assumes S's value is independent of how outsiders organize. Congestion, market competition, and network externalities can violate this; then value should depend on both S and the partition.

## 4. Real-World Example

For federated learning, `v(S)` could be the revenue or accuracy improvement produced by clients in S minus training cost. Duplicate datasets cause diminishing returns; complementary datasets create synergy. Data Shapley methods average each client's marginal gain across possible arrival orders. The critical modeling issue is ensuring the metric is reproducible and does not credit data leakage or test-set overfitting.

## 5. Diagrams / Mental Models

```text
coalition S --> optimizer/simulator --> value v(S)
     ^                                  |
     `------- marginal comparisons -----'
```

| Property | Test | Meaning |
|---|---|---|
| Normalized | `v(emptyset)=0` | zero baseline |
| Monotone | `S subseteq T => v(S)<=v(T)` | members cannot hurt |
| Superadditive | `v(S union T)>=v(S)+v(T)` | disjoint merger helps |
| Convex | marginal contribution rises with coalition size | complementarity |

## 6. Common Interview Questions

### Q1. Define a characteristic function.
**Answer:** `v:2^N->R` assigns each coalition its achievable value. **Expected:** coalition value, not allocation. **Mistake:** mapping players directly to payoffs.

### Q2. Why set `v(emptyset)=0`?
**Answer:** It establishes a no-participant baseline and simplifies formulas. **Expected:** normalization. **Mistake:** claiming it is a theorem rather than convention/model choice.

### Q3. What is marginal contribution?
**Answer:** `v(S union {i})-v(S)`. **Expected:** depends on S. **Mistake:** using `v({i})` only.

### Q4. Is every characteristic function monotone?
**Answer:** No. Mandatory coordination costs can make a larger group less valuable. **Expected:** property, not definition. **Mistake:** assuming members can always be ignored.

### Q5. Value game versus cost game?
**Answer:** A value game maximizes surplus; a cost game allocates joint cost. Their stability inequalities use opposite directions unless cost is converted to savings. **Expected:** distinguish value guarantees from cost ceilings. **Mistake:** applying value-core inequalities unchanged.

### Q6. How large is an explicit characteristic-function table?
**Answer:** `2^n` entries. **Expected:** exponential representation. **Mistake:** `n^2`.

### Q7. What is an additive game?
**Answer:** `v(S)=sum(i in S)v({i})`; there is no interaction surplus. **Expected:** Shapley then equals singleton values. **Mistake:** confusing with superadditive.

### Q8. What does convexity mean?
**Answer:** Marginal contributions do not decrease as the receiving coalition grows. **Expected:** increasing returns/complementarity and nonempty core. **Mistake:** geometric convexity of a plotted curve only.

### Q9. When is characteristic form inadequate?
**Answer:** When S's payoff depends on outsiders' partition or actions. **Expected:** externalities and partition-function form. **Mistake:** silently assigning one value anyway.

### Q10. What is a value oracle?
**Answer:** An algorithm returning `v(S)` on demand instead of storing every entry. **Expected:** it saves storage, not necessarily exponential query complexity. **Mistake:** assuming oracle calls are free.

## 7. Deep-Dive Questions

### Q1. State convexity in marginal form.
For `S subseteq T subseteq N\{i}`, `v(S union {i})-v(S) <= v(T union {i})-v(T)`.

### Q2. How do Möbius/unanimity representations help?
They decompose value into interaction dividends associated with subsets, making higher-order synergy explicit and supporting axiomatic analysis.

### Q3. Can two operational models produce the same cooperative game?
Yes. Characteristic form intentionally discards mechanism details if every coalition guarantee is identical; solution concepts based only on v cannot distinguish them.

### Q4. How do you estimate v when evaluation is expensive?
Use domain structure, memoization, surrogate models, or sampled coalitions, then report approximation error because Shapley/core conclusions may be sensitive to noisy values.

### Q5. Why does convexity imply superadditivity in normalized games?
Increasing marginal returns let the members of T added after S contribute at least what they contribute starting from empty, yielding `v(S union T)>=v(S)+v(T)` for disjoint sets.

## 8. Comparison Tables

| Feature | Characteristic function | Payoff allocation |
|---|---|---|
| Symbol | `v(S)` | `x_i` |
| Describes | production capability | division among individuals |
| Defined for | every coalition | players in outcome |

| Property | Strength | Main implication |
|---|---|---|
| Additive | no interaction | marginal contributions fixed |
| Superadditive | merger not harmful | grand coalition value-efficient |
| Convex | increasing marginal returns | core nonempty; Shapley in core |

## 9. Common Mistakes

- Treating `v(S)` as the amount each member gets.
- Mixing gross revenue and net surplus across coalitions.
- Assuming monotonicity or superadditivity without checking.
- Forgetting outsiders and externalities.
- Computing only pair values and inventing larger values by addition.

## 10. Edge Cases / Special Cases

- Empty coalition may have a nonzero baseline in an unnormalized formulation.
- Negative values require careful participation interpretation.
- Noisy/estimated values can make exact core inequalities misleading.
- A player with zero marginal contribution everywhere is a null player.
- Symmetric players can still have different singleton labels but must be equivalent under v for symmetry axioms.

## 11. How to Explain in Interview

> A characteristic function `v(S)` tells us the total transferable value coalition S can guarantee without outsiders. It is the input to cooperative solution concepts: marginal differences feed the Shapley value, while comparisons between allocated sums and `v(S)` determine whether coalitions block an allocation.

## 12. Quick Revision Notes

- Game is `(N,v)`; table size `2^n`.
- Marginal contribution: `v(S+i)-v(S)`.
- Additive < superadditive < convex in structural strength (with qualifications).
- Cost models need correct inequality direction.
- Trap: externalities may require partition-function form.

## 13. Practice Tasks

1. Build v for three services sharing a fixed deployment cost.
2. Compute every marginal contribution in the running example.
3. Check monotonicity, superadditivity, and convexity by enumeration.
4. Convert a shared-cost table into a savings game.
5. Implement a bitmask value oracle with memoization.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | set function assigning coalition capability |
| Why | separates value creation from division |
| Asked | marginal contribution, properties, exponential size |
| Compare | characteristic value vs allocation; value vs cost game |
| One line | “`v(S)` is what S can guarantee; it is not what each member receives.” |

---

# Core

## 1. Overview

### Definition

The **core** is the set of efficient allocations no coalition can block. For a TU value game, `x` is in the core when:

1. **Efficiency:** `sum(i in N)x_i=v(N)`.
2. **Coalitional rationality:** `sum(i in S)x_i>=v(S)` for every `S subseteq N`.

### Why it matters, uses, and interviews

The core gives a strong notion of agreement stability: no subgroup has enough standalone value to offer all members a better deal. It is used for shared infrastructure cost, supply chains, energy markets, logistics, and collaborative compute. Interviews test inequality construction, blocking logic, feasibility, and the fact that the core may be empty or contain many allocations.

## 2. Core Idea

For the running game, an allocation `(x_A,x_B,x_C)` must satisfy:

```text
x_A+x_B+x_C = 9
x_A>=2, x_B>=2, x_C>=1
x_A+x_B>=7, x_A+x_C>=4, x_B+x_C>=5
```

Take `(4,3,2)`: it sums to 9; pair sums are 7,6,5, so it is in the core. Take `(2,2,5)`: AB gets 4 < 7 and blocks. The core is therefore a feasible region cut out by a hyperplane and coalition half-spaces.

## 3. Important Subtopics

### 3.1 Imputations

An imputation is efficient and individually rational. The core adds every group-rationality constraint. Interview angle: every core allocation is an imputation, not vice versa.

### 3.2 Blocking

S blocks x if its current total `x(S)` is below `v(S)` under TU. The deficit is the surplus the coalition can redistribute to improve all members.

### 3.3 Empty and non-unique cores

Constraints can conflict, producing an empty core; loose constraints create a continuum. The core is a set, not a rule selecting one point.

### 3.4 Balancedness

The Bondareva-Shapley theorem says a finite TU game has a nonempty core exactly when it is balanced. Balanced weights cover each player once; no balanced collection of coalition claims may exceed `v(N)`.

### 3.5 Convex games

Convex games have increasing marginal contributions, possess a nonempty core, and every marginal vector from a player ordering lies in the core. Their Shapley value, an average of marginal vectors, also lies in the core.

### 3.6 Least core

When the core is empty, the least core minimizes the largest coalition dissatisfaction by relaxing constraints to `x(S)>=v(S)-epsilon` and minimizing `epsilon`.

## 4. Real-World Example

Three data centers save 9 units by a joint peering link. Any pair can save 7,4,5, and singletons save 2,2,1. Charging them the negative of allocation `(4,3,2)` is stable because every subgroup receives at least its alternative saving. In practice the constraints can be solved as a linear program; a violated constraint identifies the exact customer group likely to defect.

## 5. Diagrams / Mental Models

```text
efficient plane: x_A+x_B+x_C=9
          intersect
all coalition half-spaces: x(S)>=v(S)
          equals
             CORE
```

| Check | Question |
|---|---|
| Efficiency | Was all grand-coalition value distributed? |
| Individual rationality | Would one player leave? |
| Coalitional rationality | Would any group leave? |

## 6. Common Interview Questions

### Q1. Define the core.
**Answer:** Efficient allocations satisfying `x(S)>=v(S)` for all S. **Expected:** no blocking coalition. **Mistake:** giving only individual rationality.

### Q2. What is an imputation?
**Answer:** An efficient, individually rational allocation. **Expected:** core adds coalition constraints. **Mistake:** treating it as a synonym for core.

### Q3. How do you test an allocation?
**Answer:** Verify the grand total, then every coalition inequality. **Expected:** systematic subset enumeration/optimization. **Mistake:** checking only pairs or singletons.

### Q4. Can the core be empty?
**Answer:** Yes, when coalition claims cannot all fit inside `v(N)`. **Expected:** stability may not exist. **Mistake:** invoking finite-game equilibrium existence.

### Q5. Can the core contain multiple allocations?
**Answer:** Yes, often a continuum. **Expected:** it is a feasible set. **Mistake:** asking for “the core value” as one vector.

### Q6. Does a core allocation have to be fair?
**Answer:** No. It is stable, not necessarily symmetric or equitable. **Expected:** distinguish properties. **Mistake:** calling any stable division fair.

### Q7. Is the Shapley value always in the core?
**Answer:** No; it is for convex games, but not general games. **Expected:** condition. **Mistake:** combining two solution concepts universally.

### Q8. Why is efficiency equality rather than inequality?
**Answer:** A full allocation distributes exactly `v(N)`; leftover transferable value could improve someone. **Expected:** feasibility plus no waste. **Mistake:** allowing total greater than available.

### Q9. What changes for cost games?
**Answer:** Allocated cost sums to `c(N)` and a coalition should not pay more than `c(S)`: `x(S)<=c(S)`. **Expected:** reversed inequality. **Mistake:** using value direction.

### Q10. How is core membership computationally difficult?
**Answer:** Up to `2^n` inequalities must be separated. **Expected:** a separation oracle/domain optimization may help. **Mistake:** assuming one LP row per player.

## 7. Deep-Dive Questions

### Q1. Give an empty-core example.
Let `v(N)=1`, every pair value `1`, and singleton values zero. Pair constraints sum to `2(x_A+x_B+x_C)>=3`, but efficiency gives left side 2, a contradiction.

### Q2. State the balancedness intuition.
If weighted coalitions collectively cover every player exactly once, their total justified claims cannot exceed the grand coalition's value; otherwise no allocation can satisfy all claims.

### Q3. Why is the core convex?
It is the intersection of linear equality/half-spaces. Any convex combination of two core allocations remains efficient and satisfies every linear inequality.

### Q4. Core versus strong Nash equilibrium?
Both resist group deviations, but the core uses a coalitional value abstraction and typically TU binding agreements; strong Nash is defined in the underlying strategic game.

### Q5. What does the least-core epsilon measure?
The smallest worst-case shortfall from coalition guarantees. `epsilon=0` means the core is nonempty; larger epsilon quantifies unavoidable instability.

## 8. Comparison Tables

| Concept | Efficiency | Singleton constraints | All coalition constraints | Unique? |
|---|---:|---:|---:|---:|
| Feasible allocation | yes | no | no | no |
| Imputation | yes | yes | no | no |
| Core | yes | yes | yes | no |
| Shapley value | yes | depends on assumptions | not guaranteed | yes |

| Value core | Cost core |
|---|---|
| `x(N)=v(N)` | `x(N)=c(N)` |
| `x(S)>=v(S)` | `x(S)<=c(S)` |
| coalition wants more value | coalition wants lower cost |

## 9. Common Mistakes

- Reversing inequality direction.
- Checking efficiency but not coalition rationality.
- Assuming nonempty, unique, or fair.
- Forgetting singleton and empty-set cases.
- Rounding a boundary allocation so it becomes blocking.

## 10. Edge Cases / Special Cases

- Weak equality means a coalition is indifferent and does not strictly block.
- Strict versus weak blocking conventions must be stated for NTU games.
- Approximate values motivate epsilon-core tests.
- Negative coalition values can make some constraints vacuous.
- Externalities make ordinary core definitions incomplete.

## 11. How to Explain in Interview

> The core is the set of full allocations that no coalition can improve upon. I check `x(N)=v(N)` and `x(S)>=v(S)` for every coalition. If any inequality fails, that S has enough value to leave and compensate all its members; if the inequalities are inconsistent, the core is empty.

## 12. Quick Revision Notes

- Core = efficiency + all coalitional rationality.
- Imputation checks only individuals.
- Empty core means no perfectly stable division.
- Convex game => nonempty core and Shapley in core.
- Cost-game inequality points the other way.

## 13. Practice Tasks

1. Verify `(4,3,2)` and reject `(2,2,5)`.
2. Derive the empty-core contradiction above.
3. Plot a three-player core after eliminating `x_C=9-x_A-x_B`.
4. Formulate least core as an LP.
5. Write a bitmask-based core-membership checker.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | efficient allocations no coalition blocks |
| Why | strongest common TU group-stability test |
| Asked | inequalities, empty core, Shapley relation |
| Compare | imputation vs core; value vs cost core |
| One line | “The core distributes all value while giving every coalition at least what it can make alone.” |

---

# Shapley Value

## 1. Overview

### Definition

The **Shapley value** gives each player their average marginal contribution over all possible orders in which players could join:

`phi_i(v)=sum(S subseteq N\{i}) |S|!(n-|S|-1)!/n! * [v(S union {i})-v(S)]`.

### Why it matters, uses, and interviews

It is a principled unique allocation satisfying efficiency, symmetry, dummy, and additivity. It is used for shared costs, feature attribution, data valuation, revenue sharing, and network cooperation. Interviews test factorial weights, marginal reasoning, axioms, computation, and the difference between fairness and stability.

## 2. Core Idea

### Analogy and worked example

Players arrive to form a team. Credit player i with the extra value created when i arrives, then average over all `n!` arrival orders.

For the running game, A's marginal contributions across predecessor sets are:

| Predecessors S | Marginal `v(S+A)-v(S)` | Weight for n=3 |
|---|---:|---:|
| `emptyset` | 2 | 1/3 |
| `{B}` | 5 | 1/6 |
| `{C}` | 3 | 1/6 |
| `{B,C}` | 4 | 1/3 |

Thus `phi_A=2/3+5/6+3/6+4/3=10/3`. Similarly `phi_B=23/6`, `phi_C=11/6`; the sum is `9`.

### Step-by-step

1. Choose player i.
2. Enumerate coalitions not containing i.
3. Compute each marginal contribution.
4. Weight by the probability that exactly S precedes i in a random order.
5. Sum, repeat, and verify `sum phi_i=v(N)`.

## 3. Important Subtopics

### 3.1 Efficiency
All value is allocated: `sum_i phi_i=v(N)` for normalized games.

### 3.2 Symmetry
Players with identical marginal effects receive equal values, regardless of labels.

### 3.3 Dummy/null player
If `v(S+i)=v(S)+v({i})` for all S, i gets `v({i})`; a zero-contribution null player gets zero.

### 3.4 Additivity
For combined games, `phi(v+w)=phi(v)+phi(w)`. This supports decomposing systems into independent value components.

### 3.5 Permutation and subset formulas
The permutation view is intuitive; the subset formula groups identical predecessor sets. They are mathematically equivalent.

### 3.6 Computational approximation
Exact evaluation is exponential in general. Sample random permutations, record marginal increments, and average. Confidence intervals matter for high-stakes allocations.

## 4. Real-World Example

In application observability, a team may estimate how much each feature improves a fraud model. For each sampled feature ordering, retrain/evaluate as features enter and credit the improvement to the arriving feature. Averaging produces SHAP-style attribution under a chosen background and value definition. Correlated features and conditional-versus-interventional semantics are modeling issues, not mere implementation details.

## 5. Diagrams / Mental Models

```text
random order: C -> A -> B
values:       0 -> 1 -> 4 -> 9
marginals:    C:1   A:3   B:5

repeat all/sample orders -> average each player's marginal
```

| Lens | Question |
|---|---|
| Marginal | What extra value appears when i joins? |
| Probability | How likely is each predecessor set? |
| Axiomatic | Which fairness rules uniquely select the allocation? |

## 6. Common Interview Questions

### Q1. Define the Shapley value.
**Answer:** Average marginal contribution over uniformly random player orders. **Expected:** formula or permutation explanation. **Mistake:** averaging standalone values.

### Q2. Why factorial weights?
**Answer:** `|S|!` orders put S before i and `(n-|S|-1)!` arrange players after i, out of `n!`. **Expected:** predecessor probability. **Mistake:** weighting all subset sizes equally.

### Q3. Which axioms characterize it?
**Answer:** Efficiency, symmetry, dummy/null-player, and additivity. **Expected:** meanings. **Mistake:** including core stability as an axiom.

### Q4. Is it always in the core?
**Answer:** No; yes for convex games. **Expected:** fairness versus stability. **Mistake:** universal claim.

### Q5. What does a dummy player receive?
**Answer:** Its standalone additive contribution; a null player receives zero. **Expected:** distinguish dummy with nonzero singleton. **Mistake:** every dummy gets zero.

### Q6. How expensive is exact computation?
**Answer:** Generally exponential value evaluations; naïve permutations are `n!`, subset formula is `O(n2^n)` for all players. **Expected:** approximation. **Mistake:** calling the factorial formula mandatory.

### Q7. How do you approximate it?
**Answer:** Sample random permutations and average observed marginal contributions. **Expected:** unbiased sampling and error estimates. **Mistake:** sampling coalitions uniformly without correcting weights.

### Q8. Can a player with low standalone value get a high Shapley value?
**Answer:** Yes, if it unlocks complementary coalitions. **Expected:** context-dependent marginal value. **Mistake:** equating fair payoff with `v({i})`.

### Q9. Why does efficiency hold?
**Answer:** In every order, marginal increments telescope from `v(emptyset)` to `v(N)`; averaging preserves the sum. **Expected:** telescoping argument. **Mistake:** citing normalization alone.

### Q10. Shapley value versus Nash equilibrium?
**Answer:** Shapley allocates cooperative surplus from a characteristic game; Nash is a stable strategy profile under unilateral deviation. **Expected:** different objects/assumptions. **Mistake:** calling Shapley an equilibrium.

## 7. Deep-Dive Questions

### Q1. Why is the Shapley value unique under its axioms?
Unanimity games form a basis for set functions. The axioms determine shares on each basis game, and additivity extends the result uniquely to every game.

### Q2. Why does convexity put Shapley in the core?
Every ordering's marginal vector is in the core of a convex game. The core is convex, and Shapley is the average of those vectors.

### Q3. What breaks with correlated model features?
The value assigned to a feature coalition depends on how missing features are integrated out. Conditional and interventional distributions answer different questions, so attribution can change despite the same predictor.

### Q4. What is the weighted Shapley value?
It changes the arrival-order distribution or bargaining weights to model asymmetric entitlement. It sacrifices ordinary symmetry in favor of specified weights.

### Q5. Can Shapley violate individual rationality?
In arbitrary non-superadditive games it can. In superadditive games, standard Shapley allocations are individually rational because marginal contributions are at least standalone value under relevant conditions.

## 8. Comparison Tables

| Feature | Shapley value | Core |
|---|---|---|
| Output | one allocation | set, possibly empty |
| Main idea | average marginal contribution | no blocking coalition |
| Guaranteed efficient | yes | yes by definition |
| Guaranteed stable | no | yes |
| Fairness axioms | central | not selecting |

| Exact method | Cost | Best for |
|---|---:|---|
| all permutations | `O(n!)` evaluations | teaching/small n |
| subset formula | `O(n2^n)` | explicit small games |
| permutation sampling | configurable | large expensive games |

## 9. Common Mistakes

- Giving equal shares instead of equal treatment for equal contributions.
- Forgetting `v(emptyset)` normalization.
- Using the player's own mixing probability analogy from Nash calculations.
- Assuming Shapley is stable or strategy-proof.
- Ignoring evaluation noise and feature dependence.

## 10. Edge Cases / Special Cases

- With one player, `phi_1=v({1})-v(emptyset)`.
- Additive games return singleton values.
- Symmetric players receive equal shares even if their shared contribution is highly complementary.
- Negative marginals can produce negative Shapley values.
- Approximation should preserve or explicitly correct efficiency after sampling.

## 11. How to Explain in Interview

> The Shapley value credits a player by the extra value they add when joining, averaged over every possible arrival order. The factorial term is simply the probability of a predecessor set. It uniquely satisfies efficiency, symmetry, dummy, and additivity, but unlike the core it does not guarantee coalition stability in every game.

## 12. Quick Revision Notes

- Average `v(S+i)-v(S)` over arrival contexts.
- Factorial coefficient = predecessor-set probability.
- Four axioms: efficiency, symmetry, dummy, additivity.
- Exact subset method `O(n2^n)`; sample permutations at scale.
- Trap: Shapley in core only under conditions such as convexity.

## 13. Practice Tasks

1. Enumerate six orders for the three-player example.
2. Recompute values using the subset formula.
3. Prove efficiency by telescoping.
4. Implement exact bitmask Shapley in C++.
5. Add permutation sampling and compare error against exact output.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | average marginal contribution over orders |
| Why | unique axiomatic cooperative allocation |
| Asked | formula weights, axioms, complexity, core relation |
| Compare | one fair point vs stable core set |
| One line | “Shapley is expected marginal contribution under a uniformly random arrival order.” |

---

# Stable Allocations

## 1. Overview

### Definition

A **stable allocation** divides cooperative value or cost so relevant participants have no profitable permitted deviation. “Stable” is not one universal formula: it may mean core stability against coalitions, individual rationality, pairwise stability in matching, or approximate stability when exact constraints are infeasible.

### Why it matters, uses, and interviews

An efficient technical design fails if contributors reject its payment or a subgroup can cheaply leave. Stable allocations underpin cloud cost sharing, peer-to-peer resource exchange, marketplaces, matching, and distributed collaboration. Interviewers want the candidate to state the deviation model before claiming stability.

## 2. Core Idea

Stability is always relative to three choices:

```text
outcome/allocation x
   + permitted deviators D
   + feasible alternatives for D
   = stability test
```

For the running TU game, `(4,3,2)` is core-stable. `(3,3,3)` is efficient and individually rational, but AB obtains 6 below 7 and can block. Stability is therefore stronger than “everyone gets something” and different from welfare maximization.

## 3. Important Subtopics

### 3.1 Feasibility and efficiency
Feasibility prevents distributing more than exists. Efficiency normally distributes the entire transferable surplus. Stability tests are meaningless if the proposal is not feasible.

### 3.2 Individual rationality
Each player receives at least an outside option. This is participation stability against singleton deviations, not full coalition stability.

### 3.3 Coalitional stability
No permitted group can reallocate its attainable value to improve all members. The core is the main TU version.

### 3.4 Pairwise and matching stability
In matching, no unmatched pair should prefer one another to current partners, and no participant should prefer being unmatched. Transfers and preferences determine the precise definition.

### 3.5 Epsilon stability
An `epsilon`-stable allocation tolerates deviations whose gain is no more than epsilon. It is useful with noisy estimates, rounding, or an empty exact core.

### 3.6 Budget balance and subsidy
Some mechanisms cannot be simultaneously efficient, incentive compatible, stable, and exactly budget balanced. A subsidy can remove blocking but must be treated as real external cost.

## 4. Real-World Example

A distributed storage consortium allocates a monthly saving among providers. Each provider has a standalone cloud price; subsets have alternative peering deals. The operator solves an LP for a core allocation. If none exists, it finds the least-core allocation, reports the worst dissatisfied coalition, and decides whether a small platform subsidy is cheaper than losing that coalition.

## 5. Diagrams / Mental Models

```text
Is x feasible? --no--> reject
      |
     yes
Does every player beat outside option? --no--> individual exit
      |
     yes
Can any allowed group improve? --yes--> blocked
      |
      no
    stable under stated deviation model
```

## 6. Common Interview Questions

### Q1. What makes an allocation stable?
**Answer:** No allowed deviator can reach an outcome all its members prefer. **Expected:** specify deviation model. **Mistake:** defining stability as unchanged over time.

### Q2. Stable versus efficient?
**Answer:** Efficient maximizes/distributes value; stable resists deviations. Either can hold without the other. **Expected:** independent properties. **Mistake:** equating them.

### Q3. What is individual rationality?
**Answer:** `x_i` meets player i's outside option. **Expected:** participation constraint. **Mistake:** calling it coalition stability.

### Q4. Can an equal split be unstable?
**Answer:** Yes, if a productive subset receives less than its coalition value. **Expected:** test claims, not aesthetics. **Mistake:** assuming equality implies acceptance.

### Q5. Can a stable allocation be unequal?
**Answer:** Yes. Stability tracks credible alternatives, not equality. **Expected:** fairness distinction. **Mistake:** moral interpretation without model.

### Q6. What is epsilon stability?
**Answer:** No coalition can gain more than a tolerated epsilon; equivalently coalition constraints are relaxed. **Expected:** approximation/noise use. **Mistake:** confusing epsilon with per-player probability.

### Q7. How does matching stability differ from the core?
**Answer:** Matching commonly checks individuals and pairs under preference orderings; TU core checks all coalitions and transferable totals. **Expected:** allowed deviations. **Mistake:** assuming identical constraints.

### Q8. Why can rounding destroy stability?
**Answer:** A binding coalition inequality can become violated after rounding. **Expected:** preserve total and constraints. **Mistake:** rounding components independently.

### Q9. How do you find a blocking coalition at scale?
**Answer:** Solve a separation problem maximizing `v(S)-x(S)` using domain structure. **Expected:** positive maximum identifies blocker. **Mistake:** always enumerate all subsets.

### Q10. Does stable mean strategy-proof?
**Answer:** No. Stability concerns post-allocation deviation; strategy-proofness concerns profitable misreporting during the mechanism. **Expected:** different stages. **Mistake:** conflating incentives.

## 7. Deep-Dive Questions

### Q1. Can subsidy make an empty-core game stable?
Yes, by raising available grand-coalition value or relaxing claims. The minimum subsidy is closely related to least-core/balancedness deficits, but the funding source must be explicit.

### Q2. What is the nucleolus?
It lexicographically minimizes coalition excesses, first minimizing the worst complaint, then the next worst, and so on. It selects one imputation and lies in the core when the core is nonempty under standard TU assumptions.

### Q3. Stability under dynamic participation?
Static stability may fail when values, members, or information change. Contracts need recomputation, exit delays, or dynamic solution concepts; these are part of the model, not afterthoughts.

### Q4. How does uncertainty affect stability?
Coalition values may be random or estimated. Ex ante, expected, robust, and high-probability stability are different requirements; the risk rule must match the contract.

### Q5. Can all coalitions be stable if transfers are restricted?
Not necessarily. Scalar surplus inequalities assume free transfers; with restricted transfers, one must verify a feasible utility vector for every proposed deviation.

## 8. Comparison Tables

| Property | Question | Typical condition |
|---|---|---|
| Feasible | Is it affordable? | `x(N)<=v(N)` |
| Efficient | Is value wasted? | `x(N)=v(N)` |
| Individually rational | Will one player leave? | `x_i>=outside_i` |
| Core-stable | Will any coalition leave? | `x(S)>=v(S)` |
| Strategy-proof | Will anyone lie? | truthful report dominates |

## 9. Common Mistakes

- Saying “stable” without naming possible deviators.
- Confusing equal, fair, efficient, stable, and truthful.
- Ignoring outside options and transaction costs.
- Testing only currently likely coalitions.
- Treating estimated coalition values as exact.

## 10. Edge Cases / Special Cases

- Indifference may or may not count as blocking depending on convention.
- Rounding and indivisible payments can eliminate exact feasibility.
- Restricted transfers require vector feasibility.
- A stable allocation today can fail after a participant's outside option changes.
- Collusion resistance may require limiting coalitions by size or communication capability.

## 11. How to Explain in Interview

> An allocation is stable only relative to a deviation model. I first check feasibility and outside options, then ask whether any permitted group can use its own resources to make all members better off. In a TU characteristic game, that becomes the core inequalities; with approximation or matching, the constraints change.

## 12. Quick Revision Notes

- Stability != efficiency != fairness != strategy-proofness.
- Individual rationality handles singleton exits.
- Core stability handles all coalition exits.
- `epsilon` measures tolerated dissatisfaction.
- Always state transfers, outside options, and allowed deviators.

## 13. Practice Tasks

1. Classify several allocations as feasible, IR, and core-stable.
2. Construct an equal but unstable split.
3. Find maximum excess `v(S)-x(S)` by bitmask enumeration.
4. Round a stable allocation while preserving constraints.
5. Compare pairwise stability with coalition stability in a four-user matching.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | no permitted profitable deviation |
| Why | keeps a cooperative agreement viable |
| Asked | stable vs efficient/fair/truthful, epsilon, blocking |
| Compare | individual, pairwise, coalitional stability |
| One line | “State who may deviate; stability means none of those deviators can make all members better off.” |

---

# Bargaining

## 1. Overview

### Definition

**Bargaining** studies how players choose an agreement from a feasible set when disagreement gives each an outside-option payoff. The Nash bargaining solution (NBS) for two players maximizes `(u_1-d_1)(u_2-d_2)` over feasible, individually rational utilities, where `d` is the disagreement point.

### Why it matters, uses, and interviews

Bargaining models SLA negotiation, bandwidth sharing, cloud contracts, labor agreements, protocol standards, and marketplace fees. It forces explicit treatment of outside options, feasible trade-offs, bargaining power, and strategic delay. Interviewers ask it to connect optimization, axioms, equilibrium, and system negotiation.

## 2. Core Idea

Two services split 10 units of latency-saving value. Disagreement gives A 2 and B 1. If the frontier is `u_A+u_B=10`, maximize `(u_A-2)(u_B-1)`. Substitute `u_B=10-u_A`:

`f(u_A)=(u_A-2)(9-u_A)`.

The derivative `11-2u_A=0` yields `u_A=5.5`, `u_B=4.5`. The surplus above disagreement is 8 and is split equally: each gains 4. The final utilities are not equal because outside options differ.

## 3. Important Subtopics

### 3.1 Feasible set and Pareto frontier
The feasible set contains achievable utility pairs. A rational solution lies on the Pareto frontier: otherwise both could improve.

### 3.2 Disagreement point
`d` is what players receive if talks fail. It determines individual-rationality constraints and bargaining leverage. Threats matter only if credible and reflected in d or the process.

### 3.3 Nash bargaining axioms
Pareto efficiency, symmetry, invariance to positive affine utility transformations, and independence of irrelevant alternatives characterize the standard NBS.

### 3.4 Weighted Nash bargaining
Maximize `(u_1-d_1)^alpha (u_2-d_2)^(1-alpha)` to represent asymmetric bargaining power. On a linear frontier, surplus shares follow the weights.

### 3.5 Rubinstein alternating offers
Players alternate proposals and discount future payoffs. The subgame-perfect equilibrium explains how patience and first-mover position affect division and provides a noncooperative foundation for bargaining outcomes.

### 3.6 Threats, commitment, and information
Outside options, deadlines, private valuations, and commitment devices shape outcomes. A noncredible threat should not be inserted into the disagreement point.

## 4. Real-World Example

Two backend teams share a fixed database IOPS budget. Profiling gives a feasible latency-utility frontier, while dedicated-instance performance gives disagreement utilities. The platform maximizes a weighted Nash product to allocate IOPS, with weights representing contractual priority. Admission control enforces the allocation; monitoring updates the frontier when workloads change.

## 5. Diagrams / Mental Models

```text
u_B
 ^       feasible frontier
 |      * NBS
 |    /   product rectangle from d is largest
 | d*----------------
 +------------------------> u_A

d = outcome if negotiation fails
```

| Input | Role |
|---|---|
| Feasible set F | what agreements can deliver |
| Disagreement d | credible fallback |
| Weights | relative bargaining power |
| Discount factors | cost of delay |

## 6. Common Interview Questions

### Q1. What is a bargaining problem?
**Answer:** A feasible utility set plus disagreement point, with players seeking an agreement. **Expected:** both ingredients. **Mistake:** describing only price haggling.

### Q2. State the Nash bargaining solution.
**Answer:** Maximize the product of gains over disagreement on the feasible IR set. **Expected:** `(u_i-d_i)`, not raw utilities. **Mistake:** maximizing `u_1u_2` when d is nonzero.

### Q3. Why use a product?
**Answer:** Its maximizer uniquely satisfies the Nash axioms and balances proportional gains; log form turns it into a sum. **Expected:** axiomatic basis. **Mistake:** claiming products always mean fairness.

### Q4. What is the disagreement point?
**Answer:** Credible payoff if no agreement occurs. **Expected:** outside option. **Mistake:** worst imaginable punishment.

### Q5. Is the NBS always an equal split?
**Answer:** No. On a symmetric transferable frontier it equally splits surplus over d; asymmetric frontiers, weights, or disagreement points change utilities. **Expected:** equal gains under symmetry, not universally equal outcomes. **Mistake:** splitting total resources blindly.

### Q6. Which axioms characterize NBS?
**Answer:** Pareto efficiency, symmetry, affine invariance, and independence of irrelevant alternatives. **Expected:** explain at least briefly. **Mistake:** confusing Nash equilibrium conditions.

### Q7. What is weighted Nash bargaining?
**Answer:** Exponents encode bargaining power in the Nash product. **Expected:** weights sum conventionally to one. **Mistake:** treating them as utility units.

### Q8. NBS versus Nash equilibrium?
**Answer:** NBS is an axiomatic cooperative selection from feasible agreements; Nash equilibrium is mutual best response in a strategic game. **Expected:** Rubinstein can link them. **Mistake:** same because both say Nash.

### Q9. What does Rubinstein bargaining predict?
**Answer:** A unique subgame-perfect division under standard complete-information alternating offers; more patient players obtain more, and delay is avoided. **Expected:** patience, proposal order, and subgame perfection. **Mistake:** ignoring discount factors.

### Q10. Why must utilities permit affine transformation?
**Answer:** Expected-utility representations are equivalent under positive affine changes, so the selected physical outcome should not depend on arbitrary scale/origin. **Expected:** positive affine invariance preserves the selected agreement. **Mistake:** demanding invariance to every monotone transform.

## 7. Deep-Dive Questions

### Q1. Solve weighted bargaining on `u_1+u_2=V`.
With disagreement `d`, surplus is `V-d_1-d_2`. Maximizing weighted logs gives gains `alpha` and `1-alpha` times that surplus.

### Q2. Why is the log objective useful computationally?
`log product = sum log(u_i-d_i)`, a concave objective for convex feasible sets. It improves numerical handling and exposes proportional fairness.

### Q3. What is controversial about independence of irrelevant alternatives?
Removing an unchosen feasible option should not change the selected outcome if the old solution remains feasible. Real negotiators may use such options as reference points, motivating alternative solutions such as Kalai-Smorodinsky.

### Q4. How does private information change bargaining?
Players may misrepresent valuations or delay to signal type. Mechanism design and Bayesian/sequential equilibrium replace the complete-information cooperative calculation.

### Q5. How does Rubinstein approach Nash bargaining?
As offer intervals become short and discounting is calibrated, the alternating-offers equilibrium can converge to a weighted Nash bargaining outcome, with relative impatience determining weights.

## 8. Comparison Tables

| Feature | Nash bargaining solution | Rubinstein bargaining |
|---|---|---|
| Model | cooperative/axiomatic | noncooperative sequential game |
| Inputs | feasible set, disagreement | offers, timing, discount factors |
| Output basis | maximize gains product | subgame-perfect equilibrium |
| Power source | weights/symmetry | patience and proposer position |

| Solution | Guiding principle | Notable sensitivity |
|---|---|---|
| Nash | product of gains | disagreement, IIA |
| Egalitarian | equal gains | utility scale |
| Utilitarian | maximum sum | may sacrifice one party |
| Kalai-Smorodinsky | equal proportional concessions | ideal point |

## 9. Common Mistakes

- Maximizing raw utilities instead of gains above disagreement.
- Treating a threat as credible automatically.
- Confusing equal resource, equal utility, and equal surplus.
- Ignoring utility-scale assumptions.
- Calling every negotiated outcome Pareto-efficient.
- Confusing Nash bargaining with Nash equilibrium.

## 10. Edge Cases / Special Cases

- If no feasible point strictly dominates d, mutually beneficial bargaining may not exist.
- A nonconvex feasible set may yield multiple local/product maximizers.
- Zero gain makes the log objective undefined; restrict to positive gains or handle the boundary.
- Indivisible goods can prevent the continuous NBS without lotteries.
- More than two players use a generalized product, but coalition formation and participation become central.

## 11. How to Explain in Interview

> A bargaining problem specifies feasible utility outcomes and the payoff if talks fail. The Nash bargaining solution chooses the individually rational point maximizing the product of gains above that disagreement point. It is Pareto-efficient and axiomatic; weighted versions model power, while alternating-offers games explain bargaining through strategic timing and patience.

## 12. Quick Revision Notes

- NBS objective: maximize `product_i(u_i-d_i)`.
- Split gains over the fallback, not total utility.
- Standard axioms: Pareto, symmetry, affine invariance, IIA.
- Weighted exponents represent power.
- Rubinstein: patience and proposal timing matter.
- Trap: Nash bargaining solution is not Nash equilibrium.

## 13. Practice Tasks

1. Solve the 10-unit example analytically.
2. Change disagreement to `(4,1)` and recompute.
3. Solve weights `(0.7,0.3)`.
4. Draw a nonlinear feasible frontier and locate the tangent condition.
5. Implement a grid-search bargaining solver and verify against the closed form.
6. Explain a database IOPS negotiation using credible outside options.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | agreement maximizing product of gains over disagreement |
| Why | principled division with outside options |
| Asked | objective, axioms, weights, Rubinstein comparison |
| Compare | cooperative NBS vs strategic alternating offers |
| One line | “Nash bargaining maximizes `(u1-d1)(u2-d2)`, so it balances surplus gains relative to credible fallback payoffs.” |
