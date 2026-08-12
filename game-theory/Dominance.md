# Strictly Dominant Strategies

## 1. Overview

A **strictly dominant strategy** is a strategy that gives a player a strictly higher payoff than every other strategy available to that player, **for every possible strategy chosen by the other players**.

For player (i), strategy (s_i^*) is strictly dominant if, for every alternative (s_i \neq s_i^*) and every possible opponents' strategy profile (s_{-i}),

\[
u_i(s_i^*, s_{-i}) > u_i(s_i, s_{-i}).
\]

The phrase “strictly higher” is essential: a tie in even one relevant case means the strategy is not strictly dominant over that alternative.

Why it matters:

- It makes a player's decision independent of predictions about other players.
- If every player has a strictly dominant strategy, the resulting outcome is a dominant-strategy equilibrium and is also a Nash equilibrium.
- It gives a strong solution concept because each player's choice remains optimal under every opponent action.

Where it is used:

- Auction and mechanism design, especially truthful bidding in second-price auctions.
- Pricing and competition models.
- Security decisions when one action is safer under every attack scenario.
- Protocol and incentive design in distributed systems.
- Resource-allocation systems in which participants may act strategically.

Interviewers ask about it to test whether a candidate can read payoff matrices, reason with quantifiers, distinguish dominance from Nash equilibrium, and recognize that individually rational choices can still produce a socially poor outcome.

## 2. Core Idea

### Intuition

A strategy is strictly dominant when it wins every head-to-head comparison against each of the player's alternatives, regardless of what everyone else does. The player does not need probabilities, beliefs, communication, or knowledge of the opponent's reasoning.

### Real-world analogy

Suppose two commuting routes have the following travel times:

- Route A always takes 20 minutes.
- Route B takes either 25 or 35 minutes depending on traffic.

Route A is strictly better in every traffic condition. The traffic condition plays the role of the opponent's choice; Route A is analogous to a strictly dominant strategy.

### Small example: Prisoner's Dilemma

The first number in each cell is Player 1's payoff; the second is Player 2's.

| Player 1 \ Player 2 | Cooperate | Defect |
|---|---:|---:|
| **Cooperate** | (3, 3) | (0, 5) |
| **Defect** | (5, 0) | (1, 1) |

For Player 1:

- If Player 2 cooperates, Defect gives 5 instead of 3.
- If Player 2 defects, Defect gives 1 instead of 0.
- Therefore, Defect strictly dominates Cooperate.

The matrix is symmetric, so the same reasoning applies to Player 2. Thus `(Defect, Defect)` is the dominant-strategy equilibrium, even though `(Cooperate, Cooperate)` gives both players a higher payoff. Dominant individual incentives do not guarantee social efficiency.

### Step-by-step test

1. Fix one player.
2. Pick two of that player's strategies.
3. Hold the opponents' action fixed, one column or row at a time.
4. Compare only the chosen player's payoff.
5. Confirm that the candidate strategy gives a strictly larger payoff in every case.
6. Repeat against every other strategy of that player.

## 3. Important Subtopics

### 3.1 Strict dominance by a pure strategy

A pure strategy is one definite action. Row `A` strictly dominates row `B` for the row player when every payoff in row `A` is greater than the corresponding payoff in row `B`.

This matters because it is the fastest matrix test. Interviewers commonly ask candidates to scan a matrix and identify dominant or dominated rows and columns. For a column player, compare the **second** payoff vertically while holding the row fixed.

### 3.2 Strict dominance by a mixed strategy

A randomized combination of strategies can strictly dominate a pure strategy even when no single pure strategy does. If mixing strategies `A` and `B` with probabilities (p) and (1-p) gives a higher expected payoff than strategy `C` against every opponent action, the mixture strictly dominates `C`.

This matters in larger games because checking only pairwise pure strategies can miss removable actions. An advanced interview may ask whether a strategy survives pure-strategy elimination but is still dominated by a mixture.

### 3.3 Dominant-strategy equilibrium

An outcome is a dominant-strategy equilibrium when every player's chosen action is dominant for that player. It is robust because no player's reasoning depends on another player's decision.

Every strictly dominant-strategy equilibrium is a Nash equilibrium. The reverse is false: many Nash equilibria exist without dominant strategies. This implication is a frequent interview check.

### 3.4 Uniqueness

A player cannot have two distinct strictly dominant strategies. If `A` strictly dominated `B`, then `B` could not also strictly dominate `A`. Therefore, if every player has a strictly dominant strategy, the dominant-strategy equilibrium is unique.

This does not mean that every game has one. Most games have no strictly dominant strategy for at least one player.

### 3.5 Efficiency and the price of incentives

Strict dominance describes private incentives, not total welfare. The Prisoner's Dilemma demonstrates that dominant behavior may lead to a Pareto-inferior outcome.

Interviewers use this distinction to see whether the candidate incorrectly equates “equilibrium,” “best for each player,” and “best for society.”

## 4. Real-World Example

### Second-price sealed-bid auction

Each bidder submits one bid. The highest bidder wins but pays the second-highest bid. For a bidder with true value (v), bidding (v) is weakly dominant, and the reasoning illustrates why dominance is valuable in system design:

- Overbidding can make the bidder win at a price above their value.
- Underbidding can make the bidder lose when the price would have been below their value.
- Truthful bidding avoids both errors.

Strict dominance is rarer in real mechanisms because ties and irrelevant bid ranges often make truth-telling only weakly dominant. That distinction itself is important: interviews may deliberately call truthful bidding “strictly dominant” to see whether the candidate notices the overstatement.

In backend and distributed-system design, the analogous goal is **incentive compatibility**: design rules so that the desired behavior is optimal without requiring the server to infer each participant's beliefs.

## 5. Diagrams / Mental Models

### Quantifier model

```text
Candidate strategy S*
    |
    +-- versus every alternative S
            |
            +-- under every opponent action
                    |
                    +-- payoff(S*) must be strictly greater
```

Remember: **every alternative × every opponent action × strict inequality**.

### Matrix scan

```text
Row player:    compare first numbers horizontally, row against row.
Column player: compare second numbers vertically, column against column.
```

| Property | Strictly dominant strategy |
|---|---|
| Depends on beliefs about opponents | No |
| Allows a tie against an alternative | No |
| Can be found by payoff comparison | Yes |
| Must exist in every finite game | No |
| If all players have one, outcome is Nash | Yes |

## 6. Common Interview Questions

### Q1. What is a strictly dominant strategy?

**Answer:** It is a strategy that produces a strictly higher payoff than every other strategy for every possible combination of opponents' actions.

**Expected:** Correct use of “every” and “strictly higher.” **Common mistake:** Saying it is merely the best response to the opponent's likely action.

### Q2. How do you find one in a payoff matrix?

**Answer:** Fix the player's opponents' action, compare that player's payoff across their own strategies, and identify a single strategy that is strictly best in every case.

**Expected:** Compare first coordinates for the row player and second coordinates for the column player. **Common mistake:** Comparing total payoffs or comparing both coordinates together.

### Q3. Is every strictly dominant strategy a best response?

**Answer:** Yes. It is the unique best response to every possible opponent strategy profile.

**Expected:** Dominance implies best response for all opponent actions. **Common mistake:** Reversing the implication; a best response to one action need not be dominant.

### Q4. Is every Nash equilibrium a dominant-strategy equilibrium?

**Answer:** No. Nash equilibrium requires each action to be a best response only to the actions chosen at that equilibrium. Dominance requires optimality against all possible opponent actions.

**Expected:** Explain the difference in scope. **Common mistake:** Treating both concepts as synonyms.

### Q5. Can a player have two strictly dominant strategies?

**Answer:** No. Each would need to yield a strictly higher payoff than the other under the same opponent action, which is impossible.

**Expected:** A short contradiction argument. **Common mistake:** Confusing strict and weak dominance.

### Q6. Does a strictly dominant strategy always exist?

**Answer:** No. In coordination games, matching pennies, rock-paper-scissors, and many other games, the best action depends on what the opponent does.

**Expected:** State nonexistence and provide an example. **Common mistake:** Assuming every payoff matrix has a dominant row or column.

### Q7. If only one player has a strictly dominant strategy, is the outcome determined?

**Answer:** Not completely. That player's action is determined, but the other players may have multiple best responses or require further equilibrium analysis.

**Expected:** Separate player-level and game-level conclusions. **Common mistake:** Declaring a dominant-strategy equilibrium immediately.

### Q8. Can a strictly dominant outcome be Pareto inefficient?

**Answer:** Yes. `(Defect, Defect)` in the Prisoner's Dilemma is the classic example: it is generated by strictly dominant strategies but both players prefer `(Cooperate, Cooperate)`.

**Expected:** Distinguish stability from welfare. **Common mistake:** Assuming rational behavior maximizes total payoff.

### Q9. Does multiplying all of a player's payoffs by a positive constant change strict dominance?

**Answer:** No. Positive affine transformations preserve payoff ordering and therefore preserve dominance.

**Expected:** Mention order preservation; adding a constant also changes nothing. **Common mistake:** Claiming any transformation is safe—negative multiplication reverses preferences.

### Q10. Can a mixed strategy be strictly dominant?

**Answer:** Yes in principle, if its expected payoff is strictly greater than every alternative against every opponent strategy. However, if a pure strictly dominant strategy exists, randomizing away from it cannot improve the player's payoff.

**Expected:** Use expected payoffs and universal comparison. **Common mistake:** Assuming “strategy” always means pure strategy.

## 7. Deep-Dive Questions

### 1. Why is it enough to test pure opponent strategies in a finite game?

Expected payoff against a mixed opponent strategy is a weighted average of payoffs against pure actions. If a strategy is strictly better at every pure action, its weighted average is strictly better against every mixture. The converse requires care when zero-probability actions are permitted, but pure-action checks establish the desired universal inequality.

### 2. Can strict dominance change if two players form a coalition?

Yes. Ordinary dominance is defined for unilateral choices. A coalition can coordinate deviations and transfer utility, creating a different strategic object. Strong equilibrium or coalition-proof concepts are needed; individual strict dominance alone does not analyze coordinated deviations.

### 3. Why is strict dominance epistemically strong?

The player needs almost no belief about opponents. They need only know their own payoff ordering and available actions. By contrast, selecting a Nash-equilibrium action may require correct beliefs about what others choose and confidence that others reason similarly.

### 4. How does strict dominance relate to rationalizability?

A strictly dominated strategy is never a best response to any belief and is therefore not rationalizable. A strictly dominant strategy survives every rationalizability test and is the only rationalizable action when it strictly dominates all alternatives.

### 5. Does strict dominance survive adding irrelevant strategies?

If payoffs for existing action profiles do not change, a strategy that dominated all old alternatives still dominates those old alternatives. But a newly added strategy may outperform it in some state, so it may cease to be dominant over the enlarged strategy set.

## 8. Comparison Tables

| Concept | Requirement | Beliefs needed | Strength |
|---|---|---:|---:|
| Strictly dominant strategy | Strictly better than every alternative against every opponent action | None | Strongest here |
| Weakly dominant strategy | Never worse and sometimes better than every alternative | None | Weaker |
| Best response | Best against one specified opponent strategy/belief | Yes | Local |
| Nash-equilibrium strategy | Best response to equilibrium opponents' actions | Consistent equilibrium belief | Outcome-specific |

| Strict dominance | Pareto dominance |
|---|---|
| Compares one player's strategies | Compares complete outcomes for all players |
| Holds opponents' actions fixed | May change every player's action |
| Concerns incentives | Concerns welfare |
| Can produce Pareto-poor outcomes | Identifies unanimous outcome improvement |

## 9. Common Mistakes

- Comparing the row player's second payoff or the column player's first payoff.
- Checking only one opponent action rather than all of them.
- Accepting a tie as strict dominance.
- Comparing total payoff instead of the relevant player's payoff.
- Assuming a strictly dominant strategy must maximize social welfare.
- Saying a Nash-equilibrium action is automatically dominant.
- Forgetting that mixed strategies can dominate pure strategies.
- Concluding that the whole game is solved when only one player has a dominant strategy.

## 10. Edge Cases / Special Cases

- With identical payoff rows, neither row strictly dominates the other.
- A strategy may strictly dominate one alternative but fail to dominate another; then it is not strictly dominant overall.
- Strict dominance can exist with negative payoffs; only ordering matters.
- Against infinitely many opponent actions, checking endpoints works only when payoff structure justifies it, such as linearity or monotonicity.
- In games with incomplete information, a strategy must specify an action for every player type. Dominance is evaluated type by type across possible reports or actions.
- A strictly dominant strategy remains optimal against correlated opponent behavior because it wins pointwise.

## 11. How to Explain in Interview

> A strictly dominant strategy gives a player a strictly higher payoff than every alternative, no matter what the other players do. I find it by fixing each opponent action and comparing only that player's payoffs. If every player has one, their combination is a unique dominant-strategy equilibrium and a Nash equilibrium, although it need not be socially efficient.

## 12. Quick Revision Notes

- Definition: (u_i(s_i^*,s_{-i}) > u_i(s_i,s_{-i})) for all alternatives and opponent profiles.
- No ties are allowed.
- It is a best response to every opponent action.
- At most one strictly dominant strategy exists per player.
- If every player has one, their profile is a Nash equilibrium.
- Dominant does not mean Pareto efficient.
- Trap: second-price auction truth-telling is generally **weakly**, not strictly, dominant.

## 13. Practice Tasks

1. Create a (2 \times 2) payoff matrix in which both players have strictly dominant strategies but the resulting outcome is Pareto dominated.
2. Create a game in which only the row player has a strictly dominant strategy; find all Nash equilibria.
3. Write a C++ function that receives an integer payoff matrix for one player and returns the index of a strictly dominant strategy or `-1`.
4. Extend the function to reject ragged matrices and test a tie case.
5. Prove that two distinct strictly dominant strategies cannot coexist for one player.
6. Explain why checking every pure opponent profile also covers mixed opponent strategies in finite games.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Strictly better against every opponent action |
| Key symbol | `>` everywhere |
| Fast test | Compare own payoffs cell by cell |
| Major implication | All players strictly dominant ⇒ Nash equilibrium |
| Most asked distinction | Dominant strategy vs best response/Nash strategy |
| Main trap | Equilibrium need not be socially optimal |
| One-line answer | “It is my uniquely best action regardless of what others do.” |

---

# Weakly Dominant Strategies

## 1. Overview

A **weakly dominant strategy** is never worse than any alternative for any opponents' action, and is strictly better than that alternative in at least one case.

Strategy (s_i^*) weakly dominates an alternative (s_i) if

\[
u_i(s_i^*,s_{-i}) \ge u_i(s_i,s_{-i}) \quad \text{for every } s_{-i},
\]

and

\[
u_i(s_i^*,s_{-i}) > u_i(s_i,s_{-i}) \quad \text{for at least one } s_{-i}.
\]

To call (s_i^*) weakly dominant overall, it must weakly dominate every alternative strategy.

Weak dominance matters because many practical mechanisms cannot guarantee a strict benefit in every case. Some opponent actions make two choices equivalent, yet one choice remains safer because it is better in other cases and never worse.

It appears in truthful auctions, voting mechanisms, congestion decisions, protocol participation, and fallback policies. Interviewers ask about it because the word “weakly” changes both the definition and the reliability of elimination arguments.

## 2. Core Idea

### Intuition

A weakly dominant strategy is a **no-regret option**: choosing it never hurts compared with another strategy and sometimes helps. Unlike strict dominance, some scenarios may end in a tie.

### Real-world analogy

Suppose a software service offers two retry policies:

- Policy A succeeds whenever Policy B succeeds.
- Under temporary network failure, A retries and succeeds while B fails.
- Under normal conditions, both behave identically.

A weakly dominates B: it is equal in ordinary cases and better in at least one relevant case.

### Small example

| Player 1 \ Player 2 | Left | Right |
|---|---:|---:|
| **Up** | (3, 1) | (2, 2) |
| **Down** | (3, 0) | (1, 2) |

For Player 1:

- Against Left: Up and Down both give 3.
- Against Right: Up gives 2 and Down gives 1.
- Therefore, Up weakly dominates Down, but does not strictly dominate it.

The equality against Left is exactly why the classification is weak.

### Step-by-step test

1. Choose a candidate and one alternative.
2. Verify the candidate payoff is at least as large in every corresponding cell.
3. Verify it is strictly larger in at least one cell.
4. Repeat for every other alternative.
5. Keep track of ties; they affect equilibrium and elimination conclusions.

## 3. Important Subtopics

### 3.1 The two-part condition

Weak dominance requires both “never worse” and “sometimes better.” If all payoffs are equal, the strategies are payoff-equivalent under the common textbook definition; neither weakly dominates the other when strict improvement somewhere is required.

Interviewers may use a convention where “weakly dominates” means only `>=`. State your convention explicitly when identical strategies appear.

### 3.2 Multiple weakly dominant strategies

A player may have more than one weakly dominant strategy. They can tie across relevant outcomes or differ only in cases where other actions are themselves strategically implausible.

This matters because weak dominance does not necessarily predict a unique action or outcome.

### 3.3 Weakly dominant-strategy equilibrium

If each player selects a weakly dominant strategy, the profile is a Nash equilibrium: no unilateral deviation produces a strictly greater payoff. But there may be other Nash equilibria, and different choices among multiple weakly dominant strategies may produce different outcomes.

### 3.4 Truthful bidding in a Vickrey auction

In a second-price auction, bidding one's true value is weakly dominant. In many cases, changing the bid does not alter who wins or the price, so truth-telling cannot be strictly dominant. In pivotal cases, lying can make the bidder lose a profitable purchase or win an unprofitable one.

This is the canonical mechanism-design interview example.

### 3.5 Weak dominance by mixed strategies

A probability distribution over pure actions may never perform worse than a particular pure action and may outperform it for some opponent action. Detecting this may require inequalities or linear programming rather than a simple row comparison.

## 4. Real-World Example

### Truthful reporting in a second-price auction service

Assume a bidder values an instance at ₹1,000:

- If the highest competing bid is ₹700, any own bid above ₹700 wins and pays ₹700. Truthful bidding earns ₹300.
- If the competitor bids ₹1,200, truthful bidding loses, avoiding a negative surplus.
- Underbidding below ₹700 can incorrectly lose a profitable auction.
- Overbidding above ₹1,000 can incorrectly win when the price exceeds the bidder's value.

Truth-telling is never worse than lying and is better in some pivotal ranges, but many different bids have the same result for a fixed competing bid. Hence it is weakly dominant.

For backend engineers, the practical lesson is that payment rules shape client behavior. A well-designed allocation API can make honest inputs a safe choice instead of relying only on fraud detection after submission.

## 5. Diagrams / Mental Models

```text
Strict dominance:  >  >  >  >
Weak dominance:    ≥  ≥  >  ≥    (at least one >)
No dominance:      >  <  ≥  >    (preference reverses)
Equivalence:       =  =  =  =
```

| Candidate vs alternative | Classification |
|---|---|
| Better in every state | Strictly dominates |
| Never worse, better somewhere | Weakly dominates |
| Equal everywhere | Payoff-equivalent under the strict-somewhere convention |
| Better in some, worse in others | Neither dominates |

## 6. Common Interview Questions

### Q1. Define a weakly dominant strategy.

**Answer:** It gives at least as much payoff as every alternative for every opponent action and gives strictly more for at least one opponent action per comparison.

**Expected:** Both inequality conditions. **Common mistake:** Omitting “better somewhere,” thereby treating duplicate strategies as dominance without noting convention.

### Q2. How is weak dominance different from strict dominance?

**Answer:** Strict dominance requires a strict payoff improvement in every case. Weak dominance allows ties but no losses and requires improvement in at least one case.

**Expected:** `>` everywhere versus `>=` everywhere plus `>` somewhere. **Common mistake:** Saying weak dominance means “usually better.”

### Q3. Can two strategies weakly dominate each other?

**Answer:** Under the convention requiring strict improvement somewhere, no. If a text defines weak dominance using only `>=`, payoff-identical strategies weakly dominate each other. State the convention.

**Expected:** Recognize the definitional convention. **Common mistake:** Giving an unconditional yes or no.

### Q4. Can a player have multiple weakly dominant strategies?

**Answer:** Yes. Weak inequalities allow strategies to tie in many or all strategically reachable cases while each is never worse than other alternatives.

**Expected:** Contrast with uniqueness under strict dominance. **Common mistake:** Applying the strict-dominance uniqueness result.

### Q5. Is a profile of weakly dominant strategies a Nash equilibrium?

**Answer:** Yes. Each chosen strategy is a best response to the opponents' chosen strategies, so no player has a profitable unilateral deviation.

**Expected:** Explain through best responses. **Common mistake:** Claiming it must be the unique Nash equilibrium.

### Q6. Why is truth-telling only weakly dominant in a second-price auction?

**Answer:** Many bid changes do not affect allocation or payment, producing equal utility. Truthful bidding is strictly better only in cases where a false bid changes a beneficial win into a loss or an avoided loss into a harmful win.

**Expected:** Discuss non-pivotal ties. **Common mistake:** Saying truth always generates strictly higher profit.

### Q7. Can weakly dominant behavior produce different outcomes?

**Answer:** Yes. Multiple weakly dominant actions and ties can lead to different equilibria and different welfare levels.

**Expected:** Weak dominance has limited predictive power. **Common mistake:** Assuming dominance always selects exactly one cell.

### Q8. Does a weakly dominant strategy remain optimal against a mixed opponent strategy?

**Answer:** It never gives lower expected utility, because expectation preserves pointwise weak inequalities. It may tie against a mixture whose support excludes every state where it was strictly better.

**Expected:** Mention expected payoff and support. **Common mistake:** Claiming strict superiority against every mixture.

### Q9. Is playing a weakly dominated strategy irrational?

**Answer:** It is avoidable because another strategy is never worse and sometimes better. However, labeling it irrational requires assumptions about whether the player assigns positive probability to the states where improvement occurs. This is subtler than strict domination.

**Expected:** Explain the role of beliefs. **Common mistake:** Treating weak and strict domination identically.

### Q10. What happens if all corresponding payoffs tie?

**Answer:** The strategies are payoff-equivalent. Whether the term “weakly dominates” applies depends on the textbook convention, so explicitly state the definition being used.

**Expected:** Handle ambiguity precisely. **Common mistake:** Silently choosing a convention.

## 7. Deep-Dive Questions

### 1. Why can weak dominance fail to be strict against a mixed belief?

The only states with strict improvement may receive probability zero. The expected payoff difference is then zero even though the candidate is weakly better pointwise. Strict dominance avoids this issue because every state has a positive payoff gap.

### 2. Is a weakly dominated strategy ever a best response?

Yes. It can be a best response to a belief concentrated entirely on opponent actions where it ties with its dominator. A strictly dominated strategy cannot be a best response to any belief.

### 3. Why is weak dominance sensitive to removing opponent strategies?

The removed strategy might be the only case in which the candidate is strictly better. After removal, two strategies can become payoff-equivalent, so the original strict-somewhere relationship disappears.

### 4. Does weak dominance imply evolutionary stability?

No. Evolutionary stability requires additional resistance to invasion when payoffs tie against the incumbent. Weak dominance alone does not guarantee those second-order conditions.

### 5. How would you detect mixed weak dominance computationally?

Introduce probability variables for the dominating mixture, require them to be nonnegative and sum to one, and impose one payoff inequality for each opponent pure strategy. Add a condition that at least one inequality is strict, commonly implemented by maximizing a slack variable with linear programming.

## 8. Comparison Tables

| Feature | Strictly dominant | Weakly dominant |
|---|---:|---:|
| Never worse | Yes | Yes |
| Better in every case | Yes | No |
| Ties allowed | No | Yes |
| Unique for a player | Yes | Not necessarily |
| Best response to every opponent action | Unique best response | A best response |
| Elimination order concerns | No for strict elimination | Yes for weak elimination |

| Weakly dominant strategy | Maximin strategy |
|---|---|
| Compares actions state by state | Maximizes the worst possible payoff |
| Never worse than alternatives in any state | May be worse in some states |
| Independent of beliefs | Based on worst-case reasoning |
| Need not maximize minimum payoff uniquely | Chosen specifically by minimum payoff |

## 9. Common Mistakes

- Defining weak dominance as being better “most of the time.”
- Forgetting the no-worse requirement for every opponent action.
- Forgetting strict improvement somewhere.
- Assuming a weakly dominant strategy is unique.
- Calling truthful Vickrey bidding strictly dominant.
- Treating weakly dominated actions as never being best responses.
- Assuming iterated weak elimination has a unique, order-independent result.
- Ignoring the convention for payoff-identical strategies.

## 10. Edge Cases / Special Cases

- A weakly dominant strategy can tie with an alternative against the actual equilibrium action.
- With multiple weakly dominant strategies, different dominant-strategy equilibria may exist.
- A weakly dominated strategy may still appear in a Nash equilibrium because it can tie as a best response.
- Removing an opponent action can erase the only strict inequality supporting weak dominance.
- Under uncertainty about one's own type, an entire contingent plan—not just one immediate action—is evaluated.
- Weak dominance by a mixed strategy may be missed by pure row/column scans.

## 11. How to Explain in Interview

> A weakly dominant strategy is never worse than any alternative, regardless of what others do, and is strictly better in at least one case. Ties distinguish it from strict dominance. A profile of weakly dominant strategies is a Nash equilibrium, but it may not be unique, and eliminating weakly dominated strategies can depend on elimination order.

## 12. Quick Revision Notes

- Formula: `>=` for every opponent action and `>` somewhere.
- “Weak” does not mean probable or usually better.
- Multiple weakly dominant strategies may exist.
- A weakly dominated strategy can still be a best response to some belief.
- Vickrey auction truth-telling is the classic example.
- Iterated weak elimination can remove Nash equilibria and be order-dependent.
- Trap: clarify how identical payoff strategies are classified.

## 13. Practice Tasks

1. Modify one payoff in the Prisoner's Dilemma so Defect becomes weakly, but not strictly, dominant.
2. Construct a game with two Nash equilibria in which one equilibrium uses a weakly dominated strategy.
3. Prove truthful bidding is weakly dominant in a second-price auction by splitting into cases based on the highest competing bid.
4. Write a program that labels pairwise relationships as strict, weak, equivalent, or incomparable.
5. Find an example where a strategy is dominated by a mixture but not by a pure strategy.
6. Explain why a zero-probability state matters when discussing rationality of weakly dominated actions.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Never worse, better somewhere |
| Key symbols | `>=` everywhere, `>` at least once |
| Canonical example | Truthful bid in a second-price auction |
| Major implication | Profile of weakly dominant strategies ⇒ Nash equilibrium |
| Main contrast | Strict dominance permits no ties |
| Main trap | Weak elimination may be order-dependent |
| One-line answer | “It cannot hurt me and helps me in at least one case.” |

---

# Dominated Strategies

## 1. Overview

A **dominated strategy** is an action for which another pure or mixed strategy always performs at least as well and performs better under the required dominance condition.

- Strategy (s_i) is **strictly dominated** by (t_i) if
  \[
  u_i(t_i,s_{-i}) > u_i(s_i,s_{-i})
  \]
  for every opponents' strategy profile.
- Strategy (s_i) is **weakly dominated** by (t_i) if
  \[
  u_i(t_i,s_{-i}) \ge u_i(s_i,s_{-i})
  \]
  everywhere and the inequality is strict somewhere.

Dominated strategies matter because they can be discarded from rational consideration. Removing them simplifies games, reduces search space, and reveals strategic structure.

In practical systems, domination can identify inferior scheduling policies, bidding rules, retry strategies, pricing choices, or security settings. Interviewers ask about it to test matrix reasoning, the relationship between dominance and best responses, and whether candidates understand pure versus mixed domination.

## 2. Core Idea

### Intuition

Dominance asks: “Is there any reason to use this action?” If another strategy beats it in every situation, the answer is no under payoff-maximizing rationality.

### Real-world analogy

Consider two cloud plans with identical reliability and support:

- Plan A costs ₹1 per request in every usage tier.
- Plan B costs ₹2 per request in every usage tier.

Plan B is strictly dominated by Plan A. If Plan B ties A in one tier but costs more in another, B is weakly dominated.

### Small example

| Row player \ Column player | L | C | R |
|---|---:|---:|---:|
| **A** | (4, 1) | (2, 3) | (3, 2) |
| **B** | (2, 0) | (1, 4) | (0, 1) |
| **C** | (5, 2) | (0, 2) | (4, 0) |

Compare Row's `A` and `B` payoffs:

- Against L: 4 > 2.
- Against C: 2 > 1.
- Against R: 3 > 0.

Therefore `B` is strictly dominated by `A`. `A` does not dominate `C`, because `C` is better against L and R while `A` is better against C.

### Step-by-step explanation

1. Analyze one player at a time.
2. Select the suspected dominated strategy.
3. Compare it with each other pure strategy, coordinate by coordinate.
4. If no pure strategy dominates it, consider whether a mixture does.
5. Classify the relationship as strict, weak, equivalent, or incomparable.
6. Do not confuse “low absolute payoff” with domination; comparison must hold against the same opponent action.

## 3. Important Subtopics

### 3.1 Strictly dominated strategies

A strictly dominated strategy loses in every contingency. It is never a best response to any belief over opponent actions and cannot receive positive probability in a Nash equilibrium.

This is the cleanest elimination case and the usual starting point in interviews.

### 3.2 Weakly dominated strategies

A weakly dominated strategy never wins against its dominator and loses somewhere, but it may tie in the state the player expects. Therefore it can still be a best response and can appear in a Nash equilibrium.

This subtlety explains why deleting weakly dominated strategies is less safe.

### 3.3 Pure-strategy domination

A pure strategy dominates another by itself. In a matrix, compare corresponding entries in two rows for the row player or two columns for the column player.

This is computationally simple and is usually all that introductory questions require unless mixed dominance is explicitly mentioned.

### 3.4 Domination by a mixed strategy

No single action may dominate a strategy, while a randomized combination does.

Example payoffs for the row player:

| Strategy | L | R |
|---|---:|---:|
| A | 4 | 0 |
| B | 0 | 4 |
| C | 1 | 1 |

Neither A nor B dominates C. A 50–50 mixture of A and B gives expected payoff `(2, 2)`, which strictly dominates C's `(1, 1)`.

The common interview angle is: “Did your elimination algorithm check only pure dominators?”

### 3.5 Never-best-response interpretation

Every strictly dominated strategy is never a best response. In finite two-player games, a pure strategy is strictly dominated by some mixed strategy if and only if it is never a best response to any belief over the opponent's actions.

Weak domination does not have the same equivalence because ties can make the dominated strategy a best response.

## 4. Real-World Example

### Backend retry policy selection

Suppose a backend chooses among retry policies under three network conditions:

| Policy | Stable | Temporary outage | Long outage |
|---|---:|---:|---:|
| No retry | 8 | 0 | 0 |
| One bounded retry | 8 | 7 | -1 |
| Infinite retry | 7 | 5 | -10 |

Assume payoff combines latency, success rate, and resource cost.

- Infinite retry is strictly dominated by one bounded retry: `8 > 7`, `7 > 5`, and `-1 > -10`.
- No retry and one bounded retry are incomparable: bounded retry helps during temporary outages but has a small cost during long outages.

This illustrates a practical rule: discard a policy only if the comparison holds under every modeled condition. “Looks bad on average” is not dominance; it is an expected-value judgment that depends on probabilities.

## 5. Diagrams / Mental Models

```text
                     Is another strategy never worse?
                              /          \
                            no            yes
                            |              |
                       not dominated   Is it better somewhere?
                                          /       \
                                        no         yes
                                        |           |
                                  payoff-equivalent weakly dominated

If it is better everywhere -> strictly dominated.
```

| Test | Strictly dominated | Weakly dominated | Low expected payoff |
|---|---:|---:|---:|
| State-by-state comparison | Yes | Yes | No |
| Requires probabilities | No | No | Yes |
| Can be a best response | No | Sometimes | Sometimes |
| Safe to remove for Nash search | Yes | Not always | No |

## 6. Common Interview Questions

### Q1. What is a dominated strategy?

**Answer:** It is a strategy for which another pure or mixed strategy yields at least as much payoff against every opponent action and satisfies the relevant strict-improvement condition.

**Expected:** State whose payoff is compared and against what. **Common mistake:** Calling the globally lowest payoff action dominated without state-by-state comparison.

### Q2. What is the difference between strictly and weakly dominated?

**Answer:** A strictly dominated strategy loses against its dominator in every state. A weakly dominated strategy may tie in some states but never wins and loses in at least one.

**Expected:** Precise inequalities. **Common mistake:** Defining weak domination as lower average payoff.

### Q3. Can a strictly dominated strategy be part of a Nash equilibrium?

**Answer:** No. At that profile, switching to its dominator would strictly improve the player's payoff, contradicting the best-response condition.

**Expected:** One-step deviation proof. **Common mistake:** Saying only that it is “unlikely.”

### Q4. Can a weakly dominated strategy be part of a Nash equilibrium?

**Answer:** Yes. If it ties with its dominator against the equilibrium opponent action, it can still be a best response.

**Expected:** Mention ties. **Common mistake:** Applying the strict result to weak domination.

### Q5. Does a strategy with the smallest payoff in one cell have to be dominated?

**Answer:** No. It may outperform alternatives in other columns. Dominance requires a consistent state-by-state comparison.

**Expected:** Explain crossover payoffs. **Common mistake:** Ranking rows by their minimum or sum without being asked for maximin or expectation.

### Q6. Can a mixed strategy dominate a pure strategy when no pure strategy can?

**Answer:** Yes. For payoffs A=`(4,0)`, B=`(0,4)`, and C=`(1,1)`, a 50–50 mix of A and B produces `(2,2)` and strictly dominates C.

**Expected:** Calculate expected payoffs. **Common mistake:** Mixing payoff coordinates without using consistent probabilities.

### Q7. How do you check domination for the column player?

**Answer:** Hold each row fixed and compare the second payoff across columns. A column dominates another if the column player's relevant inequality holds in every row.

**Expected:** Second coordinate and vertical comparison. **Common mistake:** Comparing the first coordinate.

### Q8. Is a never-best-response strategy always dominated?

**Answer:** In a finite two-player game, a pure strategy that is never a best response to any belief is strictly dominated by a mixed strategy. The statement requires qualifications in more general settings.

**Expected:** Mention mixed domination and finite-game assumptions. **Common mistake:** Insisting a pure dominator must exist.

### Q9. Does positive affine transformation change domination?

**Answer:** No. Replacing utility with (a u+b), where (a>0), preserves all payoff comparisons.

**Expected:** Preference ordering is unchanged. **Common mistake:** Allowing (a<0).

### Q10. Is risk dominance the same as a dominated strategy?

**Answer:** No. Risk dominance compares equilibria in coordination games by robustness to uncertainty. Strategic domination compares a player's actions pointwise against opponent actions.

**Expected:** Separate equilibrium selection from action elimination. **Common mistake:** Treating all uses of “dominance” as the same concept.

## 7. Deep-Dive Questions

### 1. How can linear programming detect mixed domination?

For a candidate strategy `C`, assign probabilities (p_k) to the other strategies. Require (p_k \ge 0), (sum p_k=1), and for every opponent action (j),

\[
\sum_k p_k u_i(k,j) \ge u_i(C,j)+\epsilon.
\]

Maximize (epsilon). If the optimum is positive, the mixture strictly dominates `C`.

### 2. Why can no strictly dominated strategy have positive probability in mixed Nash equilibrium?

Every pure strategy in the support of a mixed best response must yield maximal expected payoff. A strict dominator yields higher payoff against every pure opponent action and thus against the equilibrium mixture, so the dominated action cannot be payoff-maximizing.

### 3. Is dominance transitive?

Yes for a fixed type of pointwise inequality. If A strictly dominates B and B strictly dominates C, then A strictly dominates C. Similar reasoning holds for weak dominance with attention to the strict-somewhere convention.

### 4. Can adding an opponent strategy make an existing strategy dominated?

It can destroy an existing dominance relationship because the dominator may perform worse in the new column. Merely adding a column cannot create direct pointwise dominance between two rows that previously crossed, because the old counterexample remains. Changing or removing columns can create dominance.

### 5. Why is weak domination belief-sensitive from a rationality perspective?

If a player assigns zero probability to every state where the dominator is strictly better, both actions have equal expected utility. Thus weakly dominated play can still maximize expected payoff under some beliefs, unlike strictly dominated play.

## 8. Comparison Tables

| Strategy status | Against every opponent action | Best-response possibility | Nash support |
|---|---|---:|---:|
| Strictly dominated | Another strategy is strictly better | Never | No |
| Weakly dominated | Another is never worse and sometimes better | Possible on ties | Possible |
| Undominated | No qualifying dominator | Possible, not guaranteed | Possible, not guaranteed |
| Dominant | It dominates all alternatives | Always a best response | Yes when selected with others' best responses |

| Pure domination | Mixed domination |
|---|---|
| One action is the dominator | A probability distribution is the dominator |
| Simple cell-by-cell scan | Requires expected payoff inequalities |
| Easier to detect | Finds more dominated strategies |
| May miss convex combinations | Uses the convex hull of payoff vectors |

## 9. Common Mistakes

- Comparing payoff sums, averages, or maxima instead of corresponding states.
- Looking at the wrong payoff coordinate.
- Declaring a strategy dominated because it loses in most—but not all—states.
- Ignoring mixed-strategy domination.
- Believing every undominated strategy appears in some Nash equilibrium.
- Believing every weakly dominated strategy is excluded from Nash equilibrium.
- Confusing dominated strategy with Pareto-dominated outcome.
- Confusing strategic dominance with risk dominance.

## 10. Edge Cases / Special Cases

- Identical payoff strategies are equivalent; terminology depends on whether strict improvement somewhere is required.
- A strategy can be dominated after some opponent strategies are eliminated even if it was not dominated initially.
- Domination is player-specific; one player's poor payoff does not determine another's action status.
- A mixture using the candidate strategy itself is unnecessary when testing whether that candidate is dominated; its weight can be removed and the remaining probabilities renormalized when strict improvement exists.
- In zero-sum games, domination can be checked on a single payoff matrix because the second player's payoff is its negative.
- In continuous games, dominance may require inequalities over infinitely many actions and often uses calculus or convexity.

## 11. How to Explain in Interview

> A dominated strategy has another pure or mixed strategy that performs better in every relevant contingency—strictly better everywhere for strict domination, or never worse and better somewhere for weak domination. Strictly dominated strategies are never best responses and cannot appear in Nash equilibrium; weakly dominated ones can appear because of ties.

## 12. Quick Revision Notes

- Dominated describes the inferior action; dominant describes the superior one.
- Strict: loses everywhere.
- Weak: never wins, ties somewhere, loses somewhere.
- Strictly dominated ⇒ never a best response ⇒ absent from Nash support.
- Weakly dominated may be a best response on a tie.
- Check pure dominators first, then mixtures if required.
- Trap: low expected payoff is not the same as domination.

## 13. Practice Tasks

1. For five custom matrices, mark every strictly and weakly dominated row and column.
2. Construct payoff vectors where pairwise pure comparison finds nothing but a 50–50 mixture dominates one action.
3. Implement a C++ pure-domination checker with time complexity (O(m^2n+n^2m)) for an (m \times n) two-player game.
4. Prove a strictly dominated strategy cannot be in the support of a mixed Nash equilibrium.
5. Design a retry-policy payoff table and explain why average performance is insufficient for dominance.
6. Find a game where an initially undominated strategy becomes dominated after another player's strategy is removed.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Another strategy beats or matches it state by state |
| Strictly dominated | Worse everywhere |
| Weakly dominated | Never better and worse somewhere |
| Nash fact | Strictly dominated strategies cannot be used |
| Advanced check | A mixture may dominate when no pure action does |
| Main trap | Dominated action ≠ Pareto-dominated outcome |
| One-line answer | “There is another policy I can switch to that is never worse and meets the required strict gain.” |

---

# Iterated Elimination of Dominated Strategies

## 1. Overview

**Iterated elimination of dominated strategies (IEDS)** repeatedly removes dominated actions from a game. Each removal creates a smaller game; strategies that were not dominated initially may become dominated after irrelevant opponent actions disappear.

Two main versions are:

- **IESDS:** iterated elimination of strictly dominated strategies.
- **IEWDS:** iterated elimination of weakly dominated strategies.

The method matters because it converts repeated assumptions of rationality into a mechanical solving process. If only one strategy remains for each player, the game is **dominance solvable**.

It is useful in auctions, market-entry games, voting, bargaining, security-resource allocation, and algorithmic game solving. Interviewers ask candidates to trace elimination correctly, justify every deletion using the current reduced game, and explain why strict and weak elimination have different guarantees.

## 2. Core Idea

### Intuition

First remove actions a rational player would never choose. Once everyone knows those actions will not occur, new actions may become unattractive. Repeating this reasoning models layers of mutual knowledge of rationality.

### Real-world analogy

Imagine shortlisting backend designs:

1. Remove a design that is slower, costlier, and less reliable in every load condition.
2. Once that design is gone, a deployment mode that existed only to support it becomes pointless.
3. Removing that mode may make another design clearly inferior.

The comparison changes because the feasible scenarios shrink.

### Small example

| Player 1 \ Player 2 | L | C | R |
|---|---:|---:|---:|
| **U** | (3, 2) | (2, 1) | (1, 0) |
| **M** | (2, 3) | (1, 2) | (0, 1) |
| **D** | (0, 0) | (0, 4) | (2, 3) |

Step 1: For Player 2, compare C and R using the second payoffs:

- At U: C gives 1, R gives 0.
- At M: C gives 2, R gives 1.
- At D: C gives 4, R gives 3.

So R is strictly dominated by C; remove R.

Step 2: In the reduced columns `{L, C}`, compare Player 1's U and M:

- Against L: U gives 3 > 2.
- Against C: U gives 2 > 1.

So M is strictly dominated by U; remove M.

Step 3: In rows `{U, D}`, compare Player 2's L and C:

- At U: L gives 2 > 1.
- At D: C gives 4 > 0.

Neither dominates the other, so strict elimination stops. The method can simplify a game without solving it completely.

### Step-by-step procedure

1. Search all players for a dominated strategy in the current game.
2. Record the dominator and the inequalities proving domination.
3. Remove the dominated strategy only.
4. Recompute comparisons in the reduced game.
5. Repeat until no qualifying strategy remains.
6. Analyze the surviving game for Nash equilibria if more than one profile remains.

## 3. Important Subtopics

### 3.1 Iterated strict elimination

Eliminating strictly dominated strategies is robust. In finite games, the final reduced game is order-independent in the relevant sense, and no Nash equilibrium is lost. A strategy may be dominated by a pure strategy or, under the broader method, by a mixed strategy.

Interviewers expect the candidate to say which version they are using.

### 3.2 Iterated weak elimination

Weak deletion is more aggressive but less safe. Different valid deletion orders can leave different reduced games, and weak deletion can remove a Nash equilibrium.

Therefore every weak elimination trace should explicitly state its order and should not claim preservation of all equilibria.

### 3.3 Newly dominated strategies

A strategy can become dominated only after an opponent's action disappears. The opponent action may have been the single column where the strategy outperformed its future dominator.

This is the main reason the procedure is iterative rather than a one-pass scan.

### 3.4 Dominance solvability

A game is dominance solvable if repeated elimination leaves exactly one action for each player. Under strict elimination, the surviving profile is the unique Nash equilibrium of the original finite game.

If multiple strategies survive, IEDS has still produced useful reduction but not a complete solution.

### 3.5 Epistemic interpretation

The first round removes actions inconsistent with rationality. The second round assumes players are rational and know others are rational. Further rounds reflect deeper mutual knowledge. This links an algorithmic process to game-theoretic beliefs.

### 3.6 Pure versus mixed dominators

Pure-strategy IEDS is easy to perform manually but may stop too early. Allowing mixed dominators can remove additional strategies. An interview answer should not silently move between these definitions.

## 4. Real-World Example

### Market entry and cloud pricing

Consider three pricing choices for a new cloud provider and three incumbent responses. A “premium price with fewer features” strategy may initially survive because one unusual incumbent response makes it profitable. If that incumbent response is strictly dominated—perhaps it loses money under every entrant price—it is removed. Without that column, the premium strategy may become strictly dominated by a standard price.

A decision-support backend can apply this reduction before running more expensive equilibrium or optimization routines:

```text
Raw strategic choices
        |
        v
Remove provably inferior policies
        |
        v
Recalculate comparisons
        |
        v
Run equilibrium search on smaller game
```

The practical warning is that real payoff models are estimates. A strategy should not be deleted as “strictly dominated” when uncertainty intervals overlap; otherwise modeling error can erase a genuinely useful option.

## 5. Diagrams / Mental Models

### Elimination loop

```text
+--------------------------+
| Current reduced game     |
+------------+-------------+
             |
             v
   Find dominated strategy? ---- no ----> Stop
             |
            yes
             |
             v
   Remove it and document proof
             |
             +---------------------------> repeat
```

### Example trace notation

```text
G0: rows {U,M,D}, columns {L,C,R}
R removed: C strictly dominates R for Player 2
G1: rows {U,M,D}, columns {L,C}
M removed: U strictly dominates M for Player 1
G2: rows {U,D}, columns {L,C}
No further strict dominance
```

| Property | Strict IEDS | Weak IEDS |
|---|---:|---:|
| Removes all original Nash equilibria? | No | Can remove some |
| Generally order-independent in finite games | Yes | No |
| Allows ties in domination test | No | Yes |
| May expose new domination | Yes | Yes |
| Requires equilibrium analysis if several survive | Yes | Yes |

## 6. Common Interview Questions

### Q1. What is iterated elimination of dominated strategies?

**Answer:** It repeatedly deletes a player's dominated strategy, recomputes dominance in the reduced game, and stops when no further strategy qualifies.

**Expected:** Emphasize recomputation. **Common mistake:** Removing only strategies dominated in the original matrix.

### Q2. Why can a strategy become dominated later?

**Answer:** An opponent action that prevented domination may be removed. On the smaller set of possible opponent actions, another strategy can now be better in every remaining case.

**Expected:** Explain changed comparison domain. **Common mistake:** Thinking the payoffs themselves change.

### Q3. Does elimination of strictly dominated strategies preserve Nash equilibria?

**Answer:** Yes. A strictly dominated strategy cannot be a best response, so it cannot be played with positive probability in a Nash equilibrium. Deleting it therefore preserves the original game's Nash equilibria among surviving strategies.

**Expected:** Best-response justification. **Common mistake:** Extending the claim to weak elimination.

### Q4. Is strict elimination order-independent?

**Answer:** For finite games under the standard process, iterated elimination of strictly dominated strategies has an order-independent reduced outcome, with appropriate care about whether domination by mixed strategies is allowed.

**Expected:** State assumptions. **Common mistake:** Claiming every elimination notion is order-independent.

### Q5. Why is weak elimination order-dependent?

**Answer:** Removing a strategy can erase the only state where one remaining strategy was strictly better than another, or can alter which ties matter. Different valid first deletions can therefore enable or disable later weak deletions.

**Expected:** Tie-based explanation. **Common mistake:** Saying order matters merely because matrix size changes.

### Q6. Can weak elimination remove a Nash equilibrium?

**Answer:** Yes. A weakly dominated strategy can still be a best response when it ties with its dominator against the equilibrium action, so a Nash equilibrium may use it.

**Expected:** Connect ties to best responses. **Common mistake:** Assuming all dominated strategies are absent from equilibrium.

### Q7. What does dominance solvable mean?

**Answer:** Repeated elimination leaves one strategy for each player, producing a unique surviving action profile. Under strict elimination in a finite game, that profile is the unique Nash equilibrium.

**Expected:** One strategy per player and the strictness qualification. **Common mistake:** Calling any partially reduced game solved.

### Q8. Do surviving strategies necessarily form a Nash equilibrium?

**Answer:** Not by themselves. If several actions survive, some may not participate in any Nash equilibrium. IEDS filters strategies; it does not generally finish equilibrium computation.

**Expected:** Separate rationalizability-style survival from equilibrium. **Common mistake:** Declaring all surviving cells equilibria.

### Q9. What is the complexity of naive pure-strategy elimination?

**Answer:** For each round, comparing all row pairs across columns and all column pairs across rows costs roughly (O(m^2n+n^2m)); up to (m+n) deletions gives a straightforward polynomial-time implementation for a two-player matrix.

**Expected:** Reasonable comparison count, not necessarily a memorized bound. **Common mistake:** Claiming simple IEDS directly computes all mixed Nash equilibria.

### Q10. How would you present an elimination answer on a whiteboard?

**Answer:** Cross out one row or column at a time, state the player, name the dominator, show all relevant inequalities, and label whether the comparison is strict, weak, pure, or mixed.

**Expected:** Auditable reasoning. **Common mistake:** Crossing out multiple actions without proof or comparing the wrong payoff coordinate.

## 7. Deep-Dive Questions

### 1. Give the epistemic meaning of repeated strict elimination.

Round one assumes each player is rational. Round two assumes each is rational and believes others are rational. Round (k) adds further levels of mutual belief. Strategies surviving all rounds are consistent with common belief in rationality; in finite games this connects to rationalizability, especially when mixed-strategy domination is included.

### 2. Why does strict elimination preserve mixed Nash equilibria?

A strictly dominated pure strategy earns strictly less than its dominator against every opponent pure profile, hence also against every mixture by linearity of expectation. It cannot be in any best-response support, so removing it does not disturb equilibrium mixtures.

### 3. Can simultaneous versus sequential deletion matter?

For strict dominance in standard finite settings, the eventual result is robust. For weak dominance, deleting all currently weakly dominated strategies simultaneously may produce a different result from deleting one at a time, so the procedure must specify the rule.

### 4. How does IEDS relate to rationalizability?

Rationalizability eliminates strategies that are never best responses to beliefs about opponents' surviving strategies. Iterated elimination by mixed strict dominance characterizes the same surviving pure strategies in finite games. Pure-only elimination can leave more strategies because some never-best responses require mixed dominators.

### 5. What changes in infinite games?

Order independence and termination become more delicate. Elimination may require infinitely many or transfinite rounds, maxima may not exist, and continuity or compactness assumptions matter. Interview problems normally restrict attention to finite matrices unless stated otherwise.

## 8. Comparison Tables

| Method | What it removes | Safe equilibrium claim | Typical use |
|---|---|---|---|
| One-shot strict elimination | Initially strictly dominated actions | Preserves Nash equilibria | Quick simplification |
| Iterated strict elimination | Newly and initially strictly dominated actions | Preserves Nash equilibria; robust order | Standard dominance solving |
| Iterated weak elimination | Weakly dominated actions over rounds | May remove Nash equilibria | Aggressive refinement with caution |
| Best-response/rationalizability deletion | Never-best responses to beliefs | Captures rationalizable strategies | Belief-based analysis |

| IEDS | Backward induction |
|---|---|
| Used mainly in normal-form games | Used in extensive-form sequential games |
| Removes dominated actions | Solves from terminal nodes backward |
| Based on comparisons across opponent actions | Based on optimal continuation at each decision node |
| May stop with several strategies | Often selects a subgame-perfect outcome in finite perfect-information games |

| IEDS | Nash equilibrium search |
|---|---|
| Filters irrational actions | Finds mutually best responses |
| Does not require guessing an equilibrium | Requires checking response consistency |
| May not solve the game | Always targets equilibrium profiles |
| Strict version safely reduces search space | Applied after reduction when needed |

## 9. Common Mistakes

- Performing only one elimination pass.
- Comparing against strategies already removed without stating the convention.
- Removing a row based on the column player's payoffs, or vice versa.
- Treating weak elimination as order-independent.
- Claiming weak elimination preserves every Nash equilibrium.
- Removing a strategy that is better in one remaining state because it looks poor overall.
- Failing to say whether mixed strategies may serve as dominators.
- Assuming every surviving strategy belongs to an equilibrium.
- Calling a reduced game “solved” when multiple actions remain.
- Erasing several rows at once without recording the dominance proof.

## 10. Edge Cases / Special Cases

- The process may stop immediately because no strategy is dominated.
- It may remove some strategies but leave a nontrivial subgame.
- Strictly dominance-solvable games have a unique Nash equilibrium, but a game can have a unique Nash equilibrium without being dominance solvable.
- Weak deletion may remove one equilibrium and retain another, changing equilibrium selection.
- Mixed-strategy domination can continue reduction after pure-strategy elimination stops.
- With identical strategies, the treatment depends on the weak-dominance convention.
- A cyclic-looking payoff structure such as rock-paper-scissors has no dominated pure strategies and survives unchanged.
- Numerical implementations need tolerance handling; floating-point noise should not turn equality into strict inequality.

## 11. How to Explain in Interview

> Iterated elimination repeatedly removes a dominated action and then recomputes dominance in the smaller game, because new strategies can become dominated after opponent actions disappear. Strict elimination preserves Nash equilibria and is order-independent for standard finite games. Weak elimination is less robust: its result may depend on order and it can remove Nash equilibria.

## 12. Quick Revision Notes

- IEDS is a loop, not a one-time scan.
- Always identify player, dominated strategy, dominator, and inequalities.
- Strict IEDS preserves Nash equilibria.
- Weak IEDS can be order-dependent and can delete equilibria.
- One surviving strategy per player ⇒ dominance solvable.
- Several survivors ⇒ continue with best-response/Nash analysis.
- Pure-only and mixed-dominator versions can yield different reductions.
- Trap: surviving does not mean equilibrium strategy.

## 13. Practice Tasks

1. Trace IESDS on a (3 \times 3) matrix, writing the reduced game after every deletion.
2. Construct a game where no row is initially dominated but one becomes dominated after deleting a column.
3. Find a small game in which two orders of weak elimination produce different survivors.
4. Implement pure-strategy IEDS in C++ using active-row and active-column boolean arrays.
5. Add a trace that prints `player`, `removed`, `dominator`, and the payoff comparisons.
6. Test the implementation on Prisoner's Dilemma, rock-paper-scissors, and a dominance-solvable (3 \times 3) game.
7. Explain why floating-point payoffs require an epsilon and how epsilon can affect “strict” comparisons.
8. After reducing a game, compute all pure Nash equilibria in the surviving subgame and map them back to the original game.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Repeatedly delete dominated actions and recompute |
| Strict version | Safe for Nash equilibria; robust to order in finite games |
| Weak version | Can depend on order and remove equilibria |
| Solved condition | Exactly one strategy remains for each player |
| Advanced distinction | Pure versus mixed dominators |
| Most asked task | Show a correct elimination trace |
| Main trap | A surviving strategy is not automatically an equilibrium action |
| One-line answer | “Delete an inferior action, shrink the game, and repeat until no valid deletion remains.” |

