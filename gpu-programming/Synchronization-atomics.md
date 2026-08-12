# GPU Synchronization and Atomics: Placement and Interview Guide

This guide uses NVIDIA CUDA terminology, but most principles apply to SIMT GPUs from other vendors. Code examples assume modern CUDA C++. Exact capabilities, atomic scopes, and memory-order features depend on the GPU architecture and CUDA version.

## Recommended Reading Order

1. [Thread Synchronization](#thread-synchronization)
2. [Block Synchronization](#block-synchronization)
3. [Atomic Operations](#atomic-operations)
4. [Race Conditions](#race-conditions)
5. [Memory Ordering](#memory-ordering)
6. [CUDA Memory Model](#cuda-memory-model)
7. [Warp-Level Synchronization](#warp-level-synchronization)

---

# Atomic Operations

## 1. Overview

An **atomic operation** performs a memory action as one indivisible transaction with respect to other atomic accesses in its scope. A read-modify-write atomic such as `atomicAdd` reads a value, computes a new value, and stores it without another competing atomic update being lost in the middle.

Atomics matter when many GPU threads update a counter, histogram bin, work index, queue pointer, flag, or aggregate. They are used in allocators, graph frontiers, reductions, sparse algorithms, and concurrent data structures. Interviewers ask about them to test whether you can distinguish atomicity from synchronization, reason about contention, and choose between atomics and hierarchical aggregation.

## 2. Core Idea

Suppose 1,000 people increment a scoreboard. A non-atomic update is “read score, add one, write score.” Two people may both read 10 and both write 11, losing one increment. An atomic increment acts like a scoreboard mechanism that accepts one complete increment at a time.

```cpp
__global__ void count_positive(const float* x, int n, unsigned* count) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n && x[i] > 0) atomicAdd(count, 1u);
}
```

Step by step: qualifying threads address the same counter; hardware serializes conflicting atomic updates sufficiently to preserve every increment; each caller receives the old value for fetch-style operations; the final count is correct. The order of individual increments is generally unspecified, and heavy contention can make the single address a bottleneck.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Atomic read-modify-write | Indivisible update of one atomic object. | `atomicAdd`, `atomicExch` | Prevents lost updates, not general races elsewhere. |
| Compare-and-swap (CAS) | Replace value only if it equals an expected value. Universal building block for lock-free algorithms. | `atomicCAS` | CAS retry loop and ABA problem. |
| Atomic scope | Threads that observe one total atomic modification order. | block/device/system scope | Narrower scope can be cheaper. |
| Memory order | Ordering around the atomic beyond indivisibility. | relaxed, acquire, release | Relaxed atomics still atomic but do not publish unrelated data. |
| Return value | Many atomics return the old value, enabling unique ticket allocation. | `slot = atomicAdd(tail, 1)` | Bounds and publication still required. |
| Contention | Multiple threads target the same address and serialize. | global counter | Privatize or aggregate updates. |
| Atomic support | Supported types/operations vary with compute capability and address space. | floating-point `atomicAdd` | Atomic float addition is not mathematically deterministic. |
| CAS loop | Implements unsupported updates by read-compute-CAS retry. | atomic min for custom representation | Handle representation and retry correctly. |

## 4. Real-World Example

For a GPU histogram, the simplest kernel atomically increments global bins. It is correct but slow when the distribution is skewed because many threads contend on popular bins. A practical version builds a per-block histogram in shared memory, synchronizes the block, and has a small number of threads atomically merge block totals into global memory. The algorithm reduces global contention while retaining correctness.

## 5. Diagrams / Mental Models

```text
Non-atomic increment                 Atomic increment
T0 reads 7                          T0: atomicAdd 7 -> 8
T1 reads 7                          T1: atomicAdd 8 -> 9
T0 writes 8                         final = 9
T1 writes 8
final = 8  (lost update)
```

```text
many threads -> per-warp totals -> per-block total -> few global atomics
                 cheap/local          shared             contended
```

## 6. Common Interview Questions

1. **What makes an operation atomic?** Other relevant threads cannot observe or interleave a partial operation on that atomic object. Expected: indivisibility and scope. Mistake: saying all surrounding statements are protected.
2. **Why is `x++` normally unsafe across GPU threads?** It is a read-modify-write sequence whose updates can overlap and be lost. Mistake: believing aligned integer access makes increment atomic.
3. **What does `atomicAdd` return?** CUDA's classic intrinsic returns the old value, useful as a unique ticket. Mistake: assuming it returns the new value.
4. **Are atomics deterministic?** Integer commutative accumulation gives a deterministic mathematical result absent overflow issues, but execution order is unspecified; floating-point accumulation can vary because addition is not associative. Mistake: equating atomic with fixed ordering.
5. **Do atomics replace barriers?** No. Atomics protect an operation on an object; barriers make participants rendezvous. Mistake: using an atomic counter where phase completion requires safe waiting.
6. **How do you reduce atomic contention?** Aggregate per lane, warp, or block; shard counters; improve data partitioning; then perform fewer global atomics. Mistake: adding a lock around the atomic.
7. **What is `atomicCAS`?** Compare the current value with an expected value and conditionally replace it atomically, returning the observed old value. Mistake: ignoring retry when another thread wins.
8. **Can atomics operate in shared memory?** Many can, subject to architecture/type support; scope and performance differ from global atomics. Mistake: assuming shared memory itself makes updates atomic.
9. **What is a relaxed atomic?** It preserves atomicity and the object's modification order without acquire/release ordering for other memory. Mistake: calling it non-atomic.
10. **When should you avoid atomics?** When ownership, reduction structure, prefix sums, sorting, or privatization can eliminate a hot shared update. Mistake: avoiding atomics even when contention is low and simplicity wins.

## 7. Deep-Dive Questions

1. **What is the ABA problem in CAS algorithms?** A value changes A→B→A, so CAS sees A and cannot detect that intervening changes occurred. Use version tags or a design not vulnerable to reuse.
2. **How would you implement atomic floating-point add with CAS?** Load the bit representation, compute the new float, CAS the old bits to new bits, and retry on failure. Handle NaN comparisons using integer bit comparison to avoid infinite retry logic.
3. **Why can system-scope atomics cost more?** They coordinate a wider set of observers, potentially including CPUs or peer devices, requiring stronger coherence/transport behavior than block- or device-scope operations.
4. **Are two atomics on different addresses globally ordered?** Not necessarily in the way a producer-consumer protocol needs. Use explicit memory-order semantics or fences and a well-defined synchronization object.
5. **How do warp-aggregated atomics work?** Participating lanes form a group, one leader atomically reserves a range, and the old base is broadcast so each lane derives a unique offset. This turns up to one atomic per lane into one per group.

## 8. Comparison Tables

| Approach | Correct for shared update? | Contention | Best use |
|---|---:|---|---|
| Plain load/add/store | No | None enforced | Thread-private data |
| Global atomic | Yes | Potentially high | Sparse or low-contention updates |
| Shared/block atomic + merge | Yes with barriers/merge | Localized | Histograms and aggregation |
| Mutex around update | Can be | Very high | Rare complex critical section; usually redesign |
| Reduction | Yes for associative operation | Low | Bulk aggregation |

| Operation | Meaning |
|---|---|
| `atomicAdd` | Add and return old value |
| `atomicExch` | Replace and return old value |
| `atomicCAS` | Conditional replace and return observed old value |
| `atomicMin/Max` | Update with extrema |
| `atomicAnd/Or/Xor` | Atomic bitwise update |

## 9. Common Mistakes

- Treating an atomic variable as a lock for nearby ordinary variables without ordering.
- Assuming atomic access gives deterministic thread order.
- Sending every thread to one global counter without measuring contention.
- Mixing atomic and non-atomic accesses to the same location concurrently.
- Implementing a CAS loop without retrying from the newly observed value.
- Forgetting integer overflow, floating-point rounding, or architecture support.

## 10. Edge Cases / Special Cases

- Atomicity is defined at a particular width, address alignment, address space, and scope.
- Floating-point NaNs and signed zero complicate CAS-based numeric operations.
- Atomic addition on floating point prevents lost updates but cannot remove rounding-order variation.
- A ticket from `atomicAdd` may exceed queue capacity; reservation and bounds handling are separate concerns.
- Host visibility requires suitable system-scope operations, memory type, and host-device coordination; a device-scope atomic alone is not a universal CPU notification mechanism.

## 11. How to Explain in Interview

“An atomic operation makes one access or read-modify-write indivisible for an object within a defined scope. It prevents lost updates to counters and similar shared state, but it is not a barrier and does not automatically order unrelated memory. Under contention, I aggregate locally and issue fewer atomics.”

## 12. Quick Revision Notes

- Atomicity applies to the addressed atomic object, not a whole code block.
- `atomicAdd` commonly returns the old value.
- CAS is the basis of many lock-free updates.
- Relaxed means weak ordering, not weak atomicity.
- Floating-point atomic sums can vary across runs.
- Interview trap: correct does not mean scalable under contention.

## 13. Practice Tasks

1. Implement a global atomic histogram, then a per-block shared histogram; compare correctness and timing for uniform and skewed input.
2. Use `atomicAdd` to compact qualifying elements into an output array and handle capacity safely.
3. Implement atomic maximum for a floating-point representation using CAS and test negative values and NaN policy.
4. Build a warp-aggregated counter and verify every participating lane receives a unique index.
5. Explain why an atomic ready flag needs release/acquire ordering to publish a non-atomic payload.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Indivisible access/update to one atomic object |
| Why it matters | Prevents lost updates under concurrent access |
| Most asked | Atomic vs mutex/barrier; CAS; contention; return value |
| Common comparison | One global atomic vs hierarchical aggregation |
| One-line answer | Atomics give correctness for shared updates; aggregation gives scalability. |

---

# Race Conditions

## 1. Overview

A **race condition** occurs when a program's result depends incorrectly on the relative timing or interleaving of concurrent operations. A **data race** is the specific case where concurrent threads access the same memory location, at least one access is a write, and the accesses are not properly synchronized under the language/memory model.

Races matter because they create intermittent wrong answers, corruption, hangs, or seemingly impossible states. GPUs amplify the problem through massive concurrency. Races appear in reductions, shared-memory tiling, queues, graph traversal, and host-device pipelines. Interviewers ask about them to test causal reasoning: identify the conflicting accesses, the missing happens-before relation, and the smallest correct fix.

## 2. Core Idea

Two clerks edit the same balance. Both read ₹100. One adds ₹20 and writes ₹120; the other subtracts ₹10 and writes ₹90. The correct result is ₹110, but the final value depends on which write happens last.

```cpp
// Incorrect: every thread may race on *sum.
__global__ void bad_sum(const int* x, int n, int* sum) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) *sum += x[i];
}
```

The expression expands conceptually to load, add, store. Multiple threads can load the same old value. A minimal correctness fix is `atomicAdd(sum, x[i])`; a scalable fix for large input is a hierarchical reduction with one small number of global updates.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Read-write race | One thread reads while another writes without ordering. | consumer reads incomplete payload | Visibility and ordering protocol. |
| Write-write race | Multiple threads write same location without ordering. | duplicate output index | Atomic or unique ownership. |
| Lost update | RMW sequences overwrite each other. | non-atomic counter | Expand `++` into load/add/store. |
| Benign-looking race | Writers store the same value, but language rules may still make the access invalid or fragile. | mark flag as `1` | Use an atomic or redesign. |
| Happens-before | Formal ordering relation that makes conflicting access safe and visible. | release flag → acquire flag | Timing delay is not synchronization. |
| Determinism | Same input produces same observable output. | floating reduction order | Race freedom does not guarantee bitwise determinism. |
| Detection tools | Dynamic tools find executed hazards; static reasoning covers unexecuted paths. | Compute Sanitizer Racecheck | Tools do not prove absence of races. |
| Logical race | Operations are individually atomic but combined invariant is wrong. | check-then-act | Atomic primitives alone may not protect compound state. |

## 4. Real-World Example

In breadth-first search, many frontier vertices may discover the same neighbor. A plain `if (!visited[v]) { visited[v] = true; enqueue(v); }` is a check-then-act race: several threads can see false and enqueue duplicates. An atomic compare-and-swap can make exactly one thread transition the vertex from unvisited to visited and enqueue it. Alternatively, the algorithm may tolerate duplicates and remove them later if that is proven correct and faster.

## 5. Diagrams / Mental Models

```text
Time ->
T0: read sum=5 ---- add 2 ---- write 7
T1:    read sum=5 ---- add 3 ------- write 8
Expected: 10       Observed: 7 or 8
```

Race checklist:

```text
Same memory location?
  └─ concurrent access?
       └─ at least one write?
            └─ no valid ordering/atomic rule? -> DATA RACE
```

## 6. Common Interview Questions

1. **What is a race condition?** Incorrect behavior whose outcome depends on concurrent timing. Expected: not every nondeterministic schedule is a bug. Mistake: defining it only as two writes.
2. **What is a data race?** Conflicting unsynchronized accesses to the same location, with at least one write. Mistake: including two ordinary reads.
3. **Why is `counter++` racy?** It is multiple operations and competing updates may read the same old value. Mistake: assuming one source statement means one hardware transaction.
4. **How do you fix a race?** Establish ownership or a happens-before relationship using suitable atomics, synchronization, algorithm partitioning, or barriers at the correct scope. Mistake: adding an arbitrary delay.
5. **Can `__syncthreads()` fix a global race between blocks?** No; it only coordinates one block. Mistake: placing it after a conflicting write from many blocks.
6. **Does `volatile` remove a race?** No. It may affect compiler access behavior but does not provide atomicity or a complete synchronization relationship. Mistake: treating visibility as indivisibility.
7. **Can an atomic program still have a race condition?** Yes. Check-then-act across multiple atomics or inconsistent compound state can have logical races even without a low-level data race. Mistake: “all atomics means correct.”
8. **How do you debug intermittent GPU races?** Minimize the case, use Compute Sanitizer tools, add deterministic validation, inspect every conflicting access and synchronization scope, and avoid relying on printf timing. Mistake: assuming a disappearing bug is fixed.
9. **Is nondeterministic floating-point output proof of a race?** No. A race-free atomic or parallel reduction may change operation order and therefore rounding. Mistake: equating nondeterminism with data races.
10. **What is a write-after-read hazard in shared memory?** A producer overwrites a buffer before all consumers finish reading it; use a barrier before reuse. Mistake: only synchronizing after the original load.

## 7. Deep-Dive Questions

1. **Can two threads writing the same value be considered safe?** Do not rely on it. Under formal models it can still be a data race, tools may report it, and future changes may break the equality assumption. Use an atomic or unique ownership.
2. **What is the difference between race freedom and deterministic output?** Race freedom means accesses obey synchronization rules; deterministic output additionally requires the algorithm and arithmetic/order choices to yield the same result.
3. **How can a race disappear in debug builds?** Instrumentation, lower optimization, extra register spills, and changed timing alter interleavings without repairing the missing ordering.
4. **Why is check-then-act dangerous even with atomic reads and writes?** Another thread may change state between the check and action. Use CAS or a lock/protocol that makes the state transition atomic.
5. **How would you prove a shared-memory kernel race-free?** For every location and phase, identify its writer(s), readers, and ownership; show conflicting accesses are separated by a valid barrier or atomic relation reached by all relevant threads.

## 8. Comparison Tables

| Concept | Meaning | Example |
|---|---|---|
| Data race | Invalid conflicting memory accesses | plain concurrent `sum += x` |
| Race condition | Timing-dependent logical incorrectness | duplicate queue insertion |
| Nondeterminism | Results/order may differ, possibly legally | atomic floating-point sum |
| Deadlock | Participants wait forever | divergent block barrier |

| Fix | Use when | Limitation |
|---|---|---|
| Unique ownership | Data partitions naturally | May need later merge |
| Atomic | One shared state transition/update | Contention and limited compound invariants |
| Block barrier | Cross-thread phases inside one block | No cross-block ordering |
| Separate kernel | Grid-wide phase boundary | Launch overhead/intermediate storage |
| Lock | Complex critical invariant | Serialization; dangerous on GPU |

## 9. Common Mistakes

- Debugging timing instead of identifying conflicting accesses.
- Assuming “usually works” establishes correctness.
- Confusing a data race with any nondeterministic order.
- Using the wrong synchronization scope.
- Protecting the flag but not correctly publishing the payload.
- Fixing one caller while the shared racy update remains elsewhere.
- Forgetting write-after-read races during buffer reuse.

## 10. Edge Cases / Special Cases

- Out-of-bounds writes can look like races but are memory-safety bugs; run memory checking as well as race checking.
- Floating-point reductions may be race-free yet differ by a few ulps.
- Warp-synchronous code may pass on older scheduling behavior and fail on architectures with independent thread scheduling.
- Separate CUDA streams can race on the same buffer unless connected by events or other dependencies.
- Unified memory does not make simultaneous unsynchronized CPU/GPU access safe.

## 11. How to Explain in Interview

“A race condition is timing-dependent incorrect behavior; a data race is specifically an unordered conflicting access to one location with at least one write. I debug it by naming the exact writer and reader, then establishing ownership or the smallest valid happens-before relationship at warp, block, device, or system scope.”

## 12. Quick Revision Notes

- `++` is a read-modify-write, not inherently atomic.
- Same address + concurrency + write + no ordering is the core test.
- `volatile` and delays are not race fixes.
- Block barriers cannot order different blocks.
- Race-free can still be nondeterministic.
- Interview trap: individually atomic steps may form a racy compound protocol.

## 13. Practice Tasks

1. Run a racy counter kernel repeatedly and compare results; then fix it with an atomic and a reduction.
2. Use Racecheck on a shared-memory neighbor kernel with its barrier removed.
3. Implement a BFS visited transition using `atomicCAS` and explain why it prevents duplicate ownership.
4. Analyze a double-buffered tile loop for read-after-write and write-after-read hazards.
5. Create two CUDA streams accessing one buffer, then order them with an event.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Correctness depends improperly on concurrent interleaving |
| Why it matters | Causes intermittent corruption, wrong results, and hangs |
| Most asked | `++` race, volatile myth, atomic vs logical race |
| Common comparison | Data race vs race condition vs nondeterminism |
| One-line answer | Find the conflicting accesses, then create ownership or a valid happens-before edge. |

---

# Thread Synchronization

## 1. Overview

**Thread synchronization** coordinates concurrent threads so that shared work happens in a correct order and shared data is observed in a valid state. On a GPU, thousands of threads may run in an order the programmer cannot predict. Synchronization supplies specific guarantees without making the entire program sequential.

It matters whenever one thread produces data that another consumes, multiple threads update shared state, or a phase must finish before the next begins. It appears in reductions, scans, histograms, tiled matrix multiplication, graph algorithms, queues, and host-device coordination. Interviewers ask about it because correct GPU code requires separating three ideas that beginners often mix up: **execution synchronization**, **memory visibility**, and **atomicity**.

## 2. Core Idea

Imagine cooks sharing a kitchen. A bell can mean “everyone must finish chopping before anyone starts cooking.” A locked cash box can mean “only one cook updates the total at a time.” These solve different problems: the bell orders phases; the lock protects an update.

```cpp
__global__ void block_sum(const float* in, float* blockSums) {
    __shared__ float tile[256];
    int t = threadIdx.x;
    int i = blockIdx.x * blockDim.x + t;

    tile[t] = in[i];                 // phase 1: produce shared data
    __syncthreads();                 // every block thread has produced

    for (int stride = blockDim.x / 2; stride > 0; stride /= 2) {
        if (t < stride) tile[t] += tile[t + stride];
        __syncthreads();             // finish this reduction level
    }

    if (t == 0) blockSums[blockIdx.x] = tile[0];
}
```

Step by step:

1. Every thread writes one shared-memory element.
2. `__syncthreads()` prevents any block thread from entering the reduction before all writes finish and makes earlier shared/global accesses visible within the block.
3. Active threads combine pairs.
4. Each loop barrier prevents the next level from reading partially updated values.
5. One thread publishes the block result.

Without the barriers, the result depends on timing and is a race. A barrier is not a mutex: all participating threads rendezvous rather than one thread gaining exclusive ownership.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Barrier | Participating threads wait until all arrive. Orders phases. | `__syncthreads()` | Barrier versus lock or fence. |
| Memory fence | Orders a thread's memory operations and affects visibility; it does not make other threads wait. | `__threadfence()` | Why a fence is not a barrier. |
| Atomic operation | Makes a read-modify-write indivisible for a location. | `atomicAdd(&count, 1)` | Atomicity does not synchronize unrelated data automatically. |
| Mutex/lock | Gives one thread exclusive access to a critical section. Usually avoided in kernels because spinning can serialize or deadlock poorly designed code. | `atomicCAS` spinlock | Why GPU locks are risky. |
| Scope | Set of threads for which a synchronization guarantee applies. | block, device, system | Choose the narrowest sufficient scope. |
| Producer-consumer | Producer writes payload, then signals; consumer waits for signal, then reads payload. | queue slot plus ready flag | Correct publication requires ordering and visibility. |
| Host-device sync | Coordinates asynchronous kernels and transfers with CPU work. | streams, events, `cudaDeviceSynchronize()` | Kernel launch is normally asynchronous. |
| Cooperative groups | Explicit thread-group abstractions for block, tile, or grid cooperation. | `cg::this_thread_block().sync()` | Better expression of participation scope. |

## 4. Real-World Example

In tiled matrix multiplication, a block cooperatively loads a tile of matrix A and matrix B into shared memory. Threads must wait after loading so no thread multiplies using missing elements. They must wait again before overwriting shared memory with the next tile, or fast threads could destroy values slow threads still need. This is a two-barrier producer/use/reuse pattern repeated per tile.

## 5. Diagrams / Mental Models

```text
Thread 0: write tile[0] ----\                 /---- read all tile entries
Thread 1: write tile[1] -----+-- BARRIER -----+---- read all tile entries
Thread 2: write tile[2] -----+  all arrive    +---- read all tile entries
Thread 3: write tile[3] ----/                 \---- read all tile entries
```

```text
Barrier:  waits + establishes specified visibility for participants
Fence:    orders memory operations; no rendezvous
Atomic:   indivisible operation on one addressed object
Lock:     exclusion around a region; built from atomics if needed
```

## 6. Common Interview Questions

1. **What is thread synchronization?** It is coordination that constrains execution and memory observation among concurrent threads. Expected: ordering, visibility, and participating scope. Common mistake: saying it merely “stops threads.”
2. **Why is synchronization needed on a GPU?** GPU thread scheduling and relative progress are not generally predictable. Expected: data dependencies and shared-state correctness. Mistake: assuming thread ID determines execution order.
3. **What does `__syncthreads()` guarantee?** All non-exited threads in the block wait, and prior shared/global memory accesses become visible to block threads according to CUDA semantics. Mistake: claiming it synchronizes the whole grid.
4. **Is a memory fence a barrier?** No. A fence orders the calling thread's memory operations but does not wait for peers. Mistake: using `__threadfence()` alone as a rendezvous.
5. **Is an atomic operation a barrier?** No. It serializes the relevant access to one object; other threads do not rendezvous. Mistake: assuming an atomic counter automatically makes a payload visible without a publication protocol.
6. **Can `__syncthreads()` appear inside an `if`?** Only if the condition is uniform for every participating, non-exited thread in the block. Otherwise some threads wait forever or behavior is undefined. Mistake: putting it under `if (threadIdx.x < 32)`.
7. **Can blocks synchronize inside a normal kernel?** Not with `__syncthreads()`. Use separate kernel launches, cooperative grid synchronization when launch constraints are met, or a carefully designed global protocol. Mistake: a global counter followed by an ordinary block barrier.
8. **Why are spinlocks unattractive on GPUs?** Contention serializes work, consumes execution resources, and same-warp lock holders/waiters can interact badly. Expected: prefer partitioning, atomics, or staged kernels. Mistake: directly transplanting CPU locking designs.
9. **How does stream synchronization work?** Work in one stream is ordered; events or explicit stream/device synchronization express cross-stream or host dependencies. Mistake: assuming all streams execute strictly one after another.
10. **What is the cost of synchronization?** Waiting, reduced overlap, memory-ordering overhead, and possibly lower occupancy or contention. Expected: correctness first and narrow scope. Mistake: assigning one fixed cycle cost.

## 7. Deep-Dive Questions

1. **Why can a grid-wide software barrier deadlock?** A kernel may have more blocks than can reside concurrently. Resident blocks spin at the barrier while unscheduled blocks cannot start and increment the arrival count. Cooperative launch avoids this by guaranteeing compatible residency.
2. **Does independent thread scheduling remove the need for synchronization?** No. It makes implicit warp-synchronous assumptions even less safe. Communication still needs the appropriate warp primitive, barrier, atomic, or memory order.
3. **How do you publish data with a flag?** Write the payload, use release semantics on the flag; the consumer loads the flag with acquire semantics before reading the payload. With older primitives, combine the right fence and atomic signaling carefully.
4. **When should an algorithm use multiple kernels instead of a global barrier?** When work naturally has grid-wide phases. Kernel completion is a simple global synchronization boundary and avoids cooperative-launch residency restrictions.
5. **Can synchronization fix all races?** No. Threads must actually participate in the same synchronization relationship, and conflicting accesses must be ordered. A block barrier cannot order accesses between blocks.

## 8. Comparison Tables

| Primitive | Waits for peers? | Protects/affects | Typical scope | Primary purpose |
|---|---:|---|---|---|
| `__syncwarp(mask)` | Yes | Participating warp lanes | Warp subset | Warp rendezvous and visibility |
| `__syncthreads()` | Yes | Block-visible accesses | Block | Phase boundary |
| `__threadfence_block()` | No | Calling thread's memory order | Block | Publish within block |
| `__threadfence()` | No | Calling thread's memory order | Device | Publish across device |
| Atomic RMW | No | One atomic object | Depends on scope | Indivisible update |
| Kernel boundary | Host sequencing determines wait | Completed kernel writes | Device/grid | Grid-wide phase separation |

## 9. Common Mistakes

- Assuming threads execute in increasing ID order.
- Using `volatile` as a replacement for atomics, fences, or barriers.
- Calling a block barrier from only part of a block.
- Believing a fence makes other threads wait.
- Believing an atomic protects adjacent non-atomic data.
- Adding synchronization “for safety” without checking scope or dependency, harming performance and sometimes correctness.
- Relying on implicit warp lockstep rather than `__syncwarp()` and correct masks.

## 10. Edge Cases / Special Cases

- Threads that return before a later block barrier can make participation invalid; structure code so all required threads reach every barrier.
- A barrier inside a uniform branch is valid; a syntactically identical branch is not enough if its condition differs per thread.
- Kernel completion orders later work in the same CUDA stream, but different streams require explicit dependencies when they share data.
- Unified memory does not eliminate synchronization; ownership migration and visibility still follow CUDA rules.
- Dynamic parallelism, cooperative groups, clusters, and system-scope atomics introduce additional scopes and hardware/version constraints.

## 11. How to Explain in Interview

“GPU thread synchronization establishes the execution and memory relationships needed when threads share data. I choose a primitive by scope and purpose: a barrier for a phase rendezvous, a fence or acquire-release operation for publication, and an atomic for an indivisible shared update. `__syncthreads()` is block-local, so grid-wide phases usually need separate kernels or a cooperative launch.”

## 12. Quick Revision Notes

- Synchronization is about **who**, **what**, and **when**.
- Execution barrier, memory fence, and atomic operation are different.
- `__syncthreads()` covers one block, not a grid.
- All required block threads must reach a block barrier.
- Same stream orders work; separate streams need dependencies.
- Interview trap: a fence does not wait, and an atomic is not a general barrier.

## 13. Practice Tasks

1. Implement a shared-memory block reduction and remove each barrier one at a time; use Compute Sanitizer Racecheck to observe hazards.
2. Write a tiled matrix multiplication and label the load, use, and reuse phases.
3. Replace a two-kernel grid-wide phase boundary with cooperative groups; document launch restrictions.
4. Build a one-producer/one-consumer slot using an atomic ready flag with release/acquire semantics.
5. Draw the synchronization scope required for warp-, block-, device-, and CPU-visible communication.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Coordination that orders execution and memory observation |
| Why it matters | GPU scheduling is nondeterministic relative to data dependencies |
| Most asked | Barrier vs fence vs atomic; scope of `__syncthreads()` |
| Common comparison | Rendezvous vs ordering vs indivisible update |
| One-line answer | Synchronize at the narrowest scope that correctly orders every conflicting access. |

---

# Block Synchronization

## 1. Overview

**Block synchronization** coordinates threads belonging to the same CUDA thread block. Because a block is scheduled as a unit on one streaming multiprocessor and its threads share on-chip shared memory, CUDA can provide efficient block-wide barriers such as `__syncthreads()`.

It matters in cooperative algorithms where threads load a tile, compute partial values, reuse a buffer, or reduce results. It is used in matrix multiplication, convolution, scans, histograms, sorting networks, and stencil codes. Interviewers ask about it to verify that you understand synchronization scope, barrier participation, shared-memory visibility, and why blocks normally cannot coordinate with a block primitive.

## 2. Core Idea

Think of a block as a project team sharing one whiteboard. Before anyone uses the completed table, every member must finish writing their assigned row. The team can hold an inexpensive meeting because they are in one room; teams in different rooms need a different mechanism.

```cpp
__global__ void neighbor_sum(const float* x, float* y) {
    extern __shared__ float s[];
    unsigned t = threadIdx.x;
    unsigned i = blockIdx.x * blockDim.x + t;

    s[t] = x[i];
    __syncthreads();
    if (t > 0) y[i] = s[t] + s[t - 1];
}
```

Each thread writes `s[t]`. Thread `t` then reads `s[t - 1]`, which another thread wrote. The barrier ensures all writes happen before any post-barrier read. A barrier is unnecessary for reading a thread's own independent slot, but necessary for this cross-thread dependency.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| `__syncthreads()` | Full-block execution barrier plus documented memory visibility. | Tile load before tile use | All threads must participate consistently. |
| Barrier convergence | Every non-exited thread expected by the barrier reaches it. | Uniform loop trip count | Divergent barrier can hang or be undefined. |
| Shared memory | Per-block scratchpad enabling fast cooperation. | Matrix tiles | Shared memory alone does not prevent races. |
| Barrier reuse | Hardware barrier can be used repeatedly after all participants leave the prior phase. | Reduction loop | Each iteration must have uniform participation. |
| Barrier reductions | `__syncthreads_count`, `_and`, and `_or` combine a predicate while synchronizing. | Count active conditions | Avoid separate shared counter and barrier. |
| Cooperative groups | Named group synchronization and partitioning. | `thread_block`, tiled group | Makes scope and participants explicit. |
| Asynchronous copy barriers | Modern pipelines coordinate `memcpy_async`/`cp.async` completion and consumption. | Global-to-shared staging | Wait for data readiness, not merely instruction issue. |
| Cluster synchronization | Newer architectures may synchronize blocks in a cluster and access distributed shared memory. | Cluster histogram | Not equivalent to arbitrary grid sync. |

## 4. Real-World Example

A convolution kernel loads an input tile plus halo pixels into shared memory. Different threads load different elements. The block synchronizes before convolution so every neighborhood is complete. After computing the current output tile, the block may synchronize again before reusing the shared buffer for the next channel. Missing the first barrier reads uninitialized/stale values; missing the second permits early overwrite.

## 5. Diagrams / Mental Models

```text
             Same CUDA block
     +--------------------------------+
T0 ->| load s[0]  \                   |
T1 ->| load s[1]   +-> __syncthreads  |-> all may read s[]
T2 ->| load s[2]   +   (rendezvous)   |
T3 ->| load s[3]  /                   |
     +--------------------------------+

Block A barrier  X  Block B threads
                 cannot synchronize across this boundary
```

## 6. Common Interview Questions

1. **What is block synchronization?** Coordination among threads in one block, commonly with `__syncthreads()`. Expected: block scope and shared-memory cooperation. Mistake: calling it grid synchronization.
2. **What exactly does `__syncthreads()` do?** It blocks participating threads until all required block threads arrive and exposes prior memory accesses to block peers. Mistake: describing only cache flushing.
3. **Why can CUDA synchronize a block efficiently?** Its threads are assigned together to one SM and share hardware barrier resources and shared memory. Mistake: claiming all threads execute simultaneously.
4. **Can blocks use `__syncthreads()` to communicate?** No. Each block has its own barrier instance and shared memory. Mistake: assuming same `threadIdx.x` links blocks.
5. **Why is a conditional barrier dangerous?** If the condition differs, some threads wait for peers that never arrive. Expected: condition must be uniform across the block. Mistake: “safe if only one warp enters.”
6. **Does `__syncthreads()` serialize all threads?** It creates a phase boundary but work before and after remains parallel. Mistake: equating barrier with single-thread execution.
7. **When do you need two barriers around shared-memory reuse?** One ensures production before consumption; another ensures all consumers finish before overwrite. Mistake: keeping only the first barrier.
8. **Can a warp-level barrier replace a block barrier?** Only when every dependency is confined to the named warp lanes. Mistake: using `__syncwarp()` while reading values written by another warp.
9. **What are `__syncthreads_count/and/or`?** Block barriers that also reduce a predicate into a count or Boolean result. Mistake: thinking they atomically modify arbitrary data.
10. **What is the performance cost?** Barrier instruction cost plus waiting for the slowest warp and reduced scheduling freedom. Mistake: removing required barriers solely for speed.

## 7. Deep-Dive Questions

1. **How can a barrier be correct inside a loop?** Every participating thread must execute the same number of barrier instances in compatible order. Per-thread early exits or different trip counts violate this.
2. **Can a barrier solve bank conflicts?** No. It orders access; it does not change how addresses map to shared-memory banks. Padding or access-layout changes address conflicts.
3. **Why might a block barrier reduce occupancy?** The barrier itself does not necessarily change theoretical occupancy, but shared-memory/register-heavy cooperative designs do; waiting blocks also expose insufficient resident work if occupancy is low.
4. **How do asynchronous shared-memory copies change synchronization?** Threads can overlap copies with computation, but must use the pipeline/arrival-wait mechanism required by the API before consuming the copied stage.
5. **How do cluster barriers differ?** They coordinate a defined cluster of blocks on supported hardware, often with distributed shared memory. They broaden scope beyond a block but remain narrower and more constrained than a general grid barrier.

## 8. Comparison Tables

| Feature | Warp sync | Block sync | Grid sync |
|---|---|---|---|
| Common primitive | `__syncwarp(mask)` | `__syncthreads()` | `grid.sync()` cooperative groups or kernel boundary |
| Participants | Named lanes | Threads in one block | All blocks in cooperative grid |
| Typical memory | Registers/shared | Shared/global | Global |
| Cost | Lowest | Moderate | Highest |
| Major constraint | Correct mask | Uniform participation | Cooperative launch/residency or relaunch |

| Need | Correct choice |
|---|---|
| All block threads finished loading a tile | `__syncthreads()` |
| Only lanes in one warp exchange registers | Warp shuffle plus required warp sync semantics |
| Order current thread's writes before a device-wide flag | Release atomic or device fence plus signal |
| All blocks finish phase 1 | Kernel boundary or cooperative grid sync |

## 9. Common Mistakes

- Placing `__syncthreads()` in a lane-dependent branch.
- Forgetting the barrier before shared-memory buffer reuse.
- Assuming a barrier initializes shared memory.
- Replacing a block barrier with warp synchronization even when multiple warps exchange data.
- Synchronizing after every instruction instead of at actual dependency boundaries.
- Believing the scheduler runs every block concurrently.

## 10. Edge Cases / Special Cases

- A block size smaller than one warp still has block semantics; do not assume inactive physical lanes are CUDA threads.
- A uniform condition derived from `blockIdx` can guard a block barrier safely; a condition derived from `threadIdx` usually needs scrutiny.
- Threads may exit before a barrier only when the program's barrier semantics remain valid for all required participants; simple interview-safe advice is to keep early returns away from later barriers.
- Shared-memory atomics can coordinate updates but may still need a barrier before results are consumed.
- Barrier throughput and implementation vary by compute capability.

## 11. How to Explain in Interview

“Block synchronization coordinates threads assigned to the same CUDA block. `__syncthreads()` forms a block-wide phase boundary and makes earlier relevant memory operations visible to block peers. Every required thread must reach it, and it cannot synchronize different blocks; grid-wide phases usually use another kernel or cooperative grid synchronization.”

## 12. Quick Revision Notes

- Scope: one block on one SM.
- Shared memory is visible to a block but still needs ordering.
- Load → barrier → use → barrier → reuse is the classic pattern.
- Conditional barriers require block-uniform control flow.
- Warp sync is insufficient for cross-warp dependencies.
- Interview trap: a block barrier is not a grid barrier.

## 13. Practice Tasks

1. Implement tiled matrix multiplication and justify both barriers in each tile iteration.
2. Write a shared-memory scan; label which reads depend on which writes.
3. Introduce an early return before a barrier and use `compute-sanitizer --tool synccheck` to inspect it.
4. Replace a shared counter plus barrier with `__syncthreads_count()` where appropriate.
5. Compare a warp-only reduction against a multi-warp block reduction and identify the point requiring block synchronization.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Same-block rendezvous and visibility |
| Why it matters | Enables safe cooperative use of shared memory |
| Most asked | Scope, conditional barriers, why two barriers are needed |
| Common comparison | Warp vs block vs grid synchronization |
| One-line answer | `__syncthreads()` separates block-wide phases; every participating thread must reach it. |

---

# Memory Ordering

## 1. Overview

**Memory ordering** defines which memory operations may be observed before or after others when compilers, processors, caches, and interconnects execute concurrently. Source-code order alone does not guarantee that another GPU thread observes writes in that order.

It matters in producer-consumer queues, ready flags, locks, work stealing, device-host communication, and any protocol where data is written and then announced. Interviewers ask about it because an atomic update can be indivisible yet still use ordering too weak to publish surrounding data correctly.

## 2. Core Idea

A restaurant places a meal on a pickup shelf and then turns on the “ready” light. The customer must not see the light before the meal is actually visible. The producer needs **release** ordering when signaling; the consumer needs **acquire** ordering when observing the signal.

```cpp
// Conceptual CUDA C++ atomics
payload[slot] = value;
ready.store(true, cuda::std::memory_order_release);

// Consumer
if (ready.load(cuda::std::memory_order_acquire)) {
    use(payload[slot]);
}
```

Step by step:

1. Producer writes the ordinary payload.
2. Release store prevents that earlier write from being ordered after publication.
3. Consumer's acquire load observes the released flag value.
4. The matching release/acquire relation makes preceding producer writes visible to subsequent consumer reads within the selected scope.

The atomic flag supplies a synchronization point; acquire/release supplies ordering for surrounding memory. `relaxed` would keep the flag atomic but would not create this publication guarantee.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Program order | Order prescribed within one thread before allowed transformations. | payload then flag in source | Other threads need synchronization to rely on it. |
| Modification order | Per-atomic-object total order of its writes/RMWs. | all updates to one counter | Does not imply one global order across all objects. |
| Relaxed | Atomicity without cross-object synchronization. | statistics counter | Fast when only final value matters. |
| Acquire | Later operations cannot move before a successful acquiring observation in the relevant sense. | consume published payload | Usually used by reader. |
| Release | Earlier operations are published before release. | store ready flag | Usually used by writer. |
| Acquire-release | Both properties for RMW operations. | lock acquisition/release protocol | Useful when operation both consumes and publishes. |
| Sequential consistency | Strong ordering giving a single order consistent with participating operations' program order. | simplest reasoning | Stronger than often necessary; scope still matters. |
| Fence | Orders operations without itself necessarily naming the synchronization object. | device fence before signal | Fence plus correct communication operation required. |
| Scope | Defines which agents participate in ordering. | block/device/system | Correct order at wrong scope is still wrong. |

## 4. Real-World Example

A GPU work queue has an array of tasks and a `tail`/ready state. A producer reserves a slot, fills the task fields, and publishes readiness with release semantics. A consumer observes readiness with acquire semantics before reading the fields. If the producer increments a visible counter before the task is fully published, the consumer may process partial data even though the counter update itself is atomic.

## 5. Diagrams / Mental Models

```text
Producer thread                         Consumer thread
payload = 42
     | program order
release(flag = 1)  ---- synchronizes-with ----> acquire(load flag == 1)
                                                   |
                                                   v
                                             read payload == 42

Combined relation: payload write happens-before payload read
```

| Order | Atomic object safe? | Publishes earlier data? | Typical use |
|---|---:|---:|---|
| Relaxed | Yes | No | counters, unique tickets |
| Acquire | Yes | Consumes a release | reading ready/lock |
| Release | Yes | Yes, to matching acquire | publishing ready/unlock |
| Acq_rel | Yes | Both | state-transition RMW |
| Seq_cst | Yes | Yes plus strongest common ordering | simplest cross-thread reasoning |

## 6. Common Interview Questions

1. **What is memory ordering?** Rules governing how one thread's memory operations become ordered and observable to others. Expected: compiler and hardware effects plus synchronization. Mistake: only discussing instruction execution order.
2. **What does relaxed atomic mean?** The access remains atomic and participates in that object's modification order but does not order unrelated memory. Mistake: saying it can tear or lose updates.
3. **What are acquire and release?** Release publishes prior operations; an acquire that observes it makes those operations visible before subsequent consumer work. Mistake: using acquire on producer and release on consumer by rote.
4. **What is happens-before?** A relation establishing that effects of one operation are ordered before another; it combines sequencing and synchronization relationships. Mistake: equating wall-clock completion with formal ordering.
5. **Why is `payload=x; flag=1;` unsafe without synchronization?** Another thread may observe the flag without a guarantee that the payload is visible or race-free. Mistake: relying on source order.
6. **Does an atomic flag automatically publish data?** Only with suitable memory order and scope or an equivalent fence-based protocol. Mistake: “atomic means full fence.”
7. **When is relaxed ordering appropriate?** When only atomicity/modification order of that object matters, such as a counter read after kernel completion. Mistake: using relaxed for a ready flag that guards data.
8. **What does a fence do?** It constrains ordering/visibility of the calling thread's operations at a scope; it does not wait or by itself tell consumers when to read. Mistake: treating it as a barrier.
9. **Is sequential consistency always required?** No. Acquire/release or relaxed often expresses the actual dependency with less constraint. Mistake: weakening order without proving the protocol.
10. **Why does scope matter?** A block-scope relation does not synchronize agents outside that block; device and system observers need broader scopes. Mistake: discussing order while omitting participants.

## 7. Deep-Dive Questions

1. **Can a consumer use a relaxed load after the producer uses release?** Not to establish release/acquire publication. The consumer needs an acquiring operation or another valid synchronization path.
2. **What is a release sequence?** In C++-style models, a release operation and qualifying following modifications to the same atomic can allow an acquire that observes the sequence to synchronize with the original release; exact CUDA API semantics/version should be checked.
3. **Why is sequential consistency not simply “actual execution order”?** It is an abstract order for relevant atomic operations consistent with required program orders; physical execution can still be optimized if observable guarantees hold.
4. **How can a fence-based publication work?** Producer writes payload, executes a release/device fence, then signals atomically; consumer observes the signal using the matching protocol before reading. Modern acquire-release atomics express this more directly.
5. **Can ordering repair a non-atomic multi-writer counter?** No. Ordering does not make a read-modify-write indivisible. Use an atomic RMW or establish exclusive ownership.

## 8. Comparison Tables

| Concept | Guarantees | Does not guarantee |
|---|---|---|
| Atomicity | Operation is indivisible at its scope | Ordering of unrelated data unless specified |
| Visibility | A write can be observed by relevant peers under the model | All peers have reached a point |
| Ordering | Operations cannot be observed in forbidden order | Mutual exclusion |
| Barrier | Participants rendezvous and receive documented visibility | Cross-scope synchronization |

| Fence scope | Intended observers |
|---|---|
| Block | Threads in the same block |
| Device | Threads on the GPU/device |
| System | Device plus supported system participants such as CPU/peers |

## 9. Common Mistakes

- Assuming source order is automatically inter-thread observation order.
- Calling relaxed atomics “non-atomic.”
- Using acquire/release at a scope that excludes the communicating thread.
- Applying a fence but no valid signal/observation protocol.
- Assuming one atomic gives a total order for different atomic objects.
- Using `volatile` to emulate acquire/release semantics.

## 10. Edge Cases / Special Cases

- If an acquire load does not observe the relevant release (or its permitted sequence), the expected synchronization edge may not exist.
- Atomic scope and memory order are independent choices: strong order with narrow scope may still be insufficient.
- Kernel launches, stream ordering, events, and host synchronization create higher-level ordering relationships that may make in-kernel atomics unnecessary.
- Memory-mapped host memory and peer devices require supported system-scope/coherence behavior; portability assumptions must be checked.
- Compiler optimizations are constrained by the formal model, not by what a debugger happens to display.

## 11. How to Explain in Interview

“Memory ordering controls how operations around synchronization become observable across threads. A release operation publishes earlier writes, and an acquire that observes it makes those writes available before later reads. Relaxed atomics preserve atomicity but do not publish unrelated data, and every guarantee has a scope.”

## 12. Quick Revision Notes

- Relaxed: atomicity, no payload publication.
- Release publishes; acquire consumes.
- Acquire/release requires a matching communication path.
- Fence is ordering, not waiting.
- Order and scope must both be correct.
- Interview trap: one atomic object's order is not a universal global timeline.

## 13. Practice Tasks

1. Draw the happens-before graph for a producer writing payload then a ready flag.
2. Classify atomic counter, queue-ready flag, and lock operations by minimum plausible memory order.
3. Implement a single-slot producer-consumer protocol with CUDA C++ atomics and explicit scope.
4. Explain why changing only the producer's flag store to release is insufficient if the consumer load is relaxed.
5. Compare a kernel-boundary solution with an in-kernel release/acquire protocol for clarity and cost.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Rules for ordering and observing concurrent memory operations |
| Why it matters | Atomic data can still be published incorrectly |
| Most asked | Relaxed vs acquire/release; fence vs barrier; happens-before |
| Common comparison | Atomicity vs ordering vs visibility |
| One-line answer | Release publishes, acquire observes, and scope names who is included. |

---

# CUDA Memory Model

## 1. Overview

The **CUDA memory model** defines how CUDA threads and host code access memory, what is visible at each execution scope, and which synchronization operations establish correct communication. It combines CUDA's hierarchy—thread, warp, block, device, system—with memory spaces such as registers/local, shared, global, constant, and managed memory.

It matters because physically shared storage does not imply safely synchronized access. The model determines whether a shared-memory exchange, global producer-consumer flag, cross-stream dependency, or CPU-GPU handoff is valid. Interviewers ask about it to ensure candidates can map an algorithm's communication pattern to the correct memory space, synchronization primitive, and scope.

## 2. Core Idea

Think of CUDA as a campus:

- A thread's registers are its private notebook.
- Shared memory is a whiteboard in one classroom (block).
- Global memory is a campus archive accessible by all blocks.
- System-visible memory can be shared with the outside office (CPU/peers), subject to supported mechanisms.

Access to the same building does not mean everyone sees updates at the same instant. The program needs a defined handoff.

```cpp
__global__ void publish(int* payload, cuda::atomic<int,
                        cuda::thread_scope_device>* ready) {
    if (blockIdx.x == 0 && threadIdx.x == 0) {
        *payload = 42;
        ready->store(1, cuda::memory_order_release);
    }
}
```

A device-scope acquire load by another device thread that observes `1` can consume the payload. But a block-scope atomic would be too narrow for another block, and a CPU observer may require system scope plus supported memory/coherence and host coordination.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Address spaces | Storage with different visibility, lifetime, caching, and performance. | shared vs global | Visibility scope is not the same as speed. |
| Thread hierarchy | Threads group into warps, blocks, grids, and possibly clusters. | block-local tile | Synchronization follows hierarchy. |
| Consistency | Rules for when observers may see writes. | global payload plus flag | Global memory is not automatically phase-consistent. |
| Thread scopes | Block, device, and system scope for atomics/fences. | scoped `cuda::atomic` | Narrowest correct scope. |
| Coherence/caches | Cache behavior interacts with visibility, but programmers should use model primitives, not cache guesses. | L1/L2 paths | `volatile` is not a universal coherence solution. |
| Kernel/stream order | A stream orders its queued operations; events connect streams. | kernel A then B | Kernel boundaries are useful global phase boundaries. |
| Unified memory | One virtual allocation may migrate/be accessed by CPU and GPU. | managed array | Unified address does not remove data-race rules. |
| Host-device handoff | API synchronization establishes when CPU may safely consume GPU results. | event synchronize, memcpy | Launch completion is normally asynchronous. |
| CUDA C++ atomics | Standard-like memory orders combined with CUDA thread scopes. | `cuda::atomic<T, Scope>` | Both order and scope matter. |

## 4. Real-World Example

A backend inference service fills an input buffer on the CPU, asynchronously copies it to a device stream, runs preprocessing and inference kernels in that same stream, then records an event. The stream order ensures each GPU stage sees the prior stage's results. The CPU waits on the event before reading the copied-back output. No device-wide synchronization is needed; the memory model and stream dependency create the required handoffs while allowing unrelated streams to overlap.

## 5. Diagrams / Mental Models

```text
System scope: CPU + GPU(s), where supported
└── Device scope: all threads on one GPU
    └── Block scope: all threads in one block
        └── Warp/lane cooperation
            └── Thread-private registers/local state
```

| Memory space | Typical owner/visibility | Lifetime | Synchronization concern |
|---|---|---|---|
| Registers | One thread | Thread | Exchange via shuffle/shared memory |
| Local memory | Logically one thread, physically device memory | Thread | Not a shared communication space |
| Shared memory | One block (or cluster features where applicable) | Block | Block/cluster ordering |
| Global memory | Device threads; host through APIs/mappings | Allocation | Device/system ordering and API dependencies |
| Constant memory | Grid-readable, host-updated between work | Context/allocation | Do not mutate from ordinary device code |
| Managed memory | Unified virtual allocation | Allocation | Migration plus synchronization still applies |

## 6. Common Interview Questions

1. **What is the CUDA memory model?** Rules connecting CUDA execution scopes, memory spaces, visibility, ordering, and synchronization. Mistake: listing memory types without consistency rules.
2. **Is global memory immediately visible to all threads?** Do not assume useful program-order visibility without a synchronization relationship. Expected: use atomics/fences/barriers or phase boundaries. Mistake: “global means synchronized.”
3. **What memory can block threads share efficiently?** Shared memory, coordinated with block synchronization where accesses depend on peers. Mistake: assuming access is race-free because it is shared.
4. **What does `__threadfence()` guarantee?** It orders the calling thread's relevant memory operations for device-scope observation; it does not stop other threads or itself announce completion. Mistake: calling it a device barrier.
5. **How do kernels in the same stream observe one another?** Stream order makes later work begin after earlier work completes as specified, providing a natural phase ordering. Mistake: adding in-kernel grid barriers unnecessarily.
6. **How do different streams share a buffer safely?** Record an event after the producer and make the consumer stream wait on it, or otherwise explicitly synchronize. Mistake: relying on launch order across independent streams.
7. **Does unified memory mean coherent simultaneous CPU/GPU access?** Not universally; legal concurrent access and visibility depend on platform capabilities and synchronization. Mistake: confusing one address with automatic race freedom.
8. **What is the difference between block-, device-, and system-scope atomics?** They define increasingly broad sets of threads/agents participating in atomic synchronization. Mistake: choosing scope based only on memory location.
9. **What is local memory?** Per-thread logical storage that may reside in device memory, often due to spills or arrays. Mistake: confusing it with fast on-chip shared memory.
10. **Why should code use model primitives instead of cache assumptions?** Cache policies and hardware vary; atomics, fences, barriers, and API dependencies express portable correctness. Mistake: assuming an L2 write automatically establishes a protocol.

## 7. Deep-Dive Questions

1. **How does a last-block reduction pattern work?** Each block writes its partial result, executes appropriate device-scope publication ordering, then atomically increments a completion counter. The block observing the final count can safely consume partials only if the protocol establishes visibility correctly.
2. **What changes with peer GPUs?** Addressability, peer access, atomic support, and system scope depend on topology and platform capabilities; ordinary device-scope operations on one GPU may not synchronize another.
3. **How do mapped pinned host memory atomics differ from normal global memory?** They cross the device-system boundary and require supported atomicity/coherence and system scope; PCIe/interconnect cost can dominate.
4. **Does L1 bypass or `volatile` solve publication?** It may influence how accesses are generated/cached, but correct communication still needs the memory model's ordering and synchronization guarantees.
5. **How do memory model and occupancy interact?** They are distinct: the model defines correctness; occupancy affects whether software protocols such as spinning can make progress and whether enough other warps hide latency.

## 8. Comparison Tables

| CUDA mechanism | Scope/role | Waits? | Typical use |
|---|---|---:|---|
| `__syncwarp()` | Named warp lanes | Yes | Warp exchange |
| `__syncthreads()` | Block | Yes | Shared-memory phases |
| `__threadfence_block()` | Block visibility order | No | Block publication protocol |
| `__threadfence()` | Device visibility order | No | Cross-block publication protocol |
| `__threadfence_system()` | System visibility order | No | Supported CPU/peer publication |
| Event/stream wait | Work dependency | Consumer waits as scheduled | Cross-stream pipeline |
| Kernel completion | Grid phase | Later dependent work waits | Global phase boundary |

## 9. Common Mistakes

- Equating memory space visibility with synchronization.
- Calling local memory “shared within an SM.”
- Assuming default-stream behavior applies identically to every configuration and stream type.
- Using a block-scope primitive for cross-block communication.
- Assuming unified memory makes simultaneous access safe.
- Designing around a guessed cache behavior instead of documented semantics.
- Forgetting that host API operations can be asynchronous.

## 10. Edge Cases / Special Cases

- Default stream semantics can depend on legacy versus per-thread default stream configuration; use explicit streams/events for clear dependencies.
- Pageable versus pinned host memory changes transfer behavior and overlap, but not the need for correct synchronization.
- Cooperative groups grid synchronization requires a cooperative launch and resource constraints that allow all participating blocks to be resident as required.
- Cluster scope and distributed shared memory are architecture-specific extensions, not universal CUDA assumptions.
- Texture/constant/read-only caching has specialized semantics; do not use read-only paths for mutable inter-thread publication.

## 11. How to Explain in Interview

“The CUDA memory model combines a hierarchy of participants with memory spaces and synchronization rules. Shared memory is block-visible, global memory is broadly addressable, and system-visible memory may include the CPU, but addressability alone is not ordering. I pair the communication path with the right barrier, atomic order, fence, event, or kernel boundary and the narrowest sufficient scope.”

## 12. Quick Revision Notes

- Registers/local: thread-private logically.
- Shared: block cooperation; global: device-wide addressability.
- Visibility does not imply ordering or race freedom.
- Same-stream work is ordered; cross-stream dependencies need events/sync.
- Unified memory unifies addresses, not synchronization rules.
- Interview trap: `__threadfence()` is not a grid barrier.

## 13. Practice Tasks

1. Classify every allocation and synchronization edge in a tiled reduction pipeline.
2. Build two-stream producer/consumer kernels connected by a CUDA event.
3. Implement a multi-block “last block finishes reduction” pattern and explain its fence/atomic ordering.
4. Compare block-, device-, and system-scope atomics in a communication-scope diagram.
5. Use Nsight Systems to verify overlap and dependencies among H2D copy, kernel, and D2H copy.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | CUDA rules for memory spaces, visibility, order, and scopes |
| Why it matters | Addressable memory is not automatically synchronized memory |
| Most asked | Memory spaces, fence semantics, stream order, atomic scopes |
| Common comparison | Block vs device vs system scope |
| One-line answer | Match every communication path to its memory space, ordering primitive, and participant scope. |

---

# Warp-Level Synchronization

## 1. Overview

**Warp-level synchronization** coordinates selected lanes within a warp, the hardware's SIMT execution group. In CUDA a warp is currently 32 threads, but portable code should use `warpSize` and the documented primitive contracts rather than hard-code scheduling assumptions.

It matters for fast reductions, scans, ballots, compaction, voting, register exchange, and fine-grained algorithms that do not require an entire block. Warp operations avoid shared-memory traffic and block-wide barriers. Interviewers ask about them because older “warp-synchronous” folklore is unsafe under divergence and independent thread scheduling; correct code must use participation masks and explicit synchronization semantics.

## 2. Core Idea

Imagine 32 people seated in one row. Instead of writing values to a shared board, each can pass a value directly to another seat. A roll call mask identifies exactly which people are taking part, and every named participant must execute the matching operation.

```cpp
__device__ float warp_sum(float value) {
    unsigned mask = __activemask();
    for (int offset = warpSize / 2; offset > 0; offset /= 2)
        value += __shfl_down_sync(mask, value, offset);
    return value; // lane 0 of a full warp has the complete sum
}
```

At offset 16, lower lanes add values from lanes 16 positions ahead; then offsets 8, 4, 2, and 1 combine progressively smaller groups. Values move through the register exchange network. The mask states which lanes participate; code must not read a source lane that is inactive or outside the intended group.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Warp | SIMT scheduling/execution group, currently 32 CUDA threads. | lanes 0–31 | Warp is not a block. |
| Active mask | Bit set of lanes active at a point. | `__activemask()` | A snapshot is not automatically the logical group needed later. |
| Shuffle | Direct register-value exchange among lanes. | `__shfl_down_sync` | Faster/simpler than shared memory for warp-local data. |
| Vote | Combine per-lane predicates. | `__all_sync`, `__any_sync` | Returns warp/group decision. |
| Ballot | Produce a bit mask of lanes whose predicate is true. | `__ballot_sync` | Basis for compaction and leader selection. |
| Match | Find lanes holding equal values. | `__match_any_sync` | Warp aggregation by key. |
| `__syncwarp(mask)` | Rendezvous named lanes and provides documented memory ordering among them. | shared exchange in a warp | Correct mask and participation required. |
| Cooperative groups tile | Typed subgroup abstraction. | `tiled_partition<32>` | Clearer group intent and smaller tiles. |
| Divergence | Lanes follow different control paths. | conditional work | Derive membership before divergence where necessary. |

## 4. Real-World Example

In stream compaction, each lane tests whether its item qualifies. `__ballot_sync` forms a bit mask of qualifying lanes. Each qualifying lane counts set bits below its lane using `__popc(mask & __lanemask_lt())` to obtain a local rank. One leader atomically reserves a contiguous output range for the whole warp, broadcasts the base with a shuffle, and each qualifying lane writes to `base + rank`. This replaces many atomic reservations with one per warp.

## 5. Diagrams / Mental Models

```text
8-lane illustration, values: [1 2 3 4 5 6 7 8]

offset 4: [1+5 2+6 3+7 4+8  ...] = [6 8 10 12 ...]
offset 2: [6+10 8+12 ...]          = [16 20 ...]
offset 1: [16+20 ...]              = [36 ...]
lane 0 result = 36
```

```text
predicates:  T F T T F F T F
ballot:      0b01001101
lane 3 rank: popcount(bits below lane 3) = popcount(0b00000101) = 2
```

## 6. Common Interview Questions

1. **What is a warp?** The GPU's SIMT group of threads issued/scheduled together; CUDA warp size is currently 32. Mistake: saying a block always contains one warp.
2. **What is warp-level synchronization?** Coordination and collective exchange among a specified set of lanes in one warp. Expected: mask and scope. Mistake: treating lockstep as a sufficient API guarantee.
3. **What does `__syncwarp(mask)` do?** Named participating lanes wait until all named lanes reach a matching call, with documented memory ordering for their accesses. Mistake: passing lanes that will never arrive.
4. **What is a shuffle instruction?** It lets lanes read register values from other lanes without shared memory. Mistake: assuming any arbitrary thread in the block can be the source.
5. **Why do `_sync` intrinsics take a mask?** The mask defines participating lanes and supports correct collectives under divergence. Mistake: always passing `0xffffffff` in partial/divergent warps.
6. **What does `__ballot_sync` return?** A bit mask whose bits represent participating lanes for which the predicate is true. Mistake: calling it a count; use `__popc` for the count.
7. **How do you perform a warp reduction?** Repeatedly shuffle values from decreasing offsets and combine, ensuring valid membership and source lanes. Mistake: using the result from every lane as if all contain the total.
8. **When is warp synchronization better than block synchronization?** When all dependencies remain inside a warp; it has narrower participation and often avoids shared memory. Mistake: using it for cross-warp exchange.
9. **What changed with independent thread scheduling?** Lanes can make progress more independently, invalidating implicit convergence assumptions. Correct code uses explicit warp primitives and masks. Mistake: claiming warps no longer execute SIMT.
10. **How do you handle a partial final warp?** Compute a participation mask for valid lanes and design the collective so every named lane participates and sources are valid. Mistake: full mask with out-of-range threads that returned.

## 7. Deep-Dive Questions

1. **Why can `__activemask()` inside divergent code be the wrong group?** It reports lanes active at that instant, which may be only one path fragment, not all logical participants. Compute the logical membership with a ballot before divergence when cross-path cooperation is required.
2. **What values do shuffle reads return from inactive source lanes?** The result is not something portable code should rely on. Guard the combine or structure masks/width so every read source is a valid participating lane.
3. **How would you reduce a non-power-of-two number of active lanes?** A simple offset tree needs guards or identity values and a correctly defined group. Cooperative groups or compacting active values can make the membership explicit.
4. **How does warp-aggregated atomic allocation work under divergence?** Ballot the qualifying lanes, elect the first set lane, leader reserves `popcount(mask)` slots, broadcast base, and assign each lane `base + popcount(lower qualifying bits)`.
5. **Does a shuffle synchronize memory?** A shuffle exchanges register values under the collective's participation semantics; it does not serve as a general shared/global-memory publication mechanism. Use `__syncwarp`/appropriate ordering where memory communication requires it.

## 8. Comparison Tables

| Primitive | Input | Output | Main use |
|---|---|---|---|
| `__shfl_sync` | value, source lane | selected lane's value | broadcast/gather |
| `__shfl_down_sync` | value, offset | higher lane's value | reductions |
| `__shfl_up_sync` | value, offset | lower lane's value | scans |
| `__shfl_xor_sync` | value, lane mask | XOR-partner value | butterfly/all-reduce |
| `__ballot_sync` | predicate | lane bit mask | compaction/grouping |
| `__all_sync` | predicate | all true? | unanimous decision |
| `__any_sync` | predicate | any true? | early detection |
| `__syncwarp` | participant mask | no value | rendezvous/memory ordering |

| Warp collective | Shared-memory block algorithm |
|---|---|
| Warp-local only | Can combine multiple warps |
| Register exchange | Explicit shared storage |
| No block-wide barrier | Usually needs `__syncthreads()` |
| Very low overhead | More general participation |
| Mask-sensitive | Block convergence-sensitive |

## 9. Common Mistakes

- Passing a full mask when not all lanes reach the primitive.
- Computing the membership mask after threads have already diverged.
- Assuming lane 0 is active; elect a leader from the actual mask.
- Reading a shuffle source that is not participating.
- Expecting warp synchronization to order another warp.
- Hard-coding 32 in algorithm logic where `warpSize` or an explicit tile is clearer.
- Relying on pre-Volta implicit warp-synchronous behavior.

## 10. Edge Cases / Special Cases

- The last warp of a block can be partial when block size is not a multiple of `warpSize`.
- A mask value of zero means there is no participant; avoid operations such as finding the first set bit without checking.
- The `width` argument to shuffles partitions a warp into power-of-two subgroups but does not repair an incorrect participation mask.
- A warp reduction may leave the full result only in a leader lane unless an all-reduce pattern broadcasts it.
- Diverged lanes may reconverge differently across architectures; correctness must come from documented primitives, not observed scheduling.

## 11. How to Explain in Interview

“Warp-level synchronization coordinates selected lanes within one SIMT warp using an explicit participation mask. Shuffles exchange register values, ballots build lane masks, and `__syncwarp` provides a warp rendezvous for memory communication. It is cheaper than block synchronization when dependencies are warp-local, but every named lane must participate and partial/divergent warps need correct masks.”

## 12. Quick Revision Notes

- CUDA warp size is currently 32; use `warpSize`/groups.
- Mask = contract naming participants.
- Shuffle moves register values; ballot returns bits; `__popc` counts bits.
- Warp sync cannot coordinate different warps.
- Leader may be `__ffs(mask) - 1`, not always lane 0.
- Interview trap: active mask at one point may not equal the intended logical group.

## 13. Practice Tasks

1. Implement warp sum for full and partial warps; validate against a CPU sum.
2. Use ballot and popcount to compact positive values within each warp.
3. Implement warp-aggregated atomic allocation and verify unique contiguous indices.
4. Write an inclusive scan with `__shfl_up_sync` and test subgroup boundaries.
5. Create a divergent branch with a collective; identify the invalid mask and repair the membership protocol.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Masked coordination among lanes of one warp |
| Why it matters | Fast register exchange and narrow synchronization |
| Most asked | Shuffle reduction, ballot, masks, divergence |
| Common comparison | Warp collective vs shared-memory block algorithm |
| One-line answer | Warp primitives are fast because they stay inside one warp, but the mask is a correctness contract. |
