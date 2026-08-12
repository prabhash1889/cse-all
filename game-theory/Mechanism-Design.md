# Social Choice

## 1. Overview

**Definition.** Social choice studies how individual preferences are combined into one collective decision, ranking, or outcome. A social choice function maps a profile of reported preferences or types `(t1, ..., tn)` to an outcome `f(t1, ..., tn)`.

**Why it matters.** Multi-user systems must decide whose request runs, which proposal wins, how a shared resource is divided, or which policy is selected. The aggregation rule determines efficiency, fairness, and whether users gain by manipulating their reports.

**Where used.** Elections, committee decisions, recommender aggregation, public-project selection, distributed governance, matching markets, and cloud-resource allocation.

**Why interviewers ask.** It tests whether you can formalize participants, alternatives, preferences, and objectives—and recognize that no aggregation rule satisfies every desirable property.

## 2. Core Idea

Suppose three engineers rank deployment windows `A`, `B`, and `C`. A rule receives the three rankings and chooses a window. Majority voting sounds simple, but pairwise majorities may cycle: society can prefer `A > B`, `B > C`, and `C > A` even when every engineer has a consistent ranking.

```text
individual preferences -> aggregation rule -> collective outcome
       private                 public             binding
```

Step by step: define alternatives; collect preference reports; apply a deterministic or randomized rule; evaluate the result using efficiency, fairness, and resistance to strategic reporting. Social choice asks what a good rule should produce. Mechanism design additionally asks how to make self-interested reports lead there.

## 3. Important Subtopics

### Preference relations and utility

A preference relation ranks alternatives; utility assigns numbers representing that ranking. Ordinal utility preserves only order, while cardinal utility also supports meaningful utility differences. This distinction matters because plurality voting needs rankings, whereas welfare maximization needs comparable values. Interview trap: utility numbers are not automatically comparable across people.

### Social choice function versus social welfare function

A social choice function selects an alternative. A social welfare function outputs a collective ranking. For server allocation, choosing server `S2` is social choice; ranking all servers is social welfare. Interviewers often ask candidates not to confuse the two.

### Pareto efficiency

An outcome is Pareto efficient if no other feasible outcome makes someone better off without making anyone worse off. It rules out obvious waste, but usually does not select a unique or fair outcome.

### Voting rules and manipulation

Plurality, Borda count, approval voting, and pairwise majority use different information and produce different winners. Under many unrestricted settings, any non-dictatorial deterministic rule with at least three alternatives can sometimes be manipulated (Gibbard-Satterthwaite insight).

### Arrow's impossibility theorem

With at least three alternatives and unrestricted ordinal preferences, no rank-order aggregation rule simultaneously satisfies unrestricted domain, Pareto/unanimity, independence of irrelevant alternatives, and non-dictatorship. The theorem identifies a design trade-off, not the impossibility of voting itself.

## 4. Real-World Example

A distributed platform must choose one of three replication policies. Teams rank latency, durability, and cost differently. A Borda rule assigns points to rankings. It is easy to implement, but a team may rank a strong rival last to improve its preferred policy. The platform must decide whether strategic resistance, expressiveness, or simplicity is most important.

## 5. Diagrams / Mental Models

| Layer | Question | Example |
|---|---|---|
| Inputs | What does each agent prefer? | `A > B > C` |
| Rule | How are reports aggregated? | Borda count |
| Output | What becomes collective? | Choose `B` |
| Evaluation | Is it efficient/fair/strategy-proof? | Pareto yes; strategy-proof no |

## 6. Common Interview Questions

1. **What is social choice?** Aggregating individual preferences into a collective outcome or ranking. **Expected:** inputs, rule, output. **Mistake:** calling it only voting.
2. **SCF vs SWF?** An SCF chooses an outcome; an SWF produces a social ranking. **Expected:** codomain distinction. **Mistake:** using the terms interchangeably.
3. **What is Pareto efficiency?** No feasible Pareto improvement exists. **Expected:** better for one and no worse for all. **Mistake:** equating it with equality.
4. **Can majority preference cycle?** Yes, the Condorcet paradox permits `A>B`, `B>C`, `C>A`. **Expected:** collective non-transitivity. **Mistake:** blaming irrational voters.
5. **What does Arrow prove?** No unrestricted ordinal rank aggregator with 3+ choices has all four named properties. **Expected:** conditions. **Mistake:** “democracy is impossible.”
6. **What is IIA?** The social ordering of `A` and `B` depends only on individual orderings of `A` and `B`. **Expected:** irrelevant alternatives. **Mistake:** confusing it with independence of voters.
7. **Ordinal vs cardinal preferences?** Ordinal gives order; cardinal also encodes intensity. **Expected:** permitted operations. **Mistake:** comparing arbitrary utility scales.
8. **Is every Pareto-efficient result fair?** No; giving everything to one person can be Pareto efficient. **Expected:** efficiency/fairness distinction. **Mistake:** treating Pareto as justice.
9. **What is a Condorcet winner?** An alternative beating every other in pairwise majority contests. **Expected:** may not exist. **Mistake:** assuming plurality winner equals it.
10. **Why can voting be manipulated?** A report changes how the rule treats alternatives, so a false ranking may yield a preferred winner. **Expected:** strategic reporting. **Mistake:** assuming a ballot always reveals truth.

## 7. Deep-Dive Questions

1. **How can designers escape impossibility results?** Restrict preferences, use randomization, accept dictatorship, weaken axioms, use transfers, or reduce alternatives.
2. **Does adding an alternative leave the winner unchanged?** Not generally; many rules violate IIA and exhibit spoiler effects.
3. **Why is interpersonal utility comparison difficult?** Positive affine transformations preserve an individual's preferences but can change summed welfare weights.
4. **Can random dictatorship be strategy-proof?** Yes for ordinal preferences: select a voter randomly and implement that voter's top choice; it trades deterministic fairness for lottery fairness.
5. **How does computational complexity help?** Finding a beneficial manipulation can be hard, but worst-case hardness is not a guarantee against practical manipulation.

## 8. Comparison Tables

| Concept | Output | Information | Main concern |
|---|---|---|---|
| Social choice function | One outcome | Types/preferences | Selection |
| Social welfare function | Collective ordering | Rankings | Aggregation |
| Mechanism | Outcome plus possible payments | Strategic messages | Incentives |

## 9. Common Mistakes

- Assuming majority rule always yields a transitive ranking.
- Treating Pareto efficiency as fairness or uniqueness.
- Applying Arrow without checking its assumptions.
- Assuming reported preferences are true preferences.
- Summing ordinal utility numbers as if they were comparable cardinal values.

## 10. Edge Cases / Special Cases

With only two alternatives, Arrow's three-alternative impossibility does not apply. Restricted domains such as single-peaked preferences admit well-behaved rules. Ties need explicit tie-breaking, which itself can affect incentives. Randomized rules return lotteries, so preferences over risk become relevant.

## 11. How to Explain in Interview

“Social choice formalizes how a system combines many agents' preferences into one decision or ranking. We judge the aggregation rule by properties such as Pareto efficiency, non-dictatorship, and resistance to manipulation, while impossibility results show that these goals can conflict.”

## 12. Quick Revision Notes

- `f: T1 x ... x Tn -> O` is a social choice function.
- Condorcet cycles can arise from individually rational rankings.
- Pareto efficient does not mean equal or strategy-proof.
- Arrow concerns ordinal social rankings; Gibbard-Satterthwaite concerns manipulable choice rules.
- Trap: always state theorem assumptions.

## 13. Practice Tasks

1. Construct a three-voter Condorcet cycle.
2. Compute plurality and Borda winners for the same ballots.
3. Find a profitable misreport under Borda count.
4. Model replica-policy selection as an SCF and list desired axioms.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Aggregate individual preferences into a collective output |
| Why it matters | Shared systems need legitimate allocation and selection rules |
| Most asked | Pareto efficiency, Condorcet cycle, Arrow, SCF vs SWF |
| Comparison | Social choice specifies the goal; mechanism design engineers incentives |
| One-line answer | “It maps private preferences to a collective decision and studies which desirable properties can coexist.” |

---

# Incentive Compatibility

## 1. Overview

**Definition.** A mechanism is incentive compatible when following the intended reporting strategy is optimal for each participant. Under **dominant-strategy incentive compatibility (DSIC)**, truth-telling is best regardless of others' reports. Under **Bayesian incentive compatibility (BIC)**, truth-telling maximizes expected utility given beliefs about others' types.

It matters because users, bidders, services, and agents optimize their own outcomes. It appears in auctions, matching, pricing, routing, surveys, and resource allocation. Interviewers ask it to test quantifiers: “for every report of others” is stronger than “in expectation over others.”

## 2. Core Idea

An incentive constraint aligns private optimization with system behavior. If true type is `ti`, report is `ri`, allocation is `x`, payment is `p`, and utility is quasi-linear, then:

`u_i = v_i(x, ti) - p_i`.

DSIC requires, for every `ti`, false report `ri`, and reports `t_-i`:

`u_i(ti, t_-i; ti) >= u_i(ri, t_-i; ti)`.

Analogy: a form is well designed when users cannot improve their result by lying on it. In a second-price auction, bidding the true value is weakly dominant because the winner pays the highest competing bid, not their own bid.

## 3. Important Subtopics

### DSIC

Truth is a dominant strategy. It needs no beliefs and is robust, but may limit achievable objectives. Interview angle: correctly quantify over every action/profile of others.

### BIC

Truth maximizes expected utility conditional on the agent's type and a prior distribution over others. It permits more mechanisms but depends on correct common-prior assumptions.

### Ex post and interim viewpoints

Ex post constraints hold after others' types are fixed; interim constraints average over unknown types after one's own type is known. This language clarifies why DSIC is stronger than BIC.

### Weak versus strict truthfulness

Most truthful mechanisms make truth-telling weakly optimal; other reports can tie. Strict truthfulness is uncommon and not required for DSIC.

### Single-parameter monotonicity

In many single-parameter domains, a deterministic allocation rule is DSIC-implementable if allocation is monotone in the bid, paired with a critical-value payment. Raising a bid should not turn a winner into a loser.

## 4. Real-World Example

A cloud platform allocates one GPU. In a first-price auction, a bidder shades its bid below value to trade winning probability against price. In a second-price auction, the winner pays the runner-up bid. Overbidding risks buying above value; underbidding risks losing a profitable allocation. Truthful bidding is therefore weakly dominant.

## 5. Diagrams / Mental Models

```text
true type ti -> choose report ri -> allocation/payment -> utility
       truth is IC if no alternate ri produces higher utility
```

| Notion | Comparison set | Beliefs needed | Strength |
|---|---|---|---|
| DSIC | Every report of others | No | Strongest here |
| Ex-post IC | Every realized type profile | No | Often equivalent in direct settings |
| BIC | Expected over others' types | Yes | Weaker |

## 6. Common Interview Questions

1. **Define IC.** Intended behavior maximizes each agent's utility. **Expected:** deviation inequality. **Mistake:** saying everyone is forced to comply.
2. **Define DSIC.** Truth is optimal for every profile of others' reports. **Expected:** dominant strategy. **Mistake:** “when others tell truth.”
3. **Define BIC.** Truth is optimal in expectation given type and beliefs. **Expected:** prior. **Mistake:** calling it dominant.
4. **Does DSIC imply BIC?** Under compatible assumptions, yes, since a pointwise inequality survives expectation. **Expected:** strength relation. **Mistake:** claiming converse.
5. **Why is second-price truthful?** Bid changes win/loss, not price conditional on winning. **Expected:** overbid/underbid cases. **Mistake:** “winner pays own bid.”
6. **Is first-price truthful?** Generally no; optimal bidders shade bids. **Expected:** price depends on own bid. **Mistake:** confusing allocation efficiency with truthfulness.
7. **Can truth be weakly dominant?** Yes; DSIC normally permits ties. **Expected:** weak inequality. **Mistake:** requiring unique best response.
8. **What is a type?** Private information determining preferences/value. **Expected:** not merely a submitted bid. **Mistake:** equating type and report.
9. **What is monotonicity?** A higher single-parameter bid cannot reduce allocation. **Expected:** critical payments. **Mistake:** treating it as utility monotonicity.
10. **Why care about IC in software systems?** Metrics and protocols are gamed if desired behavior is not individually optimal. **Expected:** incentive-aware design. **Mistake:** assuming validation prevents all strategic behavior.

## 7. Deep-Dive Questions

1. **Can DSIC coexist with budget balance and efficiency?** Not always; public-good and bilateral-trade impossibility results expose conflicts among efficiency, IC, IR, and budget balance.
2. **Does IC guarantee truthful reports in practice?** It guarantees truth is optimal under the model; bounded rationality, collusion, externalities, or misspecified utility can break prediction.
3. **What changes without quasi-linear utility?** Money cannot simply be subtracted from value; standard payment identities and VCG arguments may fail.
4. **Why do critical payments work?** A winner pays the threshold at which it would just stop winning, removing benefit from fine-tuning a winning bid.
5. **Can an IC mechanism be unfair?** Yes. IC concerns strategic deviations, not equity, privacy, or distribution.

## 8. Comparison Tables

| DSIC | BIC |
|---|---|
| Pointwise best response | Expected best response |
| No prior required | Prior required |
| Robust but restrictive | Flexible but model-dependent |
| Easy behavioral advice | Requires belief/risk assumptions |

## 9. Common Mistakes

- Forgetting that utility includes payments.
- Checking truth only when all other agents are truthful.
- Confusing “truthful equilibrium” with dominant-strategy truthfulness.
- Assuming IC implies participation, efficiency, or budget balance.
- Proving only that one particular lie is unprofitable.

## 10. Edge Cases / Special Cases

Ties can make many reports optimal. Randomized mechanisms compare expected utilities. Correlated types complicate BIC posteriors. Multi-dimensional types generally lack the simple monotonicity/threshold characterization. Collusion requires group-strategy-proofness, which individual IC does not provide.

## 11. How to Explain in Interview

“Incentive compatibility means the mechanism makes the desired report—usually truth—optimal for a self-interested agent. DSIC holds against every behavior of others, whereas BIC holds only in expectation under beliefs about their types.”

## 12. Quick Revision Notes

- DSIC: pointwise; BIC: expectation.
- Type is private information; report is the chosen message.
- Truthfulness is usually weak, not strict.
- Single parameter: monotone allocation plus threshold payment.
- Trap: IC does not imply IR.

## 13. Practice Tasks

1. Prove truthfulness of a second-price auction by cases.
2. Exhibit bid shading in a first-price auction.
3. Write the DSIC inequalities for two types and two reports.
4. Test whether a small allocation table is monotone.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | Intended strategy maximizes utility |
| Why | Align private incentives with system goals |
| Asked | DSIC vs BIC, second-price proof, monotonicity |
| Compare | IC = reporting incentive; IR = participation incentive |
| One line | “Truth is DSIC when no lie helps for any reports made by others.” |

---

# Individual Rationality

## 1. Overview

**Definition.** Individual rationality (IR), or participation constraint, means each agent receives at least its outside-option utility by joining the mechanism. If opting out gives normalized utility `0`, IR requires utility `>= 0`.

It matters because even a truthful and efficient mechanism fails if rational users refuse to participate. IR appears in auctions, contracts, marketplaces, admission control, and data-sharing systems. Interviewers ask it to distinguish truthful reporting from voluntary participation.

## 2. Core Idea

Before choosing what to report, an agent chooses whether to enter. A mechanism must pass two tests:

```text
Participate?  utility in mechanism >= outside option       (IR)
What report?  truth gives best utility among reports       (IC)
```

Example: a freelancer values a job at cost `₹8,000`. A mechanism offering expected payment `₹7,000` may be strategy-proof after entry, but the freelancer rationally opts out. IR is evaluated relative to the real outside option, not necessarily zero.

## 3. Important Subtopics

### Ex-post IR

For every realized type/profile, truthful participation beats opting out. It is robust and easy to communicate but restrictive.

### Interim IR

After learning its own type but before seeing others' types, each agent has nonnegative expected utility. It depends on beliefs and permits some realized losses.

### Ex-ante IR

Before any private type is known, expected participation utility is adequate. It is weakest and can hide losses for particular types.

### Outside options and normalization

Zero is only a convenient normalization. A seller who can use an item internally has a positive reservation value; ignoring it produces the wrong constraint.

### No positive transfers and budget balance

IR is distinct from whether the mechanism pays agents and whether total payments balance. A mechanism can be IR while subsidized by the designer.

## 4. Real-World Example

A backend marketplace asks servers to execute jobs. Server `i` has private execution cost `ci`. If selected, utility is `payment - ci`; otherwise it gets `0`. Paying the winner its reported bid may encourage lies; paying a truthful critical threshold can provide IC. But if payment falls below actual cost, ex-post IR fails and the server will reject the job.

## 5. Diagrams / Mental Models

| Time of guarantee | Information known | Guarantee |
|---|---|---|
| Ex ante | No types | Average over all uncertainty |
| Interim | Own type | Average over others |
| Ex post | All types realized | Every realization |

Strength: `ex-post IR => interim IR => ex-ante IR` under consistent beliefs.

## 6. Common Interview Questions

1. **Define IR.** Participation utility is at least the outside option. **Expected:** participation constraint. **Mistake:** “agent behaves rationally.”
2. **IR vs IC?** IR asks whether to enter; IC asks what to report after entering. **Expected:** separate decisions. **Mistake:** treating them as synonyms.
3. **What is ex-post IR?** Constraint holds for every realized profile. **Expected:** strongest standard. **Mistake:** using expected utility.
4. **What is interim IR?** Conditional on own type, expected utility over others is adequate. **Expected:** timing. **Mistake:** ex-ante averaging.
5. **What is ex-ante IR?** Expected utility before learning one's own type beats opting out. **Expected:** weakest. **Mistake:** guaranteeing each type gains.
6. **Must the outside option be zero?** No; zero is normalization. **Expected:** reservation utility. **Mistake:** ignoring alternatives.
7. **Is Vickrey auction IR?** With truthful bidding and standard assumptions, yes ex post: winner pays at most its value; losers pay zero. **Expected:** voluntary participation. **Mistake:** ignoring tie/payment rules.
8. **Can a mechanism be IC but not IR?** Yes, truth can be best among reports while every participating outcome is worse than opting out. **Expected:** example. **Mistake:** assuming truth implies entry.
9. **Can IR require a subsidy?** Yes, depending on objective and outside options. **Expected:** budget distinction. **Mistake:** assuming designer never pays.
10. **Why is IR important in platforms?** Unattractive terms cause supply/users to leave, invalidating allocation assumptions. **Expected:** voluntary adoption. **Mistake:** treating enrollment as compulsory.

## 7. Deep-Dive Questions

1. **Can interim IR permit negative realized utility?** Yes; only conditional expected utility must meet the outside option.
2. **How does risk aversion affect IR?** Expected monetary surplus is insufficient; evaluate expected utility under the agent's utility function.
3. **Can participation constraints bind?** Often the lowest-information-rent type gets exactly its outside option; other types earn information rent.
4. **What if opting out affects others?** The outside outcome must be modeled as a full alternative, including changed allocation and externalities.
5. **Why is bilateral trade hard?** Under private buyer/seller values, efficiency, Bayesian IC, IR, and no subsidy cannot generally all be achieved.

## 8. Comparison Tables

| Property | Protects | Typical inequality |
|---|---|---|
| IR | Participation | `u(join) >= u(outside)` |
| IC | Reporting | `u(truth) >= u(lie)` |
| Budget balance | Designer finances | total receipts cover payments |
| Efficiency | Total value | chosen outcome maximizes welfare |

## 9. Common Mistakes

- Defining IR as “players are rational.”
- Forgetting nonzero reservation utility.
- Mixing ex-ante, interim, and ex-post guarantees.
- Assuming IR means every agent receives money.
- Ignoring costs, risk attitudes, or opt-out consequences.

## 10. Edge Cases / Special Cases

Mandatory mechanisms need not satisfy voluntary participation. Entry fees can preserve ex-ante IR but violate ex-post IR. Budget constraints may prevent an agent from joining even with positive utility. With externalities, losing or opting out may itself have nonzero utility.

## 11. How to Explain in Interview

“Individual rationality is the participation constraint: every agent should prefer joining the mechanism to taking its outside option. Ex-post IR gives that guarantee in every realization; interim and ex-ante IR give progressively weaker expected guarantees.”

## 12. Quick Revision Notes

- IR is about entry; IC is about reports.
- Normalize outside utility to zero only when valid.
- Ex post is stronger than interim, which is stronger than ex ante.
- IR does not imply budget balance.
- Trap: a negative payment is not automatically negative utility.

## 13. Practice Tasks

1. Check IR for each valuation in a second-price auction.
2. Build a mechanism that is IC but not IR.
3. Compare ex-post and interim IR for a lottery.
4. Model a compute provider's nonzero outside option.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | Joining is at least as good as opting out |
| Why | Rational agents can refuse participation |
| Asked | IR vs IC; ex-post/interim/ex-ante |
| Compare | Stronger timing guarantee implies weaker ones |
| One line | “IR guarantees participation utility at least equals reservation utility.” |

---

# Truthful Mechanisms

## 1. Overview

A truthful or strategy-proof mechanism is a direct mechanism in which reporting one's true private type is a dominant strategy. It matters because the designer can act on reliable data without predicting strategic lies. Auctions, procurement, matching, ad allocation, and scheduling use truthful mechanisms. Interviewers commonly ask for a proof, not merely a label.

## 2. Core Idea

Truthfulness is engineered through the relationship between allocation and payment. A second-price auction illustrates it: the highest bid wins but pays the second-highest bid. If your value is `10` and the highest rival bid is `7`, any bid above `7` wins and yields utility `3`; bidding below `7` loses that gain. If the rival bid is `12`, winning would create negative utility, so exaggerating is harmful.

The proof partitions all cases by the competing threshold. Truth does not always uniquely maximize utility; it is enough that no lie does better.

## 3. Important Subtopics

### Direct mechanisms

Agents report types directly; the outcome and payment functions operate on reports. Directness makes “truthful” meaningful and supports revelation-principle analysis.

### Strategy-proofness

For every agent, true type, alternative report, and other-report profile, truthful utility is at least deviation utility. This is DSIC for a direct mechanism.

### Allocation/payment separation

An efficient allocation alone need not be truthful. Payments internalize the effect of reports. In single-item auctions, first-price and second-price rules can choose the same winner but have different incentives.

### Critical-value payments

For monotone single-parameter allocation, a winner pays the smallest bid that would still win. This threshold removes the incentive to shade within the winning region.

### Group strategy-proofness

Individual truthfulness does not prevent coalitions from coordinating misreports and side payments. Group strategy-proofness is stronger and often impossible with other goals.

## 4. Real-World Example

A scheduler has one premium execution slot and jobs report latency savings. Awarding it to the largest reported saving is manipulable if the charge equals the report. Charging the minimum report needed to beat the runner-up makes the report affect whether a job wins, while the threshold determines what it pays.

## 5. Diagrams / Mental Models

```text
own report affects:      win or lose
others' reports set:     critical threshold
winner pays:             threshold, not arbitrary own bid
therefore:               report true value
```

## 6. Common Interview Questions

1. **What is a truthful mechanism?** A direct mechanism where truth is dominant. **Expected:** DSIC condition. **Mistake:** saying lying is impossible.
2. **Truthful vs direct?** Direct describes message format; truthful describes incentives. **Expected:** either can exist without the other. **Mistake:** equating them.
3. **Prove Vickrey truthfulness.** Fix highest rival bid and analyze value above/below it. **Expected:** threshold cases. **Mistake:** assuming rivals truthful.
4. **Why not first price?** A winner can often lower its bid and still win while paying less. **Expected:** profitable shading. **Mistake:** focusing only on winner identity.
5. **Is truth always unique?** No; it is commonly weakly dominant. **Expected:** ties. **Mistake:** demanding strict dominance.
6. **Does truthful mean efficient?** No; an allocation may be truthful but intentionally reserve capacity or favor priorities. **Expected:** separate property. **Mistake:** conflation.
7. **Does truthful mean IR?** No. **Expected:** entry vs reporting. **Mistake:** assuming agents participate.
8. **What is a critical value?** The threshold report at which allocation changes. **Expected:** winner payment. **Mistake:** using the winner's exact bid.
9. **Can a randomized mechanism be truthful?** Yes, universally truthful or truthful in expectation. **Expected:** distinguish notions. **Mistake:** treating them as identical.
10. **Can coalitions manipulate a truthful auction?** Potentially; DSIC protects unilateral deviations only. **Expected:** collusion distinction. **Mistake:** assuming group strategy-proofness.

## 7. Deep-Dive Questions

1. **Universal truthfulness vs truthfulness in expectation?** Universal truthfulness is a distribution over deterministic truthful mechanisms; truthful-in-expectation only compares expected utilities and is weaker.
2. **Why is monotonicity necessary in single-parameter domains?** If raising value removes allocation, the two IC inequalities for high and low types contradict each other.
3. **Are payments unique?** For fixed monotone allocation, DSIC payments are characterized up to type-independent constants under standard conditions.
4. **What breaks with externalities?** An agent may value who else wins, so simple value-minus-payment and threshold reasoning can fail.
5. **What is false-name manipulation?** One participant creates multiple identities; ordinary strategy-proofness does not necessarily prevent gains.

## 8. Comparison Tables

| Mechanism | Allocation | Payment | Truthful? |
|---|---|---|---|
| First-price auction | Highest bid | Own bid | Generally no |
| Second-price auction | Highest bid | Second bid | DSIC |
| Posted price | Accept if value >= price | Fixed price | Trivially truthful decision |

## 9. Common Mistakes

- Proving truthfulness only when opponents report truthfully.
- Saying a truthful bidder must always win.
- Ignoring payments in utility.
- Confusing weak dominance with unique behavior.
- Assuming truthful mechanisms defeat collusion or fake identities.

## 10. Edge Cases / Special Cases

Tie-breaking should not depend manipulably on the winner's report. Reserve prices preserve truthfulness with suitable payments but may reduce allocative efficiency. Budget-limited bidders violate basic quasi-linear assumptions. Repeated interaction and reputation can introduce incentives absent from the one-shot model.

## 11. How to Explain in Interview

“A truthful mechanism makes honest type reporting a dominant strategy. Typically the allocation is monotone and the payment is a report-independent critical threshold, so lying cannot improve whether the agent wins at a profitable price.”

## 12. Quick Revision Notes

- Truthful = strategy-proof direct mechanism.
- Prove against arbitrary reports of others.
- Second price: threshold set by competition.
- First price: shading incentive.
- Truthful does not automatically mean efficient, IR, or coalition-proof.

## 13. Practice Tasks

1. Prove second-price truthfulness using three cases.
2. Find a profitable first-price misreport.
3. Design threshold payments for a monotone scheduling rule.
4. Construct a truthful but inefficient posted-price mechanism.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | Truth is dominant in a direct mechanism |
| Why | Reliable decisions without strategic prediction |
| Asked | Vickrey proof, monotonicity, critical value |
| Compare | First price encourages shading; second price encourages truth |
| One line | “A mechanism is truthful when no unilateral lie beats an honest report, whatever others report.” |

---

# Revelation Principle

## 1. Overview

The revelation principle says that if some possibly indirect mechanism implements an outcome rule in equilibrium, then there exists a direct mechanism in which agents truthfully report their types and the same outcome rule is implemented. Versions exist for dominant-strategy and Bayesian implementation.

It matters because it reduces mechanism search: study truthful direct mechanisms instead of every protocol, negotiation, or message game. It is used in auction and contract theory and helps reason about API/protocol incentives. Interviewers test what the theorem does—and does not—guarantee.

## 2. Core Idea

Imagine an indirect auction where each type would follow an equilibrium strategy `s_i(t_i)`. Build a mediator that asks for `t_i`, internally computes `s_i(t_i)`, and feeds those equilibrium messages into the old mechanism. If lying about type helped in the direct mechanism, the same type could imitate that equilibrium strategy in the old mechanism, contradicting equilibrium.

```text
report type -> mediator computes old equilibrium action -> old outcome rule
```

Thus the direct mechanism reproduces outcomes and inherits incentive constraints. The principle is an analysis reduction, not a claim that every desirable rule is truthfully implementable.

## 3. Important Subtopics

### Direct versus indirect mechanisms

Direct mechanisms ask for types; indirect mechanisms ask for bids, actions, signals, or multi-round messages that need not equal types. Revelation replaces equilibrium strategies with internal simulation.

### Dominant-strategy revelation principle

If an outcome is implemented in dominant strategies, a DSIC direct mechanism can implement it. The robustness notion is preserved.

### Bayesian revelation principle

If an outcome is implemented in Bayes-Nash equilibrium, a BIC direct mechanism can implement it under the same type distribution and beliefs.

### Implementation versus computation

The theorem establishes existence and outcome equivalence. The direct mechanism may reveal sensitive information, be expensive to compute, or be impractical to communicate.

### Outcome equivalence

What is preserved may include allocations and payments under the theorem's formulation, not necessarily off-equilibrium behavior, privacy, simplicity, or robustness to new deviations such as collusion.

## 4. Real-World Example

A cloud procurement protocol uses several negotiation rounds. For every private cost, a server has an equilibrium negotiation strategy. Conceptually, a direct mechanism can ask for cost and simulate that strategy. Researchers can therefore characterize achievable allocations via direct IC constraints even if production later uses a privacy-preserving indirect protocol.

## 5. Diagrams / Mental Models

```text
Indirect: type -> equilibrium strategy -> messages -> outcome
Direct:   type -------- mediator simulation --------> outcome

If false type were profitable in Direct,
imitating that type's strategy would be profitable in Indirect.
```

## 6. Common Interview Questions

1. **State the revelation principle.** Any equilibrium-implementable outcome rule has an equivalent truthful direct mechanism. **Expected:** equilibrium notion and equivalence. **Mistake:** “all mechanisms are truthful.”
2. **Why useful?** It restricts analysis to direct IC mechanisms without losing implementable outcomes. **Expected:** search-space reduction. **Mistake:** saying it makes implementation easy.
3. **What is a direct mechanism?** Message space equals type space. **Expected:** agents report private information. **Mistake:** “one-round” only.
4. **Does it make every social choice rule implementable?** No; only converts a rule already implementable in a specified equilibrium. **Expected:** conditional theorem. **Mistake:** universal truthfulness claim.
5. **Does it preserve dominant strategies?** The dominant-strategy version does. **Expected:** match theorem variant. **Mistake:** mixing DSIC and BIC.
6. **What is the proof idea?** Ask type and simulate the equilibrium strategy of that reported type. **Expected:** contradiction via imitation. **Mistake:** invoking VCG unnecessarily.
7. **Does direct mean practical?** No; privacy, communication, and computation may favor indirect mechanisms. **Expected:** existence vs engineering. **Mistake:** insisting production should reveal types.
8. **Does it preserve off-equilibrium paths?** Not generally; it targets equilibrium outcomes. **Expected:** limitation. **Mistake:** claiming full game equivalence.
9. **What assumptions matter?** Type spaces, utilities, equilibrium concept, beliefs for Bayesian form, and commitment to outcomes/payments. **Expected:** model dependence. **Mistake:** theorem without qualifiers.
10. **Revelation principle vs VCG?** Revelation is a reduction theorem; VCG is a particular efficient DSIC mechanism family. **Expected:** theorem vs construction. **Mistake:** equating them.

## 7. Deep-Dive Questions

1. **Why can privacy invalidate the practical conclusion?** Direct reporting centralizes types; equivalent outcomes need not preserve information leakage.
2. **Does it apply to collusion?** Standard individual versions do not automatically preserve coalition-proof implementation; the deviation/equilibrium concept must match.
3. **What about bounded communication?** A direct type report may require exponentially many bits, so outcome equivalence does not imply communication equivalence.
4. **Can it handle dynamic mechanisms?** Specialized dynamic revelation principles exist, but timing, evolving types, and commitment require additional assumptions.
5. **Why is commitment important?** If the designer cannot commit to the announced rule after learning types, truthful reporting may unravel.

## 8. Comparison Tables

| Direct truthful mechanism | Indirect equilibrium mechanism |
|---|---|
| Reports are types | Messages/actions can be arbitrary |
| Truth is specified equilibrium | Strategic translation needed |
| Convenient for characterization | May improve privacy or usability |
| Not automatically computationally simple | May distribute computation |

## 9. Common Mistakes

- Saying the theorem proves truth-telling in every existing mechanism.
- Forgetting to specify dominant or Bayesian equilibrium.
- Assuming outcome equivalence includes privacy and complexity.
- Using it to claim an impossible rule becomes possible.
- Confusing directness with a single message or no payments.

## 10. Edge Cases / Special Cases

Multiple equilibria make the selected equilibrium strategy important. Correlated types require correct conditional beliefs. Limited commitment, verification, costly communication, or privacy constraints can make the direct construction infeasible even though the abstract result holds.

## 11. How to Explain in Interview

“The revelation principle is a reduction: if an outcome can arise from equilibrium play in any mechanism, a mediator can ask agents for their types, simulate those equilibrium strategies, and implement the same outcome truthfully in a direct mechanism.”

## 12. Quick Revision Notes

- Conditional existence result, not universal implementability.
- Direct: report type; truthful: reporting type is equilibrium.
- Preserve the same solution concept: dominant or Bayesian.
- Main proof: mediator simulates equilibrium actions.
- Trap: no automatic privacy or computational benefit.

## 13. Practice Tasks

1. Convert a simple bargaining-message equilibrium into a direct mechanism.
2. Write the contradiction proof for the Bayesian version.
3. List properties not preserved by outcome equivalence.
4. Explain why the theorem narrows an optimization problem over mechanisms.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Definition | Implementable equilibrium outcomes can be truthfully directly implemented |
| Why | Restricts the mechanism-design search space |
| Asked | Proof construction, assumptions, limits |
| Compare | Revelation = reduction; VCG = concrete mechanism |
| One line | “Ask types, simulate their old equilibrium strategies, and reproduce the outcome.” |

---

# VCG Mechanism

## 1. Overview

The Vickrey-Clarke-Groves (VCG) family selects the outcome maximizing reported total value and charges each agent for the externality it imposes on everyone else. Under quasi-linear utilities and standard assumptions, truthful reporting is a dominant strategy.

VCG matters because it combines efficient allocation with DSIC across rich valuation domains. It appears in combinatorial auctions, spectrum/resource allocation, routing models, and ad-auction foundations. Interviewers expect the allocation rule, payment formula, truthfulness intuition, and limitations.

## 2. Core Idea

Let outcomes be `o in O`, and reported value of agent `i` be `v_i(o)`. Choose

`o* in argmax_o sum_i v_i(o)`.

The Clarke pivot payment is

`p_i = max_o sum_{j != i} v_j(o) - sum_{j != i} v_j(o*)`.

This is others' best welfare without `i` minus their welfare when `i` participates. Agent `i`'s utility becomes total reported/true welfare under the selected outcome minus a term independent of `i`'s report. Maximizing utility therefore aligns with truthfully maximizing total welfare.

Small auction: values are A=`10`, B=`7`, C=`4`. A wins. Without A, others can obtain `7`; with A winning, others obtain `0`, so A pays `7`. Losers impose zero externality and pay `0`. This is the second-price auction as a VCG special case.

## 3. Important Subtopics

### Efficient allocation rule

VCG maximizes the sum of reported valuations over feasible outcomes. Feasibility is crucial: overlapping bundles or resource limits must be encoded correctly.

### Groves payments

General Groves payment has `p_i = h_i(v_-i) - sum_{j != i} v_j(o*)`, where `h_i` is independent of `i`'s report. This independence creates truthfulness. Clarke pivot chooses `h_i` as others' optimum without `i`.

### Externality interpretation

An agent pays the welfare loss its presence causes others. Payment is not simply its bid, a fixed fee, or necessarily the second-highest scalar value in multi-item settings.

### Quasi-linear utility

VCG assumes `u_i = value_i(outcome) - payment_i`. Income effects, hard budgets, and non-monetary externalities can invalidate the proof.

### Computational complexity

The welfare-maximization problem may be NP-hard, as in general combinatorial auctions. Approximation can destroy exact DSIC unless allocation/payment design is handled carefully.

### Budget balance and revenue

VCG is not designed to maximize seller revenue and need not be budget balanced. In some environments it may require subsidies or produce low revenue.

## 4. Real-World Example

A cloud scheduler has two machines and jobs with values for bundles of time slots. It selects the feasible job set with maximum total reported value. Each accepted job pays the reduction in other jobs' maximum attainable welfare caused by its presence. A job cannot profit by inflating a value to change the chosen schedule unless that change also raises its genuine value enough to cover the externality.

## 5. Diagrams / Mental Models

```text
1. Receive valuation functions
2. Find welfare-maximizing feasible outcome o*
3. For each i, remove i and optimize again
4. Payment_i = others' welfare without i - others' welfare at o*
5. Utility_i = value_i(o*) - payment_i
```

| Single-item VCG | General VCG |
|---|---|
| Highest value wins | Welfare-maximizing feasible outcome |
| Winner pays second bid | Agent pays marginal externality |
| One scalar per bidder | Valuation may cover many outcomes/bundles |

## 6. Common Interview Questions

1. **What does VCG choose?** A feasible outcome maximizing reported social welfare. **Expected:** sum of valuations. **Mistake:** maximizing revenue.
2. **What does an agent pay?** The harm/externality imposed on others. **Expected:** formula. **Mistake:** always second-highest bid.
3. **Why is VCG truthful?** Utility equals total true welfare of selected outcome minus an own-report-independent term. **Expected:** alignment argument. **Mistake:** “because payment is low.”
4. **How is Vickrey auction related?** It is single-item VCG. **Expected:** winner pays runner-up. **Mistake:** all VCG payments are runner-up bids.
5. **Is VCG efficient?** Yes relative to reported valuations and feasible outcomes; with truthfulness, relative to true values. **Expected:** assumptions. **Mistake:** computational efficiency.
6. **Is VCG individually rational?** Clarke pivot VCG is ex-post IR under common settings including private values and a null outcome, but check domain assumptions. **Expected:** qualified answer. **Mistake:** unconditional claim.
7. **Is VCG budget balanced?** Not generally. **Expected:** distinguish payments from welfare. **Mistake:** assuming collected money equals cost.
8. **Is VCG revenue optimal?** No; it targets welfare, not seller revenue. **Expected:** objective distinction. **Mistake:** equating efficiency and revenue.
9. **What assumptions support truthfulness?** Quasi-linear utilities, private valuations represented in the model, feasible exact optimization, and no harmful dependence of `h_i` on own report. **Expected:** model. **Mistake:** theorem without assumptions.
10. **Why is VCG hard to deploy?** Expressing valuations, solving welfare optimization, privacy, collusion, false identities, and budget issues. **Expected:** practical limits. **Mistake:** only runtime.

## 7. Deep-Dive Questions

1. **Derive the truthfulness argument.** With others fixed, `u_i = v_i(o*) + sum_{j!=i} v_j(o*) - h_i(v_-i)`; the last term is fixed, so truthful reporting makes the mechanism choose the outcome maximizing the agent's actual utility expression.
2. **What if welfare is approximated?** Arbitrary approximation can make reports manipulate the approximation error; maximal-in-range rules with VCG payments can retain truthfulness over a fixed restricted range.
3. **Can VCG be colluded against?** Yes. Individual DSIC does not guarantee coalition-proofness, and losing bidders may coordinate to alter payments.
4. **What are false-name bids?** One agent submits multiple identities; VCG is not universally resistant, particularly in combinatorial domains.
5. **Why can payments be zero?** If an agent's presence does not reduce anyone else's best attainable welfare, its externality is zero even if it receives allocation.

## 8. Comparison Tables

| Property | VCG | First-price | Posted price |
|---|---|---|---|
| Objective | Welfare | Often seller revenue/auction clearing | Simple trade |
| Truthful | DSIC under assumptions | No | Acceptance decision is truthful |
| Payment | Externality | Own bid | Fixed price |
| General valuations | Yes in theory | Depends on format | Limited |
| Main weakness | Computation/budget/collusion | Strategic shading | Possible inefficiency |

## 9. Common Mistakes

- Calculating payment as winner's reported value.
- Removing an agent but forgetting to re-optimize.
- Using total welfare difference including the paying agent on both sides incorrectly.
- Claiming VCG maximizes revenue.
- Ignoring feasibility constraints or complementarity between items.
- Assuming polynomial-time computation for arbitrary valuations.

## 10. Edge Cases / Special Cases

Ties require report-independent deterministic or suitable randomized tie-breaking. An agent causing no externality can pay zero. Public projects may generate budget deficits. With negative valuations, externalities, budgets, or no null outcome, IR and payment signs require careful analysis. Approximate optimization is not automatically truthful.

## 11. How to Explain in Interview

“VCG chooses the feasible outcome with maximum total reported value and charges each participant the welfare loss it causes everyone else. Because an agent's utility becomes total welfare minus a term independent of its own report, truthful valuation reporting is dominant under quasi-linear preferences.”

## 12. Quick Revision Notes

- Allocation: maximize `sum_i v_i(o)`.
- Pivot payment: best welfare of others without `i` minus their welfare in chosen outcome.
- Vickrey auction is single-item VCG.
- DSIC and allocatively efficient, not necessarily revenue-optimal or budget balanced.
- Trap: computational efficiency is different from allocative efficiency.

## 13. Practice Tasks

1. Compute allocation and payments for values `10, 7, 4`.
2. Solve a two-item combinatorial example with bundle valuations.
3. Implement exhaustive VCG allocation for a tiny set of jobs and verify utilities under misreports.
4. Construct an example where a winner pays zero.
5. Explain why an arbitrary greedy approximation may lose truthfulness.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Welfare maximization plus externality payments |
| Why | Achieves efficient allocation with dominant-strategy truthfulness |
| Most asked | Formula, proof intuition, Vickrey relation, limitations |
| Compare | VCG maximizes welfare; Myerson-style auctions target revenue |
| One-line answer | “Choose maximum welfare and charge each agent the harm it imposes on others.” |
