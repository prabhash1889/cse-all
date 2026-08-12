# Auction Theory for SDE Placements

Auctions are allocation algorithms for scarce resources. The seller defines rules, bidders submit actions, and the mechanism determines a winner and payment. Throughout this guide, a bidder with value `v`, bid `b`, and payment `p` has quasi-linear utility `u = v - p` if they win and `0` if they lose, unless stated otherwise.

---

# First-Price Auction

## 1. Overview

A **first-price sealed-bid auction** asks every bidder to submit one private bid. The highest bidder wins and pays their own bid. It matters because the allocation rule is simple but bidding is strategic: bidding one's true value can destroy all surplus. Procurement, advertising, spectrum sales, and online marketplaces use first-price or reverse first-price variants. Interviewers use it to test utility modeling, best responses, equilibrium, and the distinction between a bid and a valuation.

## 2. Core Idea

The bidder balances two forces: a higher bid raises the probability of winning, while a lower bid raises profit conditional on winning. This is **bid shading**.

Analogy: a buyer values a limited-edition device at Rs. 10,000. Offering Rs. 10,000 may win but leaves zero gain; offering Rs. 7,000 creates Rs. 3,000 surplus if rivals bid less, but risks losing.

Example: values are A=100, B=80, C=60; bids are 76, 70, 55. A wins, pays 76, and gets utility `100-76=24`.

Step by step:

1. Each bidder estimates a private value and beliefs about rivals.
2. Each chooses one bid without seeing the others.
3. The auction ranks bids and applies a tie rule.
4. The highest bidder receives the item.
5. The winner pays their bid; losers pay zero.
6. A rational bidder shades below value in the standard independent-private-values model.

For `n` risk-neutral bidders whose values are i.i.d. uniform on `[0,1]`, the symmetric Bayesian Nash equilibrium is `b(v) = ((n-1)/n)v`. More competition reduces shading.

## 3. Important Subtopics

### Bid shading

**Meaning:** bidding below value. **Why:** it preserves winner surplus. **Example:** with two uniform bidders, value 0.8 implies equilibrium bid 0.4. **Interview angle:** explain why truthful bidding is generally not dominant.

### Bayesian Nash equilibrium

**Meaning:** a bidding rule is optimal given beliefs about unknown rival values and assuming rivals use equilibrium rules. **Why:** the game has incomplete information. **Example:** `b(v)=((n-1)/n)v` under the uniform benchmark. **Interview angle:** identify assumptions before quoting a formula.

### Reserve price and ties

**Meaning:** the seller may reject bids below a minimum; equal top bids require a deterministic or random tie-break. **Why:** both alter winning probabilities and revenue. **Example:** top bid 70 below reserve 75 means no sale. **Interview angle:** never silently assume a sale or an unspecified tie winner.

### Risk attitudes and competition

Risk-averse bidders usually shade less because losing is more painful; more bidders also reduces shading. These effects matter in practical auction tuning. An interviewer expects qualitative reasoning, not an unjustified universal formula.

## 4. Real-World Example

An ad exchange can ask advertisers for a maximum cost-per-click bid, score eligible ads, and charge the winner its effective bid. Production systems also incorporate quality scores, budgets, pacing, reserve prices, and fraud controls. The pure first-price model explains the strategic core; the engineering system must make ranking, payment, tie-breaking, and audit logs deterministic.

## 5. Diagrams / Mental Models

```text
private value v -> choose shaded bid b -> rank all bids
                                      -> lose: utility 0
                                      -> win: utility v - b
```

| Bid choice | Winning chance | Profit if winning | Main risk |
|---|---:|---:|---|
| Low | Low | High | Lose profitable item |
| Near value | High | Low | Winner's surplus vanishes |
| Above value | Higher | Negative possible | Overpay |

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Who wins and pays what?** Highest bid wins and pays its own bid, subject to reserve and tie rules. | Allocation plus payment rule | Saying second-highest price |
| 2 | **Is truthful bidding dominant?** No; a winner can often lower its bid and still win, increasing utility. | Bid shading | Confusing value with bid |
| 3 | **Why not bid above value?** Winning at `b>v` yields negative utility. Under standard assumptions it is weakly dominated. | `u=v-b` | Ignoring the losing case |
| 4 | **Why not bid zero?** It maximizes profit only if it wins, but normally makes winning unlikely. | Probability-profit trade-off | Optimizing conditional profit alone |
| 5 | **What is the uniform equilibrium bid?** For `n` risk-neutral i.i.d. uniform bidders, `b(v)=(n-1)v/n`. | State assumptions | Treating formula as universal |
| 6 | **Effect of more bidders?** Competition raises equilibrium bids toward values and usually raises expected revenue. | Less shading | Claiming every realized revenue rises |
| 7 | **Effect of risk aversion?** Bidders generally bid more aggressively because they dislike the risk of losing. | Risk changes equilibrium | Saying risk attitudes never matter |
| 8 | **What does a reserve do?** It sets a minimum acceptable bid, potentially increasing revenue but causing no-sale outcomes. | Revenue/allocation trade-off | Calling reserve a starting bid only |
| 9 | **How are ties handled?** By a stated random or deterministic rule; the rule is part of the mechanism. | Explicit edge behavior | Assuming ties have probability zero in code |
| 10 | **How would you implement it?** Track the best eligible bid and tie candidates in one pass, then compute payment from the winning bid. | O(n), validation, deterministic tie rule | Sorting unnecessarily or using float equality carelessly |

## 7. Deep-Dive Questions

1. **Derive the two-bidder uniform equilibrium.** Suppose the rival uses `b(x)=x/2`. A type `v` mimicking type `x` wins with probability `x` and earns `(v-x/2)x`. Differentiating gives `v-x=0`, so `x=v` and `b(v)=v/2`.
2. **Why is equilibrium Bayesian?** A bidder knows its type but not rival types; optimality is computed in expectation over the known value distribution.
3. **Can asymmetric bidders use the same formula?** Not generally. Different value distributions, budgets, or information lead to asymmetric bidding functions.
4. **Does highest value always win?** In a symmetric monotone equilibrium, yes, because bids increase with values. Outside that setting, constraints or asymmetric strategies can break efficiency.
5. **What changes in procurement?** Lowest bid wins a contract and is paid its bid. A supplier shades upward from cost rather than a buyer shading downward from value.

## 8. Comparison Tables

| Feature | First-price | Second-price |
|---|---|---|
| Winner | Highest bidder | Highest bidder |
| Payment | Own bid | Second-highest eligible bid |
| Standard strategy | Shade below value | Bid true value |
| Strategic burden | Estimate rivals | Value item accurately |
| Truthful dominant strategy | No | Yes, under standard assumptions |

## 9. Common Mistakes

- Treating bid, value, payment, and utility as synonyms.
- Claiming every bidder should use the uniform-distribution formula.
- Maximizing surplus conditional on winning while ignoring win probability.
- Forgetting reserves, ties, budgets, and negative utility from overbidding.
- Calling a symmetric Bayesian equilibrium a dominant strategy.

## 10. Edge Cases / Special Cases

With one eligible bidder, the reserve effectively sets the price. Discrete bid increments create positive-probability ties. Budget constraints can make a bidder unable to express full value. Correlated or common values introduce inference and winner's-curse effects. Risk-seeking bidders may shade more. Collusion can suppress bids. A bidder may bid above value for external strategic reasons, but not in the standard isolated private-value model.

## 11. How to Explain in Interview

“In a first-price sealed-bid auction, the highest bid wins and pays its own bid. Because utility is value minus payment, bidders trade off a greater winning probability against greater surplus and typically shade below value. The exact equilibrium depends on the number of bidders, value distribution, and risk assumptions.”

## 12. Quick Revision Notes

- Rule: highest bid wins; winner pays own bid.
- Core tension: win probability versus profit margin.
- Benchmark: `b(v)=(n-1)v/n` only for i.i.d. uniform, risk-neutral bidders.
- More competition or risk aversion generally means less shading.
- Trap: equilibrium bidding is not truthful or dominant.

## 13. Practice Tasks

1. Compute winners, payments, and utilities for five bid profiles with a reserve.
2. Derive the two-bidder uniform equilibrium using expected utility.
3. Write a C++ function returning winner, payment, and tie status in `O(n)`.
4. Simulate uniform values and compare revenue for 2, 5, and 20 bidders.
5. Convert the mechanism into a reverse procurement auction.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Highest bid wins and pays its bid |
| Why it matters | Canonical strategic allocation mechanism |
| Most asked | Why shade? What assumptions yield `(n-1)v/n`? |
| Main comparison | First-price needs shading; Vickrey supports truth telling |
| One-line answer | “Win with the highest bid, pay your bid, so bid strategically below value.” |

---

# Second-Price / Vickrey Auction

## 1. Overview

A **second-price sealed-bid auction**, or **Vickrey auction**, awards the item to the highest bidder but charges the second-highest eligible bid. Under independent private values, quasi-linear utility, and no externalities, bidding one's true value is a weakly dominant strategy. This truthful mechanism is foundational in mechanism design and appears in ad-market history, allocation systems, and VCG mechanisms. Interviewers ask about it because a short case analysis reveals whether a candidate understands incentives rather than merely rules.

## 2. Core Idea

Your bid decides whether you win, but—except through ties—does not determine what you pay. The critical price is the highest rival bid `m`.

- If `v>m`, you want to win; any winning bid gives utility `v-m>0`.
- If `v<m`, you want to lose; winning would give `v-m<0`.
- Bidding `b=v` makes exactly the right decision in both cases.

Example: values A=100, B=75, C=40 and truthful bids. A wins, pays 75, and earns 25. A could bid 1,000 without changing payment, but doing so is unnecessary and dangerous if its bid exceeds its true value in another profile.

## 3. Important Subtopics

### Truthfulness and weak dominance

Truthful bidding never gives lower utility than another bid for any rival-bid profile, although alternatives can tie it. It matters because participants need not forecast competitors. Interview angle: prove it by comparing `v` with the maximum rival bid, not by saying “the second price is fair.”

### Critical-value payment

The winner pays the threshold it had to beat, not its declared value. This separates allocation from payment and is the basic mechanism-design pattern behind truthful single-parameter auctions.

### Efficiency

Truthful bids make the highest-value bidder win, maximizing allocative welfare for one indivisible item. Efficiency does not mean maximum revenue or fairness.

### Assumption failures

Externalities, collusion, budgets, common values, identity manipulation, or repeated interaction can weaken simple truthfulness claims. These are frequent advanced interview angles.

## 4. Real-World Example

A cloud scheduler allocates one temporary high-memory machine. Services report their value for receiving it, the highest report wins, and internal credits charged equal the next-highest report. Truthful reporting simplifies each service's decision. A real implementation must authenticate bidders, enforce one identity, specify reserves/ties, and prevent the auctioneer from inventing a fake second bid.

## 5. Diagrams / Mental Models

```text
your value v versus highest rival bid m

v > m  -> winning is profitable -> truthful bid wins -> pay m
v < m  -> winning is harmful    -> truthful bid loses -> pay 0
v = m  -> indifferent           -> tie rule applies
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **What are the rules?** Highest eligible bid wins and pays the second-highest eligible bid or defined reserve. | Allocation/payment separation | Winner pays own bid |
| 2 | **Why bid truthfully?** It ensures winning exactly when value exceeds the critical rival bid. | Two-case proof | “Because payment ignores bid” without cases |
| 3 | **Is truth telling strictly dominant?** No, weakly dominant; many bids produce the same outcome for some rival profiles. | Strict vs weak | Calling it strictly dominant |
| 4 | **Can overbidding hurt?** Yes; it may win when the second bid exceeds value, causing negative utility. | Counterexample | Saying the own bid never matters |
| 5 | **Can underbidding hurt?** Yes; it may lose when the rival price is below value, forfeiting positive surplus. | Counterexample | Looking only at payment |
| 6 | **Is the result efficient?** With truthful private values, the highest-value bidder wins. | Allocative efficiency | Equating efficiency with revenue |
| 7 | **What if only one bidder exists?** Payment needs a defined reserve/minimum; “second price” otherwise is undefined. | Mechanism completeness | Assuming zero without specification |
| 8 | **What about ties?** A declared tie-break rule chooses among top bids; truthfulness remains weak under standard neutral rules. | Tie policy | Ignoring tie probability in discrete bids |
| 9 | **Can bidders collude?** Yes. A losing bidder may suppress the second price, so collusion can reduce revenue. | Strategic interaction beyond unilateral deviation | Treating dominant strategy as collusion-proof |
| 10 | **How does a reserve work?** Winner pays `max(reserve, second-highest bid)` if the top bid meets reserve. | Eligibility and price | Charging reserve even when top bid is below it |

## 7. Deep-Dive Questions

1. **Give the formal dominance proof.** Fix rivals and let `m` be their maximum bid. If `v>m`, truthful bidding wins profitably; underbidding can only lose that gain, while overbidding adds none. If `v<m`, truth loses correctly; overbidding can cause a loss, while lower losing bids tie truth.
2. **Why can revenue match first-price despite different payments?** In the standard symmetric benchmark, first-price bidders shade; in second-price they bid values. Equilibrium expected payments can therefore coincide.
3. **Does truthfulness survive a bidder valuing rival loss?** No. Externalities make utility depend on who wins, so the simple single-value proof fails.
4. **How is Vickrey related to VCG?** Vickrey is the one-item special case of VCG, where a winner pays the externality imposed on others.
5. **Why might platforms avoid pure Vickrey auctions?** Credibility of the second bid, collusion, complex multi-slot allocation, budgets, pacing, and revenue goals complicate deployment.

## 8. Comparison Tables

| Feature | Vickrey | English |
|---|---|---|
| Bid process | One sealed bid | Open ascending bids |
| Information revealed | Limited | Dropout/price information |
| Standard private-value outcome | Highest value wins near second value | Same |
| Dominant intuition | Report value | Stay until price reaches value |
| Common-value behavior | Less information during bidding | Information can reduce winner's curse |

## 9. Common Mistakes

- Saying the winner pays the second-highest **value** rather than bid.
- Claiming truthfulness without stating private values and utility assumptions.
- Calling truth telling strictly dominant.
- Believing overbidding is harmless because payment is not one's bid.
- Treating dominant-strategy truthfulness as collusion-proof or revenue-optimal.

## 10. Edge Cases / Special Cases

A reserve may replace a missing or low second bid. Discrete bids require tie handling. False-name bids can manipulate multi-item variants. If the seller can observe bids and lie about the runner-up, participants need verifiability. In common-value settings, truthful bidding refers to one's information-dependent expected value, not an unknowable realized value, and inference still matters.

## 11. How to Explain in Interview

“A Vickrey auction gives the item to the highest bidder but charges the second-highest bid. Fix the highest rival bid as a threshold: I want to win exactly when my value exceeds it, so bidding my value is weakly dominant. Under private values this also allocates the item efficiently.”

## 12. Quick Revision Notes

- Winner: highest bidder. Payment: critical/second bid.
- Truthful bidding is **weakly**, not strictly, dominant.
- Underbidding can lose a profitable win; overbidding can create a harmful win.
- Truthfulness simplifies strategy but does not guarantee maximum revenue.
- Reserve payment: usually `max(reserve, second bid)`.

## 13. Practice Tasks

1. Prove truthfulness using `v` and highest rival bid `m`.
2. Generate counterexamples showing harms from overbidding and underbidding.
3. Implement a one-pass top-two-bids algorithm with duplicate maxima.
4. Add reserve, eligibility, and deterministic tie behavior.
5. Explain Vickrey as a critical-value mechanism to a peer in 60 seconds.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Highest bid wins; pays second-highest eligible bid |
| Why it matters | Canonical truthful mechanism |
| Most asked | Prove truthfulness; explain weak dominance |
| Main comparison | Same private-value outcome as an English auction |
| One-line answer | “Bid your value: your bid selects win/loss, while the rival threshold sets price.” |

---

# English Auction

## 1. Overview

An **English auction** is an open, ascending-price auction. The price rises through bids or by an auctioneer's clock until only one bidder remains; that bidder wins and typically pays the final price. It matters because it is intuitive, observable, and performs price discovery. Art, collectibles, livestock, property, and online marketplaces use variants. Interviewers ask how dynamic information, dropout behavior, and strategic equivalence differ from sealed-bid formats.

## 2. Core Idea

In a private-value auction, a bidder can remain active while price is below value and drop out when price reaches value. Leaving earlier risks missing positive surplus; staying beyond value risks overpayment.

Example: bidder values are 100, 75, and 40. C exits near 40, B exits near 75, and A wins at approximately 75 plus the minimum increment. The outcome resembles a Vickrey auction, although the dynamic process reveals more information.

Steps: register bidders; announce starting price; accept higher bids/increase clock; mark dropouts; stop when one remains or time expires; validate reserve and increments; settle winner/payment.

## 3. Important Subtopics

### Ascending clock versus open outcry

An auctioneer may raise a common clock until bidders exit, or bidders may submit successively higher offers. Both are English-style, but exact final price and timing rules differ. Interviewers expect the mechanism to be specified precisely.

### Dropout strategy

With private values, remain until the price reaches value. This maps each value to a stopping threshold and yields efficient allocation.

### Price discovery and information revelation

Observed bidding reveals willingness to pay. In common-value settings, rivals' continued participation or exit contains information and may mitigate winner's-curse risk.

### Increments, soft close, and sniping

Minimum increments limit event volume but make price discrete. Online systems often extend the deadline after late bids (“soft close”) to preserve the ascending process; fixed deadlines can encourage sniping.

## 4. Real-World Example

An online marketplace stores a current leader, current price, minimum next bid, and closing time. Each accepted bid is an atomic conditional update to prevent two bidders from simultaneously becoming leader. A proxy-bidding implementation can automatically bid up to a user's maximum; externally it looks ascending, while internally maximum bids may be processed with second-price-like logic.

## 5. Diagrams / Mental Models

```text
price 0 ---- 40 ---- 75 ---- 100
               C exits  B exits   A's limit
                         |
                         +-- A wins around second-highest value
```

| Event | State change | Engineering concern |
|---|---|---|
| Valid higher bid | Leader/price update | Atomicity |
| Dropout | Active set shrinks | Irreversibility rule |
| Late bid | May extend close | Clock consistency |
| One remains | Finalize | Idempotent settlement |

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **What defines an English auction?** Publicly observable bids or price ascend until no higher competition remains. | Dynamic ascending process | Calling any public auction English |
| 2 | **Best private-value strategy?** Stay active until price reaches value, then exit. | Stopping threshold | Bidding above value to intimidate |
| 3 | **Relation to Vickrey?** Under standard private values they yield similar allocation and a price near the second-highest value. | Outcome equivalence, not identical games | Claiming formats are identical |
| 4 | **Why is it good for price discovery?** Participants observe demand and update decisions as price rises. | Information revelation | Saying it reveals exact values |
| 5 | **What is a bid increment?** Minimum allowed increase; it bounds events but creates price granularity. | Rule and consequence | Ignoring overshoot |
| 6 | **What is a reserve?** Minimum seller-acceptable price; no sale if bidding fails to reach it. | Reserve behavior | Confusing with starting price |
| 7 | **What is sniping?** Late bidding in fixed-deadline online auctions to prevent response. | Timing incentives | Treating it as unique to English logic |
| 8 | **What is a soft close?** Extend the auction after a late bid so others can respond. | Anti-sniping mechanism | Endless extension without bounds/rules |
| 9 | **How handle concurrent bids?** Use an atomic compare-and-update/transaction and monotonic sequence ordering. | Concurrency, idempotency | Last-write-wins without validation |
| 10 | **Does public bidding always help?** No; it leaks information, enables signaling/collusion, and can create participation costs. | Trade-offs | Assuming transparency is unconditionally good |

## 7. Deep-Dive Questions

1. **Why can English auctions outperform sealed bids under common values?** Dropouts reveal signals. Remaining bidders can update estimates downward or upward instead of relying only on private signals.
2. **Is staying until value dominant?** In the ideal independent-private-value ascending-clock model, it has a dominant-strategy interpretation. Budget constraints, jump bids, externalities, and signaling complicate it.
3. **What does a jump bid communicate?** It may accelerate the auction or signal strength, but can reveal information and is not automatically optimal.
4. **How do you guarantee exactly-once settlement?** Make finalization an idempotent state transition keyed by auction ID/version; payment retries must not create duplicate charges.
5. **Can a bidder re-enter after dropping out?** The mechanism must say. Clock auctions usually prohibit re-entry because observed exit is strategically meaningful.

## 8. Comparison Tables

| Feature | English | Dutch |
|---|---|---|
| Direction | Price rises | Price falls |
| End condition | Last bidder remains | First bidder accepts |
| Information during process | Rich dropout/bid history | Little before acceptance |
| Private-value strategic cousin | Second-price | First-price |
| Typical pressure | Avoid overpaying | Avoid waiting too long |

## 9. Common Mistakes

- Assuming the final price is exactly the second-highest value despite increments.
- Treating online fixed-deadline bidding as a perfect clock auction.
- Forgetting that public histories change information and strategy.
- Ignoring concurrent updates, bid retractions, and settlement idempotency.
- Confusing starting price with reserve price.

## 10. Edge Cases / Special Cases

No bidder may meet reserve. Two bidders can exit at the same displayed price. Network latency can reorder online bids, so server receipt order must be authoritative. Proxy bidding changes visible bid dynamics. Withdrawal and re-entry rules affect manipulation. With participation costs, high-value bidders might never enter. Bid increments make the Vickrey analogy approximate.

## 11. How to Explain in Interview

“An English auction raises a public price until one bidder remains. With independent private values, each bidder can stay until the price reaches its value, so the highest-value bidder wins at roughly the second-highest value. Its distinguishing feature is dynamic information revelation.”

## 12. Quick Revision Notes

- Open, ascending, dynamic mechanism.
- Private-value rule: stay until price reaches value.
- Price discovery is useful but may enable signaling.
- English resembles Vickrey under private values, not under every information model.
- Systems concerns: atomic bidding, clocks, soft close, idempotent settlement.

## 13. Practice Tasks

1. Trace an auction with values 90, 71, 70 and increment 5.
2. Design state transitions for `OPEN -> CLOSING -> SETTLED`.
3. Implement atomic bid validation with an auction version number.
4. Compare fixed close and soft close under network latency.
5. Explain how dropout information changes a common-value estimate.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Public price rises until one bidder remains |
| Why it matters | Price discovery plus intuitive participation |
| Most asked | Strategy, Vickrey relation, sniping, concurrency |
| Main comparison | Ascending English vs descending Dutch |
| One-line answer | “Stay until value; highest value wins near the runner-up's threshold.” |

---

# Dutch Auction

## 1. Overview

A **Dutch auction** begins at a high price and continuously or discretely lowers it until the first bidder accepts; that bidder wins and pays the accepted price. It is fast and creates urgency. Flower markets, perishable-goods sales, treasury/share-allocation variants, and resource liquidation use descending mechanisms. Interviewers ask about its strategic equivalence to first-price sealed bidding and its implementation as a race.

## 2. Core Idea

Waiting produces a better price but increases the chance that someone else accepts first. A bidder therefore chooses a stopping price below value, analogous to selecting a shaded bid in a first-price auction.

Example: a bidder values an item at 100 and plans to accept at 75. If a rival accepts at 80, it loses; if no rival acts first, it wins at 75 and earns 25. The bidder cannot react after another acceptance.

Steps: announce high price; lower it by a known clock; bidders monitor; first valid acceptance atomically stops the clock; winner pays displayed price; later accepts are rejected.

## 3. Important Subtopics

### Strategic equivalence to first-price

In the standard private-value model, choosing an acceptance threshold in Dutch is strategically equivalent to submitting that threshold as a sealed first-price bid. Highest threshold accepts first and pays its threshold.

### Clock speed and latency

Clock decrement determines duration and price granularity. In distributed implementations, network delay can create unfairness; server timestamps or precommitted thresholds avoid client-location races.

### Urgency and cognitive load

Bidders must decide under time pressure without learning rivals' thresholds before the sale. This makes Dutch auctions fast but can increase errors.

### Multi-unit descending auctions

Some auctions sell units as demand arrives while price descends. Uniform versus discriminatory pricing must be specified; these are not automatically equivalent to the single-item Dutch model.

## 4. Real-World Example

A backend liquidates expiring compute reservations. It publishes a signed price schedule, accepts the first authenticated request satisfying available balance, and commits allocation/payment in one transaction. To avoid geographic latency determining the winner, users may submit a private “accept at or below X” threshold in advance, which the server evaluates against its clock.

## 5. Diagrams / Mental Models

```text
price: 120 -> 110 -> 100 -> 90 -> 80 -> 70
                                      ^
                               first ACCEPT wins

wait longer = more surplus if win + greater risk of losing
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **What are the rules?** Price descends from high level; first valid accepter wins and pays that price. | First acceptance | Saying lowest bid wins |
| 2 | **Why start high?** It ensures the clock crosses bidders' willingness-to-pay thresholds from highest downward. | Threshold ordering | Treating start as seller estimate only |
| 3 | **Optimal private-value intuition?** Accept below value at a threshold balancing surplus against losing risk. | Bid shading analogue | Always wait until zero |
| 4 | **Relation to first-price?** Acceptance thresholds correspond to sealed first-price bids under standard assumptions. | Strategic equivalence | Claiming information/timing are identical |
| 5 | **Does own action set payment?** Yes; the accepted displayed price is paid. | First-price property | Calling it second-price |
| 6 | **What if two accept together?** Apply an authoritative ordering or declared random tie rule. | Race semantics | Trusting client clocks |
| 7 | **Effect of faster clock?** Faster sale, less reaction time, potentially coarser decisions and more mistakes. | UX/strategy trade-off | Assuming equilibrium unchanged in all implementations |
| 8 | **What is latency unfairness?** Closer clients may reach the server first at the same observed price. | Distributed-systems issue | Using local timestamps as proof |
| 9 | **How prevent double allocation?** One atomic state transition from OPEN to SOLD with compare-and-swap/transaction. | Linearization point | Check-then-write race |
| 10 | **Is a treasury Dutch auction identical?** Not necessarily; multi-unit clearing-price rules differ from single-item first-acceptance Dutch auctions. | Define variant | Applying single-item results blindly |

## 7. Deep-Dive Questions

1. **Prove first-price equivalence.** Map each bidder's chosen Dutch stopping price to a sealed bid. The highest threshold is reached first, wins, and is paid as price—the same allocation and payment as first-price.
2. **Where does equivalence fail behaviorally?** Time pressure, observation of an unsold clock, latency, risk changes during the countdown, and mistakes can alter behavior though the ideal strategic form maps cleanly.
3. **How can precommitment improve fairness?** Store authenticated thresholds before the clock; the server selects the highest crossed threshold, removing reaction-time and network-location advantages.
4. **What happens with risk aversion?** As in first-price auctions, bidders generally accept earlier/higher to reduce loss risk.
5. **How do discrete decrements affect results?** The winner may pay up to one decrement away from its intended threshold; ties become more likely and clock-speed design matters.

## 8. Comparison Tables

| Feature | Dutch | First-price sealed bid |
|---|---|---|
| Action | Choose when to stop clock | Submit bid once |
| Winner | Highest stopping threshold | Highest bid |
| Payment | Accepted threshold | Own bid |
| Observation | Unsold price path | No rival information |
| Ideal private-value strategy | Same threshold/bid logic | Bid shading |

## 9. Common Mistakes

- Confusing Dutch with a reverse auction where sellers undercut one another.
- Calling the final price the lowest willingness to pay.
- Ignoring latency and atomicity in online versions.
- Extending single-item equivalence to every multi-unit Dutch variant.
- Believing waiting is free of strategic risk.

## 10. Edge Cases / Special Cases

The price can reach a floor with no acceptance. Discrete clock ticks permit simultaneous accepts. A bidder may disconnect after scheduling an acceptance. Precommitted thresholds require clear tie and cancellation rules. Multi-unit demand can create partial fills. A falling external value, such as expiring inventory, means bidder values may change during the auction.

## 11. How to Explain in Interview

“A Dutch auction starts high and lowers price until the first bidder accepts and pays that price. Waiting improves surplus but risks losing, so the acceptance threshold plays the same strategic role as a shaded bid in a first-price sealed-bid auction.”

## 12. Quick Revision Notes

- Descending clock; first acceptance wins.
- Winner pays accepted price.
- Threshold strategy maps to first-price bidding.
- Core engineering issue: make first acceptance atomic and fair under latency.
- Trap: not every multi-unit ‘Dutch auction’ uses the single-item rules.

## 13. Practice Tasks

1. Map a set of first-price bids to Dutch stopping thresholds.
2. Simulate different clock decrements and measure price error.
3. Design an atomic `accept(auctionId, expectedVersion)` endpoint.
4. Compare client-reactive and server-precommitted thresholds.
5. Analyze values 100, 80, 60 with proposed stops 72, 70, 55.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Descending price; first accepter wins and pays it |
| Why it matters | Fast allocation with urgent price discovery |
| Most asked | First-price equivalence and race handling |
| Main comparison | Dutch is the dynamic cousin of first-price |
| One-line answer | “Pick a shaded stopping threshold: wait for surplus, but not so long that a rival wins.” |

---

# Private-Value Auctions

## 1. Overview

In a **private-value auction**, each bidder knows its own value, and learning another bidder's information does not directly change that value. A collector's personal enjoyment of a painting is a standard example. Private values matter because they determine what information is hidden and support clean results such as truthful Vickrey bidding. Digital ads, personalized recommendations, job scheduling, and internal cloud credits often approximate this model. Interviewers ask candidates to distinguish private information from common uncertainty.

## 2. Core Idea

“Private” describes the source of value, not bid secrecy. Your value may be unknown to others even in an open English auction.

Example: A values a server slot at 12 ms of avoided latency, translated to 100 credits; B values it at 70 credits. If B reveals its estimate, A's intrinsic benefit remains 100. The revelation may change A's bid strategy, but not A's value.

Model: each bidder observes type `v_i`; types are often independently drawn from known distribution `F`; utility is `v_i-p` on winning. The mechanism maps reported types/bids to allocation and payment.

## 3. Important Subtopics

### Independent versus correlated private values

Values can be private yet statistically correlated. Independence makes inference simpler; correlation means another signal teaches a bidder about likely competition, though not necessarily intrinsic value.

### Symmetric versus asymmetric bidders

Symmetric bidders share a value distribution and constraints. Asymmetric bidders may have different distributions, budgets, or information, changing equilibrium strategies.

### Quasi-linear utility

The standard `value-payment` form assumes money transfers linearly and ignores budgets/wealth effects. This enables welfare and payment analysis but is a model assumption, not a law.

### Incentive compatibility

A mechanism is incentive compatible if truthful reporting is optimal under the specified equilibrium concept. Vickrey is dominant-strategy incentive compatible in the standard single-item private-value setting.

## 4. Real-World Example

Services bid internal tokens for a scarce GPU slot. Each service privately estimates the latency or revenue benefit of running now. A Vickrey rule can make honest value reporting simple, while a first-price rule requires each service to model competitors. Engineers must prevent budget exhaustion, duplicate identities, and miscalibrated value metrics.

## 5. Diagrams / Mental Models

```text
private signal/type v_i -> intrinsic value stays v_i
                         -> auction rule + rival behavior determine bid
                         -> allocation/payment determine utility

Learning rival data changes strategy, not intrinsic value.
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Define private values.** Each bidder's payoff-relevant value is individually known and does not depend directly on others' signals. | Information structure | “Bids are secret” |
| 2 | **Are values necessarily independent?** No; private values and statistical independence are separate assumptions. | Correlation distinction | Equating private with independent |
| 3 | **Can an English auction have private values?** Yes; auction format and value model are different dimensions. | Format vs information | Calling public bidding common value |
| 4 | **Why is Vickrey truthful here?** Rival bids set the winning threshold, so reporting value selects the correct side of it. | Critical price | “Because everyone is honest” |
| 5 | **Why shade in first-price?** Payment equals own bid, creating a margin-versus-win-probability trade-off. | Utility | Applying Vickrey logic |
| 6 | **What is a type?** Private payoff-relevant information, often represented by value `v_i`. | Bayesian game vocabulary | Calling strategy a type |
| 7 | **What is efficiency?** Allocate to the bidder with highest realized value, maximizing total value for one item. | Welfare | Maximum seller revenue |
| 8 | **What does i.i.d. mean?** Values are independent and drawn from the same distribution. | Both parts | Saying merely “random” |
| 9 | **Can budgets matter?** Yes; ability to pay may constrain bids and violate quasi-linearity. | Model limitations | Treating value as available cash |
| 10 | **How validate a private-value model?** Ask whether learning others' signals changes intrinsic willingness to pay or only strategic beliefs. | Diagnostic question | Looking only at item category |

## 7. Deep-Dive Questions

1. **What is interdependent value?** A bidder's value depends partly on others' signals; it lies between pure private and pure common-value benchmarks.
2. **Why is Bayesian analysis needed?** Bidders observe their types but form beliefs over unknown opponent types and optimize expected utility.
3. **Does efficiency imply incentive compatibility?** No. An allocation objective and incentives are different properties; payment design is needed to make truthful reports support the objective.
4. **How do correlated types change strategy?** Reports or dropouts can reveal information about competitors and conditional distributions, altering optimal bids.
5. **Can a platform know true values?** Usually not directly. It can design incentives, run experiments, or infer values from behavior, but observed bids are mechanism-dependent.

## 8. Comparison Tables

| Feature | Private value | Common value |
|---|---|---|
| True worth | Bidder-specific | Same ex-post worth |
| Signal role | Reveals own value | Estimates shared unknown value |
| Rival information | Mainly changes competition beliefs | Changes value estimate too |
| Main hazard | Strategic shading | Winner's curse plus strategy |
| Example | Personal enjoyment | Unknown mineral rights |

## 9. Common Mistakes

- Defining private values as secret bids.
- Assuming private values are automatically i.i.d.
- Treating a value as observable cash or a bid.
- Applying risk-neutral formulas to budget-constrained bidders.
- Ignoring interdependent or externality-based values.

## 10. Edge Cases / Special Cases

A bidder may have multi-dimensional value: quality, quantity, timing, and complementarities. Values can be private but correlated. Resale opportunities create common components. Identity and budget constraints alter feasible reports. Negative values arise for disposal or obligation items. Multi-item complements can make independent per-item auctions inefficient.

## 11. How to Explain in Interview

“Private values mean each bidder knows its own intrinsic value and another bidder's information does not directly change it. The auction still has incomplete information because values are hidden. This assumption supports truthful Vickrey bidding and simple equilibrium analysis.”

## 12. Quick Revision Notes

- Private value != private bid.
- Private != independent; i.i.d. is an added assumption.
- Type is private payoff-relevant information.
- Vickrey: truthful; first-price: shade, under standard assumptions.
- Diagnostic: would rival information change my value or only my bidding belief?

## 13. Practice Tasks

1. Classify ten markets as private, common, or interdependent value.
2. Convert latency savings into a service's token value.
3. Simulate i.i.d. values and verify efficient allocation under truthful Vickrey bids.
4. Construct correlated but private values.
5. Give a counterexample where a budget breaks the quasi-linear model.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Bidder-specific intrinsic value privately known |
| Why it matters | Determines incentives and valid equilibrium model |
| Most asked | Private vs common; truthful vs shaded bidding |
| Main comparison | Rival signals affect strategy only vs affect value estimate |
| One-line answer | “My value is mine; others' information changes competition, not what the item is worth to me.” |

---

# Common-Value Auctions

## 1. Overview

In a **common-value auction**, the item has the same underlying ex-post value for all bidders, but bidders observe different noisy signals before bidding. Examples include mineral rights, spectrum with uncertain demand, a company acquisition, or a used asset intended for resale. The central risk is the **winner's curse**: winning suggests one's estimate was the most optimistic. Interviewers ask whether candidates can condition on winning rather than bid from an unconditional estimate.

## 2. Core Idea

Suppose an oil field's true value `V` is the same for every firm. Each firm sees `s_i = V + noise_i`. If a firm bids its raw estimate and wins, it likely had unusually positive noise. The relevant quantity is not `E[V | s_i]`, but `E[V | s_i, i wins]`, which is usually lower.

Example: estimates are 80, 100, and 130 while true value is 90. If everyone bids estimates in a first-price auction, the 130 bidder wins and loses 40. Rational bidders shade for both payment strategy and adverse selection.

## 3. Important Subtopics

### Winner's curse

Winning is bad news about estimation error. It does not mean every winner loses; it means naive bidding ignores selection and earns too little or negative expected profit.

### Signals and affiliation

Signals are noisy information about shared value. Positively affiliated signals make high signals from others evidence of a high true value. Public bidding can aggregate that information.

### Information linkage

Mechanisms that reveal credible information about the common value can increase bidders' confidence and seller revenue by reducing adverse-selection shading.

### Experienced versus naive bidders

Experienced bidders condition on winning. Naive bidders may overbid, temporarily raising revenue but risking losses, exit, or unstable participation.

## 4. Real-World Example

Cloud providers bid for a long-term capacity contract whose resale revenue depends on uncertain future demand shared by all. Each uses different forecasts. A bidder should run scenario analysis conditional on being the highest forecast, apply risk limits, and log the signal snapshot used. The seller can release audited demand data to reduce uncertainty and improve participation.

## 5. Diagrams / Mental Models

```text
true shared value V
   |---- noisy signal s_A
   |---- noisy signal s_B
   `---- noisy signal s_C

highest signal -> most likely winner
most likely winner -> most likely positive estimation error
therefore condition value estimate on the event of winning
```

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **Define common value.** Ex-post item value is shared, while bidders have different pre-auction signals. | Same value, different information | Same valuation estimate |
| 2 | **What is winner's curse?** Winning selects the most optimistic estimate, so naive winners tend to overpay. | Conditional inference | “Winning always causes a loss” |
| 3 | **How should bidders respond?** Estimate value conditional on both their signal and winning, then account for payment rules. | Conditional expectation | Arbitrary fixed discount |
| 4 | **More bidders: what changes?** Winning becomes stronger evidence of extreme optimism, intensifying adverse selection, though competition also changes revenue. | Two effects | Saying more bidders simply means more revenue |
| 5 | **Does Vickrey remove winner's curse?** No. It removes own-payment shading incentives, not uncertainty about common value. | Separate incentive/information problems | “Truthful bid solves everything” |
| 6 | **Why can English auctions help?** Dropout prices reveal signals, allowing belief updates before final bidding. | Information aggregation | Claiming full revelation always |
| 7 | **Give a classic example.** Oil/mineral rights with uncertain quantity and different geological estimates. | Shared realized worth | Personal art preference |
| 8 | **Is resale value a common component?** Often yes, because bidders ultimately face a shared market price. | Model classification | Assuming every used item is private value |
| 9 | **What is affiliation?** High signals make other high signals more likely; signals are positively related. | Informational dependence | Calling it collusion |
| 10 | **How can seller disclosure help?** Credible public data reduces uncertainty and winner's-curse shading, sometimes raising revenue. | Linkage intuition | Assuming seller secrecy always increases price |

## 7. Deep-Dive Questions

1. **Why condition on winning mathematically?** Winning implies `s_i >= max(s_-i)`. This event changes the posterior distribution of `V`; expected value must use `E[V | s_i, s_i is highest]`.
2. **How does the number of bidders affect naive bidding?** More rivals make the maximum noise more extreme, so the highest raw estimate is more upward biased.
3. **What is the linkage principle?** Under affiliated information, expected seller revenue often rises when the mechanism links payment/outcomes more strongly to bidders' information or releases relevant public information.
4. **Can common and private components coexist?** Yes. A telecom license has shared market-demand uncertainty and firm-specific network synergies; this is interdependent value.
5. **How would you detect winner's curse in data?** Compare realized post-auction returns of winners with pre-bid forecasts, controlling for observable quality; persistent negative surprises among winners indicate selection bias.

## 8. Comparison Tables

| Question | Private-value answer | Common-value answer |
|---|---|---|
| What does my signal tell me? | My intrinsic value | Shared uncertain value |
| Does rival information change my estimate? | Usually no | Yes |
| Main correction | Strategic shading/payment | Condition on winning |
| Does Vickrey solve core problem? | Truthful value report | Not the inference problem |
| Does open bidding add value? | Mostly price discovery | Can aggregate signals |

## 9. Common Mistakes

- Saying all bidders have identical estimates rather than identical realized value.
- Describing every winner as cursed.
- Bidding an unconditional expected value.
- Assuming second-price truthfulness eliminates informational adverse selection.
- Forgetting mixed private/common components.

## 10. Edge Cases / Special Cases

Signals may be biased, differently precise, or strategically acquired. The seller may possess information and face disclosure incentives. The true value may be realized only much later. Financing constraints can amplify losses. A bidder with a genuine private synergy need not share the common value exactly. Collusion and information sharing can have both competitive and informational effects.

## 11. How to Explain in Interview

“In a common-value auction everyone ultimately values the asset from the same uncertain fundamental, but each bidder sees a different signal. Because the highest signal tends to win, winning is evidence that my estimate was optimistic. I should therefore value the item conditional on winning—the winner's-curse correction.”

## 12. Quick Revision Notes

- Same ex-post value; different noisy signals.
- Winner's curse is a selection effect, not guaranteed loss.
- Use `E[V | own signal, win]`, not just `E[V | own signal]`.
- More bidders can intensify the inference correction.
- English/dropout information may reduce uncertainty.

## 13. Practice Tasks

1. Simulate `V + noise` signals and compare winners' errors with all bidders' errors.
2. Explain why a Vickrey auction does not erase winner's curse.
3. Classify spectrum, art, ads, and resale inventory by value model.
4. Design a seller disclosure policy for audited asset data.
5. Build a spreadsheet computing conditional winner profit under simple signal distributions.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Shared realized value, privately observed noisy signals |
| Why it matters | Winning changes the value estimate |
| Most asked | Winner's curse and conditional expectation |
| Main comparison | Private value changes strategy; common information changes estimated value |
| One-line answer | “Winning says I was most optimistic, so I condition my estimate on that bad news.” |

---

# Revenue Equivalence Theorem

## 1. Overview

The **revenue equivalence theorem** says that a broad class of auction mechanisms produce the same expected seller revenue when they allocate the item to the highest-value bidder and give the lowest possible type the same expected utility, under standard assumptions. It explains why first-price, second-price, English, and Dutch auctions can have equal expected revenue despite different bidding and payment rules. Interviewers use it to test theorem assumptions, expected versus realized outcomes, and the difference between strategy and revenue.

## 2. Core Idea

Different formats move strategic adjustment between the bid and payment rule. In first-price, bidders shade; in second-price, they bid values but pay a rival threshold. Under symmetric independent private values with risk-neutral bidders, these effects balance in expectation.

For two uniform `[0,1]` bidders:

- First-price equilibrium bid is `v/2`; expected winning value is `E[max]=2/3`, so expected payment is `(2/3)/2=1/3`.
- Second-price payment is the lower value; `E[min]=1/3`.

The realized payments differ profile by profile, but expected revenue is equal.

## 3. Important Subtopics

### Standard assumptions

Risk-neutral bidders; independent private values; symmetric/identically distributed types in the textbook form; allocation to highest type; same utility for the lowest type; well-behaved monotone mechanisms. Every interview answer should state assumptions.

### Allocation rule and payment identity

In an incentive-compatible single-parameter setting, a bidder's expected utility is pinned down by the probability of allocation across types plus boundary utility. Therefore mechanisms with the same allocation and boundary condition have the same expected payments.

### Expected versus ex-post revenue

Equivalence concerns expectation over value draws and equilibrium play. Individual auctions can generate very different payments.

### Failure conditions

Risk aversion, asymmetric or correlated values, common values, budgets, reserve differences, entry costs, and collusion can rank formats differently.

## 4. Real-World Example

An ad platform compares first-price and second-price rules. Revenue equivalence supplies a benchmark, not a forecast: if bidders are symmetric, risk-neutral, and fully adapt, expected revenue may converge. In production, budgets, pacing, learning, floors, quality scores, and asymmetric information violate assumptions, so the platform must use experiments and equilibrium-aware analysis rather than cite the theorem as proof.

## 5. Diagrams / Mental Models

```text
same type distribution + same allocation probability by type
                         + same utility of lowest type
                                      |
                                      v
                         same expected bidder payments
                                      |
                                      v
                         same expected seller revenue
```

| Format | Equilibrium behavior | Payment source | Expected revenue benchmark |
|---|---|---|---|
| First-price | Shade | Own bid | Equal under assumptions |
| Dutch | Stop at shaded threshold | Accepted price | Equal under assumptions |
| Second-price | Truthful | Runner-up bid | Equal under assumptions |
| English | Stay to value | Dropout threshold | Equal under private values |

## 6. Common Interview Questions

| # | Question and clear answer | Expected key points | Common mistake |
|---:|---|---|---|
| 1 | **State the theorem.** Same allocation rule and lowest-type utility imply same expected payments/revenue under standard private-value assumptions. | Allocation + boundary + assumptions | “All auctions earn the same revenue” |
| 2 | **Which formats are classic examples?** First-price, Dutch, second-price, and English single-item auctions. | Equilibrium comparison | Ignoring model assumptions |
| 3 | **Does every bid profile pay the same?** No; equality is ex ante/in expectation over types. | Expected vs realized | Comparing one outcome |
| 4 | **Why can first- and second-price match?** First-price shading offsets second-price's lower payment rule in equilibrium. | Strategic adaptation | Comparing truthful bids in both |
| 5 | **Why does risk neutrality matter?** Expected monetary payoff summarizes preferences; risk aversion changes first-price aggressiveness. | Utility assumptions | Saying risk affects all formats identically |
| 6 | **Why does allocation matter?** Expected utility/payment is determined by how winning probability varies with type. | Payment identity intuition | Focusing on auction labels |
| 7 | **What is the boundary condition?** Usually the lowest type gets zero expected utility; different entry subsidies/fees change revenue. | Lowest-type utility | Omitting it |
| 8 | **Can reserves break equivalence?** Different reserves change allocation/boundary outcomes; identical appropriately applied reserves can preserve comparison. | Compare like with like | Saying any reserve invalidates theorem |
| 9 | **Do common values satisfy it?** Not the standard theorem; signals and winner's curse change information and strategies. | Private-value requirement | Applying it to oil leases blindly |
| 10 | **Practical lesson?** Auction format alone does not determine revenue; assumptions and bidder adaptation matter. | Benchmark, not guarantee | Choosing format solely by theorem |

## 7. Deep-Dive Questions

1. **Give payment-identity intuition.** A type's informational rent equals accumulated allocation probability above the lowest type. If two mechanisms give every type the same winning probability and same lowest-type utility, expected utility and therefore expected payment are pinned down.
2. **Why can risk aversion favor first-price revenue?** Risk-averse bidders value reducing loss probability and shade less in first-price; truthful second-price bidding is less affected in the basic model.
3. **What happens with asymmetric distributions?** Formats can yield different allocations or equilibrium bid functions, and simple symmetric equivalence claims may fail; generalized payment results need careful conditions.
4. **How do entry costs matter?** Formats may induce different participation decisions. Once entrant sets differ, allocation probabilities and boundary utilities differ.
5. **Does the theorem identify the revenue-maximizing auction?** No. Optimal auction design can use reserves or virtual values and may intentionally leave the item unsold.

## 8. Comparison Tables

| Claim | Correct interpretation | Incorrect interpretation |
|---|---|---|
| Revenue is equivalent | Same expected revenue in equilibrium under assumptions | Same payment in each auction |
| Same allocation | Same winning probability for each type | Same user interface |
| Same boundary utility | Lowest type receives same expected surplus | Every bidder gets same surplus |
| Format neutrality | Strategic responses can offset payment rules | Rules never affect behavior |

## 9. Common Mistakes

- Reciting “all auctions have equal revenue” without conditions.
- Comparing truthful first-price bids against truthful second-price bids.
- Confusing expected revenue with ex-post payment.
- Forgetting allocation and lowest-type utility conditions.
- Applying the result to common values, risk aversion, budgets, or collusion without qualification.

## 10. Edge Cases / Special Cases

Atom/discrete value distributions make ties non-negligible. Different reserve prices or entry fees alter boundary utility. Risk-loving or risk-averse utility changes equilibrium. Correlation and affiliation add informational effects. Multi-unit and combinatorial auctions require generalized conditions. Seller value for retaining the item changes the efficient allocation benchmark.

## 11. How to Explain in Interview

“Revenue equivalence says that under symmetric independent private values and risk neutrality, mechanisms with the same allocation rule and the same utility for the lowest type generate the same expected payments. Thus first-price and second-price auctions can match in expected revenue even though one uses bid shading and the other truthful bidding.”

## 12. Quick Revision Notes

- Equality is in expectation and equilibrium, not per realization.
- Key structure: same allocation by type + same lowest-type utility.
- Textbook assumptions: risk-neutral, independent private values, symmetry.
- First-price shading offsets second-price payment.
- The theorem is a benchmark, not a universal format ranking.

## 13. Practice Tasks

1. Compute `E[min]` and `E[max]/2` for two uniform bidders.
2. List one assumption violated by each of five real auction markets.
3. Explain how risk aversion changes first-price bidding.
4. Compare two mechanisms with different entry fees and identify the failed condition.
5. Simulate first- and second-price equilibrium revenue for uniform bidders.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Same allocation and boundary utility imply same expected revenue |
| Why it matters | Separates auction labels from equilibrium effects |
| Most asked | State assumptions; expected vs realized; failure cases |
| Main comparison | First-price shading vs truthful second-price payment |
| One-line answer | “Under the benchmark assumptions, different rules redistribute strategy, not expected revenue.” |
