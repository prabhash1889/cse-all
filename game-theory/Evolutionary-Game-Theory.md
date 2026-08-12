# Evolutionarily Stable Strategy (ESS)

## 1. Overview

An **evolutionarily stable strategy**, or ESS, is a strategy that cannot be displaced by a small group of mutants using another strategy once the ESS is common in a population. It is a refinement of symmetric Nash equilibrium for evolutionary settings: players need not calculate, communicate, or even be rational. Strategies that earn higher fitness simply become more common.

For a symmetric two-player game with payoff function \(u(s,t)\), a resident strategy \(s^*\) is an ESS if, for every mutant \(s \ne s^*\), either:

1. \(u(s^*,s^*) > u(s,s^*)\), or
2. \(u(s^*,s^*) = u(s,s^*)\) and \(u(s^*,s) > u(s,s)\).

The first condition says a mutant does worse against residents. The second is the tie-breaker: if mutants perform equally well against residents, residents must outperform mutants in resident-mutant encounters.

ESS matters because ordinary Nash equilibrium checks only unilateral deviation at a fixed opponent strategy. ESS additionally checks whether an equilibrium resists invasion. It is used in evolutionary biology, behavioral ecology, cultural evolution, adaptive routing, protocol adoption, security behavior, and multi-agent learning. Interviewers use it to test precise inequality reasoning, the difference between equilibrium and stability, and the ability to connect a payoff matrix to population behavior.

## 2. Core Idea

### Intuition

Imagine almost everyone follows strategy \(R\). A small fraction \(\varepsilon\) uses mutant strategy \(M\). Random matching gives expected fitness

\[
F_R=(1-\varepsilon)u(R,R)+\varepsilon u(R,M)
\]

and

\[
F_M=(1-\varepsilon)u(M,R)+\varepsilon u(M,M).
\]

\(R\) is evolutionarily stable if \(F_R>F_M\) for every sufficiently small positive \(\varepsilon\), regardless of the mutant \(M\).

### Real-world analogy

Suppose almost every service in an ecosystem follows a reliable retry policy. A new aggressive retry policy appears. If aggressive clients obtain lower long-run success because they trigger throttling, the existing policy resists invasion. No central planner is required; relative performance determines adoption.

### Small example

Consider:

| Player 1 \ Player 2 | A | B |
|---|---:|---:|
| **A** | (4, 4) | (2, 1) |
| **B** | (1, 2) | (3, 3) |

For resident \(A\), a mutant \(B\) gets \(u(B,A)=1\), while residents get \(u(A,A)=4\). Since \(4>1\), \(A\) is ESS against \(B\). The strict first condition is enough.

For resident \(B\), a mutant \(A\) gets \(u(A,B)=2\), while residents get \(u(B,B)=3\). Hence \(3>2\), so \(B\) is also ESS. A game may therefore have multiple ESSs.

### Step-by-step ESS test

1. Confirm that the game is symmetric or that the proposed evolutionary interpretation is well-defined.
2. Pick a resident candidate \(s^*\).
3. For every mutant \(s\), compare \(u(s^*,s^*)\) with \(u(s,s^*)\).
4. If the resident payoff is strictly larger, that mutant cannot invade.
5. If the values tie, compare \(u(s^*,s)\) with \(u(s,s)\).
6. The candidate is ESS only if every possible mutant fails the invasion test.

## 3. Important Subtopics

### 3.1 Symmetric Nash equilibrium as a necessary condition

Every ESS is a symmetric Nash equilibrium because \(u(s^*,s^*)\ge u(s,s^*)\) for all \(s\). Otherwise a mutant would immediately outperform residents. This matters as a quick filter: first find symmetric Nash equilibria, then apply the stricter ESS test. The converse is false when a neutral mutant ties residents both against residents and against itself.

**Interview angle:** Prove ESS implies Nash equilibrium, then provide a Nash equilibrium that is not ESS.

### 3.2 The second ESS condition

The tie-breaker is the defining subtlety. If \(u(s^*,s^*)=u(s,s^*)\), rare mutants initially tie residents in resident encounters. Their occasional encounters with each other then decide whether they grow. Residents must do better against mutants than mutants do against themselves.

**Example:** If payoffs satisfy \(u(A,A)=u(B,A)=2\), \(u(A,B)=3\), and \(u(B,B)=1\), then \(A\) is ESS through the second condition.

**Interview angle:** Candidates often stop after establishing Nash equilibrium and miss this second comparison.

### 3.3 Pure and mixed ESS

An ESS may be a pure action or a probability distribution over actions. A mixed strategy \(p^*\) is tested against every alternative mixed strategy \(q\). In a two-strategy game, an interior mixed ESS often makes both pure actions earn equal payoff at \(p^*\), while local deviations are pushed back by fitness differences.

Mixed ESS matters when no pure behavior can resist invasion, as in anti-coordination games. Interviewers may ask whether “randomization” means an organism flips a coin or whether it can represent stable proportions of pure types; both interpretations are possible, but they are different biological models.

### 3.4 Invasion barrier

The definition uses “sufficiently small” mutant share. An **invasion barrier** is a positive threshold \(\bar\varepsilon\) such that the resident beats the mutant for all \(0<\varepsilon<\bar\varepsilon\). ESS is local resistance, not a guarantee that the resident defeats a mutant population of any size.

**Interview angle:** Distinguish local evolutionary stability from global dominance.

### 3.5 ESS and asymptotic stability

Under standard replicator dynamics, an ESS is locally asymptotically stable in many common settings, but the concepts are not identical without assumptions. ESS is defined by payoffs under invasion; dynamic stability depends on a chosen adjustment process. A state can be dynamically stable under one process and unstable under another.

**Interview angle:** Do not claim that every Nash equilibrium or every ESS is globally attracting.

### 3.6 Neutral stability

A neutrally stable strategy prevents mutants from doing strictly better but may not eliminate them. Neutral stability allows equality where ESS requires a strict second-order advantage. Neutral drift can therefore persist.

## 4. Real-World Example

### Competing congestion-control policies

Consider a population of clients sharing a backend. The resident policy backs off after rate-limit responses; a mutant retries aggressively.

- When nearly all clients back off, they preserve server capacity and achieve high completion rates.
- A few aggressive clients may gain short-term throughput.
- If throttling, queueing delay, and failures reduce the aggressive policy's long-run payoff below that of residents, it cannot invade.
- If aggressive clients tie when rare but harm one another badly when they meet, the resident can still be ESS through the second condition.

This model helps protocol designers ask a practical question: “If a small fraction of independently controlled clients changes behavior, will the desired convention remain attractive?” The model does not replace load testing; it exposes incentive compatibility.

## 5. Diagrams / Mental Models

~~~text
Resident population s*
        |
        v
Introduce tiny mutant share epsilon
        |
        v
Compare expected fitness
  F_resident > F_mutant?
       / \
     yes  no
     /      \
resists     invasion can grow
invasion
~~~

| Solution concept | Main question | Comparison |
|---|---|---|
| Best response | What is optimal against a fixed opponent strategy? | One player's alternatives |
| Nash equilibrium | Does anyone gain by deviating alone? | At the equilibrium profile |
| ESS | Can any rare mutant invade? | First-order test plus tie-breaker |
| Dynamic stability | Do nearby states return over time? | Depends on an evolution rule |

## 6. Common Interview Questions

### Q1. What is an ESS?

**Answer:** A strategy that, when used by almost the whole population, earns greater expected fitness than any sufficiently rare mutant. Formally it satisfies the two-condition invasion test.

**Expected:** Rare-mutant interpretation, both inequalities, symmetric-game context.  
**Common mistake:** Saying only “an ESS is a Nash equilibrium.”

### Q2. Why must an ESS be a Nash equilibrium?

**Answer:** If some mutant earned more against the resident than the resident earns against itself, it would grow when rare. Therefore the resident must be a best response to itself.

**Expected:** \(u(s^*,s^*)\ge u(s,s^*)\).  
**Common mistake:** Claiming every Nash equilibrium is ESS.

### Q3. Is every strict symmetric Nash equilibrium an ESS?

**Answer:** Yes. Strictness gives \(u(s^*,s^*)>u(s,s^*)\) for every alternative, which directly satisfies the first ESS condition.

**Expected:** Explain why no tie-breaker is needed.  
**Common mistake:** Confusing a strict equilibrium with a strictly dominant strategy.

### Q4. Can a non-strict Nash equilibrium be ESS?

**Answer:** Yes. It can pass the second ESS condition when a mutant ties against residents but residents outperform the mutant in cross encounters.

**Expected:** Mention the tie case.  
**Common mistake:** Assuming ESS always requires strict Nash equilibrium.

### Q5. Can a game have more than one ESS?

**Answer:** Yes. Coordination games often have multiple pure ESSs, each locally resistant around its own population state.

**Expected:** Local basins and path dependence.  
**Common mistake:** Assuming stability implies uniqueness.

### Q6. Can an ESS be mixed?

**Answer:** Yes. A probability distribution can resist all alternative distributions. Hawk-Dove commonly has an interior mixed ESS.

**Expected:** Equal payoff on support and invasion resistance.  
**Common mistake:** Testing only pure mutants.

### Q7. What is the role of \(\varepsilon\)?

**Answer:** It is the mutant population share. ESS requires resistance for all sufficiently small positive values, not necessarily for every population composition.

**Expected:** Local nature of ESS.  
**Common mistake:** Treating \(\varepsilon\) as a player's mixed-strategy probability only.

### Q8. Does ESS imply Pareto efficiency?

**Answer:** No. Evolution rewards relative fitness, not total welfare. A stable convention can be socially inefficient.

**Expected:** Stability versus welfare.  
**Common mistake:** Treating “stable” as “best.”

### Q9. How do you test a pure ESS in a finite matrix?

**Answer:** For each candidate diagonal action, compare its diagonal payoff with every mutant payoff against that resident. Resolve equality with the cross-payoff comparison.

**Expected:** Correct player payoff and both conditions.  
**Common mistake:** Comparing payoff sums or the wrong coordinate.

### Q10. What is the difference between ESS and evolutionary dominance?

**Answer:** ESS is local resistance to rare mutants. A globally dominant strategy outperforms alternatives across all population compositions, a stronger property.

**Expected:** Local versus global.  
**Common mistake:** Using the terms interchangeably.

## 7. Deep-Dive Questions

### 1. Derive the two ESS conditions from expected fitness.

Subtract \(F_M\) from \(F_R\):

\[
F_R-F_M=(1-\varepsilon)[u(R,R)-u(M,R)]
+\varepsilon[u(R,M)-u(M,M)].
\]

If the first bracket is positive, it dominates for sufficiently small \(\varepsilon\). If it is zero, the second bracket must be positive. These are exactly the two ESS conditions.

### 2. Why must a mixed ESS equalize payoffs on its support?

If a supported pure action earned less than another supported action, shifting probability toward the better action would improve payoff against the resident mixture. The original mixture would not be a best response to itself and therefore could not be ESS.

### 3. Can a mixed symmetric Nash equilibrium fail to be ESS?

Yes. Equal payoffs on the support establish Nash equilibrium, but a nearby mutant mixture may be neutrally equivalent or may gain through mutant-mutant interactions. The second-order ESS test can fail.

### 4. How is ESS related to local maxima of payoff?

In a symmetric game, \(p^*\) is ESS if it locally beats nearby alternatives in the relevant invasion comparison. Under additional conditions this corresponds to a strict local maximum of an appropriate population payoff function, but general asymmetric payoff matrices need careful treatment.

### 5. Does mutation destroy ESS?

Small persistent mutation typically moves the stationary population slightly away from the mutation-free ESS. It can also select among equilibria. ESS remains a useful limiting concept, but the exact stationary state belongs to replicator-mutator dynamics.

## 8. Comparison Tables

| Property | Nash equilibrium | ESS |
|---|---|---|
| Setting | General strategic games | Usually symmetric population games |
| Test | No profitable unilateral deviation | No successful rare mutant |
| Strictness | Weak best response is enough | Tie needs second condition |
| Population interpretation | Optional | Central |
| Multiple solutions | Possible | Possible |
| Implies the other? | Not necessarily ESS | Always symmetric Nash |

| Property | Pure ESS | Mixed ESS |
|---|---|---|
| State | One action has frequency 1 | Several actions have positive frequency |
| Typical source | Coordination or dominance | Anti-coordination |
| Payoffs on support | One relevant action | Equalized at equilibrium |
| Main trap | Missing tie-breaker | Checking only pure deviations |

## 9. Common Mistakes

- Calling every Nash equilibrium evolutionarily stable.
- Ignoring the second ESS condition when the first comparison ties.
- Comparing total social payoff instead of the focal type's fitness.
- Testing only one mutant in a game with many strategies.
- Assuming an ESS attracts every initial population state.
- Treating genetic evolution, learning, and imitation as identical mechanisms.
- Assuming a mixed ESS always means each individual literally randomizes.

## 10. Edge Cases / Special Cases

- A weak symmetric Nash equilibrium may be ESS, neutrally stable, or unstable.
- Multiple ESSs create basins of attraction; initial frequencies can determine the outcome.
- An absent strategy can have equal fitness at the boundary, making linearization inconclusive.
- In finite populations, random drift can eliminate even a locally favored strategy.
- Mutation prevents frequencies from reaching exact zero.
- Asymmetric roles such as buyer and seller require asymmetric evolutionary models; the standard single-population ESS definition is not directly applicable.
- Payoff transformations that preserve positive affine order preserve ESS; arbitrary nonlinear transformations may not.

## 11. How to Explain in Interview

“An ESS is a symmetric strategy that cannot be invaded by a rare mutant. I first check that the resident does at least as well against itself as any mutant does against it. If there is a tie, I check that the resident does better against the mutant than the mutant does against itself. Therefore every ESS is a symmetric Nash equilibrium, but a Nash equilibrium need not be evolutionarily stable.”

## 12. Quick Revision Notes

- **Definition:** Rare-mutant invasion resistance.
- **First test:** \(u(s^*,s^*)>u(s,s^*)\).
- **Tie-breaker:** \(u(s^*,s)>u(s,s)\).
- **Must remember:** ESS implies symmetric Nash equilibrium.
- **Comparison:** Nash tests deviation; ESS tests population invasion.
- **Trap:** Stability is usually local, not global.

## 13. Practice Tasks

1. For a \(3\times3\) symmetric payoff matrix, list all symmetric Nash equilibria and test each for ESS.
2. Derive \(F_R-F_M\) as a function of mutant share.
3. Construct a symmetric Nash equilibrium that fails the ESS tie-breaker.
4. Write a Python or C++ function that tests every pure strategy for ESS.
5. Simulate a resident-mutant population for several starting mutant shares.
6. Explain why a strict symmetric Nash equilibrium automatically passes the ESS test.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | A resident strategy that no sufficiently rare mutant can outperform |
| Why it matters | Predicts robust conventions without assuming rational calculation |
| Most asked | ESS conditions; ESS vs Nash; pure vs mixed ESS |
| Key comparison | Every ESS is symmetric Nash; not every symmetric Nash is ESS |
| Interview trap | Forgetting the second condition on equality |
| One-line answer | “ESS is Nash equilibrium plus resistance to rare-mutant invasion.” |

# Replicator Dynamics

## 1. Overview

**Replicator dynamics** is a mathematical model of how strategy frequencies change when strategies with above-average payoff grow and strategies with below-average payoff shrink. For strategies \(1,\ldots,n\), population state \(x\) lies in the simplex, where \(x_i\ge0\) and \(\sum_i x_i=1\).

For payoff matrix \(A\),

\[
\dot{x}_i=x_i\left[(Ax)_i-x^\top Ax\right].
\]

Here \((Ax)_i\) is strategy \(i\)'s fitness and \(x^\top Ax\) is average population fitness.

Replicator dynamics matters because it turns a static game into a time-evolving system. It is used to model biological selection, imitation learning, market-share competition, protocol adoption, routing choices, and multi-agent learning. Interviewers ask it to connect matrices, differential equations, equilibria, stability, and simulation.

## 2. Core Idea

### Intuition

Growth is driven by **relative**, not absolute, performance:

- Above-average payoff: frequency rises.
- Equal-to-average payoff: instantaneous frequency is unchanged.
- Below-average payoff: frequency falls.

The factor \(x_i\) means a strategy already absent cannot spontaneously appear.

### Real-world analogy

Think of competing backend libraries. Teams copy libraries that appear more reliable than the ecosystem average. A library's adoption rate depends both on how common it already is and how much better it performs.

### Small two-strategy example

Let \(x\) be the share playing \(A\), so \(1-x\) plays \(B\). If

\[
\pi_A(x)=3x+1(1-x)=1+2x
\]

and

\[
\pi_B(x)=2x+2(1-x)=2,
\]

then

\[
\dot{x}=x(1-x)(\pi_A-\pi_B)=x(1-x)(2x-1).
\]

The fixed points are \(x=0,\frac12,1\). Below \(\frac12\), \(A\) declines; above it, \(A\) grows. The interior point is an unstable threshold.

### Step-by-step interpretation

1. Compute each strategy's expected payoff against the current population.
2. Compute the weighted average payoff.
3. Subtract average payoff from each strategy's payoff.
4. Multiply by its current frequency.
5. Follow the signs to see which shares rise or fall.
6. Find rest points by setting every \(\dot{x}_i=0\).
7. Analyze nearby arrows or eigenvalues to classify stability.

## 3. Important Subtopics

### 3.1 The simplex and invariance

The state space is the probability simplex. Since \(\sum_i\dot{x}_i=0\), total frequency stays one. Because \(\dot{x}_i\) contains \(x_i\), every face of the simplex is invariant: an absent strategy remains absent.

**Interview angle:** Prove mass conservation and explain why mutation needs a modified equation.

### 3.2 Fitness and average fitness

\((Ax)_i\) is the expected payoff of pure strategy \(i\) against population \(x\). The mean \(x^\top Ax\) makes growth relative. Adding the same population-dependent constant to all strategy payoffs does not change the dynamics.

**Interview angle:** Explain why absolute payoff level is irrelevant.

### 3.3 Rest points

A state is stationary when every present strategy earns the population average; absent strategies automatically have zero derivative even if they could earn more. Therefore not every boundary rest point is a Nash equilibrium.

**Interview angle:** Distinguish “mathematical rest point” from “stable equilibrium.”

### 3.4 Stability

- **Stable:** nearby trajectories remain nearby.
- **Asymptotically stable:** nearby trajectories converge.
- **Unstable:** some nearby trajectories move away.
- **Neutral/cyclic:** trajectories may orbit without convergence.

For one-dimensional dynamics, a sign chart usually suffices. For higher dimensions, use a Jacobian restricted to the simplex.

### 3.5 Discrete-time replicator update

A common update is

\[
x_i'=\frac{x_i f_i(x)}{\bar f(x)}.
\]

It requires suitable nonnegative fitness values. Large discrete steps can overshoot or behave differently from the continuous equation.

### 3.6 Replicator-mutator dynamics

Mutation or exploration allows absent strategies to reappear:

\[
\dot{x}_i=\sum_j x_j f_j(x)Q_{ji}-x_i\bar f(x),
\]

where \(Q_{ji}\) is the probability that reproduction from type \(j\) produces type \(i\).

### 3.7 Relation to learning

Replicator dynamics can arise from proportional imitation or multiplicative-weights learning in a continuous-time limit. The interpretation changes, but the mathematics often matches.

## 4. Real-World Example

### Adaptive request routing

Suppose a gateway distributes requests among services. Each routing policy receives a payoff based on latency, success rate, and cost. Policies that outperform the current weighted average receive a larger traffic share.

The update naturally preserves total traffic share. It can discover a stable split without a centralized optimizer, but it has practical limits:

- A route at zero share is never sampled again.
- Noisy latency can cause oscillation.
- Delayed feedback can destabilize updates.
- A small exploration or mutation term is needed to rediscover recovered routes.

This is conceptually related to production load balancing, although real systems use safety constraints, bounded steps, and explicit exploration.

## 5. Diagrams / Mental Models

~~~text
current frequencies x
        |
        v
payoff of each strategy: Ax
        |
        v
population average: x^T A x
        |
        v
relative advantage: (Ax)i - average
        |
        v
frequency change: xi * relative advantage
~~~

For \(\dot{x}=x(1-x)(2x-1)\):

~~~text
0 -------- 1/2 -------- 1
     <------   ------>
stable       unstable    stable
boundary     threshold   boundary
~~~

## 6. Common Interview Questions

### Q1. State the replicator equation.

**Answer:** \(\dot{x}_i=x_i[(Ax)_i-x^\top Ax]\).  
**Expected:** Identify frequency, strategy fitness, and mean fitness.  
**Mistake:** Omitting \(x_i\), which changes the model.

### Q2. Why do above-average strategies grow?

**Answer:** Their relative fitness term is positive, so with \(x_i>0\), \(\dot{x}_i>0\).  
**Expected:** Sign reasoning.  
**Mistake:** Comparing only raw payoff to zero.

### Q3. Why does the population sum remain one?

**Answer:** Summing derivatives gives \(\sum_i x_i f_i-\bar f\sum_i x_i=\bar f-\bar f=0\).  
**Expected:** Conservation calculation.  
**Mistake:** Treating normalization as an external correction.

### Q4. Can an absent strategy return?

**Answer:** Not under basic replicator dynamics because \(x_i=0\) implies \(\dot{x}_i=0\). Mutation or exploration is needed.  
**Expected:** Invariant boundary.  
**Mistake:** Assuming high hypothetical payoff causes spontaneous entry.

### Q5. Is every rest point a Nash equilibrium?

**Answer:** No. At a boundary, absent strategies have zero derivative even when they would outperform incumbents.  
**Expected:** Boundary counterexample.  
**Mistake:** Equating zero derivative with strategic optimality.

### Q6. What characterizes an interior rest point?

**Answer:** Every strategy has positive frequency and earns the same payoff as the population average.  
**Expected:** Equal-payoff condition.  
**Mistake:** Claiming each payoff is zero.

### Q7. How do you analyze a two-strategy game?

**Answer:** Reduce it to \(\dot{x}=x(1-x)[\pi_A(x)-\pi_B(x)]\), find roots, then draw a sign chart.  
**Expected:** Boundary and interior roots.  
**Mistake:** Solving only \(\pi_A=\pi_B\) and missing boundaries.

### Q8. How does ESS relate to replicator dynamics?

**Answer:** ESS generally implies local asymptotic stability under standard assumptions, but the concepts are defined differently and the converse needs conditions.  
**Expected:** Payoff condition versus dynamic process.  
**Mistake:** Claiming equivalence in every game.

### Q9. What happens in Rock-Paper-Scissors?

**Answer:** Depending on payoffs, trajectories may cycle around an interior rest point, spiral inward, or spiral outward.  
**Expected:** Dynamics depend on payoff parameters.  
**Mistake:** Saying replicator dynamics always converges.

### Q10. Why is time scaling often irrelevant?

**Answer:** Multiplying all payoff differences by a positive constant changes trajectory speed but not paths or stability directions.  
**Expected:** Positive scaling.  
**Mistake:** Extending this to arbitrary nonlinear transformations.

## 7. Deep-Dive Questions

### 1. Derive the two-strategy equation.

With shares \(x\) and \(1-x\), average payoff is \(x\pi_A+(1-x)\pi_B\). Thus
\[
\dot{x}=x[\pi_A-\bar\pi]
=x(1-x)(\pi_A-\pi_B).
\]

### 2. Why can average fitness fail to increase?

In symmetric partnership games it often acts like a Lyapunov function, but in general games frequency-dependent interactions can create cycles. Fisher-style monotonicity is not universal.

### 3. How do you linearize around an interior fixed point?

Compute the Jacobian of the vector field, remove the redundant direction normal to the simplex, and inspect eigenvalues. Negative real parts imply local asymptotic stability; positive real parts imply instability.

### 4. What is the connection to multiplicative weights?

Both update weights proportionally to performance. With small learning rates, normalized exponential or multiplicative updates approach replicator dynamics in continuous time.

### 5. How do delays affect the model?

If fitness is based on stale population states, feedback may arrive after the population has changed. Delays can create oscillations or destabilize a fixed point that is stable without delay.

## 8. Comparison Tables

| Aspect | Replicator dynamics | Best-response dynamics |
|---|---|---|
| Update | Proportional to relative payoff | Move toward a current best response |
| Information | Payoff of used strategies | Requires identifying maxima |
| Smoothness | Usually smooth in the interior | Often discontinuous |
| Absent strategies | Cannot re-enter | May enter immediately |
| Behavior | May converge or cycle | May converge, jump, or cycle |

| Aspect | Continuous time | Discrete time |
|---|---|---|
| Form | Differential equation | Iterative map |
| Step size | Infinitesimal | Explicit or implicit |
| Stability | Local vector-field analysis | Eigenvalues must lie inside unit circle |
| Risk | Modeling approximation | Overshoot and negative/invalid shares |

## 9. Common Mistakes

- Forgetting the frequency multiplier \(x_i\).
- Forgetting boundary rest points.
- Assuming every rest point is Nash or ESS.
- Assuming average fitness always increases.
- Using raw payoff instead of payoff relative to the mean.
- Simulating with a step so large that frequencies become negative.
- Expecting an extinct strategy to reappear without mutation.

## 10. Edge Cases / Special Cases

- At a boundary, an absent but profitable strategy still has zero derivative.
- Equal fitness everywhere makes every state stationary.
- Zero-sum cyclic games may have conserved quantities rather than convergence.
- Numerical rounding can remove low-frequency strategies permanently.
- Negative fitness is fine in continuous time but can break simple discrete proportional updates.
- Degenerate fixed points may require nonlinear analysis because the Jacobian has zero eigenvalues.

## 11. How to Explain in Interview

“Replicator dynamics tracks strategy shares. A strategy grows at a rate equal to its current share times its payoff advantage over the population average: \(\dot{x}_i=x_i(f_i-\bar f)\). This preserves the simplex and makes boundaries invariant. Rest points equalize payoff among present strategies, but a boundary rest point need not be Nash because absent strategies cannot enter.”

## 12. Quick Revision Notes

- Equation: \(\dot{x}_i=x_i[(Ax)_i-x^\top Ax]\).
- Above average grows; below average shrinks.
- Shares remain nonnegative and sum to one.
- Every boundary face is invariant.
- Interior rest point: all payoffs equal.
- Trap: rest point does not automatically mean Nash.

## 13. Practice Tasks

1. Derive and plot the phase line for a \(2\times2\) coordination game.
2. Implement Euler integration and assert that shares approximately sum to one.
3. Compare small and large time steps and observe numerical instability.
4. Simulate Rock-Paper-Scissors from three initial states.
5. Add mutation and observe whether extinct strategies return.
6. Compute a Jacobian at an interior equilibrium.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Dynamics where relative fitness changes strategy frequency |
| Why it matters | Connects payoff incentives to population evolution |
| Most asked | Equation, fixed points, simplex invariance, ESS relation |
| Main comparison | Replicator adjusts proportionally; best response jumps toward maxima |
| Trap | An absent profitable strategy remains absent |
| One-line answer | “A strategy's share grows exactly when it beats average population fitness.” |

# Population Games

## 1. Overview

A **population game** models a large collection of agents choosing among strategies when each strategy's payoff depends on aggregate usage rather than individual identities. A population state \(x\) records masses or proportions, and a payoff function \(F_i(x)\) assigns the payoff of strategy \(i\).

Population games matter because many systems are too large for an explicit player-by-player normal form. They are used in traffic routing, communication networks, cloud-resource selection, load balancing, market participation, epidemiological behavior, and distributed control. Interviewers ask them to test abstraction: converting many local choices into aggregate state, identifying equilibrium, and understanding congestion externalities.

## 2. Core Idea

### Intuition

Each individual is negligible, but the crowd matters. One driver's route choice barely changes traffic; millions of choices determine every route's delay.

### Real-world analogy

Developers choose among cloud regions. If too many choose the lowest-latency region, congestion raises its latency. Some workloads shift elsewhere until all used regions offer equal effective cost and no single workload benefits by switching.

### Small example

One unit of traffic chooses route A or B:

\[
c_A(x_A)=1+x_A,\qquad c_B(x_B)=1.4+0.2x_B
\]

with \(x_A+x_B=1\). At an interior Wardrop equilibrium, used routes have equal cost:

\[
1+x_A=1.4+0.2(1-x_A).
\]

Thus \(1.2x_A=0.6\), so \(x_A=x_B=0.5\), and both costs are \(1.5\).

### Step-by-step model

1. Define populations and available strategies.
2. Represent aggregate masses in a feasible state set.
3. Define payoff or cost as a function of aggregate state.
4. Find states where no infinitesimal agent benefits by switching.
5. Check efficiency, stability, and the dynamics used to reach equilibrium.

## 3. Important Subtopics

### 3.1 Population state and simplex

For one population of mass \(m\), \(x_i\ge0\) and \(\sum_i x_i=m\). Multiple populations have product simplexes and may have different strategy sets. This representation reduces a huge game to a small number of aggregate variables.

**Interview angle:** Explain what information aggregation discards and when agents can be treated as nonatomic.

### 3.2 Nonatomic agents

In a nonatomic model, one individual's action does not measurably change aggregate payoffs. Equilibrium therefore compares current costs without including a unilateral agent's impact. This is an approximation to large finite systems.

**Example:** A single packet does not alter average link congestion, though total flow does.

### 3.3 Wardrop equilibrium

For cost minimization, all used strategies have minimum cost:

\[
x_i>0\Rightarrow c_i(x)\le c_j(x)\quad\text{for all }j.
\]

Unused strategies may have equal or higher cost. Wardrop equilibrium is the nonatomic analogue of Nash equilibrium.

**Interview angle:** Do not require every route to be used or every route to have equal cost.

### 3.4 Congestion games

A strategy may consume several resources, and each resource's cost depends on total load. A route's total cost is the sum of its edge costs. Congestion creates negative externalities because a user's choice raises costs for others.

### 3.5 Potential games

A potential function changes in the same direction as individual incentives. In congestion games, minimizing the Beckmann potential

\[
\Phi(x)=\sum_e\int_0^{x_e} c_e(z)\,dz
\]

can characterize Wardrop equilibria. Potential structure is valuable because it converts equilibrium search into optimization.

### 3.6 Social optimum and price of anarchy

Equilibrium minimizes individual perceived cost, not total cost. The social optimum minimizes

\[
C(x)=\sum_e x_ec_e(x_e).
\]

The ratio between worst equilibrium cost and optimal cost is the **price of anarchy**.

### 3.7 Dynamics

Replicator, best-response, logit, and Smith dynamics describe how populations adjust. Equilibrium existence does not guarantee that a particular dynamic converges to it.

## 4. Real-World Example

### Backend request routing

A large API platform sends traffic to several clusters. Strategy \(i\) means choosing cluster \(i\); its cost combines latency, error rate, and monetary price. Cost rises with load.

At a population equilibrium:

- Every cluster receiving traffic has minimum effective cost.
- An unused cluster cannot offer strictly lower cost.
- Equal costs do not imply equal loads because clusters may have different capacity curves.
- The equilibrium can still overload shared resources compared with a centrally optimized allocation.

Engineers can introduce congestion pricing, quotas, or routing weights to align selfish or decentralized choices with system-wide goals.

## 5. Diagrams / Mental Models

~~~text
many tiny agents
      |
      v
aggregate strategy masses x
      |
      v
resource loads and payoff/cost F(x)
      |
      v
agents switch toward better strategies
      |
      v
equilibrium: every used strategy is optimal
~~~

| Route status | Wardrop condition |
|---|---|
| Used, \(x_i>0\) | Cost equals the minimum available cost |
| Unused, \(x_i=0\) | Cost is at least the minimum |

## 6. Common Interview Questions

### Q1. What is a population game?

**Answer:** A game where aggregate masses choose strategies and payoffs depend on the aggregate state.  
**Expected:** Large/nonatomic population and state-dependent payoffs.  
**Mistake:** Describing only a repeated two-player game.

### Q2. What is a population state?

**Answer:** A vector of nonnegative strategy masses or frequencies satisfying total-mass constraints.  
**Expected:** Simplex representation.  
**Mistake:** Treating entries as payoffs.

### Q3. What is a Wardrop equilibrium?

**Answer:** A state where all used strategies have minimum cost, so no infinitesimal agent gains by switching.  
**Expected:** Used versus unused condition.  
**Mistake:** Requiring all routes to have equal cost.

### Q4. How does Wardrop equilibrium relate to Nash equilibrium?

**Answer:** It is the nonatomic population analogue. Each negligible agent chooses a best response to aggregate congestion.  
**Expected:** Individual effect vanishes.  
**Mistake:** Calling the concepts numerically identical in finite games.

### Q5. Why can equilibrium be inefficient?

**Answer:** Individuals consider their own cost but not the delay they impose on others.  
**Expected:** Congestion externality.  
**Mistake:** Blaming inefficiency only on bad information.

### Q6. What is a potential function?

**Answer:** A scalar function whose changes track incentives. Its local minima can characterize equilibria in cost games.  
**Expected:** Optimization connection.  
**Mistake:** Confusing potential with total social cost.

### Q7. What is the price of anarchy?

**Answer:** The ratio of the cost of the worst equilibrium to the minimum possible social cost.  
**Expected:** Worst equilibrium and social optimum.  
**Mistake:** Using best equilibrium or reversing the ratio.

### Q8. Do used strategies always have equal load?

**Answer:** No. They have equal minimum cost; different cost functions can support different loads.  
**Expected:** Cost equality, not load equality.  
**Mistake:** Inferring symmetry where none exists.

### Q9. When is the nonatomic assumption reasonable?

**Answer:** When each agent's effect is tiny relative to total demand, such as packets, drivers, or requests at scale.  
**Expected:** Approximation and limitation.  
**Mistake:** Applying it to a few dominant agents.

### Q10. Does equilibrium existence imply convergence?

**Answer:** No. Convergence depends on the chosen learning or adjustment dynamics and payoff structure.  
**Expected:** Static versus dynamic distinction.  
**Mistake:** Assuming best-response updates always settle.

## 7. Deep-Dive Questions

### 1. Derive Wardrop conditions as complementarity.

If \(\lambda\) is minimum cost, then \(c_i(x)-\lambda\ge0\), \(x_i\ge0\), and
\[
x_i[c_i(x)-\lambda]=0.
\]
Positive flow forces equal minimum cost; unused strategies may cost more.

### 2. Why is the Beckmann potential not total latency?

The derivative of \(\int_0^{x_e}c_e(z)dz\) is the private edge cost \(c_e(x_e)\), matching user incentives. Total latency is \(x_ec_e(x_e)\), whose derivative includes the marginal external cost \(x_ec_e'(x_e)\).

### 3. How can tolls implement the social optimum?

Charge each user the marginal external cost \(x_ec_e'(x_e)\). Then perceived marginal cost becomes \(c_e+x_ec_e'\), matching the derivative of total latency.

### 4. What changes with atomic players?

Each player's flow has non-negligible effect, so deviation changes congestion. Equilibrium conditions include that impact, and uniqueness or potential properties may change.

### 5. Can adding capacity worsen equilibrium?

Yes. Braess's paradox shows that a new link can alter selfish routing so that every user experiences greater delay. The new feasible action changes incentives, not merely capacity.

## 8. Comparison Tables

| Aspect | Finite normal-form game | Population game |
|---|---|---|
| Players | Explicit individuals | Aggregate masses |
| Individual impact | Usually non-negligible | Negligible in nonatomic model |
| State | Strategy profile | Frequency/flow vector |
| Equilibrium | Nash | Wardrop/population Nash |
| Typical application | Bargaining, pricing | Routing, load balancing |

| Aspect | Wardrop equilibrium | Social optimum |
|---|---|---|
| Objective | No user can reduce private cost | Minimize total cost |
| Externality | Ignored | Internalized |
| Characterization | Used routes have minimum private cost | Used routes equalize marginal social cost |
| Relationship | May be inefficient | Benchmark |

## 9. Common Mistakes

- Requiring unused strategies to have the same cost as used ones.
- Confusing equal cost with equal flow.
- Treating one nonatomic user's action as changing congestion.
- Assuming the potential equals total social cost.
- Reversing the price-of-anarchy ratio.
- Assuming adding a resource always improves equilibrium.
- Ignoring multiple populations with different feasible strategies.

## 10. Edge Cases / Special Cases

- Flat cost functions can yield a continuum of equilibria.
- Equilibrium flows may be nonunique even when aggregate resource costs are unique.
- Discontinuous costs can break standard existence arguments.
- Atomic and nonatomic models give different deviation calculations.
- Demand may be elastic rather than fixed.
- Shared resources couple strategies even when route labels differ.
- Braess's paradox can make extra capacity harmful under selfish routing.

## 11. How to Explain in Interview

“A population game compresses many small agents into strategy masses. Payoffs depend on the aggregate state. In a Wardrop equilibrium, every used strategy has minimum cost and every unused strategy has no lower cost. It is the nonatomic version of Nash equilibrium and is useful for routing and load balancing, but it can be socially inefficient because agents ignore congestion externalities.”

## 12. Quick Revision Notes

- State = nonnegative masses satisfying total-demand constraints.
- Nonatomic = one agent has negligible effect.
- Wardrop = used strategies have minimum cost.
- Potential can turn equilibrium computation into optimization.
- Social cost differs from private cost.
- Price of anarchy measures equilibrium inefficiency.
- Trap: equal cost does not mean equal flow.

## 13. Practice Tasks

1. Solve a two-route Wardrop equilibrium with affine costs.
2. Compute the socially optimal flow and price of anarchy.
3. Implement a best-response routing simulation.
4. Write complementarity conditions for three resources.
5. Construct a Braess network and compare before/after equilibrium latency.
6. Explain when cloud tenants should be modeled as atomic rather than nonatomic.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Aggregate game with state-dependent strategy payoffs |
| Why it matters | Models routing, congestion, adoption, and load balancing at scale |
| Most asked | Wardrop equilibrium, potential, price of anarchy |
| Main comparison | Wardrop optimizes private choices; social optimum internalizes externality |
| Trap | Only used strategies must have equal minimum cost |
| One-line answer | “A population game replaces named players with masses whose payoffs depend on aggregate usage.” |

# Hawk-Dove Game

## 1. Overview

The **Hawk-Dove game** models conflict over a resource. Hawk escalates and fights; Dove displays but retreats from escalation. Let resource value be \(V>0\) and fighting cost be \(C>0\):

| Player 1 \ Player 2 | Hawk | Dove |
|---|---:|---:|
| **Hawk** | \(((V-C)/2,(V-C)/2)\) | \((V,0)\) |
| **Dove** | \((0,V)\) | \((V/2,V/2)\) |

It matters because it explains frequency-dependent aggression, stable behavioral mixtures, anti-coordination, and why a costly behavior can persist without dominating. Applications include animal conflict, cybersecurity escalation, market entry, resource contention, and collision-avoidance protocols. Interviewers ask it because one small matrix connects best responses, Nash equilibrium, mixed equilibrium, ESS, and replicator dynamics.

## 2. Core Idea

### Intuition

Hawk works well against Dove but may be costly against Hawk. Dove avoids costly fights but yields to Hawk. Therefore the best action depends on what others do.

### Real-world analogy

Two services compete for a lock:

- Hawk retries aggressively, gaining the resource quickly against a polite service.
- Two aggressive services create contention and waste CPU.
- Dove backs off, avoiding contention but losing against Hawk.

### Small example: \(V=2, C=4\)

| Player 1 \ Player 2 | Hawk | Dove |
|---|---:|---:|
| **Hawk** | (-1, -1) | (2, 0) |
| **Dove** | (0, 2) | (1, 1) |

Best responses:

- Against Dove, choose Hawk: \(2>1\).
- Against Hawk, choose Dove: \(0>-1\).

Thus \((H,D)\) and \((D,H)\) are pure Nash equilibria. In a symmetric population, a mixed equilibrium has Hawk frequency \(p=V/C=1/2\).

### Step-by-step mixed calculation

If opponents use Hawk with probability \(p\):

\[
U(H)=p\frac{V-C}{2}+(1-p)V
\]

\[
U(D)=p(0)+(1-p)\frac V2.
\]

Set them equal:

\[
p\frac{V-C}{2}+(1-p)V=(1-p)\frac V2
\]

which simplifies to \(p=V/C\), valid as an interior probability when \(0<V<C\).

## 3. Important Subtopics

### 3.1 Best responses and anti-coordination

When \(C>V\), Dove is the best response to Hawk and Hawk is the best response to Dove. Players prefer different roles. This makes the game an anti-coordination game.

**Interview angle:** Mark best responses in the correct payoff coordinate and identify two asymmetric pure equilibria.

### 3.2 Mixed Nash equilibrium

At \(p=V/C\), Hawk and Dove earn equal expected payoff, so a player is willing to mix. The probability is obtained by making the opponent indifferent, not by maximizing one's own payoff directly.

**Interview angle:** Candidates often invert the probability or use the wrong player's payoffs.

### 3.3 Mixed ESS

For \(C>V\), neither pure strategy is ESS:

- All-Hawk can be invaded by Dove because avoiding a costly fight is better.
- All-Dove can be invaded by Hawk because Hawk takes the full resource.

The mixed population with Hawk share \(V/C\) is ESS under the standard assumptions.

### 3.4 Parameter regimes

- \(C>V>0\): classic Hawk-Dove; two asymmetric pure Nash equilibria and an interior mixed equilibrium.
- \(C=V\): Hawk-Hawk payoff is zero; degeneracy creates weak incentives.
- \(V>C>0\): fighting is worth its cost; Hawk becomes attractive even against Hawk, and all-Hawk is stable.

### 3.5 Population interpretation versus individual mixing

A 25% Hawk equilibrium can mean every individual randomizes with probability 0.25 or 25% are fixed Hawks and 75% fixed Doves. These produce the same random-matching payoffs in a simple model but differ under identity, memory, inheritance, or repeated interaction.

### 3.6 Replicator dynamics

Let \(x\) be Hawk frequency. The two-strategy equation has an interior rest point \(x^*=V/C\). For \(C>V\), arrows point toward it: Hawk grows below \(x^*\), while Dove grows above it.

## 4. Real-World Example

### Aggressive versus polite retry policies

A distributed system's clients contend for a scarce service slot.

- An aggressive client captures capacity when matched with a backoff client.
- Two aggressive clients amplify collisions, throttling, and wasted retries.
- Two polite clients share without severe contention.

If collision cost exceeds the value of immediate access, neither universal aggression nor universal politeness is robust. A stable mixture can emerge. Production protocols normally replace uncontrolled evolution with randomized exponential backoff, which deliberately implements probabilistic anti-coordination.

## 5. Diagrams / Mental Models

~~~text
Opponent is Dove -> Hawk takes resource -> choose Hawk
Opponent is Hawk -> fight is too costly -> choose Dove

Best responses cross:
    (Hawk, Dove) and (Dove, Hawk)
~~~

For \(C>V\):

~~~text
Hawk share
0 -------- V/C -------- 1
     ------>   <------
        stable mixed ESS
~~~

## 6. Common Interview Questions

### Q1. What does the Hawk-Dove game model?

**Answer:** Conflict over a resource where escalation wins against restraint but mutual escalation is costly.  
**Expected:** Frequency-dependent incentives.  
**Mistake:** Calling Hawk strictly dominant in the classic \(C>V\) case.

### Q2. Write the standard payoff matrix.

**Answer:** Hawk-Hawk gives each \((V-C)/2\), Hawk-Dove gives \((V,0)\), and Dove-Dove gives \((V/2,V/2)\).  
**Expected:** Explain assumptions behind splitting.  
**Mistake:** Assigning the full fighting cost to each without adjusting the formula.

### Q3. What are the pure Nash equilibria when \(C>V\)?

**Answer:** \((H,D)\) and \((D,H)\).  
**Expected:** Crossed best responses.  
**Mistake:** Naming \((H,H)\) or \((D,D)\).

### Q4. Find the mixed equilibrium.

**Answer:** The probability of Hawk is \(p=V/C\), found by making Hawk and Dove equally profitable.  
**Expected:** Show indifference equation.  
**Mistake:** Reporting \(C/V\), which can exceed one.

### Q5. Why is all-Dove not ESS?

**Answer:** A rare Hawk receives \(V\) against Dove while resident Doves receive \(V/2\).  
**Expected:** Direct invasion comparison.  
**Mistake:** Arguing that Dove is socially peaceful, so it must be stable.

### Q6. Why is all-Hawk not ESS when \(C>V\)?

**Answer:** A rare Dove gets \(0\) against Hawk, while Hawk residents get \((V-C)/2<0\).  
**Expected:** Correct sign.  
**Mistake:** Assuming Hawk always wins.

### Q7. Is the mixed equilibrium stable under replicator dynamics?

**Answer:** Yes in the classic \(C>V\) case. Below \(V/C\), Hawk does better; above it, Dove does better.  
**Expected:** Directional argument.  
**Mistake:** Assuming mixed equilibria are always unstable.

### Q8. What if \(V>C\)?

**Answer:** Hawk earns a positive payoff even against Hawk and is the best response to both actions; all-Hawk becomes the relevant stable outcome.  
**Expected:** Parameter-sensitive answer.  
**Mistake:** Reusing \(V/C\) as an interior probability when it exceeds one.

### Q9. Is Hawk-Dove zero-sum?

**Answer:** Generally no. Total payoff differs across outcomes because fighting destroys value through cost.  
**Expected:** Compare cell sums.  
**Mistake:** Equating conflict with zero-sum structure.

### Q10. How is Hawk-Dove different from Prisoner's Dilemma?

**Answer:** Hawk-Dove has opposite best responses and multiple pure equilibria; Prisoner's Dilemma has mutual defection from dominant strategies.  
**Expected:** Anti-coordination versus dominance.  
**Mistake:** Saying both merely reward aggression.

## 7. Deep-Dive Questions

### 1. Derive the equilibrium average payoff.

At the mixed equilibrium, use Dove's payoff:
\[
\bar U=U(D)=(1-V/C)V/2=\frac{V(C-V)}{2C}.
\]
Hawk has the same payoff by indifference.

### 2. Derive the replicator equation.

With Hawk share \(x\),
\[
\dot{x}=x(1-x)[U(H)-U(D)].
\]
The payoff difference simplifies to \((V-Cx)/2\), so
\[
\dot{x}=\frac12x(1-x)(V-Cx).
\]

### 3. Why can both asymmetric pure Nash equilibria coexist with a symmetric mixed ESS?

The pure equilibria assign different roles to two labeled players. In a single symmetric random-matching population, no label permanently assigns who is Hawk; the stable aggregate is a mixture.

### 4. How would assessment or ownership change the game?

If contestants can observe strength or ownership, they can condition aggression on state. Strategies such as “owner plays Hawk, intruder plays Dove” may avoid costly fights and become stable.

### 5. What changes in a finite population?

Encounter probabilities use finite-population sampling, and stochastic drift matters. The equilibrium frequency need not be exactly \(V/C\), especially when mutations are rare and selection is weak.

## 8. Comparison Tables

| Property | Hawk-Dove | Prisoner's Dilemma | Coordination game |
|---|---|---|---|
| Incentive | Prefer opposite action | Defect is dominant | Prefer same action |
| Pure Nash equilibria | Two asymmetric | One, mutual defect | Usually two symmetric |
| Mixed equilibrium | Interior, typically stable | None interior in strict case | Interior, typically unstable |
| Social issue | Costly escalation | Cooperation failure | Equilibrium selection |

| Population state | Can invade? when \(C>V\) | Conclusion |
|---|---|---|
| All Dove | Hawk earns more | Not ESS |
| All Hawk | Dove avoids negative fight payoff | Not ESS |
| Hawk share \(V/C\) | Nearby deviations pushed back | Mixed ESS |

## 9. Common Mistakes

- Calling Hawk dominant without checking \(C>V\).
- Forgetting that fighting cost changes the Hawk-Hawk payoff.
- Inverting \(V/C\).
- Confusing two asymmetric pure Nash equilibria with pure ESSs in a symmetric population.
- Assuming the mixed equilibrium is always unstable.
- Ignoring parameter regimes where \(V/C\) is not a valid probability.
- Treating peaceful behavior as automatically evolutionarily stable.

## 10. Edge Cases / Special Cases

- At \(C=V\), the interior formula reaches one and inequalities become weak.
- If \(V=0\), resource-seeking incentives disappear and the standard interpretation degenerates.
- If \(C<0\), fighting becomes beneficial and the biological story changes completely.
- Assortative matching changes encounter probabilities and equilibrium frequency.
- Repeated encounters can support retaliation, reputation, or conditional strategies.
- Correlated roles such as owner/intruder can replace random mixing.

## 11. How to Explain in Interview

“Hawk-Dove models costly conflict. Hawk beats Dove, Dove is better against Hawk when fighting cost exceeds resource value, and two Doves split the resource. For \(C>V\), the game has two asymmetric pure Nash equilibria and a symmetric mixed equilibrium with Hawk probability \(V/C\). In a random-matching population that mixture is evolutionarily stable.”

## 12. Quick Revision Notes

- Matrix entries: HH \((V-C)/2\), HD \(V\), DH \(0\), DD \(V/2\).
- Classic assumption: \(C>V>0\).
- Pure Nash: \((H,D)\), \((D,H)\).
- Mixed Hawk share: \(V/C\).
- Neither all-Hawk nor all-Dove is ESS when \(C>V\).
- Trap: parameter regime matters.

## 13. Practice Tasks

1. Derive \(p=V/C\) from the indifference condition.
2. Mark best responses for \(V=3,C=5\).
3. Plot \(\dot{x}=\frac12x(1-x)(V-Cx)\).
4. Simulate replicator dynamics from \(x=0.1,0.5,0.9\).
5. Modify the game to include an ownership signal.
6. Compare equilibrium welfare with a rule that prevents mutual escalation.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Costly-conflict game between escalation and restraint |
| Why it matters | Canonical model of anti-coordination and mixed ESS |
| Most asked | Payoff matrix, pure NE, \(V/C\), stability |
| Main comparison | Unlike Prisoner's Dilemma, the best response switches with opponent action |
| Trap | \(V/C\) is interior only when \(C>V>0\) |
| One-line answer | “When fights cost more than the prize, evolution stabilizes Hawk frequency at \(V/C\).” |
