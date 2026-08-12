# Repeated Games for SDE Placements

Repeated games model strategic interactions that occur more than once. They explain why history, reputation, punishment, patience, and credible future rewards can change behavior even when the underlying one-shot game favors selfish action.

---

# Finite Repeated Games

## 1. Overview

**Definition.** A finite repeated game repeats a stage game a known, finite number `T` of times. After each round, players usually observe some history and choose again. Total payoff may be the sum or average of round payoffs.

**Why it matters.** A deadline changes incentives: a reward or punishment must occur before the final round to affect behavior. In many games, backward induction makes the end dominate the entire analysis.

**Real systems.** Fixed-term contracts, finite cloud auctions, bounded retry contests, tournament rounds, procurement cycles, and protocols with a known shutdown time.

**Why interviewers ask.** It tests whether you distinguish a one-shot action from a history-dependent strategy and can apply backward induction rather than merely multiply a stage-game payoff by `T`.

## 2. Core Idea

### Intuition and analogy

Imagine two contractors who will work together for exactly three releases. Good behavior today can be rewarded tomorrow, but there is no tomorrow after release three. The known endpoint can unravel cooperation.

### Small example

Use the Prisoner's Dilemma stage payoffs:

| A \ B | Cooperate | Defect |
|---|---:|---:|
| **Cooperate** | `3,3` | `0,5` |
| **Defect** | `5,0` | `1,1` |

If the game is played three times and both maximize the sum, `Defect` is dominant in round 3. If future cooperation was supposed to discipline round 2, that threat disappears because both know round 3 will be defection. The same reasoning moves to round 1. The subgame-perfect outcome is defection in every round.

### Step by step

1. Define the stage game and horizon `T`.
2. Define what is observed after each round.
3. A strategy maps every possible history to a current action.
4. Solve the last round as a one-shot game.
5. Substitute that continuation outcome into round `T-1`.
6. Continue backward to round 1.

## 3. Important Subtopics

### 3.1 Histories and strategies

A history `h_t` records actions observed before round `t`. A repeated-game strategy is a function `s_i(h_t)`, not a fixed action. This matters because punishment and forgiveness depend on history. **Example:** cooperate unless a prior overload occurred. **Interview angle:** distinguish a complete strategy from the action chosen on the equilibrium path.

### 3.2 Payoff aggregation

Total payoff can be `sum(u_t)`, average payoff, or a discounted sum. With a fixed `T`, sum and average produce the same preference ordering when the divisor is common. **Interview angle:** state the objective before comparing deviations.

### 3.3 Backward induction

Solve the final proper subgame, then move backward. It is essential for subgame-perfect equilibrium. **Example:** a final-round dominant action eliminates non-credible last-round punishment. **Mistake:** assuming the first round can be analyzed independently of later continuation payoffs.

### 3.4 End-game effects

Behavior may change near termination because reputation loses value. Real systems sometimes hide or randomize termination to reduce this effect. **Interview angle:** explain why a known deadline differs from an uncertain one.

### 3.5 Stage-game equilibrium repetition

Repeating a stage-game Nash equilibrium each round is a subgame-perfect equilibrium: after every history, no player gains in that round by deviating. Other equilibria may exist if the stage game has multiple equilibria or if terminal rewards change incentives.

## 4. Real-World Example

Two backend teams share a finite migration window of four nights. Each can rate-limit (`C`) or send maximum traffic (`D`). Aggression gives a private speed advantage but risks shared failure. If everyone knows the fourth night ends the relationship and aggression is stage-game dominant, a promise to punish on a fifth night is meaningless. Engineers must change the stage incentives—quotas, admission control, or failure charges—not rely only on reputation.

## 5. Diagrams / Mental Models

```text
Round 1 -> Round 2 -> ... -> Round T
   ^          ^                 |
 history affects choices        +-- solve here first
                    backward <------ then move left
```

| Feature | One-shot | Finite repeated |
|---|---|---|
| Decision rule | One action | Action after every possible history |
| Future discipline | None | Limited by remaining rounds |
| Main tool | Best response | Backward induction |
| Deadline | Immediate | Known round `T` |

## 6. Common Interview Questions

1. **What is a finite repeated game?** A stage game played a known finite number of times, with strategies conditioned on histories. **Expected:** stage game, horizon, history, aggregate payoff. **Mistake:** calling repeated actions a strategy.
2. **Why can cooperation unravel?** In a finitely repeated Prisoner's Dilemma, defection is optimal last; backward induction propagates it. **Expected:** dominance and known endpoint. **Mistake:** claiming every finite game must unravel.
3. **What is a history?** The observable sequence of earlier actions/signals. **Expected:** information available at a decision point. **Mistake:** assuming perfect observation without stating it.
4. **What is a repeated-game strategy?** A complete mapping from possible histories to actions. **Expected:** off-path behavior. **Mistake:** saying “always cooperate” is the only possible form.
5. **Why is repeated stage-game Nash an equilibrium?** At every history, the current prescribed stage action is a best response. **Expected:** subgame perfection. **Mistake:** proving only the initial path.
6. **Does finite repetition never support cooperation?** No. Multiple stage equilibria, incomplete information, terminal bonuses, or non-dominant incentives can support it. **Expected:** qualify the unraveling result. **Mistake:** overgeneralization.
7. **Sum versus average payoff?** For fixed common `T`, dividing by `T` does not change optimal choices. **Expected:** positive scaling. **Mistake:** applying this when horizons differ.
8. **What is an end-game effect?** Strategic behavior changes near a known endpoint as future consequences shrink. **Expected:** reputation loses leverage. **Mistake:** treating it as irrationality.
9. **Why use backward induction?** It removes threats that will not be carried out in later subgames. **Expected:** sequential rationality. **Mistake:** merely reasoning forward.
10. **Can a finite game have trigger strategies?** Yes, but a trigger must induce credible continuation behavior before the horizon. **Expected:** credibility. **Mistake:** assuming any severe threat works.

## 7. Deep-Dive Questions

1. **When does unraveling fail?** When the last-round game lacks a unique dominant-strategy equilibrium, types are uncertain, later stage equilibria can reward/punish, or terminal payoffs matter.
2. **Nash versus subgame-perfect equilibrium?** Nash checks deviation from the initial strategy profile; subgame perfection requires optimal play after every history and eliminates empty threats.
3. **What if actions are imperfectly observed?** Strategies use signals rather than true actions; accidental punishment and false attribution can make cooperation fragile.
4. **Can reputation matter with a finite horizon?** Yes under incomplete information—for example, uncertainty that a player is mechanically cooperative can make mimicking valuable.
5. **What if `T` is random?** A positive continuation probability makes the game strategically similar to an infinite discounted game and weakens the terminal-round argument.

## 8. Comparison Tables

| Finite horizon | Indefinite/infinite horizon |
|---|---|
| Known last round | No known final interaction |
| Backward induction central | Continuation value central |
| End-game effects strong | Reputation may persist |
| Threats expire | Threats may remain effective |

## 9. Common Mistakes

- Treating a repeated strategy as one fixed action.
- Applying Prisoner's Dilemma unraveling to every finite repeated game.
- Ignoring off-path histories and threat credibility.
- Forgetting observation assumptions or how payoffs are aggregated.
- Claiming finite repetition automatically creates cooperation.

## 10. Edge Cases / Special Cases

- With `T=1`, the model is the stage game.
- Multiple stage equilibria may provide credible rewards and punishments.
- An unknown or probabilistic endpoint is not strategically equivalent to a known `T`.
- Imperfect monitoring can punish innocent players.
- Terminal bonuses or state carried outside the model can restore future consequences.

## 11. How to Explain in Interview

“A finite repeated game plays the same stage game a known number of times, but a strategy can depend on the entire observed history. I solve it from the last round backward. In a finitely repeated Prisoner's Dilemma, last-round defection causes cooperation to unravel, though that conclusion needs the usual dominance, information, and fixed-horizon assumptions.”

## 12. Quick Revision Notes

- Strategy: `history -> action`; horizon: known `T`.
- Solve sequentially rational behavior backward.
- Repeated stage Nash is always a subgame-perfect candidate.
- Known deadlines weaken reputation.
- Trap: “finite repetition always means defection” is false in general.

## 13. Practice Tasks

1. Solve a 3-round Prisoner's Dilemma by backward induction.
2. Write pseudocode for a strategy that punishes for two rounds after defection.
3. Compare sum and average payoffs for `T=5`.
4. Modify the last-round payoffs so cooperation can survive earlier.
5. Simulate two retry policies over ten fixed rounds and record welfare.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Known finite repetitions of a stage game |
| Main analytical tool | Backward induction |
| Central risk | End-game unraveling |
| Most asked | Why finite Prisoner's Dilemma cooperation fails |
| One-line answer | “History matters, but a known last round limits the power of future punishment.” |

---

# Infinite Repeated Games

## 1. Overview

**Definition.** An infinite repeated game has no fixed final round. It may literally continue forever or end after each round with some constant probability. Utilities must make the infinite stream comparable, commonly through discounting.

**Why it matters.** Without a last round, future rewards and punishments can make behavior sustainable that is not a one-shot equilibrium.

**Real systems.** Long-lived API ecosystems, distributed peer networks, congestion control, marketplaces, reputation systems, security monitoring, and ongoing vendor relationships.

**Interview value.** It connects equilibrium, present value, credible threats, and the design of protocols that align repeated incentives.

## 2. Core Idea

The key object is continuation value. A one-time deviation gives an immediate gain but may destroy a valuable future relationship.

For normalized discounted utility,

```text
U_i = (1-delta) * sum from t=0 to infinity of delta^t * u_i(t)
```

The factor `1-delta` only normalizes constant payoff `x` to value `x`. In the Prisoner's Dilemma with reward `R=3`, temptation `T=5`, and punishment `P=1`, grim-trigger cooperation requires:

```text
3/(1-delta) >= 5 + delta*1/(1-delta)
delta >= (5-3)/(5-1) = 1/2
```

Step by step: cooperate now yields `3` forever; defect now yields `5`, then `1` forever; compare those streams; cooperation is incentive-compatible when the future is important enough.

## 3. Important Subtopics

### 3.1 Continuation value

The value after a history summarizes all expected future payoffs. It converts future consequences into a current incentive. **Interview angle:** write “current payoff + discounted continuation value.”

### 3.2 Discounted utility

Discounting makes infinite sums finite and represents impatience or termination risk. High `delta` means patient players. **Example:** `delta=0.95` values next round at 95% of today.

### 3.3 Subgame-perfect equilibrium

Every prescribed continuation must be optimal after every history. This ensures punishments are credible. A punishment that hurts the punisher with no later benefit may fail this test.

### 3.4 Long-run average payoff

An alternative criterion averages payoffs over time. It can ignore finite initial events and is not always equivalent to discounting. **Interview angle:** state the evaluation method.

### 3.5 Perfect and imperfect monitoring

With perfect monitoring, actions are observed. With public or private noisy signals, players may confuse bad luck with defection, so strategies need tolerance or forgiveness.

## 4. Real-World Example

Independent services repeatedly share a rate-limited dependency. Each can obey a quota or burst. Bursting improves one request but triggers a persistent low-priority tier. If services expect many future requests, the loss of priority can exceed the one-time speed gain. The mechanism turns a continuing relationship into an enforceable incentive without requiring altruism.

## 5. Diagrams / Mental Models

```text
             cooperate now
            /             \
current value       future cooperative stream

             deviate now
            /           \
temptation gain     future punishment stream

Cooperate iff: forgone temptation <= discounted loss of continuation value
```

| `delta` | Interpretation | Typical effect |
|---:|---|---|
| Near 0 | Very impatient/high exit risk | Stage-game incentives dominate |
| Medium | Some future matters | Limited discipline possible |
| Near 1 | Patient/relationship likely continues | Broad cooperation supportable |

## 6. Common Interview Questions

1. **What makes a repeated game infinite?** No known terminal round. **Expected:** literal infinity or random continuation. **Mistake:** saying infinitely many actions occur with certainty.
2. **Why discount payoffs?** To value timing and make streams finite/comparable. **Expected:** impatience or continuation probability. **Mistake:** treating `delta` as a payoff.
3. **How can cooperation arise?** Future loss after deviation can outweigh immediate temptation. **Expected:** incentive constraint. **Mistake:** invoking trust without payoffs.
4. **What is continuation value?** Expected discounted utility from the next period onward after a history. **Expected:** history dependence. **Mistake:** ignoring off-path values.
5. **Why no backward-unraveling argument?** There is no known last round from which to start. **Expected:** contrast finite horizon. **Mistake:** saying backward induction is never used.
6. **What is normalized utility?** `(1-delta)` times the discounted sum. **Expected:** preserves preference rankings for fixed `delta`. **Mistake:** mixing normalized and unnormalized expressions.
7. **What equilibrium is normally required?** Subgame-perfect equilibrium. **Expected:** credible continuation play. **Mistake:** checking only the cooperative path.
8. **Can infinite repetition guarantee cooperation?** No; incentives, patience, monitoring, and feasible punishments matter. **Expected:** conditions. **Mistake:** equating repetition with cooperation.
9. **What does imperfect monitoring change?** Signals may misidentify deviations, creating erroneous punishment. **Expected:** robustness/forgiveness. **Mistake:** assuming exact action histories.
10. **Infinite horizon versus random termination?** With constant continuation probability, expected payoff has the same geometric form. **Expected:** effective discount factor. **Mistake:** claiming they are behaviorally identical under all information structures.

## 7. Deep-Dive Questions

1. **Why is one-shot deviation checking often enough?** In discounted repeated games with appropriate regularity, any profitable multistage deviation has a first profitable one-stage deviation.
2. **How do private signals complicate equilibrium?** Players can hold different histories and beliefs, making coordinated punishment and return to cooperation harder.
3. **Can punishment be finite?** Yes; a finite punishment phase followed by cooperation can be credible and less costly after noise.
4. **What changes when players have different discount factors?** Every player's constraint must hold; the least patient relevant player often limits cooperation.
5. **Does `delta -> 1` mean future payoff is infinite?** Unnormalized sums grow, but normalized payoffs stay on the stage-payoff scale; strategic comparisons remain meaningful.

## 8. Comparison Tables

| Discounted payoff | Long-run average payoff |
|---|---|
| Earlier rounds weigh more | Dates treated symmetrically in the limit |
| Finite deviations can matter | Finite prefix may vanish |
| Parameter `delta` | Limit/liminf convention needed |
| Models impatience/exit | Models persistent average performance |

## 9. Common Mistakes

- Treating “infinite” as certainty that the system physically runs forever.
- Forgetting to compare entire payoff streams.
- Mixing normalized and unnormalized utilities.
- Checking cooperation but not punishment credibility.
- Assuming perfect observation in noisy distributed systems.

## 10. Edge Cases / Special Cases

- At `delta=0`, only the current stage matters.
- At `delta=1`, the geometric discounted sum is generally undefined; use an average-payoff criterion.
- Asymmetric players need separate incentive constraints.
- Exit options cap the punishment that can be imposed.
- Noise can make grim trigger inefficient because one false signal causes permanent punishment.

## 11. How to Explain in Interview

“An infinite repeated game has no known final round, so present actions change the value of an ongoing relationship. I compare the immediate gain from deviation with the discounted loss in continuation value and verify that both cooperation and any punishment are optimal after every history.”

## 12. Quick Revision Notes

- No known last round; strategy remains `history -> action`.
- Utility commonly uses `sum delta^t u_t`.
- Cooperation needs an incentive constraint for every player.
- Subgame perfection checks credible punishment.
- Monitoring and exit risk materially affect results.

## 13. Practice Tasks

1. Derive the cooperation threshold for arbitrary `T, R, P` payoffs.
2. Simulate grim trigger for `delta` values `0.2`, `0.6`, and `0.95`.
3. Replace permanent punishment with three-period punishment and compare welfare.
4. Add a 2% false alarm rate and measure cooperation duration.
5. Model random termination probability `q` and identify the effective discount factor.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Repetition with no known last round |
| Main comparison | Deviation gain vs discounted continuation loss |
| Key equilibrium | Subgame-perfect equilibrium |
| Most asked | Derive the minimum `delta` for cooperation |
| One-line answer | “No last round lets future consequences discipline current actions.” |

---

# Discount Factors

## 1. Overview

**Definition.** The discount factor `delta`, usually `0 <= delta < 1`, is the relative weight placed on next period's payoff. A payoff `k` rounds ahead receives weight `delta^k`.

**Why it matters.** It determines whether future reward or punishment is large enough to alter a current best response.

**Real systems.** Customer churn, service lifetime, repeated auctions, subscription retention, peer-to-peer participation, and any relationship with delay or exit risk.

**Interview value.** It tests geometric series, economic interpretation, inequality manipulation, and sensitivity reasoning.

## 2. Core Idea

`delta` is a conversion rate between future and present utility. If `delta=0.9`, payoff `100` next round has present value `90`, and payoff `100` two rounds ahead has value `81`.

For a constant stream `x`:

```text
x + delta*x + delta^2*x + ... = x/(1-delta)
```

With continuation probability `p` and pure time preference `beta`, an effective factor is often `delta=p*beta`. Thus patience can mean low impatience, low termination risk, or both.

## 3. Important Subtopics

### 3.1 Present value

Discounting translates delayed utility to today's units. It matters whenever deviation changes future states. **Interview angle:** align exponents carefully: current round has exponent zero.

### 3.2 Geometric series

For `|delta|<1`, `sum(delta^t)=1/(1-delta)`. This is the core calculation behind stationary repeated payoffs. **Mistake:** using the formula at `delta=1`.

### 3.3 Patience

Higher `delta` means future consequences matter more and usually expands the sustainable equilibrium set. It does not itself make a player moral or cooperative.

### 3.4 Continuation probability

If the game continues with probability `p`, expected future weights are geometric. **Example:** a 90% customer-retention probability makes later interactions progressively less likely. **Interview angle:** distinguish probability of continuation from subjective time preference.

### 3.5 Threshold derivation

Write cooperative value and deviation value, solve `V_C >= V_D`, and verify the resulting threshold lies in `[0,1)`. The direction of inequality matters.

## 4. Real-World Example

A marketplace seller gains `20` by cheating once but loses future margin `5` per transaction after a ban. If transactions continue with factor `delta`, honesty is sustainable when `5/(1-delta) >= 20`, or `delta >= 0.75`. A platform can increase effective `delta` by improving retention or increase the punishment loss through reputation and access controls.

## 5. Diagrams / Mental Models

```text
time:       now      +1       +2       +3
weight:      1      delta    delta^2  delta^3
```

| Change | Effect on cooperation constraint |
|---|---|
| Higher temptation payoff | Harder |
| Higher cooperative stream | Easier |
| Harsher credible punishment | Easier |
| Higher `delta` | Easier |
| Higher exit probability | Harder |

## 6. Common Interview Questions

1. **What is `delta`?** The weight on one-period-ahead utility. **Expected:** range and interpretation. **Mistake:** calling it interest rate.
2. **Why must `delta<1` for the geometric sum?** Otherwise a positive constant stream does not converge. **Expected:** convergence. **Mistake:** using `1/(1-delta)` at one.
3. **What does high `delta` mean?** Patience or high continuation likelihood. **Expected:** future matters. **Mistake:** “player cooperates automatically.”
4. **Present value after `k` rounds?** `delta^k x`. **Expected:** current period exponent zero. **Mistake:** off-by-one exponent.
5. **Value of constant stream?** `x/(1-delta)`. **Expected:** unnormalized form. **Mistake:** confusing it with normalized value `x`.
6. **Why normalize?** Multiplying by `1-delta` keeps values on the stage-payoff scale without changing preferences. **Expected:** positive common scaling. **Mistake:** mixing forms in one inequality.
7. **How is random termination related?** Survival to period `t` contributes `p^t`; `p` acts like a discount factor. **Expected:** expected payoff. **Mistake:** assuming independence without stating it.
8. **Can players have different factors?** Yes; check each player's constraint separately. **Expected:** asymmetry. **Mistake:** using an average factor.
9. **How find a cooperation threshold?** Compare comply-forever value with one-shot-deviation-plus-punishment value. **Expected:** solve inequality. **Mistake:** compare only current payoffs.
10. **Does higher `delta` always improve welfare?** Not necessarily; it can also sustain collusion or harmful coordination. **Expected:** equilibrium, not morality. **Mistake:** equating patience with social good.

## 7. Deep-Dive Questions

1. **What if discounting is non-geometric?** Preferences may become time-inconsistent, so a plan optimal today may not be optimal later.
2. **How does uncertain duration combine with impatience?** Under independent constant survival `p` and time discount `beta`, multiply them: `delta=p beta`.
3. **Why does normalization not change equilibrium?** It multiplies every payoff stream for a player by the same positive constant.
4. **What happens as `delta` approaches one?** Distant future payoffs retain weight; normalized discounted payoffs approach long-run averages under suitable conditions.
5. **How would you estimate `delta` in a system?** Infer retention/survival probabilities and time-value preferences, then test sensitivity because strategic conclusions may hinge on the threshold.

## 8. Comparison Tables

| Low `delta` | High `delta` |
|---|---|
| Present-focused | Future-focused |
| Weak reputation effects | Strong reputation effects |
| Deviation gain often dominates | Continuation loss may dominate |
| Short expected relationship | Long expected relationship |

## 9. Common Mistakes

- Off-by-one exponents.
- Treating `delta` as a probability in every model.
- Mixing normalized and raw discounted sums.
- Assuming patience guarantees socially desirable behavior.
- Forgetting different players may have different horizons.

## 10. Edge Cases / Special Cases

- `delta=0`: only current payoff counts.
- `delta` near one: formulas are numerically sensitive.
- `delta=1`: discounted constant sums diverge.
- Negative or greater-than-one factors are generally outside the standard model.
- State-dependent or time-varying survival breaks the simple geometric form.

## 11. How to Explain in Interview

“The discount factor converts future utility into present utility: a payoff `k` periods ahead gets weight `delta^k`. In repeated games I compare a one-time deviation gain with the discounted loss of future cooperation; a larger `delta` makes credible future consequences more influential.”

## 12. Quick Revision Notes

- `PV(x at t)=delta^t x`.
- Constant stream: `x/(1-delta)` for `delta<1`.
- Normalize with `1-delta` if desired, consistently.
- High `delta` means patient/high continuation.
- Trap: high `delta` can sustain harmful collusion too.

## 13. Practice Tasks

1. Compute present values for `delta=0.8` over five rounds.
2. Derive `delta*` for arbitrary temptation, reward, and punishment.
3. Implement a ten-line calculator for discounted payoff streams.
4. Plot cooperation feasibility as temptation changes.
5. Separate retention probability and time preference in a worked example.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | One-period future weight |
| Formula | `sum delta^t x = x/(1-delta)` |
| Main interview task | Derive threshold `delta` |
| Main trap | Mixing normalized and unnormalized values |
| One-line answer | “`delta` measures how much future consequences can discipline today's choice.” |

---

# Trigger Strategies

## 1. Overview

**Definition.** A trigger strategy changes behavior when observed history satisfies a trigger condition, usually switching from cooperation to punishment after a deviation.

**Why it matters.** It operationalizes reputation: the strategy specifies both normal behavior and a response to violations.

**Real systems.** Rate-limit escalation, circuit breakers, access revocation, marketplace reputation, peer blacklisting, congestion response, and security lockouts.

**Interview value.** It exposes whether a candidate understands history-dependent strategies, credible threats, noise, and incentive compatibility.

## 2. Core Idea

A trigger strategy behaves like a state machine. “Grim trigger” starts in `COOPERATE`; any observed defection moves permanently to `PUNISH`. “Tit for tat” copies the opponent's previous action. A finite trigger punishes for `k` rounds and then forgives.

```text
COOPERATE --observed defection--> PUNISH
    ^                                |
    +------- forgiveness ------------+
```

The threat changes behavior only if (1) deviation is detectable, (2) punishment costs the deviator enough, and (3) carrying out punishment is itself sequentially rational.

## 3. Important Subtopics

### 3.1 Grim trigger

Cooperate until any defection, then punish forever. It is simple and strong but brittle under noise. **Interview angle:** derive its incentive constraint and discuss false positives.

### 3.2 Tit for tat

Start cooperatively, then copy the opponent's last action. It retaliates quickly and forgives quickly. **Example:** one accidental defect may cause alternating retaliation if actions are simultaneous. **Mistake:** assuming it is always an equilibrium.

### 3.3 Finite punishment

Punish for `k` rounds, then return to cooperation. It limits damage from mistakes but may require longer punishment to deter high temptation.

### 3.4 Credibility

A prescribed punishment must be a best response in the punishment subgame. Repeating a stage-game Nash equilibrium is a common credible punishment. **Interview angle:** severe is not the same as credible.

### 3.5 Detection and public signals

Triggers may respond to observed actions or performance signals. Noisy metrics can trigger punishment without misconduct, so thresholds, grace periods, and forgiveness matter.

## 4. Real-World Example

A distributed API gateway gives clients a normal quota. If a client exceeds it, the gateway moves that identity into a throttled state for five windows, then restores normal access. The finite trigger is transparent, bounded, and robust to occasional measurement errors. Permanent blacklisting would deter more strongly but could destroy legitimate long-term traffic after one false alarm.

## 5. Diagrams / Mental Models

| Strategy | Trigger | Punishment duration | Forgiveness | Noise tolerance |
|---|---|---:|---|---|
| Grim trigger | Any defection | Forever | None | Low |
| Tit for tat | Last action | Usually one response | Immediate | Medium/low |
| `k`-period trigger | Any confirmed defection | `k` rounds | Automatic | Medium |
| Threshold trigger | Signal crosses threshold | Configurable | Configurable | Higher |

## 6. Common Interview Questions

1. **What is a trigger strategy?** A history-contingent rule that switches behavior after a specified event. **Expected:** normal and punishment phases. **Mistake:** describing only punishment.
2. **What is grim trigger?** Cooperate until first deviation, then punish forever. **Expected:** irreversible state. **Mistake:** confusing it with tit for tat.
3. **What is tit for tat?** Begin cooperating and copy the opponent's previous action. **Expected:** retaliation plus forgiveness. **Mistake:** saying it punishes forever.
4. **Why can triggers sustain cooperation?** They attach a future loss to current deviation. **Expected:** discounted incentive constraint. **Mistake:** “because players trust each other.”
5. **What makes punishment credible?** It must be optimal for punishers after the trigger. **Expected:** subgame perfection. **Mistake:** choosing maximally harmful but self-damaging punishment.
6. **Which strategy handles noise better?** Generally forgiving/threshold strategies outperform irreversible grim trigger. **Expected:** false positives. **Mistake:** declaring one universal winner.
7. **Can triggers work in finite games?** Sometimes, but known endpoints restrict credible future punishment. **Expected:** horizon dependence. **Mistake:** absolute no.
8. **What must be observable?** A sufficiently informative action or signal correlated with deviation. **Expected:** monitoring model. **Mistake:** assuming perfect attribution.
9. **Why use finite punishment?** It balances deterrence and recovery after mistakes. **Expected:** choose duration to satisfy incentives. **Mistake:** arbitrary `k`.
10. **Is a trigger strategy itself an equilibrium?** Not automatically; the entire profile and every continuation must satisfy best responses. **Expected:** strategy profile. **Mistake:** labeling one player's rule an equilibrium.

## 7. Deep-Dive Questions

1. **How choose `k`?** Find the smallest punishment duration whose discounted payoff loss exceeds the deviation gain for every player.
2. **What if punishment harms both sides?** It may still be credible if punishment play is a stage-game equilibrium; otherwise renegotiation can undermine it.
3. **How does private monitoring hurt triggers?** Players may disagree about whether a violation occurred, producing unsynchronized states and cascading retaliation.
4. **What is renegotiation-proofness?** After a trigger, players should not unanimously prefer abandoning punishment immediately; many harsh equilibria fail this stronger criterion.
5. **How would you implement a trigger safely?** Use an explicit state machine, auditable signals, bounded sanctions, decay/forgiveness, and protection against identity resets.

## 8. Comparison Tables

| Grim trigger | Tit for tat |
|---|---|
| Permanent punishment | Mirrors last move |
| Maximum deterrence | Fast forgiveness |
| Simple state | Needs last action |
| Fragile under noise | Can create retaliation loops |

## 9. Common Mistakes

- Confusing a strategy with an equilibrium profile.
- Ignoring punishment credibility.
- Assuming actions are perfectly observed.
- Choosing permanent punishment in a noisy system.
- Forgetting identity changes can evade history.

## 10. Edge Cases / Special Cases

- Simultaneous tit-for-tat players can alternate forever after one error.
- If deviation is undetectable, direct triggers cannot work.
- If players can cheaply create new identities, reputation punishment weakens.
- Excessively harsh punishment may invite renegotiation.
- Asymmetric errors may require asymmetric recovery rules.

## 11. How to Explain in Interview

“A trigger strategy is a history-based state machine: cooperate in the normal state, switch to a specified punishment after detected deviation, and possibly forgive later. To claim equilibrium I must show the future loss deters deviation and the punishment is credible after the trigger.”

## 12. Quick Revision Notes

- Grim: permanent; tit for tat: mirror last move; finite trigger: punish `k` rounds.
- Detection, deterrence, and credibility are separate requirements.
- Noise favors forgiveness and thresholds.
- A strategy is not an equilibrium by itself.
- Security trap: reset identities can erase reputation.

## 13. Practice Tasks

1. Implement grim trigger and tit for tat as two-state agents.
2. Inject random observation errors and compare average payoff.
3. Derive minimum punishment length `k` for given payoffs.
4. Design a rate-limit trigger with a recovery path.
5. Find a punishment rule that is not credible and repair it.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | History event switches prescribed behavior |
| Key designs | Grim, tit for tat, finite/threshold trigger |
| Must verify | Detection, deterrence, credibility |
| Main tradeoff | Strong punishment vs robustness/forgiveness |
| One-line answer | “A trigger turns future treatment into a current incentive.” |

---

# Cooperation

## 1. Overview

**Definition.** Cooperation is behavior that helps create a mutually valuable outcome, often by resisting a profitable short-run deviation. It need not mean altruism: it can be individually rational when future consequences matter.

**Why it matters.** Many systems depend on independent agents respecting shared limits, reporting honestly, forwarding traffic, or contributing resources.

**Real systems.** Congestion control, distributed storage, open-source maintenance, shared caches, rate limits, marketplaces, and cybersecurity information sharing.

**Interview value.** It tests the distinction between equilibrium and welfare and asks candidates to design incentives rather than assume goodwill.

## 2. Core Idea

In a social dilemma, joint cooperation produces more total value, but each player may gain by exploiting a cooperator. Repetition adds reputation and continuation value.

```text
cooperate forever value >= defect once + punishment value
```

Step by step: identify the cooperative profile; calculate each player's deviation gain; choose observable, credible consequences; derive patience/monitoring conditions; check all histories; compare welfare and fairness.

## 3. Important Subtopics

### 3.1 Individual rationality

Cooperation must give each participating player at least its enforceable outside-option or security payoff. **Interview angle:** voluntary participation differs from total welfare.

### 3.2 Incentive compatibility

Following the cooperative rule must be at least as good as unilateral deviation. This is the precise version of “trust.” **Example:** honest reporting preserves future access.

### 3.3 Reciprocity and reputation

Players condition future behavior on past conduct. Reputation can make cooperative access an asset that cheating destroys.

### 3.4 Efficiency and fairness

The highest total payoff may distribute gains unevenly. A cooperative arrangement can be efficient yet rejected by a disadvantaged player. **Interview angle:** separate Pareto efficiency, social welfare, and equity.

### 3.5 Mechanism and protocol design

Quotas, deposits, audits, access tiers, and pricing change payoffs directly. Often this is more robust than informal retaliation.

## 4. Real-World Example

TCP senders share a bottleneck. Each could transmit aggressively, but universal aggression causes congestion collapse. Congestion-control algorithms reduce sending rates after loss and increase them cautiously, approximating reciprocal restraint through a protocol. The engineering goal is not kindness; it is to make local behavior compatible with stable shared throughput.

## 5. Diagrams / Mental Models

```text
                 Individually stable?
                        |
cooperative profile ----+----> efficient total payoff?
                        |
                        +----> fair distribution?

These are three different questions.
```

| Tool | Changes | Example |
|---|---|---|
| Reputation | Future access | Seller rating |
| Punishment | Continuation payoff | Temporary throttling |
| Reward | Cooperative payoff | Priority tier |
| Monitoring | Detectability | Audit logs |
| Mechanism | Stage-game incentives | Congestion price |

## 6. Common Interview Questions

1. **Does cooperation imply altruism?** No; future self-interest can support it. **Expected:** repeated incentives. **Mistake:** moral explanation only.
2. **Why is cooperation hard in Prisoner's Dilemma?** Defection is individually dominant in one shot. **Expected:** conflict between incentives and welfare. **Mistake:** saying players communicate badly.
3. **How can repetition help?** Deviation sacrifices future cooperative surplus. **Expected:** continuation value. **Mistake:** repetition automatically helps.
4. **What is incentive compatibility?** No participant benefits by violating the prescribed rule, given others follow it. **Expected:** unilateral deviation. **Mistake:** equating it with efficiency.
5. **What is individual rationality?** Participation beats the relevant outside option. **Expected:** participation constraint. **Mistake:** comparing only total payoffs.
6. **Is every Nash equilibrium efficient?** No; mutual defection can be Nash and Pareto-dominated. **Expected:** stability vs welfare. **Mistake:** Nash means optimal.
7. **How does monitoring help?** It links behavior to future consequences. **Expected:** signal accuracy. **Mistake:** ignoring monitoring cost/error.
8. **How does reputation help?** Good history preserves future opportunities. **Expected:** persistent identity. **Mistake:** assuming reputation survives identity reset.
9. **What threatens cooperation?** Impatience, high temptation, weak punishment, noise, churn, and asymmetric benefits. **Expected:** structured list. **Mistake:** blame irrationality.
10. **How would you engineer cooperation?** Change payoffs/observability with quotas, pricing, deposits, audits, or reputation. **Expected:** incentive-aware design. **Mistake:** rely only on policy text.

## 7. Deep-Dive Questions

1. **Can communication alone create cooperation?** Cheap talk helps coordinate beliefs but does not change incentives unless messages are credible or commitments exist.
2. **How does group size matter?** Individual impact becomes harder to observe and free-riding grows; targeted monitoring and selective incentives become important.
3. **Can punishment reduce welfare?** Yes. Deterrence may help on-path, while actual punishment is costly; forgiveness can improve robustness.
4. **What is a public-goods free rider?** A player enjoys the shared benefit without paying its contribution cost.
5. **How does mechanism design differ from repeated enforcement?** Mechanism design changes rules/payoffs; repeated enforcement conditions future actions on history. Systems often combine both.

## 8. Comparison Tables

| Cooperation | Collusion |
|---|---|
| Jointly beneficial coordination, possibly socially useful | Cooperation among participants that harms outsiders/competition |
| Example: congestion restraint | Example: price fixing |
| Welfare depends on all affected parties | Private gains can reduce social welfare |

| Stability | Efficiency |
|---|---|
| No profitable unilateral deviation | No feasible alternative improves welfare criterion |
| Nash concept | Pareto/social-welfare concept |

## 9. Common Mistakes

- Equating cooperation with kindness.
- Equating equilibrium with social optimality.
- Ignoring outside options and unequal benefit division.
- Assuming monitoring is perfect and free.
- Forgetting that cooperation can harm outsiders through collusion.

## 10. Edge Cases / Special Cases

- A player near exit may defect despite a cooperative history.
- Anonymous or resettable identities weaken reputation.
- Too much punishment can destroy value after accidental signals.
- Coalitions may deviate even when no individual deviation pays.
- Cooperation can be stable but illegal or socially harmful.

## 11. How to Explain in Interview

“Game-theoretic cooperation is not assumed goodwill. It is a profile where players restrain short-run opportunism because rewards, reputation, or credible future consequences make compliance individually rational. I separately check stability, efficiency, fairness, and robustness to noisy monitoring.”

## 12. Quick Revision Notes

- Cooperative does not automatically mean equilibrium, fair, or socially good.
- Constraint: cooperative value must beat deviation value.
- Persistent identity and monitoring support reputation.
- Protocol design can change the stage game.
- Trap: collusion is cooperation for insiders but harmful overall.

## 13. Practice Tasks

1. Model two clients sharing a capacity limit and identify free-riding.
2. Design a deposit that removes the gain from cheating.
3. Simulate cooperative behavior with 5% monitoring error.
4. Compare permanent and temporary exclusion policies.
5. Explain TCP congestion control as incentive alignment and note limits of the analogy.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core definition | Mutually valuable restraint/contribution |
| Why sustainable | Future surplus exceeds deviation gain |
| Must separate | Stability, efficiency, fairness, legality |
| Most asked | How repetition supports cooperation |
| One-line answer | “Cooperation is sustainable when following the rule is individually better than exploiting it.” |

---

# Folk Theorem Intuition

## 1. Overview

**Definition.** Folk theorems are a family of results saying, roughly, that in sufficiently patient infinitely repeated games, many feasible payoff vectors above appropriate individual-rationality levels can be supported as equilibria.

**Why it matters.** Repetition may predict not one outcome but a large set; institutions, norms, focal points, and robustness then determine which equilibrium occurs.

**Real systems.** Long-running platform rules, industry standards, distributed-resource sharing, marketplace reputation, and repeated security relationships.

**Interview value.** It tests whether candidates can state conditions and intuition without making the false claim that “anything can be an equilibrium.”

## 2. Core Idea

Players can combine stage outcomes over time to create feasible average payoffs. If someone deviates, others switch to a credible continuation giving the deviator a low payoff. When `delta` is near one, the future loss can dominate the temporary gain.

```text
candidate payoff
   must be feasible --------------> achievable from stage outcomes
   must be individually rational -> above enforceable punishment/security level
   must be enforceable -----------> deviations deterred by credible continuation
```

Analogy: a long-lived professional community can sustain many sharing arrangements, provided every member prefers membership to the credible consequences of cheating.

## 3. Important Subtopics

### 3.1 Feasible payoffs

A payoff vector is feasible if it can be generated by stage outcomes or mixtures/time-sharing among them. Repetition cannot manufacture payoff outside the feasible set.

### 3.2 Individual rationality and minmax payoff

The minmax value is roughly the lowest payoff opponents can force on a player while responding optimally within the theorem's setup. A sustainable payoff generally must exceed the relevant punishment/security benchmark.

### 3.3 Patience

For payoffs strictly above the benchmark, a sufficiently high `delta` makes a finite deviation gain small relative to future loss. **Mistake:** claiming one universal threshold works for all games and targets.

### 3.4 Equilibrium multiplicity

Many outcomes—including inefficient ones—may be equilibria. The theorem expands possibilities; it does not select a prediction. **Interview angle:** equilibrium selection becomes central.

### 3.5 Variants and assumptions

Different folk theorems use Nash or subgame-perfect equilibrium, perfect or imperfect monitoring, discounted or average payoff, and different dimensional conditions. State the intuitive version unless formal assumptions are requested.

## 4. Real-World Example

Three cloud tenants repeatedly share capacity. They can alternate priority so each receives high throughput one-third of the time, achieving a feasible time-average allocation unavailable as a single symmetric stage outcome. A detected quota violation moves the violator to a credible low-priority continuation. If identities persist and tenants value future access, multiple rotation schedules can be stable—illustrating both the power and the selection problem.

## 5. Diagrams / Mental Models

```text
payoff to B
   ^        feasible payoff region
   |      /-------------------\
   |     /  sustainable when   \
   |----|-- above both players --|  <- individual-rationality bounds
   |     \  punishment levels  /
   +--------------------------------> payoff to A
```

| Claim | Correct? | Reason |
|---|---|---|
| Repetition can support cooperation | Often | Future punishment can deter deviation |
| Any payoff can be equilibrium | No | Must be feasible and individually rational, with assumptions |
| Folk theorem predicts a unique outcome | No | It usually implies multiplicity |
| High patience makes all behavior good | No | Inefficient/collusive equilibria may also persist |

## 6. Common Interview Questions

1. **State the intuition.** Patient players can sustain many feasible, individually rational payoffs using history-dependent rewards and punishments. **Expected:** all three qualifiers. **Mistake:** “anything is possible.”
2. **What is feasible?** Achievable from stage outcomes, including mixtures or time-sharing. **Expected:** convex combinations where applicable. **Mistake:** merely desirable.
3. **What is individually rational?** Each player receives at least the relevant enforceable security/minmax level. **Expected:** participation/enforcement floor. **Mistake:** total payoff is positive.
4. **Why must players be patient?** Future punishment must outweigh current deviation gain. **Expected:** high `delta`. **Mistake:** patience means altruism.
5. **What role do punishments play?** They lower continuation value after deviation. **Expected:** credibility. **Mistake:** punishment occurs on the equilibrium path.
6. **Does it guarantee cooperation?** No; it shows supportability, not selection or inevitability. **Expected:** multiplicity. **Mistake:** prediction claim.
7. **Why “folk” theorem?** Variants circulated as broadly known results before and alongside formal statements. **Expected:** family of theorems. **Mistake:** treating it as one assumption-free theorem.
8. **Does it require infinite repetition?** Standard forms use infinite/indefinite horizons or limiting repeated games. **Expected:** future discipline. **Mistake:** applying directly to a known finite Prisoner's Dilemma.
9. **Can inefficient outcomes be supported?** Yes if conditions hold. **Expected:** equilibrium is not welfare. **Mistake:** only cooperative optimum qualifies.
10. **What is the biggest practical limitation?** Monitoring, credibility, identity persistence, coordination, and equilibrium selection. **Expected:** connect assumptions to systems. **Mistake:** cite only computation.

## 7. Deep-Dive Questions

1. **Why do payoff vectors often form a convex hull?** Players can randomize or time-share among stage outcomes, so long-run averages approximate convex combinations.
2. **Minmax versus maximin?** Maximin is what a player guarantees itself; minmax is the upper bound opponents can impose by minimizing the player's best response. In standard two-player zero-sum games they coincide, but terminology matters generally.
3. **Why require strict improvement over the minmax level in common statements?** Slack helps construct punishments and satisfy incentive constraints for sufficiently high but subunit `delta`.
4. **What changes under imperfect public monitoring?** Public signals must be informative enough, and continuation payoffs reward/punish signal realizations; not every perfect-monitoring result survives.
5. **Why is equilibrium selection difficult?** Many strategy profiles implement different payoffs; history, communication, norms, symmetry, risk dominance, and robustness may select among them.

## 8. Comparison Tables

| One-shot equilibrium analysis | Folk-theorem repeated analysis |
|---|---|
| Current action incentives | Current plus continuation incentives |
| Often small equilibrium set | Potentially large equilibrium set |
| No reputation value | History can carry rewards/punishments |
| Stage feasible outcomes | Time-sharing expands feasible averages |

| Folk theorem provides | Folk theorem does not provide |
|---|---|
| Conditions for supportability | A unique prediction |
| A broad equilibrium-payoff set | Automatic cooperation |
| Role of patience and punishment | Robustness to every monitoring structure |

## 9. Common Mistakes

- Saying any payoff can be sustained.
- Omitting feasibility, individual rationality, or patience.
- Treating supportability as a behavioral prediction.
- Confusing minmax and socially worst payoff.
- Assuming the same theorem under every monitoring and equilibrium concept.

## 10. Edge Cases / Special Cases

- Payoffs on the individual-rationality boundary may require special treatment.
- Low-dimensional feasible sets can violate technical conditions of some versions.
- Imperfect/private monitoring narrows or changes implementability.
- Renegotiation may make harsh off-path punishments implausible.
- A stable repeated equilibrium may implement collusion harmful to outsiders.

## 11. How to Explain in Interview

“The folk-theorem intuition is that patient players can use future rewards and credible punishments to support many repeated-game outcomes, not just the stage Nash outcome. The target payoff must be feasible and above each player's enforceable punishment level. It is a supportability result, not a unique prediction or a guarantee of cooperation.”

## 12. Quick Revision Notes

- Three words: feasible, individually rational, patient.
- Future continuation payoffs enforce current behavior.
- Many equilibria create a selection problem.
- The precise theorem depends on monitoring and equilibrium assumptions.
- Trap: “anything goes” is wrong.

## 13. Practice Tasks

1. Plot stage payoffs and their convex hull for a 2x2 game.
2. Compute each player's minmax benchmark.
3. Choose a target payoff and propose reward/punishment phases.
4. Explain why a point outside the feasible region is impossible.
5. Compare perfect-monitoring and noisy-public-signal implementations.

## 14. Final Cheat Sheet

| Item | Recall |
|---|---|
| Core intuition | Patient repetition supports many equilibrium payoffs |
| Required qualifiers | Feasible and individually rational |
| Enforcement | Credible history-dependent continuation |
| Most asked trap | It does not say “anything is equilibrium” |
| One-line answer | “With enough patience, future consequences can enforce many feasible payoffs above the punishment floor.” |
