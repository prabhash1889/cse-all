# Mixed Strategies in Game Theory

## 1. Overview

### Definition

A **mixed strategy** is a probability distribution over a player's available pure strategies. Instead of always choosing one action, the player randomizes: for example, choosing action `A` with probability `p` and action `B` with probability `1-p`.

A **mixed-strategy Nash equilibrium** is a strategy profile in which every player's probability distribution is a best response to the other players' distributions. No player can improve their expected payoff by changing their own distribution alone.

This guide develops five connected ideas:

1. mixed-strategy equilibrium;
2. expected utility;
3. the indifference principle;
4. computing mixed Nash equilibria; and
5. the support of a mixed strategy.

### Why it matters

Randomization is useful when predictable behavior can be exploited. Mixed strategies also guarantee a broader notion of equilibrium: every finite game has at least one Nash equilibrium, possibly mixed, even when no pure-strategy equilibrium exists.

### Where it is used in real systems

- **Cybersecurity:** random inspection, patrol, and defense schedules prevent attackers from targeting a predictable gap.
- **Distributed systems:** randomized backoff reduces repeated collisions among competing clients.
- **Networking:** probabilistic channel access helps nodes share a medium.
- **Online platforms:** randomized experiments and allocation policies balance learning and reward.
- **Algorithms:** randomized choices can make worst-case exploitation harder.
- **Auctions and markets:** bidders may randomize when competitors observe or infer deterministic rules.

These systems are not always literal one-shot games, but the same strategic logic applies: when another actor adapts to your behavior, unpredictability can have value.

### Why interviewers ask about it

The topic tests whether a candidate can translate probability into payoffs, distinguish pure and mixed actions, set up equations, reason about incentives, and verify an answer instead of merely solving algebra. It also exposes a common conceptual trap: in equilibrium, a player's probabilities are usually determined by making the **other player** indifferent.

---

## 2. Core Idea

### Intuition

Suppose a goalkeeper always dives left during penalties. A striker learns this and shoots right. If the goalkeeper always dives right instead, the striker adapts again. A probability distribution can remove this exploitable pattern.

Randomization does not mean indecision. It can be a deliberate commitment to frequencies that deny the opponent a profitable prediction.

### Real-world analogy: security patrols

A guard can patrol Gate A or Gate B. An intruder attacks the gate believed less likely to be guarded. A fixed patrol is exploitable; a suitable random schedule makes the intruder indifferent between targets. The intruder may also randomize, making the guard indifferent between patrol routes.

### Small example: Matching Pennies

Two players simultaneously choose Heads (`H`) or Tails (`T`). Player 1 wins when the choices match; Player 2 wins when they differ.

| Player 1 \ Player 2 | H | T |
|---|---:|---:|
| **H** | `(1, -1)` | `(-1, 1)` |
| **T** | `(-1, 1)` | `(1, -1)` |

There is no pure Nash equilibrium:

- if the choices match, Player 2 wants to switch;
- if they differ, Player 1 wants to switch.

Let Player 1 choose `H` with probability `p`, and Player 2 choose `H` with probability `q`.

Player 1's payoff from choosing pure `H` against Player 2's mix is

\[
U_1(H,q)=q(1)+(1-q)(-1)=2q-1.
\]

Player 1's payoff from pure `T` is

\[
U_1(T,q)=q(-1)+(1-q)(1)=1-2q.
\]

For Player 1 to willingly use both actions, these must be equal:

\[
2q-1=1-2q \Rightarrow q=\frac12.
\]

Similarly, Player 2 is indifferent only when `p=1/2`. Therefore the unique equilibrium is

\[
p^*=q^*=\frac12,
\]

and each player's expected payoff is `0`.

### Step-by-step mental procedure

```text
1. Name each player's mixing probabilities.
2. Guess which pure actions have positive probability (the support).
3. Compute each pure action's expected payoff against the opponent's mix.
4. Equalize payoffs among actions in the proposed support.
5. Solve the probability and normalization equations.
6. Check probabilities are in [0, 1].
7. Check excluded actions do not give a higher payoff.
```

The equal-payoff equations provide a **candidate**. The inequality checks establish that it is actually an equilibrium.

---

## 3. Important Subtopics

### 3.1 Mixed-strategy equilibrium

#### What it means

For player `i`, let `S_i` be the finite set of pure strategies and let `\Delta(S_i)` denote all probability distributions over `S_i`. A mixed profile `\sigma^*=(\sigma_1^*,\ldots,\sigma_n^*)` is a Nash equilibrium if, for every player `i` and every alternative mixed strategy `\sigma_i`,

\[
u_i(\sigma_i^*,\sigma_{-i}^*) \ge u_i(\sigma_i,\sigma_{-i}^*).
\]

The notation `\sigma_{-i}` means the strategies of everyone except player `i`.

#### Why it matters

It extends equilibrium analysis to games with cycling incentives and models deliberate unpredictability. A pure strategy is a special mixed strategy that assigns probability `1` to one action, so the mixed definition includes pure equilibria.

#### Example

In Matching Pennies, `(1/2, 1/2)` for each player is an equilibrium. Any bias by Player 1 allows Player 2 to favor the action that exploits it, and vice versa.

#### Common interview angle

Interviewers often ask whether randomization itself creates value. The accurate answer is: in a mixed equilibrium, all pure strategies used with positive probability give the same expected payoff. The mix protects the player strategically by shaping the opponent's incentives; the player is not strictly better off among the actions they actually mix over.

### 3.2 Expected utility

#### What it means

Expected utility is the probability-weighted average of possible payoffs. For two players with payoff matrix `A`, row-player distribution `x`, and column-player distribution `y`,

\[
U_1(x,y)=x^T A y.
\]

Expanded over individual outcomes,

\[
U_i(\sigma)=\sum_{s\in S}\Pr_\sigma(s)u_i(s),
\]

where independent mixing gives `Pr(s)=\prod_j \sigma_j(s_j)`.

#### Why it matters

Players compare expected payoffs before choosing best responses. The expectation converts several probabilistic outcomes into one number that can be optimized.

#### Example

An action yields payoff `8` with probability `0.25` and payoff `0` otherwise. Its expected utility is

\[
0.25(8)+0.75(0)=2.
\]

If another action guarantees payoff `1.5`, an expected-utility maximizer chooses the risky action, although its most common realized payoff is `0`.

#### Common interview angle

Candidates confuse expected utility with the most likely payoff or with a guaranteed payoff. Expectation describes the long-run average or ex-ante evaluation, not what must happen in one play.

### 3.3 Indifference principle

#### What it means

If a player assigns positive probability to two or more pure strategies in equilibrium, those strategies must give that player the same expected payoff against the opponents' equilibrium mix.

If one supported action gave a strictly higher payoff, shifting all probability toward it would improve the player's payoff, contradicting equilibrium.

Formally, if `s_i` is in the support of `\sigma_i^*`, then

\[
u_i(s_i,\sigma_{-i}^*) = \max_{t_i\in S_i}u_i(t_i,\sigma_{-i}^*).
\]

An action outside the support may tie this value, but it may not exceed it.

#### Why it matters

This principle produces the equations used to calculate equilibrium probabilities.

#### Example

If Player 1 mixes between `Up` and `Down`, the column player's probability `q` must satisfy

\[
U_1(Up,q)=U_1(Down,q).
\]

Notice that solving Player 1's indifference equation gives **Player 2's** mixing probability `q`.

#### Common interview angle

The classic trap is setting Player 1's own probability to make Player 1 indifferent. A player's expected payoff from choosing a pure action depends on the opponent's mix, not on probabilities the player would use after that pure choice has been fixed.

### 3.4 Computing mixed Nash equilibria

#### General `2 x 2` game

Write payoffs as follows:

| Row \ Column | Left | Right |
|---|---:|---:|
| **Up** | `(a, e)` | `(b, f)` |
| **Down** | `(c, g)` | `(d, h)` |

Let Row play `Up` with probability `p`; let Column play `Left` with probability `q`.

Row is indifferent when

\[
qa+(1-q)b=qc+(1-q)d.
\]

When the denominator is nonzero,

\[
q^*=\frac{d-b}{a-b-c+d}.
\]

Column is indifferent when

\[
pe+(1-p)g=pf+(1-p)h,
\]

so

\[
p^*=\frac{h-g}{e-f-g+h}.
\]

These formulas are shortcuts, not substitutes for verification. A zero denominator, a probability outside `[0,1]`, weak ties, or a dominated strategy requires separate analysis.

#### Fully worked example

Consider:

| Row \ Column | L | R |
|---|---:|---:|
| **U** | `(3, 1)` | `(0, 2)` |
| **D** | `(1, 3)` | `(2, 0)` |

Let Row use `U` with probability `p`, and Column use `L` with probability `q`.

Row's pure-action payoffs are

\[
U_1(U)=3q, \qquad U_1(D)=q+2(1-q)=2-q.
\]

Equating them:

\[
3q=2-q \Rightarrow q=\frac12.
\]

Column's pure-action payoffs are

\[
U_2(L)=p+3(1-p)=3-2p,
\]

\[
U_2(R)=2p.
\]

Equating them:

\[
3-2p=2p \Rightarrow p=\frac34.
\]

Thus the completely mixed candidate is

\[
\sigma_1=(3/4,1/4),\qquad \sigma_2=(1/2,1/2).
\]

Verification:

- Row gets `3/2` from either `U` or `D`.
- Column gets `3/2` from either `L` or `R`.
- There are no excluded actions in this `2 x 2` full-support case.

Therefore it is a mixed Nash equilibrium.

#### Common interview angle

An interviewer may give a matrix and expect four stages: mark pure best responses, identify pure equilibria, solve mixed candidates, and verify. Jumping directly to equations can miss pure equilibria or special cases.

### 3.5 Support of a mixed strategy

#### What it means

The support of `\sigma_i` is

\[
\operatorname{supp}(\sigma_i)=\{s_i\in S_i:\sigma_i(s_i)>0\}.
\]

A strategy is **fully mixed** if every available pure strategy is in its support. A **degenerate** mixed strategy has support size one and is simply a pure strategy.

#### Why it matters

The support tells us which indifference equations to impose. In larger games, equilibrium computation commonly uses **support enumeration**: guess supports, solve equalities and probability sums, then verify inequalities for excluded strategies.

#### Example

If `\sigma_1=(0.6,0.4,0)` over `{A,B,C}`, its support is `{A,B}`. In equilibrium, `A` and `B` must tie for maximum expected payoff. `C` must give no more than that value.

#### Common interview angle

The converse of the indifference principle is false. If two actions tie, the player is allowed—but not required—to put positive probability on both. Therefore an excluded action can be a best response with probability zero.

### 3.6 Dominance and mixed strategies

A strictly dominated pure strategy cannot appear with positive probability in a Nash equilibrium. More strongly, a strategy strictly dominated by a mixed strategy can also be eliminated. Weak dominance is delicate: eliminating weakly dominated actions can remove Nash equilibria, especially equilibria based on payoff ties.

### 3.7 Best-response geometry

Expected payoff is linear in a player's own mixing probabilities when opponents' strategies are fixed. Therefore a best response places probability only on pure strategies that maximize payoff. Mixing is optimal precisely on boundaries where multiple pure best responses tie.

---

## 4. Real-World Example

### Randomized exponential backoff in a distributed system

Imagine two clients repeatedly trying to acquire a shared communication channel. If both retry after exactly `100 ms`, they collide again. A deterministic response synchronizes them into repeated failure.

```text
Client A fails ── waits 100 ms ── retries ┐
                                          ├── collision again
Client B fails ── waits 100 ms ── retries ┘
```

Random delay breaks the symmetry:

```text
Client A fails ── samples delay 37 ms ── succeeds
Client B fails ── samples delay 81 ms ── observes busy channel, retries later
```

The connection to mixed strategies is conceptual:

- pure strategies are possible retry times or retry windows;
- a mixed strategy is a distribution over those times;
- payoff reflects latency, throughput, and collision cost;
- an adaptive competitor can exploit a deterministic retry;
- randomization reduces predictability and correlated collisions.

Real backoff protocols are repeated stochastic processes rather than simple one-shot Nash games. Network load, asymmetric clients, and protocol rules affect the optimal distribution. Still, mixed-strategy reasoning explains why randomization is not noise—it is a coordination and anti-exploitation tool.

### Security allocation variant

Suppose a service has one expensive inspection slot and two endpoints. The defender chooses which endpoint to inspect; an attacker chooses one to target. If attack values differ, equilibrium probabilities need not be `1/2`. The defender's probability is chosen to equalize the attacker's expected returns, while the attacker's probability equalizes the defender's benefits from inspecting either endpoint. This is the same indifference calculation as a payoff matrix, now tied to operational costs.

---

## 5. Diagrams / Mental Models

### Pure versus mixed choice

```text
Pure strategy
    choose A with certainty
    P(A)=1, P(B)=0

Mixed strategy
    sample from a distribution
    P(A)=p, P(B)=1-p
```

### Equilibrium dependency

```text
Player 1's mixing probability p
             │
             └── makes Player 2 indifferent

Player 2's mixing probability q
             │
             └── makes Player 1 indifferent
```

### Support-enumeration flowchart

```text
Start
  │
  ├─ Find pure best responses and pure Nash equilibria
  │
  ├─ Choose candidate support for each player
  │
  ├─ Equalize supported actions' expected payoffs
  │
  ├─ Add probability-sum equations
  │
  ├─ Solve
  │    └─ invalid/negative probability? Reject support
  │
  ├─ Check unsupported actions do not pay more
  │    └─ violated inequality? Reject support
  │
  └─ Candidate passes → Nash equilibrium
```

### Three levels that should not be confused

| Level | Meaning | Example |
|---|---|---|
| Pure action | One deterministic choice | Play `U` now |
| Mixed strategy | A distribution chosen before play | `P(U)=0.7` |
| Realized outcome | Actions actually sampled | This round produced `(U,L)` |

---

## 6. Common Interview Questions

### Q1. What is a mixed strategy?

**Answer:** A mixed strategy is a probability distribution over a player's pure strategies. It specifies how frequently or with what probability each action is selected.

**Interviewer expects:** probabilities are nonnegative, sum to one, and represent deliberate randomization.

**Common mistake:** calling a sequence such as `A, B, A, B` mixed merely because it contains both actions. If the pattern is predictable, it is not randomization in the strategic sense.

### Q2. What is a mixed-strategy Nash equilibrium?

**Answer:** It is a profile of mixed strategies in which each player's distribution is a best response to the others. No unilateral change in probabilities can increase expected payoff.

**Interviewer expects:** best response, expected payoff, unilateral deviation.

**Common mistake:** saying every player must randomize. A Nash equilibrium in mixed strategies may include pure strategies because pure strategies are degenerate distributions.

### Q3. Why must supported strategies be indifferent?

**Answer:** If one supported pure strategy paid strictly less than another, moving its positive probability to the better action would increase expected utility. That would contradict best-response behavior.

**Interviewer expects:** a short deviation argument.

**Common mistake:** claiming all available strategies must tie. Only supported strategies must tie at the maximum; excluded strategies may be worse or tied.

### Q4. How do you compute expected utility from a payoff matrix?

**Answer:** Multiply each outcome's payoff by the probability of that outcome and sum. With independent row and column distributions `x` and `y`, the row player's expected payoff is `x^T A y`.

**Interviewer expects:** joint outcome probability is the product of independent action probabilities.

**Common mistake:** averaging matrix entries equally even when outcomes have unequal probabilities.

### Q5. Whose indifference equation determines Player 1's probability?

**Answer:** Player 1's probability is normally found from Player 2's indifference equation. Player 1 adjusts frequencies so Player 2 has no strict preference among Player 2's supported actions.

**Interviewer expects:** the cross-player relationship.

**Common mistake:** using Player 1's payoff equation to solve Player 1's own probability.

### Q6. What is the support of a mixed strategy?

**Answer:** It is the set of pure strategies receiving strictly positive probability.

**Interviewer expects:** zero-probability actions are excluded and support determines which equalities are required.

**Common mistake:** defining support as all legal strategies.

### Q7. Can an action outside the support be a best response?

**Answer:** Yes. It may tie the equilibrium payoff and still receive probability zero. It cannot give a strictly higher payoff, because then the current mix would not be a best response.

**Interviewer expects:** distinguish necessity from converse.

**Common mistake:** assuming indifference forces positive probability.

### Q8. Can a strictly dominated strategy be used in equilibrium?

**Answer:** No. A strictly dominated strategy is always worse than another strategy, so it cannot be a best response and cannot receive positive equilibrium probability.

**Interviewer expects:** this includes strict domination by an appropriate mixed strategy.

**Common mistake:** making the same blanket claim for weakly dominated strategies.

### Q9. Does randomization increase a player's equilibrium payoff?

**Answer:** Not by choosing among supported actions after the opponent's mix is fixed; those actions tie. The strategic value is that the distribution changes the opponent's incentives and prevents exploitation. Compared with committing to an exploitable pure action, the equilibrium mix may protect payoff.

**Interviewer expects:** separate own indifference from strategic unpredictability.

**Common mistake:** saying randomness automatically gives a higher numerical payoff.

### Q10. Why is solving equalities not enough?

**Answer:** Equalities only ensure supported actions tie. We must also check valid probabilities, normalization, and that every excluded action gives no greater payoff. Otherwise the candidate is not a best response profile.

**Interviewer expects:** feasibility and inequality checks.

**Common mistake:** accepting negative probabilities or ignoring a profitable third action.

### Q11. What does Nash's existence theorem say here?

**Answer:** Every finite strategic-form game has at least one Nash equilibrium in mixed strategies. It does not say the equilibrium is unique, pure, efficient, easy to compute, or easy to coordinate on.

**Interviewer expects:** finite game and mixed equilibrium.

**Common mistake:** interpreting existence as uniqueness or social optimality.

### Q12. How would you find equilibria in a `3 x 3` game?

**Answer:** First eliminate strictly dominated strategies when safe and mark pure equilibria. Then enumerate plausible supports, equalize payoffs within each support, enforce probabilities summing to one, and verify all excluded-action inequalities.

**Interviewer expects:** support enumeration and verification.

**Common mistake:** assuming every `3 x 3` equilibrium has full support.

---

## 7. Deep-Dive Questions

### 1. Why is expected payoff linear in a player's own mixed strategy?

Fix opponents' strategies. If player `i` assigns probabilities `x_k` to pure actions `k`, then

\[
U_i(x,\sigma_{-i})=\sum_k x_k U_i(k,\sigma_{-i}).
\]

This is a weighted sum of constants and is therefore linear in `x`. Consequently, a maximum is reached by putting probability only on pure actions with maximal payoff. Interior mixing occurs when multiple maxima tie.

### 2. What happens when the indifference equation has a zero denominator?

The payoff difference between the two actions may be constant rather than crossing as the opponent changes probability. There are three possibilities:

- one action is always strictly better, so both cannot be in equilibrium support;
- both actions tie for every opponent probability, creating many best responses;
- another support or boundary probability must be considered.

Blind use of the `2 x 2` formula would divide by zero and hide the game structure.

### 3. Why can weakly dominated strategies sometimes appear in Nash equilibrium?

Weak domination allows equality for some opponent actions. If equilibrium play stays entirely in those tie cases, the weakly dominated strategy can still be a best response. Therefore iterated deletion of weakly dominated strategies can remove Nash equilibria, unlike deletion of strictly dominated strategies.

### 4. How does a mixed strategy differ from a correlated strategy?

In a standard mixed-strategy profile, players randomize independently, so joint probabilities factor into products. In a correlated equilibrium, a shared signal can correlate recommendations. Each player must prefer following their recommendation given the information it conveys. Correlation can produce joint distributions unavailable through independent mixing and may improve payoffs.

### 5. Is the equilibrium mixture the same as randomizing independently in every repeated round?

For a one-shot model, a mixed strategy is a distribution over actions. Independent sampling each repeated round implements those marginal frequencies, but repeated games introduce histories, learning, punishment, and correlated behavior. A deterministic sequence with the right long-run frequency can still be exploitable if the opponent predicts its next action. Frequencies alone do not capture strategic unpredictability.

---

## 8. Comparison Tables

### Pure versus mixed strategy

| Feature | Pure strategy | Mixed strategy |
|---|---|---|
| Choice | One action with certainty | Distribution over actions |
| Probabilities | One entry is `1`; others `0` | Multiple entries may be positive |
| Predictability | Often predictable | Can prevent exploitation |
| Payoff evaluation | Matrix cell or expected payoff against a mix | Expected payoff over outcomes |
| Relationship | Special case of a mixed strategy | Generalization of pure strategy |

### Pure versus mixed Nash equilibrium

| Feature | Pure Nash equilibrium | Mixed Nash equilibrium |
|---|---|---|
| Player strategies | Degenerate distributions | At least one player may genuinely randomize |
| How found | Mutual best-response cells | Indifference equations plus inequalities |
| Existence in every finite game | No | Yes |
| Realized play | Equilibrium action profile occurs | Individual realized profiles need not be equilibria |

### Supported versus unsupported action

| Property at equilibrium | Supported action | Unsupported action |
|---|---|---|
| Probability | Strictly positive | Zero |
| Expected payoff | Equals maximum payoff | At most maximum payoff |
| Must be a best response | Yes | No; but may tie as one |
| Used in indifference equations | Yes | Usually used in inequality checks |

### Mixed versus behavioral versus correlated strategy

| Concept | Randomization | Independence | Typical setting |
|---|---|---|---|
| Mixed strategy | Over complete pure strategies | Players mix independently | Normal-form games |
| Behavioral strategy | Separately at information sets | A player's local randomizations specified directly | Extensive-form games |
| Correlated strategy | Shared signal recommends actions | Joint choices may be correlated | Mediated coordination |

In finite games with perfect recall, mixed and behavioral strategies are outcome-equivalent in the relevant sense, but they are conceptually different objects.

---

## 9. Common Mistakes

1. **Solving for the wrong probability:** use one player's indifference condition to find the opponent's mix.
2. **Forgetting normalization:** every probability is nonnegative and the probabilities in a distribution sum to one.
3. **Treating expected payoff as guaranteed payoff:** a single realization can differ sharply from the expectation.
4. **Equalizing every legal action:** only the proposed support must tie; excluded actions require inequalities.
5. **Assuming a tie forces mixing:** an action can be an unused best response.
6. **Skipping pure equilibria:** a game may have both pure and mixed equilibria.
7. **Accepting probabilities outside `[0,1]`:** this rejects the proposed support; it is not an exotic equilibrium.
8. **Using strict-dominance logic for weak dominance:** weakly dominated actions can occur in Nash equilibria.
9. **Confusing a mixed profile with a realized action profile:** sampling may produce a cell that is not itself a pure equilibrium.
10. **Assuming equal mixing:** probabilities are `1/2` only in appropriately symmetric payoff structures.
11. **Ignoring all opponent actions outside support:** one of them may be a profitable deviation.
12. **Confusing mixed and correlated equilibrium:** standard mixed strategies do not use a shared correlation device.

---

## 10. Edge Cases / Special Cases

### Boundary solutions

If solving yields `p=0` or `p=1`, the candidate is not completely mixed. It represents a smaller support and should be checked as a pure or semi-mixed equilibrium.

### Invalid interior probabilities

If `p<0` or `p>1`, the assumed support cannot be an equilibrium. Reconsider dominance, pure equilibria, or another support.

### Continuum of equilibria

Payoff ties can create infinitely many equilibria. For example, if a player receives the same payoff from every action against a range of opponent mixtures, their best-response set can be a whole interval.

### Semi-mixed equilibria

One player may use a pure strategy while another mixes among several best responses. Do not assume support sizes must match in general games.

### More than two actions

For support size `k`, make `k` supported pure strategies share one payoff value, add a probability-sum equation, and verify excluded actions. Redundant equations or rank deficiencies may signal no solution or a continuum.

### Zero-sum special structure

In two-player zero-sum games, equilibrium strategies are minimax strategies and all equilibria yield the same game value. Linear programming can compute them efficiently. General-sum games do not share these conclusions.

### Degenerate games

Degeneracy creates extra best responses, multiple supports representing the same equilibrium, or continua. Support-enumeration implementations must deduplicate candidates and tolerate exact ties carefully.

### Numerical precision

Floating-point solutions may produce values such as `-1e-12` or make theoretically equal payoffs differ slightly. Code should use a justified tolerance, normalize carefully, and still distinguish numerical noise from a genuinely violated inequality.

---

## 11. How to Explain in Interview

> A mixed strategy is a probability distribution over pure actions. In a mixed Nash equilibrium, each player's distribution is a best response to the others, so no unilateral probability change improves expected payoff. To compute one, I choose candidate supports, make each player indifferent among their supported actions using the opponent's probabilities, solve the equations, and then verify probabilities and all excluded-action inequalities. The important detail is that my mixing probability makes the other player indifferent.

For a payoff-matrix problem, follow immediately with the equations rather than stopping at the definition.

---

## 12. Quick Revision Notes

### Key definitions

- **Pure strategy:** one action selected with probability `1`.
- **Mixed strategy:** a probability distribution over pure strategies.
- **Support:** actions with strictly positive probability.
- **Expected utility:** probability-weighted payoff.
- **Mixed Nash equilibrium:** every mix is a best response to opponents' mixes.
- **Fully mixed:** every pure strategy has positive probability.

### Important points

- Supported actions must all achieve the maximum expected payoff.
- Unsupported actions may tie but cannot pay more.
- Player 1's mixture is obtained by making Player 2 indifferent, and vice versa.
- Equalities generate candidates; inequalities verify equilibria.
- Every finite game has a mixed-strategy Nash equilibrium.

### Common comparisons

- Pure is a special case of mixed.
- Mixed strategies are independently randomized; correlated strategies need not be.
- Expected payoff is not the most likely payoff and not a guaranteed payoff.

### Must-remember facts

\[
U_1(x,y)=x^TAy
\]

\[
\operatorname{supp}(\sigma_i)=\{s_i:\sigma_i(s_i)>0\}
\]

For every supported `s_i`:

\[
u_i(s_i,\sigma_{-i})=\max_{t_i}u_i(t_i,\sigma_{-i}).
\]

### Interview traps

- Do not automatically use `1/2`.
- Do not forget pure equilibria.
- Do not accept an algebraic solution before checking deviations.
- Do not require an unused tied best response to receive positive probability.

---

## 13. Practice Tasks

### Task 1: Solve Matching Pennies

Derive both probabilities and the game value without memorizing the answer. Then change the payoff for one matching outcome from `1` to `3` and solve again.

### Task 2: Find every equilibrium

For the matrix below, mark best responses, find all pure equilibria, and compute any mixed equilibrium:

| Row \ Column | L | R |
|---|---:|---:|
| **U** | `(2,2)` | `(0,0)` |
| **D** | `(0,0)` | `(1,1)` |

Explain why the mixed equilibrium coexists with two pure equilibria.

### Task 3: Support verification

Given a `3 x 3` game, assume support `{R1,R3}` for Row and `{C1,C2}` for Column. Write all indifference, normalization, positivity, and excluded-action inequalities before solving.

### Task 4: Detect impossible support

Construct a game where equalizing two actions produces `q=1.4`. Explain why this means the support assumption fails rather than that probability can exceed one.

### Task 5: Implement a `2 x 2` solver

Write a small C++ or Python program that:

1. reads two `2 x 2` payoff matrices;
2. finds pure Nash equilibria by mutual best responses;
3. computes an interior mixed candidate when denominators are nonzero;
4. verifies the candidate with a tolerance; and
5. prints why a candidate was rejected.

Do not rely only on the closed-form formula; test boundary and degenerate cases.

### Task 6: Model randomized backoff

Create two retry policies—fixed delay and random delay—and simulate collision rates. Explain which elements resemble a strategic-form game and which require a repeated stochastic model.

### Task 7: Explain aloud

In under 90 seconds, explain why supported actions tie and why Player 1's probability is found using Player 2's payoff equation. This is excellent whiteboard-interview practice.

---

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | A mixed strategy is a distribution over pure strategies. |
| Equilibrium condition | Each player's mix maximizes expected payoff against opponents' mixes. |
| Expected payoff | Multiply payoff by outcome probability and sum; matrix form is `x^TAy`. |
| Indifference principle | Every supported action ties at the maximum payoff. |
| Support | Exactly the positive-probability actions. |
| Computation | Guess support → equalize → normalize → solve → verify inequalities. |
| Cross-player rule | Player 1's probability makes Player 2 indifferent. |
| Existence | Every finite game has at least one Nash equilibrium in mixed strategies. |
| Dominance | Strictly dominated strategies receive zero equilibrium probability. |
| Main trap | Equal payoff does not force positive probability. |

### Most asked questions

1. Define a mixed strategy and mixed Nash equilibrium.
2. Compute expected utility from a matrix.
3. Explain the indifference principle.
4. Solve a `2 x 2` equilibrium.
5. Define support and check excluded actions.
6. Explain why randomization prevents exploitation.

### One-line interview answer

> A mixed Nash equilibrium is a profile of probability distributions where each player randomizes only among best responses, making every supported action equally valuable and leaving no profitable unilateral deviation.
