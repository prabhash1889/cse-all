# Game Theory Foundations for SDE Placements

Game theory studies situations in which the outcome for one decision-maker depends not only on that decision-maker's action, but also on the actions of others. This guide develops the vocabulary and models most useful in placement interviews: players, strategies, payoffs, rationality, normal-form and extensive-form representations, zero-sum and non-zero-sum interaction, and cooperative and non-cooperative games.

---

# Players, Strategies, and Payoffs

## 1. Overview

### Definition

Every game-theoretic model begins with three questions:

1. **Who makes decisions?** These decision-makers are the **players**.
2. **What can each player do?** A complete decision rule available to a player is a **strategy**.
3. **How much does each player value each possible outcome?** That value is the player's **payoff** or **utility**.

A game is not necessarily entertainment. A database client choosing when to retry, two services sharing limited capacity, competing sellers setting prices, and processes competing for CPU time can all be modeled as games.

### Why it matters

The three concepts separate a messy interaction into decision-makers, available choices, and objectives. Once these are defined correctly, we can ask precise questions: Is a strategy dominated? Is there a stable outcome? Does a protocol reward honest behavior? Can one participant benefit by deviating?

### Where it is used in real systems

- **Distributed systems:** independent nodes choose whether to cooperate, retry, report honestly, or consume shared resources.
- **Networking:** users choose transmission rates and routes while affecting congestion experienced by others.
- **Cloud computing:** tenants bid for resources or choose capacity under shared constraints.
- **Security:** attackers and defenders choose attack and defense strategies.
- **Databases:** transactions compete for locks and choose retry or backoff behavior.
- **Online platforms:** advertisers bid for impressions; recommendation systems respond to strategic creators and users.

### Why interviewers ask about it

Interviewers use these terms to test whether a candidate can convert a story into a formal model. The difficult part is usually not arithmetic; it is identifying the correct player boundary, the complete strategy set, and a payoff that represents the real objective rather than an easy-to-measure proxy.

## 2. Core Idea

### Intuition

Think of a game as a programmable interface:

```text
Players + allowed strategies + chosen strategy profile
                         |
                         v
                  outcome/payoffs
```

A **strategy profile** lists one strategy for every player. If players are `A` and `B`, and they choose strategies `s_A` and `s_B`, the profile is `(s_A, s_B)`. A payoff function maps that whole profile—not merely one player's own action—to each player's value.

For player `i`:

```text
u_i(s_1, s_2, ..., s_n) = player i's payoff under that strategy profile
```

### Real-world analogy

Two commuters choose between the same highway and a longer side road. Each commuter's travel time depends on both choices. A commuter cannot evaluate “take the highway” in isolation: it may be excellent when the other person uses the side road and poor when both use the highway.

### Small example

Two backend clients, A and B, simultaneously decide whether to send a request now or wait. Payoffs represent negative latency and failure cost; higher is better.

| A's choice | B's choice | A's payoff | B's payoff |
|---|---|---:|---:|
| Wait | Wait | 2 | 2 |
| Send | Wait | 5 | 1 |
| Wait | Send | 1 | 5 |
| Send | Send | -2 | -2 |

### Step-by-step explanation

1. **Players:** clients A and B.
2. **Actions:** each can `Send` or `Wait` in this one-shot situation.
3. **Strategy profile:** `(Send, Wait)` means A sends and B waits.
4. **Outcome:** only A uses the constrained server immediately.
5. **Payoffs:** A gets `5` because it finishes quickly; B gets `1` because it delays.
6. **Interdependence:** A's payoff from `Send` is `5` if B waits but `-2` if B sends.
7. **Modeling lesson:** a payoff is a preference score. It need not literally be money, and only its ordering may matter.

## 3. Important Subtopics

### 3.1 Players and player boundaries

**What it means:** A player is an entity capable of choosing among strategies. It may be a person, company, process, service, nation, autonomous agent, or coalition treated as one decision-maker.

**Why it matters:** Choosing the wrong boundary changes the game. Treating all microservices owned by one company as a single player may be sensible if they share one objective, but misleading if teams optimize separate service-level metrics.

**Example:** In an ad auction, the advertisers are players. The auction platform defines the mechanism; it is also a player only if it makes strategic choices within the modeled interaction.

**Common interview angle:** “Who are the players?” State who controls decisions, not every entity mentioned in the story. Nature or randomness may be represented separately as a chance player, but it has no preferences.

### 3.2 Actions versus strategies

**What it means:** An **action** is one move at one decision point. A **strategy** is a complete contingent plan specifying what a player would do at every decision point the player might face.

**Why it matters:** In a one-step simultaneous game, action and pure strategy often coincide. In a sequential game they do not.

**Example:** In a two-stage protocol, “send now” is an action. “Send initially; if rejected, wait one second and retry; if challenged, authenticate” is a strategy.

**Common interview angle:** Interviewers often ask why a strategy must specify behavior even at decision nodes that are not reached. The answer is that deviation and equilibrium analysis needs a complete plan for every contingency.

### 3.3 Pure and mixed strategies

**What it means:** A **pure strategy** selects one option with certainty. A **mixed strategy** is a probability distribution over pure strategies.

**Why it matters:** Some games, such as matching pennies, have no stable pure-strategy outcome but do have a mixed-strategy equilibrium.

**Example:** A security scanner checks route X with probability `0.7` and route Y with probability `0.3` so an attacker cannot predict its inspection route.

**Common interview angle:** Randomization is valuable when being predictable is exploitable. The player chooses the distribution; the realized action is sampled from it.

### 3.4 Strategy sets and feasibility

**What it means:** Player `i` has a strategy set `S_i`, containing all strategies permitted by the model.

**Why it matters:** An omitted strategy can create a false equilibrium. An impossible strategy can produce meaningless conclusions.

**Example:** If a transaction can abort, retry immediately, or retry after exponential backoff, a model allowing only abort/retry may miss the stable behavior introduced by backoff.

**Common interview angle:** Clarify constraints, information, timing, resource limits, and whether strategies are discrete or continuous.

### 3.5 Strategy profiles

**What it means:** A strategy profile `s = (s_1, ..., s_n)` specifies one strategy for every player. The notation `s_-i` means the strategies chosen by everyone except player `i`.

**Why it matters:** Best responses and Nash equilibrium compare `u_i(s_i, s_-i)` with the payoff from unilateral alternatives.

**Example:** For three load-balancing clients, `(Server 1, Server 2, Server 2)` is one profile.

**Common interview angle:** Explain that equilibrium is a property of a profile, not of one strategy in isolation.

### 3.6 Payoff functions

**What it means:** A payoff function `u_i` assigns a numerical value to every relevant outcome or strategy profile for player `i`.

**Why it matters:** The payoff captures what the player optimizes. Incorrect payoffs lead to correct mathematics about the wrong problem.

**Example:** A cloud client's payoff might be `value of completed jobs - compute price - latency penalty - failure risk`.

**Common interview angle:** State whether higher or lower is better. Costs can be converted to payoffs by negation.

### 3.7 Ordinal versus cardinal utility

**What it means:** **Ordinal utility** preserves preference order: payoff `4` being above `2` says the first outcome is preferred, not that it is twice as good. **Cardinal utility** also gives meaningful differences, especially for expected-utility calculations.

**Why it matters:** Arbitrary arithmetic on ordinal labels is invalid. Mixed strategies and risk require a suitable cardinal representation.

**Example:** Rankings `3, 2, 1` encode first, second, third preference. They do not automatically show how much better first is than second.

**Common interview angle:** Positive affine transformations `u' = a u + b`, where `a > 0`, preserve expected-utility preferences; arbitrary increasing transformations need not preserve them under uncertainty.

### 3.8 Best responses, dominance, and equilibrium preview

**What it means:** A best response maximizes a player's payoff given others' strategies. A strategy is strictly dominant if it yields a strictly higher payoff against every possible opponent strategy. A Nash equilibrium is a profile in which every player's chosen strategy is a best response.

**Why it matters:** These concepts predict stable behavior from the player/strategy/payoff model.

**Example:** If immediate retry always produces a lower payoff than exponential backoff regardless of other clients, immediate retry is strictly dominated.

**Common interview angle:** A Nash strategy need not be dominant; it only needs to be best against the strategies used at that equilibrium.

## 4. Real-World Example

### Distributed retry storm

Suppose two services call an overloaded dependency. Each chooses `Immediate Retry` or `Backoff`.

| Service A \ Service B | Backoff | Immediate Retry |
|---|---|---|
| **Backoff** | `(4, 4)` recovery is smooth | `(1, 6)` B gets priority |
| **Immediate Retry** | `(6, 1)` A gets priority | `(-4, -4)` retry storm |

Practical interpretation:

- **Players:** independently configured caller services.
- **Strategies:** retry policies, not individual packets.
- **Payoffs:** successful completion value minus latency, error, and capacity costs.
- **Conflict:** each service may gain by retrying aggressively while the other backs off.
- **System risk:** when both optimize locally, the dependency may collapse.
- **Engineering response:** jitter, server-provided `Retry-After`, admission control, rate limiting, or incentive-compatible quotas change the available strategies or payoffs.

This is why game-theoretic modeling is practical: engineering controls do not merely improve performance; they reshape incentives.

## 5. Diagrams / Mental Models

### Basic model

```text
Player A --chooses s_A--\
                         > strategy profile s --> outcome --> (u_A(s), u_B(s))
Player B --chooses s_B--/
```

### Modeling checklist

```text
Story
  |
  +-- Who can make an independent choice? ----------> Players
  +-- What complete plans are actually feasible? ---> Strategy sets
  +-- What does each participant truly value? ------> Payoff functions
  +-- What does each know, and when? ----------------> Information/timing
  +-- Can anyone improve alone? ---------------------> Stability analysis
```

### Key distinctions

| Term | Meaning | Typical mistake |
|---|---|---|
| Player | Independent decision-maker | Calling every object a player |
| Action | Move at one decision point | Treating it as a full plan in a sequential game |
| Strategy | Complete contingent plan | Specifying only the on-path move |
| Strategy profile | One strategy per player | Calling one player's strategy an equilibrium |
| Outcome | Consequence produced by choices | Assuming every profile gives a unique outcome in stochastic games |
| Payoff | Numerical representation of preference | Confusing points with literal money or social welfare |

## 6. Common Interview Questions

### Q1. What are the basic components of a game?

**Answer:** The essential components are players, each player's feasible strategies, and payoff functions assigning each player a value for every relevant strategy profile or outcome. Timing and information must also be specified when they affect decisions.

**Interviewer expects:** Correct definitions and recognition that payoffs depend on the complete profile.

**Common mistake:** Listing only players and moves while ignoring preferences or information.

### Q2. What is the difference between an action and a strategy?

**Answer:** An action is a choice at a particular decision point. A strategy is a complete rule covering every decision point a player could face. They coincide only in simple one-shot games.

**Interviewer expects:** A sequential-game example.

**Common mistake:** Using the words interchangeably in an extensive-form game.

### Q3. What is a strategy profile?

**Answer:** It is a tuple containing one strategy for each player, such as `s = (s_1, s_2, ..., s_n)`. Payoffs are evaluated at a profile.

**Interviewer expects:** Awareness of `s_i` and `s_-i` notation.

**Common mistake:** Describing only one player's choice.

### Q4. What is a pure strategy?

**Answer:** A pure strategy selects a particular complete plan with probability one.

**Interviewer expects:** Contrast with a mixed strategy.

**Common mistake:** Saying “pure” means morally fair or optimal.

### Q5. What is a mixed strategy?

**Answer:** It is a probability distribution over pure strategies. The player commits to probabilities and then randomizes the realized pure strategy.

**Interviewer expects:** Why unpredictability can prevent exploitation.

**Common mistake:** Calling uncertainty about an opponent's fixed choice the player's mixed strategy.

### Q6. Are payoff values always money?

**Answer:** No. They can represent profit, negative latency, reliability, energy, security, satisfaction, or any combined objective, provided the values correctly represent preferences.

**Interviewer expects:** Higher payoff means more preferred and costs may be negated.

**Common mistake:** Assuming interpersonal payoff values are directly comparable.

### Q7. What is a best response?

**Answer:** Given the other players' strategies, a best response is any strategy that maximizes the player's payoff. There may be several tied best responses.

**Interviewer expects:** `BR_i(s_-i) = arg max u_i(s_i, s_-i)`.

**Common mistake:** Calling a strategy globally best without conditioning on opponents.

### Q8. What is a dominant strategy?

**Answer:** A strictly dominant strategy gives a strictly higher payoff than every alternative for every possible strategy profile of the other players. Weak dominance uses “at least as high everywhere and higher somewhere.”

**Interviewer expects:** The quantifier “regardless of what others do.”

**Common mistake:** Confusing a best response at one profile with dominance.

### Q9. Can a player have multiple objectives?

**Answer:** Yes. The payoff function can combine objectives such as throughput, cost, latency, and risk. The modeling challenge is choosing weights or a preference representation that reflects actual trade-offs.

**Interviewer expects:** Recognition of multi-objective modeling and proxy risk.

**Common mistake:** Adding incomparable metrics with arbitrary weights and treating the result as ground truth.

### Q10. Why must a strategy specify off-path choices?

**Answer:** Equilibrium analysis compares possible deviations and asks what would happen after histories that may not occur under the proposed equilibrium. A complete contingent plan makes those comparisons defined.

**Interviewer expects:** Connection to sequential games and credible behavior.

**Common mistake:** Defining a strategy only by the observed path.

### Q11. How do you model a cost-minimization problem as a payoff game?

**Answer:** Set payoff equal to the negative cost, possibly plus benefits: `u_i = benefit_i - cost_i`. Maximizing payoff then minimizes cost when benefits are fixed.

**Interviewer expects:** Consistent preference direction.

**Common mistake:** Forgetting the negative sign and predicting the highest-cost choice.

### Q12. Can two different payoff tables describe the same strategic preferences?

**Answer:** Yes. In deterministic ordinal analysis, any strictly increasing transformation preserves rankings. Under expected utility, positive affine transformations preserve the relevant comparisons.

**Interviewer expects:** Difference between ordinal and cardinal utility.

**Common mistake:** Claiming all numerical transformations preserve mixed-strategy calculations.

## 7. Deep-Dive Questions

### Q1. Why is defining the payoff function often harder than solving the game?

Real participants optimize hidden, changing, or multi-dimensional goals. A metric such as request count may be a poor proxy for customer value, and participants can game proxies. Once an accurate finite payoff matrix exists, mechanical tools can often find best responses or equilibria; choosing the correct objective requires domain knowledge.

### Q2. What happens when a player's type is private information?

The model introduces a **type** containing private characteristics such as cost, value, or risk. A strategy maps types and observed information to actions. Beliefs about other players' types become part of a Bayesian game, and expected payoffs are computed over those beliefs.

### Q3. Are utilities comparable across players?

Not automatically. Payoff `10` for A and `5` for B does not imply A is twice as satisfied. Nash equilibrium needs each player's internal ordering, not cross-player comparison. Social-welfare calculations require an additional assumption about how utilities can be aggregated.

### Q4. Can a player be an algorithm?

Yes, if the algorithm controls choices according to an objective. Bots in auctions, congestion-control algorithms, schedulers, and learning agents are routinely modeled as players. Their effective strategy set may be constrained by code and available observations.

### Q5. How can a system designer change behavior without controlling players?

The designer can change the game: impose prices, quotas, penalties, access rules, randomized audits, rate limits, or information disclosure. Mechanism design works backward from desired behavior to rules under which self-interested strategies produce it.

## 8. Comparison Tables

### Action versus strategy

| Dimension | Action | Strategy |
|---|---|---|
| Scope | One decision point | Every possible decision point |
| Example | Retry now | Retry now; back off after failure; abort after three failures |
| One-shot game | Usually identical to a pure strategy | Usually one available action |
| Sequential game | One component of a strategy | Full contingent plan |
| Used to define equilibrium | Through induced outcomes | Direct object of equilibrium analysis |

### Pure versus mixed strategy

| Dimension | Pure | Mixed |
|---|---|---|
| Choice | One plan with certainty | Probability distribution over plans |
| Purpose | Deterministic behavior | Unpredictability or equilibrium existence |
| Payoff evaluation | Direct payoff | Expected payoff |
| Example | Always inspect route A | Inspect A 60%, B 40% |
| Common trap | Assuming it always exists in equilibrium | Confusing it with a population mixture |

### Strict versus weak dominance

| Dimension | Strict dominance | Weak dominance |
|---|---|---|
| Comparison | Better for every opponent profile | Never worse, better for at least one |
| Elimination safety | Strong and order-independent in standard finite settings | Can remove equilibria; order may matter |
| Indifference allowed | No | Yes |
| Interview phrase | “Always strictly better” | “At least as good everywhere” |

## 9. Common Mistakes

- Treating a player as a person only; organizations and programs can be players.
- Confusing a move with a complete strategy in a sequential game.
- Assigning payoffs based on what is easy to measure rather than what players value.
- Assuming higher combined payoff means an outcome will occur automatically.
- Comparing payoff magnitudes across people without justification.
- Forgetting that a strategy set must contain feasible alternatives.
- Calling a strategy dominant because it is best against one opponent action.
- Assuming randomization means careless or irrational behavior.
- Forgetting that equilibrium belongs to a complete profile.
- Treating “nature” as a rational player with a strategic objective.

## 10. Edge Cases / Special Cases

- **One-player games:** Reduce to optimization or decision theory, though uncertainty may remain.
- **Chance moves:** Nature selects outcomes by fixed probabilities and does not maximize utility.
- **Ties:** Best-response sets can contain multiple strategies.
- **Infinite strategy sets:** Pricing, bidding, and bandwidth choices may be continuous; maxima may fail to exist without continuity or compactness conditions.
- **Uncertain payoffs:** Players may maximize expected utility, worst-case utility, or a risk-sensitive objective.
- **Incomplete information:** Players may not know others' payoffs or types.
- **Changing preferences:** A static payoff function may be inadequate when objectives evolve.
- **Bounded strategy sets caused by code:** A deployed algorithm may be unable to choose theoretically available behavior.
- **Correlated randomization:** Players may condition choices on a shared signal; this differs from independent mixed strategies.
- **Negative and zero payoffs:** These are not inherently losses unless the scale defines them that way; preference ordering is what matters.

## 11. How to Explain in Interview

> A game is defined by its players, the strategies available to each player, and payoff functions over the resulting strategy profiles. A player is an independent decision-maker, a strategy is a complete contingent plan, and a payoff numerically represents how much that player prefers an outcome. The key point is interdependence: my payoff from a strategy can change when another player changes theirs.

## 12. Quick Revision Notes

- **Player:** entity making an independent decision.
- **Action:** one move; **strategy:** complete contingent plan.
- **Strategy profile:** one strategy per player.
- **Payoff:** numerical preference representation; higher usually means better.
- **Best response:** maximizes payoff against specified opponent strategies.
- **Dominant strategy:** best regardless of opponents' choices.
- **Pure strategy:** deterministic plan; **mixed strategy:** distribution over pure plans.
- Payoffs need not be money and generally are not interpersonally comparable.
- Interview trap: action equals strategy only in simple one-decision games.
- Interview trap: a high social payoff does not imply individual stability.

## 13. Practice Tasks

1. Model two database transactions choosing `Wait` or `Abort` during contention. Identify players, strategies, and plausible payoffs.
2. Create a `2 x 2` payoff table for two services choosing aggressive or exponential retry.
3. For each cell, mark each player's best response and locate stable profiles.
4. Extend a one-shot retry action into a complete three-stage strategy.
5. Write a short Python or C++ program representing payoff matrices and printing best responses.
6. Convert latency costs into payoffs and explain why the sign matters.
7. Design a mixed inspection strategy for a defender protecting two endpoints.
8. Identify a misleading proxy payoff in an online platform and propose a better one.
9. Explain whether two teams inside one company should be one player or two for a shared-infrastructure game.
10. Construct an example where an omitted strategy changes the predicted equilibrium.

## 14. Final Cheat Sheet

| Item | Must remember |
|---|---|
| Core definition | Players choose strategies; payoff functions value complete profiles |
| Why it matters | Converts interactive decisions into an analyzable model |
| Most asked | Action vs strategy, pure vs mixed, best response vs dominance |
| Key notation | `S_i`, `s = (s_i, s_-i)`, `u_i(s)` |
| Practical warning | Model the real objective, not a convenient proxy |
| One-line answer | “Players choose complete strategies, and each player's payoff depends on the resulting profile.” |

---

# Rationality

## 1. Overview

### Definition

In game theory, **rationality** usually means that a player chooses an available strategy that best advances the player's preferences, given their information, beliefs, and expectations about other players. It does not mean that the player is kind, selfish, intelligent in every domain, emotionally cold, or guaranteed to predict the future correctly.

### Why it matters

Game-theoretic predictions use optimization assumptions. Best responses, dominance, Nash equilibrium, backward induction, and mechanism design all depend on some form of rational choice. Without a stated rationality assumption, almost any behavior may be possible and the model loses predictive force.

### Where it is used in real systems

- **Protocol design:** assume nodes prefer rewards and avoid penalties.
- **Auctions:** assume bidders select bids to maximize expected utility.
- **Security:** assume attackers allocate effort toward valuable, vulnerable targets.
- **Resource sharing:** assume users choose routes, rates, or servers to reduce their own cost.
- **Product design:** assume users respond to prices, defaults, friction, and incentives.
- **Algorithmic agents:** explicitly program objectives, beliefs, and decision policies.

### Why interviewers ask about it

The topic reveals whether a candidate understands the assumptions behind equilibrium claims. Strong answers distinguish individual rationality, mutual knowledge of rationality, expected utility, bounded rationality, and the difference between rational action and correct belief.

## 2. Core Idea

### Intuition

A rational choice is not “the action with the largest number” by itself. It is the action that produces the best expected outcome based on what the player believes others will do.

```text
Available strategies
        +
preferences/payoffs
        +
information and beliefs
        |
        v
evaluate consequences --> choose a best response
```

### Real-world analogy

A commuter chooses a route. If route A is normally fastest but is believed to be congested today, choosing route B can be rational. If the congestion belief is wrong but based on all available reliable information, the decision can still be rational ex ante even though it looks poor afterward.

### Small example

A service chooses a safe deployment or a risky deployment:

- Safe deployment always gives payoff `4`.
- Risky deployment gives `10` if a dependency is compatible and `-8` otherwise.
- The service believes compatibility has probability `0.75`.

Expected payoff of risky deployment:

```text
E[u(Risky)] = 0.75(10) + 0.25(-8) = 7.5 - 2 = 5.5
E[u(Safe)]  = 4
```

Under risk-neutral expected-utility maximization, choosing risky is rational.

### Step-by-step explanation

1. List feasible strategies: safe and risky.
2. Describe outcomes under relevant states.
3. Assign utilities, not just raw money or throughput.
4. Form beliefs about uncertain states or opponents.
5. Calculate expected utility where appropriate.
6. Choose a maximizing strategy; tied maximizers are all rational choices.
7. If beliefs, information, or risk attitude changes, the rational choice may change.

## 3. Important Subtopics

### 3.1 Preference rationality

**What it means:** Standard models assume preferences are **complete** and **transitive**. Completeness means a player can compare any two relevant outcomes. Transitivity means if A is preferred to B and B to C, then A is preferred to C.

**Why it matters:** Cyclic or incomparable preferences can prevent a well-defined maximizing choice.

**Example:** A service ranks low latency above low cost and low cost above high reliability, but if it ranks high reliability above low latency without context, preferences cycle.

**Common interview angle:** Rationality concerns consistent preference-based choice, not moral behavior.

### 3.2 Expected utility

**What it means:** When outcomes are uncertain, a standard rational player maximizes probability-weighted utility: `E[u] = sum p(o)u(o)`.

**Why it matters:** It supports analysis of mixed strategies, risky choices, and games with chance.

**Example:** An attacker compares a certain small reward with a low-probability large reward minus detection cost.

**Common interview angle:** Expected monetary value and expected utility differ when utility of money is nonlinear.

### 3.3 Risk attitudes

**What it means:** A risk-neutral player has linear utility in wealth; a risk-averse player has concave utility; a risk-seeking player has convex utility over the relevant range.

**Why it matters:** Two players facing the same monetary lottery may rationally choose differently.

**Example:** A startup and a large cloud provider may value the same outage risk differently because the startup cannot absorb the loss.

**Common interview angle:** Reject the claim that choosing the highest expected money is always rational.

### 3.4 Beliefs and best responses

**What it means:** A rational player chooses a best response to a belief about others' choices or types.

**Why it matters:** Correct optimization from incorrect beliefs can yield poor realized results without being internally inconsistent.

**Example:** A bidder bids based on an estimated distribution of rival valuations.

**Common interview angle:** Separate rationality of the decision procedure from accuracy of the belief.

### 3.5 Common knowledge of rationality

**What it means:** Everyone is rational, everyone knows everyone is rational, everyone knows that everyone knows, and so on indefinitely.

**Why it matters:** Many deductions require more than individual rationality. Iterated elimination and backward induction can depend on higher-order beliefs.

**Example:** In a multi-round entry game, a player may choose differently if unsure whether the next player will optimize.

**Common interview angle:** Mutual knowledge is not automatically common knowledge.

### 3.6 Individual rationality

**What it means:** A player participates only if the expected payoff is at least a reservation payoff or outside option.

**Why it matters:** Auctions, contracts, and distributed protocols fail if voluntary participants are worse off by joining.

**Example:** A cloud worker contributes compute only if the reward covers energy and opportunity cost.

**Common interview angle:** Distinguish “the player optimizes” from the mechanism-design participation constraint.

### 3.7 Bounded rationality

**What it means:** Real players have limited time, information, computational power, and attention. They may use heuristics or satisfice—choose an acceptable rather than provably optimal option.

**Why it matters:** Computing an optimal strategy may itself be infeasible. Real protocols must work with realistic agents.

**Example:** A user accepts the default privacy setting rather than analyzing every consequence.

**Common interview angle:** Bounded rationality is not random irrationality; it models optimization under cognitive and computational constraints.

### 3.8 Strategic rationality versus collective welfare

**What it means:** Rational players optimize their own payoffs, not necessarily total payoff.

**Why it matters:** Individually rational choices can create congestion, pollution, retry storms, or the Prisoner's Dilemma.

**Example:** Every client aggressively retries to reduce its own waiting time, bringing down the shared service.

**Common interview angle:** Nash equilibrium can be inefficient even when every player is rational.

## 4. Real-World Example

### Database lock contention

Two long-running transactions detect contention. Each can `Wait` or `Abort and Retry`. Their decision depends on expected remaining work, retry cost, deadlock probability, priority, and beliefs about the other transaction.

```text
Observed lock conflict
        |
        +-- estimate cost of waiting
        +-- estimate cost/probability of abort and retry
        +-- infer whether the other transaction will release or abort
        |
        v
choose action with best expected utility
```

A rational transaction policy may wait when little work remains for the blocker, but abort when deadlock risk is high. A globally designed database may use wait-die or wound-wait rules because independently rational retry behavior can otherwise cause repeated collisions.

This example exposes three levels:

- **Local rationality:** each transaction minimizes its expected completion cost.
- **Beliefs:** decisions depend on estimates of the other transaction's remaining time.
- **Mechanism design:** the database changes rules to avoid globally harmful cycles.

## 5. Diagrams / Mental Models

### Rational does not mean successful

```text
Good information + coherent preferences + correct optimization
                             |
                             v
                       rational choice
                             |
                 randomness / wrong belief
                             |
                             v
                       poor final outcome
```

### Levels of assumption

| Level | Claim | What it permits |
|---|---|---|
| Preference consistency | Choices follow complete, transitive preferences | Utility representation |
| Individual rationality | Each player optimizes given beliefs | Best-response reasoning |
| Mutual rationality | Each knows others are rational | Some strategic anticipation |
| Common knowledge | Rationality is known at all belief levels | Strong iterative deductions |
| Bounded rationality | Optimization has resource limits | Heuristics, learning, satisficing |

## 6. Common Interview Questions

### Q1. What does rationality mean in game theory?

**Answer:** A rational player chooses a strategy that maximizes their utility given feasible choices, available information, and beliefs about uncertainty and other players.

**Interviewer expects:** Utility, constraints, information, and beliefs.

**Common mistake:** Equating rationality with selfishness, intelligence, or always winning.

### Q2. Can a rational player make a decision that turns out badly?

**Answer:** Yes. A decision can maximize expected utility using reasonable beliefs and still produce a bad outcome because of randomness or incomplete information.

**Interviewer expects:** Ex ante versus ex post distinction.

**Common mistake:** Judging decision quality solely by realized outcome.

### Q3. What is expected utility?

**Answer:** It is the probability-weighted average of utilities over possible outcomes. A standard model predicts selection of the strategy with maximum expected utility.

**Interviewer expects:** Formula and the distinction from expected money.

**Common mistake:** Averaging raw outcomes when utility is nonlinear.

### Q4. What is the difference between risk-neutral and risk-averse behavior?

**Answer:** A risk-neutral player evaluates lotteries by expected monetary value if utility is linear. A risk-averse player has diminishing marginal utility and may prefer a certain outcome to a lottery with the same expected money.

**Interviewer expects:** Linear versus concave utility.

**Common mistake:** Calling every cautious choice irrational.

### Q5. What is bounded rationality?

**Answer:** It models decision-makers with limited computation, time, information, or attention who use feasible heuristics or seek satisfactory choices.

**Interviewer expects:** Realistic limits and a practical example.

**Common mistake:** Defining it simply as irrationality.

### Q6. What is common knowledge of rationality?

**Answer:** Every player is rational, knows that all players are rational, knows that all know it, and this nesting continues indefinitely.

**Interviewer expects:** Higher-order knowledge.

**Common mistake:** Saying it merely means everyone is rational.

### Q7. What is individual rationality in mechanism design?

**Answer:** A participation constraint: each participant's expected utility from joining must be at least their outside-option utility.

**Interviewer expects:** Reservation payoff and voluntary participation.

**Common mistake:** Confusing it with ordinary payoff maximization after entry.

### Q8. Is cooperation inconsistent with rationality?

**Answer:** No. Cooperation can maximize individual utility when interaction is repeated, reputation matters, contracts are enforceable, or incentives reward cooperation.

**Interviewer expects:** Payoffs determine rational behavior; selfishness does not imply defection in every model.

**Common mistake:** Assuming rational always means defect.

### Q9. Can two rational players choose different strategies in the same situation?

**Answer:** Yes, if they have different preferences, risk attitudes, private information, or beliefs. They may also be indifferent among several best responses.

**Interviewer expects:** Conditions underlying choice.

**Common mistake:** Treating rationality as a single universal algorithm.

### Q10. Does Nash equilibrium require common knowledge of rationality?

**Answer:** Nash equilibrium is mathematically a mutual-best-response profile. Interpreting it as a prediction often uses strong assumptions about rationality, beliefs, or learning, but the precise epistemic conditions depend on the solution concept and setting.

**Interviewer expects:** Separate definition from behavioral justification.

**Common mistake:** Claiming individual rationality alone always leads players to a Nash equilibrium.

### Q11. Why can rational behavior produce inefficient outcomes?

**Answer:** Each player accounts for private payoff but may impose external costs on others. The resulting equilibrium can have lower total welfare than a coordinated outcome.

**Interviewer expects:** Externalities and Prisoner's Dilemma/congestion example.

**Common mistake:** Assuming rationality implies social optimality.

### Q12. How do beliefs enter rational decision-making?

**Answer:** When opponents' actions or types are uncertain, players evaluate expected utility using beliefs—a probability distribution over those unknowns—and choose a best response to that distribution.

**Interviewer expects:** Bayesian reasoning.

**Common mistake:** Ignoring that a best response needs something to respond to.

## 7. Deep-Dive Questions

### Q1. Can rationality be defined when preferences are incomplete?

Standard utility maximization becomes harder because some alternatives cannot be ranked. Models may use partial orders, choice correspondences, robust dominance, or set-valued preferences. The interview point is that completeness is an assumption, not a law of human behavior.

### Q2. Why does transitivity matter?

If a player strictly prefers A to B, B to C, and C to A, no alternative is consistently maximal. A sequence of trades can exploit the cycle, sometimes called a money-pump argument. Transitivity permits coherent utility representation under standard conditions.

### Q3. How does computational complexity challenge rationality?

If finding a best response or equilibrium requires infeasible computation, an unbounded-rationality prediction is operationally weak. Algorithmic game theory therefore studies approximation, regret minimization, learning dynamics, and computationally bounded agents.

### Q4. What is the difference between maximizing expected utility and minimizing regret?

Expected utility requires probabilities over outcomes. Regret compares the chosen strategy's payoff with the best strategy in hindsight. Online systems often minimize cumulative regret when reliable probability models are unavailable.

### Q5. How can repeated interaction make cooperation rational?

Defection may give a one-period gain but trigger future punishment or loss of reputation. If future payoff is valued sufficiently highly, the discounted loss from damaged cooperation exceeds the immediate gain, so cooperative strategies can be sequentially rational.

## 8. Comparison Tables

### Perfect rationality versus bounded rationality

| Dimension | Perfect rationality | Bounded rationality |
|---|---|---|
| Computation | Unlimited in the model | Limited |
| Information processing | Complete and costless | Costly or incomplete |
| Choice | Exact maximizer | Heuristic, approximate, or satisfactory |
| Predictive use | Clean benchmark | More realistic behavior |
| System example | Exact optimal bid | Rule-of-thumb autoscaling |

### Rationality versus correctness

| Dimension | Rational decision | Correct prediction/outcome |
|---|---|---|
| Evaluated using | Information available at decision time | What actually happens |
| Can fail due to randomness? | Still rational | Outcome may be poor |
| Can use a wrong belief? | Yes, if belief formation is outside the assumption | Prediction is then wrong |
| Interview keyword | Ex ante | Ex post |

### Individual versus common knowledge of rationality

| Dimension | Individual rationality | Common knowledge of rationality |
|---|---|---|
| Assumption | I optimize | Everyone optimizes and all higher-order levels know it |
| Reasoning depth | Own best response | Iterated reasoning about others |
| Supports | Basic optimization | Backward induction and iterated deductions in suitable games |
| Strength | Weaker | Much stronger |

## 9. Common Mistakes

- Saying a rational player must be selfish; preferences can include fairness or others' welfare.
- Saying rational players always obtain good outcomes.
- Ignoring information and beliefs when labeling a decision rational.
- Treating expected monetary value as expected utility.
- Assuming all players have the same risk attitude.
- Equating mutual knowledge with common knowledge.
- Assuming Nash equilibrium follows from individual rationality alone.
- Treating bounded rationality as arbitrary behavior.
- Ignoring the computational cost of finding an optimal strategy.
- Assuming individually rational behavior maximizes social welfare.

## 10. Edge Cases / Special Cases

- **Indifference:** Several strategies can be equally rational best responses.
- **Nonexistent maximum:** With open or unbounded strategy sets, a supremum may exist without an attainable maximizer.
- **Ambiguity:** A player may not know probabilities and may use maximin or ambiguity-averse rules.
- **Time inconsistency:** Present and future selves may behave like different players when discounting is inconsistent.
- **Behavioral biases:** Framing, loss aversion, and limited attention can violate standard expected-utility predictions.
- **Social preferences:** Altruism, spite, and fairness can be included in utility; they are not automatically irrational.
- **Learning:** A player can begin with poor beliefs and update rationally from observations.
- **Adversarial uncertainty:** Worst-case optimization may be rational when probabilities are unreliable and losses are catastrophic.
- **Equilibrium selection:** Rationality may narrow behavior to several equilibria without selecting one.
- **Algorithmic commitment:** A player may rationally commit to a rule that restricts future choices because the commitment changes others' behavior.

## 11. How to Explain in Interview

> Rationality in game theory means choosing a utility-maximizing strategy given one's feasible actions, information, beliefs, and attitude toward risk. It does not guarantee a good outcome or imply selfishness. In strategic settings, my rational choice is usually a best response to what I believe other players will do, and stronger results may require common knowledge that everyone reasons this way.

## 12. Quick Revision Notes

- Rationality = consistent preference-based optimization under information and beliefs.
- Complete and transitive preferences support utility representation.
- Under uncertainty, standard theory uses expected utility.
- Rational ex ante can look bad ex post.
- Risk attitude comes from utility curvature.
- Bounded rationality models limited computation and attention.
- Common knowledge is stronger than everyone merely being rational.
- Individual rationality in mechanism design means participation beats the outside option.
- Rational self-interest can produce socially inefficient equilibria.
- Interview trap: rationality does not imply accurate beliefs or omniscience.

## 13. Practice Tasks

1. Calculate expected utilities for safe and risky deployments under three different success probabilities.
2. Draw linear, concave, and convex utility curves and explain their risk implications.
3. Give an example of a rational decision with a bad realized outcome.
4. Model a database transaction's wait-versus-abort decision using expected costs.
5. Explain why a greedy retry policy can be individually rational but globally harmful.
6. Construct cyclic preferences and show why they violate transitivity.
7. Compare a best response under correct and incorrect beliefs.
8. Design an outside-option constraint for workers joining a distributed compute pool.
9. Describe a heuristic that a boundedly rational bidder might use.
10. Explain how a future penalty can make present cooperation rational.

## 14. Final Cheat Sheet

| Item | Must remember |
|---|---|
| Core definition | Maximize utility given constraints, information, and beliefs |
| Why it matters | Powers best-response and equilibrium reasoning |
| Most asked | Rational vs successful, expected utility, bounded rationality, common knowledge |
| Key formula | `E[u] = sum_o p(o)u(o)` |
| Practical warning | Wrong beliefs or proxy utilities can make predictions fail |
| One-line answer | “A rational player selects a best response to their beliefs, not necessarily the action that looks best afterward.” |

---

# Normal-Form Games

## 1. Overview

### Definition

A **normal-form game**, also called a **strategic-form game**, represents a strategic interaction by listing:

- a set of players,
- a strategy set for each player, and
- a payoff function for each player over all strategy profiles.

For two players with finitely many strategies, it is commonly displayed as a payoff matrix. Rows belong to one player, columns to the other, and each cell contains the payoffs generated by that pair of strategies.

Formally:

```text
G = (N, (S_i) for i in N, (u_i) for i in N)
```

where `N` is the player set, `S_i` is player `i`'s strategy set, and `u_i` maps every strategy profile to player `i`'s payoff.

### Why it matters

Normal form gives a compact view of strategic dependence. It is ideal for identifying best responses, dominant and dominated strategies, pure and mixed Nash equilibria, coordination failures, and incentive conflicts.

### Where it is used in real systems

- Competing services selecting shared servers or routes.
- Clients choosing conservative or aggressive retry policies.
- Security teams allocating defense while attackers choose targets.
- Cloud providers and users selecting prices and demand levels.
- Database transactions choosing wait, abort, or retry policies.
- Firms choosing compatible or incompatible technical standards.

### Why interviewers ask about it

Normal-form questions test matrix reading, systematic best-response analysis, dominance, equilibrium, and the distinction between stability and efficiency. They also test whether a candidate can construct a model from a system scenario rather than merely solve a supplied matrix.

## 2. Core Idea

### Intuition

A payoff matrix is a lookup table for consequences. It does not show time or visible moves directly. Each player chooses a complete strategy, and the selected row and column locate the outcome.

### Real-world analogy

Two teams independently choose one of two API standards, `X` or `Y`. Matching standards creates compatibility. Each team prefers its own standard if coordination occurs.

| Team A \ Team B | X | Y |
|---|---:|---:|
| **X** | `(4, 3)` | `(0, 0)` |
| **Y** | `(0, 0)` | `(3, 4)` |

The first number in every cell is A's payoff; the second is B's.

### Small example and step-by-step solution

1. **If B chooses X:** A gets `4` from X and `0` from Y, so A's best response is X.
2. **If B chooses Y:** A gets `0` from X and `3` from Y, so A's best response is Y.
3. **If A chooses X:** B gets `3` from X and `0` from Y, so B's best response is X.
4. **If A chooses Y:** B gets `0` from X and `4` from Y, so B's best response is Y.
5. Cells where both choices are best responses are `(X, X)` and `(Y, Y)`.
6. Therefore, both are pure Nash equilibria.
7. The game does not itself say which equilibrium will be selected. Communication, defaults, conventions, history, or leadership may coordinate selection.

## 3. Important Subtopics

### 3.1 Payoff matrices

**What it means:** A finite two-player normal-form game can be laid out as rows and columns. Every cell contains an ordered pair `(row payoff, column payoff)`.

**Why it matters:** Reversing payoff order leads to incorrect best responses and equilibria.

**Example:** In `(5, 2)`, the row player gets `5` and the column player gets `2` unless stated otherwise.

**Common interview angle:** Always declare whose payoff appears first before analyzing.

### 3.2 Best-response marking

**What it means:** For each fixed opponent strategy, mark the player's maximum payoff. A cell marked for all players is a mutual best response.

**Why it matters:** It is the safest manual method for finding pure Nash equilibria.

**Example:** Compare row payoffs vertically within a column, and column payoffs horizontally within a row.

**Common interview angle:** Candidates often compare numbers within a cell or across the wrong direction.

### 3.3 Dominant and dominated strategies

**What it means:** A dominant strategy beats alternatives against every opponent choice. A dominated strategy is worse than another strategy against every opponent choice, strictly or weakly depending on the definition.

**Why it matters:** Strictly dominated strategies are never rational best responses and can be eliminated.

**Example:** If `Backoff` produces higher utility than `Immediate Retry` for every load condition, immediate retry is strictly dominated.

**Common interview angle:** Dominance compares complete payoff vectors, not a strategy's largest single payoff.

### 3.4 Iterated elimination of strictly dominated strategies

**What it means:** Remove a strictly dominated strategy, form the reduced game, and repeat.

**Why it matters:** A complex matrix may collapse to one profile without calculating every equilibrium.

**Example:** Removing an obviously bad server choice for one client may make another route dominated for a second client.

**Common interview angle:** Strict-dominance elimination is robust; weak-dominance elimination can depend on order and can discard Nash equilibria.

### 3.5 Pure-strategy Nash equilibrium

**What it means:** A profile `s*` is a Nash equilibrium if no player gains by changing strategy alone:

```text
u_i(s_i*, s_-i*) >= u_i(s_i, s_-i*) for every player i and every s_i
```

**Why it matters:** It formalizes unilateral stability.

**Example:** Both services use the same compatible protocol, and neither wants to switch alone.

**Common interview angle:** Nash equilibrium is not necessarily unique, dominant, fair, Pareto-optimal, or socially best.

### 3.6 Mixed-strategy Nash equilibrium

**What it means:** Each player randomizes over pure strategies so that every pure strategy used with positive probability gives the same expected payoff; unused strategies give no higher payoff.

**Why it matters:** Every finite normal-form game has at least one Nash equilibrium in mixed strategies, even if no pure equilibrium exists.

**Example:** In matching pennies, each player chooses Heads and Tails with probability `1/2`.

**Common interview angle:** Solve by making the opponent indifferent, because your mixing probabilities determine the opponent's expected payoffs.

### 3.7 Support of a mixed strategy

**What it means:** The support is the set of pure strategies assigned positive probability.

**Why it matters:** At equilibrium, all strategies in a player's support must tie for maximum expected payoff.

**Example:** `(0.7, 0.3, 0)` has support consisting of the first two strategies.

**Common interview angle:** A zero-probability strategy need not be indifferent; it only must not be more profitable.

### 3.8 Pareto efficiency and social welfare

**What it means:** An outcome is Pareto-efficient if no other outcome makes someone better off without making anyone worse off. Utilitarian social welfare is often modeled as the sum of payoffs, when such addition is justified.

**Why it matters:** Stability and efficiency answer different questions.

**Example:** Mutual defection in the Prisoner's Dilemma is Nash-stable but Pareto-dominated by mutual cooperation.

**Common interview angle:** Do not label an equilibrium “optimal” without specifying whose objective is optimized.

### 3.9 Symmetric games

**What it means:** Players have the same strategy sets, and payoffs depend on strategies rather than player identity.

**Why it matters:** Symmetry can simplify analysis, but symmetric games can have asymmetric equilibria.

**Example:** Two identical clients select one of two servers; one on each server may be an asymmetric equilibrium.

**Common interview angle:** A symmetric game does not require every equilibrium to use identical strategies.

### 3.10 Correlated strategies

**What it means:** A trusted signal recommends actions drawn from a joint distribution. Following recommendations is optimal conditional on one's received signal in a correlated equilibrium.

**Why it matters:** Correlation can coordinate players more efficiently than independent mixed strategies.

**Example:** A scheduler recommends which of two services should send first, avoiding collisions.

**Common interview angle:** A mixed Nash strategy uses independent private randomization; correlated equilibrium may coordinate choices through a common signal.

## 4. Real-World Example

### Load balancing across two servers

Two large clients independently route a heavy job to server `S1` or `S2`. `S1` is faster, but placing both jobs on it causes severe contention.

| Client A \ Client B | S1 | S2 |
|---|---:|---:|
| **S1** | `(1, 1)` | `(5, 3)` |
| **S2** | `(3, 5)` | `(2, 2)` |

Best-response analysis:

- If B uses S1, A prefers S2 (`3 > 1`).
- If B uses S2, A prefers S1 (`5 > 2`).
- Symmetrically, B prefers the server not used by A.
- The pure Nash equilibria are `(S1, S2)` and `(S2, S1)`.
- Both equilibria balance load, but clients disagree over who receives faster S1.

Practical system consequences:

- If clients choose independently and simultaneously, they may oscillate or collide.
- Deterministic hashing can act as a coordination rule.
- A centralized load balancer changes the interaction from a non-cooperative game to an allocation problem.
- Prices or congestion signals can change payoffs so decentralized choices balance naturally.
- Random independent routing may still collide; correlated scheduling can avoid the collision.

## 5. Diagrams / Mental Models

### How to read a matrix

```text
                         Column player's strategy
                              C1        C2
Row player's strategy   R1   (a,b)     (c,d)
                        R2   (e,f)     (g,h)

First value  = row player's payoff
Second value = column player's payoff
```

### Pure Nash workflow

```text
For each column -> mark largest row-player payoff
For each row    -> mark largest column-player payoff
                         |
                         v
Cells marked for both players = pure Nash equilibria
```

### Stability versus efficiency

| Question | Concept |
|---|---|
| Can one player profit by changing alone? | Nash equilibrium |
| Is a strategy best regardless of others? | Dominance |
| Can someone improve without hurting anyone? | Pareto efficiency |
| Is total payoff maximized? | Social-welfare optimum |

## 6. Common Interview Questions

### Q1. What is a normal-form game?

**Answer:** It specifies players, each player's strategy set, and payoff functions over complete strategy profiles. A finite two-player game is usually shown as a payoff matrix.

**Interviewer expects:** Formal components and matrix interpretation.

**Common mistake:** Saying normal form means simultaneous play only; sequential games can also be converted to normal form using complete strategies.

### Q2. How do you find pure Nash equilibria in a payoff matrix?

**Answer:** For each opponent choice, mark each player's best response. A cell where every player's chosen strategy is a best response is a pure Nash equilibrium.

**Interviewer expects:** Correct row/column comparison directions.

**Common mistake:** Selecting the cell with the largest total payoff.

### Q3. What is the difference between a dominant-strategy equilibrium and a Nash equilibrium?

**Answer:** In a dominant-strategy equilibrium, each player's strategy is best against every opponent strategy. In a Nash equilibrium, it only needs to be best against the strategies actually chosen at that profile. Every dominant-strategy equilibrium is Nash; the converse is false.

**Interviewer expects:** Strength of quantifiers.

**Common mistake:** Treating the terms as synonyms.

### Q4. Can a game have no pure Nash equilibrium?

**Answer:** Yes. Matching pennies and rock-paper-scissors have no mutual pure best response. Every finite game still has at least one mixed-strategy Nash equilibrium.

**Interviewer expects:** A standard counterexample and Nash's existence result.

**Common mistake:** Saying no pure equilibrium means no equilibrium at all.

### Q5. How do you calculate a mixed equilibrium in a `2 x 2` game?

**Answer:** Let each player assign a probability to one pure strategy. Choose a player's probability so the opponent is indifferent between pure strategies in their support; solve both indifference equations and verify probabilities lie in `[0,1]` and unused strategies are not better.

**Interviewer expects:** “Make the opponent indifferent.”

**Common mistake:** Using a player's own payoff equation to solve their own mixing probability.

### Q6. Why are strategies in the support indifferent at mixed equilibrium?

**Answer:** If one support strategy gave lower expected payoff, the player would shift its positive probability to a better strategy, contradicting equilibrium.

**Interviewer expects:** Best-response logic.

**Common mistake:** Requiring every pure strategy, including unused ones, to tie.

### Q7. What is iterated elimination of dominated strategies?

**Answer:** Repeatedly remove strategies that are dominated in the current game. Strictly dominated strategies can never be best responses, so their removal simplifies rational analysis.

**Interviewer expects:** Strict versus weak qualification.

**Common mistake:** Eliminating a strategy merely because it performs badly in one cell.

### Q8. Is every Nash equilibrium Pareto-efficient?

**Answer:** No. The Prisoner's Dilemma has a Nash equilibrium at mutual defection that both players rank below mutual cooperation.

**Interviewer expects:** Stability is not efficiency.

**Common mistake:** Calling Nash equilibrium the globally optimal outcome.

### Q9. Can a normal-form game represent sequential decisions?

**Answer:** Yes. Each pure strategy must specify a complete action plan at every possible decision node. However, normal form hides timing, information sets, and credibility, so extensive form is often more informative.

**Interviewer expects:** Complete contingent strategies.

**Common mistake:** Listing only actions on the expected path.

### Q10. What is a symmetric game?

**Answer:** Players have equivalent strategic roles: swapping player identities and their strategies swaps their payoffs consistently.

**Interviewer expects:** Symmetry of rules/payoffs, not necessarily outcomes.

**Common mistake:** Claiming all equilibria must be symmetric.

### Q11. What is a correlated equilibrium?

**Answer:** A joint random signal recommends actions, and no player benefits from ignoring their recommendation after observing it, assuming others follow theirs.

**Interviewer expects:** Conditional incentive compatibility and contrast with independent randomization.

**Common mistake:** Calling any shared random seed a correlated equilibrium without checking obedience incentives.

### Q12. What information is lost in normal form?

**Answer:** It does not explicitly display order of moves, observations, information sets, or which threats are credible. These may be encoded indirectly in the enlarged strategy sets, but the tree structure is hidden.

**Interviewer expects:** Motivation for extensive form.

**Common mistake:** Saying normal form cannot represent sequential games at all.

## 7. Deep-Dive Questions

### Q1. Derive the mixed equilibrium of matching pennies.

Let row play Heads with probability `p` and column play Heads with probability `q`. With payoff `+1` for matching and `-1` otherwise, row is indifferent when `q(1)+(1-q)(-1) = q(-1)+(1-q)(1)`, giving `q = 1/2`. Column is indifferent when `p = 1/2`. Therefore both randomize uniformly and the expected value is zero.

### Q2. Why can iterated elimination of weakly dominated strategies be order-dependent?

Weak dominance allows ties. Removing one tied alternative can change whether another strategy meets the “better somewhere” condition, and weakly dominated strategies can participate in Nash equilibria. Consequently, different valid elimination orders may leave different reduced games.

### Q3. How large can the normal form of a sequential game become?

A pure strategy selects an action at every information set. If player `i` has action counts `a_1, a_2, ..., a_k` across their information sets, the number of pure strategies is their product. This can be exponential in the size of the game tree, making explicit normal form computationally unattractive.

### Q4. What is rationalizability?

A strategy is rationalizable if it is a best response to some belief about opponents' rationalizable strategies. In finite games, iterated elimination of strictly dominated strategies by mixed strategies characterizes rationalizable strategies under standard assumptions. It is generally weaker than Nash equilibrium because beliefs need not be mutually correct.

### Q5. Why does every finite game have a mixed Nash equilibrium?

Allowing mixed strategies makes each strategy space a compact convex simplex, and expected payoff is continuous and linear in a player's own mixture. A fixed-point argument, commonly Kakutani's theorem, establishes a profile in which every mixture is a best response. An interview answer normally states the result and intuition; a full proof is rarely expected.

## 8. Comparison Tables

### Normal form versus payoff matrix

| Dimension | Normal form | Payoff matrix |
|---|---|---|
| Meaning | General strategic representation | Tabular display for finite, usually two-player games |
| Players | Any finite number | Visually convenient for two |
| Strategy sets | Finite or infinite | Explicitly finite |
| Payoffs | Functions | Ordered values in cells |
| Relationship | Mathematical object | One way to display it |

### Dominant strategy versus best response versus Nash strategy

| Concept | Depends on opponent choice? | Scope |
|---|---|---|
| Dominant strategy | No; best against all choices | Property of one player's strategy |
| Best response | Yes; best against specified choice/belief | Conditional property |
| Nash equilibrium strategy | Best against equilibrium opponents | Component of a stable profile |

### Pure versus mixed Nash equilibrium

| Dimension | Pure equilibrium | Mixed equilibrium |
|---|---|---|
| Behavior | Deterministic strategy | Random distribution |
| Existence in finite games | Not guaranteed | Guaranteed |
| Manual method | Mutual best-response cells | Indifference equations/support check |
| Predictability | Exact action profile | Probabilities, not realization |

## 9. Common Mistakes

- Reversing the order of payoffs in a cell.
- Comparing the row player's payoffs across a row instead of down a fixed column.
- Selecting the maximum payoff-sum cell as Nash equilibrium.
- Assuming a Nash equilibrium must use dominant strategies.
- Ignoring tied best responses and missing equilibria.
- Eliminating a strategy because it loses in one scenario rather than every scenario.
- Treating weak-dominance elimination like strict-dominance elimination.
- Solving one's own mixing probability from one's own indifference equation.
- Requiring unused pure strategies to be indifferent in a mixed equilibrium.
- Claiming normal form proves which equilibrium players will coordinate on.

## 10. Edge Cases / Special Cases

- **Multiple equilibria:** The model may need an equilibrium-selection story.
- **No pure equilibrium:** Search for mixed strategies rather than stopping.
- **Continuum of equilibria:** Indifference can produce infinitely many equilibrium profiles.
- **Degenerate games:** More pure best responses than normally expected can complicate support enumeration.
- **Weak dominance:** A weakly dominated strategy may still appear in Nash equilibrium.
- **Continuous actions:** A matrix cannot enumerate all prices or resource levels; use payoff functions and calculus/optimization.
- **Non-unique best responses:** Best-response correspondences, not functions, are needed.
- **Asymmetric equilibrium in symmetric games:** Identical roles can yield different equilibrium actions.
- **Correlated equilibrium:** Joint randomization can expand attainable stable distributions.
- **Ordinal transformation:** Pure best responses survive increasing transformations, while mixed expected-payoff calculations need stronger cardinal preservation.

## 11. How to Explain in Interview

> A normal-form game lists players, their complete strategy sets, and payoffs for every strategy profile. For a two-player finite game, I represent it as a matrix and find pure Nash equilibria by marking each player's best response to every opponent choice; mutual best-response cells are equilibria. If none exist, I check mixed strategies by choosing probabilities that make the opponent indifferent.

## 12. Quick Revision Notes

- Normal form: `G = (N, S_i, u_i)`.
- Rows and columns are strategies; cells are ordered payoff pairs.
- Pure Nash = mutual best response; no profitable unilateral deviation.
- Dominance is stronger than being a Nash best response.
- Strictly dominated strategies can be eliminated safely in standard finite analysis.
- Mixed equilibrium: support strategies tie in expected payoff.
- Every finite game has a mixed Nash equilibrium.
- Nash stability does not imply Pareto efficiency or fairness.
- A sequential game can be represented in normal form, but timing is hidden.
- Interview trap: mark best responses before judging cells by intuition.

## 13. Practice Tasks

1. Mark best responses in the coordination matrix from Section 2.
2. Solve the load-balancing matrix and explain both pure equilibria.
3. Build and solve a Prisoner's Dilemma payoff matrix.
4. Build a matching-pennies matrix and derive its mixed equilibrium.
5. Write a C++ program that accepts two payoff matrices and outputs all pure Nash equilibria.
6. Add support for tied best responses to that program.
7. Construct a game with a weakly dominated strategy that appears in a Nash equilibrium.
8. Convert a two-stage entry game into normal form by enumerating complete strategies.
9. Compare independent random routing with a correlated scheduler.
10. Find an equilibrium that is Pareto-dominated and propose a rule that changes the incentives.

## 14. Final Cheat Sheet

| Item | Must remember |
|---|---|
| Core definition | Players, strategy sets, payoffs over profiles |
| Why it matters | Compactly exposes incentives and unilateral stability |
| Most asked | Find Nash equilibria, dominance, pure vs mixed |
| Solving rule | Mark best responses; mutual marks are pure Nash |
| Mixed rule | Your probability makes the opponent indifferent |
| One-line answer | “Normal form is the strategy-payoff table; Nash cells are mutual best responses.” |

---

# Extensive-Form Games

## 1. Overview

### Definition

An **extensive-form game** represents a game as a tree that explicitly describes the order of moves, choices available after each history, what each player knows when acting, chance events, and payoffs at terminal outcomes.

Its main components are:

- players,
- decision nodes and histories,
- the player acting at each decision node,
- available actions,
- information sets,
- chance probabilities where applicable, and
- terminal-node payoffs.

### Why it matters

Timing and information change incentives. A threat made before an opponent's action may be incredible once the threatened decision node is reached. A player who observes an earlier move may respond differently from one who moves without observing it. Extensive form exposes these distinctions.

### Where it is used in real systems

- Authentication and security challenge-response protocols.
- Transaction commit, abort, timeout, and recovery sequences.
- Network handshakes and congestion responses.
- Market entry followed by an incumbent response.
- Negotiation, escalation, and rollback workflows.
- Distributed protocols containing messages, timeouts, failures, and retries.

### Why interviewers ask about it

Interviewers test whether candidates understand game trees, backward induction, perfect versus imperfect information, complete contingent strategies, subgames, and credible threats. The representation also connects naturally to protocol and state-machine reasoning used by software engineers.

## 2. Core Idea

### Intuition

Normal form answers “what complete strategy did everyone choose?” Extensive form answers “what happened first, what was observed, what could happen next, and how does each continuation end?”

### Real-world analogy

A new service decides whether to enter a market. If it stays out, the game ends. If it enters, the incumbent observes entry and chooses to fight or accommodate.

```text
Entrant
├── Stay Out ------------------------------> (0, 5)
└── Enter
    └── Incumbent
        ├── Fight --------------------------> (-2, -1)
        └── Accommodate --------------------> (3, 2)
```

Payoffs are `(Entrant, Incumbent)`.

### Step-by-step explanation

1. At the final decision node, the incumbent compares `Fight: -1` with `Accommodate: 2`.
2. A rational incumbent accommodates.
3. The entrant anticipates accommodation.
4. At the initial node, the entrant compares `Stay Out: 0` with `Enter: 3`.
5. The entrant enters.
6. The backward-induction outcome is `(Enter, Accommodate)`.
7. A pre-entry threat to fight is not credible because fighting is irrational once entry has occurred.

## 3. Important Subtopics

### 3.1 Nodes, branches, and histories

**What it means:** A node represents a history of prior actions. An outgoing branch is an available action. The root is the empty history; a terminal node has no further actions and carries payoffs.

**Why it matters:** Every decision is interpreted in context, not as an isolated action.

**Example:** `Connect -> Challenge -> Authenticate` is a history in a protocol tree.

**Common interview angle:** A node is a state/history; an edge is an action.

### 3.2 Perfect information

**What it means:** Every player knows the complete prior action history whenever they move. Every information set contains a single decision node.

**Why it matters:** Finite perfect-information games can usually be solved by backward induction.

**Example:** Chess has perfect information because all moves and board state are visible, although it has enormous complexity.

**Common interview angle:** Perfect information does not mean complete information about preferences or absence of chance.

### 3.3 Imperfect information and information sets

**What it means:** Nodes that a player cannot distinguish are grouped in an information set. The player must choose the same action at every node in that set.

**Why it matters:** It models simultaneous moves, hidden actions, and private observations.

**Example:** A defender chooses without knowing which route an attacker secretly selected.

**Common interview angle:** Information-set nodes must belong to the same player and normally offer the same action labels.

### 3.4 Perfect recall

**What it means:** A player never forgets their own previous actions or information. They may lack information about others, but do not lose their personal history.

**Why it matters:** Perfect recall gives clean equivalence between mixed and behavioral strategies in finite games.

**Example:** A security agent remembers which endpoint it inspected earlier, even if it never observed the attacker's route.

**Common interview angle:** Imperfect information and imperfect recall are different.

### 3.5 Strategies in extensive form

**What it means:** A pure strategy assigns an action at every information set belonging to the player, including information sets not reached during actual play.

**Why it matters:** Full strategies allow counterfactual deviation analysis and conversion to normal form.

**Example:** The incumbent's strategy must say whether it fights after entry, even if the entrant stays out.

**Common interview angle:** The realized path is an outcome, not a complete strategy profile.

### 3.6 Backward induction

**What it means:** Solve the last decision nodes first, replace them with their rational continuation payoffs, and work backward to the root.

**Why it matters:** It produces sequentially rational behavior in finite perfect-information games.

**Example:** An incumbent's future response determines whether an entrant chooses entry now.

**Common interview angle:** Do not choose the initial move before evaluating later responses.

### 3.7 Subgames

**What it means:** A subgame starts at a singleton information set and contains all successor nodes without cutting any information set.

**Why it matters:** Subgames isolate proper continuation games and support subgame-perfect equilibrium.

**Example:** The incumbent's decision following observed entry begins a proper subgame.

**Common interview angle:** A node inside a multi-node information set cannot start a subgame.

### 3.8 Subgame-perfect Nash equilibrium

**What it means:** A strategy profile is subgame-perfect if it induces a Nash equilibrium in every subgame, including off-path subgames.

**Why it matters:** It rules out non-credible threats supported only because the threatened node is never expected to occur.

**Example:** `Stay Out; Fight if entry occurs` may be Nash in the strategic form under some payoffs but is not subgame-perfect if accommodation is better after entry.

**Common interview angle:** Every subgame-perfect equilibrium is Nash; not every Nash equilibrium is subgame-perfect.

### 3.9 Chance nodes

**What it means:** Nature selects a branch using specified probabilities. Nature is not an optimizing strategic player.

**Why it matters:** Chance models failures, random demand, card deals, or uncertain compatibility.

**Example:** After deployment, a dependency is compatible with probability `0.9`.

**Common interview angle:** Expected payoffs must be propagated backward through chance nodes.

### 3.10 Mixed and behavioral strategies

**What it means:** A mixed strategy randomizes once over complete pure plans. A behavioral strategy independently randomizes at each information set.

**Why it matters:** With perfect recall, they are outcome-equivalent in the relevant sense (Kuhn's theorem). Without perfect recall, they can differ.

**Example:** Choose a full inspection schedule at the beginning versus randomize separately at each checkpoint.

**Common interview angle:** Avoid treating the two randomization methods as definitionally identical.

## 4. Real-World Example

### Authentication challenge-response

A client requests access. A server can approve immediately or issue a challenge. After a challenge, the client can provide valid proof or abandon. A malicious type may attempt fake proof, and verification may probabilistically detect it.

```text
Client requests access
        |
        v
Server
├── Approve ----------------------------> fast access / higher attack risk
└── Challenge
    └── Client
        ├── Abandon ---------------------> request denied / verification saved
        └── Provide proof
            └── Verification chance
                ├── Valid/detected ------> allow or block
                └── Invalid/missed ------> possible breach
```

Game-theoretic modeling helps answer:

- Does the server's threat to verify deter fake proofs?
- Is verification worth its compute and latency cost after proof arrives?
- If verification is costly, would the server actually perform it, or is the threat non-credible?
- What randomized audit rate makes a malicious attempt unprofitable?
- What does the client know about the audit policy?

Engineering controls such as cryptographic proofs, automatic verification, non-bypassable policy, and committed audit rates turn a discretionary and possibly non-credible threat into a credible mechanism.

## 5. Diagrams / Mental Models

### Tree vocabulary

```text
root node
├── action A -> decision node
│               ├── action C -> terminal payoff
│               └── action D -> terminal payoff
└── action B -> terminal payoff

root-to-node action sequence = history
root-to-terminal sequence    = play/path/outcome
complete choices at all of a player's information sets = strategy
```

### Information set

```text
          hidden earlier choice
             /            \
        node x ........... node y     <- same information set
          |                   |
       choose A/B          choose A/B

The acting player cannot tell whether it is at x or y,
so its strategy must prescribe the same available action at both.
```

### Backward-induction workflow

```text
terminal payoffs
      |
choose optimal action at latest decision nodes
      |
replace each solved continuation with its value
      |
repeat toward root
      |
obtain strategy at every node, not only the path
```

## 6. Common Interview Questions

### Q1. What is an extensive-form game?

**Answer:** It is a game-tree representation showing histories, order of moves, the acting player, available actions, information sets, chance probabilities, and terminal payoffs.

**Interviewer expects:** Timing and information as its distinguishing strengths.

**Common mistake:** Describing only a decision tree without strategic players and payoffs.

### Q2. What is the difference between a node and an information set?

**Answer:** A node is one particular history. An information set groups decision nodes that the acting player cannot distinguish when choosing an action.

**Interviewer expects:** Same action must be selected at all nodes in one information set.

**Common mistake:** Treating an information set as a set of possible actions.

### Q3. What is perfect information?

**Answer:** At each decision, the acting player observes the complete prior action history; therefore every information set is a singleton.

**Interviewer expects:** Contrast with complete information.

**Common mistake:** Saying it means all payoffs or types are known, or that there is no randomness.

### Q4. What is backward induction?

**Answer:** Solve the last decisions first using optimal actions, substitute their continuation payoffs, and recursively move toward the root.

**Interviewer expects:** It determines actions at all decision nodes in finite perfect-information games.

**Common mistake:** Following only the most attractive root-to-leaf path without accounting for later decision-makers.

### Q5. What is a subgame?

**Answer:** A subtree beginning at a singleton information set that contains all descendants and does not cut across any information set.

**Interviewer expects:** The information-set restriction.

**Common mistake:** Calling every subtree a valid subgame.

### Q6. What is subgame-perfect Nash equilibrium?

**Answer:** A strategy profile that is a Nash equilibrium in every subgame. It requires sequential rationality even after histories not reached on the equilibrium path.

**Interviewer expects:** It removes non-credible threats.

**Common mistake:** Defining it as the Nash equilibrium with the largest payoff.

### Q7. Why must strategies include off-path actions?

**Answer:** Because the opponent's earlier decision can depend on what the player would do after a deviation, and equilibrium refinements test rationality in those continuations.

**Interviewer expects:** Credibility and counterfactual reasoning.

**Common mistake:** Reporting only the equilibrium action sequence as the strategy profile.

### Q8. What is a chance node?

**Answer:** A node at which nature selects an action according to fixed probabilities. Expected continuation values are computed from those probabilities.

**Interviewer expects:** Nature does not optimize.

**Common mistake:** Assigning nature a payoff-maximizing strategy.

### Q9. How do extensive and normal form relate?

**Answer:** Enumerate each player's complete contingent strategies from the tree, then compute the terminal outcome and payoffs for every strategy profile. This produces normal form, often with exponential growth and loss of visible timing/information structure.

**Interviewer expects:** Strategies, not just tree actions, become matrix rows/columns.

**Common mistake:** Putting individual branches directly into the matrix when a player moves more than once.

### Q10. What is a credible threat?

**Answer:** A threatened continuation action is credible if carrying it out is optimal when the relevant decision point is actually reached. Non-credible threats can support Nash equilibria in normal form but fail subgame perfection.

**Interviewer expects:** Sequential rationality.

**Common mistake:** Assuming an announced threat is credible because it changes earlier behavior.

### Q11. What is perfect recall?

**Answer:** Players remember their own earlier actions and information at every later information set.

**Interviewer expects:** Distinction from observing all opponents' actions.

**Common mistake:** Equating perfect recall with perfect information.

### Q12. What is the difference between a mixed and behavioral strategy?

**Answer:** A mixed strategy randomizes over complete pure plans at the start. A behavioral strategy randomizes locally at each information set. With perfect recall, they generate equivalent outcome distributions against opponents under standard conditions.

**Interviewer expects:** Randomization timing and Kuhn's theorem.

**Common mistake:** Claiming equivalence even with imperfect recall.

## 7. Deep-Dive Questions

### Q1. Can a Nash equilibrium contain a non-credible threat?

Yes. Nash equilibrium tests unilateral deviations from the complete profile. If an earlier player stays away, the threatened continuation is off-path and may never be tested by payoff comparison. Subgame-perfect equilibrium examines the continuation subgame directly and rejects a threat that would not be optimal when reached.

### Q2. Why cannot a subgame cut an information set?

Doing so would pretend that the acting player knows which node within that information set has occurred. The resulting continuation would change the information structure of the original game and would not be a self-contained game.

### Q3. How do you represent simultaneous play in extensive form?

Draw one player moving first only as a representation device, then connect the second player's decision nodes in one information set so the second player does not observe the first action. This preserves strategic simultaneity despite the visual order.

### Q4. When does backward induction fail as a simple solution method?

It is not directly sufficient in games with imperfect information because a player may not know which decision node they occupy, in infinite-horizon games without suitable terminal structure, or when beliefs at information sets must be specified. Concepts such as sequential equilibrium, perfect Bayesian equilibrium, and dynamic programming under additional conditions may be needed.

### Q5. Why can commitment change an extensive-form outcome?

Commitment removes future actions from the committing player's feasible set or changes their payoff, making a previously non-credible response automatic or optimal. Examples include an immutable smart contract, automatic rate limiter, published pricing rule, or hardware-backed access policy.

## 8. Comparison Tables

### Normal form versus extensive form

| Dimension | Normal form | Extensive form |
|---|---|---|
| Main representation | Strategy/payoff table or functions | Game tree |
| Timing | Hidden in complete strategies | Explicit |
| Information | Mostly implicit | Explicit information sets |
| Compactness | Compact for small strategy sets | Compact for sequential structure |
| Best suited for | Dominance and mutual best responses | Backward induction and credibility |
| Equilibrium refinement | Nash | Subgame-perfect/sequential concepts |

### Perfect versus imperfect information

| Dimension | Perfect information | Imperfect information |
|---|---|---|
| Observed history | Complete before each move | Some nodes indistinguishable |
| Information sets | Singleton | May contain multiple nodes |
| Example | Chess | Poker or simultaneous choice |
| Basic method | Backward induction in finite games | Beliefs and information-set strategies needed |

### Nash versus subgame-perfect equilibrium

| Dimension | Nash equilibrium | Subgame-perfect Nash equilibrium |
|---|---|---|
| Deviations tested | From complete profile | Nash behavior in every subgame |
| Off-path rationality | May fail | Required in every subgame |
| Non-credible threats | May survive | Eliminated |
| Relationship | Broader set | Refinement; every SPNE is Nash |

### Mixed versus behavioral strategy

| Dimension | Mixed | Behavioral |
|---|---|---|
| Randomization | Once over complete plans | Separately at information sets |
| Correlation across own moves | Can be built in | Local randomization |
| Perfect recall | Outcome-equivalent under Kuhn's theorem | Outcome-equivalent under Kuhn's theorem |
| Imperfect recall | May differ | May differ |

## 9. Common Mistakes

- Calling a branch a strategy when the player has multiple decision points.
- Reporting only the equilibrium path and omitting off-path choices.
- Confusing perfect information with complete information.
- Allowing different actions at nodes in the same information set.
- Starting a subgame inside a non-singleton information set.
- Treating nature as a payoff-maximizing player.
- Believing every announced punishment is credible.
- Using forward intuition instead of solving later nodes first.
- Converting actions rather than complete strategies into normal form.
- Assuming backward induction alone solves every imperfect-information game.

## 10. Edge Cases / Special Cases

- **Tied continuation payoffs:** Backward induction can generate multiple subgame-perfect equilibria.
- **Imperfect information:** Proper subgames may be absent, so subgame perfection may not refine Nash enough.
- **Imperfect recall:** Behavioral and mixed strategies can produce different attainable distributions.
- **Infinite horizon:** There may be no final node from which to start backward induction.
- **Chance with unknown probabilities:** Players need beliefs or ambiguity-sensitive rules.
- **Simultaneous move:** Represented with a multi-node information set.
- **Unobserved action versus unknown type:** Both create uncertainty but may require different tree structures.
- **Commitment devices:** Can change later feasibility and turn threats into credible rules.
- **Repeated games:** The tree grows exponentially with horizon and infinitely for indefinite repetition.
- **Zero-probability information sets:** Sequential refinements require beliefs even at information sets not reached in equilibrium.

## 11. How to Explain in Interview

> An extensive-form game is a game tree that makes move order, observations, chance events, and terminal payoffs explicit. A strategy is a complete plan at every information set. In finite perfect-information games, I solve from the leaves using backward induction; requiring Nash behavior in every subgame gives subgame-perfect equilibrium and removes non-credible threats.

## 12. Quick Revision Notes

- Node = history/state; branch = action; leaf = terminal payoff.
- Information set = nodes the acting player cannot distinguish.
- Perfect information means every information set is a singleton.
- Strategy specifies an action at every information set, including off-path ones.
- Backward induction solves later decisions before earlier ones.
- A subgame cannot cut an information set.
- SPNE is Nash in every subgame and removes non-credible threats.
- Nature follows probabilities and has no strategic objective.
- Mixed strategy randomizes over plans; behavioral strategy randomizes locally.
- Interview trap: equilibrium path is not the same as equilibrium strategy profile.

## 13. Practice Tasks

1. Draw and solve the market-entry tree in Section 2.
2. Change the incumbent's fight payoff so fighting becomes credible; solve again.
3. Draw a two-stage database lock game with `Wait`, `Abort`, and `Retry` actions.
4. Represent a simultaneous `2 x 2` game as a tree using an information set.
5. Enumerate complete strategies from a tree where one player moves at two nodes.
6. Convert that tree into normal form.
7. Identify every proper subgame and find the subgame-perfect equilibria.
8. Add a chance node for dependency compatibility and propagate expected payoffs backward.
9. Design a commitment device that changes a non-credible security audit threat.
10. Explain where backward induction becomes insufficient in a hidden-type authentication game.

## 14. Final Cheat Sheet

| Item | Must remember |
|---|---|
| Core definition | Tree of histories, actions, information, chance, and payoffs |
| Why it matters | Makes timing, observation, and credibility explicit |
| Most asked | Backward induction, information sets, SPNE, credible threats |
| Solving rule | Start at the leaves and reason backward |
| Key trap | A strategy covers every information set, not only the played path |
| One-line answer | “Extensive form is the game tree; backward induction plus subgame rationality removes empty threats.” |

---

# Zero-Sum vs Non-Zero-Sum Games

## 1. Overview

### Definition

A **zero-sum game** is one in which the sum of all players' payoffs is constant—conventionally normalized to zero—for every outcome. One player's gain is exactly another player's loss. In a two-player zero-sum game, `u_2(s) = -u_1(s)`.

A **non-zero-sum game** has no such restriction. Players' interests may conflict in some dimensions and align in others. Both may gain, both may lose, or gains and losses may have different sizes.

A **constant-sum game** has `u_1 + u_2 = c` in every outcome. Subtracting a constant from payoffs converts it strategically to zero-sum, so the two are often analyzed together.

### Why it matters

The classification determines what conclusions are valid. Two-player zero-sum games have a single competitive value, minimax reasoning, and interchangeable equilibrium strategies. Non-zero-sum games require analysis of coordination, externalities, credibility, bargaining, trust, and efficiency.

### Where it is used in real systems

- **Zero-sum-like:** attacker versus defender over whether a fixed asset is compromised; two algorithms competing for a fixed prize; adversarial testing.
- **Non-zero-sum:** shared network congestion, standards adoption, database contention, cloud pricing, open-source collaboration, and repeated service interactions.
- **Machine learning:** adversarial robustness and generative adversarial training often use competitive objectives, though implementations may not be exactly zero-sum.
- **Scheduling:** assigning a fixed resource can be constant-sum, while total throughput loss from contention makes the broader system non-zero-sum.

### Why interviewers ask about it

Interviewers want candidates to classify games from payoff relationships rather than from words like “competition.” They also test maximin/minimax, saddle points, game value, Pareto improvement, and the false assumption that every competitive setting is zero-sum.

## 2. Core Idea

### Intuition

In zero-sum interaction, there is no joint surplus to create: strategic analysis is about how a fixed amount is divided. In non-zero-sum interaction, the size of the total payoff can change, so players may have both a conflict over division and a shared interest in creating or preserving value.

### Real-world analogy

- **Zero-sum:** Two candidates compete for one fixed prize worth one point. If A wins, B loses that opportunity.
- **Non-zero-sum:** Two engineering teams choose compatible APIs. They may disagree over whose standard to use, but both benefit from compatibility and both lose from fragmentation.

### Small examples

Zero-sum matching pennies, showing row player's payoff only:

| Row \ Column | Heads | Tails |
|---|---:|---:|
| **Heads** | 1 | -1 |
| **Tails** | -1 | 1 |

Column's payoff is the negative of each entry.

Non-zero-sum Prisoner's Dilemma:

| A \ B | Cooperate | Defect |
|---|---:|---:|
| **Cooperate** | `(3, 3)` | `(0, 5)` |
| **Defect** | `(5, 0)` | `(1, 1)` |

### Step-by-step classification

1. Add the players' payoffs in every cell.
2. If the sum is identical in every cell, the game is constant-sum.
3. Normalize a constant-sum game to zero-sum if useful.
4. If sums vary, it is non-zero-sum.
5. Do not classify from whether players appear hostile; inspect payoffs.
6. In zero-sum games, solve for the security value and minimax strategies.
7. In non-zero-sum games, separately evaluate equilibrium stability and joint efficiency.

## 3. Important Subtopics

### 3.1 Strictly competitive preferences

**What it means:** Players rank outcomes in exactly opposite order. In standard two-player zero-sum representation, one payoff is the negative of the other.

**Why it matters:** No outcome can improve one player without worsening the other.

**Example:** A fixed cybersecurity contest in which the protected asset is either retained by the defender or captured by the attacker.

**Common interview angle:** Real security often includes defense cost, collateral damage, and partial losses, making the full model non-zero-sum.

### 3.2 Constant-sum normalization

**What it means:** If payoffs always sum to `c`, define transformed payoffs such as `u'_1 = u_1 - c/2` and `u'_2 = u_2 - c/2`.

**Why it matters:** The transformation preserves strategic incentives while letting zero-sum results apply.

**Example:** A prize split always totals 100; subtract 50 from each payoff.

**Common interview angle:** Constant-sum and zero-sum are strategically equivalent, but non-constant sums cannot be normalized this way.

### 3.3 Maximin strategy

**What it means:** A player chooses the strategy whose worst possible payoff is as high as possible:

```text
max_x min_y u(x, y)
```

**Why it matters:** It guarantees a security level even against an adversarial response.

**Example:** A defender selects a randomized inspection policy maximizing the minimum protection across attacker targets.

**Common interview angle:** Maximin maximizes one's guaranteed payoff; it is not simply the largest value in the matrix.

### 3.4 Minimax strategy

**What it means:** The minimizing player selects a strategy minimizing the maximum payoff the opponent can obtain:

```text
min_y max_x u(x, y)
```

**Why it matters:** In finite two-player zero-sum games with mixed strategies, minimax equals maximin.

**Example:** An attacker minimizing the defender's best achievable security payoff.

**Common interview angle:** State whose payoff matrix is being maximized and minimized.

### 3.5 Minimax theorem and game value

**What it means:** For finite two-player zero-sum games with mixed strategies:

```text
max_x min_y E[u(x,y)] = min_y max_x E[u(x,y)] = v
```

`v` is the value of the game.

**Why it matters:** Neither player benefits from knowing which equilibrium strategy the other selected; all equilibrium profiles produce the same expected value.

**Example:** Matching pennies has value zero under uniform mixing.

**Common interview angle:** Pure maximin and minimax may differ; mixed strategies close the gap.

### 3.6 Saddle points

**What it means:** A pure cell is a saddle point if it is the row player's minimum within its row and the maximum of those row minima, while also the column player's relevant maximum within its column and the minimum of those column maxima, using a single payoff matrix.

**Why it matters:** A saddle point is a pure-strategy equilibrium in a two-player zero-sum game.

**Example:** If maximin equals minimax at one cell, no randomization is needed.

**Common interview angle:** Carefully follow the row-maximizer/column-minimizer convention.

### 3.7 Pareto improvements in non-zero-sum games

**What it means:** A move is a Pareto improvement if at least one player becomes better off and no player becomes worse off.

**Why it matters:** Non-zero-sum games may leave mutual gains unrealized because stable incentives differ from collective interests.

**Example:** Two services adopting compatible protocols improves both from `(0,0)` to `(3,3)`.

**Common interview angle:** Pareto-efficient does not mean fair or maximum total payoff.

### 3.8 Externalities and social dilemmas

**What it means:** A player's action affects others' payoffs without the effect being fully internalized.

**Why it matters:** Externalities create gaps between private incentives and system-wide performance.

**Example:** Aggressive retries reduce one client's latency if others back off but impose load on everyone.

**Common interview angle:** Suggest pricing, quotas, rate limits, or protocol rules that internalize the externality.

### 3.9 Coordination and conflict together

**What it means:** Non-zero-sum games can contain shared and opposed interests simultaneously.

**Why it matters:** “Cooperative interests” do not imply a cooperative game, and “competition” does not imply zero-sum.

**Example:** Teams both want one API standard but prefer their own standard.

**Common interview angle:** Describe both the surplus-creation problem and the surplus-division problem.

### 3.10 Price of anarchy

**What it means:** The price of anarchy compares the welfare of a worst equilibrium with the welfare of a socially optimal outcome, under an explicitly chosen welfare measure.

**Why it matters:** It quantifies efficiency lost through decentralized self-interested behavior.

**Example:** Selfish routing produces more total latency than centrally optimized routing.

**Common interview angle:** Define the ratio convention carefully because cost and utility formulations invert it.

## 4. Real-World Example

### Network congestion is not zero-sum

Two clients choose a fast shared link or a slower independent link.

| Client A \ Client B | Shared | Independent |
|---|---:|---:|
| **Shared** | `(1, 1)` | `(5, 3)` |
| **Independent** | `(3, 5)` | `(3, 3)` |

The payoff sums are `2`, `8`, `8`, and `6`, so the game is non-zero-sum. When both crowd the shared link, capacity is wasted through congestion; the lost performance is not transferred to another client.

Practical lessons:

- Competitive resource access does not make the interaction zero-sum.
- Congestion destroys total value, creating scope for Pareto improvements.
- A congestion price or admission controller can change private payoffs.
- A scheduler can coordinate access and preserve throughput.
- If the only modeled payoff were a fixed rank—first versus second—the model might look zero-sum but omit actual latency and capacity costs.

## 5. Diagrams / Mental Models

```text
ZERO-SUM
Player A gain  <====================> Player B loss
Total strategic payoff remains constant

NON-ZERO-SUM
             create/destroy joint value
                      |
        +-------------+-------------+
        |                           |
   divide the value             coordinate actions
```

### Quick classification table

| Cell | A payoff | B payoff | Sum |
|---|---:|---:|---:|
| 1 | 4 | -4 | 0 |
| 2 | -1 | 1 | 0 |
| 3 | 2 | -2 | 0 |

Constant sum across all cells implies a constant-sum game; the value need not originally be zero.

## 6. Common Interview Questions

### Q1. What is a zero-sum game?

**Answer:** A game where total payoff is constant across outcomes, conventionally zero, so one player's gain equals another's loss.

**Interviewer expects:** Payoff-sum definition.

**Common mistake:** Calling any competitive game zero-sum.

### Q2. What is a non-zero-sum game?

**Answer:** A game where payoff sums can vary across outcomes. Players may share some interests while conflicting over others.

**Interviewer expects:** Possibility of mutual gain or loss.

**Common mistake:** Assuming it means players always cooperate.

### Q3. How do you classify a payoff matrix?

**Answer:** Add player payoffs in every cell. A common sum means constant-sum; normalize it to zero if desired. Varying sums mean non-zero-sum.

**Interviewer expects:** Cell-by-cell check.

**Common mistake:** Checking only one or two outcomes.

### Q4. What is the maximin strategy?

**Answer:** The strategy maximizing the player's minimum payoff across all opponent responses. It provides the best guaranteed payoff.

**Interviewer expects:** Security-level interpretation.

**Common mistake:** Selecting the row containing the matrix's largest entry.

### Q5. State the minimax theorem.

**Answer:** In finite two-player zero-sum games allowing mixed strategies, the maximizing player's maximin expected payoff equals the minimizing player's minimax expected payoff; this common number is the game value.

**Interviewer expects:** Mixed strategies and finite two-player zero-sum assumptions.

**Common mistake:** Claiming pure strategies always satisfy equality.

### Q6. What is a saddle point?

**Answer:** A pure strategy profile where the maximizer cannot improve against the chosen column and the minimizer cannot reduce the payoff against the chosen row. It is a pure zero-sum Nash equilibrium.

**Interviewer expects:** Maximin equals minimax at that cell.

**Common mistake:** Calling any local numerical maximum a saddle point.

### Q7. Is the Prisoner's Dilemma zero-sum?

**Answer:** No. Payoff sums vary, and mutual cooperation can improve both players relative to mutual defection.

**Interviewer expects:** Demonstration from the matrix.

**Common mistake:** Saying it is zero-sum because the players have conflicting incentives.

### Q8. Is every security game zero-sum?

**Answer:** No. Defense costs, attack costs, false positives, collateral damage, multiple assets, and outcomes where both sides lose can make total payoffs vary.

**Interviewer expects:** Model classification depends on payoffs, not domain label.

**Common mistake:** Treating attacker-defender wording as proof.

### Q9. Why is Pareto efficiency less informative in a two-player zero-sum game?

**Answer:** Improving one player necessarily worsens the other, so every feasible outcome is typically Pareto-efficient under strict opposition. The key zero-sum question is security value, not joint surplus.

**Interviewer expects:** No mutual improvement is possible.

**Common mistake:** Saying zero-sum equilibria maximize both players' payoffs.

### Q10. Can non-zero-sum games have Nash equilibria?

**Answer:** Yes. Nash equilibrium applies broadly. Non-zero-sum games may have efficient or inefficient, unique or multiple, pure or mixed equilibria.

**Interviewer expects:** Zero-sum is a class, not a prerequisite for equilibrium.

**Common mistake:** Associating minimax with all Nash equilibria.

### Q11. What is the value of a zero-sum game?

**Answer:** The expected payoff guaranteed to the maximizing player and held to by the minimizing player when both use minimax-optimal strategies.

**Interviewer expects:** All equilibrium pairs share this value.

**Common mistake:** Calling the maximum matrix entry the game value.

### Q12. What is the price of anarchy?

**Answer:** A measure of efficiency loss comparing a socially optimal outcome with the worst equilibrium under a chosen welfare or cost function.

**Interviewer expects:** Selfish routing or congestion example.

**Common mistake:** Computing it before defining social welfare and ratio direction.

## 7. Deep-Dive Questions

### Q1. Why are equilibrium strategies interchangeable in two-player zero-sum games?

Every equilibrium strategy of the maximizer guarantees at least the value, and every equilibrium strategy of the minimizer holds the opponent to at most the value. Pairing any such optimal strategies still produces the value, so the pair is an equilibrium.

### Q2. Can a general-sum game be transformed into zero-sum by subtracting the opponent's payoff?

Not without changing incentives. Replacing `u_i` by `u_i-u_j` changes how player `i` ranks outcomes unless the original sum was constant. Only payoff transformations preserving each player's relevant preferences leave the same strategic game.

### Q3. How does linear programming solve finite zero-sum games?

The maximizing player selects probabilities and a guaranteed value `v`, with constraints ensuring expected payoff against every opponent pure strategy is at least `v`. The dual program gives the minimizing player's problem. Strong duality mirrors the minimax theorem.

### Q4. Why can a zero-sum approximation be dangerous in system design?

It may omit destroyed or created value, such as outage cost, energy use, congestion, or collateral damage. A policy optimized to defeat an opponent under a fixed-sum model can reduce welfare for all real participants.

### Q5. How do repeated games change a non-zero-sum dilemma?

Future rewards and punishments can support cooperation that is unstable in the one-shot stage game. The relevant comparison is the immediate deviation gain versus discounted future loss; sufficiently patient players may cooperate in equilibrium.

## 8. Comparison Tables

### Zero-sum versus non-zero-sum

| Dimension | Zero-sum | Non-zero-sum |
|---|---|---|
| Payoff sum | Constant, normalized to 0 | Varies |
| Interests | Strictly opposed | May align and conflict |
| Mutual gain | Impossible within fixed outcomes | Often possible |
| Core solution idea | Minimax/game value | Nash plus efficiency/coordination analysis |
| Equilibrium payoffs | Same value in two-player case | May differ across equilibria |
| System example | Fixed-prize contest | Congestion and standards adoption |

### Maximin versus minimax

| Dimension | Maximin | Minimax |
|---|---|---|
| Perspective | Maximizing player | Minimizing player |
| Operation | Maximize worst payoff | Minimize opponent's best payoff |
| Meaning | Best guarantee | Tightest upper bound |
| Zero-sum mixed equilibrium | Equals game value | Equals game value |

### Nash reasoning versus minimax reasoning

| Dimension | Nash | Minimax |
|---|---|---|
| Applicable games | General strategic games | Primarily adversarial/zero-sum security reasoning |
| Belief | Opponent uses equilibrium strategy | Protect against worst response |
| Result | Mutual best-response profile | Guaranteed value/optimal defense |
| Efficiency claim | None | Joint efficiency usually not relevant in strict zero-sum |

## 9. Common Mistakes

- Inferring zero-sum from competition or conflict.
- Forgetting that constant-sum games are strategically zero-sum after normalization.
- Assuming the sum must literally be zero in the original units.
- Applying minimax mechanically to general-sum games.
- Confusing maximum matrix entry with maximin value.
- Ignoring mixed strategies when pure maximin and minimax differ.
- Assuming a zero-sum equilibrium is unique because its value is unique.
- Assuming non-zero-sum means cooperative or friendly.
- Confusing Pareto efficiency with maximum total payoff or fairness.
- Using payoff addition without justifying interpersonal comparisons.

## 10. Edge Cases / Special Cases

- **More than two players:** Constant total payoff does not imply pairwise strict opposition; coalitions complicate analysis.
- **Constant-sum but nonzero:** Strategically equivalent to zero-sum after suitable shifts.
- **Unique value, multiple strategies:** Zero-sum equilibrium payoff is unique, equilibrium strategies need not be.
- **Approximate zero-sum:** Small shared costs can materially alter incentives near indifference.
- **Risk-sensitive players:** Expected payoff minimax may not capture nonlinear utility.
- **Unknown opponent model:** Robust maximin may be safer but conservative.
- **Side payments:** Transfers can turn a non-zero-sum bargaining problem into a different game.
- **Negative externalities:** Both players can lose value; this proves the broader interaction is not fixed-sum.
- **Finite versus continuous games:** Minimax equality in continuous games needs technical convexity/compactness conditions.
- **Team games:** Several agents with identical payoff can act as one side only if coordination and information assumptions justify it.

## 11. How to Explain in Interview

> In a zero-sum game, total payoff is constant, so one player's gain is exactly another's loss; two-player finite games are solved using minimax, and mixed strategies guarantee a common game value. In a non-zero-sum game, total value can change, so I analyze not only Nash stability but also coordination, externalities, and Pareto efficiency. I classify from the payoff sums, not from whether the story sounds competitive.

## 12. Quick Revision Notes

- Zero-sum: `u_1 + u_2 = 0`; constant-sum can be normalized.
- Non-zero-sum: payoff sums vary; mutual gain or loss can occur.
- Maximin = best guaranteed payoff.
- Minimax = smallest upper bound the opponent permits.
- Mixed-strategy minimax theorem gives equality and game value.
- Saddle point = pure zero-sum equilibrium.
- Zero-sum value is unique; strategies may not be.
- Non-zero-sum equilibrium may be Pareto-inefficient.
- Competition does not prove zero-sum.
- Interview trap: do not apply minimax to every strategic game.

## 13. Practice Tasks

1. Classify five payoff matrices by checking every payoff sum.
2. Normalize a constant-sum prize-allocation game to zero-sum.
3. Compute pure maximin and minimax values for a `3 x 3` matrix.
4. Determine whether a saddle point exists.
5. Derive the mixed equilibrium and value of matching pennies.
6. Model an attacker-defender game including defense and attack costs; test whether it remains zero-sum.
7. Build a congestion game and identify an equilibrium that wastes total value.
8. Compute a price-of-anarchy ratio after defining a welfare measure.
9. Explain why API-standard competition is non-zero-sum.
10. Formulate a small zero-sum matrix game as a linear program.

## 14. Final Cheat Sheet

| Item | Must remember |
|---|---|
| Core definition | Zero-sum has constant total payoff; non-zero-sum does not |
| Why it matters | Determines whether minimax or broader incentive analysis applies |
| Most asked | Classification, maximin/minimax, saddle point, minimax theorem |
| Key test | Add payoffs in every outcome |
| Key trap | Competitive does not automatically mean zero-sum |
| One-line answer | “Zero-sum divides fixed value; non-zero-sum can also create or destroy value.” |

---

# Cooperative vs Non-Cooperative Games

## 1. Overview

### Definition

**Non-cooperative game theory** models individual players choosing strategies under specified rules. Agreements are not automatically binding; stable behavior is justified by each player's incentives. Nash equilibrium, dominant strategies, subgame perfection, and repeated-game strategies belong primarily to this framework.

**Cooperative game theory** models what groups or **coalitions** can achieve together and how the resulting value or cost should be divided. Binding agreements, enforceable transfers, or coalition commitments are generally assumed. Central questions include which coalition forms, whether an allocation is stable, and whether the division is fair.

The distinction is about the modeling framework and enforceability—not about whether players behave politely. Players can cooperate in a non-cooperative repeated game, and members of a cooperative game can bargain aggressively over the surplus.

### Why it matters

The two frameworks solve different engineering and business questions:

- Non-cooperative: “Given these rules and incentives, what will each independent participant do?”
- Cooperative: “What value can each group create, which groups are stable, and how should shared value or cost be allocated?”

### Where it is used in real systems

- **Non-cooperative:** auctions, congestion control, independent retries, adversarial security, pricing, and protocol participation.
- **Cooperative:** shared cloud-cost allocation, federated compute pools, supply-chain partnerships, bandwidth-sharing coalitions, joint caching, and revenue sharing.
- **Hybrid systems:** nodes first decide whether to join a coalition and then act strategically inside or outside it.

### Why interviewers ask about it

Interviewers test whether candidates understand binding versus self-enforcing behavior, coalition characteristic functions, transferable utility, the core, Shapley value, Nash equilibrium, and the fact that repeated non-cooperative games can sustain cooperation without becoming cooperative games in the formal sense.

## 2. Core Idea

### Intuition

Non-cooperative analysis starts with individual strategy choices. Cooperative analysis starts with the productive capability of groups.

```text
Non-cooperative:
rules + individual strategies + incentives -> equilibrium behavior

Cooperative:
coalition values + feasible divisions -> stable/fair allocation
```

### Real-world analogy

Three services can buy separate reserved instances or share one larger instance. Together they save money. Cooperative game theory asks how much each subset could save and how the total saving should be divided. Non-cooperative game theory asks whether services will truthfully report demand, join, overconsume, or leave under a proposed billing rule.

### Small example

Players A, B, and C can cooperate on a joint cache. Coalition value `v(S)` is saved cost:

| Coalition `S` | `v(S)` |
|---|---:|
| `∅` | 0 |
| `{A}` | 0 |
| `{B}` | 0 |
| `{C}` | 0 |
| `{A,B}` | 6 |
| `{A,C}` | 4 |
| `{B,C}` | 2 |
| `{A,B,C}` | 9 |

### Step-by-step explanation

1. The **grand coalition** `{A,B,C}` creates value `9`.
2. An allocation `(x_A, x_B, x_C)` distributes that value.
3. **Efficiency** requires `x_A + x_B + x_C = 9`.
4. **Individual rationality** requires each player to get at least what they can achieve alone: here, at least `0`.
5. **Coalitional stability** asks whether any subset receives less than its own value. For example, A and B together need `x_A + x_B >= 6` to avoid wanting to leave.
6. The **core** is the set of efficient allocations satisfying every coalition constraint.
7. A fairness solution such as the **Shapley value** instead averages each player's marginal contribution across every joining order. Fairness and core stability are related but not identical.

## 3. Important Subtopics

### 3.1 Binding agreements and self-enforcement

**What it means:** Cooperative models typically permit enforceable coalition agreements. Non-cooperative models require behavior to be individually optimal under the game's rules.

**Why it matters:** A promise to share capacity has different force if a contract, scheduler, or smart contract enforces it.

**Example:** Services promise not to exceed quotas. Without enforcement, quota compliance must be an equilibrium; with a non-bypassable gateway, it can be contractually enforced.

**Common interview angle:** Ask what prevents a participant from deviating after agreement.

### 3.2 Coalitions and the grand coalition

**What it means:** A coalition is any subset of players that coordinates. The grand coalition contains all players.

**Why it matters:** A proposed grand-coalition allocation is unstable if a subset can do better by leaving.

**Example:** Two data centers may peer independently if the three-center agreement allocates them too little benefit.

**Common interview angle:** With `n` players there are `2^n` coalitions including the empty coalition, which creates computational growth.

### 3.3 Characteristic function

**What it means:** In a characteristic-function game, `v(S)` gives the value coalition `S` can guarantee or generate.

**Why it matters:** It summarizes coalition capabilities without explicitly modeling how outsiders organize.

**Example:** `v({A,B}) = 6` means A and B together can create six units of saving.

**Common interview angle:** In some real settings, a coalition's value depends on what outsiders do; then a partition-function model may be needed.

### 3.4 Transferable versus non-transferable utility

**What it means:** With **transferable utility (TU)**, coalition value can be redistributed through money or an equivalent transferable unit. With **non-transferable utility (NTU)**, a coalition has a set of feasible individual utility vectors rather than one divisible number.

**Why it matters:** Many allocation formulas assume freely transferable value.

**Example:** Cloud bill savings are transferable as money; latency experienced by one service cannot always be transferred to another.

**Common interview angle:** Do not apply the Shapley-value formula blindly when utility is not transferable.

### 3.5 Imputation

**What it means:** In a TU game, an imputation is typically an efficient, individually rational allocation: it distributes `v(N)` fully and gives each player at least `v({i})`.

**Why it matters:** It defines minimally acceptable divisions of grand-coalition value.

**Example:** If the grand coalition saves 9 and a player saves 2 alone, an allocation below 2 will not induce that player to join.

**Common interview angle:** An imputation need not be stable against multi-player coalitions.

### 3.6 The core

**What it means:** The core contains efficient allocations that no coalition can block:

```text
sum_{i in N} x_i = v(N)
sum_{i in S} x_i >= v(S) for every coalition S
```

for a value-sharing TU game.

**Why it matters:** It captures coalition stability.

**Example:** If A and B can make `6` alone but receive only `5` together, they can block the allocation.

**Common interview angle:** The core can be empty, contain one allocation, or contain many.

### 3.7 Shapley value

**What it means:** The Shapley value assigns each player their average marginal contribution over all possible orders in which players might join:

```text
phi_i(v) = sum over S subset of N\{i}
           [ |S|! (n-|S|-1)! / n! ] * [v(S union {i}) - v(S)]
```

**Why it matters:** It gives a principled fairness allocation satisfying efficiency, symmetry, dummy-player, and additivity axioms.

**Example:** A service whose data dramatically improves every coalition's cache hit rate receives a larger share.

**Common interview angle:** The Shapley value is unique under its axioms but need not lie in the core for every game.

### 3.8 Convex cooperative games

**What it means:** A cooperative game is convex when marginal contributions grow as the coalition being joined grows; equivalently, the value function is supermodular.

**Why it matters:** Convex games have a nonempty core, and the Shapley value lies in the core.

**Example:** Complementary datasets may become more valuable as more sources join.

**Common interview angle:** Do not confuse convex cooperative games with convex optimization or convex utility functions.

### 3.9 Repeated-game cooperation

**What it means:** Players in a non-cooperative repeated game may use reward and punishment strategies that make cooperative actions self-enforcing.

**Why it matters:** Formal cooperation does not require a cooperative-game model.

**Example:** Independent services share capacity fairly because overuse triggers future throttling or reciprocal denial.

**Common interview angle:** The game remains non-cooperative because individual strategies and incentives enforce the behavior.

### 3.10 Mechanism design as a bridge

**What it means:** Mechanism design specifies rules so strategic individual behavior produces a desired allocation or coalition outcome.

**Why it matters:** A fair cooperative allocation is not operational until participants are motivated to reveal information and comply.

**Example:** A billing mechanism implements shared-cost allocation while discouraging inflated demand reports.

**Common interview angle:** Allocation fairness, incentive compatibility, budget balance, and participation may conflict.

## 4. Real-World Example

### Shared cloud infrastructure cost allocation

Three teams can deploy separately or share a cluster. Standalone monthly costs are:

- A: ₹60,000
- B: ₹50,000
- C: ₹30,000

Suppose joint deployments cost less due to multiplexing. Define coalition **savings** as standalone cost minus shared cost. Cooperative analysis proceeds as follows:

```text
measure cost of every coalition
             |
convert to coalition savings v(S)
             |
choose allocation rule: core / Shapley / negotiated
             |
verify efficiency and participation
```

Practical questions:

- Does the allocation distribute the entire saving?
- Does each team pay no more than deploying alone?
- Could a subset leave and operate more cheaply?
- Is usage accurately reported?
- Can one team cause noisy-neighbor costs for others?

Cooperative theory can produce a fair savings allocation, but implementation is non-cooperative: teams may exaggerate baselines, underreport demand, or overconsume shared capacity. Metering, admission control, auditable cost models, and enforceable quotas are needed to make the intended allocation work.

## 5. Diagrams / Mental Models

### Framework choice

```text
Are enforceable coalition agreements the central object?
                 |
          +------+------+
          |             |
         yes            no
          |             |
coalition value and   individual strategies
allocation analysis  and equilibrium analysis
  (cooperative)       (non-cooperative)
```

### Cooperative allocation tests

```text
Grand-coalition value v(N)
           |
           v
Allocation x
  ├── Efficiency: distribute all value
  ├── Individual rationality: each beats outside option
  ├── Coalition stability: no subset can block
  └── Fairness: contribution/symmetry principles
```

### Stability versus fairness

| Question | Typical concept |
|---|---|
| Does every player accept participation? | Individual rationality |
| Can any coalition profitably leave? | Core |
| What is each player's average marginal contribution? | Shapley value |
| Will unilateral strategy deviations occur? | Nash equilibrium |

## 6. Common Interview Questions

### Q1. What is the difference between cooperative and non-cooperative game theory?

**Answer:** Non-cooperative theory models individual strategies and self-enforcing equilibria. Cooperative theory models coalition capabilities and allocation of coalition value, usually assuming binding agreements or enforceable transfers.

**Interviewer expects:** Framework/enforceability distinction.

**Common mistake:** Saying cooperative players are friendly and non-cooperative players are hostile.

### Q2. Can cooperation occur in a non-cooperative game?

**Answer:** Yes. Repetition, reputation, punishments, contracts represented as moves, or aligned payoffs can make cooperative actions an equilibrium.

**Interviewer expects:** Repeated Prisoner's Dilemma example.

**Common mistake:** Classifying from observed behavior instead of model structure.

### Q3. What is a coalition?

**Answer:** A subset of players coordinating their actions and possibly sharing the value they create. The coalition containing all players is the grand coalition.

**Interviewer expects:** Any subset, not only pairs.

**Common mistake:** Assuming a coalition is automatically stable or optimal.

### Q4. What is a characteristic function?

**Answer:** A function `v(S)` assigning a value to every coalition `S`, commonly the amount that coalition can guarantee or create independently.

**Interviewer expects:** Domain `2^N` and `v(∅)=0` convention.

**Common mistake:** Treating it as an individual payoff function over strategies.

### Q5. What is transferable utility?

**Answer:** Coalition value can be freely redistributed among members, usually through money or an equivalent unit, so the coalition can be represented by one scalar value.

**Interviewer expects:** Contrast with feasible utility vectors in NTU games.

**Common mistake:** Assuming latency, reliability, or privacy utility is always transferable.

### Q6. What is the core?

**Answer:** The set of efficient allocations that no coalition can block by leaving and obtaining more total value for its members.

**Interviewer expects:** Efficiency plus every coalition constraint.

**Common mistake:** Checking only individual rationality.

### Q7. Can the core be empty?

**Answer:** Yes. Coalition demands may be mutually incompatible with distributing only the grand-coalition value. Empty core means no allocation is stable against all coalition deviations under that model.

**Interviewer expects:** It is a set, not always a single solution.

**Common mistake:** Assuming a grand coalition always has a stable division.

### Q8. What is the Shapley value?

**Answer:** It assigns each player their expected marginal contribution when players join in a uniformly random order. It is the unique allocation satisfying efficiency, symmetry, dummy, and additivity axioms.

**Interviewer expects:** Marginal contribution and axioms.

**Common mistake:** Dividing coalition value equally regardless of contribution.

### Q9. Is the Shapley value always in the core?

**Answer:** No. It lies in the core for important classes such as convex games, but a general game's Shapley allocation may be blockable.

**Interviewer expects:** Fairness and stability are distinct.

**Common mistake:** Assuming any axiomatic fairness solution guarantees coalition stability.

### Q10. What is an imputation?

**Answer:** In a standard TU value game, it is an allocation of the grand-coalition value that is efficient and individually rational.

**Interviewer expects:** Outside-option constraint.

**Common mistake:** Calling every allocation an imputation.

### Q11. How does Nash equilibrium differ from the core?

**Answer:** Nash equilibrium blocks profitable unilateral strategy deviations in a specified non-cooperative game. The core blocks profitable deviations by any coalition from a value allocation in a cooperative game.

**Interviewer expects:** Individual strategy stability versus group allocation stability.

**Common mistake:** Treating one as a stronger version of the other without acknowledging different models.

### Q12. How would you apply cooperative game theory to cloud cost sharing?

**Answer:** Estimate the cost or saving achievable by every team coalition, define `v(S)`, calculate an allocation using a rule such as Shapley value or the core, and then verify participation, coalition stability, metering accuracy, and enforceability.

**Interviewer expects:** Both allocation math and practical incentive issues.

**Common mistake:** Calculating a fair split while ignoring strategic usage reports or departure options.

## 7. Deep-Dive Questions

### Q1. Compute the Shapley value conceptually for three players.

List all six joining orders. In each order, record how much value player `i` adds to the players who arrived before them. Average those six marginal contributions for each player. The results sum to `v(N)` because marginal contributions telescope to total coalition value in every order.

### Q2. Why can the core be empty?

Suppose each two-player coalition can generate a high value, but the grand coalition cannot generate enough to satisfy all pairwise minimum claims simultaneously. The allocation constraints become infeasible. This is a stability failure, not an arithmetic error.

### Q3. What is the Bondareva-Shapley result?

For transferable-utility games, the core is nonempty exactly when the game is balanced. Intuitively, no balanced weighted collection of coalitions can collectively claim more than the grand coalition's value. In most placement interviews, stating the theorem and intuition is sufficient.

### Q4. What if coalition value depends on how outsiders group themselves?

The characteristic function `v(S)` is insufficient because it assigns one value to `S` independent of the outside partition. A partition-function game records coalition value conditional on the entire coalition structure, capturing externalities among coalitions.

### Q5. How can a cooperative solution be implemented when agreements are not naturally binding?

Build a non-cooperative mechanism: auditable measurements, automatic transfers, escrow, quotas, penalties, or smart contracts. Then verify incentive compatibility, individual rationality, and equilibrium compliance. This separates the desired allocation from the protocol that implements it.

## 8. Comparison Tables

### Cooperative versus non-cooperative games

| Dimension | Cooperative | Non-cooperative |
|---|---|---|
| Primary object | Coalitions and value allocations | Individual strategies and rules |
| Agreements | Usually binding/enforceable | Must be self-enforcing unless enforcement is modeled |
| Main questions | Who joins? How is value divided? Is allocation stable/fair? | What will each player do? Is behavior an equilibrium? |
| Common concepts | Core, Shapley value, imputation | Nash, dominance, SPNE, mixed strategies |
| Typical input | Characteristic function `v(S)` | Strategy sets and payoff functions `u_i(s)` |
| Engineering example | Shared infrastructure cost split | Independent clients selecting retry policies |

### Core versus Shapley value

| Dimension | Core | Shapley value |
|---|---|---|
| Type | Set of allocations | One allocation |
| Goal | Coalition stability | Axiomatic fairness/contribution |
| Can be empty? | Yes | No for finite TU games |
| Can have many solutions? | Yes | No; unique for a given game |
| Relationship | Shapley need not belong to it | Lies in core for convex games |

### Individual rationality versus coalition rationality

| Dimension | Individual rationality | Coalition stability |
|---|---|---|
| Constraint | `x_i >= v({i})` | `sum_{i in S} x_i >= v(S)` |
| Prevents | One player leaving alone | Any group blocking |
| Strength | Necessary for imputation | Stronger family of constraints |
| Checked for | Singleton coalitions | All coalitions |

### Cooperation in repeated games versus cooperative games

| Dimension | Repeated non-cooperative cooperation | Cooperative game |
|---|---|---|
| Enforcement | Future incentives/reputation | Binding agreement or coalition mechanism |
| Unit of analysis | Individual strategies over histories | Coalition values and allocations |
| Stability idea | Sequential/Nash incentives | No blocking coalition/core |
| Example | Reciprocal bandwidth sharing | Contracted bandwidth-sharing pool |

## 9. Common Mistakes

- Defining cooperative games as games where players behave kindly.
- Assuming any observed cooperation implies a cooperative-game framework.
- Ignoring whether agreements and transfers are enforceable.
- Confusing the characteristic function with a normal-form payoff function.
- Checking only singleton outside options when claiming an allocation is in the core.
- Assuming the core is always nonempty or contains one allocation.
- Assuming the Shapley value is always stable or always in the core.
- Applying transferable-utility formulas to non-transferable outcomes.
- Forgetting coalition externalities when using `v(S)`.
- Designing a fair cost split without addressing strategic reporting and consumption.

## 10. Edge Cases / Special Cases

- **Empty core:** No division can prevent every coalition from leaving.
- **Multiple core allocations:** Stability alone may not select a fair division.
- **Non-transferable utility:** Scalar coalition value and monetary transfer assumptions fail.
- **Coalition externalities:** A coalition's value depends on the outside partition.
- **Overlapping coalitions:** Players may participate in several resource-sharing groups simultaneously.
- **Coalition formation cost:** Negotiation, migration, and enforcement costs reduce coalition value.
- **Asymmetric information:** Players may misreport costs or contributions.
- **Dynamic coalitions:** Membership and value may change over time.
- **Negative value/cost games:** Inequalities and interpretation change when allocating cost rather than surplus; define the convention explicitly.
- **Large player count:** Exact Shapley computation needs exponentially many coalition values in general; sampling or structure-specific algorithms may be used.
- **Convex games:** The Shapley value is in the core, providing both the named fairness allocation and stability.
- **No binding enforcement:** A cooperative allocation must be implemented as an incentive-compatible non-cooperative mechanism.

## 11. How to Explain in Interview

> Non-cooperative game theory models individual strategy choices and asks whether behavior is self-enforcing, usually through Nash-type equilibrium. Cooperative game theory models what coalitions can achieve and how coalition value should be divided under enforceable agreements, using concepts such as the core and Shapley value. The key distinction is enforceability and the object being modeled, not whether players happen to cooperate.

## 12. Quick Revision Notes

- Non-cooperative: individual strategies, explicit rules, self-enforcing equilibrium.
- Cooperative: coalition values, binding agreements, allocation and stability.
- Coalition = subset of players; grand coalition = all players.
- Characteristic function `v(S)` assigns each coalition a value.
- TU allows redistribution of coalition value; NTU may not.
- Imputation = efficient and individually rational allocation.
- Core = efficient allocations no coalition can block.
- Shapley value = average marginal contribution over joining orders.
- Shapley is fair by its axioms but not always in the core.
- Repeated non-cooperative games can sustain cooperative behavior.
- Interview trap: cooperative action is not the definition of a cooperative game.

## 13. Practice Tasks

1. Define coalition values for three teams sharing a build server.
2. List all eight coalitions, including the empty and grand coalitions.
3. Test whether three proposed allocations are imputations.
4. Write every core inequality and determine whether each allocation is blocked.
5. Compute the three-player Shapley value by enumerating six joining orders.
6. Construct a cooperative game with an empty core.
7. Compare Shapley allocation and core membership for the same game.
8. Model latency sharing as an NTU problem and explain why money-like transfer fails.
9. Design a non-cooperative billing mechanism to implement a cooperative cloud-cost allocation.
10. Explain how reciprocal behavior sustains cooperation in a repeated bandwidth-sharing game.

## 14. Final Cheat Sheet

| Item | Must remember |
|---|---|
| Core definition | Cooperative studies coalitions/allocations; non-cooperative studies strategies/equilibria |
| Why it matters | Separates binding allocation problems from self-enforcing behavior |
| Most asked | Core, Shapley value, TU, Nash vs core, repeated cooperation |
| Key comparison | Core = stability set; Shapley = unique contribution-based allocation |
| Key trap | Cooperative behavior can occur in a non-cooperative game |
| One-line answer | “Cooperative theory divides coalition value; non-cooperative theory predicts individual strategic behavior.” |

---

# Cross-Topic Interview Map

Use this sequence when an interviewer gives an unfamiliar game-theory scenario:

```text
1. Identify independent decision-makers ----------------> Players
2. List complete feasible plans ------------------------> Strategies
3. Define preferences for every relevant outcome -------> Payoffs
4. State information, beliefs, and optimization --------> Rationality assumptions
5. Is timing/observation essential? --------------------> Extensive form
   Otherwise use strategy/payoff representation --------> Normal form
6. Are total payoffs constant? -------------------------> Zero/constant-sum
   Otherwise examine shared surplus and externalities --> Non-zero-sum
7. Are enforceable coalitions central? -----------------> Cooperative framework
   Otherwise test individual deviations ----------------> Non-cooperative framework
8. Match the solution concept:
   - mutual unilateral stability -----------------------> Nash equilibrium
   - sequential credibility ---------------------------> Subgame-perfect equilibrium
   - adversarial guaranteed payoff --------------------> Minimax
   - stable coalition allocation ----------------------> Core
   - contribution-based fair allocation ---------------> Shapley value
```

## Master Comparison Table

| Question being answered | Correct concept |
|---|---|
| Who chooses? | Player |
| What can they commit to doing? | Strategy |
| What do they value? | Payoff/utility |
| How do they choose under beliefs? | Rationality/best response |
| What if choices are summarized without visible timing? | Normal form |
| What if order and observations matter? | Extensive form |
| Is one side's gain exactly the other's loss? | Zero-sum/constant-sum |
| Can interaction create or destroy joint value? | Non-zero-sum |
| Must behavior be self-enforcing? | Non-cooperative analysis |
| Can coalitions bind and divide value? | Cooperative analysis |

## Thirty-Second Placement Answer

> Game theory models interdependent decisions using players, complete strategies, and payoffs. Rational players choose best responses based on their information and beliefs. Normal form emphasizes strategy profiles and payoff matrices, while extensive form shows timing, observations, and credible continuations. Zero-sum games divide fixed value and use minimax reasoning; non-zero-sum games may create mutual gains or losses. Non-cooperative theory studies self-enforcing individual behavior, whereas cooperative theory studies coalitions and allocation through concepts such as the core and Shapley value.
