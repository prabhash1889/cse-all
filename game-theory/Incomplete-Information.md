# Incomplete Information in Game Theory

Incomplete-information games model strategic situations in which at least one player does not know some payoff-relevant fact, such as another player's cost, valuation, capability, or objective. This guide develops the five ideas most often tested in interviews: **types of players, Bayesian games, prior probabilities, expected payoff, and Bayesian Nash equilibrium**.

---

## 1. Overview

### Definition

A game has **incomplete information** when a player does not know the complete structure relevant to decisions—usually another player's payoff function or private characteristic. The hidden characteristic is represented by a player's **type**.

A finite Bayesian game is commonly written as:

```text
G = (N, (A_i), (T_i), p, (u_i))
```

where:

- `N` is the set of players.
- `A_i` is player `i`'s action set.
- `T_i` is player `i`'s type set.
- `p(t_1, ..., t_n)` is the common prior over type profiles.
- `u_i(a_1, ..., a_n, t_1, ..., t_n)` is player `i`'s payoff.

A **Bayesian Nash equilibrium (BNE)** is a strategy profile in which every type of every player maximizes its expected payoff, given its beliefs and the other players' strategies.

### Why it matters

Most real strategic systems contain private information. Buyers know their valuations, cloud tenants know their urgency, services know their local load, and attackers know their capabilities. A complete-information model can predict the wrong behavior if it ignores these differences.

### Where it is used in real systems

- **Online auctions:** bidders privately know how much an item or ad impression is worth.
- **Cloud scheduling:** jobs privately know urgency, resource demand, or willingness to pay.
- **Networking:** endpoints have private traffic demand or quality requirements.
- **Cybersecurity:** defenders are uncertain about attacker type, intent, and capability.
- **Distributed systems:** nodes may be honest, faulty, selfish, or malicious.
- **Marketplaces:** sellers privately know quality or production cost.
- **Hiring and signaling:** candidates know their ability more accurately than employers.

### Why interviewers ask about it

The topic tests whether you can:

1. Distinguish an unknown action from an unknown type.
2. formalize beliefs as probabilities rather than vague uncertainty.
3. calculate conditional expected utility correctly.
4. define a strategy as a mapping from type to action.
5. verify equilibrium separately for every possible type.

---

## 2. Core Idea

### Intuition

In a complete-information game, a player asks, “What will the other player do?” In an incomplete-information game, the player must also ask, “What kind of player am I facing?”

Nature conceptually chooses the hidden types before strategic play:

```text
Nature draws type profile t from prior p
              |
              +--> Player i observes its own type t_i
              +--> Player i may not observe opponents' types t_-i
              |
              v
Players choose actions using strategies s_i(t_i)
              |
              v
Payoffs depend on actions and types
```

The “Nature” step is a modeling device. Nature does not optimize; it represents chance.

### Real-world analogy

Imagine bidding in a sealed-bid auction. You know your valuation is ₹80,000, but you do not know the other bidder's valuation. You have a belief about it—perhaps it is uniformly distributed between ₹0 and ₹100,000. Your bid should balance two effects:

- A higher bid increases the probability of winning.
- A higher bid reduces your surplus if you win.

Your best action therefore depends on your private type and on beliefs about the other bidder's type.

### Small example: deploy or wait

Two teams may deploy to a shared production service. Team A knows whether its release is **urgent** (`U`) or **routine** (`R`). Team B sees only the prior:

```text
P(A is urgent)  = 0.3
P(A is routine) = 0.7
```

Suppose B chooses `Deploy` or `Wait`. Its payoff is:

| A's type and likely action | B deploys | B waits |
|---|---:|---:|
| Urgent A deploys | -6 | 1 |
| Routine A waits | 4 | 2 |

If B believes urgent A deploys and routine A waits:

```text
EU_B(Deploy) = 0.3(-6) + 0.7(4) = 1.0
EU_B(Wait)   = 0.3(1)  + 0.7(2) = 1.7
```

So B waits. Notice that B does not maximize against one known row; it maximizes an expectation over possible types.

### Step-by-step explanation

1. **Identify private facts.** A's release urgency is private information.
2. **Create types.** `T_A = {U, R}`.
3. **Assign a prior.** B initially believes `P(U)=0.3` and `P(R)=0.7`.
4. **Define actions.** Both teams can deploy or wait.
5. **Define type-dependent payoffs.** Collision is especially costly when both deploy.
6. **Define strategies by type.** A strategy for A must say what urgent A does and what routine A does.
7. **Calculate expected payoffs.** Weight each state by its probability.
8. **Check incentives.** A BNE requires B's action and both of A's type-contingent actions to be optimal.

---

## 3. Important Subtopics

### 3.1 Types of players

#### What it means

A **type** packages everything privately known by a player that affects preferences, feasible actions, or relevant beliefs. Types can describe:

- high or low valuation;
- low or high production cost;
- urgent or delay-tolerant workload;
- honest, selfish, faulty, or malicious behavior;
- strong or weak capability;
- risk tolerance or private signal.

The phrase “types of players” does not merely classify people informally. In a Bayesian model, `t_i` is a formal variable and a pure strategy is a function:

```text
s_i : T_i -> A_i
```

If `T_i = {High, Low}` and `A_i = {Aggressive, Conservative}`, a pure strategy must specify two actions, such as:

```text
s_i(High) = Aggressive
s_i(Low)  = Conservative
```

#### Why it matters

Two types of the same player can rationally choose different actions because their payoffs differ. Checking only one type is not enough to establish equilibrium.

#### Example

In a cloud auction, a batch job values immediate execution at ₹20 while a latency-sensitive job values it at ₹100. The job's type changes its willingness to bid.

#### Common interview angle

Interviewers ask, “What belongs in a type?” A good answer is: all payoff-relevant private information needed to make the game complete once types are fixed. Avoid putting observable actions into the type unless they genuinely represent information selected before play.

### 3.2 Bayesian games

#### What it means

A **Bayesian game** combines actions, private types, beliefs, and type-dependent payoffs. Each player observes its own type and has beliefs about unknown types. In the standard Harsanyi model, a common prior generates all types.

#### Why it matters

It turns uncertainty about the game itself into uncertainty inside a larger, well-defined game. Conditional on the realized type profile, payoffs are fully specified.

#### Example

In intrusion response, the defender chooses `Monitor` or `Block`; the attacker chooses `Attack` or `Leave`. The attacker may be `Skilled` or `Unskilled`. Blocking can be necessary against a skilled attacker but unnecessarily expensive against an unskilled one.

#### Common interview angle

Be able to list the tuple and explain the timing: Nature draws types, players observe specified information, then choose actions. Also distinguish a Bayesian game from a stochastic game, where a public or private state evolves over multiple periods.

### 3.3 Prior probabilities and posterior beliefs

#### What it means

A **prior** is a probability distribution over types before new strategic evidence is observed. A **posterior** is the updated belief after observing a signal or action.

Bayes' rule is:

```text
P(t | x) = P(x | t)P(t) / P(x)
```

where `x` is observed evidence.

#### Why it matters

Expected payoffs and best responses depend on beliefs. Incorrect conditioning is one of the most common errors in Bayesian-game calculations.

#### Example

Suppose 20% of nodes are faulty. A timeout occurs with probability 0.8 for faulty nodes and 0.1 for healthy nodes:

```text
P(Faulty | Timeout)
= (0.8)(0.2) / [(0.8)(0.2) + (0.1)(0.8)]
= 0.16 / 0.24
= 2/3
```

The timeout raises the failure belief from `0.2` to about `0.667`.

#### Common interview angle

State the conditioning event explicitly. A player's relevant belief is usually `P(t_-i | t_i)` rather than an unconditional marginal. If types are correlated, observing one's own type can reveal information about others.

### 3.4 Expected payoff

#### What it means

Expected payoff is probability-weighted utility. For player `i`, type `t_i`, candidate action `a_i`, and opponents' strategies `s_-i`:

```text
EU_i(a_i | t_i, s_-i)
= sum over t_-i of P(t_-i | t_i)
  * u_i(a_i, s_-i(t_-i), t_i, t_-i)
```

If opponents mix, also average over their randomized actions.

#### Why it matters

Players cannot optimize against an unknown state directly. Under expected-utility assumptions, they compare probability-weighted outcomes.

#### Example

If a security action gives payoff `8` against a weak attacker and `-4` against a strong attacker, with probabilities `0.75` and `0.25`:

```text
EU = 0.75(8) + 0.25(-4) = 5
```

#### Common interview angle

Do not average actions or types first and then plug the “average type” into a nonlinear payoff. Evaluate payoff state by state, multiply by probability, and sum.

### 3.5 Bayesian Nash equilibrium

#### What it means

A strategy profile `s*` is a BNE if, for every player `i` and every type `t_i` with positive probability:

```text
s_i*(t_i) belongs to argmax over a_i of
sum over t_-i P(t_-i | t_i)
u_i(a_i, s_-i*(t_-i), t_i, t_-i)
```

No type can improve its expected payoff through a unilateral deviation.

#### Why it matters

BNE is the basic stability concept for simultaneous games with private information. It underlies auctions, mechanism design, signaling analysis, and resource-allocation protocols.

#### Example: threshold decision

A server accepts a job if its private value `v` exceeds expected congestion cost `c`. If accepting yields `v-c` and rejecting yields `0`, its best response is:

```text
Accept if v >= c
Reject if v < c
```

This is a type-dependent threshold strategy, a common form of BNE.

#### Common interview angle

The equilibrium object is a **profile of functions**, not merely an action pair. Verify incentive compatibility for each type, including types that occur with small but positive probability.

### 3.6 Harsanyi transformation

#### What it means

The Harsanyi transformation represents incomplete information by adding an initial chance move that selects types. Players then know whatever the information structure says they know.

#### Why it matters

It allows ordinary strategic reasoning over an expanded game without pretending private information is observable.

#### Example

Nature selects attacker type `Advanced` with probability `0.2` or `Basic` with probability `0.8`. The attacker observes its type; the defender does not. Both then act.

#### Common interview angle

Nature is not strategic and has no payoff. Its probability distribution encodes beliefs.

### 3.7 Common prior and correlated types

#### What it means

A **common prior** means all players' beliefs can be derived by conditioning one shared joint distribution. Types need not be independent.

#### Why it matters

With correlation, learning one's own type changes beliefs about other players. Replacing a joint prior with independent marginals can change the equilibrium.

#### Example

Two services share an upstream traffic shock. If service A observes high local demand, it should raise its belief that service B also has high demand.

#### Common interview angle

Common prior does not mean identical posteriors. Players can receive different information and therefore condition the same prior differently.

### 3.8 Interim and ex ante perspectives

#### What it means

- **Ex ante:** before anyone knows its type.
- **Interim:** after a player knows its own type but not others' types.
- **Ex post:** after all types are known.

#### Why it matters

BNE optimality is normally interim: every realized type optimizes given its conditional belief. Mechanism performance may be evaluated ex ante, while ex-post incentive compatibility is stronger.

#### Example

Before learning whether a job is urgent, a tenant assesses expected allocation quality ex ante. Once it learns urgency, it chooses a bid using interim expected payoff.

#### Common interview angle

Do not confuse high ex-ante average welfare with every type having no profitable interim deviation.

---

## 4. Real-World Example

### First-price auction for cloud capacity

A cloud platform sells one immediate compute slot. Two jobs submit sealed bids. Each job privately knows its value `v_i`; values are independently uniform on `[0, 100]`. The highest bid wins and pays its own bid.

The components are:

| Component | Model |
|---|---|
| Players | Job 1 and Job 2 |
| Type | Private value `v_i` |
| Prior | Each value is uniform on `[0,100]` |
| Action | Bid `b_i >= 0` |
| Winner payoff | `v_i - b_i` |
| Loser payoff | `0` |
| Strategy | A bid function `b_i(v_i)` |

For two risk-neutral symmetric bidders, consider `b(v)=v/2`. If a bidder with value `v` pretends to be type `x` and bids `x/2`, it wins when the opponent value is below `x`, which has probability `x/100`. Expected payoff is:

```text
EU(x; v) = (v - x/2)(x/100)
         = (vx - x²/2)/100
```

Differentiate with respect to `x`:

```text
dEU/dx = (v - x)/100
```

The maximum occurs at `x=v`, so bidding `v/2` is a best response when the opponent uses the same rule. Therefore the symmetric strategy profile is a BNE.

Practical lessons:

- The action is a single bid, but the strategy is a bid for every possible value.
- Bidders shade bids below value because paying less is valuable.
- A higher bid improves win probability but reduces surplus.
- The result depends on the prior, payment rule, bidder count, independence, and risk attitude.

---

## 5. Diagrams / Mental Models

### Information timeline

```text
Ex ante                 Interim                         Ex post
before type draw        own type known                  all relevant facts known
     |                       |                                  |
Nature draws types ---> player chooses s_i(t_i) ---> actions and payoffs realized
```

### Strategy is a contingent plan

```text
Player type          Strategy output
-----------          ---------------
Low value      ----> low bid
Medium value   ----> medium bid
High value     ----> high bid

The whole mapping is chosen as the equilibrium strategy.
```

### Solving checklist

```text
Identify players/actions
        |
Identify private types and observations
        |
Write joint prior and conditional beliefs
        |
Propose type-contingent strategies
        |
Compute each type's expected payoff from every deviation
        |
All types best-respond? -- yes --> Bayesian Nash equilibrium
        |
        no
        v
Revise candidate strategy
```

### Probability tree

```text
                      Opponent type
                    /               \
              Strong (p)         Weak (1-p)
               /    \             /      \
           Attack  Wait       Attack    Wait
              |      |           |        |
          payoff   payoff      payoff   payoff
```

---

## 6. Common Interview Questions

### Q1. What is incomplete information?

**Answer:** A game has incomplete information when some player lacks knowledge of a payoff-relevant characteristic, typically another player's type or payoff function. Types and beliefs model that uncertainty.

**Interviewer expects:** distinction between unknown types and merely unknown simultaneous actions.

**Common mistake:** saying every simultaneous game has incomplete information. Players can know the full payoff matrix while not knowing the action chosen at the same time.

### Q2. What is a player type?

**Answer:** A type is a formal description of a player's privately known, payoff-relevant characteristics. Once the complete type profile is fixed, the model specifies payoffs and feasible decisions.

**Interviewer expects:** examples such as valuation, cost, capability, or risk preference.

**Common mistake:** treating a type as an action or as a vague personality label.

### Q3. What are the components of a Bayesian game?

**Answer:** Players, action sets, type sets, a probability distribution over type profiles, information about what each player observes, and payoff functions depending on actions and types.

**Interviewer expects:** notation such as `(N, A, T, p, u)` and the role of Nature.

**Common mistake:** omitting the prior or information structure.

### Q4. What is a prior probability?

**Answer:** It is the belief over possible types before observing additional evidence. In a common-prior model, each player's conditional beliefs derive from one joint distribution.

**Interviewer expects:** awareness that priors can be joint and correlated.

**Common mistake:** assuming independence without justification.

### Q5. How is a posterior computed?

**Answer:** Use Bayes' rule: multiply the likelihood of the observation under a type by the prior probability of that type, then normalize across all types that could produce the observation.

**Interviewer expects:** `P(t|x) = P(x|t)P(t)/P(x)`.

**Common mistake:** reversing `P(x|t)` and `P(t|x)`.

### Q6. What is expected payoff?

**Answer:** It is the sum of each possible payoff multiplied by the probability of the state or action producing it. In Bayesian games, a type uses conditional beliefs over opponents' types.

**Interviewer expects:** a correct probability-weighted formula.

**Common mistake:** taking an unweighted arithmetic mean.

### Q7. Define Bayesian Nash equilibrium.

**Answer:** It is a profile of type-contingent strategies such that, for every player and every type with positive probability, the prescribed action maximizes expected payoff given beliefs and the opponents' strategies.

**Interviewer expects:** “every type,” “expected payoff,” and “unilateral deviation.”

**Common mistake:** checking one average player instead of each type.

### Q8. How does BNE differ from ordinary Nash equilibrium?

**Answer:** Ordinary Nash equilibrium assumes the game's relevant payoff structure is known. BNE allows private types; strategies map types to actions and optimality is evaluated using beliefs. A Bayesian game can also be converted into an expanded complete-information strategic form over type-contingent plans.

**Interviewer expects:** the change in strategy space and expectation over hidden types.

**Common mistake:** claiming Nash equilibrium contains no uncertainty at all; mixed strategies can still introduce action uncertainty.

### Q9. What is the Harsanyi transformation?

**Answer:** It models incomplete information as an initial chance move in which Nature draws types according to a prior, followed by players observing their permitted information and acting.

**Interviewer expects:** Nature is non-strategic and types make payoffs well-defined.

**Common mistake:** assigning Nature an objective.

### Q10. Why is a Bayesian strategy a function rather than one action?

**Answer:** The player learns its type before acting, so the complete plan must specify an action for every type it might be. Equilibrium compares these full contingent plans.

**Interviewer expects:** `s_i:T_i -> A_i`.

**Common mistake:** listing only the action of the realized type.

### Q11. Can players have different posterior beliefs under a common prior?

**Answer:** Yes. They may receive different private signals or observe different types. Conditioning the same joint prior on different information produces different posteriors.

**Interviewer expects:** common prior is not the same as common information.

**Common mistake:** assuming shared prior implies identical beliefs at every point.

### Q12. How do you verify a candidate BNE?

**Answer:** Fix the opponents' candidate strategies. For each player and each possible type, compute conditional expected payoff for the prescribed action and every feasible deviation. The profile is a BNE only if none gives a strictly higher payoff.

**Interviewer expects:** type-by-type incentive checks.

**Common mistake:** verifying only outcomes that occur on the proposed path.

---

## 7. Deep-Dive Questions

### Q1. What changes when types are correlated?

Observing `t_i` changes player `i`'s belief about `t_-i`, so the correct weight is `P(t_-i | t_i)`, not `P(t_-i)`. Correlation can alter best responses even if each player's marginal type distribution stays unchanged.

### Q2. Does every finite Bayesian game have a BNE?

Yes, if mixed strategies are allowed and players have finite type and action sets. Transform the Bayesian game into an agent-normal-form or strategic-form game whose pure strategies are type-to-action mappings; Nash's existence result then supplies a mixed equilibrium. A pure BNE need not exist.

### Q3. What is the difference between BNE and sequential equilibrium?

BNE requires optimal type-contingent strategies given beliefs at the strategic-form level. Sequential equilibrium additionally requires sequential rationality at every information set and beliefs consistent with strategies, including careful treatment of off-path events. In dynamic games, BNE can permit non-credible future actions.

### Q4. Why can actions reveal private types?

If types have different costs and benefits, they may prefer different actions. Observers infer type from action using Bayes' rule. A **separating** equilibrium uses different actions by type; a **pooling** equilibrium uses the same action and reveals less.

### Q5. What if the prior assigns zero probability to a type or observation?

A zero-probability type does not affect expected payoff under that prior. Bayes' rule cannot determine beliefs after a zero-probability observation because the denominator is zero. Refinements for dynamic games impose additional consistency requirements for such off-path beliefs.

---

## 8. Comparison Tables

### Complete versus incomplete information

| Aspect | Complete information | Incomplete information |
|---|---|---|
| Payoff-relevant facts | Commonly known | Some are private or unknown |
| Basic private variable | None required | Type |
| Strategy | Action/contingent plan | Type-contingent plan |
| Optimization | Payoff against strategies | Expected payoff using beliefs |
| Equilibrium | Nash equilibrium | Bayesian Nash equilibrium |
| Example | Known payoff matrix | Auction with private values |

### Imperfect versus incomplete information

| Aspect | Imperfect information | Incomplete information |
|---|---|---|
| Unknown item | Earlier actions/history | Types/payoff-relevant characteristics |
| Typical example | Player cannot observe a previous move | Bidder does not know rival's valuation |
| Representation | Information sets in extensive form | Types and beliefs |
| Can coexist? | Yes | Yes |

### Prior versus posterior

| Aspect | Prior | Posterior |
|---|---|---|
| Timing | Before new evidence | After evidence |
| Formula role | Starting distribution | Updated conditional distribution |
| Example | 20% of nodes are faulty | 67% fault chance after timeout |
| Common trap | Assuming independence | Forgetting normalization |

### Nash equilibrium versus Bayesian Nash equilibrium

| Aspect | Nash equilibrium | Bayesian Nash equilibrium |
|---|---|---|
| Private types | Not essential | Central |
| Strategy object | Strategy/action plan | Mapping from type to action |
| Payoff comparison | Usually direct | Conditional expected utility |
| Incentive check | Every player | Every type of every player |
| Beliefs | Usually implicit | Explicit prior/posterior |

### Ex ante, interim, and ex post

| View | Information available | Typical question |
|---|---|---|
| Ex ante | No private type realized/known | Is the mechanism good on average? |
| Interim | Own type known | What action should this type choose? |
| Ex post | All types known | Would the action remain optimal after full revelation? |

---

## 9. Common Mistakes

1. **Confusing hidden action with hidden type.** Simultaneous action uncertainty alone does not make the payoff structure incomplete.
2. **Treating a strategy as one action.** A Bayesian pure strategy specifies an action for every possible own type.
3. **Using unconditional probabilities.** With correlated types, use `P(t_-i | t_i)`.
4. **Averaging payoffs without weights.** Expected payoff must use the actual probability distribution.
5. **Checking only one type.** BNE requires a best response for every type with positive probability.
6. **Ignoring how an action changes beliefs.** In signaling settings, observed behavior conveys information.
7. **Assuming common prior means identical posterior.** Different information produces different conditioning.
8. **Using ordinal rankings as cardinal utilities.** Expected-utility arithmetic needs meaningful utility differences.
9. **Forgetting tie rules.** Auction equilibrium can depend on how equal bids are resolved.
10. **Assuming a pure BNE must exist.** Finite games guarantee equilibrium only when mixing is allowed.

---

## 10. Edge Cases / Special Cases

- **Degenerate prior:** If one type has probability `1`, the model effectively reduces to complete information about that type.
- **Zero-probability types:** They do not constrain standard on-support BNE calculations, but may matter in refinements or robustness analysis.
- **Correlated types:** Own type is evidence about others; never multiply marginals automatically.
- **Continuous types:** Replace sums with integrals and often solve for threshold or monotone strategy functions.
- **Mixed strategies by type:** Each type may randomize differently, so the strategy maps a type to a probability distribution over actions.
- **Risk aversion:** Maximizing expected money is not the same as maximizing expected utility of money.
- **Interdependent values:** A player's payoff may depend on others' private information, not only its own value.
- **No common prior:** Players may hold fundamentally incompatible beliefs; standard common-prior Bayesian analysis may not apply directly.
- **Signals and noisy observations:** A posterior must condition on the signal-generation process, not merely on observed behavior.
- **Dynamic games:** BNE may not rule out non-credible continuation behavior; perfect Bayesian or sequential equilibrium may be needed.

---

## 11. How to Explain in Interview

> “An incomplete-information game is one where players do not know all payoff-relevant facts, such as another bidder's valuation. We model each private fact as a type and place a prior over type profiles. A strategy maps each possible own type to an action. Each type chooses the action that maximizes conditional expected payoff given beliefs and the other players' type-contingent strategies. If every type is doing so, the strategy profile is a Bayesian Nash equilibrium.”

---

## 12. Quick Revision Notes

### Key definitions

- **Type:** private payoff-relevant information about a player.
- **Prior:** belief over type profiles before new evidence.
- **Posterior:** belief updated after information using Bayes' rule.
- **Bayesian strategy:** mapping `s_i:T_i -> A_i` or to distributions over actions.
- **Expected payoff:** probability-weighted utility.
- **BNE:** every type's strategy is an expected-payoff best response.

### Important points

- Nature draws types but does not optimize.
- Conditional beliefs matter when types are correlated.
- Verify deviations one player and one type at a time.
- Strategies, not realized actions alone, form the equilibrium.
- Pure BNE may fail to exist; mixed BNE exists in finite games.

### Common comparisons

- Complete information concerns knowledge of payoffs/types; perfect information concerns observation of history.
- Prior is before evidence; posterior is after conditioning.
- Nash uses known game structure; BNE explicitly includes private types and beliefs.

### Must-remember facts

```text
EU_i(a_i | t_i) = sum P(t_-i | t_i)u_i(a_i, s_-i(t_-i), t)
```

```text
BNE = no profitable unilateral deviation for any player type
```

### Interview traps

- Do not say “probability of an action” when the question asks for a prior over types.
- Do not forget to normalize a posterior.
- Do not substitute expected type into a nonlinear payoff.
- Do not verify only the most likely type.

---

## 13. Practice Tasks

1. **Type-to-strategy enumeration:** Two types and two actions give four pure strategies. List them explicitly.
2. **Posterior calculation:** Start with a 10% malicious-node prior and two signal likelihoods; compute the posterior after an alert.
3. **Expected payoff table:** For two defender actions and two attacker types, calculate each action's expected payoff as a function of prior `p`.
4. **Threshold derivation:** Find the value of `p` at which the defender switches from monitoring to blocking.
5. **BNE verification:** Given candidate strategies for high- and low-cost sellers, check every type's deviations.
6. **Auction derivation:** Re-derive `b(v)=v/2` for two uniform first-price bidders.
7. **Simulation:** Write a short C++ or Python program that samples bidder values, applies `b(v)=v/2`, and estimates average utility.
8. **Correlation exercise:** Construct a joint type table where seeing your own high demand raises the chance the other service has high demand.
9. **Information comparison:** Convert a complete-information matrix into a Bayesian game by making one payoff parameter private.
10. **Interview drill:** Explain why `s_i(t_i)` is a function in under 30 seconds.

---

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Incomplete information means some payoff-relevant fact is unknown to at least one player. |
| Type | Formal package of a player's private information. |
| Bayesian game | Players + actions + types + prior + information + payoffs. |
| Prior | Distribution over type profiles before evidence. |
| Expected payoff | Sum/integral of payoff weighted by conditional probabilities. |
| BNE | Every type of every player best-responds in expected utility. |
| Main comparison | Nash: known payoff structure; BNE: private types and beliefs. |
| Most asked question | How do you verify BNE? Check every type's expected payoff against every unilateral deviation. |
| Biggest trap | Treating a Bayesian strategy as one realized action. |
| One-line answer | “BNE is Nash equilibrium adapted to private types: each type chooses an expected-payoff best response given beliefs.” |

