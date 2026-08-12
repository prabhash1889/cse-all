# Beliefs

## 1. Overview

### Definition

In an extensive-form game with incomplete information, a **belief** is a probability distribution over the decision nodes inside an information set. It represents what a player thinks has happened before that player moves. If a receiver observes a signal `m` but not the sender's type `t`, the receiver's belief is commonly written `mu(t | m)`.

### Why it matters

An action can be rational only relative to some view of the hidden history. Beliefs connect incomplete information to optimal decisions and prevent an equilibrium analysis from saying only what happens on the equilibrium path while ignoring what a rational player would do after an unexpected signal.

### Where it is used in real systems

- Security systems infer whether a request is benign or malicious from observable behavior.
- Hiring platforms infer candidate quality from credentials and work samples.
- Online marketplaces infer seller quality from warranties, prices, and reviews.
- Distributed services infer whether a silent peer is slow, partitioned, or failed.
- Auctions infer private valuations from bids.

### Why interviewers ask about it

Beliefs test whether a candidate can separate **unknown state**, **observable action**, and **posterior probability**, and then use the posterior to justify a decision.

## 2. Core Idea

### Intuition and analogy

A belief is not a guess chosen after seeing the desired answer. It is the player's information-state. Think of a spam filter: before reading an email it has a prior probability of spam; after seeing a suspicious link it updates that probability and chooses whether to quarantine the message.

### Small example

A developer is either strong (`H`) with prior probability `0.6` or weak (`L`) with probability `0.4`. The developer sends a portfolio (`P`) or does not (`N`). A recruiter observes the action but not the type. After `P`, the recruiter's belief is

`mu(H | P) = Pr(H | P)`.

If both types always choose `P`, observing `P` reveals nothing and `mu(H | P)=0.6`. If only strong developers choose `P`, then `mu(H | P)=1`.

### Step-by-step

1. Nature selects a hidden type using the prior.
2. The informed player observes the type and acts.
3. The uninformed player observes a signal, not the type.
4. The signal and equilibrium strategy determine a posterior belief.
5. The receiver chooses a best response to that posterior.
6. For an off-path signal, Bayes' rule may not determine a posterior; the equilibrium concept specifies what consistency is still required.

## 3. Important Subtopics

### 3.1 Priors and posteriors

- **Meaning:** A prior is the probability before observing a signal; a posterior is the updated probability afterward.
- **Why it matters:** Confusing them makes receiver behavior impossible to justify.
- **Example:** `Pr(H)=0.6`, but a costly certification may produce `Pr(H | Certified)=0.9`.
- **Interview angle:** State both the conditioning event and whose information is being modeled.

### 3.2 Information sets

- **Meaning:** An information set groups nodes a player cannot distinguish when acting.
- **Why it matters:** One action and one belief distribution apply to the whole set.
- **Example:** A recruiter sees `P` but cannot distinguish whether `H` or `L` sent it.
- **Interview angle:** Beliefs are over nodes or types consistent with the observed history, not over arbitrary future actions.

### 3.3 On-path and off-path beliefs

- **Meaning:** An information set is on path if reached with positive probability under the strategy profile; otherwise it is off path.
- **Why it matters:** Bayes' rule pins down on-path beliefs, but cannot condition on a zero-probability event.
- **Example:** If neither type chooses `N`, `mu(H | N)` is off path.
- **Interview angle:** PBE still requires sequentially rational behavior after `N`, based on a specified off-path belief.

### 3.4 Consistency

- **Meaning:** Beliefs must be derived from the prior and strategies wherever Bayes' rule applies.
- **Why it matters:** Otherwise any receiver action could be rationalized using invented probabilities.
- **Example:** If `H` sends `P` with probability 1 and `L` with probability `1/2`, then `mu(H|P)=0.6/(0.6+0.4/2)=0.75`.
- **Interview angle:** Write the numerator and denominator explicitly.

## 4. Real-World Example

Consider an API gateway classifying a request as legitimate (`L`) or attack (`A`). The gateway starts with `Pr(A)=0.02`. A request may present a valid but unusual token pattern. Historical strategies imply `Pr(pattern|A)=0.7` and `Pr(pattern|L)=0.01`. The posterior is

`Pr(A|pattern) = 0.7(0.02) / [0.7(0.02)+0.01(0.98)] approx 0.588`.

The gateway should block only if the expected cost of allowing the request exceeds the false-positive cost. The game-theory lesson is that the signal does not directly dictate the action; it changes a belief, and the belief changes expected payoffs.

## 5. Diagrams / Mental Models

```text
Nature chooses type -> Sender observes type -> Sender emits signal
                                               |
                                               v
Receiver observes signal -> updates belief -> chooses best response
```

| Object | Known by | Example |
|---|---|---|
| Prior `Pr(t)` | Both players | `Pr(H)=0.6` |
| Type `t` | Sender | Strong developer |
| Signal `m` | Receiver observes it | Portfolio |
| Posterior `mu(t|m)` | Receiver computes it | `Pr(H|P)=0.75` |

## 6. Common Interview Questions

1. **What is a belief in an extensive-form game?** A probability distribution over nodes in an information set. **Expected:** connect it to hidden history. **Mistake:** calling it a mixed strategy.
2. **What is the difference between a prior and posterior?** The prior precedes a signal; the posterior conditions on it. **Expected:** conditional notation. **Mistake:** treating the posterior as fixed.
3. **Where are beliefs needed?** At information sets where the acting player is uncertain which node was reached. **Expected:** player-specific information. **Mistake:** assigning beliefs at singleton sets unnecessarily.
4. **What is an on-path belief?** A belief at an information set reached with positive equilibrium probability. **Expected:** Bayes consistency. **Mistake:** equating on path with desirable.
5. **What is an off-path belief?** A belief after a zero-probability equilibrium history. **Expected:** Bayes may not pin it down. **Mistake:** saying no action is required there.
6. **Can beliefs be arbitrary in a PBE?** Only off path, subject to probability and any additional consistency imposed by the model; on path they follow Bayes. **Expected:** qualify the claim. **Mistake:** saying all beliefs are arbitrary.
7. **Do beliefs describe uncertainty about future actions?** Usually they describe the hidden node or type at the current information set; strategies describe actions. **Expected:** separate beliefs from strategies. **Mistake:** merging both objects.
8. **When does a signal reveal a type?** When equilibrium strategies make that signal possible for only that type. **Expected:** posterior becomes one. **Mistake:** assuming costly signals always reveal type.
9. **Why must beliefs be written with conditioning events?** Because the same type can have different posterior probabilities after different signals. **Expected:** `mu(t|m)`. **Mistake:** using one posterior globally.
10. **How do beliefs affect receiver action?** The receiver maximizes expected payoff using the posterior-weighted payoff of each action. **Expected:** show an expectation. **Mistake:** best-responding to the most likely type only.

## 7. Deep-Dive Questions

1. **Why can zero-probability conditioning not use ordinary Bayes' rule?** Its denominator is zero, so no conditional distribution is defined. Refinements such as sequential equilibrium obtain beliefs as limits of completely mixed strategies.
2. **Can two PBEs share strategies but have different beliefs?** Yes, particularly at unreached information sets; different beliefs may support the same sequentially rational off-path action.
3. **How do continuous types change beliefs?** Replace probability masses with densities and sums with integrals; use Bayes' density formula where the signal has positive density.
4. **Can beliefs assign probability to an impossible node?** They must have support only on nodes within the information set and respect known zero-probability events when consistency requires it.
5. **Why are beliefs part of the equilibrium object?** Strategies alone cannot evaluate optimality at an information set whose exact node is unknown.

## 8. Comparison Tables

| Feature | Prior | Posterior |
|---|---|---|
| Timing | Before signal | After signal |
| Notation | `Pr(t)` | `Pr(t|m)` |
| Inputs | Type distribution | Prior plus strategies/likelihoods |
| Role | Initial uncertainty | Expected-payoff calculation after observation |

| Feature | On-path belief | Off-path belief |
|---|---|---|
| Reach probability | Positive | Zero |
| Bayes' rule | Required | Usually undefined directly |
| Freedom | Pinned down by strategies | May support multiple PBEs |

## 9. Common Mistakes

- Treating a belief as the true type rather than uncertainty about it.
- Updating from payoffs instead of signal likelihoods.
- Forgetting the prior in Bayes' numerator.
- Checking beliefs only along the equilibrium path.
- Choosing a receiver response to the most likely type instead of expected payoff.
- Assigning probabilities that do not sum to one within an information set.

## 10. Edge Cases / Special Cases

- A singleton information set has a degenerate belief of one on its only node.
- A signal used with zero probability creates an off-path information set.
- If both types use the same signal with equal probability, the posterior equals the prior.
- If a signal is impossible for one type and possible for another, the posterior is degenerate.
- With more than two types, beliefs form a probability vector, not one scalar.

## 11. How to Explain in Interview

> A belief is a player's probability distribution over the hidden histories consistent with what the player observes. In PBE, on-path beliefs come from Bayes' rule, and actions must maximize expected payoff given those beliefs, including after off-path histories.

## 12. Quick Revision Notes

- Prior: uncertainty before observation.
- Posterior: prior updated after a signal.
- Beliefs live at information sets.
- On path: derive with Bayes' rule.
- Off path: specify a belief and verify optimality.
- Trap: a posterior is not the same thing as a strategy.

## 13. Practice Tasks

1. Compute `Pr(H|P)` for priors `(0.7,0.3)` when `H` sends `P` with probability `0.8` and `L` with probability `0.2`.
2. Draw a two-type signaling tree and label every information set and belief.
3. Find the receiver's action threshold when accepting `H` pays `3`, accepting `L` pays `-2`, and rejecting pays `0`.
4. Construct two different off-path beliefs that support different receiver responses.
5. Implement a short Python or C++ function that normalizes `prior[type] * likelihood[signal|type]`.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Probability distribution over nodes/types at an information set |
| Why it matters | Converts hidden history into expected-payoff decisions |
| Most asked | Prior vs posterior; on path vs off path; Bayes update |
| Main comparison | Belief describes uncertainty; strategy describes behavior |
| One-line answer | Beliefs say what a player thinks happened, conditional on what the player observed. |

---

---

# Sequential Rationality

## 1. Overview

### Definition

A strategy is **sequentially rational** if it maximizes a player's expected payoff at every information set, given the player's beliefs and the other players' strategies. The requirement applies whether or not the information set is reached in equilibrium.

### Why it matters

Nash equilibrium can rely on empty threats: an announced response that would be irrational if the relevant history actually occurred. Sequential rationality removes such threats by checking continuation behavior everywhere.

### Real-system use and interview relevance

It appears in incident response, security deterrence, negotiation protocols, reputation systems, and any staged interaction. Interviewers use it to test backward reasoning, expected payoff, credible commitments, and the distinction between simultaneous and sequential games.

## 2. Core Idea

### Intuition and analogy

A service owner says, "If any client exceeds quota once, I will permanently shut down the service." That threat might discourage excess use, but after one client violates the quota, permanent shutdown harms the owner too. The threat is not sequentially rational and should not support a credible equilibrium.

### Small example and steps

An entrant chooses `Enter` or `Stay Out`. If entry occurs, an incumbent chooses `Fight` or `Accommodate`.

| Outcome | Entrant payoff | Incumbent payoff |
|---|---:|---:|
| Stay Out | 0 | 3 |
| Enter, Fight | -1 | -1 |
| Enter, Accommodate | 2 | 1 |

1. At the incumbent's information set, `Accommodate` gives `1` and `Fight` gives `-1`.
2. Sequential rationality therefore requires `Accommodate` after entry.
3. Anticipating that response, the entrant chooses `Enter` because `2 > 0`.
4. A Nash profile `(Stay Out, Fight after entry)` may deter entry, but its threat is not credible and it is not sequentially rational.

## 3. Important Subtopics

### 3.1 Continuation strategies

- **Meaning:** The actions planned from an information set onward.
- **Why:** Optimality is checked in the remaining subgame or continuation problem.
- **Example:** After an intrusion alert, quarantine versus ignore.
- **Interview angle:** Compare continuation payoffs, not sunk payoffs.

### 3.2 Credible threats and promises

- **Meaning:** A threatened or promised action is credible only if optimal when execution time arrives.
- **Why:** Strategic announcements alone do not change incentives.
- **Example:** A seller's promise to refund is credible when an escrow contract enforces it.
- **Interview angle:** Commitment devices can alter the game and make an otherwise irrational response credible.

### 3.3 Expected utility at an information set

- **Meaning:** When a player cannot distinguish nodes, compare actions using belief-weighted payoffs across those nodes.
- **Why:** Node-by-node maximization may prescribe incompatible actions at one information set.
- **Example:** With belief `p` of a high type, accept if `p*u(A,H)+(1-p)*u(A,L)` exceeds rejection payoff.
- **Interview angle:** Derive the cutoff belief.

### 3.4 Relationship to backward induction

- **Meaning:** Backward induction solves finite perfect-information games from terminal nodes backward.
- **Why:** Sequential rationality generalizes the same logic to imperfect information using beliefs.
- **Example:** At a multi-node information set, optimize expected rather than node-specific payoff.
- **Interview angle:** Backward induction alone is insufficient when nodes are indistinguishable.

## 4. Real-World Example

A distributed database threatens to blacklist any replica that misses one heartbeat. If network partitions are common, blacklisting a healthy replica reduces availability and is irrational after the alert. A credible policy instead compares the posterior failure probability and costs of quarantine versus continued service. Sequential rationality forces the policy to remain optimal when the alert actually occurs, not merely to sound deterrent in advance.

## 5. Diagrams / Mental Models

```text
For every information set I:
beliefs at I + opponents' continuation strategies
                       |
                       v
expected payoff of each available action
                       |
                       v
choose a maximizing action (including when Pr(I)=0)
```

## 6. Common Interview Questions

1. **Define sequential rationality.** Optimality at every information set given beliefs and continuation strategies. **Expected:** include off path. **Mistake:** checking only the initial node.
2. **How is it stronger than Nash optimality?** Nash checks complete-strategy deviations ex ante; sequential rationality rules out irrational continuation actions. **Expected:** empty threats. **Mistake:** saying every Nash equilibrium is sequentially rational.
3. **Why inspect off-path histories?** An unexpected move can occur, and a complete credible strategy must prescribe an optimal response. **Expected:** local continuation reasoning. **Mistake:** ignoring zero-probability nodes.
4. **What makes a threat credible?** Carrying it out is optimal when its decision point is reached, or a commitment changes the payoff/action set. **Expected:** incentives at execution. **Mistake:** credibility from repetition alone.
5. **How are beliefs used?** They weight continuation payoffs across indistinguishable nodes. **Expected:** expected utility. **Mistake:** optimize separately at each node in one information set.
6. **Is every subgame-perfect equilibrium sequentially rational?** In perfect-information finite games, yes in the relevant sense; with imperfect information, beliefs are additionally needed. **Expected:** qualification. **Mistake:** treating SPE and PBE as identical universally.
7. **Can multiple actions be sequentially rational?** Yes, when they tie in expected payoff; mixing among best responses is also rational. **Expected:** indifference. **Mistake:** demanding uniqueness.
8. **Are past costs included?** Sunk past payoffs do not change which continuation action maximizes remaining total payoff. **Expected:** compare outcomes correctly. **Mistake:** sunk-cost reasoning.
9. **How do you verify it?** At each information set, calculate expected continuation payoff for every action and confirm positive-probability actions maximize it. **Expected:** exhaustive check. **Mistake:** inspect equilibrium path only.
10. **Can commitment make an irrational threat rational?** A real commitment changes feasible actions or payoffs, so the resulting game's prescribed response can be rational. **Expected:** game changes. **Mistake:** treating cheap talk as commitment.

## 7. Deep-Dive Questions

1. **Why is local optimality enough?** With perfect recall, the one-shot deviation principle often lets us verify no profitable single information-set deviation instead of all complete strategies.
2. **What if a player forgets earlier information?** Imperfect recall can invalidate standard behavioral-strategy and one-shot-deviation arguments.
3. **How does sequential rationality handle mixing?** Every action in the support must yield the same maximal expected payoff; unused actions cannot yield more.
4. **Can sequential rationality determine beliefs?** No. It restricts optimal actions given beliefs; consistency or Bayes' rule restricts beliefs given strategies.
5. **Why can PBE still allow implausible outcomes?** Weak restrictions on off-path beliefs can rationalize responses that stronger refinements eliminate.

## 8. Comparison Tables

| Feature | Nash rationality | Sequential rationality |
|---|---|---|
| Evaluation point | Start of game | Every information set |
| Off-path behavior | May be irrational | Must be optimal given beliefs |
| Empty threats | May survive | Ruled out |
| Beliefs | Not generally explicit | Essential under imperfect information |

| Feature | Backward induction | Sequential rationality |
|---|---|---|
| Information | Perfect information | Can handle imperfect information |
| Calculation | Node-by-node | Information-set expected utility |

## 9. Common Mistakes

- Calling an action rational merely because it supports a favorable earlier move.
- Ignoring off-path information sets.
- Comparing payoffs before rather than after the relevant history.
- Forgetting that mixed support actions must tie.
- Treating a statement as a binding commitment.

## 10. Edge Cases / Special Cases

- Ties allow several sequentially rational actions.
- At an off-path information set, optimality depends on the specified belief.
- With perfect information, beliefs are degenerate and backward induction usually suffices.
- Infinite-horizon games may require discounting and careful continuation values.
- Imperfect recall needs special treatment.

## 11. How to Explain in Interview

> Sequential rationality means every planned action remains a best response when its information set is reached, using the player's belief there. It eliminates non-credible threats because even off-path continuation actions must be optimal.

## 12. Quick Revision Notes

- Check every information set.
- Use continuation, not sunk, payoffs.
- At uncertain nodes, maximize belief-weighted payoff.
- Off-path actions matter.
- Commitment can change credibility by changing the game.
- Trap: Nash equilibrium alone may contain empty threats.

## 13. Practice Tasks

1. Solve the entry-deterrence game above by backward induction.
2. Add a binding cost of `3` for accommodating and recompute the equilibrium.
3. Derive an accept/reject cutoff for an arbitrary belief `p`.
4. Find an empty threat in a three-stage game of your own design.
5. Verify sequential rationality for every information set in a small signaling tree.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Best response at every information set |
| Why it matters | Removes empty threats and irrational continuations |
| Most asked | Nash vs sequential rationality; credibility; off-path actions |
| Main comparison | Backward induction is the perfect-information special case |
| One-line answer | A strategy is sequentially rational when you would still want to follow it whenever the decision point arrives. |

---

---

# Bayes' Rule

## 1. Overview

### Definition

Bayes' rule updates the probability of a hidden type after observing a signal:

`Pr(t|m) = Pr(m|t)Pr(t) / sum_t' Pr(m|t')Pr(t')`.

In signaling games, the likelihood `Pr(m|t)` comes from the sender's strategy.

### Why it matters, use, and interview relevance

Bayes' rule makes beliefs consistent with actual behavior. It is used in fraud detection, diagnosis, filtering, reliability, bidding, and reputation. Interviewers ask it because it combines conditional probability with strategic reasoning: the likelihood is endogenous because a rational sender chooses signals.

## 2. Core Idea

### Intuition and analogy

Reverse the direction of inference. You may know how likely each type is to generate a signal and want to infer how likely a type is after seeing it. A rare type can still have a high posterior if it produces the observation much more frequently.

### Small example and steps

Suppose `Pr(H)=0.3`, `Pr(L)=0.7`, `Pr(C|H)=0.8`, and `Pr(C|L)=0.2`.

1. Joint mass for high type and certification: `0.3*0.8=0.24`.
2. Joint mass for low type and certification: `0.7*0.2=0.14`.
3. Total probability of certification: `0.24+0.14=0.38`.
4. Posterior: `Pr(H|C)=0.24/0.38=12/19 approx 0.632`.

Certification raises the high-type probability from `0.3` to about `0.632`, but does not prove the type is high.

## 3. Important Subtopics

### 3.1 Likelihood versus posterior

- **Meaning:** `Pr(m|t)` is likelihood; `Pr(t|m)` is posterior.
- **Why:** Reversing them is the base-rate fallacy.
- **Example:** Most attacks trigger an alert does not mean most alerts are attacks.
- **Interview angle:** Write the complete fraction.

### 3.2 Total probability denominator

- **Meaning:** The denominator sums all mutually exclusive ways to observe `m`.
- **Why:** It normalizes posterior probabilities to one.
- **Example:** `Pr(C)=Pr(C|H)Pr(H)+Pr(C|L)Pr(L)`.
- **Interview angle:** Include every possible type.

### 3.3 Strategy-induced likelihoods

- **Meaning:** In a signaling game, sender mixing probabilities are signal likelihoods.
- **Why:** Beliefs and strategies must agree.
- **Example:** If type `H` sends `m` with probability `x`, then `Pr(m|H)=x`.
- **Interview angle:** Substitute equilibrium mixing probabilities into Bayes' rule.

### 3.4 Odds form

- **Meaning:** Posterior odds equal prior odds times likelihood ratio.
- **Why:** It exposes how diagnostic a signal is.
- **Example:** `posterior odds(H:L) = prior odds(H:L) * Pr(m|H)/Pr(m|L)`.
- **Interview angle:** Useful for repeated independent signals.

## 4. Real-World Example

A backend fraud detector starts with a `0.1%` fraud base rate. A rule fires on `90%` of fraudulent transactions and `2%` of legitimate ones. Then

`Pr(F|alert)=0.9(0.001)/[0.9(0.001)+0.02(0.999)] approx 0.0431`.

Despite high sensitivity, only about `4.3%` of alerts are fraud because legitimate traffic dominates. A rational blocking decision must combine this posterior with false-positive and false-negative costs.

## 5. Diagrams / Mental Models

```text
unnormalized posterior weight(type)
    = prior(type) * probability(type sends observed signal)

posterior(type) = weight(type) / sum(all type weights)
```

| Type | Prior | `Pr(C|type)` | Joint weight | Posterior after `C` |
|---|---:|---:|---:|---:|
| H | 0.30 | 0.80 | 0.24 | 0.632 |
| L | 0.70 | 0.20 | 0.14 | 0.368 |

## 6. Common Interview Questions

1. **State Bayes' rule.** `Pr(A|B)=Pr(B|A)Pr(A)/Pr(B)`. **Expected:** define denominator. **Mistake:** swapping conditional directions.
2. **How is `Pr(B)` computed?** Sum `Pr(B|A_i)Pr(A_i)` over a partition. **Expected:** all types. **Mistake:** omit base rates.
3. **What is the base-rate fallacy?** Ignoring priors when interpreting evidence. **Expected:** false-positive example. **Mistake:** blaming only test accuracy.
4. **How does a sender strategy enter Bayes' rule?** It supplies `Pr(m|t)`. **Expected:** connect mixing to likelihood. **Mistake:** treat likelihood as exogenous.
5. **When is Bayes' rule undefined?** When the conditioning event has probability zero. **Expected:** off-path signal. **Mistake:** divide anyway.
6. **Does an informative signal guarantee posterior one?** No; unless other types send it with zero probability. **Expected:** likelihood ratios. **Mistake:** equate evidence with proof.
7. **What if all types send a signal equally often?** Posterior equals prior. **Expected:** signal is uninformative. **Mistake:** assume observation always updates.
8. **What is a likelihood ratio?** `Pr(m|H)/Pr(m|L)`; above one shifts odds toward `H`. **Expected:** odds update. **Mistake:** confuse with posterior ratio alone.
9. **How do you update with multiple independent signals?** Multiply likelihood ratios, conditional on independence given type. **Expected:** state assumption. **Mistake:** assume unconditional independence is enough.
10. **Why is Bayes' rule part of PBE?** It makes on-path beliefs consistent with strategies and priors. **Expected:** beliefs plus sequential rationality. **Mistake:** claim Bayes alone defines PBE.

## 7. Deep-Dive Questions

1. **How do mixed strategies generate posteriors?** If type probabilities are `pi_t` and signal probabilities are `sigma_t(m)`, then `mu(t|m)=pi_t sigma_t(m)/sum_s pi_s sigma_s(m)`.
2. **What happens under a continuum of types?** Use prior and likelihood densities and normalize with an integral.
3. **Why can very accurate tests have low positive predictive value?** A very small prior can be outweighed by false positives from a huge negative population.
4. **How do correlated signals affect repeated updates?** Their joint conditional likelihood must be used; multiplying marginal likelihoods double-counts evidence.
5. **How do refinements handle off-path Bayes updates?** Sequential equilibrium considers limits of fully mixed strategies, yielding beliefs from vanishing trembles.

## 8. Comparison Tables

| Quantity | Meaning | Common error |
|---|---|---|
| `Pr(t)` | Prior | Ignore it |
| `Pr(m|t)` | Likelihood | Call it posterior |
| `Pr(t,m)` | Joint probability | Forget multiplication by prior |
| `Pr(t|m)` | Posterior | Reverse conditional |

| Rule | Use |
|---|---|
| Bayes' rule | Reverse a conditional probability |
| Total probability | Compute evidence/denominator |
| Odds form | Combine likelihood ratios cleanly |

## 9. Common Mistakes

- Dropping the prior.
- Using `Pr(t|m)=Pr(m|t)`.
- Normalizing over signals instead of types.
- Omitting a possible type from the denominator.
- Applying ordinary Bayes conditioning to an off-path event.
- Rounding too early near an action threshold.

## 10. Edge Cases / Special Cases

- Zero likelihood for every type makes the observed event off path.
- Zero prior types remain zero posterior under ordinary Bayesian updating.
- Equal likelihoods leave beliefs unchanged.
- A zero likelihood for all but one positive-prior type gives posterior one.
- Continuous signals require densities; a point may have probability zero while still having a well-defined conditional density treatment.

## 11. How to Explain in Interview

> Bayes' rule updates a type's prior probability by multiplying it by how likely that type was to generate the observed signal, then normalizing across all types. In signaling games, those likelihoods come from the sender's equilibrium strategy.

## 12. Quick Revision Notes

- Posterior is proportional to prior times likelihood.
- Denominator is total evidence probability.
- Sender strategy supplies likelihood.
- On-path beliefs must use Bayes.
- Off-path zero-denominator cases need separately specified beliefs.
- Trap: `Pr(A|B)` is generally not `Pr(B|A)`.

## 13. Practice Tasks

1. Recompute the certification example for prior `Pr(H)=0.1`.
2. Derive the posterior symbolically using type-specific mixing probabilities `x` and `y`.
3. Calculate fraud posterior for three risk classes.
4. Find the likelihood ratio required to raise prior `0.1` to posterior `0.8`.
5. Write a numerically stable log-odds updater for repeated signals.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | `posterior = prior * likelihood / evidence` |
| Why it matters | Makes beliefs consistent with observed strategic behavior |
| Most asked | Base rates; denominator; mixed-strategy likelihoods |
| Main comparison | Likelihood predicts signal from type; posterior infers type from signal |
| One-line answer | Multiply each type's prior by its chance of sending the observed signal, then normalize. |

---

---

# Signaling Games

## 1. Overview

A **signaling game** is a dynamic Bayesian game in which Nature chooses a sender's private type, the sender observes it and sends a signal, and a receiver observes the signal before acting. Signals matter because different types may face different signaling costs. These games model credentials, warranties, prices, security behavior, and protocol messages. Interviewers ask them to test game trees, conditional probability, incentive constraints, and credible off-path responses.

## 2. Core Idea

Imagine strong and weak job candidates choosing whether to earn a certificate. The recruiter sees certification, not productivity. A certificate can communicate quality only when the strong type is more willing to obtain it.

```text
Nature: H with p, L with 1-p
   H -> sender chooses C or N --\
                                  > receiver observes C/N -> Hire/Reject
   L -> sender chooses C or N --/
```

To solve the game: propose type-contingent signals; compute on-path beliefs; find the receiver's best response after every signal; verify each type prefers its assigned signal; then specify and check off-path beliefs.

## 3. Important Subtopics

### 3.1 Types and priors

- **Meaning:** Nature draws private information before play.
- **Importance:** Type changes payoffs or signaling cost.
- **Example:** Product quality is high with probability `p`.
- **Interview angle:** Write the common prior before solving.

### 3.2 Signals versus actions

- **Meaning:** The informed sender signals; the receiver subsequently acts.
- **Importance:** A signal can be costly yet need not directly change productive output.
- **Example:** Warranty length signals reliability; purchase is receiver action.
- **Interview angle:** Do not call every observed choice credible information.

### 3.3 Incentive compatibility

- **Meaning:** Each type must prefer the signal prescribed to it, given receiver responses.
- **Importance:** A proposed pattern is not equilibrium merely because it reveals types.
- **Example:** For separation, require `U_H(C,a_C)>=U_H(N,a_N)` and `U_L(N,a_N)>=U_L(C,a_C)`.
- **Interview angle:** Write one inequality per type.

### 3.4 Receiver thresholds

- **Meaning:** The receiver's best action often changes at a posterior cutoff.
- **Importance:** This turns a complex tree into a simple belief condition.
- **Example:** Hire when `mu*w_H+(1-mu)*w_L >= 0`.
- **Interview angle:** Derive rather than guess the cutoff.

## 4. Real-World Example

A cloud vendor offers a long service-level guarantee. Reliable vendors expect few payouts, so the warranty is cheap; unreliable vendors expect many payouts, so it is costly. Buyers update reliability beliefs after observing warranty length. The warranty conveys information only if the induced price and expected claims make the two types choose differently or mix in a stable way.

## 5. Diagrams / Mental Models

| Stage | Actor | Knows | Chooses |
|---|---|---|---|
| 1 | Nature | Prior | Sender type |
| 2 | Sender | Own type | Signal |
| 3 | Receiver | Signal, not type | Action |
| 4 | Both | Outcome | Receive payoffs |

Mental model: **strategy -> likelihood -> posterior -> receiver response -> sender incentives**.

## 6. Common Interview Questions

1. **What defines a signaling game?** Informed sender moves before an uninformed receiver. **Expected:** Nature, type, signal, action. **Mistake:** omit private type.
2. **What is a sender strategy?** A signal choice for every sender type. **Expected:** type-contingent plan. **Mistake:** name one signal only.
3. **What is a receiver strategy?** An action after every possible signal. **Expected:** include off path. **Mistake:** give only observed equilibrium response.
4. **When is a signal informative?** When signal probabilities differ by type. **Expected:** posterior differs from prior. **Mistake:** equate cost with informativeness automatically.
5. **What is incentive compatibility?** No type profits by imitating another prescribed signal. **Expected:** inequalities. **Mistake:** check receiver only.
6. **How do you solve a signaling game?** Guess a pattern, update beliefs, best-respond, verify sender deviations and off-path behavior. **Expected:** complete loop. **Mistake:** stop after Bayes.
7. **Why can cost create credibility?** If costs differ by type, imitation may be unprofitable. **Expected:** single-crossing intuition. **Mistake:** any positive cost suffices.
8. **Can cheap talk signal information?** Sometimes, when preferences allow informative communication; not when all types share the same incentive to misreport. **Expected:** incentive dependence. **Mistake:** always useless.
9. **What is an off-path signal?** One sent with zero equilibrium probability. **Expected:** belief and response still specified. **Mistake:** ignore it.
10. **Can signaling be socially wasteful?** Yes; costly education or advertising can separate types without raising intrinsic quality. **Expected:** private versus social value. **Mistake:** assume signals create productivity.

## 7. Deep-Dive Questions

1. **What is single crossing?** The marginal cost or benefit of signaling varies monotonically by type, making ordered separation possible.
2. **How can a continuum of types separate?** The signal schedule must satisfy local incentive compatibility and appropriate boundary conditions.
3. **What is the intuitive criterion?** It restricts off-path beliefs when only certain types could plausibly benefit from a deviation.
4. **Can the receiver mix?** Yes, at a posterior making the receiver indifferent; this often supports semi-separation.
5. **How is signaling different from screening?** In signaling the informed side moves first; in screening the uninformed side offers a menu.

## 8. Comparison Tables

| Feature | Signaling | Screening |
|---|---|---|
| First strategic mover | Informed party | Uninformed party |
| Typical instrument | Credential/warranty | Contract/menu |
| Goal | Reveal or conceal type | Induce self-selection |

| Outcome | Signal use by types | Information revealed |
|---|---|---|
| Pooling | Same signal | None on path |
| Separating | Different signals | Full |
| Semi-separating | At least one mixes | Partial |

## 9. Common Mistakes

- Leaving receiver actions unspecified after an unused signal.
- Checking only one type's deviation.
- Updating beliefs before stating strategies.
- Assuming a costly signal is automatically separating.
- Confusing productive investment with pure signaling.

## 10. Edge Cases / Special Cases

Signals may be free, productive, noisy, continuous, or unavailable to some types. Ties permit mixing. Multiple PBEs may coexist because off-path beliefs differ. A signal observed with positive probability only from one type yields a degenerate posterior.

## 11. How to Explain in Interview

> A signaling game has an informed sender and an uninformed receiver. The sender's type affects its signal incentives; the receiver updates beliefs after the signal and best-responds. Equilibrium requires Bayes-consistent beliefs, receiver optimality, and no profitable imitation by any type.

## 12. Quick Revision Notes

- Nature -> type -> signal -> belief -> response.
- Sender strategy is type-contingent.
- Receiver strategy covers every signal.
- Verify Bayes, receiver best responses, sender IC, and off-path behavior.
- Trap: proposed revelation without IC is not equilibrium.

## 13. Practice Tasks

1. Draw a two-type, two-signal, two-action game.
2. Derive the receiver's posterior cutoff for hiring.
3. Write both separation incentive inequalities.
4. Change signal costs and identify when separation fails.
5. Enumerate pooling, separating, and semi-separating candidates.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Private type sends observable signal before receiver acts |
| Why it matters | Models strategic information transmission |
| Most asked | Beliefs, IC constraints, pooling vs separating |
| Comparison | Signaling: informed first; screening: uninformed first |
| One-line answer | Signals reveal type only when equilibrium incentives make different types use them differently. |

---

---

# Pooling Equilibrium

## 1. Overview

A **pooling equilibrium** is a signaling equilibrium in which all sender types choose the same signal. The receiver cannot distinguish types from the on-path signal, so its posterior there equals the prior when all types pool with probability one. Pooling explains uninformative credentials, standardized messages, and markets where quality remains hidden. Interviewers ask it because off-path beliefs are central.

## 2. Core Idea

Suppose both high- and low-quality sellers choose no warranty. Observing no warranty gives the buyer no new type information: `mu(H|N)=p`. The buyer best-responds to average quality. To support pooling, neither type may gain by deviating to warranty, given the buyer's off-path belief and response after warranty.

Steps: propose `H->N, L->N`; set on-path posterior to `p`; compute receiver action after `N`; choose an off-path belief after `W`; compute response after `W`; check deviation payoff for both types.

## 3. Important Subtopics

### 3.1 Uninformative on-path signal

- **Meaning:** Every type generates the same observation.
- **Why:** Posterior equals prior.
- **Example:** All services display the same generic security badge.
- **Angle:** Pooling does not mean the receiver knows nothing; it retains the prior.

### 3.2 Off-path deterrence

- **Meaning:** Beliefs after an unused signal determine whether deviation is attractive.
- **Why:** Many pooling PBEs depend on pessimistic off-path beliefs.
- **Example:** Buyers think a deviating seller is low quality and refuse to buy.
- **Angle:** State whether the belief is plausible under stronger refinements.

### 3.3 Pooling incentive constraints

- **Meaning:** For every type `t`, `U_t(m*,a(m*)) >= U_t(m',a(m'))`.
- **Why:** Both types must prefer the pool.
- **Example:** Even a high type may avoid certification if it is too costly.
- **Angle:** Check types separately because their costs differ.

### 3.4 Pooling on either signal

- **Meaning:** With two signals, candidates include pooling on each one.
- **Why:** One may fail while the other survives.
- **Example:** Both certify versus neither certifies.
- **Angle:** Enumerate candidates systematically.

## 4. Real-World Example

All new marketplace sellers may choose the platform's basic warranty because buyers distrust any nonstandard promise. Buyers price every basic-warranty seller using average expected quality. A high-quality seller does not deviate to a longer warranty if its added price fails to cover the cost, while a low-quality seller also stays. This is pooling: behavior is identical even though types differ.

## 5. Diagrams / Mental Models

```text
H --\
     > same signal m* -> posterior remains prior -> receiver uses average payoff
L --/

unused m' -> off-path belief -> response -> deviation check for H and L
```

## 6. Common Interview Questions

1. **Define pooling equilibrium.** All types choose the same signal. **Expected:** on-path posterior. **Mistake:** say types have same payoff.
2. **What is the on-path belief?** The prior if every type pools surely. **Expected:** Bayes calculation. **Mistake:** posterior one.
3. **Why are off-path beliefs important?** They determine receiver response to deviation. **Expected:** IC link. **Mistake:** ignore unused signals.
4. **Can pooling be a PBE?** Yes, if receiver actions are optimal and every type prefers pooling. **Expected:** full conditions. **Mistake:** pooling alone suffices.
5. **Can multiple pooling PBEs exist?** Yes, supported by different signals or off-path beliefs. **Expected:** refinement issue. **Mistake:** assume uniqueness.
6. **Is a pooling signal informative?** Not about type on path when used equally by all types. **Expected:** posterior equals prior. **Mistake:** call it meaningless in all respects.
7. **How do you test pooling?** Receiver best responses plus one deviation inequality per type. **Expected:** both candidate signals. **Mistake:** check one type.
8. **Does pooling imply inefficiency?** Not necessarily, but hidden type can cause adverse selection or distorted actions. **Expected:** qualify. **Mistake:** always inefficient.
9. **Can receiver action differ after signals?** Yes; the unused signal's response follows its off-path belief. **Expected:** complete strategy. **Mistake:** same response forced.
10. **Why might refinements eliminate pooling?** A deviation may be profitable only for a particular type, making a pessimistic belief implausible. **Expected:** intuitive criterion idea. **Mistake:** all PBEs survive refinements.

## 7. Deep-Dive Questions

1. **What belief range supports pooling?** Derive receiver response regions, then intersect them with both types' no-deviation inequalities.
2. **Can pooling occur with productive signals?** Yes, if productivity and costs do not create profitable type-dependent deviations.
3. **How does prior probability affect pooling?** It can change the receiver's on-path best response and thus both types' incentives.
4. **Why is pooling vulnerable to refinement?** Off-path beliefs can punish deviations even when only a desirable type would rationally make them.
5. **Can all types mix identically and still pool informationally?** Yes; if their signal distributions are identical, every signal leaves the posterior equal to the prior.

## 8. Comparison Tables

| Feature | Pooling | Separating |
|---|---|---|
| Type behavior | Same signal | Different signals |
| On-path posterior | Usually prior | Degenerate |
| Information | None revealed | Type revealed |
| Key check | Off-path deviations | Imitation constraints |

## 9. Common Mistakes

- Setting the pooling posterior to `1/2` instead of the stated prior.
- Omitting receiver response after deviation.
- Using the same deviation cost for both types.
- Claiming pooling is equilibrium without inequalities.
- Ignoring stronger refinements when asked about plausibility.

## 10. Edge Cases / Special Cases

If the receiver is indifferent, several actions or a mixed action can support pooling. If the prior sits exactly at a response cutoff, equilibrium multiplicity expands. Identical mixed signal distributions are observationally pooling. A zero-prior type does not affect on-path Bayes updating.

## 11. How to Explain in Interview

> In a pooling equilibrium all types send the same signal, so the receiver's on-path posterior remains the prior. We then choose a best response to that prior and verify, using off-path beliefs and responses, that no type wants to deviate.

## 12. Quick Revision Notes

- Same signal for all types.
- On-path belief equals prior.
- Off-path belief is decisive.
- Check receiver optimality and every type's IC.
- Trap: pooling behavior is not by itself a PBE.

## 13. Practice Tasks

1. Test pooling on each signal in a `2x2x2` signaling game.
2. Find all off-path beliefs supporting one candidate.
3. Vary the prior and plot receiver actions.
4. Apply the intuitive criterion informally.
5. Design a marketplace pooling example with numerical payoffs.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | All types choose the same signal |
| Why it matters | Explains persistent hidden information |
| Most asked | On-path prior, off-path belief, IC checks |
| Comparison | Pooling reveals none; separating reveals all |
| One-line answer | Pooling survives only if average-type receiver behavior and off-path responses deter every type's deviation. |

---

---

# Separating Equilibrium

## 1. Overview

A **separating equilibrium** assigns different signals to different sender types, so the receiver infers type perfectly on path. It matters in credentials, warranties, pricing, and costly authentication. Interviewers focus on incentive compatibility: revelation must arise from self-selection, not assumption.

## 2. Core Idea

Let `H` choose certificate `C` and `L` choose none `N`. Bayes gives `mu(H|C)=1` and `mu(H|N)=0`. The recruiter hires after `C` and rejects after `N`. Separation holds only if `H` prefers the certification/hire outcome and `L` prefers no certificate/rejection to imitating `H`.

If hiring benefit is `B` and certification costs are `c_H<c_L`, the classic conditions are `B-c_H >= 0` and `B-c_L <= 0`, or `c_H <= B <= c_L`.

## 3. Important Subtopics

### 3.1 Full revelation

- **Meaning:** Each on-path signal identifies one type.
- **Why:** Receiver can tailor action to type.
- **Example:** Valid hardware attestation identifies trusted device class.
- **Angle:** Posterior is zero or one, not the prior.

### 3.2 Self-selection constraints

- **Meaning:** Each type prefers its own signal-response pair.
- **Why:** Prevents imitation.
- **Example:** `H` finds certification cheap; `L` finds it too costly.
- **Angle:** Write both inequalities, including reverse separation if possible.

### 3.3 Single crossing

- **Meaning:** Types rank signal intensity differently in a monotone way.
- **Why:** Supports an ordered mapping from type to signal.
- **Example:** More productive workers have lower marginal education cost.
- **Angle:** It is a condition on preferences, not merely observed correlation.

### 3.4 Signaling cost and efficiency

- **Meaning:** Separation may consume resources only to communicate type.
- **Why:** Private equilibrium can be socially wasteful.
- **Example:** Excess credentials do not raise productivity.
- **Angle:** Distinguish signaling return from human-capital return.

## 4. Real-World Example

A reliable backend vendor offers a high-penalty SLA because failures are rare; an unreliable vendor expects penalty payments and chooses a basic SLA. Enterprise buyers infer reliability from the chosen contract. The SLA separates only when the price gain covers expected penalties for the reliable type but not for the unreliable type.

## 5. Diagrams / Mental Models

```text
H -> C -> belief H=1 -> Hire
L -> N -> belief H=0 -> Reject

Check: H does not imitate L; L does not imitate H.
```

## 6. Common Interview Questions

1. **Define separating equilibrium.** Types choose distinct signals. **Expected:** perfect on-path inference. **Mistake:** merely different payoffs.
2. **What are on-path beliefs?** Probability one on the type assigned to each observed signal. **Expected:** Bayes. **Mistake:** retain prior.
3. **What supports separation?** Differential costs or benefits that make imitation unattractive. **Expected:** IC. **Mistake:** signal cost alone.
4. **How do you verify it?** Receiver best responses and one no-imitation inequality per type. **Expected:** both directions. **Mistake:** check only low type.
5. **Can separation exist when costs are equal?** Sometimes if other payoff differences create IC, but equal pure signaling costs alone do not screen identical preferences. **Expected:** qualify. **Mistake:** categorical no.
6. **Is separation efficient?** It improves allocation but may burn signaling resources. **Expected:** welfare tradeoff. **Mistake:** equate information with efficiency.
7. **Can labels be reversed?** Test the reverse candidate; often single crossing rules it out. **Expected:** enumerate. **Mistake:** assume natural label mapping.
8. **Are off-path beliefs needed?** If every available signal is used on path in a two-signal/two-type pure separation, no signal is off path; with extra signals, yes. **Expected:** count signals. **Mistake:** always or never.
9. **What is a least-cost separating equilibrium?** A separating outcome using the smallest signal distortion compatible with IC. **Expected:** boundary condition. **Mistake:** zero cost necessarily.
10. **How does prior affect pure separation?** On-path posteriors are degenerate, though prior can affect ex-ante welfare and zero-prior edge cases. **Expected:** distinguish incentives. **Mistake:** force prior into degenerate posterior.

## 7. Deep-Dive Questions

1. **Why can there be many separating signal levels?** Any levels satisfying IC may work; refinements or least-cost criteria can select among them.
2. **How does Spence signaling work?** Education is less costly for productive workers, enabling self-selection even if education adds no productivity.
3. **Can multidimensional types separate with one signal?** Not generally; different types may share preferences over the scalar signal.
4. **How do refinements affect excessive signals?** Criteria such as dominance and intuitive reasoning often eliminate unnecessarily costly separation.
5. **What changes if signals are noisy?** Posterior beliefs are no longer degenerate, so separation becomes statistical rather than perfect.

## 8. Comparison Tables

| Feature | Separating | Pooling | Semi-separating |
|---|---|---|---|
| Signal choice | Type-specific pure | Same pure signal | Some mixing |
| Revelation | Full | None | Partial |
| Posterior | 0 or 1 | Prior | Interior after some signals |
| Central condition | No imitation | No deviation | Indifference + Bayes |

## 9. Common Mistakes

- Assuming different signals automatically form equilibrium.
- Forgetting one type's IC constraint.
- Leaving receiver response unjustified.
- Confusing perfect revelation with zero signaling cost.
- Ignoring reverse separating candidates.

## 10. Edge Cases / Special Cases

Weak inequalities allow boundary equilibria and mixing. More signals than types create off-path beliefs. Zero prior for a type breaks ordinary inference about that type. Noisy observation prevents literal perfect revelation. Productive signals change both information and output.

## 11. How to Explain in Interview

> A separating equilibrium has each type choose a different signal, so Bayes' rule identifies the type on path. The key is incentive compatibility: every type must prefer its own signal and induced receiver action over imitating another type.

## 12. Quick Revision Notes

- Different type -> different signal.
- On-path posteriors are degenerate.
- Receiver best-responds type by type.
- Check both no-imitation inequalities.
- Trap: revelation is a result of incentives, not an imposed truth-telling rule.

## 13. Practice Tasks

1. Derive `c_H <= B <= c_L` from payoffs.
2. Test both directions of separation in a numerical game.
3. Add a third signal and specify off-path beliefs.
4. Compare private and social welfare with a wasteful signal.
5. Model an SLA as a separating device.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Different types choose different signals |
| Why it matters | Enables self-selection and type-specific response |
| Most asked | Degenerate beliefs; IC inequalities; single crossing |
| Comparison | Full revelation versus pooling's no revelation |
| One-line answer | Separation is credible revelation produced by no-imitation incentives. |

---

---

# Semi-Separating Equilibrium

## 1. Overview

A **semi-separating** or **partially pooling equilibrium** occurs when at least one type randomizes over signals and observed signals reveal some, but not all, information. Receiver beliefs are often interior probabilities. It models noisy credentials, probabilistic fraud behavior, and strategic randomization. Interviewers ask it because solving requires indifference equations and Bayes' rule together.

## 2. Core Idea

Suppose `H` always chooses `C`, while `L` chooses `C` with probability `q` and `N` otherwise. Then `N` reveals `L`, but `C` does not:

`mu(H|C)=p/[p+(1-p)q]`, while `mu(H|N)=0`.

If `L` genuinely mixes, its payoff from `C` and `N` must tie. If the receiver mixes after `C`, its actions must also tie at the posterior induced by `q`. Solve these indifference conditions, then use Bayes and check all unused deviations.

## 3. Important Subtopics

### 3.1 Mixing and indifference

- **Meaning:** A player assigns positive probability only to best responses.
- **Why:** Mixing probabilities are determined by making the other relevant decision-maker indifferent.
- **Example:** Receiver hiring probability may make `L` indifferent about certification.
- **Angle:** Do not choose mixing probabilities arbitrarily.

### 3.2 Interior posterior

- **Meaning:** After a signal used by multiple types, belief lies strictly between zero and one.
- **Why:** Receiver action reflects residual uncertainty.
- **Example:** `p/[p+(1-p)q]`.
- **Angle:** Include signal probabilities in the denominator.

### 3.3 Partial revelation

- **Meaning:** Some signals identify type; others only shift probability.
- **Why:** Information is neither all nor nothing.
- **Example:** No certificate reveals low type, certificate is ambiguous.
- **Angle:** State posterior after each signal separately.

### 3.4 Boundary cases

- **Meaning:** As `q` approaches `0` or `1`, semi-separation becomes separation or pooling.
- **Why:** Valid mixing requires `0<q<1`.
- **Example:** `q=0` makes only `H` certify.
- **Angle:** Reject computed probabilities outside `[0,1]`.

## 4. Real-World Example

Legitimate clients always complete an expensive attestation, while some attackers imitate it and others avoid it. An attested request is safer than the prior but not certainly safe; an unattested request identifies the attacker in the stylized model. The gateway may randomize between allowing and challenging attested traffic so attackers are exactly indifferent between imitation and avoidance.

## 5. Diagrams / Mental Models

```text
H --100%--> C --\
                > posterior in (0,1) -> receiver may mix
L ----q----> C --/
L --1-q--> N ---> posterior H=0

Positive probability action => must be a best response.
```

## 6. Common Interview Questions

1. **Define semi-separating equilibrium.** At least one type mixes, yielding partial information. **Expected:** interior posterior. **Mistake:** call any mixed equilibrium semi-separating.
2. **Why does a player mix?** Supported actions give equal maximal payoff. **Expected:** indifference. **Mistake:** randomness for unpredictability without payoff equality.
3. **How is posterior computed?** Prior times type-specific signal probability, normalized. **Expected:** Bayes formula. **Mistake:** ignore mixing rate.
4. **Who determines a player's mixing probability?** Usually the opponent's indifference condition determines it. **Expected:** strategic mixing logic. **Mistake:** use player's own indifference to solve its own probability in a linear game.
5. **What does partial revelation mean?** Signals alter beliefs without always identifying type. **Expected:** compare posterior to prior. **Mistake:** every signal must be ambiguous.
6. **How do you validate a solution?** Probabilities in `[0,1]`, Bayes consistency, support indifference, and no profitable excluded action. **Expected:** all checks. **Mistake:** solve equations only.
7. **Can one type be pure?** Yes; often one type uses one signal surely while another mixes. **Expected:** common pattern. **Mistake:** both must mix.
8. **What happens at probability zero or one?** The candidate collapses to pooling or separating and must be reclassified. **Expected:** boundary check. **Mistake:** call it interior mixing.
9. **Can receiver mix after a signal?** Yes, when posterior makes receiver indifferent. **Expected:** action support. **Mistake:** receiver must be pure.
10. **Why are semi-separating equilibria computationally harder?** Strategies and beliefs jointly determine each other through Bayes and indifference. **Expected:** fixed-point logic. **Mistake:** Bayes update alone.

## 7. Deep-Dive Questions

1. **Derive the low-type mixing rate for target posterior `mu*`.** From `mu*=p/[p+(1-p)q]`, obtain `q=p(1-mu*)/[mu*(1-p)]`.
2. **How is receiver mixing probability found?** Set the mixing sender type's payoffs from its two signals equal and solve for the receiver action probability.
3. **Can both types mix over both signals with informative beliefs?** Yes if their mixing rates differ; equal rates make signals uninformative.
4. **What if the solved `q>1`?** No equilibrium of the proposed support exists; test another support or pure pattern.
5. **How do trembles relate to semi-separation?** Completely mixed perturbations give every signal positive probability and can select limiting beliefs and strategies.

## 8. Comparison Tables

| Property | Pooling | Semi-separating | Separating |
|---|---:|---:|---:|
| Information | None | Partial | Full |
| Typical posterior | Prior | Interior | 0 or 1 |
| Sender mixing | No | Yes, at least one | No |
| Key equations | No-deviation | Indifference + Bayes | No-imitation |

## 9. Common Mistakes

- Forgetting that every support action must tie.
- Solving a probability outside `[0,1]` and accepting it.
- Calling receiver mixing alone semi-separation when sender signals reveal types purely.
- Failing to recompute beliefs from mixing probabilities.
- Ignoring excluded-action inequalities.

## 10. Edge Cases / Special Cases

At exact payoff ties a continuum of mixing probabilities may be possible. Equal type-specific signal rates reveal no information even though both types mix. A signal used by only one type has a degenerate posterior. Boundary solutions must be rechecked as pure equilibria.

## 11. How to Explain in Interview

> In a semi-separating equilibrium at least one sender type randomizes, so signals are only partially informative. I solve it by equating payoffs for every mixed action, deriving the mixing probabilities, updating beliefs with Bayes' rule, and checking probabilities and deviations.

## 12. Quick Revision Notes

- Partial information, usually interior beliefs.
- Mixing requires indifference.
- Bayes uses type-specific mixing rates.
- Opponent indifference usually pins down your mixing probability.
- Check `0<q<1`; boundaries are pure cases.

## 13. Practice Tasks

1. Derive `q` from a receiver cutoff `mu*`.
2. Build payoffs that make low type mix.
3. Verify every support and excluded-action inequality.
4. Plot posterior `mu(H|C)` against `q`.
5. Implement a solver that enumerates supports in a two-type game.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Definition | Some type mixes, producing partial revelation |
| Why it matters | Models strategic noise between pooling and separation |
| Most asked | Indifference equations; posterior from mixing; boundary checks |
| Comparison | More informative than pooling, less than separation |
| One-line answer | Semi-separation combines Bayes updating with mixing probabilities chosen to maintain indifference. |

---

---

# Perfect Bayesian Equilibrium: Synthesis

A **Perfect Bayesian Equilibrium (PBE)** is an **assessment** `(strategies, beliefs)` satisfying:

1. **Sequential rationality:** every player's strategy is optimal at every information set given beliefs and other strategies.
2. **Consistency:** beliefs follow Bayes' rule wherever the information set is reached with positive probability.

```text
Propose strategies
      |
      v
derive on-path beliefs with Bayes
      |
      v
find best responses at every information set
      |
      v
check every type's deviation
      |
      v
state and test off-path beliefs -> PBE or reject candidate
```

| Equilibrium form | Sender behavior | Information |
|---|---|---|
| Pooling | All types use same signal | None revealed on path |
| Separating | Types use distinct signals | Fully revealed |
| Semi-separating | At least one type mixes | Partially revealed |

**Placement-ready answer:** PBE strengthens Nash equilibrium in dynamic incomplete-information games by requiring optimal continuation behavior and Bayes-consistent beliefs. To solve one, enumerate signaling patterns, calculate beliefs, best-respond at every information set, and verify all incentive constraints.
