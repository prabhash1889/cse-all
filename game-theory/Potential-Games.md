# Potential Games: Interview Guide

This guide develops four connected ideas: exact potential games, congestion games, the Rosenthal potential, and their use in networks and distributed systems. Unless stated otherwise, games are finite, a strategy profile is `s = (s_i, s_-i)`, and lower cost is preferred in cost-minimization examples.

---

# Exact Potential Games

## 1. Overview

An **exact potential game** is a strategic game whose players' unilateral incentive changes can all be represented by one scalar function, the **exact potential** `Phi`.

For a utility-maximization game, `Phi` is exact when, for every player `i`, fixed opponents' strategies `s_-i`, and actions `a_i, b_i`,

`u_i(a_i, s_-i) - u_i(b_i, s_-i) = Phi(a_i, s_-i) - Phi(b_i, s_-i)`.

For a cost-minimization game, replace `u_i` with `c_i`. The equality concerns **changes**, not levels: `Phi(s)` need not equal a player's utility, total utility, or social cost.

This matters because a many-agent stability question becomes movement on one global landscape. In a finite exact potential game, strictly improving unilateral moves must terminate at a pure-strategy Nash equilibrium (PSNE). Applications include routing, load balancing, channel selection, distributed allocation, facility selection, and coordination. Interviewers use the topic to test invariants, convergence proofs, mathematical modeling, and the distinction between stability and optimality.

## 2. Core Idea

### Intuition and analogy

Imagine every strategy profile as a point on a landscape. When one player changes action, that player's payoff change exactly equals the change in landscape height. A utility-improving player climbs; a cost-reducing player descends. A finite landscape cannot support an infinite sequence of strict moves in one direction.

Think of developers choosing shared build servers. Each server switch changes the developer's wait and a shared meter by exactly the same amount. The meter need not show total waiting time; it only needs to track each mover's difference.

### Small example

Two services choose server `A` or `B`. A service pays the number of services on its chosen server.

| Profile | Service 1 cost | Service 2 cost | `Phi` |
|---|---:|---:|---:|
| `(A, A)` | 2 | 2 | 3 |
| `(A, B)` | 1 | 1 | 2 |
| `(B, A)` | 1 | 1 | 2 |
| `(B, B)` | 2 | 2 | 3 |

If service 1 moves from `(A,A)` to `(B,A)`, its cost changes by `1-2=-1`; `Phi` changes by `2-3=-1`. Every unilateral move satisfies the same equality. The split profiles are local minima and PSNEs.

### Step-by-step reasoning

1. Choose two profiles differing only in player `i`'s action.
2. Compute player `i`'s utility or cost difference.
3. Compute the proposed potential difference.
4. Verify equality on every unilateral edge of the strategy graph.
5. Every strict better response moves `Phi` strictly in one direction.
6. Finitely many profiles imply termination at a profile with no profitable unilateral deviation: a PSNE.

## 3. Important Subtopics

### Exact, weighted, ordinal, and generalized ordinal potentials

- **Exact:** `Delta u_i = Delta Phi`.
- **Weighted:** `Delta u_i = w_i Delta Phi` for a positive player-specific `w_i`.
- **Ordinal:** player and potential changes always have the same sign.
- **Generalized ordinal:** every strict player improvement strictly improves the potential; the reverse need not hold.

Weaker notions may still prove convergence, but exactness preserves cardinal differences. Interviewers often ask which property suffices for pure-equilibrium existence in finite games: even a generalized ordinal potential does.

### Finite improvement property

The **finite improvement property (FIP)** says every sequence of strict unilateral improvements is finite. A finite ordinal-potential game has FIP because the potential strictly changes and no profile can repeat. The terminal profile is a PSNE. FIP concerns all better-response paths, not only a particular best-response schedule.

### Local versus global optima

A PSNE is a **unilateral local optimum** of the potential. It need not be a global potential optimum, and neither need minimize social cost. Two local minima can have different welfare. This is why convergence and price-of-anarchy analysis answer different questions.

### Constructing and verifying a potential

Set `Phi` at one reference profile and integrate payoff differences along unilateral edges. This is well-defined only if every closed path has zero accumulated change. In a two-player matrix, a four-cell rectangle is the standard consistency check: traverse unilateral edges around the rectangle and verify that the deviators' changes sum to zero.

### Non-uniqueness

If `Phi` is exact, then `Phi+K` is exact for any constant `K`. On a connected strategy graph, exact potentials differ only by an additive constant. Absolute values are normalization; differences carry the strategic information.

## 4. Real-World Example

Consider a distributed cache cluster. Each application instance chooses one cache node, and latency depends on how many instances use that node. If one instance at a time migrates only when its latency decreases, the unweighted congestion model supplies an exact potential. Every migration reduces the potential by exactly the mover's latency reduction, so the ideal process terminates at a stable placement.

The result gives a local-update convergence argument, but not an optimal-latency guarantee. Simultaneous migrations, stale measurements, noise, and changing demand violate the static sequential model and can produce oscillation.

## 5. Diagrams / Mental Models

```text
profile s -- player i changes alone --> profile s'

Delta utility_i = Delta Phi       utility convention
Delta cost_i    = Delta Phi       cost convention

strict improvement -> monotone Phi -> finite termination -> PSNE
```

| `Phi` is | `Phi` is not necessarily |
|---|---|
| A scalar encoding unilateral incentives | Any player's payoff |
| A Lyapunov-like progress measure | Sum of player costs |
| A PSNE-existence tool in finite games | A uniqueness or fairness guarantee |
| Defined up to a constant | A unique absolute measurement |

## 6. Common Interview Questions

1. **What is an exact potential game?** It has a scalar `Phi` whose change under every unilateral deviation equals the deviator's payoff or cost change. **Expected:** the quantified difference equation. **Mistake:** saying incentives merely “roughly align.”
2. **Why does a finite exact potential game have a PSNE?** Strict improvements move `Phi` monotonically; finitely many profiles force termination where no profitable unilateral deviation exists. **Expected:** connect termination to Nash. **Mistake:** claim the global minimum is the only equilibrium.
3. **Is the potential social welfare?** Not generally; it matches marginal unilateral differences, while welfare aggregates outcomes. **Expected:** separate difference and level. **Mistake:** assume `Phi=sum_i u_i`.
4. **Can there be multiple PSNEs?** Yes; every unilateral local optimum is a PSNE and the landscape may contain several. **Expected:** mention selection. **Mistake:** assume one scalar means one optimum.
5. **What is FIP?** Every strict unilateral improvement path terminates. **Expected:** quantify over all paths. **Mistake:** define only one chosen schedule.
6. **Does best-response dynamics find a global potential optimum?** Not necessarily; it can stop at a local optimum determined by initialization and update order. **Expected:** convergence versus optimality. **Mistake:** treat local search as global optimization.
7. **Exact versus ordinal potential?** Exact matches magnitude; ordinal preserves direction. **Expected:** ordinal still proves FIP in finite games. **Mistake:** confuse this with ordinal utility representation.
8. **How do you verify a candidate `Phi`?** Check every unilateral edge while opponents stay fixed. **Expected:** compare differences. **Mistake:** compare profiles where several players move.
9. **Is an exact potential unique?** Up to an additive constant on a connected strategy graph. **Expected:** only differences matter. **Mistake:** treat normalizations as distinct games.
10. **Can an infinite potential game fail to terminate?** Yes; a strictly improving infinite sequence can approach a limit. **Expected:** identify the finite-state step in the proof. **Mistake:** apply FIP automatically to continuous games.

## 7. Deep-Dive Questions

1. **What is the cycle condition?** Along any closed unilateral-deviation path, the sum of deviators' payoff changes must be zero. A scalar potential returns to its starting value; nonzero circulation makes exactness impossible.
2. **Why is Nash only local optimality?** Nash permits one coordinate to change. A coordinated multi-player change may reach a better potential or welfare state even when every one-coordinate move is worse.
3. **How is a potential like a Lyapunov function?** It changes monotonically along permitted dynamics and rules out recurrent strict-improvement behavior. It is strategic, however, and says nothing about transitions that are not unilateral improvements.
4. **Why do asynchronous updates matter?** Serialized unilateral moves inherit the proof regardless of mover order. Simultaneous moves are a joint edge, so cross-effects may reverse the expected potential change.
5. **Can convergence still be computationally slow?** Yes. FIP guarantees a finite path, not a polynomial one; succinct games can have exponentially long improvement paths or hard best-response computations.

## 8. Comparison Tables

| Property | Exact | Weighted | Ordinal |
|---|---|---|---|
| Relation | `Delta u_i=Delta Phi` | `Delta u_i=w_i Delta Phi` | Same sign |
| Magnitude preserved | Yes | Up to player scale | No |
| Direction preserved | Yes | Yes | Yes |
| FIP in finite games | Yes | Yes | Yes |

| Concept | Question | Guarantee |
|---|---|---|
| PSNE | Can one player improve? | Unilateral stability |
| Potential local optimum | Can one coordinate improve `Phi`? | PSNE in a potential game |
| Potential global optimum | Is `Phi` globally best? | A PSNE, not necessarily best welfare |
| Social optimum | Is chosen welfare globally best? | Efficiency, not necessarily stability |

## 9. Common Mistakes

- Calling sign agreement exactness.
- Checking joint rather than unilateral deviations.
- Equating `Phi` with total utility or cost.
- Claiming every finite game has a potential.
- Confusing Nash's mixed-equilibrium theorem with pure-equilibrium existence here.
- Confusing finite convergence with fast convergence.
- Treating a local potential optimum as a global social optimum.
- Mixing utility and cost sign conventions.
- Ignoring tied moves that can travel on a flat potential plateau.
- Applying sequential results to simultaneous distributed updates.

## 10. Edge Cases / Special Cases

- Constant-payoff games are exact potential games and every profile may be a PSNE.
- Weak equilibria can lie on flat regions rather than strict extrema.
- Adding to player `i`'s payoff any function depending only on `s_-i` preserves unilateral incentives and the potential.
- Different positive payoff scales can turn exactness into weighted exactness.
- Indifferent moves can cycle even though strict improvements cannot.
- A global `Phi` optimum is a PSNE, but a welfare optimum need not be.
- Noise, delayed information, simultaneous deviations, or time-varying payoffs can break modeled descent.

## 11. How to Explain in Interview

“An exact potential game has one scalar function whose change equals the deviating player's payoff change for every unilateral move. In a finite game, strict better responses move that function monotonically and must stop at a pure Nash equilibrium. The potential proves stability and convergence, but it is not necessarily total welfare, so the equilibrium may be inefficient.”

## 12. Quick Revision Notes

- Exact equation: `Delta u_i=Delta Phi` on every unilateral deviation.
- Cost improvements decrease both player cost and `Phi`.
- Finite exact/ordinal potential game => FIP => at least one PSNE.
- PSNE = unilateral local optimum of `Phi`.
- Global potential optimum is a PSNE, not necessarily a social optimum.
- Verify on unilateral edges; closed-cycle sums must be zero.
- Trap: simultaneous moves are outside the proof.

## 13. Practice Tasks

1. Build a potential for a `2 x 2` game by fixing one cell to zero and integrating edge differences.
2. Draw a three-player improvement graph and identify its sinks.
3. Write a C++ verifier for two payoff matrices and a proposed potential matrix.
4. Construct an exact potential game with two PSNEs of different social welfare.
5. Give an ordinal potential that is not exact.
6. Simulate sequential better responses from every initial profile.
7. Modify the simulator for simultaneous updates and find an oscillation.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Definition | Every unilateral payoff difference equals one potential difference |
| Why it matters | One landscape explains decentralized improvements |
| Main theorem | Every finite exact potential game has a PSNE |
| Equilibrium test | No one-coordinate potential improvement |
| Exact vs ordinal | Amount versus direction |
| Main trap | Potential is not automatically welfare |
| One-line answer | “Exact potential games encode every player's unilateral incentive change in one scalar function.” |

---

# Congestion Games

## 1. Overview

A **congestion game** models players choosing sets of shared resources whose costs depend on how many players use them. Formally, player `i` chooses `S_i` from feasible sets `Sigma_i subseteq 2^E`; resource load is `n_e(s)=|{i:e in S_i}|`; and player cost is

`C_i(s)=sum_(e in S_i)c_e(n_e(s))`.

The classic model is **atomic**, **unweighted**, and uses the same load-dependent resource cost for every user. It captures routes, servers, queues, channels, replicas, storage, and shared APIs. It matters because decentralized choices create congestion externalities, yet the standard finite model always has a PSNE. Interviewers ask it to connect Nash equilibrium, local search, systems modeling, and price of anarchy.

## 2. Core Idea

### Intuition and analogy

Each player chooses a bundle of resources. A player's decision changes their own cost and the costs faced by other users of those resources. Drivers choosing paths are the canonical analogy: each path is a set of road edges, edge latency depends on traffic, and route latency is the edge-latency sum.

### Small example

Two jobs choose server `A` or `B`:

- `c_A(1)=1`, `c_A(2)=4`
- `c_B(1)=2`, `c_B(2)=3`

| Profile | Loads `(n_A,n_B)` | Job costs | PSNE? |
|---|---|---|---|
| `(A,A)` | `(2,0)` | `(4,4)` | No; a mover pays 2 on `B` |
| `(A,B)` | `(1,1)` | `(1,2)` | Yes |
| `(B,A)` | `(1,1)` | `(2,1)` | Yes |
| `(B,B)` | `(0,2)` | `(3,3)` | No; a mover pays 1 on `A` |

### Step-by-step analysis

1. List every player's feasible resource sets.
2. Count the load on each resource for a candidate profile.
3. Evaluate each resource cost at its load.
4. Sum chosen-resource costs for each player.
5. For every unilateral alternative, recompute **post-move** loads and cost.
6. The profile is a PSNE if no player can strictly reduce personal cost.
7. Rosenthal's potential proves at least one PSNE exists in every finite standard congestion game.

## 3. Important Subtopics

### Atomic versus nonatomic congestion

Atomic players have positive discrete impact. Nonatomic users are infinitesimal; equilibrium is usually a **Wardrop equilibrium**, where all used routes have minimum available latency. Atomic games use Rosenthal's discrete sum, while suitable nonatomic models use the Beckmann integral. State the model before applying a theorem.

### Singleton versus network congestion games

In a **singleton** game, each strategy selects one resource, such as a server. In a **network congestion game**, resources are graph edges and a strategy is usually a source-to-destination path. Network feasibility makes best-response computation a shortest-path problem rather than a simple minimum scan.

### Symmetric versus asymmetric games

All players share the same feasible strategy family in a symmetric game. Asymmetric games allow different endpoints, permissions, or capabilities. Rosenthal's standard existence result does not require symmetry; it requires the unweighted shared-cost structure.

### Externalities and social cost

Standard social cost is

`SC(s)=sum_i C_i(s)=sum_e n_e(s)c_e(n_e(s))`.

A player sees personal latency, not the extra delay imposed on existing users. The **price of anarchy** compares the worst equilibrium with the social optimum; the **price of stability** compares the best equilibrium with it.

### Variants that change the theorem

Weighted players, player-specific costs, splittable flow, bottleneck objectives, capacities, and non-additive interactions are useful but may not admit the classic exact potential. Never invoke Rosenthal's theorem before checking assumptions.

## 4. Real-World Example

Suppose microservices choose database read replicas. Each request class is an atomic player, its strategy is one permitted replica, and latency grows with the number of classes assigned there. Sequential latency-reducing migrations converge in the ideal model.

The model helps teams detect selfish overload, compare stable assignments with minimum total latency, and design prices or admission limits. A production design must also handle request rates, noise, migration cost, failures, and simultaneous “thundering herd” moves.

## 5. Diagrams / Mental Models

```text
player -> feasible resource set -> loads n_e -> costs c_e(n_e)
   ^                                      |
   |                                      v
   +--------- unilateral cost comparison -+

private move changes own cost and costs imposed on others
```

| Layer | Routing | Compute system |
|---|---|---|
| Player | Driver/flow | Job/service |
| Resource | Road/link | Server/queue/channel |
| Strategy | Path | Permitted resource set |
| Load | Users on edge | Jobs sharing resource |
| PSNE | No better route alone | No better placement alone |

## 6. Common Interview Questions

1. **Define a congestion game.** Players choose feasible resource sets; resource costs depend on user count; player cost is the selected-resource sum. **Expected:** players, resources, loads, feasible sets, additive cost. **Mistake:** describe only routing.
2. **Does every finite congestion game have a PSNE?** Every finite standard unweighted congestion game does via Rosenthal's potential. **Expected:** assumptions. **Mistake:** include all variants.
3. **How do you test a profile?** Recompute each unilateral alternative using post-move loads. **Expected:** subtract load on left resources and add it on joined resources. **Mistake:** reuse old costs.
4. **Atomic versus nonatomic?** Atomic players change loads discretely; nonatomic users are infinitesimal and satisfy Wardrop conditions. **Expected:** discrete versus continuous. **Mistake:** use identical equilibrium definitions.
5. **What is social cost?** Usually `sum_i C_i=sum_e n_e c_e(n_e)`. **Expected:** both forms. **Mistake:** call it Rosenthal potential.
6. **Why can equilibrium be inefficient?** Players ignore congestion imposed on others. **Expected:** identify the externality. **Mistake:** blame irrational behavior.
7. **Define PoA and PoS.** For minimization, `PoA=max_NE SC/OPT`; `PoS=min_NE SC/OPT`. **Expected:** worst versus best equilibrium. **Mistake:** invert ratios.
8. **What is a singleton congestion game?** Every strategy selects one resource. **Expected:** server-selection example. **Mistake:** say it has one player.
9. **What is a network congestion game?** Resources are graph edges and strategies are paths. **Expected:** sum edge costs. **Mistake:** make each named path one unrelated resource.
10. **Why can simultaneous best responses oscillate?** Several players react to the same old loads; their joint move is not covered by unilateral exactness. **Expected:** stale observations or synchronization. **Mistake:** think equilibrium existence prevents all dynamics from cycling.

## 7. Deep-Dive Questions

1. **Why is social cost not the exact potential?** Joining a resource changes `n c(n)`, including the new delay experienced by incumbents. The mover's private change does not include all of that externality.
2. **How do tolls improve routing?** Charge marginal external cost so perceived private cost more closely matches social marginal cost. In nonatomic differentiable routing, the classic toll is `x l'_e(x)`.
3. **What fails with weighted players?** A move changes load by `w_i`, so Rosenthal's unit-by-unit telescoping no longer generally equals that player's experienced cost difference.
4. **How do you compute a network best response?** Fix others, assign each edge the latency the player would face after using it, then run shortest path over feasible routes.
5. **What controls convergence time?** Potential range and improvement granularity can bound moves, but compactly represented games may have exponential paths; update order and best-response complexity also matter.

## 8. Comparison Tables

| Model | Player size | Strategy | Equilibrium | Potential |
|---|---|---|---|---|
| Atomic singleton | Discrete | One resource | No profitable switch | Rosenthal sum |
| Atomic network | Discrete | Path/set | No profitable path switch | Rosenthal sum |
| Nonatomic routing | Infinitesimal | Flow | Used paths have minimum latency | Beckmann integral |
| Central assignment | Not strategic | Optimizer chooses | Global objective optimum | Objective |

| Metric | Formula | Meaning |
|---|---|---|
| Social optimum | `min_s SC(s)` | Best coordinated state |
| PSNE | No unilateral reduction | Stable selfish state |
| PoA | `max_NE SC/OPT` | Worst cost of selfishness |
| PoS | `min_NE SC/OPT` | Best stable quality |

## 9. Common Mistakes

- Assuming a strategy is always one resource rather than a set or path.
- Evaluating deviations at pre-move loads.
- Confusing resource load, player cost, social cost, and potential.
- Claiming every equilibrium balances resources optimally.
- Applying the theorem to weighted or player-specific variants unchecked.
- Ignoring path feasibility in network best responses.
- Assuming increasing costs are algebraically required for Rosenthal exactness.
- Applying sequential convergence to simultaneous migrations.

## 10. Edge Cases / Special Cases

- Constant costs create no congestion externality on that resource.
- Flat cost regions can create many weak equilibria.
- Decreasing costs still satisfy the classic potential identity, though they model positive network effects.
- Capacity may be encoded through feasibility or carefully handled very large costs.
- Player-specific resource costs generally break the shared potential.
- A strategy may be empty if opting out is allowed.
- Shared edges must be counted per edge, even when paths have different names.
- Switching cost introduces history dependence unless state is augmented.
- Arrivals and departures create a changing game, not one static convergence process.

## 11. How to Explain in Interview

“A congestion game has players choose shared resource sets, with each resource's cost determined by load and each player's cost equal to the sum on selected resources. The finite unweighted model has Rosenthal's exact potential, so sequential better responses reach a pure Nash equilibrium. The equilibrium can still be inefficient because players ignore congestion imposed on others.”

## 12. Quick Revision Notes

- `n_e(s)` = number of players using resource `e`.
- `C_i(s)=sum_(e in S_i)c_e(n_e(s))`.
- Standard finite unweighted congestion game => PSNE exists.
- Singleton = one resource; network = path/resource set.
- Atomic = impactful discrete players; nonatomic = infinitesimal flow.
- `SC=sum_e n_e c_e(n_e)`.
- PoA uses worst equilibrium; PoS uses best.
- Trap: recompute post-move loads.

## 13. Practice Tasks

1. Enumerate all profiles of a three-job, two-server game and find every PSNE.
2. Implement resource-set costs and loads in C++.
3. Simulate sequential best responses and assert potential descent.
4. Model a routing network and compute best responses with Dijkstra.
5. Build an instance with inefficient equilibrium and calculate PoA/PoS.
6. Compare sequential and simultaneous migrations.
7. Add marginal-cost tolls and test whether the optimum becomes stable.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Definition | Players choose shared resources with load-dependent costs |
| Player cost | Sum of costs on selected resources |
| Main theorem | Finite standard unweighted congestion games have a PSNE |
| Proof tool | Rosenthal exact potential |
| Inefficiency | Players ignore costs imposed on others |
| Key comparison | Atomic Nash versus nonatomic Wardrop |
| One-line answer | “Congestion games model selfish selection of load-sensitive shared resources.” |

---

# Rosenthal Potential

## 1. Overview

The **Rosenthal potential** is the exact potential for a finite unweighted congestion game. For profile `s`, load `n_e(s)`, and per-user resource cost `c_e(k)`, it is

`Phi(s)=sum_(e in E) sum_(k=1 to n_e(s)) c_e(k)`.

For each resource, it accumulates the first user's cost, the second user's cost, and so on to current load. It is generally not total social cost `sum_e n_e(s)c_e(n_e(s))`.

When one player changes strategies, `Phi` changes by exactly that player's cost change. This proves PSNE existence and convergence of sequential strict better responses in every finite standard congestion game. The formula appears in routing, server choice, scheduling, channel allocation, and local-search analysis. Interviewers expect the formula, the join/leave proof, and the distinction from social cost.

## 2. Core Idea

### Intuition

Imagine users entering resource `e` one at a time. At load `k`, the potential contribution is

`c_e(1)+c_e(2)+...+c_e(k)`.

One new user adds exactly `c_e(k+1)`, which is the cost the newcomer experiences. A leaving user removes exactly the old last term `c_e(k)`, which is the cost that user had experienced.

### Small example

Let `c_A(1)=2`, `c_A(2)=5`, `c_A(3)=9`, and `c_B(1)=3`, `c_B(2)=4`, `c_B(3)=8`. At loads `(2,1)`:

`Phi=[2+5]+[3]=10`.

If one job moves from `A` to `B`, loads become `(1,2)`:

`Phi'=[2]+[3+4]=9`.

The mover's cost changes from 5 to 4, or `-1`; potential also changes by `-1`.

### General deviation proof

Let player `i` change from `S_i` to `S_i'`.

1. Resources in both sets keep the same load and cancel.
2. Leaving resource `e` with old load `n_e` removes `c_e(n_e)` from `Phi`.
3. Joining resource `e` with old load `n_e` adds `c_e(n_e+1)`.
4. Thus `Delta Phi` is the joined-resource sum minus the left-resource sum.
5. The same terms remain after canceling common resources from the player's new and old costs.
6. Therefore `Delta Phi=Delta C_i`.

## 3. Important Subtopics

### Why the formula is cumulative

`c_e(n_e)` alone does not integrate changes over loads. `n_e c_e(n_e)` includes the changed cost imposed on incumbents. The cumulative sum is designed so a unit load change adds or removes exactly one marginal term.

### Exactness by cancellation

Partition resources into joined, left, common, and unused. Only joined and left resources change load. Common resources cancel in both potential and private-cost differences. This set-difference derivation is the core interview proof.

### Equilibrium as local minimum

Under cost minimization, a PSNE is exactly a unilateral local minimum of `Phi`. A global minimum is therefore a PSNE, giving a direct existence proof because the finite profile set has a minimum.

### Improvement dynamics

Every strict cost-reducing unilateral move reduces `Phi`. Arbitrary sequential better responses therefore terminate. The theorem guarantees termination, not fairness of the update scheduler, uniqueness, global optimality, or a polynomial number of moves.

### Relation to social cost

Rosenthal contribution at load `n` is `sum_(k=1)^n c_e(k)`; social contribution is `n c_e(n)`. With nonnegative nondecreasing costs, the first is at most the second, but they usually differ. Potential chooses stable local states; social cost evaluates collective performance.

## 4. Real-World Example

Distributed workers choose queues with predicted completion time `c_e(k)` at queue load `k`. A worker moving from queue `A` to `B` changes two load counters. Workers need only personal predicted costs, while Rosenthal potential supplies an offline convergence proof.

Engineers can compute `Phi` in a simulator as a test oracle. If a serialized claimed cost improvement raises `Phi`, the implementation's load accounting or the modeled resource costs are inconsistent. Production telemetry still needs to address concurrency, noise, and time variation.

## 5. Diagrams / Mental Models

```text
resource load 3:

arrival number       1        2        3
term added          c(1)     c(2)     c(3)

Phi_e(3) = c(1) + c(2) + c(3)
leave at load 3 -> remove c(3)
join at load 3  -> add c(4)
```

| Load | Rosenthal term | Social-cost term |
|---:|---|---|
| 0 | `0` | `0` |
| 1 | `c(1)` | `c(1)` |
| 2 | `c(1)+c(2)` | `2c(2)` |
| 3 | `c(1)+c(2)+c(3)` | `3c(3)` |

## 6. Common Interview Questions

1. **State Rosenthal's potential.** `Phi(s)=sum_e sum_(k=1)^(n_e(s))c_e(k)`. **Expected:** correct bounds and load. **Mistake:** write `sum_e n_e c_e(n_e)`.
2. **Why is it exact?** A join adds `c_e(n_e+1)` and a departure removes `c_e(n_e)`, matching the mover's changed costs. **Expected:** joined, left, and common sets. **Mistake:** assert without cancellation.
3. **How does it prove a PSNE exists?** A finite global minimum cannot have a unilateral cost-reducing move. **Expected:** contradiction using exactness. **Mistake:** invoke only mixed equilibrium.
4. **Is it total latency?** Generally no: potential accumulates marginal arrival costs; total latency charges all users the final cost. **Expected:** both formulas. **Mistake:** treat them as synonyms.
5. **What happens when a player improves?** `Phi` decreases by exactly the player's cost reduction. **Expected:** consistent cost convention. **Mistake:** say it increases because utility potentials do.
6. **Must costs increase with load?** Not for the algebraic exactness of the classic finite unweighted construction, though monotonicity fits congestion. **Expected:** distinguish assumption from interpretation. **Mistake:** use monotonicity as the proof.
7. **What if a strategy uses many resources?** Sum effects over joined and left resources; common resources cancel. **Expected:** set differences. **Mistake:** prove only singleton games.
8. **Can equal load vectors have different potential?** No; Rosenthal potential depends only on resource loads. **Expected:** equal potential does not imply equal profiles. **Mistake:** infer identical strategies.
9. **Does minimizing `Phi` minimize social cost?** Not generally. **Expected:** stability versus efficiency. **Mistake:** call `Phi` the central welfare objective.
10. **Why can simultaneous moves raise `Phi`?** Exactness applies against fixed opponents; joint moves change the load each mover anticipated. **Expected:** unilateral assumption. **Mistake:** sum stale unilateral deltas.

## 7. Deep-Dive Questions

1. **Derive overlapping-set change.** With left set `L=S_i\S_i'`, joined set `J=S_i'\S_i`, and common set `K`, common terms cancel; departures contribute `-sum_(e in L)c_e(n_e)` and joins contribute `sum_(e in J)c_e(n_e+1)` to both differences.
2. **What is the nonatomic analogue?** The Beckmann potential is `sum_e integral_0^(x_e) l_e(t)dt`; its derivative with respect to flow is latency, paralleling discrete cumulative sums.
3. **Can potential bound move count?** With integer costs and minimum strict decrease one, initial potential minus a lower bound limits steps. Arbitrary reals or succinct inputs may give no useful polynomial bound.
4. **Why does a minimum work with nonmonotone costs?** Exactness is sufficient: any private cost reduction would lower `Phi` and contradict minimality.
5. **How do tolls change the potential?** Replace perceived resource cost by `c_e(k)+tau_e(k)` in the cumulative formula; separately track the original social objective.

## 8. Comparison Tables

| Function | Resource contribution | Purpose |
|---|---|---|
| Rosenthal | `sum_(k=1)^n c_e(k)` | Encode unilateral private changes |
| Social cost | `n c_e(n)` | Aggregate performance |
| Beckmann | `integral_0^x l_e(t)dt` | Continuous-flow equilibrium |
| Marginal social cost | Change/derivative of total cost | Efficient decisions and tolls |

| State | PSNE? | Global `Phi` min? | Social optimum? |
|---|---|---|---|
| Global `Phi` minimum | Yes | Yes | Not necessarily |
| Unilateral local `Phi` minimum | Yes | Not necessarily | Not necessarily |
| Social-cost minimum | Not necessarily | Not necessarily | Yes |

## 9. Common Mistakes

- Memorizing `n c(n)` instead of `c(1)+...+c(n)`.
- Using `c(n)` rather than `c(n+1)` for a join from old load `n`.
- Removing `c(n-1)` rather than old last term `c(n)` on departure.
- Double-counting common resources.
- Mixing utility and cost directions.
- Claiming potential minimization is welfare minimization.
- Calling every PSNE a strict local minimum.
- Applying the formula unchanged to weighted or player-specific games.
- Assuming monotone descent means fast convergence.

## 10. Edge Cases / Special Cases

- At load zero, the inner sum is empty and contributes zero.
- Constant `c(k)=a` yields `an`, equal to social resource cost.
- Decreasing or negative costs can satisfy the algebra even if interpretation changes.
- Tied moves leave `Phi` unchanged and may cycle if allowed.
- Equal potential values do not imply adjacent or strategically equivalent profiles.
- Weighted joins can skip multiple unit loads and break the private-change match.
- Identity-dependent or non-load-based costs generally invalidate the formula.

## 11. How to Explain in Interview

“Rosenthal's potential sums `c_e(1)` through `c_e(n_e)` for every resource. A joining player adds exactly the cost they see, and a leaving player removes exactly their old cost. Across all changed resources, potential change equals player cost change, proving exactness, finite better-response convergence, and pure-equilibrium existence.”

## 12. Quick Revision Notes

- `Phi=sum_e sum_(k=1)^(n_e)c_e(k)`.
- Join old load `n`: add `c_e(n+1)`.
- Leave old load `n`: remove `c_e(n)`.
- Common resources cancel.
- `Delta Phi=Delta player cost`.
- Global `Phi` minimum is a PSNE.
- Trap: `Phi` is usually not `sum_e n_e c_e(n_e)`.

## 13. Practice Tasks

1. Calculate `Phi` for every profile of a three-player, two-resource game.
2. Verify exactness for a multi-resource deviation using set differences.
3. Implement a C++ Rosenthal-potential function from loads and cost arrays.
4. Assert `Delta Phi=Delta mover cost` in a simulator.
5. Construct a potential minimum differing from the social optimum.
6. Derive the Beckmann integral for linear latency.
7. Show numerically why a weight-2 player breaks the standard formula.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Formula | `sum_e[c_e(1)+...+c_e(n_e)]` |
| Join | Add the new last term |
| Leave | Remove the old last term |
| Exactness | `Delta Phi=Delta deviator cost` |
| Existence | Finite global minimum is a PSNE |
| Main comparison | Cumulative marginal costs versus `n*c(n)` |
| One-line answer | “Rosenthal's cumulative resource-cost sum turns selfish congestion moves into exact potential descent.” |

---

# Applications to Networks and Distributed Systems

## 1. Overview

Potential games analyze decentralized systems in which independent agents choose routes, servers, queues, channels, replicas, schedules, or protocol parameters. When unilateral local improvements align with a potential, the potential becomes a global progress measure even though no agent explicitly optimizes it.

Applications include selfish routing, traffic engineering, load balancing, wireless channel selection, distributed scheduling, caching, storage placement, peer-to-peer selection, topology formation, and protocol adoption. The framework separates three questions:

1. **Stability:** will any agent want to deviate?
2. **Convergence:** will the chosen update process reach a stable state?
3. **Efficiency:** how good is that stable state for the whole system?

Interviewers ask this topic to test whether candidates can map formal theory to real components and identify where assumptions such as sequential moves, static costs, and accurate measurements fail in production.

## 2. Core Idea

### Intuition and analogy

A distributed system lacks one controller with complete fresh information. Components observe local performance and change their own decisions. A potential function proves that these individual moves collectively make progress.

For Wi-Fi channel selection, each access point prefers less interference, while switching changes neighbors' interference. If costs form a potential game and access points update one at a time, every beneficial switch moves the potential downhill until no access point benefits alone.

### Small example

Three services choose replicas `R1` or `R2`, with `c_1(k)=k` and `c_2(k)=k+1`. Start at loads `(3,0)`. Every `R1` user pays 3. One can move to `R2` and pay 2, creating `(2,1)`. All users now pay 2, and no service improves alone, so the placement is stable.

### Step-by-step engineering method

1. Identify agents and their actual decisions.
2. Define measurable private cost: latency, loss, energy, queue delay, or price.
3. Identify shared resources and the load-to-cost rule.
4. Check whether congestion or another potential structure really applies.
5. Specify updates: sequential, simultaneous, delayed, stochastic, or state-based.
6. Prove only what is required: existence, termination, approximate stability, or welfare bound.
7. Validate model gaps with simulation, fault injection, and telemetry.

## 3. Important Subtopics

### Selfish routing

Flows choose paths minimizing latency. Edges are resources and path cost is the sum of edge costs. Atomic flows form network congestion games; infinitesimal flows use Wardrop equilibrium. Typical interview angles are overloaded common edges, shortest-path best responses, PoA, and marginal-cost tolls.

### Load balancing and scheduling

Jobs choose machines, queues, or time slots. Singleton congestion fits one-machine choice; resource-set games fit jobs needing multiple components. Be precise about the objective: individual completion time, total delay, and makespan are different quantities.

### Wireless channel selection

Transmitters choose channels or power levels; payoff depends on interference. Symmetric interference models may admit potentials. Directed interference, hidden terminals, and heterogeneous power can break exactness, so observed oscillation may reveal either concurrency or model mismatch.

### Distributed learning and update schedules

A best response finds the best action; a better response finds any strict improvement. Sequential improvements converge in finite potential games. Randomized/log-linear learning can explore several local optima. Simultaneous greedy updates can oscillate. The update protocol is part of the algorithm, not a minor implementation choice.

### Incentive design

If stable behavior is inefficient, change perceived costs using prices, tolls, quotas, backoff, admission control, or rewards. A successful mechanism makes desirable states individually stable and uses signals agents can observe and that the system can enforce.

### Approximate equilibrium and robustness

In a noisy dynamic system, exact equilibrium may be meaningless. At an `epsilon`-Nash equilibrium, no agent can improve by more than `epsilon`. Choose `epsilon` from measurement error and migration overhead. Robust analysis also considers churn, delays, failures, and strategic reporting.

## 4. Real-World Example

### Distributed edge-routing controller

Each tenant routes an unsplittable workload through a network. Link `e` has latency `c_e(n_e)`. A tenant computes a strictly cheaper path using predicted post-move loads and installs it.

In the ideal model, one tenant moves at a time and Rosenthal potential falls by its latency reduction. Production requires more:

- **serialization or randomized backoff** to prevent herd movement;
- **hysteresis** so tiny noisy improvements do not trigger migration;
- **versioned snapshots** to reject stale decisions;
- **rate limits** because convergence may be long;
- **capacity/failure constraints** in path feasibility;
- **welfare monitoring** because stable routing may have high total latency;
- **fallback routes** because a static equilibrium proof is not an availability proof.

Theory supplies the invariant; systems engineering preserves its assumptions or detects when they fail.

## 5. Diagrams / Mental Models

```text
telemetry -> estimated private cost -> unilateral decision
                                           |
                                    update protocol
                                           |
                                           v
                              loads / interference change
                                           |
                                           v
                                  potential progress

ideal: fixed game + correct costs + one mover at a time
real:  noise + delay + concurrency + churn + failures
```

| System question | Theory | Engineering control |
|---|---|---|
| Will improvements stop? | FIP/potential descent | Serialization, strict threshold |
| Is state stable? | PSNE/epsilon-NE | Regret checks |
| Is state efficient? | PoA/PoS | Pricing, central guidance |
| Can it oscillate? | Joint/stale deviations | Backoff, leases, epochs |
| Is a move computable? | Best-response complexity | Shortest path/approximation |
| What about churn? | Dynamic game | Damping and reoptimization |

## 6. Common Interview Questions

1. **How are potential games useful in distributed systems?** They provide a global progress measure for decentralized unilateral updates. **Expected:** convergence plus separate welfare analysis. **Mistake:** call the potential a controller.
2. **Give a networking example.** Flows choose paths and link latency depends on load. **Expected:** shared edges and path-cost sum. **Mistake:** omit externalities.
3. **Why can server migrations oscillate?** Agents act simultaneously on one stale snapshot. **Expected:** the proof assumes unilateral moves. **Mistake:** conclude no potential exists solely from oscillation.
4. **How do you prevent thundering herds?** Serialize or randomize moves, use leases/backoff, and require hysteresis. **Expected:** tie controls to concurrency/noise. **Mistake:** add an unexplained fixed sleep.
5. **Does convergence mean optimal balance?** No; it means no unilateral private improvement. **Expected:** PoA/PoS. **Mistake:** equate stability with optimum.
6. **How can pricing help?** Charge external costs so selfish decisions better align with social cost. **Expected:** incentive alignment. **Mistake:** claim a price physically reduces latency.
7. **What information is needed for a routing best response?** Feasible graph and predicted post-move edge costs. **Expected:** account for the player's current occupancy. **Mistake:** blindly use old weights.
8. **When use epsilon-equilibrium?** With noise, switching cost, continuous measurements, or changing demand. **Expected:** derive epsilon operationally. **Mistake:** choose a unitless arbitrary value.
9. **How do failures affect the guarantee?** They change resources, feasible strategies, or costs, so the underlying game changes. **Expected:** static proof must restart or become dynamic. **Mistake:** assume one potential survives every topology.
10. **What should production monitor?** Pre/post private costs, loads, regret, update concurrency, snapshot age, migrations, potential/proxy, and social cost. **Expected:** invariant and outcome. **Mistake:** only average latency.

## 7. Deep-Dive Questions

1. **How can asynchronous updates preserve unilateral reasoning?** Make overlapping moves linearizable using coordination, leases, or version-check-and-retry. Randomized clocks can reduce collision probability; exact multi-resource locking may be too expensive.
2. **What is regret?** For a player, current cost minus the best unilateral alternative under a snapshot. Maximum regret at most `epsilon` means epsilon-equilibrium and is measurable despite noise.
3. **Can potential be a termination detector?** Conceptually, but global computation may require aggregation. Production commonly uses quiescent epochs, bounded regret, or no-change windows instead.
4. **How should switching costs be handled?** Put migration cost in the move threshold or augment state with previous placement. History dependence can invalidate a static congestion formulation.
5. **How do you separate model and implementation bugs?** Verify exactness on observed serialized transitions, predicted versus actual costs, snapshot versions, and whether the move was unilateral. Failed equations suggest model mismatch; inconsistent execution suggests implementation error.

## 8. Comparison Tables

| Approach | Authority | Strength | Main risk |
|---|---|---|---|
| Central optimizer | Controller | Targets global objective | Stale state, scalability, control-plane failure |
| Sequential best response | Agents | Potential convergence | Local optimum, long path |
| Simultaneous greedy | Agents in rounds | Fast reaction | Herding and oscillation |
| Randomized learning | Agents | Exploration/symmetry breaking | Slow stochastic convergence |
| Price-guided decentralization | Agents plus signals | Better incentive alignment | Pricing correctness/enforcement |

| Application | Player | Strategy | Shared effect | Main concern |
|---|---|---|---|---|
| Routing | Flow/tenant | Path | Link congestion | PoA and shortest path |
| Load balancing | Job/service | Server | Queue delay | Migration oscillation |
| Wireless | Radio/AP | Channel/power | Interference | Asymmetry |
| Caching | Client/content | Placement | Storage/load | Non-additive benefit |
| Protocol adoption | Service/team | Version | Compatibility | Multiple equilibria |

## 9. Common Mistakes

- Naming players without defining their strategic choices.
- Using current average latency instead of post-move marginal latency.
- Assuming decentralization eliminates all coordination.
- Applying sequential proofs to simultaneous deployments.
- Ignoring migration, retry, and reconfiguration costs.
- Treating a static game as unchanged under failures and shifting demand.
- Inferring efficiency from equilibrium existence.
- Assuming a decreasing empirical metric is an exact potential without proof.
- Ignoring best-response computational cost.
- Designing prices agents cannot observe or the system cannot enforce.
- Chasing improvements smaller than telemetry noise.

## 10. Edge Cases / Special Cases

- Independent agents with no shared resources form a trivial potential game.
- Identical resources create symmetry and synchronized herding risk.
- Flat costs create weak improvements and ambiguous movement policies.
- Tail latency and bottleneck objectives may not be additive.
- Multi-resource moves may require transactions to appear unilateral.
- Strategic agents may misreport private information.
- A topology change can change the potential itself.
- Continuous decisions need assumptions beyond finite FIP.
- Policy/security constraints belong in feasible strategy sets.
- Fairness may conflict with total-cost minimization.

## 11. How to Explain in Interview

“In networks and distributed systems, potential games model flows or services choosing shared resources based on local cost. If unilateral improvements match a potential, serialized better responses converge to a stable state. I would separately analyze efficiency, response-computation cost, stale data, concurrent moves, failures, measurement noise, and migration overhead because the static potential proof does not solve those systems concerns.”

## 12. Quick Revision Notes

- Model agents, actions, shared resources, private costs, and update rules.
- Potential is an analysis invariant, not necessarily a runtime coordinator.
- Sequential strict better response gives convergence in finite potential games.
- Routing best response often becomes shortest path with post-move weights.
- Stability != efficiency; measure regret and social cost.
- Gaps: concurrency, staleness, noise, churn, failures, switching cost.
- Controls: backoff, versioning, hysteresis, pricing, epsilon stopping.
- Trap: state atomic/nonatomic and static/dynamic assumptions.

## 13. Practice Tasks

1. Model pod placement as a singleton congestion game and list unrealistic assumptions.
2. Implement routing best responses with Dijkstra and verify potential descent.
3. Run simultaneous updates and demonstrate an oscillation.
4. Add random backoff and hysteresis; measure migrations and regret.
5. Compute PoA and PoS for a two-route network.
6. Design and explain an enforceable latency toll.
7. Inject a link failure and identify which game components change.
8. Choose epsilon from telemetry error plus switching overhead.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core use | Analyze decentralized resource-selection updates |
| Network mapping | Flows choose paths; links have load costs |
| Systems mapping | Jobs choose servers, queues, channels, replicas |
| Convergence requirement | Fixed game plus unilateral strict improvements |
| Efficiency | Compare equilibrium cost with coordinated optimum |
| Hazards | Staleness, concurrency, churn, noise, switching cost |
| Controls | Backoff, versioning, hysteresis, pricing, regret |
| One-line answer | “Potential games turn local selfish updates into global progress when the distributed update assumptions are preserved.” |

---

## References

- Dov Monderer and Lloyd S. Shapley, “Potential Games,” *Games and Economic Behavior*, 1996.
- Robert W. Rosenthal, “A Class of Games Possessing Pure-Strategy Nash Equilibria,” *International Journal of Game Theory*, 1973.
- MIT OpenCourseWare, *Networks*, congestion-games lecture and recitation notes.
