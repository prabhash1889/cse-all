# Zero-Sum Games

## 1. Overview

### Definition

A **zero-sum game** is a strategic interaction in which one player's gain is exactly the other player's loss. If Player A receives payoff `x`, Player B receives `-x`, so the total payoff is always zero.

For a two-player matrix game, it is therefore enough to store one payoff in each cell:

| | B chooses Left | B chooses Right |
|---|---:|---:|
| **A chooses Up** | 3 | -1 |
| **A chooses Down** | 0 | 2 |

The numbers are A's payoffs. B's corresponding payoffs are `-3`, `1`, `0`, and `-2`.

### Why it matters

Zero-sum games give a precise model for **adversarial decision-making**. Each player chooses while assuming the opponent will act intelligently against them. This makes the model useful whenever a system must perform well under a worst-case opponent or environment.

### Where it is used in real systems

- Security: attacker versus defender resource allocation.
- Networks: anti-jamming and robust routing decisions.
- Auctions and trading: simplified competitive bidding models.
- Machine learning: adversarial training and minimax optimization.
- Algorithms: worst-case analysis, online algorithms, and game-tree search.
- Backend systems: choosing defensive capacity against hostile traffic patterns.

Not every competitive situation is literally zero-sum. Market participants, for example, may create or destroy total value. Zero-sum modeling is appropriate when the relevant payoff can reasonably be treated as transferred between two opposing sides.

### Why interviewers ask about it

The topic tests whether a candidate can:

- translate a story into a payoff matrix;
- distinguish a guaranteed payoff from an optimistic payoff;
- compute row minima, column maxima, and saddle points;
- reason about deterministic and randomized algorithms;
- derive probabilities rather than memorize formulas;
- recognize when linear programming is needed.

---

## 2. Core Idea

### Intuition

Player A wants to **maximize** the payoff shown in the matrix. Player B wants to **minimize** it. A cannot safely plan around B making a mistake, so A evaluates every action by its worst possible outcome. B reasons symmetrically.

- A asks: “For each row, what is the smallest payoff B can force? Which row makes that minimum as large as possible?” This is **maximin**.
- B asks: “For each column, what is the largest payoff A can obtain? Which column makes that maximum as small as possible?” This is **minimax**.

### Real-world analogy

Imagine a service operator choosing one of two defenses while an attacker chooses one of two attacks. The operator does not know the attack in advance. A defense is judged by the damage under its worst matching attack, not by its best outcome. Randomization may be necessary because a predictable defense can be exploited.

### Small example

Let the payoff to A be:

| | B: L | B: R | Row minimum |
|---|---:|---:|---:|
| **A: U** | 4 | 1 | **1** |
| **A: D** | 2 | 3 | **2** |
| **Column maximum** | **4** | **3** | |

### Step-by-step explanation

1. For row `U`, B would choose `R`, leaving A with `min(4,1)=1`.
2. For row `D`, B would choose `L`, leaving A with `min(2,3)=2`.
3. A chooses the better guarantee: `max(1,2)=2`. A's maximin value is 2.
4. If B chooses `L`, A can obtain `max(4,2)=4`.
5. If B chooses `R`, A can obtain `max(1,3)=3`.
6. B chooses the smaller exposure: `min(4,3)=3`. B's minimax value is 3.
7. Since `2 != 3`, no pure-strategy saddle point exists.
8. By randomizing between rows and columns, the players can close the gap. The mixed-strategy value is `2.5`.

The inequality

`maximin <= minimax`

always holds. The left side is what A can guarantee with pure strategies; the right side is the most B must allow with pure strategies.

---

## 3. Important Subtopics

### 3.1 Maximin and minimax strategies

#### What they mean

For payoff matrix `A = [a_ij]`, the row player chooses row `i` and the column player chooses column `j`.

- Row player's pure **maximin** value:
  `max_i min_j a_ij`
- Column player's pure **minimax** value:
  `min_j max_i a_ij`

A **maximin strategy** maximizes the player's guaranteed payoff. A **minimax strategy** minimizes the opponent's largest possible payoff.

#### Why they matter

These criteria separate a robust decision from a hopeful one. A maximin strategy does not claim to produce the largest possible payoff; it produces the best payoff the player can guarantee against every response.

#### Example

For

```text
      L  R
U     5 -2
D     1  3
```

- Row minima: `-2, 1`; maximin is `1`, achieved by `D`.
- Column maxima: `5, 3`; minimax is `3`, achieved by `R`.
- The pure-strategy security gap is `[1,3]`.

#### Common interview angle

Interviewers often give a matrix and ask for maximin, minimax, and whether a saddle point exists. State whose payoff the entries represent before calculating.

### 3.2 Saddle points

#### What a saddle point means

A cell is a **saddle point** when it is:

- the minimum value in its row, and
- the maximum value in its column.

At that cell, neither player benefits from changing strategy alone. Equivalently, pure maximin equals pure minimax.

#### Why it matters

A saddle point solves the game without randomization. Its payoff is the **value of the game**, and the corresponding row and column are optimal pure strategies.

#### Example

| | B: L | B: R | Row minimum |
|---|---:|---:|---:|
| **A: U** | 3 | 1 | 1 |
| **A: D** | 4 | **2** | **2** |
| **Column maximum** | 4 | **2** | |

The maximin row is `D`, and the minimax column is `R`; their intersection is `(D,R)=2`. It is the minimum of row `D` and maximum of column `R`, so `(D,R)` is the saddle point.

#### Multiple saddle points

A game may have multiple saddle-point cells. All saddle points have the same payoff value, although they may use different strategies.

#### Common interview angle

A frequent trap is to call the largest matrix entry a saddle point. The definition is relative to its row and column, not to the entire matrix.

### 3.3 Minimax theorem

#### Statement

For every finite two-player zero-sum game,

`max_p min_q p^T A q = min_q max_p p^T A q = v`,

where `p` and `q` are probability distributions over the row and column strategies, and `v` is the value of the game.

An equivalent and often easier-to-use form is:

`max_p min_j (p^T A)_j = min_q max_i (Aq)_i`.

#### Meaning

When mixed strategies are allowed, the best payoff A can guarantee equals the smallest upper bound B can enforce. There is no remaining maximin-minimax gap.

#### Why it matters

The theorem guarantees:

- an optimal mixed strategy exists for each player;
- the game has a well-defined value;
- security levels match;
- the row and column linear programs have equal optimum values.

#### What it does not say

- It does not say both players obtain payoff zero; “zero-sum” refers to the sum of payoffs, not the game's value.
- It does not say optimal strategies are always pure.
- It does not apply unchanged to arbitrary non-zero-sum games.
- It does not mean every mixed strategy is optimal.

#### Common interview angle

Explain the theorem in words before giving notation: “In a finite two-player zero-sum game, optimal randomization makes the row player's guaranteed payoff equal the column player's guaranteed upper bound.”

### 3.4 Matrix games

#### What they mean

A **matrix game** is a finite strategic game represented by a payoff matrix. Rows are A's actions, columns are B's actions, and each cell is the payoff after both choose simultaneously.

#### Dominance reduction

If one row gives A no more payoff than another row for every column, it is dominated and can be removed. For B, a column is dominated if another column gives A no greater payoff for every row.

Example:

```text
       C1 C2 C3
R1      4  2  3
R2      1  0  2
```

`R2` is dominated by `R1` because `R1` is at least as good for A in every column. A rational A never needs `R2`.

Strict dominance is safe to eliminate. Weak dominance requires more care because removing weakly dominated strategies can discard equilibria or alter the set of optimal strategies, even if the value is preserved in common zero-sum settings.

#### Game value and fairness

- `v > 0`: game favors A under the chosen payoff convention.
- `v < 0`: game favors B.
- `v = 0`: fair game in expected payoff.

#### Common interview angle

Candidates may be asked to preprocess a large matrix using dominance, find a saddle point, or reduce it to a `2 x 2` game.

### 3.5 Mixed strategies in zero-sum games

#### What they mean

A **mixed strategy** assigns probabilities to pure actions. A random draw chooses the actual action. Randomization hides intent and prevents the opponent from exploiting a predictable choice.

#### Expected payoff

If A uses probability vector `p` and B uses `q`, the expected payoff to A is:

`E[u_A] = p^T A q`.

#### Indifference principle

In a fully mixed equilibrium, each player chooses probabilities that make the opponent indifferent among every pure strategy used with positive probability.

For the `2 x 2` matrix

```text
      L  R
U     a  b
D     c  d
```

let A play `U` with probability `p`, and B play `L` with probability `q`.

B is indifferent between `L` and `R` when:

`pa + (1-p)c = pb + (1-p)d`.

Thus:

`p = (d-c) / (a-b-c+d)`.

A is indifferent between `U` and `D` when:

`qa + (1-q)b = qc + (1-q)d`,

so:

`q = (d-b) / (a-b-c+d)`.

The value is:

`v = (ad-bc) / (a-b-c+d)`,

provided the denominator is nonzero, the resulting probabilities lie in `[0,1]`, and no pure saddle point or boundary solution supersedes the fully mixed solution.

#### Worked example

For

```text
      L R
U     4 1
D     2 3
```

- `p = (3-2)/(4-1-2+3) = 1/4`.
- `q = (3-1)/(4-1-2+3) = 1/2`.
- `v = (4*3-1*2)/4 = 2.5`.

Check A's payoff against either column:

- against `L`: `(1/4)4 + (3/4)2 = 2.5`;
- against `R`: `(1/4)1 + (3/4)3 = 2.5`.

#### Support

The **support** of a mixed strategy is the set of pure strategies assigned positive probability. Strategies in support normally give the same expected payoff at equilibrium. Strategies outside support cannot do better for the player using them.

#### Common interview angle

The usual question is not “write the formula” but “derive the probabilities.” Set the opponent's relevant pure strategies equal, solve, then verify probabilities and unused strategies.

### 3.6 Linear programming formulation

#### Row player's linear program

Let A choose probabilities `p_i` and guarantee value `v`:

```text
maximize    v
subject to  sum_i p_i a_ij >= v    for every column j
            sum_i p_i = 1
            p_i >= 0
```

Each inequality says: even if B selects column `j`, A's expected payoff is at least `v`.

#### Column player's linear program

Let B choose probabilities `q_j` and enforce upper bound `w`:

```text
minimize    w
subject to  sum_j a_ij q_j <= w    for every row i
            sum_j q_j = 1
            q_j >= 0
```

Each inequality says: even if A selects row `i`, A's expected payoff is at most `w`.

#### Connection to duality

These programs are dual descriptions of the same strategic conflict. Weak duality gives `v <= w`; strong duality gives equality at optimum. This equality is the linear-programming form of the minimax theorem.

#### Shifting payoffs

Some textbook transformations divide variables by a positive game value. If entries or the value are non-positive, add a constant `K` to every payoff so all entries become positive, solve the shifted game, and subtract `K` from the final value. Adding the same constant changes no optimal strategy because it adds that constant to every expected payoff.

#### Complementary slackness intuition

- If A assigns positive probability to row `i`, B's corresponding row constraint is normally tight: that row earns exactly the value.
- If B assigns positive probability to column `j`, A's corresponding column constraint is normally tight.
- Slack constraints often correspond to unused pure strategies.

#### Common interview angle

Be able to explain every variable and constraint. A formulation without the probability-sum constraint or non-negativity is not a valid mixed strategy.

---

## 4. Real-World Example

### Backend rate-limit defense versus adaptive traffic

A backend team has two defense modes:

- `D1`: aggressive per-IP throttling;
- `D2`: computational proof-of-work challenge.

An attacker has two traffic patterns:

- `A1`: many requests from a few IPs;
- `A2`: a botnet spread across many IPs.

Payoff is the fraction of malicious requests blocked minus a latency penalty, scaled to points:

| Defender / Attacker | A1: concentrated | A2: distributed |
|---|---:|---:|
| **D1: IP throttle** | 8 | 1 |
| **D2: challenge** | 4 | 6 |

Pure analysis:

- Defender's row minima: `1,4`; maximin is 4 using `D2`.
- Attacker's column maxima: `8,6`; minimax is 6 using `A2`.
- No pure saddle point exists.

Mixed solution:

- Defender uses `D1` with probability `(6-4)/(8-1-4+6)=2/9`.
- Attacker uses `A1` with probability `(6-1)/9=5/9`.
- Game value is `(8*6-1*4)/9=44/9`, about `4.89`.

Operational interpretation: the service should vary defense modes roughly according to the calculated distribution if the payoff model is accurate. In production, costs, observability, false positives, learning attackers, and repeated interaction make the real problem richer than a one-shot matrix game. The matrix is still useful as a transparent baseline.

---

## 5. Diagrams / Mental Models

### Decision flow

```text
Build payoff matrix from A's perspective
                 |
       Compute row minima
       Compute column maxima
                 |
      maximin == minimax?
          /             \
        yes              no
        |                 |
 Pure saddle point   Remove dominated strategies
 solves the game          |
                    2x2? derive by indifference
                    larger? formulate an LP
                           |
                 verify probabilities, value,
                 and all unused strategies
```

### Mental model: lower and upper bounds

```text
A's guarantee                     B's enforced ceiling
maximin ---------------- v ---------------- minimax
               mixed strategies close the gap
```

### Strategy hierarchy

| Concept | Player A asks | Player B asks |
|---|---|---|
| Pure strategy | Which single row? | Which single column? |
| Security level | What minimum can I guarantee? | What maximum can I limit A to? |
| Mixed strategy | What row probabilities maximize the guarantee? | What column probabilities minimize the ceiling? |
| Equilibrium result | Expected payoff at least `v` | A's expected payoff at most `v` |

---

## 6. Common Interview Questions

### Q1. What is a zero-sum game?

**Answer:** It is a game where the players' payoffs add to a constant, conventionally zero. In a two-player zero-sum game, one payoff matrix is enough because B's payoff is the negative of A's.

**Interviewer expects:** constant total payoff, opposing objectives, and correct payoff convention.

**Common mistake:** Saying that every player's payoff must individually be zero.

### Q2. What is the difference between maximin and minimax?

**Answer:** Maximin selects the action with the largest worst-case payoff. Minimax selects the action that minimizes the opponent's best possible payoff. For an A-payoff matrix, A computes maximum of row minima and B computes minimum of column maxima.

**Interviewer expects:** formulas plus an intuitive worst-case explanation.

**Common mistake:** Taking row maxima for A or forgetting which player wants larger entries.

### Q3. Why is maximin never greater than minimax?

**Answer:** For every row `i` and column `j`, `min_j a_ij <= a_ij <= max_i a_ij`. Maximizing the left-side lower bound and minimizing the right-side upper bound preserves `max_i min_j a_ij <= min_j max_i a_ij`.

**Interviewer expects:** lower-bound versus upper-bound reasoning.

**Common mistake:** Claiming they are always equal for pure strategies.

### Q4. What is a saddle point?

**Answer:** A matrix cell that is a row minimum and a column maximum in an A-payoff matrix. It represents mutually optimal pure strategies and its payoff is the game value.

**Interviewer expects:** both conditions and the link to pure equilibrium.

**Common mistake:** Picking the global maximum or merely the intersection of an arbitrary maximin row and minimax column without checking equality.

### Q5. Can a game have more than one saddle point?

**Answer:** Yes. Different pure-strategy pairs may be saddle points, but all saddle points have the same payoff value.

**Interviewer expects:** multiplicity of strategies but uniqueness of value.

**Common mistake:** Assuming multiple saddle points imply multiple values.

### Q6. When are mixed strategies necessary?

**Answer:** They are necessary for an optimal solution when no pure saddle point exists and predictable pure play can be exploited. Randomization makes the opponent indifferent among the responses in its equilibrium support.

**Interviewer expects:** no pure saddle point, unpredictability, and indifference.

**Common mistake:** Saying players randomize because they are uncertain rather than because randomization is strategically optimal.

### Q7. How do you solve a `2 x 2` mixed game?

**Answer:** Assign one probability to each player's first action, equate the opponent's expected payoff from the pure actions that should be in support, solve both equations, compute the value, and verify probabilities fall in `[0,1]` and no excluded action is better.

**Interviewer expects:** derivation and verification.

**Common mistake:** Using a memorized formula without checking denominator, saddle points, or boundary solutions.

### Q8. State the minimax theorem.

**Answer:** Every finite two-player zero-sum game has a value in mixed strategies: the row player's maximum guaranteed expected payoff equals the column player's minimum enforceable expected-payoff ceiling.

**Interviewer expects:** finite, two-player, zero-sum, mixed strategies, equality.

**Common mistake:** Omitting mixed strategies or applying it directly to general-sum games.

### Q9. How does dominance simplify a matrix game?

**Answer:** A pure strategy that is never better than another strategy can be removed because an optimal player need not use it. Rows are compared from the maximizer's view; columns are compared from the minimizer's view.

**Interviewer expects:** opposite inequality directions for rows and columns.

**Common mistake:** Removing the larger column entries even though B wants smaller payoffs for A.

### Q10. How is a zero-sum game formulated as linear programming?

**Answer:** A maximizes a guaranteed value `v` subject to each column yielding expected payoff at least `v`, while probabilities are nonnegative and sum to one. B minimizes an upper bound `w` subject to every row yielding at most `w`.

**Interviewer expects:** objective, per-opponent-action constraints, normalization, and non-negativity.

**Common mistake:** Writing only the expected-payoff objective even though the opponent's strategy is unknown.

### Q11. What is the support of a mixed strategy?

**Answer:** It is the set of pure strategies given positive probability. At equilibrium, supported strategies are best responses and normally give the same expected payoff against the opponent's equilibrium strategy.

**Interviewer expects:** positive probability and indifference conditions.

**Common mistake:** Treating every available action as part of the support.

### Q12. Does zero-sum mean the game value is zero?

**Answer:** No. Zero-sum means the two payoffs add to zero. The equilibrium payoff to A can be positive, negative, or zero.

**Interviewer expects:** distinguish payoff sum from equilibrium value.

**Common mistake:** Confusing a fair game (`v=0`) with every zero-sum game.

---

## 7. Deep-Dive Questions

### 1. How is the minimax theorem related to linear-programming duality?

The row player's optimization is a primal LP and the column player's optimization is its dual after an equivalent standard-form transformation. Weak duality says A's guarantee cannot exceed B's ceiling. Strong duality says their optimal objective values are equal. That equality is precisely the game value promised by minimax.

### 2. What does complementary slackness tell us about equilibrium support?

If a strategy receives positive probability, the opponent's associated payoff constraint is tight. Thus every row used by A earns exactly `v` against optimal `q`, and every column used by B holds A to exactly `v` against optimal `p`. A strictly slack constraint generally identifies a strategy outside support.

### 3. Is the equilibrium strategy unique?

Not necessarily. A zero-sum game has a unique **value**, but either player may have several optimal probability distributions. Any optimal strategy for A can be paired with any optimal strategy for B to achieve the same value.

### 4. Why can adding a constant to all entries preserve optimal strategies?

For probability distributions `p` and `q`, replacing `A` by `A + KJ` gives expected payoff `p^T A q + K(p^T Jq) = p^T A q + K`, because both probability vectors sum to one. Every strategy pair shifts equally, so preferences and optimal strategies remain unchanged; only the value becomes `v+K`.

### 5. How do repeated zero-sum games relate to one-shot mixed strategies?

Independent sampling from a one-shot optimal mixed strategy guarantees the game value per round in expectation against any opponent. Over many rounds, empirical payoff tends toward that guarantee under standard concentration assumptions. However, exploitable patterns in a poor random generator or learning dynamics can matter operationally.

---

## 8. Comparison Tables

### Maximin versus minimax

| Aspect | Maximin | Minimax |
|---|---|---|
| Typical player in A-payoff matrix | Row player A | Column player B |
| Goal | Maximize guaranteed payoff | Minimize A's possible payoff ceiling |
| Pure calculation | Maximum of row minima | Minimum of column maxima |
| Bound | Lower bound on value | Upper bound on value |
| Equality | Together indicate saddle point | Together indicate saddle point |

### Pure versus mixed strategy

| Aspect | Pure strategy | Mixed strategy |
|---|---|---|
| Choice | One action with probability 1 | Distribution over actions |
| Predictability | Fully predictable if known | Individual action remains uncertain |
| Always sufficient? | No | Yes for finite two-player zero-sum games |
| Solution method | Row/column scan | Indifference equations or LP |
| Typical use | Saddle point exists | No pure saddle point |

### Saddle point versus mixed equilibrium

| Aspect | Saddle point | Mixed equilibrium |
|---|---|---|
| Strategy type | Pure | May randomize |
| Existence | Not guaranteed | Guaranteed in finite zero-sum games |
| Detection | Maximin equals minimax in pure matrix | Solve probabilities/LP |
| Value | Cell payoff | Expected payoff |
| Deviation | Neither pure action improves outcome | No unilateral distribution change improves guarantee |

### Zero-sum versus general-sum game

| Aspect | Zero-sum | General-sum |
|---|---|---|
| Total payoff | Constant | Can vary by outcome |
| Objectives | Exactly opposed | May conflict or align partly |
| Representation | One payoff matrix is enough | Usually one payoff per player |
| Main solution concept | Minimax equilibrium | Nash equilibrium |
| Equilibrium value | Unique value | Payoffs can vary across equilibria |

---

## 9. Common Mistakes

- Confusing “sum of payoffs is zero” with “each payoff is zero.”
- Calculating maximum of row maxima instead of maximum of row minima.
- Forgetting that columns are evaluated by a minimizer when entries are A's payoffs.
- Calling the largest entry a saddle point.
- Assuming pure maximin and minimax are always equal.
- Using mixed-strategy formulas before checking for a pure saddle point.
- Making the wrong player indifferent when deriving probabilities: A's probabilities control B's incentives and vice versa.
- Accepting probabilities outside `[0,1]`; this signals a boundary solution, dominance, or incorrect support.
- Eliminating weakly dominated actions without considering whether equilibrium sets matter.
- Forgetting non-negativity or sum-to-one constraints in an LP.
- Treating expected payoff as a guaranteed outcome in each individual play.
- Modeling a variable-sum real-world interaction as zero-sum without justifying the abstraction.

---

## 10. Edge Cases / Special Cases

1. **Equal maximin and minimax:** A pure saddle point exists; mixed strategies are unnecessary for finding the value.
2. **Multiple saddle points:** All have identical payoff values.
3. **Constant rows or columns:** These often make dominance or a saddle point immediately visible.
4. **Zero formula denominator:** A fully mixed `2 x 2` interior solution cannot be obtained using the standard formula; inspect dominance, parallel payoff differences, and boundary solutions.
5. **Probability outside `[0,1]`:** The assumed full support is wrong. Try a smaller support or pure strategy.
6. **Degenerate games:** More constraints may be tight than there are positive-probability strategies, so support cannot always be inferred from tightness alone.
7. **Rectangular matrices:** The game need not have equal numbers of strategies. LP handles `m x n` games directly.
8. **Negative payoffs:** The basic LP remains valid. Positivity matters only for certain textbook substitutions.
9. **Constant-sum games:** Subtracting or redistributing the constant converts them to strategically equivalent zero-sum games.
10. **Approximate solutions:** In large games, algorithms may return an `epsilon`-equilibrium where neither player can improve by more than `epsilon`.
11. **Sequential games:** A normal-form matrix may become exponentially large; backward induction or game-tree methods may be better representations.
12. **Imperfect payoff estimates:** The computed equilibrium is only as reliable as the payoff model; sensitivity analysis is important in systems work.

---

## 11. How to Explain in Interview

> A two-player zero-sum game models strict opposition: one player's payoff is the negative of the other's. From the row player's payoff matrix, I compute the maximum of row minima for the maximin guarantee and the minimum of column maxima for the minimax ceiling. If they are equal, their intersection is a saddle point and pure strategies solve the game. Otherwise, the players randomize; probabilities are chosen to make the opponent indifferent, or found using dual linear programs. The minimax theorem guarantees that these optimal mixed strategies meet at one game value.

---

## 12. Quick Revision Notes

### Key definitions

- **Zero-sum:** `u_A + u_B = 0` for every outcome.
- **Maximin:** largest payoff a player can guarantee.
- **Minimax:** smallest upper bound the opponent can enforce.
- **Saddle point:** row minimum and column maximum.
- **Mixed strategy:** probability distribution over pure actions.
- **Game value:** equilibrium expected payoff to the row player.
- **Support:** actions with positive probability.

### Must-remember facts

- Pure `maximin <= minimax`.
- Equality in pure strategies means a saddle point.
- Mixed-strategy equality is guaranteed for finite two-player zero-sum games.
- Optimal strategies may be non-unique; the value is unique.
- A's randomization makes B indifferent, and B's randomization makes A indifferent.
- Expected payoff is `p^T A q`.
- LP duality explains minimax equality.

### Common comparisons

- Pure: fixed action; mixed: probability distribution.
- Saddle point: pure equilibrium; minimax equilibrium: may be mixed.
- Zero-sum: exactly opposed; general-sum: payoffs need not oppose.

### Interview traps

- State whose payoff appears in the matrix.
- Check pure saddle point before mixed calculations.
- Verify all probabilities and unused strategies.
- Do not equate zero-sum with zero value.

---

## 13. Practice Tasks

1. For each matrix, compute row minima, column maxima, maximin, minimax, and all saddle points:

   ```text
   A = [ [3, 1], [4, 2] ]
   B = [ [2, -1], [0, 3] ]
   C = [ [1, 1, 0], [2, 1, -1] ]
   ```

2. Solve Matching Pennies, `[[1,-1],[-1,1]]`, by indifference and verify its value.
3. Solve `[[4,1],[2,3]]` without using the memorized formula; derive both equations.
4. Create a `3 x 3` game containing one dominated row and one dominated column, then reduce it.
5. Formulate the row and column LPs for:

   ```text
   [ [2, -1, 4],
     [0,  3, 1] ]
   ```

6. Implement a C++ function that scans an integer matrix and returns the pure maximin, minimax, and saddle-point coordinates.
7. Add assertions for a matrix with no saddle point and one with multiple saddle points.
8. Model a simplified API defender-versus-attacker scenario. Justify each payoff and discuss where the zero-sum assumption breaks.
9. Given candidate distributions `p` and `q`, verify optimality by computing payoff against every pure response.
10. Explain why adding 10 to every entry changes the value but not optimal strategies.

Suggested C++ exercise interface:

```cpp
struct PureSolution {
    int maximin;
    int minimax;
    std::vector<std::pair<int, int>> saddlePoints;
};

PureSolution analyze(const std::vector<std::vector<int>>& payoff);
```

Target complexity: `O(mn)` time. Keep row minima and column maxima, then report cells satisfying both conditions.

---

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | One player's gain equals the other's loss |
| A's pure guarantee | `max_i min_j a_ij` |
| B's pure ceiling | `min_j max_i a_ij` |
| Saddle point | Row minimum + column maximum |
| Pure solution test | `maximin == minimax` |
| Mixed payoff | `p^T A q` |
| Mixed equilibrium rule | Make supported opponent actions indifferent |
| Minimax theorem | Optimal mixed maximin equals optimal mixed minimax |
| Row LP | Maximize `v`; expected payoff against every column is at least `v` |
| Column LP | Minimize `w`; payoff from every row is at most `w` |
| Value uniqueness | Value is unique; optimal strategies may not be |
| Most asked tasks | Find saddle point, solve `2 x 2`, explain minimax, write LP |

**One-line interview answer:** A finite two-player zero-sum game has a single equilibrium value: use a saddle point when pure maximin equals minimax, otherwise use optimal randomization—computed by indifference or dual linear programs—to guarantee that value.
