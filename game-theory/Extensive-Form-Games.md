# Game Trees

## 1. Overview

A **game tree** is a rooted tree that represents a sequential interaction. A path starts at the initial situation, passes through choices made by players or chance, and ends at an outcome with a payoff for every player. Unlike a payoff matrix, it records **who moves when, what they know, and what actions are available**.

Game trees matter because order and information can change rational behavior. They are used in turn-based games, negotiation, auctions, security protocols, distributed-system recovery, pricing, and multi-stage product decisions. Interviewers use them to test whether a candidate can model a process precisely, distinguish actions from strategies, and reason backward from outcomes.

## 2. Core Idea

Think of a game tree as a program's control-flow tree with multiple decision-makers. A node is a state; an outgoing edge is an allowed action; a leaf is a completed execution with utilities.

Example: a company chooses `Launch` or `Wait`. After `Launch`, a rival chooses `Fight` or `Accommodate`.

```text
Company
├── Wait  → (2, 2)
└── Launch
    └── Rival
        ├── Fight       → (-1, 1)
        └── Accommodate → (4, 3)
```

Payoffs are ordered `(Company, Rival)`. To solve a finite perfect-information game, work backward:

1. At the rival's node, compare its payoff: `Fight` gives 1 and `Accommodate` gives 3.
2. The rival chooses `Accommodate`.
3. The company anticipates this and compares `Wait = 2` with `Launch = 4`.
4. The predicted path is `Launch → Accommodate`.

This procedure is **backward induction**. It reasons about complete future behavior before selecting the current move.

## 3. Important Subtopics

### Root, paths, and terminal nodes

- **Meaning:** The root is the initial state. A path is a possible history. A terminal node is an outcome where no further action occurs.
- **Why it matters:** Payoffs belong to outcomes, not normally to intermediate nodes.
- **Example:** `Launch → Fight` is one complete history.
- **Interview angle:** Label every terminal payoff in a consistent player order.

### Edges and action labels

- **Meaning:** Each outgoing edge represents one action available at that node.
- **Why it matters:** Missing or duplicated actions make the model incorrect.
- **Example:** `Accept`, `Reject`, and `Counteroffer` may leave a negotiation node.
- **Interview angle:** An action is one local choice; a strategy is a complete contingent plan.

### Player and chance nodes

- **Meaning:** A player node is controlled by a strategic actor. A chance node uses fixed probabilities.
- **Why it matters:** Expected utility, rather than direct payoff comparison, is used at chance nodes.
- **Example:** A packet succeeds with probability 0.98 after a server chooses a route.
- **Interview angle:** Nature is not a strategic player and has no preferences.

### Histories and subgames

- **Meaning:** A history is the action sequence leading to a node. A subgame is a valid smaller game beginning at a singleton information set and containing all successor nodes.
- **Why it matters:** Subgame reasoning eliminates non-credible threats.
- **Example:** The rival's decision after `Launch` forms a subgame in the example.
- **Interview angle:** Not every subtree is a subgame when imperfect information is present.

### Backward induction

- **Meaning:** Solve the final decisions first and replace each with the acting player's preferred continuation.
- **Why it matters:** It computes a subgame-perfect equilibrium in finite perfect-information games.
- **Example:** The rival's choice is solved before the company's choice.
- **Interview angle:** Ties may produce multiple backward-induction solutions.

## 4. Real-World Example

Consider automatic scaling in a backend. The operator chooses whether to provision capacity. Demand is then high or low by chance. If demand is high and capacity was not provisioned, an incident commander chooses to shed load or let latency rise. The leaves can contain `(availability, cost)` utilities. The tree forces engineers to represent time order, uncertain demand, recovery actions, and trade-offs explicitly. Expected payoff at the demand node can guide the initial provisioning decision, while the incident branch explains the planned response.

## 5. Diagrams / Mental Models

```text
Node types                     Evaluation rule
──────────                     ───────────────
[Player i] ─ actions ──────►   maximize player i's continuation payoff
[Chance]   ─ outcomes ─────►   probability-weighted expected payoff
[Terminal] ────────────────►   read the payoff vector
```

| Tree element | Programming analogy | Question to ask |
|---|---|---|
| Root | Entry point | What is initially known? |
| Decision node | Branch controlled by an actor | Who chooses here? |
| Edge | Command/action | What can the actor do? |
| History | Execution trace | How did we reach this state? |
| Leaf | Completed execution | What does each player receive? |
| Information set | Indistinguishable states | What can the actor observe? |

## 6. Common Interview Questions

1. **What does a game tree represent?** It represents the timing, choices, information, chance events, and terminal payoffs of a sequential game. **Expected:** all five elements. **Mistake:** calling it merely a list of moves.
2. **How does it differ from a payoff matrix?** A matrix is a compact normal-form representation of complete strategies; a tree exposes sequence and information. **Expected:** actions versus strategies. **Mistake:** saying matrices only model simultaneous games.
3. **What is a terminal node?** A completed history with a payoff vector, or more generally an outcome distribution. **Expected:** payoff for every player. **Mistake:** assigning only the winner's payoff.
4. **What is a chance node?** A non-strategic random event with an exogenous probability distribution. **Expected:** expected-utility calculation. **Mistake:** treating chance as a payoff-maximizing player.
5. **What is backward induction?** Solve the last decision nodes and recursively substitute optimal continuations toward the root. **Expected:** finite perfect information and sequential rationality. **Mistake:** choosing the globally largest leaf regardless of who controls it.
6. **What is a history?** The ordered sequence of actions from the root to a node. **Expected:** distinguish partial and terminal histories. **Mistake:** treating an unordered set of actions as a history.
7. **When is a subtree not a subgame?** When its root is not a singleton information set or it cuts an information set. **Expected:** information-set condition. **Mistake:** calling every descendant tree a subgame.
8. **Can a game tree be infinite?** Yes, through unbounded repetition or continuous time; solution concepts then require additional assumptions. **Expected:** finite trees are a special case. **Mistake:** assuming all games end after fixed moves.
9. **How are simultaneous moves shown?** By sequentially drawing nodes and joining the later player's indistinguishable nodes into one information set. **Expected:** the drawing order must not reveal the first action. **Mistake:** giving the second mover extra knowledge.
10. **How large can a tree become?** Exponential in horizon when each state has several actions. **Expected:** branching factor `b`, depth `d`, roughly `O(b^d)`. **Mistake:** assuming one node per time step.

## 7. Deep-Dive Questions

1. **Why does backward induction imply subgame perfection?** Every proper subgame is solved optimally, so the resulting strategy profile is a Nash equilibrium after every reachable or unreachable valid history.
2. **How do imperfect recall and absent-mindedness affect a tree?** A player may forget its own earlier observation or action. Standard behavioral-strategy equivalences can fail, and a node may share an information set with its own descendant.
3. **How is a tree converted to normal form?** Enumerate each player's complete contingent strategies, then calculate the terminal outcome for every strategy profile. The matrix may grow exponentially.
4. **What is pruning in game-tree search?** It removes branches proven irrelevant to the selected value, as alpha-beta pruning does in zero-sum minimax. It changes computation, not the modeled game.
5. **How are stochastic payoffs evaluated?** Compute expected utility using chance probabilities, provided the player's utility function captures its attitude toward risk.

## 8. Comparison Tables

| Property | Extensive form (tree) | Normal form (matrix) |
|---|---|---|
| Shows move order | Explicitly | Hidden inside strategies |
| Shows information | Information sets | Usually implicit |
| Size | Often large in depth | Often large in strategy count |
| Natural solution method | Backward induction, sequential equilibrium | Best responses, Nash equilibrium |
| Best use | Sequential interaction | Compact strategic comparison |

| Method | Setting | Core operation |
|---|---|---|
| Backward induction | General finite perfect-information game | Each player picks its best continuation |
| Minimax | Two-player zero-sum game | Maximize worst-case value |
| Expectimax | Game/search with chance | Take probability-weighted values |
| Alpha-beta pruning | Minimax computation | Skip branches that cannot affect value |

## 9. Common Mistakes

- Writing payoffs in a different player order at different leaves.
- Confusing a path of actions with a player's complete strategy.
- Selecting the highest total-payoff leaf as though one planner controls everyone.
- Omitting information sets and accidentally creating perfect information.
- Treating low-probability chance outcomes as strategic choices.
- Calling every subtree a subgame.
- Using backward induction directly when a player cannot observe the relevant history.

## 10. Edge Cases / Special Cases

- Tied continuation payoffs can create multiple solutions.
- Zero-probability branches still matter for a complete strategy and sequential rationality.
- A terminal outcome may be probabilistic or contain non-monetary utility.
- Repeated games may have cycles conceptually even though their unfolded representation is a tree.
- Continuous action spaces cannot be drawn by listing every edge.
- A game may have perfect information but include chance moves.

## 11. How to Explain in Interview

“A game tree is the extensive-form representation of a sequential game. Nodes record decision points, edges record actions, information sets record what a player can distinguish, chance nodes record randomness, and leaves contain payoff vectors. For a finite perfect-information tree, I normally solve from the leaves backward.”

## 12. Quick Revision Notes

- Root = initial history; leaf = completed history.
- Edge = action; strategy = action at every information set a player might face.
- Chance uses probabilities; players use preferences.
- Backward induction works cleanly for finite perfect-information games.
- A subgame cannot cut an information set.
- Trap: largest social payoff is not automatically the equilibrium outcome.

## 13. Practice Tasks

1. Draw a three-stage entry-deterrence game and solve it backward.
2. Add a chance node for uncertain demand and calculate expected payoffs.
3. Convert a small two-stage tree into normal form.
4. Identify every history, terminal history, and proper subgame in a supplied tree.
5. Write a C++ depth-first evaluator for a two-player zero-sum tree.
6. Modify the evaluator to support chance nodes.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | A rooted representation of sequential choices, observations, randomness, and outcomes |
| Why it matters | Timing and information change rational behavior |
| Most asked | Tree vs matrix; backward induction; chance nodes; subgames |
| Main comparison | Action is local; strategy is a complete contingent plan |
| Interview trap | Do not maximize one payoff across leaves controlled by different players |
| One-line answer | “A game tree makes the sequence and information structure of strategic interaction explicit.” |

---

# Decision Nodes

## 1. Overview

A **decision node** is a point in an extensive-form game where one player must choose one of the available actions. It stores three essential facts: the history so far, the player who moves, and the feasible action set. Decision nodes matter because rationality is evaluated locally: the controlling player compares the continuation outcomes created by each edge.

They model retry decisions in distributed systems, bidding steps, access-control responses, resource allocation, negotiations, and protocol choices. Interviewers ask about them to check precise modeling, especially whether the candidate understands ownership, legal actions, observations, and the difference between a state and a choice.

## 2. Core Idea

Suppose a server detects overload and can `Scale`, `Shed`, or `Wait`. The state “overload detected” is a node; the three responses are edges. The server operator does not choose a leaf directly—it chooses an action whose downstream decisions and chance events determine a leaf.

```text
[Operator at overload node]
├── Scale → cost now → possible recovery
├── Shed  → rejected traffic → stable service
└── Wait  → chance of recovery or outage
```

Step by step: identify the history, name the controlling actor, list only feasible actions, draw successors, and finally compare the actor's continuation utility. If several nodes are observationally identical to the player, connect them into one information set; then the same action must be selected at all of them.

## 3. Important Subtopics

### Node ownership

- **Meaning:** Exactly one player controls each strategic decision node.
- **Why:** It determines whose utility is optimized.
- **Example:** A client chooses a request; a server later chooses a response.
- **Interview angle:** Joint decisions should be modeled as separate or simultaneous choices, not as one node owned by two players.

### Feasible action set

- **Meaning:** The outgoing edges available at that exact history.
- **Why:** Constraints can differ across states.
- **Example:** `Retry` may be unavailable after the retry budget is exhausted.
- **Interview angle:** Nodes in the same information set must have the same available actions.

### Continuation payoff

- **Meaning:** The payoff eventually produced after choosing an edge and following subsequent play.
- **Why:** A locally costly action can lead to a better final result.
- **Example:** Replication costs resources but avoids outage loss.
- **Interview angle:** Compare terminal or expected continuation utility, not merely immediate reward.

### Reachable and off-path nodes

- **Meaning:** A node is on-path under a strategy profile if that profile reaches it; otherwise it is off-path.
- **Why:** Strategies must still prescribe behavior at off-path nodes.
- **Example:** A punishment node is not reached when both services cooperate.
- **Interview angle:** Non-credible off-path behavior motivates subgame-perfect equilibrium.

### Choice under uncertainty

- **Meaning:** A player may know the information set but not the exact node within it.
- **Why:** The decision must use beliefs about possible nodes.
- **Example:** A server sees a timeout but not whether the request failed or the response was lost.
- **Interview angle:** Do not optimize separately at indistinguishable nodes.

## 4. Real-World Example

In a database failover protocol, a coordinator observes that the primary is unreachable and chooses `Promote replica` or `Wait`. Promotion restores availability but risks split brain; waiting protects consistency but prolongs downtime. The decision node captures the coordinator's observation and legal responses. A chance node can then model whether the primary is actually dead. Correct modeling exposes why fencing or quorum evidence changes the action set and therefore the rational decision.

## 5. Diagrams / Mental Models

```text
history h → [node owned by player i] → action a → successor history h+a
                 │
                 ├─ knows exact node? yes → singleton information set
                 └─ cannot distinguish?   → joined information set
```

| Question | Modeling consequence |
|---|---|
| Who acts? | Assign node ownership |
| What has happened? | Define the history |
| What can the actor observe? | Define information set |
| What is legal? | Define outgoing actions |
| What follows? | Define successors and continuation payoffs |

## 6. Common Interview Questions

1. **What information defines a decision node?** History, moving player, feasible actions, and information-set membership. **Expected:** all elements. **Mistake:** listing only the actor.
2. **Can two players control one node?** No in the standard model; simultaneous choices are represented using separate nodes and information sets. **Expected:** modeling method. **Mistake:** labeling one node with two owners.
3. **Must every node have two actions?** No; any finite or infinite feasible set is possible. **Expected:** branching is model-dependent. **Mistake:** assuming binary trees.
4. **What is a singleton information set?** An information set containing one decision node, so the player knows the exact history. **Expected:** link to perfect information. **Mistake:** equating it with one available action.
5. **Can action sets vary between nodes?** Yes, except nodes in the same information set must share compatible action labels. **Expected:** feasibility constraint. **Mistake:** allowing a player to infer the node from different menus.
6. **What is an off-path node?** A node reached with probability zero under the specified profile. **Expected:** strategy still specifies an action there. **Mistake:** deleting it from equilibrium reasoning.
7. **Decision node versus chance node?** A player intentionally chooses at the former; an exogenous distribution selects at the latter. **Expected:** preferences versus probabilities. **Mistake:** assigning utility to nature.
8. **How is a node evaluated in backward induction?** Choose the successor giving its owner the highest continuation payoff. **Expected:** owner's coordinate. **Mistake:** maximize total welfare.
9. **What happens on a payoff tie?** Multiple actions may be optimal, producing multiple solutions. **Expected:** set-valued choice. **Mistake:** selecting arbitrarily and claiming uniqueness.
10. **Why do off-path choices matter?** They determine credibility and behavior after deviations. **Expected:** subgame perfection. **Mistake:** considering only the realized path.

## 7. Deep-Dive Questions

1. **How do beliefs enter a decision at a non-singleton information set?** The player forms a conditional distribution over its possible nodes and maximizes expected utility using that belief.
2. **Why must nodes in one information set share actions?** Otherwise observing the available menu would reveal the node, contradicting indistinguishability.
3. **Can perfect recall be read from nodes?** It requires that within an information set the player remembers its earlier information sets and its own prior actions.
4. **How do continuous actions change evaluation?** Replace finite comparison with optimization over the feasible action space; a maximum may require compactness and continuity.
5. **How is a decision node represented programmatically?** Usually by a player identifier, action-successor mapping, and optional information-set identifier; payoffs belong to terminal nodes.

## 8. Comparison Tables

| Feature | Decision node | Chance node | Terminal node |
|---|---|---|---|
| Controlled by | Strategic player | Exogenous randomness | Nobody |
| Outgoing edges | Actions | Random outcomes | None |
| Selection rule | Utility-based choice | Fixed probabilities | Read payoff |
| Contains payoff | Usually no | Usually no | Yes |

| Concept | Meaning |
|---|---|
| Node | One exact history/state |
| Information set | One or more nodes indistinguishable to the mover |
| Action | One edge selected locally |
| Strategy | Action rule for every information set of a player |

## 9. Common Mistakes

- Optimizing the wrong player's payoff coordinate.
- Placing immediate rewards on nodes without accounting for later outcomes.
- Giving nodes in one information set different action menus.
- Removing unreachable nodes from a player's strategy.
- Confusing a decision node with a complete system state when observations are partial.
- Treating a timeout or random failure as another rational player.

## 10. Edge Cases / Special Cases

- A node with one feasible action represents a forced move.
- Tied actions are all best responses.
- Infinite and continuous action sets may lack a utility-maximizing action.
- A player's own earlier action may be forgotten in imperfect-recall games.
- Chance may assign zero probability to an edge that still exists in the model.
- In simultaneous-move representations, the visually later player must not learn the earlier action.

## 11. How to Explain in Interview

“A decision node is an exact game history at which a particular player chooses from a feasible action set. The outgoing edges are actions, and the player evaluates their continuation payoffs. If the player cannot tell which of several nodes it is at, those nodes belong to one information set and require the same choice rule.”

## 12. Quick Revision Notes

- Node = exact history; information set = observed situation.
- One strategic owner per decision node.
- Compare continuation utility for the owner.
- Same information set implies the same action menu and strategy choice.
- Off-path nodes remain part of a complete strategy.
- Trap: local action is not a complete strategy.

## 13. Practice Tasks

1. Label owners and actions in an entry-deterrence tree.
2. Mark reachable and off-path nodes under a given profile.
3. Add failure and retry decisions to a request-processing tree.
4. Find modeling errors where nodes in one information set have different actions.
5. Implement `DecisionNode { player, children }` and recursively evaluate a small tree.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | A history where one player selects a feasible action |
| Why it matters | Ownership determines whose utility guides the branch |
| Most asked | Node vs information set; decision vs chance; off-path behavior |
| Main comparison | Node is a state; action is an edge; strategy covers all information sets |
| Interview trap | Do not optimize the sum of payoffs at every node |
| One-line answer | “A decision node records who moves, after what history, and which actions are feasible.” |

---

# Information Sets

## 1. Overview

An **information set** is a collection of decision nodes that a player cannot distinguish when choosing an action. It formalizes limited observation. The player knows that it is at one node in the set but does not know which one, so its strategy must prescribe the same action or action distribution throughout that set.

Information sets matter in card games, simultaneous decisions, auctions, cybersecurity, hidden-state systems, timeouts, and distributed systems with delayed messages. Interviewers ask about them because they reveal whether a candidate separates the true system state from an actor's observable state.

## 2. Core Idea

Imagine player 1 chooses `Left` or `Right` behind a screen. Player 2 then chooses `Up` or `Down` without seeing player 1's move.

```text
                 Player 1
               /          \
            Left          Right
             │              │
          [P2 node] ····· [P2 node]
             │   same information set
          Up/Down          Up/Down
```

Although the drawing contains two P2 nodes, P2 experiences one decision situation. P2 cannot choose `Up after Left` and `Down after Right`, because doing so would require knowledge P2 lacks. P2 may instead choose `Up`, `Down`, or randomize with one common probability at the information set.

## 3. Important Subtopics

### Indistinguishability

- **Meaning:** All nodes in a set are observationally identical to the acting player.
- **Why:** Rational decisions can depend only on available information.
- **Example:** A responder sees “timeout” but not the hidden network condition.
- **Interview angle:** Explain whose knowledge is modeled, not an omniscient observer's.

### Consistent action sets

- **Meaning:** Nodes in one information set offer the same action labels.
- **Why:** A different menu would reveal the node.
- **Example:** Both hidden states permit `Retry` and `Abort`.
- **Interview angle:** This is a structural validity rule.

### Beliefs

- **Meaning:** A probability distribution over nodes within an information set.
- **Why:** Expected utility depends on which hidden history is considered likely.
- **Example:** After a timeout, a client believes with probability 0.7 that processing succeeded.
- **Interview angle:** Bayes' rule updates beliefs on-path when possible.

### Perfect recall

- **Meaning:** A player remembers its own earlier observations and actions.
- **Why:** It supports the equivalence of mixed and behavioral strategies in finite games.
- **Example:** A bidder remembers its earlier bid even without seeing rivals' bids.
- **Interview angle:** Imperfect information does not imply imperfect recall.

### Behavioral strategies

- **Meaning:** A probability distribution over actions independently at each information set.
- **Why:** It is the natural operational description of randomized behavior in a tree.
- **Example:** Retry with probability 0.3 whenever the timeout information set occurs.
- **Interview angle:** Contrast with randomizing once over complete pure strategies.

## 4. Real-World Example

In a payment backend, a client times out after sending a charge request. The true node might be “charge committed, response lost” or “request never reached server.” Those nodes form an information set from the client's perspective. Retrying may double-charge in the first state and recover the purchase in the second. An idempotency key changes the payoffs by making retry safe; it does not magically reveal the hidden state. This is a practical example of designing a system to improve decisions under imperfect information.

## 5. Diagrams / Mental Models

```text
True state:       committed              not received
                       \                  /
Client observes:        └── “timeout” ───┘  ← information set
                                  │
                           retry or abort
```

| Layer | Question |
|---|---|
| Objective state | Which node actually occurred? |
| Observation | What signals does the player receive? |
| Information set | Which nodes remain possible? |
| Belief | How likely is each possible node? |
| Strategy | What action distribution is used? |

## 6. Common Interview Questions

1. **What is an information set?** Nodes indistinguishable to the player who moves there. **Expected:** same acting player and actions. **Mistake:** calling it all information known by every player.
2. **Why must one action apply across the set?** The player cannot condition on an unobserved node. **Expected:** behavioral feasibility. **Mistake:** solving each node independently.
3. **How are simultaneous moves represented?** Connect the later-drawn player's nodes across the earlier player's actions. **Expected:** no observation leaks. **Mistake:** treating drawing order as knowledge.
4. **Perfect information versus complete information?** Perfect concerns observing prior actions; complete concerns knowing players, actions, and payoffs/types. **Expected:** distinct dimensions. **Mistake:** using the terms interchangeably.
5. **What is a belief at an information set?** Conditional probabilities assigned to its nodes. **Expected:** expected-utility use. **Mistake:** treating belief as another action.
6. **Can nodes owned by different players share a set?** No, because the decision-maker must know that it is their turn. **Expected:** common owner. **Mistake:** grouping visually similar states across players.
7. **Can terminal nodes be in an information set?** Standard information sets contain decision nodes for one player, not terminal nodes. **Expected:** role of terminal nodes. **Mistake:** grouping equal-payoff leaves.
8. **What is perfect recall?** Remembering one's earlier information and actions. **Expected:** not knowledge of others' hidden actions. **Mistake:** equating it with perfect information.
9. **Mixed versus behavioral strategy?** Mixed randomizes over complete plans; behavioral randomizes locally at information sets. **Expected:** equivalence under perfect recall. **Mistake:** always claiming equivalence.
10. **Can an information set contain an ancestor and descendant?** Under perfect recall, no; such absent-minded structures involve imperfect recall. **Expected:** recall implication. **Mistake:** ignoring repeated indistinguishable visits.

## 7. Deep-Dive Questions

1. **How are off-path beliefs determined?** Bayes' rule cannot determine beliefs at zero-probability information sets; equilibrium refinements impose consistency through perturbations or limits.
2. **State Kuhn's theorem intuitively.** In finite games with perfect recall, every mixed strategy has an outcome-equivalent behavioral strategy and vice versa.
3. **Why does imperfect recall break the equivalence?** Local randomizations cannot always reproduce correlation created by choosing a complete plan once, and the player may be unable to condition consistently on forgotten history.
4. **What is an information partition?** For each player, its decision nodes are partitioned into disjoint information sets representing exactly what it can distinguish.
5. **How does additional information affect outcomes?** It refines information sets into smaller sets, expanding feasible contingent behavior, but can change strategic commitments and need not benefit every player.

## 8. Comparison Tables

| Property | Perfect information | Imperfect information |
|---|---|---|
| Information-set size | Every set is a singleton | At least one set has multiple nodes |
| Observes prior actions | Yes, when moving | Some relevant history hidden |
| Typical solution tools | Backward induction | Beliefs, Bayesian/sequential equilibrium |
| Example | Chess | Poker, sealed-bid auction |

| Strategy type | Randomization point | Correlation across information sets |
|---|---|---|
| Pure | None | Fixed action everywhere |
| Mixed | Once over pure strategies | Can correlate local choices |
| Behavioral | Separately at each information set | Independent local randomization unless modeled otherwise |

## 9. Common Mistakes

- Drawing a dotted line without ensuring identical owners and action menus.
- Letting a player condition on the actual node inside its information set.
- Confusing incomplete information about types with imperfect observation of actions.
- Assuming perfect recall means knowing the complete game history.
- Using Bayes' rule at an off-path set without specifying a consistency argument.
- Claiming mixed and behavioral strategies are always equivalent.

## 10. Edge Cases / Special Cases

- A singleton information set still exists conceptually.
- Signals can create partial, rather than all-or-nothing, observability.
- A player can know the rules and payoffs but not the earlier actions.
- Information sets may be reached with zero probability in equilibrium.
- Imperfect-recall games can contain absent-minded decision problems.
- More information can remove a useful commitment and alter equilibrium adversely.

## 11. How to Explain in Interview

“An information set groups decision nodes that look identical to the player moving there. Since the player cannot observe which history occurred, it must use the same action rule at every node in the set. Beliefs over those nodes determine expected payoff under imperfect information.”

## 12. Quick Revision Notes

- Node = true history; information set = player's observable situation.
- Same owner and same action menu within a set.
- Beliefs assign probabilities to possible nodes.
- Perfect information means singleton information sets.
- Perfect recall concerns remembering one's own past information and actions.
- Trap: drawing one node after another does not necessarily imply observation.

## 13. Practice Tasks

1. Convert matching pennies into an extensive-form tree without leaking the first move.
2. Model a payment timeout with two hidden states and calculate retry utility under different beliefs.
3. Check whether a proposed information partition has consistent action sets.
4. Draw a signaling game with sender types and receiver information sets.
5. Compare mixed and behavioral randomization in a two-stage perfect-recall game.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Indistinguishable decision nodes for one player |
| Why it matters | Feasible decisions depend on observations, not true hidden state |
| Most asked | Perfect vs complete information; beliefs; perfect recall |
| Main comparison | Mixed randomizes over plans; behavioral randomizes at sets |
| Interview trap | One information set cannot have different action menus |
| One-line answer | “An information set is the set of histories a player considers possible when it acts.” |

---

# Perfect vs Imperfect Information

## 1. Overview

A game has **perfect information** if every player, whenever it moves, knows the complete history of actions and chance outcomes relevant up to that point. Equivalently, every information set is a singleton. A game has **imperfect information** if at least one player must act without knowing exactly which prior history occurred.

The distinction matters because it determines whether simple backward induction is enough or whether strategies must incorporate beliefs and signals. It appears in authentication, auctions, network diagnosis, adversarial security, negotiations, card games, and distributed systems. Interviewers use it to test accurate reasoning about observability and hidden state.

## 2. Core Idea

Perfect information is like debugging with a complete execution trace. Imperfect information is like responding to a production alert with only metrics and a timeout: several true states fit the same observation.

In chess, both players observe every earlier move: perfect information. In poker, private cards hide part of the state: imperfect information. Randomness alone does not imply imperfect information; a public die roll can be perfectly observed.

To classify a game:

1. Examine every point where a player acts.
2. Ask whether the player knows the exact history/node.
3. If yes everywhere, the game has perfect information.
4. If no anywhere, create a multi-node information set and classify it as imperfect information.

## 3. Important Subtopics

### Perfect information

- **Meaning:** Exact history is known at each decision.
- **Why:** Each node can be optimized separately by backward induction.
- **Example:** Tic-tac-toe.
- **Interview angle:** Chance is compatible with perfect information if outcomes are observed.

### Imperfect information

- **Meaning:** At least one decision occurs with multiple possible histories.
- **Why:** Beliefs and information-contingent strategies become necessary.
- **Example:** A sealed-bid auction.
- **Interview angle:** Show it with a non-singleton information set.

### Complete versus incomplete information

- **Meaning:** Complete information means rules, payoff functions, and relevant types are common knowledge; incomplete information means some type/payoff parameter is private.
- **Why:** It is distinct from observing previous actions.
- **Example:** A known-value simultaneous game is complete but imperfect information.
- **Interview angle:** This distinction is asked frequently.

### Public, private, and noisy signals

- **Meaning:** Signals reveal information to all players, one player, or with error.
- **Why:** Signals refine beliefs and can change equilibrium behavior.
- **Example:** A public health check versus a private server log.
- **Interview angle:** Information structure is part of the game, not background detail.

### Games of incomplete information as Bayesian games

- **Meaning:** Nature selects private player types, after which players act with beliefs about types.
- **Why:** It converts hidden payoffs into an extensive-form model.
- **Example:** A bidder privately knows its valuation.
- **Interview angle:** Nature's initial move and type information sets.

## 4. Real-World Example

During leader election, one node may represent “leader crashed” and another “network partition delayed its heartbeat.” A follower sees the same missed-heartbeat signal in both states. The system therefore operates under imperfect information. Quorum protocols do not necessarily reveal the exact state; they change the evidence and constrain safe actions. This explains why timeouts alone cannot prove failure in an asynchronous distributed system.

## 5. Diagrams / Mental Models

```text
Perfect:    history ─► exact node ─► action

Imperfect:  history A ─┐
                       ├─► same observation ─► one action rule
            history B ─┘
```

| Axis | Question | Possible values |
|---|---|---|
| Information timing | Are earlier moves observed? | Perfect / imperfect |
| Game specification | Are types and payoffs known? | Complete / incomplete |
| Recall | Does a player remember its own past? | Perfect / imperfect recall |
| Randomness | Are events probabilistic? | Deterministic / stochastic |

## 6. Common Interview Questions

1. **Define perfect information.** Exact prior history is known at every decision node. **Expected:** singleton information sets. **Mistake:** saying there is no randomness.
2. **Is chess complete and perfect?** Under standard rules, yes: state, rules, and moves are public. **Expected:** distinguish the axes. **Mistake:** claiming strategic uncertainty makes it imperfect.
3. **Is a simultaneous payoff-matrix game perfect information?** Its extensive representation is imperfect because a player does not observe the other's current action. **Expected:** simultaneity. **Mistake:** calling known payoffs perfect information.
4. **Perfect versus complete information?** Perfect is observation of history; complete is knowledge of game structure, payoffs, and types. **Expected:** an example. **Mistake:** treating them as synonyms.
5. **Does a chance node make information imperfect?** Not if its realization is observed before later decisions. **Expected:** observability matters. **Mistake:** equating randomness with hidden information.
6. **Why can backward induction fail as a direct method?** A player at an information set cannot choose separately at each hidden node. **Expected:** beliefs/expected utility. **Mistake:** saying no equilibrium exists.
7. **What is a Bayesian game?** A game where players have types and beliefs, often modeled by nature selecting types. **Expected:** incomplete information. **Mistake:** using “Bayesian” merely because probabilities exist.
8. **Can a game be complete but imperfect?** Yes, such as matching pennies with known payoffs and simultaneous moves. **Expected:** clear example. **Mistake:** assuming hidden action means hidden payoff.
9. **Can a game be perfect but incomplete?** In the usual Harsanyi model, private types create information sets, so the transformed extensive game is imperfect; terminology depends on whether types are treated as history. **Expected:** nuance. **Mistake:** answering without stating the model.
10. **How does a signal affect the game?** It changes the player's information partition and posterior beliefs. **Expected:** may alter equilibrium. **Mistake:** assuming every signal reveals the state perfectly.

## 7. Deep-Dive Questions

1. **What is common knowledge?** Everyone knows a fact, everyone knows everyone knows it, and so on indefinitely; equilibrium reasoning often assumes the game structure is common knowledge.
2. **What is the value of information?** The improvement in optimized expected utility after receiving a signal, holding the decision problem fixed; strategically, information can also change others' behavior.
3. **How does Harsanyi transformation work?** Nature draws a type profile from a common prior, privately reveals types, and play continues in an imperfect-information extensive game.
4. **Why are beliefs needed for sequential equilibrium?** At a multi-node information set, expected continuation payoffs cannot be compared without probabilities over the possible nodes.
5. **Can revealing information hurt?** Yes. Public revelation may remove strategic ambiguity, expose a type, or change opponents' responses; commitment value can make ignorance beneficial.

## 8. Comparison Tables

| Feature | Perfect information | Imperfect information |
|---|---|---|
| Exact history known | Always at decisions | Not always |
| Information sets | All singleton | At least one non-singleton |
| Beliefs over current nodes | Trivial | Often essential |
| Typical examples | Chess, checkers | Poker, auctions, simultaneous games |
| Basic solution approach | Backward induction | Bayesian/sequential reasoning |

| Complete information | Incomplete information |
|---|---|
| Payoffs/types are known | Some payoff-relevant type is private |
| Can still have hidden actions | Usually represented through nature-selected types |
| Example: matching pennies | Example: private-value auction |

## 9. Common Mistakes

- Equating uncertainty about an opponent's future choice with imperfect information.
- Saying perfect information means deterministic outcomes.
- Confusing private types with unobserved earlier actions.
- Assuming known rules imply known current state.
- Treating a noisy signal as exact state revelation.
- Applying node-by-node backward induction inside one information set.

## 10. Edge Cases / Special Cases

- Public random outcomes preserve perfect information.
- Simultaneous moves are imperfect information in extensive form even with complete payoffs.
- A player may have perfect recall within an imperfect-information game.
- Delayed observation can create temporary imperfect information.
- Zero-probability histories still require beliefs in refined solution concepts.
- Different modeling conventions can affect whether private types are described as incomplete or imperfect information; state the convention.

## 11. How to Explain in Interview

“Perfect information means that whenever a player acts, it knows the exact history, so every information set is a singleton. Imperfect information means some distinct histories look identical to a player. This is different from complete information, which concerns whether payoffs, types, and game rules are known.”

## 12. Quick Revision Notes

- Perfect information: observe exact history at each move.
- Imperfect information: at least one multi-node information set.
- Complete information: know types/payoffs and game structure.
- Random does not mean hidden.
- Strategic uncertainty does not by itself mean imperfect information.
- Trap: simultaneous known-payoff games are complete but imperfect.

## 13. Practice Tasks

1. Classify chess, poker, sealed-bid auctions, and matching pennies along all four axes in the table above.
2. Draw public and private coin-toss variants and compare information sets.
3. Model a distributed timeout with hidden failure states.
4. Add a noisy monitoring signal to a repeated cooperation game.
5. Explain why a quorum certificate changes feasible safe behavior.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Perfect = exact history observable at every decision |
| Why it matters | Determines whether beliefs are required |
| Most asked | Perfect vs complete; chance; simultaneous moves |
| Main comparison | Observation of history vs knowledge of payoffs/types |
| Interview trap | Randomness can be public; known payoffs do not reveal actions |
| One-line answer | “Perfect information is about seeing history; complete information is about knowing the game.” |

---

# Strategies in Extensive-Form Games

## 1. Overview

A **strategy in an extensive-form game** is a complete contingent plan: it specifies what a player will do at every information set belonging to that player, including information sets that will not be reached if earlier choices follow the plan. A strategy is therefore larger than one action or the realized path.

Strategies matter because equilibrium compares whole plans against alternative whole plans. They describe policies for protocols, negotiations, auctions, security responses, pricing, retry logic, and resource allocation. Interviewers ask about them because “action versus strategy” is a foundational distinction and because credible off-path behavior is central to sequential games.

## 2. Core Idea

Suppose a service first chooses `Deploy` or `Do not deploy`. If it deploys and receives either a `Low load` or `High load` signal, it later chooses `Keep` or `Rollback`.

A pure strategy must specify all relevant decisions, for example:

```text
(Deploy initially; Keep after Low; Rollback after High)
```

Even if `Do not deploy` is chosen, the strategy still includes what would have happened after both signals. To enumerate pure strategies, choose one action at each of the player's information sets. If the action counts are `m1, m2, ..., mk`, the number of pure strategies is their product `m1 × m2 × ... × mk`.

## 3. Important Subtopics

### Pure strategies

- **Meaning:** One deterministic action at every information set.
- **Why:** They are the basic complete plans used to build normal form.
- **Example:** `Enter; if challenged, stay`.
- **Interview angle:** Include choices after histories prevented by the strategy itself.

### Mixed strategies

- **Meaning:** A probability distribution over complete pure strategies, selected before play.
- **Why:** It can hide or correlate planned actions across information sets.
- **Example:** Randomly select one entire incident-response playbook.
- **Interview angle:** The randomization happens over plans, not separately at nodes.

### Behavioral strategies

- **Meaning:** A probability distribution over actions at each information set.
- **Why:** It directly describes local randomized behavior.
- **Example:** At each timeout, retry with probability 0.2.
- **Interview angle:** Outcome-equivalent to mixed strategies in finite perfect-recall games.

### Strategy profile and induced outcome

- **Meaning:** A strategy profile contains one strategy for each player. Together with chance probabilities it induces a path or outcome distribution.
- **Why:** Payoffs and equilibrium are properties of profiles.
- **Example:** Entrant chooses `Enter`; incumbent chooses `Accommodate if entry`.
- **Interview angle:** A single player's strategy does not determine the outcome.

### Sequential rationality and credible threats

- **Meaning:** A plan is sequentially rational if it remains optimal whenever its information set is reached, given beliefs and others' continuations.
- **Why:** Nash equilibrium can depend on an irrational threat after a deviation.
- **Example:** Threatening a costly price war to deter entry.
- **Interview angle:** Subgame-perfect or sequential equilibrium strengthens Nash equilibrium.

## 4. Real-World Example

A distributed client policy may specify: send to the primary; after a definitive rejection, abort; after a timeout with an idempotency key, retry; after a timeout without one, query status; after repeated failure, fail over. This is a strategy because it covers every observable contingency, not just the normal request path. Comparing policies requires including failure branches, even when a candidate policy makes some branches unlikely.

## 5. Diagrams / Mental Models

```text
Information sets:       I1          I2          I3
Available actions:     A/B         C/D/E       F/G
One pure strategy:      A            E          F
Number of strategies:  2 × 3 × 2 = 12
```

| Object | Scope |
|---|---|
| Action | One choice at one information set |
| Pure strategy | One action at every information set |
| Mixed strategy | Distribution over pure strategies |
| Behavioral strategy | Local action distribution at every information set |
| Strategy profile | One complete strategy per player |

## 6. Common Interview Questions

1. **Define a strategy in extensive form.** A complete action plan for every information set of a player. **Expected:** off-path contingencies. **Mistake:** describing only the observed move.
2. **Action versus strategy?** An action is local; a strategy covers all possible decision situations. **Expected:** concise distinction. **Mistake:** using the words interchangeably.
3. **How do you count pure strategies?** Multiply the number of actions across the player's information sets. **Expected:** information sets, not nodes. **Mistake:** adding action counts.
4. **Why specify unreachable choices?** Deviations can make those histories reachable, and equilibrium compares complete plans. **Expected:** counterfactual behavior. **Mistake:** dropping off-path branches.
5. **What is a strategy profile?** A tuple containing one strategy for each player. **Expected:** plus chance it induces outcomes. **Mistake:** calling one player's plan a profile.
6. **Mixed versus behavioral strategy?** Mixed randomizes over complete plans; behavioral randomizes locally. **Expected:** timing and correlation. **Mistake:** saying they are definitionally identical.
7. **When are mixed and behavioral strategies equivalent?** In finite extensive games with perfect recall, in terms of induced outcomes against opponents. **Expected:** Kuhn's theorem conditions. **Mistake:** omitting perfect recall.
8. **What is an off-path action?** A prescribed action at an information set not reached under the current profile. **Expected:** still part of strategy. **Mistake:** assuming it has no equilibrium significance.
9. **What is a credible threat?** An announced continuation action that is optimal when its decision point is reached. **Expected:** sequential rationality. **Mistake:** judging credibility only by deterrence success.
10. **How do you derive normal form from a tree?** Enumerate complete strategies and compute the resulting terminal payoff for every profile. **Expected:** possible exponential growth. **Mistake:** using tree edges as matrix strategies.

## 7. Deep-Dive Questions

1. **Why can a Nash equilibrium contain non-credible threats?** Nash tests unilateral changes to complete strategies at the initial game, so an off-path action may never affect payoff and need not be optimal after the deviation.
2. **How does subgame perfection fix this?** It requires the strategy profile to be a Nash equilibrium in every subgame, including off-path subgames.
3. **What correlation can a mixed strategy create?** Selecting a complete plan once can correlate actions at different information sets; independent behavioral choices may not reproduce this without perfect recall equivalence.
4. **What is realization equivalence?** Two strategies are realization-equivalent if, against every opponent strategy, they induce the same probabilities over terminal histories.
5. **How do beliefs interact with behavioral strategy?** At each information set, beliefs value the hidden nodes; the behavioral strategy assigns probabilities to actions maximizing expected continuation utility.

## 8. Comparison Tables

| Property | Pure | Mixed | Behavioral |
|---|---|---|---|
| Randomization | None | Over complete pure strategies | At each information set |
| Operational timing | Deterministic | Plan sampled before play | Local sampling when reached |
| Cross-set correlation | Fixed by chosen plan | Possible | Usually independent local draws |
| Perfect-recall equivalence | Baseline | Outcome-equivalent to behavioral | Outcome-equivalent to mixed |

| Equilibrium concept | Requirement | Main purpose |
|---|---|---|
| Nash equilibrium | No profitable complete unilateral deviation | Strategic stability |
| Subgame-perfect equilibrium | Nash in every subgame | Remove non-credible threats in proper subgames |
| Sequential equilibrium | Sequential rationality plus consistent beliefs | Handle imperfect information and off-path beliefs |

## 9. Common Mistakes

- Listing only actions on the equilibrium path.
- Counting decision nodes instead of information sets.
- Treating chance probabilities as a player's strategy.
- Confusing a mixed action at one set with a mixed strategy over complete plans.
- Claiming every Nash equilibrium is sequentially credible.
- Assuming subgame perfection fully handles games with no proper subgames.

## 10. Edge Cases / Special Cases

- A player with no decision nodes has exactly one empty strategy.
- Forced one-action information sets do not increase the strategy count.
- Two distinct pure strategies may induce the same outcome against a fixed opponent profile.
- Continuous action spaces yield infinitely many pure strategies.
- Imperfect recall can destroy mixed/behavioral equivalence.
- A game may have no proper subgames beyond the entire game, so every Nash equilibrium is vacuously subgame-perfect even when off-path beliefs are problematic.

## 11. How to Explain in Interview

“A strategy in an extensive-form game is not one move; it is a complete contingent plan assigning an action to every information set the player could face, including off-path ones. A pure strategy is deterministic, a mixed strategy randomizes over complete plans, and a behavioral strategy randomizes locally.”

## 12. Quick Revision Notes

- Strategy = action rule at all of a player's information sets.
- Count pure strategies by multiplying action counts per information set.
- Profile = one strategy per player.
- Mixed: randomize over plans; behavioral: randomize locally.
- Perfect recall enables realization equivalence.
- Trap: equilibrium path is not the complete strategy.

## 13. Practice Tasks

1. Enumerate strategies in a two-stage entry-deterrence game.
2. Convert the game to normal form and locate Nash equilibria.
3. Find a Nash equilibrium supported by a non-credible threat.
4. Use backward induction to find the subgame-perfect equilibrium.
5. Implement a C++ function that enumerates Cartesian products of actions across information sets.
6. Write a simulator for a behavioral retry policy and estimate terminal-outcome probabilities.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Complete contingent action plan for every information set |
| Why it matters | Equilibrium compares complete policies, including responses to deviations |
| Most asked | Action vs strategy; counting; mixed vs behavioral; credibility |
| Main comparison | Nash tests whole-game deviations; refinements test continuation rationality |
| Interview trap | Never list only the actions actually taken |
| One-line answer | “A strategy says what I would do in every situation I might face, reached or not.” |
