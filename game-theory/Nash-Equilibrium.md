# Nash Equilibrium for SDE Placements

A Nash equilibrium describes strategic stability: once every player's choice is fixed, no single player can improve by changing only their own strategy. Throughout payoff matrices, each cell is `(row player's payoff, column player's payoff)`, and larger numbers are preferred.

---

# Pure-Strategy Nash Equilibrium

## 1. Overview

A **pure-strategy Nash equilibrium (PSNE)** is a strategy profile in which every player's chosen deterministic strategy is a best response to the others' chosen strategies. Formally, `s*` is a Nash equilibrium if, for every player `i` and every alternative `s_i`, `u_i(s_i*, s_-i*) >= u_i(s_i, s_-i*)`. It matters because it predicts stable decentralized outcomes. Networking, congestion control, pricing, security, load balancing, and protocol incentives use this idea. Interviewers ask it to test payoff-matrix reasoning and the difference between stability, dominance, and social optimality.

## 2. Core Idea

Nash equilibrium asks a local question: **given everyone else's action, do I want to deviate alone?** It does not require the outcome to be fair, efficient, unique, or globally best.

Analogy: two services choose replicas. If both have settled on servers such that moving alone increases latency, the assignment is stable even if a coordinated swap would improve both.

Example:

| A \ B | Left | Right |
|---|---:|---:|
| **Up** | (3, 2) | (0, 0) |
| **Down** | (1, 1) | (2, 3) |

At `(Up, Left)`, A would fall from 3 to 1 by switching and B from 2 to 0, so neither deviates. At `(Down, Right)`, deviations reduce A from 2 to 0 and B from 3 to 1. Both are PSNE.

## 3. Important Subtopics

### Strategy profile and unilateral deviation

A profile lists one action per player. Nash tests one player's change while holding all others fixed. This matters because jointly profitable changes do not disprove equilibrium. Interviewers often catch candidates who move both players at once.

### Best response

`BR_i(s_-i)` is the set of strategies maximizing player `i`'s payoff against opponents' fixed strategies. A profile is Nash exactly when every chosen strategy belongs to the appropriate best-response set.

### Weak inequalities and ties

Equilibrium uses `>=`, so a player may be indifferent between staying and deviating. A profitable deviation must be strictly better. This creates weak equilibria and multiple best responses.

### Efficiency and welfare

An equilibrium can be Pareto dominated or have low total payoff. Stability is an incentive property, not a welfare certificate.

## 4. Real-World Example

Two backend services independently choose data-center regions. Latency depends on both choices because shared capacity congests. A placement is a PSNE if neither service can reduce its own latency by migrating alone. Engineers use this lens to predict selfish routing; tolls, quotas, or admission controls can reshape payoffs so stable behavior aligns with system performance.

## 5. Diagrams / Mental Models

```text
candidate profile
   |
   +-> hold B fixed; can A strictly improve? -- yes -> not NE
   |                                      `-- no
   +-> hold A fixed; can B strictly improve? -- yes -> not NE
                                          `-- no -> NE
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Define PSNE.** A deterministic profile where no player has a profitable unilateral deviation. | Profile, unilateral, best response | “Best combined outcome” |
| 2 | **Does every finite game have a PSNE?** No; matching pennies has none. Every finite game has a mixed NE. | Pure vs mixed existence | Quoting Nash's theorem for pure strategies |
| 3 | **Must equilibrium maximize welfare?** No; Prisoner's Dilemma's equilibrium is Pareto inferior. | Stability vs efficiency | Calling equilibrium optimal |
| 4 | **Can there be multiple PSNE?** Yes; coordination games commonly have several. | Non-uniqueness | Assuming prediction is complete |
| 5 | **Can a player be indifferent?** Yes; `>=` permits ties, so no strictly profitable deviation is enough. | Weak inequality | Requiring strict preference to stay |
| 6 | **How find PSNE in a matrix?** Mark each player's best responses and select cells marked for all players. | Mutual best responses | Maximizing payoff sum |
| 7 | **Is a dominant-strategy equilibrium Nash?** Yes; a dominant strategy is optimal against every opponent action. | Implication direction | Saying every Nash equilibrium is dominant |
| 8 | **Can both players improve jointly from NE?** Yes; Nash blocks unilateral, not coordinated deviations. | Scope of deviation | Moving both to disprove NE |
| 9 | **What does “pure” mean?** Each player chooses one strategy with probability one. | Deterministic action | “No uncertainty in payoffs” |
| 10 | **How model costs?** Convert them to payoffs, often negative latency/cost, and still maximize. | Sign convention | Minimizing a payoff column while others maximize |

## 7. Deep-Dive Questions

1. **What is a strict Nash equilibrium?** Every player's selected strategy is a unique best response; every unilateral deviation strictly lowers payoff. Strict NE are robust to small payoff perturbations.
2. **What is an epsilon-Nash equilibrium?** No unilateral deviation improves payoff by more than `epsilon`; useful for approximate algorithms and noisy systems.
3. **Does repeated play guarantee convergence to PSNE?** No. Best-response dynamics can cycle, and learning depends on game structure.
4. **What is price of anarchy?** Ratio comparing the worst equilibrium welfare with the optimal welfare; it quantifies inefficiency caused by selfish behavior.
5. **Can a PSNE use weakly dominated strategies?** Yes in some games, especially through indifference; Nash alone does not eliminate every implausible equilibrium.

## 8. Comparison Tables

| Concept | Requirement | Strength/meaning |
|---|---|---|
| PSNE | Mutual best responses at one profile | Stable against unilateral deviations |
| Dominant-strategy equilibrium | Each choice best against every opponent action | Stronger than Nash |
| Pareto optimum | No joint change makes someone better without harming another | Welfare, not incentives |
| Social optimum | Maximizes chosen aggregate objective | Planner's benchmark |

## 9. Common Mistakes

- Looking for the largest total payoff instead of mutual best responses.
- Changing both players' actions during a unilateral-deviation test.
- Reading the wrong payoff coordinate.
- Assuming equilibrium is unique, fair, or efficient.
- Forgetting ties count as best responses.

## 10. Edge Cases / Special Cases

A player can have several best responses. A constant-payoff player is indifferent everywhere. Duplicate strategies can create many equilibria. With costs, lower raw cost is better but payoff notation should be normalized. Continuous strategy games need existence conditions and calculus rather than cell marking. Empty strategy sets or undefined outcomes make the model incomplete.

## 11. How to Explain in Interview

“A pure-strategy Nash equilibrium is a deterministic action profile where each player's action is a best response to the others. To test a profile, hold everyone else fixed and check every unilateral deviation. It is stable, but it need not be unique or socially optimal.”

## 12. Quick Revision Notes

- Nash = no **profitable unilateral** deviation.
- Pure = probability one on one strategy.
- Find mutual best-response cells.
- Ties are allowed because equilibrium uses `>=`.
- Dominant equilibrium implies Nash; Nash does not imply dominant.

## 13. Practice Tasks

1. Mark best responses in five 2x2 payoff matrices.
2. Build a C++ matrix scanner that reports all pure equilibria.
3. Construct a game with zero, one, and three PSNE.
4. Model two services choosing regions using negative latency payoffs.
5. Compute price of anarchy for a small congestion game.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | No profitable unilateral deviation |
| Why it matters | Predicts stable decentralized behavior |
| Most asked | Find PSNE; Nash vs dominant; stability vs efficiency |
| Main comparison | Mutual best response is weaker than dominance |
| One-line answer | “Freeze rivals; if every player is already best responding, the profile is Nash.” |

---

# Best-Response Functions

## 1. Overview

A **best-response correspondence** maps opponents' strategies to the set of a player's payoff-maximizing strategies: `BR_i(s_-i) = argmax_{s_i} u_i(s_i,s_-i)`. It is called a function only when the maximizer is unique. Best responses matter because Nash equilibria are intersections of players' best responses. They power matrix algorithms, iterative dynamics, pricing models, and learning agents. Interviewers ask candidates to derive them and handle ties correctly.

## 2. Core Idea

A best response is conditional, not globally best. The same action can be optimal against one opponent choice and poor against another.

Analogy: a cache chooses replication level based on request load selected by another service. High replication may be best under high load but wasteful under low load.

Example:

| A \ B | L | R |
|---|---:|---:|
| **U** | (4, 1) | (0, 3) |
| **D** | (2, 2) | (3, 0) |

For A, `BR_A(L)={U}` and `BR_A(R)={D}`. For B, `BR_B(U)={R}` and `BR_B(D)={L}`. No cell is a mutual best response, so no PSNE exists.

## 3. Important Subtopics

### Correspondences and ties

`argmax` can return multiple strategies. If U and D both give 4 against L, `BR_A(L)={U,D}`. Calling it a set-valued correspondence avoids deleting valid equilibria.

### Discrete best responses

In a payoff matrix, fix an opponent action and compare only the relevant player's payoffs. Row-player responses are column-wise; column-player responses are row-wise.

### Continuous best responses

For continuous actions, maximize utility subject to constraints using first-order conditions, boundary checks, and second-order/global reasoning. Example quantity or price choices often yield piecewise response curves.

### Best-response dynamics

Players repeatedly switch to best responses. The process may converge in potential/coordination games or cycle in games such as rock-paper-scissors.

## 4. Real-World Example

Two autoscaling services share a cluster. Each chooses replica count; its latency benefit and resource cost depend on the other's count. A best-response service computes the replica count minimizing its own cost for the observed rival load. If both controllers update aggressively, they may oscillate; damping or centralized quotas may be needed even though each local update is rational.

## 5. Diagrams / Mental Models

```text
opponents' choice s_-i
          |
          v
evaluate u_i(action, s_-i) for every feasible action
          |
          v
return ALL maximizers = BR_i(s_-i)

Mutual intersection of BR sets = Nash equilibrium
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Define best response.** Any strategy maximizing a player's payoff given fixed opponents' strategies. | Conditional argmax | Globally highest matrix cell |
| 2 | **Function or correspondence?** Generally a correspondence because ties may return several strategies. | Set-valued result | Dropping tied maxima |
| 3 | **How relate to Nash?** A profile is Nash iff every player's strategy is in its best-response set. | Mutuality | One player's best response suffices |
| 4 | **How mark row responses?** For each column, compare first coordinates down the rows. | Correct coordinate/direction | Comparing cells across columns |
| 5 | **How mark column responses?** For each row, compare second coordinates across columns. | Correct coordinate/direction | Comparing first payoffs |
| 6 | **Can a dominated strategy be a best response?** A strictly dominated strategy cannot; a weakly dominated one can under ties. | Dominance nuance | Saying no dominated strategy ever can |
| 7 | **Do best-response dynamics always converge?** No; improvement paths can cycle. | Dynamics vs static solution | Assuming rational updates converge |
| 8 | **What is a unique best response?** One strategy strictly outperforms all alternatives against that fixed opponent profile. | Uniqueness | Confusing with dominant strategy |
| 9 | **How derive continuous BR?** Optimize utility for fixed rival actions, checking first-order solution and boundaries. | Constraints/global maximum | Using derivative only |
| 10 | **What if every action ties?** The entire feasible strategy set is the best-response set. | Argmax semantics | Picking an arbitrary singleton |

## 7. Deep-Dive Questions

1. **Why can best-response curves be discontinuous?** Small rival-action changes can switch the identity of the maximizing action, especially with discrete choices or capacity thresholds.
2. **What conditions help guarantee an equilibrium by fixed-point logic?** Compact convex strategy sets, continuous payoffs, and suitable convex-valued upper-hemicontinuous best-response correspondences support fixed-point theorems.
3. **What is fictitious play?** Players best respond to empirical distributions of opponents' past play; convergence occurs for some game classes, not all.
4. **Best response versus better response?** A best response globally maximizes payoff; a better response merely improves on the current action.
5. **How do simultaneous controller updates cause oscillation?** Both respond to stale shared state, overshoot, and reverse next round; rational pointwise responses need not form a stable distributed algorithm.

## 8. Comparison Tables

| Concept | Compared against | Requirement |
|---|---|---|
| Best response | Fixed opponent profile | Maximizes payoff there |
| Better response | Current own action | Strictly improves payoff |
| Dominant strategy | Every opponent profile | Best response everywhere |
| Nash equilibrium | All players' responses together | Mutual best responses |

## 9. Common Mistakes

- Calling `argmax` single-valued when ties exist.
- Comparing the row player's payoffs across different columns.
- Treating best response as an unconditional recommendation.
- Assuming repeated best responses converge.
- Ignoring boundary points in continuous optimization.

## 10. Edge Cases / Special Cases

The best-response set can be empty if a maximum is not attained on an open/unbounded strategy set. It can contain an interval under indifference. Discontinuous payoffs may destroy fixed points. With mixed opponent strategies, maximize expected payoff. Approximate best responses are useful when exact optimization is computationally costly.

## 11. How to Explain in Interview

“A best response is a payoff-maximizing strategy against fixed opponent behavior. It is generally a set because ties are possible. Nash equilibria are precisely the profiles where all players' chosen strategies are mutual best responses.”

## 12. Quick Revision Notes

- `BR_i(s_-i)=argmax u_i(s_i,s_-i)`.
- Fix rivals before optimizing.
- Preserve every tied maximum.
- Matrix: row player compares vertically; column player horizontally.
- Dynamics can cycle even when each update is optimal.

## 13. Practice Tasks

1. Annotate all best responses in three 3x3 matrices.
2. Write a C++ routine returning tied best-response indices.
3. Derive reaction functions in a two-firm Cournot model.
4. Simulate simultaneous and alternating best-response updates.
5. Create an example with a set-valued response at a threshold.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Conditional `argmax` against rivals |
| Why it matters | Building block of Nash equilibrium |
| Most asked | Mark responses, handle ties, derive reaction curves |
| Main comparison | Dominant = best response to every rival action |
| One-line answer | “Freeze the opponents and return every action that maximizes my payoff.” |

---

# Finding Nash Equilibria from Payoff Matrices

## 1. Overview

A normal-form payoff matrix lists outcomes for every combination of two players' actions. Finding a PSNE means locating cells that are best responses for both players. This mechanical skill matters in online assessments and is the gateway to mixed equilibria, dominance, and game classification. Interviewers test indexing discipline more than arithmetic.

## 2. Core Idea

Use the **underline/circle method**:

1. Confirm payoff order `(row, column)`.
2. For each column, mark the largest first payoff: row player's best responses.
3. For each row, mark the largest second payoff: column player's best responses.
4. Cells with both marks are PSNE.

Example:

| A \ B | L | R |
|---|---:|---:|
| **U** | **(3, 2)** | (0, 0) |
| **D** | (1, 1) | **(2, 3)** |

Both bold cells are mutual best responses. Do not compare A's 3 at `(U,L)` with A's 2 at `(D,R)`; those face different B actions.

## 3. Important Subtopics

### Coordinate discipline

The first number belongs to the row player and the second to the column player unless stated otherwise. This is the most common assessment error.

### Tied maxima

Mark all equal maxima. Missing one mark can remove valid equilibria. In integer matrices, ties are common rather than measure-zero artifacts.

### No pure equilibrium

If no cell has both marks, the game has no PSNE; do not force one. A finite game still has at least one mixed equilibrium.

### Algorithmic complexity

For an `m x n` matrix, scan each cell a constant number of times: `O(mn)` time and `O(mn)` markers, or less extra space if emitting candidates carefully.

## 4. Real-World Example

A capacity planner enumerates two services' choices—small, medium, large replicas—and records negative cost for every pair. A matrix scan identifies stable allocations. This is practical only for small action spaces; large systems need structure, optimization, simulation, or learning rather than explicit Cartesian enumeration.

## 5. Diagrams / Mental Models

```text
ROW player's best responses: scan DOWN each column using first payoff
COLUMN player's responses:    scan ACROSS each row using second payoff
DOUBLE MARK = pure Nash equilibrium
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **What does each cell contain?** The payoff pair for that row/column action profile. | Coordinate convention | Treating coordinates as actions |
| 2 | **How mark row best responses?** Fix a column and maximize the first payoff over rows. | Hold B fixed | Scan horizontally |
| 3 | **How mark column best responses?** Fix a row and maximize the second payoff over columns. | Hold A fixed | Maximize first payoff |
| 4 | **What identifies PSNE?** A cell marked as a best response for every player. | Mutual response | Largest total payoff |
| 5 | **What if maxima tie?** Mark all tied actions. | Weak best responses | Choose one arbitrarily |
| 6 | **What if no double mark exists?** No pure equilibrium; consider mixed strategies if requested. | Correct conclusion | Inventing closest cell |
| 7 | **Can there be many double marks?** Yes; each is a PSNE. | Multiplicity | Reporting only highest-payoff one |
| 8 | **Complexity for m x n?** `O(mn)` because all payoff entries must be inspected. | Linear in input size | `O(m+n)` |
| 9 | **How handle costs?** Negate costs or minimize consistently; state convention. | Preference direction | Maximizing raw latency |
| 10 | **Can dominance simplify scan?** Yes, eliminate strictly dominated strategies carefully, but direct marking is safer for small matrices. | Valid elimination | Removing weakly dominated actions carelessly |

## 7. Deep-Dive Questions

1. **How find a 2x2 mixed equilibrium?** Make each player indifferent between pure actions using the opponent's mixing probability, solve probabilities, and verify they lie in `[0,1]`.
2. **Why is iterated strict-dominance elimination safe for Nash search?** Strictly dominated pure strategies cannot be best responses, so they cannot appear with positive probability in equilibrium.
3. **Why can weak-dominance elimination be order-dependent?** Removing a weakly dominated strategy can delete equilibria supported by indifference and change subsequent dominance relations.
4. **How generalize to more players?** A payoff tensor replaces the matrix; for every profile, test each player's deviations while holding all other coordinates fixed.
5. **Can matrix size become the bottleneck?** Yes. With many players/actions, explicit representation grows exponentially in players, motivating compact game representations.

## 8. Comparison Tables

| Task | What stays fixed | What is compared |
|---|---|---|
| Row player's BR | Column | First payoffs down rows |
| Column player's BR | Row | Second payoffs across columns |
| Nash test | Opponents' actions | Selected payoff vs unilateral alternatives |
| Welfare test | Nothing | Aggregate payoffs across profiles |

## 9. Common Mistakes

- Swapping payoff coordinates.
- Scanning in the wrong direction.
- Marking only one of several tied maxima.
- Selecting the largest sum rather than mutual best responses.
- Declaring no equilibrium when only no **pure** equilibrium was found.

## 10. Edge Cases / Special Cases

Repeated rows/columns can produce many ties. Negative payoffs are still maximized: `-1` is better than `-5`. Non-square matrices work identically. If payoffs are vectors or lexicographic preferences, comparisons need a declared ordering. Floating-point payoffs need a tolerance policy in code, but mathematical equality should not be changed silently.

## 11. How to Explain in Interview

“I first confirm payoff order. For each column I mark all rows maximizing the row player's payoff; for each row I mark all columns maximizing the column player's payoff. Every doubly marked cell is a pure Nash equilibrium, including ties.”

## 12. Quick Revision Notes

- First coordinate: row; second: column.
- Row BR: scan columns vertically.
- Column BR: scan rows horizontally.
- Mark all ties.
- No double mark means no PSNE, not no Nash equilibrium.

## 13. Practice Tasks

1. Solve 2x2, 2x3, and 3x3 matrices by marking.
2. Implement `findPureNE` in C++ for integer payoff matrices.
3. Add tied maxima and negative payoffs to tests.
4. Derive a mixed equilibrium for matching pennies.
5. Represent a three-player binary-action game and enumerate deviations.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Double-marked mutual best-response cells |
| Why it matters | Fast, reliable interview procedure |
| Most asked | Scan direction, ties, no-pure case |
| Main comparison | Nash maximizes individual payoff conditionally, not payoff sum |
| One-line answer | “Vertical first-payoff maxima plus horizontal second-payoff maxima; intersections are PSNE.” |

---

# Multiple Equilibria

## 1. Overview

A game has **multiple equilibria** when more than one strategy profile satisfies the equilibrium conditions. Existence alone then gives incomplete prediction: players must coordinate expectations or use an equilibrium-selection principle. Multiple equilibria matter in technology standards, distributed conventions, market adoption, routing, and protocol rollout. Interviewers ask candidates to distinguish finding equilibria from selecting among them.

## 2. Core Idea

Several outcomes can each be self-enforcing because the best action depends on what others are expected to do.

Example:

| A \ B | API v1 | API v2 |
|---|---:|---:|
| **API v1** | (4, 4) | (0, 0) |
| **API v2** | (0, 0) | (3, 3) |

Both coordinated cells are Nash equilibria. `(v1,v1)` is payoff-dominant, but if everyone expects v2, no one wants to migrate alone. History, communication, defaults, and migration tooling select the outcome.

## 3. Important Subtopics

### Payoff dominance

An equilibrium payoff-dominates another if every player gets a higher payoff there. It is attractive but may be hard to coordinate on.

### Risk dominance

An equilibrium can be safer against uncertainty about others. In 2x2 coordination games, risk dominance compares losses from choosing incorrectly; the larger basin of attraction often wins under noisy adaptation.

### Focal points and conventions

Labels, defaults, history, standards, or cultural prominence help players align without binding contracts. These are selection devices outside bare payoff arithmetic.

### Path dependence and lock-in

Early random adoption can make one equilibrium self-reinforcing, even if another later offers higher welfare. Switching costs deepen lock-in.

## 4. Real-World Example

Two teams must choose a serialization format. JSON/JSON works immediately; Protobuf/Protobuf is more efficient; a mismatch breaks communication. Both coordinated choices are equilibria. A compatibility gateway, dual-read period, or mandated default changes transition payoffs and helps the organization move without relying on simultaneous luck.

## 5. Diagrams / Mental Models

```text
expect others choose A -> A is my best response -> expectation sustains A
expect others choose B -> B is my best response -> expectation sustains B

selection inputs: history | default | communication | risk | migration cost
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Why is multiplicity a problem?** Equilibrium predicts a set, not which outcome will occur. | Selection problem | Saying theory predicts nothing |
| 2 | **What is payoff dominance?** One equilibrium gives every player higher payoff than another. | Pareto comparison | Largest single player's payoff |
| 3 | **What is risk dominance?** The equilibrium safer under uncertainty/miscoordination, often with a larger attraction basin. | Robustness | Equating with payoff dominance |
| 4 | **Can all equilibria be efficient?** Yes, but they need not be; efficiency and equilibrium are separate. | Logical independence | Assuming one must be bad |
| 5 | **What is a focal point?** A salient outcome players coordinate on without explicit agreement. | Salience | Dominant strategy |
| 6 | **How do defaults matter?** They coordinate expectations and lower one outcome's adoption cost. | Mechanism/design influence | Treating defaults as neutral |
| 7 | **Can communication solve selection?** It can align beliefs, but cheap talk may lack credibility when interests conflict. | Credibility | Assuming messages bind actions |
| 8 | **What is path dependence?** Early choices change later incentives, locking a system into an equilibrium. | History | Merely chronological order |
| 9 | **How can a designer move equilibria?** Change payoffs via subsidies, compatibility, penalties, standards, or staged migration. | Incentive engineering | Telling users to coordinate |
| 10 | **Does multiple PSNE imply a mixed NE?** In many finite 2x2 coordination games an additional mixed NE exists; derive rather than assume universally. | Mixed threshold role | Treating mixed outcome as stable convention automatically |

## 7. Deep-Dive Questions

1. **How calculate risk dominance in a symmetric 2x2 game?** Compare products of deviation losses around each equilibrium; the equilibrium with the larger product is risk-dominant.
2. **What role does the mixed equilibrium play?** Its mixing probability often forms a tipping threshold separating basins under best-response dynamics.
3. **Can refinements choose uniquely?** Sometimes. Trembling-hand perfection, global-games perturbations, forward induction, or evolutionary stability may eliminate candidates, but no refinement is universally correct.
4. **How does a compatibility layer change the game?** It raises mismatch payoffs during migration, reducing coordination risk and potentially removing the old equilibrium.
5. **Why can the better equilibrium fail to emerge?** A unilateral mover pays transition cost while benefits require coordinated adoption; rational expectations sustain the inferior status quo.

## 8. Comparison Tables

| Criterion | Question | Possible selection |
|---|---|---|
| Payoff dominance | Which equilibrium makes everyone better? | High-welfare outcome |
| Risk dominance | Which is safer if unsure? | Robust outcome |
| Focality | Which is most salient/default? | Conventional outcome |
| Path dependence | What did history establish? | Locked-in outcome |

## 9. Common Mistakes

- Reporting only the highest-payoff equilibrium.
- Assuming rational players automatically coordinate on payoff dominance.
- Confusing a dominant strategy with a focal equilibrium.
- Ignoring the mixed equilibrium/tipping threshold.
- Treating historical lock-in as proof of technical superiority.

## 10. Edge Cases / Special Cases

Equilibria can form a continuum. Weak ties make selection fragile to tiny payoff perturbations. Communication may be credible only when preferences align. Network effects can create equilibria involving partial adoption. Repeated interaction and reputation can select outcomes absent in a one-shot model.

## 11. How to Explain in Interview

“Multiple equilibria mean several outcomes are internally stable, so Nash equilibrium alone does not predict which occurs. I would list all equilibria, then discuss selection through payoff dominance, risk dominance, focal points, defaults, and history.”

## 12. Quick Revision Notes

- Find all equilibria before ranking them.
- Payoff-dominant != risk-dominant.
- Expectations can be self-fulfilling.
- Defaults/history are equilibrium-selection devices.
- Compatibility can reshape transition payoffs.

## 13. Practice Tasks

1. Create a 2x2 game with two pure and one mixed equilibrium.
2. Compare payoff and risk dominance numerically.
3. Model a database-driver migration with mismatch costs.
4. Simulate best-response adoption from different initial populations.
5. Propose a rollout that changes the selection outcome.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | More than one mutually stable strategy profile |
| Why it matters | Requires equilibrium selection |
| Most asked | Payoff vs risk dominance; focal points; lock-in |
| Main comparison | Best payoff vs safest coordination |
| One-line answer | “Nash finds stable candidates; expectations, risk, and institutions select among them.” |

---

# Coordination Games

## 1. Overview

A **coordination game** rewards players for choosing compatible actions. Interests are substantially aligned, but players may disagree about which coordinated outcome is best or fear mismatch. Standards, communication protocols, meeting locations, database migrations, and distributed rollouts exhibit coordination structure. Interviewers ask about multiple equilibria, focal points, and safe deployment design.

## 2. Core Idea

The difficulty is not defeating an opponent; it is matching expectations.

Example:

| Service A \ Service B | Old protocol | New protocol |
|---|---:|---:|
| **Old** | (2, 2) | (-3, -3) |
| **New** | (-3, -3) | (5, 5) |

Both `(Old,Old)` and `(New,New)` are PSNE. New is payoff-dominant, but unilateral migration fails. A rolling deployment therefore needs backward compatibility or orchestration.

## 3. Important Subtopics

### Pure and mixed equilibria

Typical 2x2 coordination games have two pure equilibria plus a mixed equilibrium. The mixed equilibrium often marks the belief threshold at which a player switches preferred action.

### Assurance/Stag Hunt

Players prefer mutual high effort but can choose a safe low-return action. It models trust and deployment risk: high payoff requires confidence in others.

### Network effects

An action becomes more valuable as more participants adopt it. Standards and platforms can tip toward one equilibrium.

### Coordination mechanisms

Defaults, leaders, standards, feature flags, two-phase rollouts, and compatibility layers align actions or reduce mismatch costs.

## 4. Real-World Example

A database schema change requires applications to stop writing an old field. A flag-day switch is a coordination game with a costly mismatch. The expand-migrate-contract pattern changes the payoff matrix: deploy compatible readers/writers, migrate data, switch traffic, then remove the old field. It makes unilateral intermediate steps safe.

## 5. Diagrams / Mental Models

```text
OLD only -> add compatibility -> both formats safe -> switch default -> remove OLD

The rollout does not merely “coordinate better”; it reduces mismatch cost.
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Define coordination game.** Players benefit from compatible choices, producing multiple mutual best responses. | Alignment and matching | Zero-sum competition |
| 2 | **Why multiple equilibria?** If others choose A, A is best; if they choose B, B is best. | Self-fulfilling expectations | Dominant actions |
| 3 | **What is mismatch cost?** Loss when players choose incompatible actions. | Coordination risk | Difference between equilibrium payoffs |
| 4 | **What is Stag Hunt?** High mutual cooperation beats safe action, but acting cooperatively alone is costly. | Assurance problem | Prisoner's Dilemma |
| 5 | **What is a focal point?** A salient convention that aligns expectations. | Selection | Formal enforcement |
| 6 | **How do network effects matter?** Adoption increases an option's payoff, enabling tipping and lock-in. | Endogenous payoff | Mere popularity |
| 7 | **Why can a superior standard fail?** Switching alone causes incompatibility, so the installed base sustains the old equilibrium. | Transition incentives | Irrational users |
| 8 | **How help a rollout?** Use compatibility, flags, staged activation, and an authoritative coordinator. | Change payoffs/timing | Simultaneous manual deployment |
| 9 | **Is communication sufficient?** Only if credible and execution can align; failures/latency may still create mismatch. | Operational reality | Treating agreement as atomic action |
| 10 | **Coordination vs anti-coordination?** Coordination rewards matching; anti-coordination rewards choosing different actions. | Payoff structure | Confusing load balancing with matching |

## 7. Deep-Dive Questions

1. **How derive the mixed threshold?** Set a player indifferent between coordinating on A and B using belief `p` that the opponent chooses A; solve equality of expected payoffs.
2. **Why is the mixed equilibrium often unstable?** A small belief shift makes one pure action strictly better, driving behavior away toward a pure equilibrium.
3. **How does a feature flag act strategically?** It creates a shared, quickly reversible coordination signal and can make activation atomic from participants' perspective.
4. **What is global-games selection?** Small private uncertainty about fundamentals can yield a unique threshold equilibrium, selecting among multiple complete-information equilibria.
5. **Can decentralization coordinate reliably?** Yes in structured games through conventions, consensus protocols, or potential-function learning, but failures and strategic incentives must be modeled.

## 8. Comparison Tables

| Feature | Coordination | Prisoner's Dilemma | Anti-coordination |
|---|---|---|---|
| Preferred relation | Match | Individually defect | Differ |
| Typical PSNE | Multiple matched cells | One mutual-defection cell | Multiple off-diagonal cells |
| Main problem | Expectations | Incentive conflict | Role allocation |
| System example | Protocol version | Shared-resource abuse | Load spreading |

## 9. Common Mistakes

- Calling every game with multiple equilibria a coordination game.
- Assuming shared interests remove strategic difficulty.
- Ignoring mismatch and migration costs.
- Confusing Stag Hunt with Prisoner's Dilemma.
- Treating a mixed equilibrium as deliberate randomization in every real deployment.

## 10. Edge Cases / Special Cases

Players may prefer different coordinated outcomes, producing Battle of the Sexes. More than two standards can fragment adoption. Partial compatibility changes payoffs continuously. Failures can turn an intended simultaneous switch into mismatch. A central coordinator may itself fail or act strategically.

## 11. How to Explain in Interview

“A coordination game rewards compatible actions, so several conventions can each be Nash equilibria. The engineering challenge is selecting and safely reaching one equilibrium—usually by defaults, compatibility, staged rollout, or coordination protocols.”

## 12. Quick Revision Notes

- Coordination = benefit from matching/compatibility.
- Often two pure equilibria and one mixed threshold.
- Payoff dominance and risk dominance may disagree.
- Standards and network effects cause lock-in.
- Good rollout design reduces mismatch payoff loss.

## 13. Practice Tasks

1. Model an API version migration as a payoff matrix.
2. Calculate the mixed threshold in a Stag Hunt.
3. Design an expand-migrate-contract rollout.
4. Simulate adoption under a network-effect payoff.
5. Compare centralized flags with decentralized conventions.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Players benefit from compatible choices |
| Why it matters | Explains standards, rollouts, and lock-in |
| Most asked | Multiple equilibria, Stag Hunt, focal points |
| Main comparison | Coordination problem vs defection incentive |
| One-line answer | “The goal is to match; the hard part is aligning expectations and surviving migration.” |

---

# Prisoner's Dilemma

## 1. Overview

The **Prisoner's Dilemma (PD)** is a game where each player has a strictly dominant incentive to defect, yet mutual cooperation would make both better off. With payoffs `T` (temptation), `R` (reward), `P` (punishment), and `S` (sucker), the defining order is `T > R > P > S`; repeated-game analysis often also assumes `2R > T+S`. It models shared-resource abuse, security investment, pricing, and protocol compliance. Interviewers ask because it cleanly separates individual incentives from collective welfare.

## 2. Core Idea

No matter what the other player does, defection pays more in the one-shot game:

| A \ B | Cooperate | Defect |
|---|---:|---:|
| **Cooperate** | (3, 3) | (0, 5) |
| **Defect** | (5, 0) | (1, 1) |

For A, defect gives 5 instead of 3 if B cooperates and 1 instead of 0 if B defects. Symmetrically for B. Therefore `(Defect,Defect)` is the unique dominant-strategy and Nash equilibrium, although `(Cooperate,Cooperate)` Pareto-dominates it.

## 3. Important Subtopics

### Dominant defection

Defection strictly dominates cooperation in the one-shot game. This is stronger than merely being a best response at equilibrium.

### Pareto inefficiency

Mutual defection is stable but both prefer mutual cooperation. The dilemma is the conflict between individual unilateral incentives and joint welfare.

### Repeated interaction

Future punishment/reward can support cooperation if players value the future, observe actions, and expect continued interaction.

### Mechanism design and enforcement

Contracts, quotas, authentication, rate limits, reputation, and deposits change payoffs so cooperation becomes individually rational rather than morally requested.

## 4. Real-World Example

Two clients share a backend. Each can respect a rate limit or send aggressively. Aggression improves one client's throughput if the other complies; if both act aggressively, overload causes timeouts for both. Server-enforced quotas and congestion pricing remove the unilateral temptation, converting a fragile social request into an incentive-compatible protocol.

## 5. Diagrams / Mental Models

```text
Individual logic: other cooperates -> defect pays more
                  other defects    -> defect pays more
Collective result: both defect -> both worse than mutual cooperation

stable != efficient
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Define PD.** Defection strictly dominates, but mutual cooperation Pareto-dominates mutual defection. | Incentive/welfare conflict | Any cooperation game |
| 2 | **What payoff order defines it?** `T>R>P>S`; often `2R>T+S` for repeated interpretation. | Correct symbols/order | Swapping P and S |
| 3 | **One-shot equilibrium?** Unique `(Defect,Defect)` under strict inequalities. | Dominance and Nash | `(Cooperate,Cooperate)` because welfare is higher |
| 4 | **Why is equilibrium inefficient?** Both get `P`, while mutual cooperation gives both `R>P`. | Pareto comparison | Saying total payoff alone proves Pareto dominance |
| 5 | **Can communication solve it?** Nonbinding talk alone does not remove defection incentives. | Credibility/enforcement | Assuming promise changes payoffs |
| 6 | **How can repetition help?** Future retaliation makes current defection costly when future payoffs matter. | Shadow of future | Repetition always guarantees cooperation |
| 7 | **What is tit-for-tat?** Cooperate initially, then copy the opponent's previous action; simple but vulnerable to noise. | Conditional reciprocity | Dominant strategy in repeated games |
| 8 | **System example?** Clients overconsume a shared service, causing congestion if all do it. | Map actions/payoffs | Any resource conflict without payoff check |
| 9 | **How does enforcement help?** It changes temptation or punishment through quotas, fines, deposits, or exclusion. | Change payoff matrix | Rely on goodwill |
| 10 | **PD vs tragedy of commons?** PD is commonly two-player/two-action; tragedy generalizes overuse to many users and continuous resources. | Structural relation | Treating terms as identical |

## 7. Deep-Dive Questions

1. **When can grim trigger sustain cooperation infinitely?** With normalized stage payoffs, cooperation can be sustained if `R/(1-delta) >= T + delta P/(1-delta)`, equivalently `delta >= (T-R)/(T-P)`.
2. **Why does a known finite horizon unravel cooperation?** Backward induction gives defection in the last round, then the penultimate round, continuing to the first under common knowledge of rationality.
3. **How does noise affect trigger strategies?** Misobserved actions can start endless retaliation; forgiving strategies or finite punishments can be more robust.
4. **What is the folk-theorem intuition?** With sufficiently patient players and suitable monitoring, many individually rational payoff profiles—including cooperation—can be supported by credible future punishments.
5. **How would you redesign a congested API?** Authenticate clients, measure use, enforce per-client quotas/pricing, expose backoff signals, and ensure defecting traffic cannot gain unchecked priority.

## 8. Comparison Tables

| Feature | Prisoner's Dilemma | Stag Hunt |
|---|---|---|
| Dominant action | Defect | Usually none |
| Pure equilibria | One | Two |
| Core problem | Incentive to exploit | Lack of assurance |
| Mutual cooperation | Not stable one-shot | Stable but risky |
| Remedy | Change incentives/repetition | Coordinate/reduce mismatch risk |

## 9. Common Mistakes

- Calling any bad social outcome a Prisoner's Dilemma.
- Forgetting strict dominance of defection.
- Confusing Pareto superiority with equilibrium.
- Claiming repetition automatically produces cooperation.
- Recommending communication without credibility or enforcement.

## 10. Edge Cases / Special Cases

If `P <= S`, defection may not be best against defection, so the game is not standard PD. One-shot anonymous interaction differs from repeated identifiable play. Imperfect monitoring changes credible punishment. Asymmetric payoffs may give different patience thresholds. Evolutionary population dynamics need not match two-player rational analysis.

## 11. How to Explain in Interview

“In the Prisoner's Dilemma, defection is strictly better for each player whatever the other does, so mutual defection is the unique one-shot Nash equilibrium. Yet both prefer mutual cooperation, showing that stable individual incentives can produce an inefficient system.”

## 12. Quick Revision Notes

- Payoff order: `T>R>P>S`.
- Defect strictly dominates cooperate.
- `(D,D)` is stable; `(C,C)` Pareto-dominates it.
- Repetition helps only with patience, monitoring, and credible punishment.
- Engineering fix: alter incentives or enforce limits.

## 13. Practice Tasks

1. Verify the PD inequalities in five matrices.
2. Calculate the grim-trigger discount threshold.
3. Simulate tit-for-tat under action-observation noise.
4. Model API rate-limit compliance as a game.
5. Redesign payoffs using a deposit or quota.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Dominant defection creates Pareto-inferior mutual defection |
| Why it matters | Shows incentive/welfare misalignment |
| Most asked | Payoff order, equilibrium, repetition |
| Main comparison | PD needs incentive repair; Stag Hunt needs assurance |
| One-line answer | “Each rationally defects alone, so both end worse together.” |

---

# Battle of the Sexes

## 1. Overview

**Battle of the Sexes** is a coordination game in which both players prefer coordinating to separating, but each prefers a different coordinated outcome. A neutral modern analogy is two engineering teams choosing a shared tool: both require compatibility, while each favors its familiar tool. It matters for bargaining, standards, scheduling, and joint technical choices. Interviewers ask about multiple pure equilibria, the mixed equilibrium, and fairness versus stability.

## 2. Core Idea

Players share an interest in matching but conflict over where to match.

| Team A \ Team B | Tool X | Tool Y |
|---|---:|---:|
| **Tool X** | (2, 1) | (0, 0) |
| **Tool Y** | (0, 0) | (1, 2) |

`(X,X)` and `(Y,Y)` are PSNE. Neither strictly dominates: A prefers X coordination; B prefers Y coordination. There is also a mixed equilibrium. If A chooses X with probability `p` and B chooses X with probability `q`, indifference gives `q=1/3` for A and `p=2/3` for B in this matrix.

## 3. Important Subtopics

### Two asymmetric pure equilibria

Both coordinated outcomes are stable but distribute surplus differently. This creates bargaining conflict absent in symmetric coordination games.

### Mixed-strategy equilibrium

Each player's randomization makes the other indifferent. For the displayed payoffs, A mixes X with `2/3`; B mixes X with `1/3`. Miscoordination remains possible.

### Bargaining and commitment

Communication, alternating conventions, side payments, leadership, or commitment can select a coordinated outcome and address fairness.

### Correlated coordination

A shared random signal can recommend `(X,X)` or `(Y,Y)`, coordinate perfectly, and split benefits over time—better than independent mixing when recommendations are incentive compatible.

## 4. Real-World Example

Two teams must standardize on either Kafka or a managed queue. Both gain from one shared operational stack, but each team's expertise favors a different choice. Independent choice risks incompatible infrastructure. An architecture decision record, cost model, rotating ownership, or shared migration budget can create a credible selection process.

## 5. Diagrams / Mental Models

```text
                 coordinate?
                /           \
              yes            no
       X/X: A prefers       mismatch: both lose
       Y/Y: B prefers

shared goal: match | conflict: which match
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Define Battle of the Sexes.** Players prefer coordination but rank the two coordinated outcomes differently. | Common and conflicting interests | Pure conflict/zero-sum |
| 2 | **How many pure equilibria in the standard 2x2 game?** Two, the coordinated diagonal cells. | Mutual best responses | Reporting only one preferred cell |
| 3 | **Is either strategy dominant?** No; best action depends on what the other chooses. | Conditional response | Player preference implies dominance |
| 4 | **Why is selection difficult?** Each player advocates a different stable outcome. | Distributional conflict | Lack of any shared interest |
| 5 | **Is there a mixed equilibrium?** Yes; choose probabilities that make each opponent indifferent. | Indifference method | Use own payoff to solve own probability |
| 6 | **How derive B's mixing probability?** Equate A's expected payoff from X and Y; the opponent's mix makes A indifferent. | Cross-dependence | Equate B's payoffs for B's probability |
| 7 | **Does independent mixing coordinate well?** No; it assigns positive probability to costly mismatches. | Coordination loss | Calling mixed outcome efficient |
| 8 | **Can communication help?** Yes if it credibly aligns expectations; conflicting preferences may still cause strategic announcements. | Credibility/bargaining | Assuming cheap talk always selects fairly |
| 9 | **What is a correlated solution?** A shared signal recommends coordinated actions, potentially avoiding mismatch and sharing favored outcomes. | Correlation | Same as independent randomization |
| 10 | **Real system analogy?** Teams need one compatible standard but prefer different standards due to local costs. | Shared compatibility + preference conflict | Example with no coordination payoff |

## 7. Deep-Dive Questions

1. **Derive the displayed mixed equilibrium.** If B chooses X with `q`, A gets `2q` from X and `1-q` from Y, so `q=1/3`. If A chooses X with `p`, B gets `p` from X and `2(1-p)` from Y, so `p=2/3`.
2. **Why does each player use their preferred action more often here?** Mixing probabilities are determined by the opponent's indifference; with these symmetric-swapped payoffs, each player's probability happens to favor its preferred action.
3. **How can correlated equilibrium improve welfare?** A fair coin can select X/X or Y/Y and privately/publicly recommend it, eliminating mismatch while sharing favored outcomes.
4. **What does commitment do?** A credible early commitment can force coordination on the committer's preferred equilibrium, creating a first-mover advantage but possibly fairness concerns.
5. **How can repeated interaction create fairness?** Players can alternate between coordinated outcomes, giving each its preferred outcome in different periods while avoiding mismatches.

## 8. Comparison Tables

| Feature | Battle of the Sexes | Symmetric coordination | Prisoner's Dilemma |
|---|---|---|---|
| Shared desire to coordinate | Yes | Yes | Cooperation desirable but unstable |
| Ranking of coordinated outcomes | Conflicting | Same | Usually same |
| Pure equilibria | Two | Usually two | One defection equilibrium |
| Main issue | Bargaining plus coordination | Selection/assurance | Incentive conflict |
| Useful tool | Bargaining/correlation | Focal point/default | Enforcement/repetition |

## 9. Common Mistakes

- Treating it as zero-sum because preferences conflict.
- Missing one of the two pure equilibria.
- Solving a player's mixing probability from that same player's indifference incorrectly.
- Calling the mixed equilibrium socially best.
- Ignoring bargaining, commitment, and correlated signals.

## 10. Edge Cases / Special Cases

If mismatch payoffs differ, threat points alter bargaining. If one coordinated outcome gives the other player less than mismatch, it is no longer the standard game. Communication may select an equilibrium but not distribute surplus fairly. Simultaneous versus sequential moves changes commitment power. Repeated play permits alternation. Labels themselves can create focality.

## 11. How to Explain in Interview

“Battle of the Sexes is a coordination game with distributional conflict: both players prefer matching, but each prefers a different matched outcome. It has two pure Nash equilibria and typically one mixed equilibrium; communication, bargaining, or a correlated signal helps select and share outcomes.”

## 12. Quick Revision Notes

- Coordinate, but disagree where.
- Two asymmetric pure equilibria.
- No dominant strategy.
- Solve mixing by making the **other** player indifferent.
- Independent mixing risks mismatch; correlation can coordinate.

## 13. Practice Tasks

1. Find all equilibria in three differently parameterized matrices.
2. Derive mixed probabilities symbolically for diagonal payoffs `(a,b)` and `(c,d)`.
3. Compare independent mixing with a fair correlated signal.
4. Model two teams choosing a shared database technology.
5. Design an alternating repeated-game agreement.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Both want to match; each favors a different match |
| Why it matters | Models standards plus bargaining conflict |
| Most asked | Two PSNE and mixed-probability derivation |
| Main comparison | Unlike PD, coordination is stable; unlike symmetric coordination, preferences conflict |
| One-line answer | “We agree on being together, disagree on where, so selection and bargaining matter.” |
