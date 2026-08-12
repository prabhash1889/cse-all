# Distributed GPU Programming: Placement and Interview Guide

Distributed GPU programming coordinates multiple GPUs—inside one server or across many servers—to solve a problem faster or to fit a problem that is too large for one GPU. The central difficulty is usually not launching kernels; it is moving the right bytes to the right GPU, in the right order, without making communication dominate computation.

This guide covers the hardware paths (`PCIe`, `NVLink`, `NVSwitch`), network data movement (`RDMA`), the GPU communication library (`NCCL`), four core collectives (`AllReduce`, `AllGather`, `ReduceScatter`, `Broadcast`), and the broader design space of GPU-to-GPU communication.

```text
Application: data parallelism, tensor parallelism, pipeline parallelism
                     |
Collectives: AllReduce, AllGather, ReduceScatter, Broadcast
                     |
Library/runtime: NCCL, CUDA-aware MPI, NVSHMEM
                     |
Transport: CUDA P2P, GPUDirect RDMA, shared memory, sockets
                     |
Hardware: GPU memory <-> NVLink/NVSwitch/PCIe <-> NIC <-> network
```

Terms used throughout:

| Term | Meaning |
|---|---|
| Rank | One participant in a communicator, commonly one process controlling one GPU. |
| Node | One physical server. |
| Intra-node | Communication among GPUs in the same server. |
| Inter-node | Communication across servers. |
| Topology | The actual arrangement and quality of paths among GPUs, CPUs, switches, and NICs. |
| Collective | An operation that all ranks in a group enter, such as AllReduce. |
| Latency | Fixed time before useful transfer progress; most visible for small messages. |
| Bandwidth | Sustained byte rate; most important for large messages. |
| Reduction | Element-wise combination such as sum, minimum, maximum, or product. |

## Suggested Reading Order

1. [PCIe](#pcie)
2. [NVLink](#nvlink)
3. [NVSwitch](#nvswitch)
4. [RDMA](#rdma)
5. [NCCL](#nccl)
6. [AllReduce](#allreduce)
7. [AllGather](#allgather)
8. [ReduceScatter](#reducescatter)
9. [Broadcast](#broadcast)
10. [GPU-to-GPU Communication](#gpu-to-gpu-communication)

---

# NVLink

## 1. Overview

**NVLink** is NVIDIA's high-speed interconnect for communication among supported GPUs and processors. Depending on the platform, GPUs connect directly with one or more NVLink links or reach one another through NVSwitch. CUDA, NCCL, and other libraries can use the resulting peer paths; programmers normally do not manually send “NVLink packets.”

NVLink matters because modern training and HPC workloads repeatedly exchange gradients, activations, tensor shards, and halo regions. If communication is slower than computation, adding GPUs gives poor scaling. Real systems use NVLink for multi-GPU model training, tightly coupled simulations, shared-memory-style peer access, and high-throughput collectives. Interviewers ask it to see whether candidates distinguish a physical interconnect from a communication API and understand topology, P2P access, bandwidth, latency, and workload placement.

## 2. Core Idea

Imagine several GPU factories. PCIe is the city's general freight system; NVLink is a set of faster private conveyor belts between selected factories. A direct belt helps only the connected pair. If the platform uses NVSwitch, the belts terminate in a switching fabric that can connect many pairs more uniformly.

Small example:

```text
GPU 0 ===== GPU 1      `=====` means several physical NVLink connections
  ||           ||
GPU 2 ===== GPU 3
```

A copy from GPU 0 to GPU 1 proceeds conceptually as follows:

1. CUDA checks that the pair supports peer access.
2. The application enables peer access when the selected API/path requires it.
3. A peer copy or remote memory access is issued in a stream.
4. Hardware routes the request over the available peer path, potentially NVLink.
5. CUDA stream/event dependencies determine when consumers may use the data.

The key mental model is **topology-aware locality**: “the server has NVLink” does not imply every pair has the same direct links, bandwidth, hops, or contention.

## 3. Important Subtopics

| Subtopic | Meaning and importance | Example | Common interview angle |
|---|---|---|---|
| Link aggregation | Multiple physical links may connect a pair or connect a GPU to a fabric. | A topology tool reports multiple links between two GPUs. | Pair bandwidth depends on the platform, not the word NVLink alone. |
| Direct vs switched topology | Direct links connect selected endpoints; NVSwitch provides switched connectivity. | Four GPUs in a mesh versus GPUs attached to switches. | NVLink is a link/protocol; NVSwitch is a switch. |
| CUDA P2P | Supported GPUs can copy to or access peer memory. | `cudaMemcpyPeerAsync`; peer pointer loads. | NVLink enables a path, CUDA exposes programming mechanisms. |
| Remote load/store | A GPU kernel may access peer memory when supported. | GPU 0 reads a small flag or remote array on GPU 1. | Fine-grained remote access is not as cheap as local HBM. |
| Cache/coherence semantics | Visibility and ordering require supported synchronization; do not assume CPU-style global cache coherence. | Producer writes peer data, signals completion, consumer waits. | Connectivity is not a data-race solution. |
| Topology discovery | Software must learn pairwise links and route quality. | `nvidia-smi topo -m`, CUDA P2P queries. | GPU IDs are logical identifiers, not distances. |
| Collective algorithms | Rings, trees, and hierarchical algorithms map traffic onto available links. | NCCL selects channels based on discovered topology. | Fast hardware still needs a good schedule. |
| Contention | Concurrent transfers share GPU ports, switch ports, and memory bandwidth. | Two collectives use overlapping paths. | Sum of link peak rates may not be simultaneously usable. |
| NVLink-C2C | Some platforms use coherent chip-to-chip NVLink between CPU and GPU. | Grace Hopper CPU-GPU systems. | Do not treat every NVLink generation/platform as identical. |

## 4. Real-World Example

In tensor parallel inference, four GPUs each own part of a transformer's weight matrix. Each layer may need an AllReduce or AllGather of intermediate activations. Those operations occur far more frequently than a one-time model load, so the GPU interconnect directly affects token latency and throughput. A topology-aware process placement keeps the heavily communicating tensor-parallel group inside the strongest NVLink domain; slower inter-node links are used for less frequent pipeline transfers or data-parallel synchronization.

## 5. Diagrams / Mental Models

```text
Direct topology:                 Switched topology:

GPU0 ===== GPU1                 GPU0 ===\
 ||         ||                  GPU1 ==== NVSwitch fabric ==== GPU3
GPU2 ===== GPU3                 GPU2 ===/                 \=== GPU4

Some pairs may need multiple    Every route is selected through the fabric;
hops or have different widths.  exact bandwidth still depends on the system.
```

```text
local HBM access < peer access over NVLink < remote/network access
       usually             usually                 usually
   lowest latency      topology-dependent       highest latency
```

This is an ordering intuition, not a universal numerical guarantee.

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What is NVLink?** An NVIDIA high-speed interconnect used by supported processors/GPUs for peer communication. | Hardware link, not a collective. | Calling NVLink a CUDA library. |
| 2 | **How is NVLink different from PCIe?** NVLink is specialized high-speed processor/GPU connectivity; PCIe is general-purpose system I/O and more universally available. | Purpose, availability, topology. | Claiming NVLink replaces PCIe entirely. |
| 3 | **Does NVLink make GPU memory one physical pool?** No. Each GPU normally retains local memory; software may access or transfer remote allocations through supported mechanisms. | Distributed memory, remote access. | Saying all HBM becomes automatically local. |
| 4 | **What is NVLink P2P?** CUDA-enabled direct peer memory copies/accesses over an NVLink path between supported GPUs. | Pairwise capability, peer APIs. | Assuming the route merely from GPU model names. |
| 5 | **NVLink vs NVSwitch?** NVLink is the endpoint connection technology; NVSwitch switches many NVLink ports into a fabric. | Link versus switch. | Using the names interchangeably. |
| 6 | **Will every GPU pair have equal bandwidth?** Not in direct or asymmetric topologies; link count, hops, routes, and contention differ. | Inspect topology. | Assuming full connectivity from one reported link. |
| 7 | **Can kernels directly read peer memory?** Yes on supported and enabled P2P pairs, but remote access latency/bandwidth and synchronization must be considered. | Access plus cost and correctness. | Treating it like local HBM. |
| 8 | **How does NCCL use NVLink?** It discovers topology and selects transports/algorithms/channels that can exploit available links. | Library maps collectives to hardware. | Saying the application explicitly routes each packet. |
| 9 | **Why might scaling still be poor with NVLink?** Communication volume, synchronization, small messages, bad placement, contention, imbalance, or compute too small to hide communication. | Amdahl-style end-to-end reasoning. | Blaming link peak bandwidth alone. |
| 10 | **How do you verify NVLink use?** Inspect topology/link state, run P2P or collective benchmarks, and profile actual traffic. | Configuration plus measurement. | Relying only on product specifications. |

## 7. Deep-Dive Questions

1. **When is a remote peer load better than copying first?**  For small, sparse, or one-pass data where copy setup and duplication cost more than remote access. Repeated dense access usually benefits from staging into local HBM.
2. **Why does topology-aware rank placement matter?**  Collective schedules and application communication pairs should use the strongest local paths; a poor mapping can place high-volume pairs across weaker hops.
3. **Can NVLink traffic contend with kernels?**  Yes. Peer traffic consumes interconnect ports and source/destination memory-system bandwidth; a memory-bound kernel may compete even if SM execution is independent.
4. **Does unified virtual addressing guarantee NVLink?**  No. UVA identifies memory in one virtual address space. P2P capability and the physical route remain separate questions.
5. **How would you optimize a communication-heavy layer?**  Reduce communicated bytes, fuse or batch small messages, place ranks by topology, choose an appropriate collective/sharding strategy, and overlap only when dependencies allow.

## 8. Comparison Tables

| NVLink | NVSwitch |
|---|---|
| Endpoint interconnect/link technology | Switching chip/fabric for NVLink ports |
| Can directly join selected processor/GPU endpoints | Connects many endpoints through switched routes |
| Direct topology can be irregular | Often provides more uniform all-to-all reachability in a domain |
| Link count between pairs affects direct bandwidth | Fabric paths and ports determine switched bandwidth |

| Local HBM | Peer memory over NVLink |
|---|---|
| Owned by executing GPU | Physically attached to another GPU |
| Lowest-latency/highest-bandwidth target for that GPU | Higher access cost and topology dependent |
| No inter-GPU transfer needed | Consumes interconnect capacity |
| Best for repeatedly reused working data | Useful for sharing, copies, sparse/one-pass access, and collectives |

## 9. Common Mistakes

- Saying NVLink combines all GPU memory into one automatically uniform memory pool.
- Confusing the link with NCCL, an API/library that can use it.
- Assuming all GPU pairs in a server are directly linked.
- Ignoring memory-controller contention at the source and destination GPUs.
- Treating remote memory accesses as equal to local HBM accesses.
- Assuming a peer pointer removes the need for ordering and synchronization.
- Quoting bandwidth from a different NVLink generation or system topology.

## 10. Edge Cases / Special Cases

- The same GPU model can appear in systems with different link wiring.
- A disabled/down link can cause rerouting or degraded performance rather than a clean application error.
- MIG, virtualization, OS, and product support can restrict P2P visibility.
- Direct-link topologies may have multi-hop paths; collectives can use intermediate GPUs without exposing that detail to application code.
- Bidirectional aggregate marketing numbers are not the same as one-direction payload bandwidth.
- Remote atomics, memory ordering, and coherence support are architecture/API specific.

## 11. How to Explain in Interview

> NVLink is NVIDIA's high-bandwidth interconnect for supported GPUs and processors. It accelerates peer copies, remote memory access, and collectives, but it does not turn separate GPU memories into free local memory. I inspect the pairwise topology, distinguish direct NVLink from NVSwitch fabrics, and optimize the communication pattern and rank placement—not just the kernel.

## 12. Quick Revision Notes

- NVLink = physical high-speed NVIDIA interconnect.
- NVSwitch = switch/fabric built around NVLink ports.
- CUDA P2P = programming mechanism that may use NVLink.
- NCCL = topology-aware collective library that may use NVLink.
- More links/hops/topology can change pair performance.
- Remote memory remains remote; synchronize correctly.
- Interview trap: “NVLink means unified GPU memory.” False.

## 13. Practice Tasks

1. Draw a four-GPU direct topology and identify which pairs need two hops.
2. Use `nvidia-smi topo -m` and predict the best tensor-parallel grouping.
3. Measure local HBM copy, NVLink P2P copy, and peer-load bandwidth separately.
4. Write a CUDA P2P capability matrix using `cudaDeviceCanAccessPeer`.
5. Profile an AllReduce and relate its traffic to the reported topology.
6. Explain when copying a remote array locally beats repeatedly reading it remotely.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | NVIDIA high-speed processor/GPU interconnect. |
| Why it matters | Reduces the communication penalty in tightly coupled multi-GPU workloads. |
| Most asked | NVLink vs PCIe, NVLink vs NVSwitch, P2P, remote vs local memory. |
| Main trap | Connectivity does not make remote HBM local or automatically coherent. |
| One-line answer | “NVLink is the fast physical path; CUDA and NCCL expose and schedule communication over it.” |

---

# NVSwitch

## 1. Overview

**NVSwitch** is NVIDIA switching hardware that connects multiple NVLink endpoints into a high-bandwidth fabric. It plays a role similar to a network switch inside an NVLink domain: GPUs attach through NVLink ports, and the switch forwards traffic to the appropriate destination.

It matters because direct point-to-point wiring becomes difficult as GPU count grows, and irregular meshes give different pairs different path quality. NVSwitch-based systems provide broad GPU reachability and make communication-intensive collectives easier to schedule efficiently. They are used in multi-GPU servers and larger NVLink domains for LLM training/inference and HPC. Interviewers use the topic to test link-versus-switch vocabulary, switched topology, bisection bandwidth, contention, fault/configuration awareness, and why topology-aware libraries still matter.

## 2. Core Idea

An office with eight people could install a private wire between every pair, but the number of wires grows rapidly. A central phone switch lets each person attach to the fabric and lets the fabric create the required routes. NVSwitch applies that idea to NVLink-connected processors.

```text
GPU 0 ===\             /=== GPU 4
GPU 1 ====\           /==== GPU 5
GPU 2 ===== NVSwitch fabric ===== GPU 6
GPU 3 ====/           \==== GPU 7
```

Step by step for GPU 1 -> GPU 6 communication:

1. GPU 1 issues peer traffic through one or more NVLink ports.
2. An NVSwitch receives and forwards packets across its internal switching logic.
3. Traffic leaves through links toward GPU 6.
4. GPU 6's memory subsystem services the transfer/access.
5. System software monitors/configures the fabric; CUDA/NCCL expose usable communication paths.

“Switched” does not mean infinite capacity. Each GPU has finite injection bandwidth; fabric links and destination memory bandwidth can still contend.

## 3. Important Subtopics

| Subtopic | Meaning and importance | Example | Common interview angle |
|---|---|---|---|
| Crossbar/switching fabric | Routes an input port to a destination output. | Simultaneous independent GPU pairs communicate. | Nonblocking internal design does not remove endpoint limits. |
| Scale-up domain | A tightly connected set of accelerators behaves as one high-bandwidth communication domain. | Tensor-parallel ranks kept within one domain. | Contrast scale-up NVLink fabric with scale-out network. |
| Bisection bandwidth | Aggregate traffic that can cross a division of the topology. | Four GPUs exchange with the other four. | Better metric than one pair's link rate for collectives. |
| Multi-switch systems | Platforms use several switch chips and links to create the full fabric. | A GPU spreads its links across switches. | “One NVSwitch” is not always the whole system topology. |
| Routing and contention | Packets take fabric paths and can share ports/resources. | Many-to-one traffic targets one GPU. | All-to-all reachability does not mean no hotspots. |
| Fabric Manager/platform service | Some systems need software to initialize and manage NVSwitch partitions/fabric. | Link is present but fabric is not configured. | Hardware health and workload correctness are different layers. |
| Partitioning/isolation | A fabric may be divided into permitted communication domains. | Multi-tenant or managed systems. | Reachability depends on configuration, not just cables. |
| Monitoring/errors | Link-down, switch-port errors, and degraded paths affect jobs. | DCGM reports a down switch link. | Healthy GPUs do not prove a healthy fabric. |
| Collective offload features | Some platforms can accelerate reduction behavior within/near the fabric. | In-network reduction features used by optimized libraries. | Do not claim every NVSwitch generation provides identical operations. |

## 4. Real-World Example

An eight-GPU server runs tensor parallel training. Each transformer layer produces partial outputs that need an AllReduce. In a direct mesh, some pairs might communicate through intermediate GPUs or weaker paths. In an NVSwitch fabric, NCCL can construct rings/trees over broad high-bandwidth connectivity. The application still sees ranks and a collective call; the library and system software handle routes. Scaling improves only if the tensor computation is large enough relative to the repeated communication.

## 5. Diagrams / Mental Models

```text
Direct links:                         NVSwitch domain:

GPU0 ----- GPU1                      GPU0 --\
 |          |                        GPU1 ---\
GPU2 ----- GPU3                      GPU2 ---- Fabric ---- GPU4..GPU7

Pair quality may differ.             Broad reachability; endpoint and
                                     fabric capacities still finite.
```

| Layer | Responsibility |
|---|---|
| Application/framework | Chooses parallelism and calls collectives. |
| NCCL/runtime | Discovers topology and schedules traffic. |
| CUDA/driver/fabric software | Enables memory access, routes, partitions, and device control. |
| NVLink/NVSwitch hardware | Physically transports and switches traffic. |

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What is NVSwitch?** A switch for NVLink traffic that connects many supported GPU/processor endpoints into a fabric. | Switch, ports, fabric. | Calling it another name for NVLink. |
| 2 | **Why not directly connect every GPU pair?** Full pairwise wiring scales poorly in ports and physical complexity; switching provides scalable reachability. | Connectivity scaling. | Saying direct links are impossible in all systems. |
| 3 | **Does NVSwitch merge GPU memory?** No. It provides high-speed access paths among separate memories. | Physical ownership remains. | Claiming one automatic shared HBM heap. |
| 4 | **NVSwitch vs PCIe switch?** Both forward traffic, but they serve different link protocols/ecosystems and performance roles. | Protocol and purpose. | Assuming interchangeable hardware. |
| 5 | **What is bisection bandwidth?** Aggregate bandwidth available across a cut dividing the fabric; it matters for many simultaneous transfers. | System-level capacity. | Reporting only one port's bandwidth. |
| 6 | **Can NVSwitch eliminate communication bottlenecks?** No; message volume, synchronization, GPU injection, switch paths, and destination memory remain finite. | End-to-end limits. | “The fabric is nonblocking, so nothing contends.” |
| 7 | **How does NCCL benefit?** More uniform high-bandwidth reachability gives NCCL better paths for rings, trees, and hierarchical collectives. | Algorithm/topology mapping. | Saying NVSwitch itself is NCCL. |
| 8 | **What happens if a link is down?** The fabric may report an error, reroute/degrade if supported, or make jobs fail; behavior depends on platform/software. | Monitor and diagnose. | Assuming silent full-speed operation. |
| 9 | **What is scale-up vs scale-out?** Scale-up tightly couples accelerators within an NVLink domain; scale-out connects nodes through a network such as InfiniBand/Ethernet. | Two communication tiers. | Equating NVSwitch with a data-center Ethernet switch. |
| 10 | **Why does placement still matter?** Domains, partitions, multi-node boundaries, NIC affinity, and workload communication groups remain relevant. | Hierarchy beyond one switch. | Assuming all cluster GPUs form one uniform domain. |

## 7. Deep-Dive Questions

1. **How can a switch be internally nonblocking yet an application still sees contention?**  GPU injection ports, destination ports, memory bandwidth, and external links are finite; many flows can target the same resources.
2. **Why is AllReduce a useful NVSwitch workload?**  Every rank both contributes and receives data, creating sustained many-GPU traffic that benefits from strong aggregate and bisection bandwidth.
3. **How do scale-up and scale-out collectives combine?**  A hierarchical algorithm may reduce within each NVSwitch domain, exchange reduced chunks across NICs, then distribute results locally.
4. **What operational software is relevant?**  Drivers and platform fabric services configure access/partitions; monitoring tools inspect links and switch health; NCCL consumes the usable topology.
5. **What would you measure before blaming NVSwitch?**  Per-link state/errors, collective bus bandwidth, message sizes, rank mapping, endpoint memory bandwidth, synchronization gaps, and whether traffic unexpectedly crosses a slower boundary.

## 8. Comparison Tables

| Direct NVLink topology | NVSwitch topology |
|---|---|
| Selected GPU pairs are wired directly | GPUs attach to a switched NVLink fabric |
| Pair bandwidth/hops may vary sharply | Connectivity is generally broader/more uniform within the domain |
| Simpler at small scale | Scales connectivity to more endpoints |
| Algorithms must account for sparse graph | Algorithms can exploit high bisection reachability |

| Scale-up fabric | Scale-out network |
|---|---|
| Tightly couples GPUs/processors in a domain | Connects independent servers/nodes |
| Typically lower latency/higher accelerator-local bandwidth | Usually higher latency and additional network stack/NIC hops |
| NVLink/NVSwitch is a common example | InfiniBand or Ethernet/RoCE is common |
| Used for fine-grained or frequent model-parallel traffic | Used for cluster-wide training and storage/service traffic |

## 9. Common Mistakes

- Using NVLink and NVSwitch as synonyms.
- Assuming switched reachability equals zero-hop local memory.
- Ignoring endpoint injection and destination memory bandwidth.
- Treating the entire cluster as one NVSwitch domain.
- Quoting a single switch-chip specification as end-to-end application bandwidth.
- Forgetting that fabric configuration, partitions, and link health affect reachability.
- Assuming NCCL's algorithm choice is irrelevant on a strong fabric.

## 10. Edge Cases / Special Cases

- A system may contain multiple NVSwitch chips that collectively form one logical fabric.
- Switch ports can be up while a workload is misconfigured; link health and collective correctness are separate.
- Fabric partitions may intentionally prevent certain endpoints from communicating.
- Failure behavior varies: a route may degrade, a communicator may fail, or system management may isolate a component.
- Newer platforms may extend NVLink/NVSwitch beyond a single traditional server; always define the domain being discussed.
- Many-to-one Broadcast/Reduce patterns can stress different resources from balanced ring traffic.

## 11. How to Explain in Interview

> NVSwitch is switching hardware for NVLink. Instead of relying only on direct GPU-pair wires, GPUs attach to a fabric that forwards traffic and provides broad high-bandwidth reachability. It improves multi-GPU collectives and model parallelism, but it does not merge memories or remove endpoint, routing, synchronization, and topology limits.

## 12. Quick Revision Notes

- NVLink = link; NVSwitch = switch/fabric.
- Separate GPU memories remain separate.
- Key metric for group traffic: aggregate/bisection bandwidth, not one link peak.
- Scale-up fabric differs from scale-out InfiniBand/Ethernet network.
- NCCL schedules collectives over the discovered fabric.
- Fabric health/configuration can affect a job independently of GPU health.

## 13. Practice Tasks

1. Draw a direct eight-GPU mesh and an eight-GPU switched topology; compare link growth.
2. Explain a hierarchical AllReduce across two NVSwitch nodes.
3. Given a many-to-one traffic pattern, identify likely destination bottlenecks.
4. Inspect switch/link status with available NVIDIA management tools on suitable hardware.
5. Benchmark AllReduce across GPUs inside one fabric domain and then across nodes.
6. Explain why bisection bandwidth predicts some collectives better than a single-pair copy test.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Switching hardware that forwards NVLink traffic among many endpoints. |
| Why it matters | Scalable, broad, high-bandwidth GPU communication inside a fabric domain. |
| Most asked | NVLink vs NVSwitch, switched vs direct topology, bisection bandwidth, scale-up vs scale-out. |
| Main trap | A switched fabric neither merges HBM nor creates infinite bandwidth. |
| One-line answer | “NVSwitch turns NVLink endpoint connections into a scalable GPU fabric that libraries such as NCCL can exploit.” |

---

# PCIe

## 1. Overview

**PCI Express (PCIe)** is the standard high-speed I/O interconnect that connects discrete GPUs, NICs, NVMe drives, and other devices to a CPU-based system. It is a packet-switched, point-to-point hierarchy rather than one shared parallel bus.

For GPU programming, PCIe commonly carries CPU-to-GPU copies, GPU-to-CPU copies, control traffic, and—where topology and platform support permit—GPU peer-to-peer or GPU-to-NIC traffic. It matters because a GPU can process data much faster than a poor I/O path can deliver it. A fast kernel does not help if every iteration waits on avoidable host transfers.

Real systems use PCIe in workstations, inference servers, multi-GPU training nodes, storage pipelines, and HPC clusters. Interviewers ask about it to test whether candidates reason about the full system rather than kernel FLOPS alone: link width, topology, DMA, pinned memory, transfer granularity, peer access, NUMA locality, and overlap.

## 2. Core Idea

Think of PCIe as a road network. A device has an endpoint, links are roads, switches are junctions, and the CPU socket's root complex is a gateway. A nominally wide road near each GPU does not guarantee a wide end-to-end route: two GPUs may share an upstream switch or may need to cross a CPU inter-socket link.

PCIe links use one or more serial **lanes**. Link width is written `x1`, `x4`, `x8`, or `x16`. The link trains to a speed and width supported by both endpoints and every component on the path. Traffic is packetized; protocol overhead means application payload bandwidth is lower than the raw signaling rate.

Small example: GPU 0 and GPU 1 are both attached to one PCIe switch.

```text
CPU root complex
       |
   PCIe x16 uplink       <- shared by traffic leaving the switch
       |
   PCIe switch
    /       \
 x16         x16
 GPU 0       GPU 1
```

Step by step for a pinned host-to-device copy:

1. The application allocates page-locked host memory and device memory.
2. `cudaMemcpyAsync` enqueues the copy in a CUDA stream.
3. A GPU copy engine/DMA engine reads host physical memory through PCIe.
4. PCIe packets traverse the root complex and any switches.
5. The GPU writes payload into device memory.
6. A CUDA event or stream synchronization establishes when the buffer is safe to consume or reuse.

The optimization rule is simple: transfer less, transfer in larger chunks, place devices well, use pinned buffers where appropriate, and overlap independent communication with computation.

## 3. Important Subtopics

| Subtopic | What it means and why it matters | Example | Common interview angle |
|---|---|---|---|
| Lanes and link width | Multiple serial lanes form one link. Wider links can carry more traffic. | A GPU may be physically in an x16 slot but electrically connected as x8. | Physical slot size is not proof of negotiated width. |
| Generations and encoding | New generations raise transfer rate; encoding and packet overhead reduce usable payload. | Two Gen4 x16 endpoints cannot run Gen5 merely because the motherboard supports it elsewhere. | Avoid quoting raw rate as measured application bandwidth. |
| Root complex | CPU-side PCIe host bridge that anchors a hierarchy. | A GPU and NIC under the same root complex often have a better GPUDirect RDMA path. | Topology constraints matter more than device count. |
| PCIe switch | Expands connectivity and forwards packets. Downstream ports may share an uplink. | Four GPUs behind one switch can contend when all talk to host memory. | A switch is not automatically a bottleneck; inspect oversubscription. |
| DMA and copy engines | Devices transfer bytes without CPU copying each element. | An H2D copy can run on a copy engine while a kernel uses SMs. | DMA reduces CPU work; it does not make synchronization unnecessary. |
| Pinned host memory | Page-locked memory provides stable physical pages for direct DMA. | `cudaMallocHost` plus `cudaMemcpyAsync`. | Pageable memory may require staging; pinning too much harms the OS. |
| Peer-to-peer (P2P) | One GPU can transfer to or access another GPU's memory when supported. | `cudaMemcpyPeerAsync`, remote loads after peer access is enabled. | P2P support is pairwise and topology/platform dependent. |
| NUMA locality | CPU memory and PCIe roots belong to CPU/NUMA domains. | A host thread allocates pinned memory near the GPU's CPU socket. | Remote NUMA traffic can cross an inter-socket link before PCIe. |
| ACS/IOMMU/platform routing | Firmware or virtualization settings can redirect or restrict peer traffic. | P2P that unexpectedly routes through a root complex. | Software support and platform configuration can change the real path. |
| Transaction overhead | Headers, flow control, acknowledgements, and fixed launch costs reduce efficiency. | Thousands of 1 KB transfers perform worse than one batched transfer. | Optimize message size as well as nominal link bandwidth. |

## 4. Real-World Example

An inference server receives image batches in CPU memory and sends them to two GPUs. A slow design allocates pageable buffers and performs `copy -> wait -> kernel -> wait` for every batch. A better design uses two or more pinned staging buffers and CUDA streams:

```text
Time --->
Stream 0: H2D batch 0 | infer batch 0 | D2H result 0
Stream 1:             H2D batch 1 | infer batch 1 | D2H result 1
Copy engine: [H2D 0] [H2D 1]                 [D2H 0]
SMs:                 [compute 0] [compute 1]
```

The pipeline does not increase PCIe bandwidth. It hides part of its cost behind independent computation. Correctness still requires that the CPU not overwrite a staging buffer until its copy completes.

## 5. Diagrams / Mental Models

```text
Good locality:
CPU socket 0 ---- PCIe root ---- switch ---- GPU 0
                                  `-------- NIC 0
GPU 0 <-> NIC 0 can use a short peer path when supported.

Poorer locality:
GPU 0 ---- root 0 ---- CPU socket 0 ==== CPU socket 1 ---- root 1 ---- NIC 1
                                  inter-socket fabric
```

Performance model for a message of `n` bytes:

```text
transfer_time ~= fixed_latency + n / effective_bandwidth
```

For tiny messages, latency dominates. For large messages, bandwidth and path contention dominate.

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What is PCIe?** A point-to-point, packet-based I/O interconnect connecting endpoints through root complexes and optional switches. | Hierarchy, lanes, packets, devices. | Calling it a shared memory bus. |
| 2 | **What does x16 mean?** The link can use up to 16 lanes; actual width is the negotiated end-to-end width. | Lane count, negotiation. | Assuming every x16-shaped slot runs x16. |
| 3 | **Why is PCIe relevant to GPU performance?** Host/device and some peer transfers traverse it, often at much lower bandwidth than GPU-local HBM. | End-to-end bottleneck, minimize movement. | Comparing only kernel throughput. |
| 4 | **Why does pinned memory help?** It gives DMA stable resident host pages and enables reliable asynchronous transfer behavior. | DMA, async copies, resource cost. | Saying pinned memory resides on the GPU. |
| 5 | **Does `cudaMemcpyAsync` always overlap a kernel?** No. It needs compatible memory, independent work, suitable streams, hardware engines, and no blocking dependency. | Conditions for overlap. | Treating “Async” as guaranteed concurrency. |
| 6 | **What is PCIe P2P?** A supported GPU pair communicates directly through the PCIe fabric without staging payload through ordinary host memory. | Pairwise support, topology, CUDA peer APIs. | Assuming all GPUs in one server support it. |
| 7 | **What is a PCIe root complex?** The CPU/SoC component connecting processors and memory to a PCIe hierarchy. | Topology anchor. | Confusing it with a PCIe switch. |
| 8 | **Why can two x16 GPUs still contend?** Their downstream links may share an oversubscribed switch uplink, root, memory controller, or inter-socket path. | Shared path/bisection bandwidth. | Looking only at endpoint link widths. |
| 9 | **How do you reduce PCIe overhead?** Keep data resident on the GPU, batch transfers, use pinned memory appropriately, overlap independent work, and avoid unnecessary round trips. | Movement avoidance before micro-optimization. | Pinning all host memory. |
| 10 | **How do you inspect GPU topology?** Use tools such as `nvidia-smi topo -m`, device queries, and measured P2P bandwidth/latency tests. | Inspect and benchmark. | Inferring topology from GPU numbering. |

## 7. Deep-Dive Questions

1. **Why can a small copy achieve poor bandwidth?**  Fixed software submission, DMA setup, and packet overhead dominate. Increasing message size amortizes those costs until the link or memory system becomes the limiter.
2. **What is the difference between bandwidth and bisection bandwidth?**  Per-link bandwidth describes one link; bisection bandwidth describes aggregate traffic that can cross a topology cut. Many individually fast links can feed one narrow uplink.
3. **Can a GPU kernel dereference another GPU's pointer over PCIe?**  On a supported pair after peer access is enabled, yes. Remote fine-grained accesses are typically much more latency-sensitive than bulk copies, so access pattern matters.
4. **Why can ACS hurt P2P?**  Access Control Services may redirect peer packets upstream rather than allowing the shortest switch-local path, reducing available bandwidth and increasing latency.
5. **How would you diagnose unexpectedly low H2D bandwidth?**  Check negotiated generation/width, use pinned memory, test a large steady-state transfer, inspect NUMA placement and contention, exclude initialization, and compare against a topology-aware benchmark.

## 8. Comparison Tables

| PCIe | NVLink |
|---|---|
| General-purpose industry I/O interconnect | NVIDIA high-bandwidth processor/GPU interconnect |
| Connects CPUs, GPUs, NICs, and storage | Primarily connects supported NVIDIA processors/GPUs and NVSwitch fabrics |
| Usually the universal fallback path | Available only on supported products/topologies |
| Often lower GPU-peer bandwidth and higher latency | Usually better suited to heavy intra-domain GPU traffic |
| Topology rooted in CPU root complexes | May be direct GPU links or switched through NVSwitch |

| Pageable host memory | Pinned host memory |
|---|---|
| Normal allocation; OS can page it | Page-locked; limited system resource |
| Runtime may stage it for DMA | DMA-friendly |
| Simpler and cheaper to allocate | More expensive to allocate; reuse pools |
| Poor choice for sustained async pipelines | Standard choice for explicit overlapped H2D/D2H |

## 9. Common Mistakes

- Treating theoretical signaling bandwidth as guaranteed application payload bandwidth.
- Assuming GPU index order describes physical PCIe proximity.
- Expecting small transfers to saturate a link.
- Using pageable host memory while claiming copy/compute overlap.
- Ignoring the shared uplink of a PCIe switch.
- Confusing UVA, which gives a unified address range, with automatic fast peer access.
- Synchronizing the entire device after every copy and destroying overlap.
- Pinning excessive memory and degrading overall system behavior.

## 10. Edge Cases / Special Cases

- A link may **downtrain** to a lower generation or width because of platform configuration or signal issues.
- Peer capability is directional in API queries; check the exact ordered pair.
- A topology may permit copies but not efficient fine-grained remote access.
- Virtual machines, containers, IOMMU settings, ACS, and device passthrough can alter or disable P2P behavior.
- Simultaneous H2D and D2H overlap depends on available copy engines and shared path capacity.
- Unified Memory may migrate pages over PCIe, turning irregular page faults into a hidden communication bottleneck.
- “Direct” P2P means the payload avoids a CPU staging buffer; switches/root components may still forward packets.

## 11. How to Explain in Interview

> PCIe is the general-purpose point-to-point I/O fabric connecting a discrete GPU to the CPU and often to peer devices. Its real performance depends on generation, negotiated lane width, packet overhead, and topology—not just the x16 label. In GPU code I minimize host round trips, use pinned memory for asynchronous DMA, batch small transfers, overlap independent copies with kernels, and verify the real GPU/NUMA/P2P topology.

## 12. Quick Revision Notes

- **Definition:** Packet-switched, lane-based device interconnect.
- **Core path:** endpoint -> optional switch -> root complex -> CPU/memory.
- **Performance model:** latency plus bytes divided by effective bandwidth.
- **Pinned memory:** enables direct DMA-friendly host transfers; use sparingly.
- **P2P:** support is pairwise and topology/configuration dependent.
- **Comparison:** PCIe is general-purpose; NVLink is specialized for high-speed supported processor/GPU communication.
- **Trap:** x16 mechanical size is not proof of x16 negotiated width.
- **Trap:** async API submission is not proof of physical overlap.

## 13. Practice Tasks

1. Run `nvidia-smi topo -m` on a multi-GPU machine and explain every GPU-pair label.
2. Benchmark pageable versus pinned H2D copies for 4 KB, 1 MB, and 256 MB messages.
3. Build a two-stream double-buffered copy/compute pipeline and draw its timeline.
4. Use `cudaDeviceCanAccessPeer` for every ordered GPU pair and print a matrix.
5. Compare `cudaMemcpyPeerAsync` with a host-staged GPU0 -> CPU -> GPU1 path.
6. Bind a process to different NUMA nodes and measure pinned-memory transfer bandwidth.
7. Explain why batching 1,000 tiny tensors can improve a collective or copy workload.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | General-purpose packetized I/O interconnect made of point-to-point links. |
| Why it matters | Common host/device and fallback peer path; can bottleneck an otherwise fast GPU. |
| Most asked | Pinned memory, x16 meaning, P2P, topology, copy/compute overlap. |
| Compare | PCIe vs NVLink; pageable vs pinned memory. |
| One-line answer | “PCIe connects the GPU to the host and peers; optimize it by moving less data, batching transfers, using correct memory, overlapping safely, and checking topology.” |

---

# RDMA

## 1. Overview

**Remote Direct Memory Access (RDMA)** lets one machine's network adapter transfer data directly to or from registered memory on another machine with little CPU involvement on the data path. The remote CPU does not copy every byte through a socket buffer. RDMA is a communication model supported by technologies such as InfiniBand and RoCE; it is not the name of one particular network cable.

In distributed GPU programming, **GPUDirect RDMA** allows a capable NIC to DMA directly between the network and GPU memory, avoiding an explicit GPU -> host staging buffer -> network or network -> host -> GPU path. It matters because inter-node training exchanges gigabytes of gradients and activations repeatedly. Removing CPU staging reduces copies, CPU overhead, and often latency.

RDMA is used in distributed training, HPC, storage, low-latency services, and database replication. Interviewers ask it to test data-path reasoning, memory registration, queue pairs, one-sided vs two-sided operations, completion semantics, zero-copy terminology, NIC/GPU topology, and the fact that low CPU involvement does not remove correctness or synchronization requirements.

## 2. Core Idea

Ordinary socket transfer resembles sending a parcel through two reception desks: application data is copied into kernel-managed buffers, processed by the networking stack, then copied to the receiving application. RDMA gives the NIC permission and address information for pre-registered buffers, so the NIC can place bytes directly in the intended memory region.

```text
Traditional staged GPU receive:
network -> NIC -> kernel/host buffer -> CPU/runtime copy -> GPU memory

GPUDirect RDMA receive:
network -> NIC ================================> GPU memory
                      direct DMA data path
```

Small example: rank 0 on node A sends a gradient chunk in GPU memory to rank 1 on node B.

1. GPU/NIC memory mappings and communication resources are prepared.
2. The sender posts work describing the registered source and remote destination/protocol operation.
3. The NIC reads the source buffer, packetizes data, and sends it.
4. The remote NIC places data into the registered destination buffer.
5. Completion is reported through a completion mechanism.
6. The consuming GPU stream must wait on the correct communication completion before reading the buffer.

RDMA reduces data-path work. It does not mean “no software”: setup, registration, protection, queue management, congestion control, and completion handling remain essential.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Memory registration | Pins/maps a region and gives the NIC access metadata/keys. | Registering a reusable communication buffer. | Registration is expensive; cache/reuse registrations. |
| Queue pair / work queue | Producer posts send, receive, read, write, or atomic work requests to NIC queues. | Post a send, poll a completion queue. | Asynchronous submission needs completion handling. |
| One-sided operations | Initiator directly reads/writes registered remote memory without a matching data operation by the remote CPU. | RDMA Write into a remote buffer. | Remote application still needs a notification/ordering protocol. |
| Two-sided send/receive | Sender and receiver coordinate posted buffers. | Send requires a matching receive buffer. | Buffer availability matters; “RDMA” is not only one-sided. |
| Protection keys | Access is limited to registered regions and permissions. | Local/remote keys validate NIC access. | Direct access is controlled, not arbitrary remote memory access. |
| Completion | Signals that a work request reached a defined completion state. | Poll CQ before reusing a source buffer. | Local completion may not equal remote application consumption. |
| GPUDirect RDMA | A peer device such as a NIC directly DMA-accesses supported GPU memory. | NCCL transfers GPU gradients over InfiniBand without host staging. | RDMA and GPUDirect RDMA are related but not identical. |
| NIC–GPU affinity | A nearby PCIe/root path can outperform a remote NUMA path. | Rank uses the NIC closest to its GPU. | Topology affects inter-node bandwidth. |
| RoCE vs InfiniBand | Both can carry RDMA semantics; RoCE runs over Ethernet and needs correct fabric configuration. | RoCEv2 cluster with congestion controls. | RDMA is a model, not synonymous with InfiniBand. |
| Ordering/visibility | Network completion and GPU stream memory visibility must be coordinated. | GPU writes buffer, communication waits; receiver signals GPU. | Avoid races between kernel and NIC. |

## 4. Real-World Example

During data-parallel LLM training, each GPU computes gradients locally. NCCL divides the gradient buffer into chunks and exchanges them among nodes. With GPUDirect RDMA, a local NIC reads chunks directly from GPU HBM and the remote NIC writes directly into remote GPU HBM. The CPUs initialize communicators and help manage progress/control, but do not copy the bulk tensor payload byte by byte.

```text
Node A                                              Node B
GPU A HBM <-> PCIe/NVLink path <-> NIC A === fabric === NIC B <-> GPU B HBM
   compute gradient                  RDMA payload                 reduce/consume
```

The best mapping selects a NIC close to each GPU and overlaps communication of an earlier gradient bucket with backpropagation of later layers.

## 5. Diagrams / Mental Models

```text
Control plane: application/library creates resources, registers memory,
               exchanges connection metadata, posts work, handles errors.

Data plane:    memory <------ DMA ------> NIC === network === NIC <------ DMA ------> memory
```

| Event | What it usually proves | What it may not prove |
|---|---|---|
| Work request posted | NIC accepted a descriptor or it entered a queue | Transfer completed |
| Local completion | Local buffer reached the operation's completion semantics | Remote GPU kernel consumed the bytes |
| Remote notification | Protocol says remote data is available | Every unrelated GPU stream is synchronized |

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What is RDMA?** NIC-assisted direct transfer to/from registered remote memory with minimal CPU data-path involvement. | Registered memory, DMA, low CPU overhead. | “No CPU or software is involved at all.” |
| 2 | **What problem does RDMA solve?** It reduces kernel-stack processing, copies, latency, and CPU consumption for high-throughput networking. | Data path. | Saying it only increases raw line rate. |
| 3 | **What is GPUDirect RDMA?** A capable peer device, commonly a NIC, DMA-transfers directly to/from supported GPU memory. | Avoid host staging. | Confusing it with GPU-to-GPU NVLink P2P. |
| 4 | **Why register memory?** The NIC needs pinned/stable mappings, permissions, and translation metadata for DMA. | Pinning, keys, cost. | Registering/frees buffers for every tiny message. |
| 5 | **One-sided vs two-sided?** One-sided read/write names remote memory directly; two-sided send/receive requires matching receive resources. | Communication semantics. | Claiming the remote side does nothing in the whole protocol. |
| 6 | **Does RDMA guarantee application-level completion?** No. Completion has defined transport/local semantics; the application must coordinate remote readiness and consumption. | Completion nuance. | Reusing buffers immediately after posting. |
| 7 | **RDMA vs TCP sockets?** RDMA uses registered buffers and NIC work queues to bypass much of the ordinary kernel copy/processing path; sockets provide a simpler byte-stream API and broad portability. | Tradeoff, API complexity. | Saying TCP can never use zero-copy optimizations. |
| 8 | **InfiniBand vs RoCE?** Both can provide RDMA; InfiniBand is its own fabric stack, while RoCE carries RDMA over Ethernet. | RDMA is not a fabric brand. | Treating RoCE as ordinary lossy Ethernet with no tuning concerns. |
| 9 | **Why does NIC–GPU topology matter?** Traffic may cross extra PCIe switches, CPU roots, or inter-socket links, reducing bandwidth and increasing latency. | Affinity. | Assigning NICs solely by interface name. |
| 10 | **What can break GPUDirect RDMA?** Unsupported hardware/software, wrong drivers/modules, IOMMU/topology constraints, registration failure, containers/VMs, or bad affinity. | End-to-end prerequisites. | Checking only that the NIC supports RDMA. |

## 7. Deep-Dive Questions

1. **Why is memory registration expensive?**  It establishes stable pages/mappings, device permissions, and translation state. Long-lived registered pools amortize setup but consume pinned/mapping resources.
2. **How does a receiver know an RDMA Write finished?**  The protocol needs a completion/notification mechanism, such as a separate message, immediate data, a polled flag with correct ordering, or a library abstraction.
3. **Why can GPUDirect RDMA underperform host staging?**  Poor GPU–NIC topology, small messages, registration misses, contention, PCIe limits, network congestion, or an optimized staged pipeline can change the result.
4. **What is zero-copy really claiming?**  Usually that an extra application/kernel staging copy is avoided. NIC DMA still moves bytes, and protocol/header processing still occurs.
5. **How do collectives use multiple NICs?**  Libraries split channels/chunks, map GPUs to nearby NICs, and schedule traffic across rails while avoiding cross-NIC and shared-uplink bottlenecks.

## 8. Comparison Tables

| Traditional socket path | RDMA path |
|---|---|
| Kernel networking stack is central to data movement | NIC work queues and registered memory drive the fast path |
| Often extra copies/staging | Can avoid intermediate copies |
| Simple, portable programming model | More setup, resource, ordering, and failure complexity |
| CPU cost can be high at extreme throughput | Lower CPU data-path cost |

| GPUDirect P2P | GPUDirect RDMA |
|---|---|
| GPU communicates with another local peer device, commonly another GPU | Network/third-party peer device directly accesses GPU memory |
| Often intra-node over PCIe/NVLink | Commonly inter-node through NIC and network |
| CUDA peer APIs are central | RDMA stack/library/NIC integration is central |
| Avoids host staging between local peers | Avoids host staging for network payloads |

## 9. Common Mistakes

- Expanding RDMA as “remote direct *memory allocation*” instead of access.
- Saying RDMA bypasses every kernel, CPU, and software activity.
- Treating local completion as proof that the remote application consumed data.
- Forgetting registration lifetime and buffer reuse rules.
- Calling any pinned-memory transfer GPUDirect RDMA.
- Ignoring GPU–NIC NUMA/PCIe affinity.
- Assuming RoCE performs well without suitable Ethernet congestion and loss configuration.
- Using “zero-copy” to mean that no physical data movement occurs.

## 10. Edge Cases / Special Cases

- Some paths require GPU and NIC to share a suitable upstream PCIe root/topology; platform-specific restrictions apply.
- Registration caches improve steady state but require correct invalidation when memory is freed or remapped.
- GPU-produced data must be visible to the NIC before send; receiver data must be visible before a kernel consumes it.
- Firewalls, routing, priority flow configuration, MTU, and congestion can affect RoCE despite correct application code.
- Containers need the right devices, drivers, IPC/memory-lock permissions, and RDMA resources.
- Failure recovery is harder than a simple blocking socket call because work is asynchronous and buffers may be in flight.

## 11. How to Explain in Interview

> RDMA lets a NIC transfer data directly between registered memory regions with little CPU involvement in the payload path. GPUDirect RDMA extends that path to GPU memory, avoiding an explicit host staging copy in distributed GPU jobs. The important caveats are registration, protection keys, completion semantics, GPU–NIC topology, and correct synchronization between kernels and network operations.

## 12. Quick Revision Notes

- RDMA = communication model; InfiniBand/RoCE = fabrics/transports that support it.
- Memory must be registered and protected with access metadata.
- One-sided read/write differs from two-sided send/receive.
- GPUDirect RDMA connects NIC/peer DMA to GPU memory.
- Completion does not automatically mean remote application consumption.
- “Zero-copy” means avoiding a staging copy, not avoiding DMA.
- Topology and registration reuse strongly affect performance.

## 13. Practice Tasks

1. Draw staged and GPUDirect RDMA paths for an inter-node GPU send.
2. Explain the lifetime of a registered source buffer from kernel production to send completion.
3. Design a ping-pong protocol using RDMA Write plus a completion notification.
4. Map four GPUs and two NICs using a topology matrix and justify rank/NIC affinity.
5. Benchmark message-rate and bandwidth regimes separately with an RDMA-capable tool.
6. Explain how you would detect that NCCL fell back from GPUDirect RDMA to sockets.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | NIC-assisted direct access to registered remote memory. |
| Why it matters | Fewer staging copies and less CPU work for distributed GPU payloads. |
| Most asked | Registration, one- vs two-sided, GPUDirect RDMA, completion, RoCE vs InfiniBand. |
| Main trap | Direct data path does not eliminate setup, synchronization, protection, or physical movement. |
| One-line answer | “GPUDirect RDMA lets the NIC move network payloads directly between GPU memory and the fabric, avoiding CPU staging.” |

---

# NCCL

## 1. Overview

**NCCL**—the NVIDIA Collective Communications Library, pronounced “Nickel”—provides GPU-optimized collective and point-to-point communication primitives. Core collectives include AllReduce, Broadcast, Reduce, AllGather, and ReduceScatter. It is topology-aware and can use available paths such as NVLink, NVSwitch, PCIe P2P, shared-memory mechanisms, network sockets, and RDMA-capable NICs.

NCCL matters because manually implementing fast, deadlock-free collectives across heterogeneous GPU topologies is difficult. Deep-learning frameworks use it behind distributed APIs, especially for gradient synchronization and model-parallel tensor exchange. Interviewers ask NCCL to determine whether a candidate knows the rank/communicator/stream programming model, collective matching rules, topology selection, asynchronous errors, hangs, and performance diagnosis.

NCCL is not a training framework, process launcher, general message-passing replacement, or hardware interconnect. It performs communication among ranks after the application or framework has created processes, selected GPUs, and initialized a communicator.

## 2. Core Idea

Imagine a logistics coordinator who knows every road between warehouses. The application says, “sum this array from every warehouse and give the total to all warehouses.” NCCL chooses a schedule—perhaps rings, trees, multiple channels, and hierarchical intra-/inter-node phases—then enqueues GPU work on CUDA streams.

```cpp
// Conceptual one-rank call; every rank must issue a matching operation.
ncclAllReduce(sendbuf, recvbuf, count, ncclFloat, ncclSum, comm, stream);
// Work is stream-ordered. Do not assume recvbuf is host-ready at return.
```

Step by step:

1. The launcher/framework assigns a global rank and local GPU to each process.
2. Ranks exchange a unique NCCL communicator ID using an out-of-band mechanism.
3. Each rank initializes the communicator with identical world size and its unique rank.
4. Every rank enqueues the same collective sequence with compatible counts/types/root/op.
5. NCCL maps the operation onto discovered local and network topology.
6. The receive buffer becomes usable by later work in the properly ordered CUDA stream.
7. The application checks asynchronous failures and destroys/aborts resources correctly.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Rank | Integer identity inside a communicator. | Rank 3 may control local GPU 1 on node B. | Rank is not inherently a CUDA device number. |
| Communicator | Group plus communication state/topology for ranks. | `ncclCommInitRank`. | All participating ranks need consistent membership. |
| CUDA stream semantics | NCCL operations are enqueued into a stream and ordered with CUDA work there. | Kernel -> AllReduce -> optimizer kernel in one stream. | API return is not collective completion. |
| Collective matching | Ranks must call compatible collectives in a consistent order. | Same count/type/op/root where required. | Mismatch can hang, crash, or corrupt data. |
| Algorithms | Ring, tree, and other schedules trade latency and bandwidth. | Tree for small latency-sensitive buffers, ring-like bandwidth schedule for large buffers. | Do not assume one algorithm is always best. |
| Protocols/channels | NCCL chunks messages and uses parallel channels/protocols. | Large gradient split across links/NICs. | More channels can also increase contention/resource use. |
| Transport selection | NCCL selects P2P, shared-memory, network, and RDMA-related paths. | NVLink intra-node, InfiniBand inter-node. | Hardware availability does not prove the selected fast path. |
| Group calls | `ncclGroupStart/End` batches or coordinates related operations/initialization. | Managing multiple GPUs from one host thread. | Incorrect blocking call order can deadlock without grouping. |
| In-place operation | Supported layouts allow send/receive data to share storage. | `sendbuf == recvbuf` for AllReduce. | AllGather/ReduceScatter have specific in-place offsets. |
| Async errors/timeouts | Transport or peer failure may surface after launch. | Poll communicator async error, abort peers. | Waiting forever without diagnostics. |
| Environment/debug controls | Logs and configuration help diagnose interfaces, topology, and transport. | `NCCL_DEBUG=INFO` during investigation. | Treating tuning variables as permanent magic fixes. |

## 4. Real-World Example

PyTorch Distributed Data Parallel usually creates one process per GPU. Backpropagation produces gradients in reverse layer order. The framework groups gradients into buckets; when a bucket is ready, it launches NCCL AllReduce while backpropagation continues on later buckets. After reduction, every rank has the global sum/average needed for a consistent optimizer update.

```text
backprop:   [layer 12][layer 11][layer 10][layer 9]...
bucket 0:             ready -> NCCL AllReduce -------->
bucket 1:                                ready -> NCCL AllReduce ->
goal: overlap independent communication with remaining backprop compute
```

Oversized buckets delay the first collective; tiny buckets waste latency and launch overhead. Bucket size is a practical communication/computation tradeoff.

## 5. Diagrams / Mental Models

```text
Rank 0 / GPU 0 -- NVLink/NVSwitch -- Rank 1 / GPU 1
       |                                  |
     NIC 0 ===== InfiniBand/RoCE ======= NIC 1
       |                                  |
Rank 2 / GPU 2 -- local GPU fabric ---- Rank 3 / GPU 3

NCCL builds a collective schedule over this topology;
the framework decides what tensors and when.
```

| Layer | Example responsibility |
|---|---|
| Framework | Bucket gradients; choose data/tensor/pipeline parallel groups. |
| NCCL | Execute group communication efficiently and stream-order it. |
| CUDA/driver | Memory, streams, device access, kernels. |
| Hardware/network | Move packets/bytes over actual links. |

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What is NCCL?** A topology-aware NVIDIA library for GPU collectives and point-to-point communication. | Library, ranks, GPU buffers. | Calling it a physical network. |
| 2 | **Why use NCCL instead of manual copies?** It supplies optimized schedules, topology/transport selection, reduction plus communication, and multi-node support. | Complexity hidden efficiently. | Saying it makes communication free. |
| 3 | **What is an NCCL rank?** A unique participant index in a communicator, often one process/GPU. | Logical identity. | Equating rank globally with CUDA device ID. |
| 4 | **What is a communicator?** State describing the rank group and resources used for their communication. | Membership and ordering context. | Reusing incompatible ranks/counts casually. |
| 5 | **Are NCCL calls synchronous?** They enqueue work on a CUDA stream; host return usually means submission, not completion. | Stream ordering. | Reading `recvbuf` on CPU immediately. |
| 6 | **Why do NCCL jobs hang?** Mismatched collective order/count/type/root, a missing rank, process failure, network/interface problems, or synchronization deadlock. | All ranks must participate compatibly. | Increasing a timeout before checking call order. |
| 7 | **How does NCCL select a path?** It discovers topology/capabilities and chooses transports, algorithms, channels, and protocols; configuration can constrain it. | Topology-aware runtime. | Assuming it always uses NVLink/RDMA. |
| 8 | **NCCL vs MPI?** NCCL specializes in efficient GPU communication and CUDA streams; MPI is a broader distributed programming/message-passing standard. They can be used together. | Scope and integration. | Saying NCCL launches MPI processes. |
| 9 | **What does `ncclGroupStart/End` do?** Groups calls so NCCL can treat related operations/initializations together and avoid some ordering deadlocks. | Batch/coordination semantics. | Treating it as a CUDA synchronization barrier. |
| 10 | **How do you debug slow NCCL?** Validate topology and fast-path transport, inspect logs, benchmark message sizes, check rank/NIC affinity and link health, then profile overlap. | Systematic measurement. | Random environment-variable tuning first. |

## 7. Deep-Dive Questions

1. **Why can ring AllReduce be bandwidth efficient?**  Each rank sends/receives chunks in a balanced pipeline and, for large buffers, avoids concentrating all traffic at one root. Latency grows with ring steps.
2. **Why use a tree?**  Logarithmic-depth communication can reduce step latency for smaller messages, though bandwidth utilization and contention differ by topology.
3. **What does stream ordering buy you?**  A producer kernel and NCCL operation in the same stream are ordered without a host-wide barrier; a consumer can similarly wait through stream/event dependencies.
4. **How does hierarchical NCCL communication work conceptually?**  It aggregates/exchanges within fast local groups and across slower network groups, then distributes results locally, reducing expensive cross-node traffic.
5. **What is collective bus bandwidth?**  A normalized metric that accounts for an algorithm's communication volume, useful for comparing collective utilization; it is not simply raw user-buffer bytes divided by time.

## 8. Comparison Tables

| NCCL | MPI |
|---|---|
| GPU-focused communication library | General distributed message-passing standard/ecosystem |
| CUDA stream-aware device-buffer operations | Host-oriented semantics with CUDA-aware implementations available |
| Optimized for NVIDIA GPU topology | Supports many devices, languages, and platforms |
| Not a process launcher/runtime by itself | MPI implementations commonly include launch/process services |
| Often combined with MPI for bootstrap/control | Can use NCCL-like specialization beneath/alongside GPU paths |

| Ring-style algorithm | Tree-style algorithm |
|---|---|
| Strong large-message bandwidth utilization | Lower communication depth for latency-sensitive messages |
| Many pipeline steps around ranks | Logarithmic-style propagation/reduction depth |
| Naturally balanced neighbor traffic | Can create parent/child hotspots depending on topology |
| Best choice depends on message and topology | Best choice depends on message and topology |

## 9. Common Mistakes

- Saying NCCL stands for “network CUDA communication layer.”
- Treating NCCL as a process launcher or distributed training framework.
- Using different collective sequences on different ranks.
- Assuming host return means GPU communication is complete.
- Confusing a rank with a physical GPU ID.
- Hard-coding a transport/algorithm without measurements.
- Applying debug environment variables permanently across unrelated systems.
- Forgetting that frameworks may divide the world into several communicators/groups.

## 10. Edge Cases / Special Cases

- Empty/zero-count operations and in-place layouts must still follow the documented collective matching rules.
- The root parameter is a communicator rank, not necessarily a local CUDA device index.
- Multiple communicators may issue work concurrently, but stream ordering and resource contention remain relevant.
- A crashed rank can leave peers waiting unless the framework detects failure and aborts/recreates the communicator.
- Forking a process after initializing accelerator communication state is generally unsafe in many runtime configurations.
- CUDA Graph capture is supported only under documented conditions and must preserve operation structure.
- NCCL may fall back to sockets or a less direct local path; correctness can remain while performance collapses.

## 11. How to Explain in Interview

> NCCL is NVIDIA's topology-aware GPU communication library. Ranks form a communicator and enqueue matching collectives such as AllReduce onto CUDA streams. NCCL chooses algorithms and transports across NVLink, PCIe, shared memory, or network/RDMA paths. The two major interview points are that all ranks must call compatible operations in the same order, and host API return does not mean the GPU communication has completed.

## 12. Quick Revision Notes

- NCCL = library, not hardware and not a process launcher.
- Rank = logical participant; communicator = group plus communication state.
- Operations are CUDA-stream ordered.
- Collective mismatch is a leading cause of hangs.
- Ring/tree and transport selection depend on size and topology.
- AllReduce is common for gradients; AllGather/ReduceScatter for sharded state and tensor parallelism.
- Debug by validating correctness/topology/transport before tuning.

## 13. Practice Tasks

1. Write pseudocode for one process per GPU communicator initialization.
2. Intentionally swap Broadcast and AllReduce on one rank and explain the resulting hang.
3. Run `nccl-tests` across increasing message sizes and plot latency/bandwidth regimes.
4. Compare one-node and two-node AllReduce; identify the hierarchy boundary.
5. Use logs to identify whether P2P, shared memory, sockets, or RDMA transport is selected.
6. Draw stream dependencies for kernel -> AllReduce -> optimizer without a device-wide synchronize.
7. Explain how gradient bucket size changes overlap and latency overhead.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Topology-aware NVIDIA library for GPU collective/point-to-point communication. |
| Why it matters | Replaces fragile manual multi-GPU schedules with optimized communication. |
| Most asked | Rank, communicator, stream semantics, hangs, ring vs tree, NCCL vs MPI. |
| Main trap | Every rank must issue compatible calls; host return is only submission. |
| One-line answer | “NCCL maps matching GPU collective calls onto the best available local and network paths.” |

---

# AllReduce

## 1. Overview

**AllReduce** combines an array from every rank element by element using an associative reduction operation and returns the complete reduced array to every rank. For sum on `P` ranks:

```text
out[i] = in_rank0[i] + in_rank1[i] + ... + in_rank(P-1)[i]
```

AllReduce is central to data-parallel training: every GPU computes gradients on a different mini-batch, then all GPUs need the same global gradient before applying the same optimizer step. It is also used for global norms, convergence values, distributed counters, and scientific reductions.

Interviewers ask it because it exposes both semantics and performance reasoning: Reduce versus AllReduce, ring versus tree algorithms, communication volume, numerical associativity, bucketing, overlap, synchronization, and the equivalence `ReduceScatter + AllGather = AllReduce` for compatible layouts and operations.

## 2. Core Idea

Imagine four analysts each have a spreadsheet with the same rows but different values. They must sum every row and give the final spreadsheet to all four analysts. Sending every sheet to one analyst and broadcasting the result works, but it can overload that root. Distributed algorithms share the reduction and distribution work.

Small sum example:

```text
Rank 0 input: [1, 2]
Rank 1 input: [3, 4]
Rank 2 input: [5, 6]

Element-wise sum: [1+3+5, 2+4+6] = [9, 12]

Rank 0 output: [9, 12]
Rank 1 output: [9, 12]
Rank 2 output: [9, 12]
```

A common bandwidth-oriented construction is:

1. Split each input into `P` chunks.
2. **ReduceScatter:** exchange/reduce chunks until each rank owns one fully reduced chunk.
3. **AllGather:** circulate those reduced chunks until every rank has all of them.
4. Pipeline chunks so links remain busy and no root handles all bytes.

For a large ring AllReduce, each rank conceptually sends/receives about `2(P-1)/P * N` payload bytes for an `N`-byte array, excluding protocol overhead. This is far better balanced than gathering all `P*N` bytes at one root and rebroadcasting from it.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Reduction operator | Element-wise associative operation such as sum, min, max, or product. | Sum gradients; max a distributed score. | Floating-point sum is not mathematically associative. |
| All vs root result | AllReduce returns the result everywhere; Reduce returns it only at a root. | Every training rank needs the gradient. | Confusing the two operations. |
| Ring algorithm | Chunks move through `P-1` ReduceScatter and `P-1` AllGather steps. | Large dense gradient buffer. | Bandwidth efficient but step latency grows with ranks. |
| Tree algorithm | Values reduce up a tree and distribute down it. | Small control tensor or latency-sensitive collective. | Lower depth but different traffic/hotspots. |
| Hierarchical algorithm | First operate within fast local groups, then across nodes, then locally distribute. | NVSwitch inside nodes, RDMA across nodes. | Match algorithm to topology tiers. |
| Bucketing/fusion | Combine small tensors into larger collective buffers. | Framework gradient buckets. | Too small wastes latency; too large delays overlap. |
| Overlap | Launch a bucket when ready while independent computation continues. | Backprop of lower layers overlaps upper-layer gradient reduction. | Data dependencies constrain overlap. |
| In-place operation | Input and output may share storage under API rules. | `sendbuf == recvbuf` in NCCL AllReduce. | Do not overwrite data before it is consumed. |
| Scaling/averaging | Sum is often divided by world size, in framework or optimizer logic. | Global mean gradient. | NCCL sum does not necessarily divide automatically. |
| Precision/reproducibility | Reduction order changes rounding; low precision can accumulate error. | FP16 gradients accumulated with higher-precision strategies. | Bitwise equality across algorithms is not guaranteed. |

## 4. Real-World Example

Four GPUs train identical model replicas with local batch size 32. Each computes gradient `g_r` from its samples. The desired global-batch mean is:

```text
g = (g_0 + g_1 + g_2 + g_3) / 4
```

The framework launches an AllReduce sum for each ready gradient bucket and divides by four, either before/after the collective according to its implementation. Every replica then applies the same update and stays synchronized.

If one rank skips a bucket because its control flow did not use a parameter while peers call AllReduce, the collective sequence can mismatch and hang. Distributed training therefore needs consistent collective participation or explicit unused-parameter handling.

## 5. Diagrams / Mental Models

```text
Ring with four ranks:

R0 -> R1 -> R2 -> R3 -> R0

Phase A: ReduceScatter
chunks circulate; each hop combines one incoming chunk
Result: R0 owns reduced C0, R1 owns C1, R2 owns C2, R3 owns C3

Phase B: AllGather
reduced chunks circulate without further reduction
Result: every rank owns C0|C1|C2|C3
```

```text
Ideal iteration time with overlap:
max(compute_time, communication_time_that_can_overlap)
  + exposed_nonoverlappable_communication + synchronization
```

The total is not simply `compute + communication` when overlap is real, nor simply `max` when dependencies expose a tail.

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What does AllReduce do?** Reduces same-shaped inputs across all ranks and returns the full result to all ranks. | Reduction plus distribution. | Describing only Reduce. |
| 2 | **Why is it used in data parallelism?** Model replicas need a common gradient computed from all local mini-batches. | Replica consistency. | Saying it exchanges model weights every layer. |
| 3 | **AllReduce vs Reduce?** Reduce writes the result at one root; AllReduce writes it at every rank. | Output placement. | Saying AllReduce performs a different mathematical operator. |
| 4 | **How does ring AllReduce work?** A ReduceScatter reduces chunks around a ring, followed by an AllGather of the reduced chunks. | Two phases, chunking, pipeline. | Saying the entire buffer goes once around the ring. |
| 5 | **Why is ring bandwidth efficient?** Work and bytes are balanced among ranks and large chunks pipeline over neighbor links without a root bottleneck. | Per-rank volume. | Claiming constant latency as ranks grow. |
| 6 | **When might a tree be better?** Smaller messages or latency-sensitive cases where fewer sequential communication steps outweigh ring bandwidth advantages. | Latency/bandwidth tradeoff. | One algorithm always wins. |
| 7 | **Does AllReduce average gradients?** The collective applies its requested reduction; sum-to-average scaling is separate unless the API/operator/framework specifies averaging. | Sum vs mean. | Assuming division by world size is universal. |
| 8 | **Can AllReduce overlap backpropagation?** Yes for a ready bucket while later independent gradients are still computed, using proper stream dependencies. | Buckets and dependency graph. | Launching before data is ready. |
| 9 | **What happens if ranks use different counts?** Behavior is invalid and may hang, crash, or corrupt results. | Matching collective contract. | Expecting automatic size negotiation. |
| 10 | **Why can results differ across algorithms?** Floating-point addition order changes rounding; chunk/order selection can change numerical results. | Non-associativity in finite precision. | Calling any difference a network corruption bug. |

## 7. Deep-Dive Questions

1. **Derive ring data volume.**  In each of two phases, a rank sends `P-1` chunks of size `N/P`, so total per-rank sent bytes are `2(P-1)N/P`; receive volume is similar.
2. **Why does weak scaling still suffer?**  Even if compute per GPU stays fixed, communication grows with model state and rank/topology costs; synchronization exposes stragglers.
3. **How does gradient compression change the problem?**  It reduces bytes but adds compression/decompression compute and may change convergence or require error feedback. Measure end-to-end training-to-quality.
4. **Why can one slow rank slow every rank?**  Collectives are coordinated; peers cannot finish until required data/progress arrives. Load imbalance and network jitter become global stalls.
5. **How would sharded optimizers reduce AllReduce pressure?**  ReduceScatter can leave each rank with only its gradient shard for sharded optimizer work, and later AllGather can reconstruct parameters when needed, reducing replicated state/communication patterns.

## 8. Comparison Tables

| Reduce | AllReduce |
|---|---|
| Reduced result only at root | Reduced result at every rank |
| Useful for centralized reporting | Useful when all ranks consume the value |
| Follow with Broadcast to emulate AllReduce | Often optimized as distributed ReduceScatter + AllGather |
| Root can become a traffic focus in naive algorithms | Balanced algorithms avoid a single-root bottleneck |

| AllReduce | AllGather |
|---|---|
| Combines element-wise values | Concatenates rank-ordered contributions |
| Output shape equals one input shape | Output is `P` times one rank's input contribution |
| Needs a reduction operator | No reduction operator |
| Example: sum gradients | Example: assemble parameter/activation shards |

## 9. Common Mistakes

- Calling AllReduce a “broadcast of gradients” without mentioning reduction.
- Forgetting that every rank receives the result.
- Assuming NCCL sum automatically computes a mean.
- Giving ring communication complexity only as `O(P)` and ignoring pipelined byte volume/bandwidth behavior.
- Claiming overlap without checking readiness and consumer dependencies.
- Ignoring stragglers and synchronization.
- Assuming floating-point results are bitwise invariant under a different rank count or algorithm.
- Using many tiny AllReduces instead of reasonable fusion/buckets.

## 10. Edge Cases / Special Cases

- With one rank, AllReduce is effectively a local identity/copy subject to API semantics.
- Zero-count collectives must still be called consistently if they are part of the sequence.
- Unequal local batch sizes require weighted reduction; simply averaging rank-local means is biased.
- Sparse gradients may be inefficient when forced into dense AllReduce; specialized sparse exchange can be better.
- Non-associative or non-commutative custom operations need careful ordering support; common optimized collectives assume suitable reduction properties.
- Overflow/underflow can occur before division when summing low-precision values.
- Faults are not automatically “skipped”; most ordinary communicators require all members to participate.

## 11. How to Explain in Interview

> AllReduce combines equal-shaped arrays from all ranks element by element and returns the full reduced array to every rank. Data-parallel training uses it to synchronize gradients. A bandwidth-efficient ring implements it as ReduceScatter followed by AllGather, while trees can reduce latency for smaller messages. Practical performance depends on bucketing, topology, overlap, stragglers, and matching collective calls on every rank.

## 12. Quick Revision Notes

- Semantics: reduce everywhere, result everywhere.
- Data parallel use: synchronize gradients, then apply identical updates.
- Ring: ReduceScatter + AllGather; about `2(P-1)N/P` bytes sent per rank.
- Tree: fewer sequential levels; useful for latency-sensitive sizes.
- Sum is not automatically mean.
- Floating-point reduction order changes rounding.
- Trap: one missing/mismatched rank can hang the communicator.

## 13. Practice Tasks

1. Simulate a four-rank ring AllReduce on four chunks by hand.
2. Implement a CPU reference AllReduce simulator and verify every rank receives the same vector.
3. Plot predicted ring transfer time using `latency + bytes/bandwidth` as rank count changes.
4. Compare 100 tiny AllReduces with one fused buffer of equal total size.
5. Construct an unequal-batch example and compute the correct weighted global mean.
6. Draw a hierarchical AllReduce for two nodes with four GPUs each.
7. Explain stream events needed to overlap gradient bucket reduction with backpropagation.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Element-wise reduction across ranks, full result returned to every rank. |
| Why it matters | Synchronizes replicated computation, especially data-parallel gradients. |
| Most asked | Reduce vs AllReduce, ring steps/volume, tree tradeoff, gradient averaging, overlap. |
| Main trap | Sum, mean, and floating-point reproducibility are distinct concerns. |
| One-line answer | “AllReduce gives every rank the same global reduction; ring AllReduce is ReduceScatter plus AllGather.” |

---

# AllGather

## 1. Overview

**AllGather** collects an equal-sized contribution from every rank, concatenates contributions in rank order, and delivers the complete concatenated buffer to every rank. With `P` ranks contributing `N` elements each, every output has `P*N` elements.

Unlike AllReduce, AllGather does not mathematically combine values. It preserves every rank's contribution. It is used to assemble sharded parameters, activations, embeddings, metadata, and variable pieces after padding/count exchange. It is essential in tensor/sequence parallelism and sharded training systems.

Interviewers ask it to test output sizing, ordering, Gather versus AllGather, AllGather versus AllReduce, ring construction, memory amplification, in-place layout, uneven-size handling, and why gathering a full tensor can trade memory/communication for simpler local computation.

## 2. Core Idea

Imagine every participant holds one page of a report. AllGather photocopies and orders every page so that everyone receives the complete report.

```text
Rank 0 contributes [A0, A1]
Rank 1 contributes [B0, B1]
Rank 2 contributes [C0, C1]

Every rank receives [A0, A1, B0, B1, C0, C1]
                     rank 0   rank 1   rank 2
```

A ring AllGather works step by step:

1. Each rank places its local contribution in the rank-specific output slot.
2. On each step, every rank sends a chunk it owns to the next rank and receives a new chunk from the previous rank.
3. After `P-1` steps, every contribution has visited every rank.
4. The output order is determined by rank, not arrival time.

For a total gathered output of `M = P*N` bytes, each rank sends/receives approximately `(P-1)/P * M = (P-1)N` payload bytes in a ring, excluding overhead.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Rank order | Output slots are ordered by communicator rank. | Rank 2 data starts after two rank-sized blocks. | Arrival order is irrelevant. |
| Output expansion | Every rank allocates space for all contributions. | `P*N` receive elements. | Memory cost grows with world size. |
| Gather vs AllGather | Gather returns concatenation only at a root; AllGather returns it everywhere. | Root-only logging vs replicated tensor. | Confusing output placement. |
| Ring algorithm | Contributions circulate through neighbors for `P-1` steps. | Large shard assembly. | Balanced bandwidth with rank-dependent latency steps. |
| In-place layout | Each rank's input already occupies its designated output slice under API rules. | Rank `r` uses offset `r*N`. | Arbitrary overlap is not safe. |
| Tensor parallelism | Local activation shards are assembled for an operation needing the full dimension. | Gather hidden-dimension shards before a replicated layer. | Communication can erase sharding gains. |
| Parameter sharding | Parameters are materialized before compute and can be released/resharded afterward. | Fully sharded data parallel layer prefetch. | Peak memory depends on how many full tensors coexist. |
| Uneven sizes | Basic NCCL AllGather uses equal contributions; sizes must be padded or implemented with other exchanges. | Variable token counts. | Assuming an `AllGatherv` signature where none is used. |
| Chunking/prefetch | Gather upcoming data while current compute runs. | Prefetch next layer's parameter shard. | Prefetch too far increases peak memory. |
| Reverse relation | The backward of a replicated concatenation often involves slicing or ReduceScatter depending on computation. | Autograd communication pair. | Forward/backward collectives are not always identical. |

## 4. Real-World Example

In fully sharded training, four ranks store one quarter of a layer's parameter tensor. Before the layer executes, ranks AllGather the four shards so each GPU temporarily has the full parameter. They run the local forward/backward computation and release or reshard the full tensor. Gradient communication may use ReduceScatter so each rank retains only its reduced gradient shard.

```text
steady state: each rank owns W_r (1/4 of W)
pre-forward:  AllGather W_0..W_3 -> full W on each rank
compute:      use W
post-use:     discard full materialization, keep owned shard
```

This reduces persistent memory but adds repeated communication and temporary full-tensor memory.

## 5. Diagrams / Mental Models

```text
Before:
R0 [A]    R1 [B]    R2 [C]    R3 [D]

After AllGather:
R0 [A|B|C|D]
R1 [A|B|C|D]
R2 [A|B|C|D]
R3 [A|B|C|D]
```

```text
Memory tradeoff:
local shard size = N
AllGather output per rank = P*N
total replicated output across ranks = P*P*N
```

The collective is useful because the full view is required temporarily, but careless lifetime management can destroy the memory benefit of sharding.

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What does AllGather do?** Concatenates equal-sized rank contributions in rank order and returns the full buffer to every rank. | Concatenation, all outputs. | Saying values are summed. |
| 2 | **What is the output size?** `P * sendcount` elements per rank for `P` ranks. | Memory scaling. | Allocating only `sendcount`. |
| 3 | **Gather vs AllGather?** Gather stores the combined buffer at one root; AllGather stores it at every rank. | Result placement. | Confusing root semantics. |
| 4 | **AllGather vs AllReduce?** AllGather preserves/concatenates values; AllReduce combines them element-wise and keeps the original shape. | No reduction operator. | Using one as a direct semantic replacement. |
| 5 | **How does ring AllGather work?** Each rank circulates chunks to its neighbor for `P-1` steps until all ranks own all chunks. | Ring steps and rank slots. | Assuming one all-to-all blast with no schedule. |
| 6 | **Where is it used in ML?** Parameter/activation shard assembly, tensor parallelism, embedding outputs, and sharded optimizer/training states. | Concrete use. | Giving only a logging example. |
| 7 | **Can contributions have different sizes?** The basic equal-count collective cannot directly represent that; exchange sizes and pad or use a variable-size/p2p strategy. | Contract. | Letting ranks pass different counts. |
| 8 | **What is the main cost?** Communication plus an output buffer that is `P` times the local contribution on every rank. | Memory amplification. | Discussing network only. |
| 9 | **Can AllGather be in place?** Yes only with the documented layout where each rank's local contribution is in its rank-specific receive slice. | Correct offset. | `sendbuf == recvbuf` without placement reasoning. |
| 10 | **How can it overlap computation?** Chunk/prefetch a future tensor while computing on an independent current tensor, with stream/event ordering and bounded memory. | Dependency plus lifetime. | Prefetching everything and causing OOM. |

## 7. Deep-Dive Questions

1. **Why does AllGather become problematic at large `P`?**  Each rank's output grows linearly with `P`, aggregate replication grows quadratically relative to one shard, and link traffic/synchronization also increases.
2. **How do you handle variable-length sequences?**  First exchange lengths, compute offsets, then pad to a common size or perform grouped point-to-point/variable-count communication; carry masks so padding is ignored.
3. **When is AllGather preferable to remote reads?**  When the full data will be reused enough that one bulk transfer into local HBM is cheaper than many latency-sensitive peer/network accesses.
4. **Why pair AllGather with ReduceScatter in sharded training?**  AllGather materializes full parameters for compute; ReduceScatter combines gradients and leaves only each rank's owned shard, restoring sharded state.
5. **How would you reduce peak memory?**  Gather one layer/chunk just in time, compute, release it promptly, limit prefetch distance, and reuse communication buffers.

## 8. Comparison Tables

| Gather | AllGather |
|---|---|
| Full concatenation at root only | Full concatenation at every rank |
| Non-root ranks need only send contribution | Every rank needs a large receive buffer |
| Good for centralized output/checkpoint metadata | Good when all ranks compute from the full view |
| Root-focused algorithm can bottleneck | Distributed ring/tree algorithms balance traffic |

| AllGather | Broadcast |
|---|---|
| Every rank contributes distinct data | Only root contributes authoritative data |
| Output is concatenation of all contributions | Output is one root buffer copied everywhere |
| Output grows with rank count | Output size equals root buffer size |
| Used to assemble shards | Used to distribute initialization/configuration/tensors |

## 9. Common Mistakes

- Saying AllGather performs a sum or merge with conflict resolution.
- Forgetting rank-ordered output layout.
- Allocating insufficient receive memory.
- Passing different counts on different ranks to a fixed-count collective.
- Keeping every gathered layer alive and losing sharding's memory benefit.
- Assuming in-place means arbitrary overlapping pointers.
- Ignoring padding overhead for variable-length data.
- Confusing AllGather with All-to-All, where each rank sends different destination-specific chunks.

## 10. Edge Cases / Special Cases

- With one rank, output equals the local contribution.
- A zero-sized contribution still requires consistent call sequencing.
- Logical rank remapping changes output order, even when physical GPU placement is unchanged.
- Padding variable sizes can waste substantial bandwidth under skewed lengths.
- Large gathered outputs can fail allocation before communication begins.
- In tensor parallel code, a local transpose/layout conversion may be required after gathering; communication completion alone does not guarantee the desired tensor layout.
- A gather immediately followed by slicing may indicate that a more targeted collective or sharding strategy is possible.

## 11. How to Explain in Interview

> AllGather takes one equal-sized shard from every rank, concatenates shards in rank order, and gives the complete buffer to every rank. It does no reduction, and each rank's output is world-size times the local shard. It is widely used to materialize sharded parameters or activations, but memory amplification, equal-count requirements, chunking, and lifetime management are the key practical concerns.

## 12. Quick Revision Notes

- Semantics: `[rank0 data | rank1 data | ...]` on every rank.
- No reduction operator.
- Output count per rank = `P * sendcount`.
- Gather gives full result only to root.
- Ring AllGather takes `P-1` circulation steps.
- Used for parameter/activation shard assembly.
- Trap: equal-count collective does not accept arbitrary variable sizes.
- Trap: temporary full materializations can cause OOM.

## 13. Practice Tasks

1. Trace a four-rank ring AllGather one step at a time.
2. Given rank contributions of three floats, calculate every output offset.
3. Design a variable-length AllGather using a length exchange plus padding.
4. Estimate peak memory when eight ranks gather a 2 GB parameter tensor.
5. Pair a layerwise parameter AllGather timeline with gradient ReduceScatter.
6. Compare bulk AllGather with repeated remote peer reads for a reused tensor.
7. Write a small CPU simulator that verifies rank-ordered concatenation.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Rank-ordered concatenation of every contribution, returned to every rank. |
| Why it matters | Materializes distributed shards for local computation. |
| Most asked | Output size/order, Gather vs AllGather, AllGather vs AllReduce, ring steps, variable counts. |
| Main trap | Communication and memory both scale; no reduction occurs. |
| One-line answer | “AllGather trades communication and replicated memory for a complete rank-ordered view on every GPU.” |

---

# ReduceScatter

## 1. Overview

**ReduceScatter** first reduces equal-shaped logical inputs from every rank element by element, then partitions the reduced result into equal rank-ordered chunks so rank `r` receives only chunk `r`. If each rank receives `N` elements and there are `P` ranks, each rank provides a logical input of `P*N` elements.

It matters when the reduced result should remain sharded rather than replicated. Sharded optimizers use it to combine gradients while leaving each rank responsible for only its parameter/gradient partition. It is also the first half of a common ring AllReduce.

Interviewers ask it because candidates often confuse it with Reduce followed by an unrelated Scatter, get `sendcount`/`recvcount` sizes wrong, overlook rank-ordered ownership, or fail to see why it reduces memory and subsequent communication in sharded training.

## 2. Core Idea

Suppose four kitchens each produce estimates for four delivery zones. The estimates for each zone must be summed, but each kitchen is responsible for only one final zone. ReduceScatter performs both jobs: combine every kitchen's estimate and deliver one final zone total to its owner.

```text
Rank 0 input: [ 1,  2,  3,  4]
Rank 1 input: [10, 20, 30, 40]

Reduced:      [11, 22, 33, 44]
Scatter with two elements per rank:
Rank 0 output: [11, 22]
Rank 1 output: [33, 44]
```

Ring intuition with `P` chunks:

1. Divide every rank's input into `P` equal chunks.
2. Each step sends one partial chunk to the next rank.
3. The receiver reduces incoming values into its partial chunk.
4. After `P-1` steps, every chunk has incorporated every rank's contribution.
5. The schedule leaves reduced chunk `r` at rank `r`.

Each rank sends/receives about `(P-1)/P * M` bytes for a total input size `M`, excluding overhead.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Reduction then distribution | Global element-wise combine with only one result shard retained per rank. | Sum a full logical gradient, keep owned shard. | Semantics differ from plain Scatter. |
| Buffer sizing | If `recvcount=N`, logical send buffer holds `P*N` elements per rank. | Four ranks, 1M receive values -> 4M input values per rank. | Confusing send and receive counts. |
| Rank-owned chunk | Rank index determines which reduced contiguous block it receives. | Rank 2 gets block 2. | Physical GPU order and logical rank order differ. |
| Ring phase | Common bandwidth-efficient `P-1` step algorithm. | First phase of ring AllReduce. | Partial chunks are reduced at every hop. |
| Sharded data parallelism | Keeps gradients/optimizer state partitioned. | Each GPU updates one quarter of parameters. | Avoid full gradient replication. |
| AllReduce decomposition | `ReduceScatter + AllGather` yields AllReduce when layout/operator agree. | Reduce chunks, then distribute all chunks. | This is semantic equivalence, not always two literal API calls internally. |
| In-place layout | Send and receive regions may overlap only at the documented rank-specific offset. | Receive points to owned slice. | Arbitrary aliasing corrupts inputs. |
| Precision/scaling | Reduction order and sum-to-mean scaling remain relevant. | Divide reduced gradient shards by global sample count. | Assuming ReduceScatter averages. |
| Uneven partitions | Basic operation uses equal chunks; uneven model partitions need padding or another scheme. | Parameter counts not divisible by `P`. | Ignoring padding and valid-length metadata. |

## 4. Real-World Example

Eight GPUs train a model with optimizer state sharded across ranks. After backward, each rank conceptually has contributions to the full gradient. ReduceScatter sums those contributions but leaves only one-eighth of the reduced gradient on each GPU. Rank `r` updates its owned one-eighth of parameters and optimizer moments. When full parameters are needed for a layer, an AllGather temporarily materializes them.

```text
backward contributions on every rank
              |
       ReduceScatter(sum)
              |
R0 owns G0  R1 owns G1 ... R7 owns G7
              |
sharded optimizer updates local parameter shard
```

This lowers replicated gradient/optimizer memory but requires careful ordering between shard ownership, optimizer updates, and later parameter gathering.

## 5. Diagrams / Mental Models

```text
Inputs on every rank:  [C0 | C1 | C2 | C3]
                         \    \    \    \
Reduce same-position chunks across all ranks
                           \    \    \    \
Outputs:            R0[C0] R1[C1] R2[C2] R3[C3]
```

| Collective | Global mathematical result | What each rank stores |
|---|---|---|
| Reduce | Full reduced array | Root only |
| AllReduce | Full reduced array | Every rank |
| ReduceScatter | Full result exists conceptually, but partitioned | One rank-specific shard |

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What does ReduceScatter do?** Reduces corresponding elements across ranks and gives each rank one equal rank-indexed shard of the result. | Reduction plus sharded output. | Describing only Scatter. |
| 2 | **How large are buffers?** For `P` ranks and `recvcount=N`, each logical input has `P*N` elements and each output has `N`. | Count contract. | Passing only `N` input elements. |
| 3 | **ReduceScatter vs AllReduce?** ReduceScatter keeps one reduced shard per rank; AllReduce gives every rank the full reduced result. | Replication difference. | Saying mathematical reduction differs. |
| 4 | **How is it related to ring AllReduce?** It is the first phase; an AllGather of reduced shards completes AllReduce. | Two-phase decomposition. | Reversing the phases. |
| 5 | **Where is it used?** Sharded gradients/optimizers, tensor parallel reductions with sharded consumers, and collective algorithms. | Practical example. | Only mentioning textbook MPI. |
| 6 | **Does it reduce memory?** It can avoid storing a full reduced output on every rank, but input/layout/framework buffers still determine actual peak memory. | Output sharding and caveat. | Claiming guaranteed `P`-fold total memory reduction. |
| 7 | **Does it average?** Only if an average operator/framework behavior is selected; sum normally requires explicit scaling. | Reduction operator. | Assuming division by ranks. |
| 8 | **Can chunks be unequal?** Basic fixed-count ReduceScatter uses equal output counts; use padding or a variable-count alternative/other communication. | Equal partitions. | Mismatched per-rank counts. |
| 9 | **Why can it hang?** Missing/mismatched ranks, count/type/op/order differences, transport failure, or bad synchronization. | Collective contract. | Debugging only link bandwidth. |
| 10 | **What is the ring byte volume?** For total input `M`, roughly `(P-1)M/P` bytes sent and similarly received per rank, excluding overhead. | Chunked `P-1` steps. | Saying every rank sends `P*M`. |

## 7. Deep-Dive Questions

1. **Why can ReduceScatter outperform AllReduce when consumers are sharded?**  It omits the AllGather phase and avoids replicating data the next computation does not need.
2. **How do uneven parameter sizes affect implementation?**  Frameworks flatten/bucket parameters, pad to divisible chunk sizes, track valid ranges, or use ownership-aware exchanges.
3. **What is the backward communication pair of a parameter AllGather?**  Often a gradient ReduceScatter, because contributions for the full parameter must be summed while restoring gradient sharding.
4. **How does a straggler affect ReduceScatter?**  Every final chunk depends on contributions from all ranks, so one delayed producer or path can stall the group.
5. **Can reduction be fused with communication?**  Yes. Optimized algorithms reduce incoming chunks as they move rather than communicate all data first and launch a separate full-buffer reduction.

## 8. Comparison Tables

| ReduceScatter | Scatter |
|---|---|
| Every rank contributes a full logical input | Root supplies chunks |
| Corresponding values are reduced | No reduction occurs |
| Each rank gets one reduced shard | Each rank gets one root-provided shard |
| Used for distributed aggregation with sharded output | Used for distribution from one source |

| ReduceScatter | AllGather |
|---|---|
| Many full logical contributions -> one reduced shard per rank | One shard per rank -> full concatenation per rank |
| Shrinks each rank's stored result | Expands each rank's stored result |
| Has reduction operator | Has no reduction operator |
| First half of ring AllReduce | Second half of ring AllReduce |

## 9. Common Mistakes

- Treating it as a root Reduce followed by a root Scatter implementation.
- Getting the `P * recvcount` logical input size wrong.
- Forgetting that output ownership follows rank order.
- Assuming it averages rather than applying the requested operator.
- Claiming memory savings without counting temporary flattened/padded buffers.
- Using it when every rank immediately needs the full reduced tensor, then manually recreating an inefficient AllGather.
- Ignoring floating-point reduction-order effects.

## 10. Edge Cases / Special Cases

- One rank receives the full local reduction result.
- Zero-count calls still need consistent ordering across ranks.
- Total element count must fit the equal partitioning/layout required by the API; padding may be necessary.
- In-place receive storage is usually the rank's designated portion of the send layout, not simply the buffer start for all ranks.
- If later computation needs only a noncontiguous ownership pattern, a contiguous ReduceScatter may require packing/unpacking.
- Weighted gradient means for unequal sample counts need sum of weighted contributions and a global count, not mean of local means.

## 11. How to Explain in Interview

> ReduceScatter combines equal-position values from every rank and leaves only one rank-indexed reduced chunk on each rank. With `P` ranks, a rank receiving `N` elements contributes a logical `P*N`-element input. It is used by sharded training and forms the first half of ring AllReduce; AllGather of the reduced chunks produces the full result everywhere.

## 12. Quick Revision Notes

- Reduce + sharded output, with no single required root.
- Output rank `r` = reduced chunk `r`.
- Input count per rank = `P * recvcount` for equal chunks.
- `ReduceScatter -> AllGather = AllReduce` semantically.
- Used for sharded gradients/optimizer state.
- No implicit averaging unless specified.
- Trap: in-place offsets are rank-specific.

## 13. Practice Tasks

1. Trace the two-rank numeric example with sum, max, and product.
2. Simulate a four-rank ring ReduceScatter using four chunks.
3. Given 1,003 parameters and four ranks, design padding and valid ownership ranges.
4. Compare peak output memory for AllReduce and ReduceScatter on an 8 GB tensor.
5. Draw the communication around a sharded optimizer update.
6. Derive the ring per-rank byte volume for `P=8` and `M=1 GiB`.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Global element-wise reduction whose result remains evenly sharded by rank. |
| Why it matters | Avoids replicating reduced data when later computation is sharded. |
| Most asked | Buffer sizes, relation to AllReduce, use in sharded training, ReduceScatter vs Scatter. |
| Main trap | Every rank contributes the full logical range but receives only one chunk. |
| One-line answer | “ReduceScatter is the bandwidth-saving reduction to use when each GPU needs only its owned result shard.” |

---

# Broadcast

## 1. Overview

**Broadcast** copies the same buffer from one designated **root rank** to every rank in a communicator, including a root receive result according to the API's semantics. Only the root supplies authoritative data; other ranks participate as receivers.

Broadcast is used for initial model weights, configuration, random seeds, metadata, checkpoints, lookup tables, and control values. It matters because naïvely having the root send the complete buffer separately to every peer can overload the root and serialize communication. Tree or pipelined algorithms spread forwarding work.

Interviewers ask Broadcast to test root semantics, Broadcast versus AllGather, tree complexity, stream ordering, in-place behavior, rank/device confusion, and the danger of using a collective for control flow when some ranks do not participate.

## 2. Core Idea

A teacher has one announcement that every student must receive. Calling every student one by one takes `P-1` sequential calls. A phone tree lets recipients forward the same announcement, reducing propagation depth.

```text
Root rank 0 owns [A, B, C]

Before: R0 [A,B,C]   R1 [?]   R2 [?]   R3 [?]
After:  R0 [A,B,C]   R1 [A,B,C] R2 [A,B,C] R3 [A,B,C]
```

Binary-tree-style steps:

1. Root sends to one peer.
2. In the next round, both informed ranks send to uninformed ranks.
3. The informed set roughly doubles each round.
4. After about `log2(P)` rounds, all ranks have the data, subject to topology and chunking.

For large messages, libraries may pipeline chunks through trees/rings to balance startup latency and bandwidth.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Root rank | Logical communicator rank that owns source data. | `root=0` may map to GPU 3 physically. | Root is not necessarily CUDA device 0. |
| Collective participation | Every communicator rank enters the call in compatible order. | Non-roots pass receive storage. | Only calling the API on root causes a hang. |
| Tree algorithm | Informed ranks forward to peers, lowering communication depth. | Small/medium control or parameter buffer. | Better than sequential root sends for latency. |
| Pipelining/chunking | Large buffers are split and forwarded while later chunks arrive. | Model parameter broadcast. | Balances startup and sustained bandwidth. |
| In-place operation | Root source/destination may share storage under API rules. | `sendbuff == recvbuff` at root. | Non-root send buffer is not authoritative. |
| Stream semantics | GPU buffer production, Broadcast, and consumption must be stream-ordered. | Root kernel produces weights; peers consume after collective. | Host return does not make output ready. |
| Broadcast vs AllGather | One root contribution copied everywhere vs all-rank concatenation. | Distribute seed vs assemble shards. | Using AllGather wastes output space for one-source data. |
| Broadcast vs Reduce+Bcast | Broadcast has no reduction; it distributes existing data. | Initial weights vs aggregated gradients. | Calling Broadcast an aggregation. |
| Root bottleneck | Naive one-to-many sends overload root links. | Root sends `P-1` full copies serially. | Optimized collective avoids simple star schedule. |
| Reliability/consistency | All ranks must agree on root, count, type, and call order. | One rank uses wrong root and hangs. | Expecting runtime negotiation. |

## 4. Real-World Example

At job startup, rank 0 reads a checkpoint and places parameters in GPU memory. A Broadcast distributes each parameter bucket to all data-parallel replicas. Each GPU then begins inference/training with identical initial weights. A production implementation may pipeline disk read, H2D copy, and GPU Broadcast; buffers are reused only after the corresponding stream/event reports completion.

```text
rank 0: storage -> pinned host -> GPU bucket -> Broadcast bucket -> reuse
rank 1:                                  receive -> model buffer
rank 2:                                  receive -> model buffer
rank 3:                                  receive -> model buffer
```

For enormous models that are intentionally sharded, broadcasting the full model to every GPU is wrong; Scatter or shard-aware loading may be more appropriate.

## 5. Diagrams / Mental Models

```text
Naive star:                  Tree:
        R1                         R0
        ^                         /  \
        |                       R1    R2
R3 <--- R0 ---> R2                  /  \
                                  R3    R4

Root transmits every copy.       Forwarding work is distributed.
```

| Question | Broadcast answer |
|---|---|
| Who contributes data? | Root only. |
| Who participates? | Every rank. |
| Who receives the result? | Every rank. |
| Is there a reduction operator? | No. |
| Does output grow with rank count? | No; each rank receives the root buffer size. |

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **What does Broadcast do?** Copies one root rank's buffer to every rank. | One source, all destinations. | Saying all ranks contribute. |
| 2 | **Do non-root ranks call Broadcast?** Yes, all communicator ranks must issue a compatible call. | Collective participation. | Calling only on root. |
| 3 | **What does root mean?** A communicator rank, not necessarily a CUDA device ID or node-local rank. | Logical mapping. | Passing local GPU index as global root. |
| 4 | **Broadcast vs AllGather?** Broadcast copies one source buffer; AllGather concatenates every rank's contribution. | Contribution/output size. | Treating them as equivalent when non-root data exists. |
| 5 | **Broadcast vs Scatter?** Broadcast sends the same full buffer to all ranks; Scatter sends a different root-owned chunk to each rank. | Same vs partitioned data. | Saying Scatter also replicates. |
| 6 | **Why use a tree?** It reduces propagation depth and distributes forwarding work instead of making root send all copies sequentially. | Roughly logarithmic rounds. | Claiming exactly `log P` time independent of bytes/topology. |
| 7 | **Can Broadcast overlap computation?** Yes when the communicated buffer/chunks are independent and streams/events enforce producer/consumer dependencies. | Pipelining. | Consumers reading early chunks without ordering. |
| 8 | **Does host return mean Broadcast completed?** Not for stream-enqueued GPU collectives; synchronize/order before host or another stream consumes data. | Async semantics. | Immediate buffer reuse. |
| 9 | **What causes a Broadcast hang?** A missing rank or mismatched count/type/root/order, process failure, or transport issue. | Matching contract. | Debugging only the root. |
| 10 | **When is Broadcast the wrong collective?** When data is naturally sharded or every rank contributes; use Scatter, AllGather, AllReduce, or point-to-point as semantics require. | Choose by data meaning. | Always starting distribution from rank 0. |

## 7. Deep-Dive Questions

1. **How does a large-message broadcast differ from a tiny one?**  Tiny messages are latency dominated and favor shallow schedules; large messages benefit from chunking/pipelining and bandwidth-balanced routes.
2. **How would you broadcast across multi-GPU nodes?**  Use a hierarchical schedule: one or more inter-node representatives exchange data, then local NVLink/NVSwitch distribution, or vice versa as topology dictates.
3. **Can the root compute the buffer immediately before Broadcast?**  Yes, if the Broadcast stream waits for the producing kernel via same-stream order or an event; otherwise there is a race.
4. **Why might a full model Broadcast waste memory?**  Model/tensor parallel systems intentionally shard parameters; replication can exceed HBM and nullify the partitioning design.
5. **How do you select the root?**  Semantics usually determine the owner; for performance, consider data location, topology, NIC affinity, and whether root responsibility rotates across repeated operations.

## 8. Comparison Tables

| Broadcast | Scatter |
|---|---|
| Same root buffer goes to every rank | Different root-owned chunk goes to each rank |
| Each output size equals full message | Each output is one partition |
| Replication | Distribution/sharding |
| Example: common configuration | Example: divide input dataset |

| Broadcast | AllReduce |
|---|---|
| Only root contributes authoritative values | Every rank contributes values |
| No reduction | Element-wise reduction |
| Copies existing buffer | Computes global result then distributes it |
| Example: initial parameters | Example: global gradients |

## 9. Common Mistakes

- Calling Broadcast only on the root rank.
- Confusing communicator rank with local GPU number.
- Claiming Broadcast combines values.
- Using a star of blocking point-to-point sends and calling it optimal Broadcast.
- Reusing root storage before stream completion.
- Broadcasting full tensors that should remain sharded.
- Letting ranks disagree about root/count/type.
- Assuming tree depth alone predicts large-message throughput.

## 10. Edge Cases / Special Cases

- With one rank, Broadcast is effectively local according to buffer/API semantics.
- Zero-count Broadcast still must preserve the collective sequence.
- The root may differ between repeated calls; all ranks must agree on each call.
- In-place behavior at root differs from non-root source-buffer relevance.
- A root process failure generally prevents the collective from completing unless a fault-tolerant higher layer rebuilds the group.
- Broadcasting variable-length data usually requires broadcasting length first, allocating/validating storage, then broadcasting payload.
- Security-sensitive distributed applications must validate sizes and metadata before allocating based on a root-provided length.

## 11. How to Explain in Interview

> Broadcast distributes one root rank's buffer unchanged to every rank. All ranks participate, and the root is a communicator rank rather than necessarily GPU 0. Optimized implementations use trees and chunked pipelines instead of sequential root sends. It differs from AllGather because only one rank contributes, and from Scatter because every rank receives the same full data.

## 12. Quick Revision Notes

- One source, all destinations, no reduction.
- Every rank calls the collective.
- Root is communicator rank.
- Tree reduces propagation depth; chunks improve large-message bandwidth.
- Broadcast vs Scatter: same full buffer vs different chunks.
- Broadcast vs AllGather: one contribution vs all contributions.
- Trap: API return is not necessarily completion.

## 13. Practice Tasks

1. Draw sequential-star and binary-tree Broadcast schedules for eight ranks.
2. Broadcast a length then a payload in pseudocode with allocation validation.
3. Design stream/event ordering for root kernel -> Broadcast -> peer kernel.
4. Explain a hierarchical Broadcast across two four-GPU nodes.
5. Compare full-model Broadcast with shard-aware loading for a model larger than one GPU's HBM.
6. Simulate a root mismatch and explain why ranks wait on incompatible communication.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Copy one root buffer unchanged to every rank. |
| Why it matters | Efficient replication of common data without manual one-to-many sends. |
| Most asked | Root meaning, all-rank participation, tree algorithm, Broadcast vs Scatter/AllGather. |
| Main trap | Only root owns source data, but every rank must enter the call. |
| One-line answer | “Broadcast replicates one rank's data everywhere; trees and pipelines prevent a naive root bottleneck.” |

---

# GPU-to-GPU Communication

## 1. Overview

**GPU-to-GPU communication** is the movement, sharing, synchronization, or collective transformation of data among GPUs. It can occur:

- inside one GPU at warp/block scope (not the focus here),
- between GPUs in one process,
- between processes controlling GPUs in one node,
- or between GPUs on different nodes.

The payload can travel through CUDA peer-to-peer copies or remote memory access over PCIe/NVLink, through an NVSwitch fabric, via shared/interprocess memory mechanisms, or through a NIC using GPUDirect RDMA or staged host memory. Higher-level libraries such as NCCL, CUDA-aware MPI, and NVSHMEM choose/expose different communication models.

It matters because multi-GPU speedup is limited by data dependencies, transfer volume, topology, synchronization, and load balance. It is used in distributed ML, graph analytics, multi-GPU databases, rendering, molecular dynamics, weather simulation, and any domain decomposition larger than one GPU. Interviewers ask it as the synthesis topic: how hardware, memory, APIs, collectives, topology, correctness, and performance fit together.

## 2. Core Idea

Treat each GPU as a computer with very fast local memory and expensive access to remote state. Good designs partition the problem so most operations use local HBM and communicate only the information that crosses a partition boundary.

Analogy: several workshops collaborate on one product. Keeping frequently used tools in each workshop is fast. Borrowing a tool across the city for every step is slow. Instead, assign coherent subassemblies, batch shipments, and overlap shipping with independent work.

Small two-GPU stencil example:

```text
Global grid rows 0..999

GPU 0 owns rows   0..499
GPU 1 owns rows 500..999

Each iteration:
GPU 0 computes interior 1..498
GPU 1 computes interior 501..998
GPUs exchange boundary/halo rows 499 and 500
Each computes the boundary-dependent rows
```

Step by step:

1. Partition data and assign ownership.
2. Discover topology and enable/select a supported path.
3. Compute regions that do not depend on incoming remote data.
4. Enqueue peer or collective communication in streams.
5. Use events/library dependencies so consumers wait for arrival.
6. Compute boundary-dependent work.
7. Reuse communication buffers only after completion.
8. Measure exposed communication, not only raw copy bandwidth.

## 3. Important Subtopics

| Subtopic | Meaning and why it matters | Example | Common interview angle |
|---|---|---|---|
| Data partitioning | Assign each GPU ownership that maximizes local reuse and balances work. | Split matrix rows or model tensor dimensions. | Communication volume is an algorithmic choice. |
| Explicit peer copies | Bulk transfer between device allocations. | `cudaMemcpyPeerAsync` for a halo row. | Prefer bulk copies for dense reuse; synchronize streams correctly. |
| Peer memory access | Kernel on one GPU loads/stores supported peer memory. | Sparse lookup on another GPU. | Remote access is slower and is not automatically coherent. |
| Collectives | Group-wide patterns express common exchanges. | AllReduce gradients, AllGather shards. | Choose collective by semantics, not familiarity. |
| Point-to-point | One sender/receiver pair exchanges targeted data. | Pipeline stage activation. | Pairwise protocols can deadlock if order is inconsistent. |
| Intra-process multi-GPU | One process/threads manages multiple CUDA devices and contexts. | One host thread loops over GPUs. | Current device and pointer ownership matter. |
| Interprocess communication | Separate local processes share/export GPU allocations or use communication libraries. | One process per GPU. | Handle lifetime/security and process failure. |
| Inter-node path | NIC/network carries data, ideally directly from/to GPU memory. | GPUDirect RDMA over InfiniBand. | NIC affinity and network topology matter. |
| Synchronization/ordering | Defines when writes are visible and buffers safe. | CUDA event before a consumer kernel. | Connectivity does not prevent races. |
| Topology awareness | Map communicating ranks to strong paths. | Tensor-parallel group within an NVSwitch domain. | Logical rank order is not physical proximity. |
| Granularity | Batch data enough to amortize latency but not so much that overlap starts late. | Gradient buckets or fused small tensors. | Latency/bandwidth crossover. |
| Contention | Communication competes for links, NICs, copy engines, and memory bandwidth. | P2P copy slows a memory-bound kernel. | Copy engines do not create independent HBM bandwidth. |
| Progress/failures | Libraries must advance operations and handle a missing rank/link/process. | NCCL asynchronous communicator error. | Blocking forever is not recovery. |

## 4. Real-World Example

Consider an LLM trained on 16 GPUs: two servers, eight GPUs each.

- **Tensor parallelism** divides matrix dimensions among GPUs inside each server. Frequent AllReduce/AllGather uses the local NVLink/NVSwitch fabric.
- **Pipeline parallelism** places layer groups on different stages. Neighbor stages send activations/gradients point to point.
- **Data parallelism** replicates the model pipeline across groups. Gradient or shard synchronization crosses nodes through NICs and RDMA.
- **NCCL** creates distinct communicators for these groups and schedules operations over local and inter-node paths.

```text
Node 0: [G0 G1 G2 G3] tensor group A -- pipeline --> [G4 G5 G6 G7] tensor group B
             | data-parallel collective                       |
          RDMA/NIC ========================================= RDMA/NIC
             |                                                |
Node 1: [G8 G9 G10 G11]             -->          [G12 G13 G14 G15]
```

The design keeps the most frequent, high-volume tensor-parallel traffic on fast local links and uses the slower network tier deliberately. Communication is overlapped with independent compute, but pipeline bubbles and collective tails remain visible.

## 5. Diagrams / Mental Models

### Path-selection ladder

```text
Same GPU?        -> local registers/shared memory/HBM
Same node P2P?   -> NVLink/NVSwitch or supported PCIe P2P
Same node no P2P?-> staged through host/shared memory path
Different node?  -> GPUDirect RDMA when supported; otherwise host-staged network
Group pattern?   -> use a collective library rather than manual pairwise copies
```

### Communication cost model

```text
T_comm ~= number_of_steps * latency
         + bytes_on_critical_path / effective_bandwidth
         + contention
         + synchronization/queueing
         + packing/unpacking
```

### Dependency-safe overlap

```text
GPU 0 compute interior ---- record ready0 ---- send halo0 ---------
GPU 1 compute interior ---- record ready1 ---- send halo1 ---------
GPU 0 receive halo1 ---- record arrived1 ---- boundary kernel ----
GPU 1 receive halo0 ---- record arrived0 ---- boundary kernel ----
```

## 6. Common Interview Questions

| # | Question and clear answer | Key points expected | Common mistake |
|---:|---|---|---|
| 1 | **How can two GPUs communicate?** Through peer copies/remote access over local interconnects, collectives or point-to-point libraries, local IPC, or NIC/network paths across nodes. | Multiple layers/paths. | Answering only “NVLink.” |
| 2 | **What is CUDA P2P?** Pairwise capability allowing supported GPUs to directly copy/access peer memory after required setup. | Query support, enable access, topology. | Assuming same-node always means P2P. |
| 3 | **P2P copy vs peer load/store?** A copy stages a bulk replica in local memory; remote access reads/writes peer memory on demand. | Reuse/granularity tradeoff. | Treating performance as identical. |
| 4 | **How do GPUs communicate across nodes?** Through NICs and a network using libraries such as NCCL/CUDA-aware MPI, ideally with GPUDirect RDMA to avoid host staging. | NIC, network, RDMA. | Claiming NVLink always spans arbitrary cluster nodes. |
| 5 | **What limits multi-GPU scaling?** Serial work, communication volume, latency/bandwidth, topology, contention, load imbalance, synchronization, and memory capacity. | End-to-end reasoning/Amdahl. | “Add more GPUs for linear speedup.” |
| 6 | **How do you overlap communication and compute?** Partition independent work, use streams/nonblocking collectives and events, and start communication as soon as data is ready. | Real dependency graph. | Device-wide sync between every stage. |
| 7 | **When should you use a collective?** When data semantics match a group pattern such as global reduction, replication, or shard assembly; optimized libraries handle topology better than manual sends. | Semantic choice. | Implementing AllReduce with root CPU copies. |
| 8 | **Why does topology matter?** Pair paths differ in bandwidth/hops and may share switches, CPU roots, or NICs; placement changes critical-path communication. | Rank mapping/affinity. | Using GPU ordinal as distance. |
| 9 | **How do you ensure correctness?** Establish ownership, matching calls, buffer lifetime, producer/consumer ordering, and proper scope/completion before reuse. | Memory/order protocol. | Believing a successful API return synchronizes everything. |
| 10 | **How do you debug slow GPU communication?** Separate correctness from performance; inspect topology/path, benchmark relevant sizes, verify fast-path transport, profile timelines/contention, then tune batching/placement/overlap. | Evidence-driven process. | Looking only at theoretical bandwidth. |

## 7. Deep-Dive Questions

1. **When is host staging acceptable or even preferable?**  If P2P/RDMA is unsupported, messages are small/infrequent, portability matters, or a well-pipelined host path avoids a poor peer topology. Correct fallback beats a fragile fast path.
2. **How do you choose between replication and remote access?**  Estimate reuse and size. Dense repeated use favors one bulk transfer and local HBM; sparse one-pass access may favor remote reads to avoid copying unused data.
3. **How does memory consistency affect peer communication?**  Writes must be ordered and made visible at the scope required by the API/hardware; consumers must wait on the specified event/collective/network completion. A pointer alone creates no happens-before relation.
4. **Why can communication overlap reduce kernel speed?**  Both may consume HBM bandwidth, L2 capacity, copy engines, interconnect injection resources, or scheduling capacity. Overlap improves wall time only if resource contention does not outweigh hidden latency.
5. **How would you design communication for a 2D domain decomposition?**  Give each GPU a tile, exchange only four halo boundaries with neighbors, compute interiors during exchange, then boundaries; place neighboring tiles on strong links and use collectives only for truly global values.

## 8. Comparison Tables

| Peer copy | Peer remote access |
|---|---|
| Bulk transfer into destination-local memory | Kernel accesses source GPU memory on demand |
| Up-front transfer and extra storage | No full replica required |
| Best for dense/repeated reuse | Useful for sparse or one-pass access |
| Easy local compute after completion | Every access pays remote-path cost |

| Point-to-point | Collective |
|---|---|
| Specific source/destination pair | Entire communicator group participates |
| Flexible irregular graphs | Standard group semantics and optimized schedules |
| Application manages matching/order details | Library manages topology-aware group algorithm |
| Example: pipeline activation | Example: AllReduce gradients |

| Intra-node communication | Inter-node communication |
|---|---|
| NVLink/NVSwitch/PCIe and local IPC/P2P | NIC + network, RDMA or socket/staged paths |
| Typically lower latency and higher accelerator-local bandwidth | Usually more expensive and topology/congestion sensitive |
| GPU-pair topology is central | GPU–NIC, switch, rail, and cluster topology are central |
| Local fabric health/configuration | Network routing, congestion, MTU, and failures also matter |

| Data parallelism | Tensor parallelism | Pipeline parallelism |
|---|---|---|
| Replicate model, split examples | Split tensor/operator dimensions | Split layers/stages |
| Gradients commonly AllReduce/ReduceScatter | Frequent AllReduce/AllGather/All-to-All | Neighbor activation/gradient sends |
| Communication often once per gradient bucket | Communication can occur every layer | Bubble scheduling and stage balance dominate |

## 9. Common Mistakes

- Optimizing a kernel while ignoring that communication dominates iteration time.
- Assuming every GPU can directly access every other GPU.
- Treating unified virtual addressing as automatic peer connectivity/coherence.
- Choosing AllReduce when only one result shard is needed.
- Issuing thousands of tiny transfers with no fusion.
- Using a device-wide synchronization where one event dependency is sufficient.
- Claiming overlap without checking the profiler timeline and resource contention.
- Mapping ranks by ordinal rather than topology and NIC affinity.
- Reusing/freing buffers after enqueue rather than after completion.
- Ignoring failure of one rank in a collective group.

## 10. Edge Cases / Special Cases

- Peer access limits, MIG partitions, virtualization, OS, and IOMMU/ACS settings may change pairwise reachability.
- GPUs can have asymmetric logical capability queries or routes; check the ordered pair and actual operation.
- Zero-byte operations still affect collective call ordering.
- Unified Memory can migrate or replicate pages unpredictably for an unsuitable multi-GPU access pattern; explicit placement/prefetch may be needed.
- GPU atomics to peer/system memory require supported scopes and semantics; ordinary local atomics do not automatically provide system-wide synchronization.
- Process crashes, link errors, or network partitions require communicator abort/recovery above basic data transfer.
- Oversubscribed PCIe switches and NIC rails can make individually fast pair tests misleading under all-GPU load.
- Variable-length sparse exchanges may fit All-to-All or grouped point-to-point better than padding an AllGather.
- Strong scaling eventually shrinks compute per GPU until fixed communication latency dominates.

## 11. How to Explain in Interview

> GPU-to-GPU communication moves or combines data among separate GPU memories. Inside a node it may use CUDA P2P over NVLink, NVSwitch, or PCIe; across nodes it uses NICs, often GPUDirect RDMA, through libraries such as NCCL. The design goal is to maximize local reuse, minimize communicated bytes, select the collective that matches the data semantics, map ranks to the physical topology, and overlap only genuinely independent communication and computation with correct stream/event ordering.

## 12. Quick Revision Notes

- Start with partitioning and ownership; communication volume follows the algorithm.
- Local HBM is fastest; remote memory is not free local memory.
- Same-node paths: NVLink/NVSwitch/PCIe P2P or fallback staging.
- Cross-node path: GPU <-> NIC <-> network <-> NIC <-> GPU.
- Collectives express group semantics; P2P handles targeted exchanges.
- Cost = latency steps + bytes/bandwidth + contention + synchronization + packing.
- Correctness = matching calls + buffer lifetime + producer/consumer ordering.
- Scaling trap: faster links do not fix poor partitioning or stragglers.

## 13. Practice Tasks

1. Implement a two-GPU peer-copy check using `cudaDeviceCanAccessPeer`, peer enabling, `cudaMemcpyPeerAsync`, and events.
2. Write a two-GPU 1D stencil that overlaps interior compute with halo exchange.
3. Given a topology matrix, place tensor-, pipeline-, and data-parallel groups for eight GPUs.
4. Benchmark copy sizes from 1 byte to 1 GiB and identify latency- and bandwidth-dominated regimes.
5. Compare remote peer reads with copy-then-reuse for different reuse counts.
6. Draw a safe producer-kernel -> send -> receive -> consumer-kernel dependency graph.
7. Use collective benchmarks to compare intra-node and inter-node paths.
8. Diagnose a hypothetical NCCL fallback from RDMA to sockets using logs and topology evidence.
9. Calculate strong-scaling efficiency when compute halves but communication stays constant.
10. Choose the correct operation—Broadcast, AllGather, ReduceScatter, or AllReduce—for ten sample data-flow descriptions.

## 14. Final Cheat Sheet

| Item | Remember |
|---|---|
| Core definition | Data movement, access, synchronization, and collective transformation among separate GPUs. |
| Why it matters | Communication and synchronization usually determine multi-GPU scaling. |
| Most asked | P2P paths, local vs remote access, topology, overlap, collectives, GPUDirect RDMA, correctness. |
| Common comparisons | Peer copy vs remote access; point-to-point vs collective; intra-node vs inter-node. |
| Main traps | UVA is not P2P; async return is not completion; theoretical bandwidth is not application speed. |
| One-line answer | “Keep work local, communicate the minimum on the best topology-aware path, and enforce exact producer/consumer ordering.” |

---

## Cross-Topic Interview Map

| If the interviewer asks… | Lead with… | Then mention… |
|---|---|---|
| “How are two local GPUs connected?” | PCIe or NVLink, possibly through NVSwitch | Pairwise P2P support, topology, CUDA APIs |
| “How do GPUs communicate across servers?” | NIC/network and GPUDirect RDMA | Registration, GPU–NIC affinity, NCCL/MPI |
| “How are gradients synchronized?” | AllReduce | Ring = ReduceScatter + AllGather, bucketing, overlap |
| “How do sharded parameters work?” | AllGather before use, ReduceScatter for gradients | Temporary memory, prefetch distance, ownership |
| “How do all ranks get one value?” | Broadcast if one source; AllReduce if all contribute | Root semantics or reduction operator |
| “Why did scaling stop?” | Exposed communication, latency, topology, stragglers | Profile timeline; verify fast path; reduce bytes |

## Minimal Collective Decision Table

| Data meaning | Correct operation |
|---|---|
| One rank owns a buffer; all ranks need the same buffer | Broadcast |
| Every rank owns a shard; all ranks need all shards | AllGather |
| Every rank owns contributions; all ranks need the full combined result | AllReduce |
| Every rank owns contributions; each rank needs only its combined shard | ReduceScatter |
| One rank sends different shards to different ranks | Scatter |
| Every rank sends a different shard to every other rank | All-to-All |

## Primary References for Further Study

- [CUDA Programming Guide: Programming Systems with Multiple GPUs](https://docs.nvidia.com/cuda/cuda-programming-guide/03-advanced/multi-gpu-systems.html)
- [NVIDIA GPUDirect RDMA Documentation](https://docs.nvidia.com/cuda/gpudirect-rdma/)
- [NCCL User Guide](https://docs.nvidia.com/deeplearning/nccl/user-guide/index.html)
- [NCCL Collective Operations](https://docs.nvidia.com/deeplearning/nccl/user-guide/docs/usage/collectives.html)
- [NVIDIA DCGM: Topology and NVLink](https://docs.nvidia.com/datacenter/dcgm/latest/learn/core-services/topology-and-links.html)
