# Network Layer, IP Addressing, Subnetting, Routing, NAT, ICMP, ARP, DHCP

Placement-focused notes for Computer Networks.

## 1. Network Layer Big Picture

The network layer is responsible for moving packets from a source host to a destination host across multiple networks. It provides logical addressing, routing, forwarding, fragmentation support, and error reporting support.

### Main Responsibilities

| Responsibility | Meaning |
|---|---|
| Logical addressing | Assigns IP addresses to hosts and routers |
| Routing | Chooses the best path from source network to destination network |
| Forwarding | Moves a packet from router input interface to correct output interface |
| Packetization | Encapsulates transport layer segments into IP packets |
| Fragmentation | Splits large packets if they exceed MTU, mainly IPv4 |
| Error reporting | Uses ICMP to report network-level issues |
| Internetworking | Connects different physical/link layer networks |

### Important Network Layer Protocols

| Protocol | Purpose |
|---|---|
| IPv4 | 32-bit logical addressing and packet delivery |
| IPv6 | 128-bit logical addressing and packet delivery |
| ICMP | Error reporting and diagnostics |
| ARP | Maps IPv4 address to MAC address in LAN |
| NDP | IPv6 replacement for ARP, router discovery, address resolution |
| DHCP | Dynamically assigns IP configuration |
| OSPF | Link-state interior routing protocol |
| RIP | Distance-vector interior routing protocol |
| BGP | Path-vector exterior routing protocol used on the Internet |
| NAT | Translates private IP addresses to public IP addresses |

### Forwarding vs Routing

| Term | Meaning | Scope |
|---|---|---|
| Forwarding | Sending a packet to the next hop using the forwarding table | Per packet |
| Routing | Computing paths and building routing tables | Network-wide logic |

Interview answer:

> Routing decides the path. Forwarding uses that decision to move each packet to the next hop.

### Packet Switching

The Internet uses packet switching. Data is divided into packets, and each packet is routed independently.

Advantages:

- Efficient sharing of links.
- Robust against failures.
- Supports bursty traffic.
- No dedicated circuit is required.

Disadvantages:

- Variable delay.
- Packet loss can happen.
- Packets may arrive out of order.
- Congestion must be handled.

## 2. IPv4 Addressing

IPv4 uses 32-bit addresses, usually written in dotted decimal notation.

Example:

```text
192.168.1.10
```

Each decimal part is 8 bits, called an octet.

```text
192      168      1        10
11000000 10101000 00000001 00001010
```

### IPv4 Address Structure

An IPv4 address has two logical parts:

```text
Network ID + Host ID
```

The subnet mask or CIDR prefix tells how many bits belong to the network part.

Example:

```text
192.168.1.10/24
```

Here `/24` means:

- First 24 bits are network bits.
- Last 8 bits are host bits.
- Network address is `192.168.1.0`.
- Broadcast address is `192.168.1.255`.
- Usable host range is `192.168.1.1` to `192.168.1.254`.

### IPv4 Address Classes

Classful addressing is mostly obsolete, but it is common in exams and interviews.

| Class | First Octet Range | Default Mask | Prefix | Use |
|---|---:|---|---:|---|
| A | 1-126 | 255.0.0.0 | /8 | Very large networks |
| B | 128-191 | 255.255.0.0 | /16 | Medium networks |
| C | 192-223 | 255.255.255.0 | /24 | Small networks |
| D | 224-239 | N/A | N/A | Multicast |
| E | 240-255 | N/A | N/A | Experimental |

Special note:

- `127.0.0.0/8` is reserved for loopback.
- `0.0.0.0` means unspecified address or default route depending on context.
- `255.255.255.255` is limited broadcast.

### Public and Private IPv4 Addresses

Private IPv4 ranges are not routed on the public Internet.

| Range | CIDR | Common Use |
|---|---|---|
| 10.0.0.0 - 10.255.255.255 | 10.0.0.0/8 | Large private networks |
| 172.16.0.0 - 172.31.255.255 | 172.16.0.0/12 | Medium private networks |
| 192.168.0.0 - 192.168.255.255 | 192.168.0.0/16 | Home/small office networks |

### Other Special IPv4 Addresses

| Address/Range | Meaning |
|---|---|
| 127.0.0.1 | Loopback localhost |
| 0.0.0.0 | Unknown/unspecified address |
| 169.254.0.0/16 | Link-local/APIPA address |
| 224.0.0.0/4 | Multicast |
| 255.255.255.255 | Limited broadcast |
| Network address | First address in a subnet, identifies the subnet |
| Broadcast address | Last address in a subnet, sends to all hosts in subnet |

### IPv4 Header

Minimum IPv4 header size is 20 bytes. Maximum is 60 bytes because the IHL field is 4 bits.

| Field | Size | Purpose |
|---|---:|---|
| Version | 4 bits | IPv4 = 4 |
| IHL | 4 bits | Header length |
| DSCP/ECN | 8 bits | QoS and congestion notification |
| Total Length | 16 bits | Entire packet length, max 65,535 bytes |
| Identification | 16 bits | Identifies fragments of same packet |
| Flags | 3 bits | Fragmentation control |
| Fragment Offset | 13 bits | Position of fragment |
| TTL | 8 bits | Prevents infinite looping |
| Protocol | 8 bits | Next layer protocol, TCP=6, UDP=17, ICMP=1 |
| Header Checksum | 16 bits | Checks IPv4 header only |
| Source IP | 32 bits | Sender IP address |
| Destination IP | 32 bits | Receiver IP address |
| Options | Variable | Rarely used |

### TTL

TTL stands for Time To Live. Every router decreases TTL by 1. If TTL becomes 0, the router drops the packet and usually sends ICMP Time Exceeded.

Purpose:

- Prevent packets from looping forever.
- Helps tools like `traceroute` discover paths.

Interview answer:

> TTL is a hop limit in IPv4. It is decremented at every router, and the packet is discarded when it reaches zero.

### IPv4 Fragmentation

Fragmentation happens when an IPv4 packet is larger than the MTU of the outgoing link.

Important points:

- MTU means Maximum Transmission Unit.
- Ethernet MTU is commonly 1500 bytes.
- IPv4 routers can fragment packets unless the Don't Fragment flag is set.
- Reassembly happens only at the final destination, not at intermediate routers.
- Fragmentation is expensive and should be avoided.

IPv4 fragmentation fields:

| Field | Use |
|---|---|
| Identification | Same for all fragments of original packet |
| DF flag | Don't Fragment |
| MF flag | More Fragments |
| Fragment Offset | Fragment position in units of 8 bytes |

Example:

If a 4000-byte IP packet must cross a link with MTU 1500, it may be split into multiple fragments.

### Path MTU Discovery

Path MTU Discovery tries to find the smallest MTU along a path.

How it works in IPv4:

1. Sender sends packets with DF flag set.
2. If a router cannot forward because packet is too large, it drops it.
3. Router sends ICMP Fragmentation Needed.
4. Sender reduces packet size.

Problem:

- If ICMP is blocked, Path MTU Discovery can fail.

## 3. IPv6 Addressing

IPv6 uses 128-bit addresses, written in hexadecimal separated by colons.

Example:

```text
2001:0db8:0000:0000:0000:ff00:0042:8329
```

### IPv6 Shortening Rules

Rule 1: Leading zeros in each group can be removed.

```text
2001:0db8:0000:0000:0000:ff00:0042:8329
2001:db8:0:0:0:ff00:42:8329
```

Rule 2: One continuous sequence of zero groups can be replaced by `::`.

```text
2001:db8:0:0:0:ff00:42:8329
2001:db8::ff00:42:8329
```

Important:

- `::` can be used only once in an IPv6 address.
- Otherwise the address becomes ambiguous.

### IPv6 Address Types

| Type | Prefix/Example | Meaning |
|---|---|---|
| Global unicast | 2000::/3 | Public Internet address |
| Link-local | fe80::/10 | Used on local link only |
| Unique local | fc00::/7 | Private IPv6-like range |
| Multicast | ff00::/8 | One-to-many communication |
| Loopback | ::1 | Localhost |
| Unspecified | :: | No address |
| Solicited-node multicast | ff02::1:ff00:0/104 | Used by NDP |

IPv6 does not use broadcast. It uses multicast and anycast instead.

### IPv6 Header

IPv6 fixed header size is 40 bytes.

| Field | Size | Purpose |
|---|---:|---|
| Version | 4 bits | IPv6 = 6 |
| Traffic Class | 8 bits | QoS |
| Flow Label | 20 bits | Identifies packet flow |
| Payload Length | 16 bits | Payload size |
| Next Header | 8 bits | Next protocol or extension header |
| Hop Limit | 8 bits | Like IPv4 TTL |
| Source Address | 128 bits | Sender IPv6 address |
| Destination Address | 128 bits | Receiver IPv6 address |

### IPv4 vs IPv6

| Feature | IPv4 | IPv6 |
|---|---|---|
| Address size | 32 bits | 128 bits |
| Notation | Dotted decimal | Hexadecimal colon notation |
| Header size | Variable, 20-60 bytes | Fixed 40 bytes |
| Header checksum | Present | Removed |
| Fragmentation | Routers and hosts | Hosts only |
| Broadcast | Supported | Not supported |
| Address resolution | ARP | NDP |
| Security | IPsec optional | IPsec support built into design |
| NAT | Common | Not required by address scarcity |
| Configuration | Manual/DHCP | SLAAC/DHCPv6/manual |

### Why IPv6 Was Introduced

- IPv4 address exhaustion.
- Larger address space.
- Better support for auto-configuration.
- Simplified fixed header.
- Better multicast support.
- No need for NAT in ideal design.

### IPv6 Fragmentation

In IPv6:

- Routers do not fragment packets.
- Sender must perform fragmentation.
- Path MTU Discovery is important.
- Fragmentation uses an extension header.

## 4. Subnetting

Subnetting divides a large network into smaller logical networks.

Reasons for subnetting:

- Efficient IP address use.
- Smaller broadcast domains.
- Better security and isolation.
- Easier network management.
- Supports hierarchical routing.

### Subnet Mask

A subnet mask marks network bits with 1s and host bits with 0s.

Example:

```text
255.255.255.0
11111111.11111111.11111111.00000000
```

This is `/24`.

### CIDR Prefix

CIDR stands for Classless Inter-Domain Routing.

CIDR notation:

```text
IP address / prefix length
```

Example:

```text
192.168.10.5/26
```

Here:

- 26 bits are network bits.
- 6 bits are host bits.

### Hosts Per Subnet Formula

```text
Number of addresses = 2^(host bits)
Usable hosts = 2^(host bits) - 2
```

Why minus 2?

- One address is network address.
- One address is broadcast address.

Exception:

- `/31` is used for point-to-point links.
- `/32` means a single host route.

### Subnets Formula

If you borrow `n` bits from host portion:

```text
Number of subnets = 2^n
```

### Common CIDR Table

| CIDR | Mask | Addresses | Usable Hosts | Block Size |
|---:|---|---:|---:|---:|
| /8 | 255.0.0.0 | 16,777,216 | 16,777,214 | 16,777,216 |
| /16 | 255.255.0.0 | 65,536 | 65,534 | 65,536 |
| /24 | 255.255.255.0 | 256 | 254 | 256 |
| /25 | 255.255.255.128 | 128 | 126 | 128 |
| /26 | 255.255.255.192 | 64 | 62 | 64 |
| /27 | 255.255.255.224 | 32 | 30 | 32 |
| /28 | 255.255.255.240 | 16 | 14 | 16 |
| /29 | 255.255.255.248 | 8 | 6 | 8 |
| /30 | 255.255.255.252 | 4 | 2 | 4 |
| /31 | 255.255.255.254 | 2 | 2 for P2P | 2 |
| /32 | 255.255.255.255 | 1 | 1 host route | 1 |

### Powers of 2 for Subnetting

| Bits | Value |
|---:|---:|
| 1 | 2 |
| 2 | 4 |
| 3 | 8 |
| 4 | 16 |
| 5 | 32 |
| 6 | 64 |
| 7 | 128 |
| 8 | 256 |
| 9 | 512 |
| 10 | 1024 |
| 11 | 2048 |
| 12 | 4096 |
| 13 | 8192 |
| 14 | 16384 |
| 15 | 32768 |
| 16 | 65536 |

### Quick Subnetting Method

Given:

```text
192.168.1.70/26
```

Step 1: Find mask.

```text
/26 = 255.255.255.192
```

Step 2: Find block size.

```text
256 - 192 = 64
```

Step 3: Subnet ranges in last octet:

```text
0-63
64-127
128-191
192-255
```

Step 4: 70 lies in `64-127`.

Answer:

```text
Network address:   192.168.1.64
First usable:      192.168.1.65
Last usable:       192.168.1.126
Broadcast address: 192.168.1.127
Usable hosts:      62
```

### Another Example

Question:

```text
Find subnet details for 10.20.30.140/28
```

Solution:

```text
/28 mask = 255.255.255.240
Block size = 256 - 240 = 16
Subnets in last octet: 0,16,32,48,64,80,96,112,128,144...
140 lies in 128-143
```

Answer:

```text
Network address:   10.20.30.128
First usable:      10.20.30.129
Last usable:       10.20.30.142
Broadcast address: 10.20.30.143
Usable hosts:      14
```

### Finding CIDR From Required Hosts

Question:

```text
Need at least 50 hosts. What prefix is required?
```

Formula:

```text
2^h - 2 >= 50
```

Try:

```text
2^5 - 2 = 30, not enough
2^6 - 2 = 62, enough
```

So host bits = 6.

```text
Prefix = 32 - 6 = /26
```

Answer: `/26`.

### VLSM

VLSM stands for Variable Length Subnet Mask.

It allows different subnets to have different sizes.

Example:

- Department A needs 100 hosts: use `/25`.
- Department B needs 50 hosts: use `/26`.
- Department C needs 20 hosts: use `/27`.
- Point-to-point link needs 2 hosts: use `/30`.

VLSM reduces address wastage.

### Supernetting

Supernetting combines multiple smaller networks into a larger route.

Example:

```text
192.168.0.0/24
192.168.1.0/24
192.168.2.0/24
192.168.3.0/24
```

Can be summarized as:

```text
192.168.0.0/22
```

This is route aggregation.

## 5. CIDR

CIDR means Classless Inter-Domain Routing.

Before CIDR, classful addressing wasted many IP addresses. CIDR allows arbitrary prefix lengths instead of fixed Class A/B/C boundaries.

### Benefits of CIDR

- More efficient IP allocation.
- Supports route aggregation.
- Reduces size of global routing tables.
- Removes dependence on address classes.

### CIDR Example

```text
172.16.5.10/20
```

`/20` means:

- Network bits = 20.
- Host bits = 12.
- Addresses = `2^12 = 4096`.
- Usable hosts = `4094`.
- Mask = `255.255.240.0`.

Block size in third octet:

```text
256 - 240 = 16
```

Third octet ranges:

```text
0-15, 16-31, 32-47, ...
```

`5` lies in `0-15`.

Answer:

```text
Network:   172.16.0.0
Broadcast: 172.16.15.255
Range:     172.16.0.1 - 172.16.15.254
```

### Longest Prefix Match

Routers use longest prefix match to choose the most specific route.

Example routing table:

| Route | Next Hop |
|---|---|
| 10.0.0.0/8 | R1 |
| 10.1.0.0/16 | R2 |
| 10.1.2.0/24 | R3 |
| 0.0.0.0/0 | Default |

Destination:

```text
10.1.2.55
```

Matching routes:

- `10.0.0.0/8`
- `10.1.0.0/16`
- `10.1.2.0/24`

Chosen route:

```text
10.1.2.0/24 via R3
```

Because `/24` is the longest and most specific prefix.

## 6. Routing

Routing is the process of finding a path from source to destination.

### Router

A router connects different networks and forwards packets based on destination IP address.

Router tasks:

- Maintains routing table.
- Determines next hop.
- Decrements TTL/Hop Limit.
- May fragment IPv4 packets.
- Sends ICMP errors when needed.
- Separates broadcast domains.

### Routing Table

A routing table contains routes.

Typical fields:

| Field | Meaning |
|---|---|
| Destination network | Target network prefix |
| Subnet mask/prefix | Network size |
| Next hop | Router to send packet to |
| Outgoing interface | Interface used to forward |
| Metric | Cost of route |
| Administrative distance | Trustworthiness of route source |

Example:

```text
Destination     Gateway       Interface
192.168.1.0/24  directly      eth0
10.0.0.0/8      192.168.1.1   eth0
0.0.0.0/0       192.168.1.254 eth0
```

### Default Route

Default route is used when no more specific route matches.

IPv4 default route:

```text
0.0.0.0/0
```

IPv6 default route:

```text
::/0
```

Interview answer:

> A default route is the fallback route used when the routing table has no specific match for the destination.

### Static Routing

Static routes are manually configured by an administrator.

Advantages:

- Simple for small networks.
- No routing protocol overhead.
- More predictable.
- Useful for default routes and stub networks.

Disadvantages:

- Does not adapt automatically to failures.
- Hard to manage in large networks.
- Manual configuration errors are common.

### Dynamic Routing

Dynamic routing uses routing protocols to exchange route information.

Advantages:

- Automatically adapts to topology changes.
- Scales better than static routing.
- Reduces manual work.

Disadvantages:

- Consumes CPU, memory, and bandwidth.
- More complex.
- Can suffer from convergence issues.

### Routing Metrics

A metric is a value used to choose the best path.

Common metrics:

- Hop count.
- Bandwidth.
- Delay.
- Cost.
- Reliability.
- Load.

Lower metric is usually preferred.

### Administrative Distance

Administrative distance measures how trustworthy a route source is. Lower administrative distance is preferred.

Typical Cisco values:

| Route Source | AD |
|---|---:|
| Directly connected | 0 |
| Static route | 1 |
| EIGRP summary | 5 |
| External BGP | 20 |
| EIGRP internal | 90 |
| OSPF | 110 |
| RIP | 120 |
| Internal BGP | 200 |

### Distance Vector Routing

Distance vector protocols share routing information with neighbors.

Each router knows:

- Distance to destination.
- Direction/next hop.

Example protocol:

- RIP.

Algorithm:

- Bellman-Ford.

Problems:

- Slow convergence.
- Routing loops.
- Count-to-infinity problem.

Loop prevention techniques:

- Split horizon.
- Route poisoning.
- Poison reverse.
- Hold-down timers.
- Maximum hop count.

### RIP

RIP stands for Routing Information Protocol.

Properties:

- Distance vector protocol.
- Uses hop count as metric.
- Maximum hop count is 15.
- Hop count 16 means unreachable.
- Uses UDP port 520.
- Periodically shares full routing table.

RIP is simple but not suitable for large networks.

### Link State Routing

Link-state routers build a complete map of the network topology.

Steps:

1. Discover neighbors.
2. Measure link costs.
3. Flood link-state advertisements.
4. Build topology database.
5. Run shortest path algorithm.
6. Install best routes.

Algorithm:

- Dijkstra's shortest path first.

Example protocol:

- OSPF.

### OSPF

OSPF stands for Open Shortest Path First.

Properties:

- Link-state protocol.
- Uses cost as metric.
- Runs Dijkstra SPF algorithm.
- Supports areas.
- Fast convergence.
- Uses IP protocol number 89.
- Supports authentication.

OSPF areas:

- Backbone area is Area 0.
- Other areas must connect to Area 0.

OSPF router types:

| Router Type | Meaning |
|---|---|
| Internal router | All interfaces in same area |
| Backbone router | Has interface in Area 0 |
| Area Border Router | Connects two or more OSPF areas |
| Autonomous System Boundary Router | Connects OSPF to external routing domain |

### Path Vector Routing

Path-vector protocols advertise the full path information.

Example:

- BGP.

BGP uses AS path to avoid loops and apply policies.

### BGP

BGP stands for Border Gateway Protocol.

Properties:

- Used between autonomous systems on the Internet.
- Path-vector protocol.
- Uses TCP port 179.
- Policy-based routing.
- Very scalable.
- Slower convergence than IGPs.

BGP path selection may consider:

- Weight.
- Local preference.
- AS path length.
- Origin type.
- MED.
- eBGP over iBGP.
- IGP metric to next hop.

Interview answer:

> OSPF is commonly used inside an organization, while BGP is used between autonomous systems on the Internet.

### Interior vs Exterior Gateway Protocols

| Type | Meaning | Examples |
|---|---|---|
| IGP | Routing within one autonomous system | RIP, OSPF, EIGRP, IS-IS |
| EGP | Routing between autonomous systems | BGP |

### Routing Loops

A routing loop occurs when packets keep circulating between routers instead of reaching the destination.

Causes:

- Incorrect routing tables.
- Slow convergence.
- Misconfiguration.
- Route redistribution errors.

Prevention:

- TTL/Hop Limit.
- Split horizon.
- Route poisoning.
- Link-state topology awareness.
- BGP AS path loop detection.

### Congestion at Network Layer

Congestion occurs when too many packets enter the network and routers cannot process/forward them fast enough.

Effects:

- Packet loss.
- Higher delay.
- Jitter.
- Retransmissions.
- Lower throughput.

Possible controls:

- Traffic shaping.
- Admission control.
- Queue management.
- QoS.
- ECN.

## 7. NAT

NAT stands for Network Address Translation.

It translates IP addresses, usually private IP addresses to public IP addresses.

### Why NAT Is Used

- Conserves public IPv4 addresses.
- Allows private networks to access the Internet.
- Hides internal addressing structure.
- Makes ISP/public IP changes easier for internal networks.

### Types of NAT

| Type | Meaning |
|---|---|
| Static NAT | One private IP maps to one public IP |
| Dynamic NAT | Private IP maps to one public IP from a pool |
| PAT/NAT Overload | Many private IPs share one public IP using ports |

PAT is the most common home router NAT.

### PAT Example

Internal hosts:

```text
192.168.1.10:50001
192.168.1.11:50002
```

Public IP:

```text
203.0.113.5
```

NAT table:

| Private Address | Public Mapping |
|---|---|
| 192.168.1.10:50001 | 203.0.113.5:40001 |
| 192.168.1.11:50002 | 203.0.113.5:40002 |

When replies return, NAT uses the port mapping to forward traffic to the correct internal host.

### NAT Table

A NAT device maintains a translation table.

Fields may include:

- Internal local address.
- Internal global address.
- External local address.
- External global address.
- Protocol.
- Port numbers.
- Timeout.

### NAT Advantages

- Saves IPv4 addresses.
- Provides basic hiding of internal hosts.
- Useful for home and enterprise networks.
- Allows many devices to share one public IP.

### NAT Disadvantages

- Breaks end-to-end connectivity.
- Some protocols need NAT traversal.
- Makes peer-to-peer communication harder.
- Can complicate VoIP, gaming, VPNs, and servers.
- NAT is not a true security mechanism.

### NAT vs Firewall

| NAT | Firewall |
|---|---|
| Translates addresses/ports | Allows or blocks traffic based on rules |
| Mainly solves addressing problem | Mainly solves security policy problem |
| May incidentally hide hosts | Explicitly controls access |

Interview answer:

> NAT is not the same as a firewall. NAT translates addresses, while a firewall filters traffic. Many home routers do both.

## 8. ICMP

ICMP stands for Internet Control Message Protocol.

It is used for error reporting and network diagnostics.

ICMP does not carry application data like TCP or UDP. It helps IP report problems.

### ICMP Uses

- Destination unreachable.
- Time exceeded.
- Echo request/reply used by `ping`.
- Redirect messages.
- Fragmentation needed.
- Router discovery in some cases.

### Common ICMPv4 Message Types

| Type | Message |
|---:|---|
| 0 | Echo Reply |
| 3 | Destination Unreachable |
| 5 | Redirect |
| 8 | Echo Request |
| 11 | Time Exceeded |
| 12 | Parameter Problem |

### Ping

`ping` uses ICMP Echo Request and Echo Reply.

Purpose:

- Check if host is reachable.
- Measure round-trip time.
- Detect packet loss.

But ping can fail even if host is up, because firewalls may block ICMP.

### Traceroute

Traceroute discovers routers along a path.

Basic idea:

1. Send packet with TTL = 1.
2. First router decrements TTL to 0 and returns ICMP Time Exceeded.
3. Send packet with TTL = 2.
4. Second router returns ICMP Time Exceeded.
5. Continue until destination is reached.

On Windows, `tracert` commonly uses ICMP.

On Unix/Linux, `traceroute` often uses UDP by default, though options vary.

### Destination Unreachable

Destination Unreachable is sent when a packet cannot be delivered.

Common reasons:

- Network unreachable.
- Host unreachable.
- Protocol unreachable.
- Port unreachable.
- Fragmentation needed but DF set.

### ICMP and Security

ICMP is useful, but attackers can abuse it.

Examples:

- Network scanning.
- Ping flood.
- Smurf attack.
- Information leakage.

Best practice:

- Do not blindly block all ICMP.
- Allow necessary ICMP messages, especially for Path MTU Discovery.

## 9. ARP

ARP stands for Address Resolution Protocol.

It maps an IPv4 address to a MAC address on a local network.

ARP is used only in IPv4. IPv6 uses Neighbor Discovery Protocol.

### Why ARP Is Needed

IP addresses are used at the network layer. MAC addresses are used at the data link layer.

To deliver a frame inside a LAN, the sender needs the destination MAC address.

If the sender knows destination IP but not MAC, it uses ARP.

### ARP Workflow

Example:

Host A wants to send to `192.168.1.20`.

1. Host A checks ARP cache.
2. If no entry exists, Host A broadcasts ARP Request:

```text
Who has 192.168.1.20? Tell 192.168.1.10
```

3. All devices receive the request.
4. Only `192.168.1.20` replies with ARP Reply:

```text
192.168.1.20 is at AA:BB:CC:DD:EE:FF
```

5. Host A stores mapping in ARP cache.
6. Host A sends Ethernet frame to that MAC.

### ARP Request vs ARP Reply

| ARP Request | ARP Reply |
|---|---|
| Broadcast | Unicast usually |
| Asks for MAC of an IP | Provides MAC address |
| Sent to FF:FF:FF:FF:FF:FF | Sent to requester MAC |

### Same Network vs Different Network

If destination is in same subnet:

- Sender ARPs for destination host MAC.

If destination is in different subnet:

- Sender ARPs for default gateway MAC.
- Packet destination IP remains the final remote host IP.
- Ethernet frame destination MAC becomes gateway MAC.

Very common interview trap:

> For remote traffic, the destination IP is the final host, but the destination MAC is the next hop router.

### ARP Cache

ARP cache stores IP-to-MAC mappings temporarily.

Benefits:

- Reduces ARP broadcasts.
- Speeds up communication.

Example commands:

```text
arp -a
```

### Gratuitous ARP

Gratuitous ARP is an ARP message where a host announces or checks its own IP-to-MAC mapping.

Uses:

- Detect duplicate IP addresses.
- Update ARP caches after MAC/IP changes.
- High availability failover.

### Proxy ARP

Proxy ARP occurs when a router replies to ARP requests on behalf of another host.

It can make devices believe remote hosts are on the local network.

### ARP Spoofing

ARP has no authentication. An attacker can send fake ARP replies.

Attack:

- Attacker maps their MAC address to the gateway IP.
- Victim sends traffic to attacker.
- Attacker can perform man-in-the-middle attack.

Defenses:

- Dynamic ARP Inspection.
- Static ARP entries for critical systems.
- Switch port security.
- DHCP snooping.
- Encryption such as HTTPS/SSH/VPN.

## 10. DHCP

DHCP stands for Dynamic Host Configuration Protocol.

It automatically gives network configuration to hosts.

### DHCP Provides

DHCP can provide:

- IP address.
- Subnet mask.
- Default gateway.
- DNS server.
- Lease time.
- Domain name.
- NTP server.
- Other options.

### DHCP Ports

| Protocol | Port |
|---|---:|
| DHCP server | UDP 67 |
| DHCP client | UDP 68 |

### DHCP DORA Process

DORA stands for:

```text
Discover, Offer, Request, Acknowledge
```

Steps:

1. Discover: Client broadcasts to find DHCP servers.
2. Offer: Server offers IP configuration.
3. Request: Client requests the offered address.
4. Acknowledge: Server confirms lease.

### DHCP Message Flow

```text
Client                         Server
  | ---- DHCP Discover -------> |
  | <---- DHCP Offer ---------- |
  | ---- DHCP Request --------> |
  | <---- DHCP ACK ------------ |
```

### Why DHCP Uses Broadcast Initially

When a client first joins:

- It has no IP address.
- It does not know DHCP server IP.
- It broadcasts DHCP Discover.

Initial source IP:

```text
0.0.0.0
```

Initial destination IP:

```text
255.255.255.255
```

### DHCP Lease

DHCP addresses are leased for a limited time.

The client must renew the lease before expiration.

Benefits:

- Reuses addresses efficiently.
- Handles devices joining/leaving.
- Allows centralized configuration changes.

### DHCP Relay

Routers normally do not forward broadcasts. If DHCP server is on another network, DHCP relay is used.

DHCP relay:

- Receives client broadcast.
- Forwards it as unicast to DHCP server.
- Sends server reply back to client network.

Common term:

```text
IP helper address
```

### DHCP Reservation

A DHCP reservation always gives the same IP to a specific MAC address.

Useful for:

- Printers.
- Servers.
- Network devices.
- Lab machines.

### DHCP vs Static IP

| DHCP | Static IP |
|---|---|
| Automatic configuration | Manual configuration |
| Good for clients | Good for servers/network devices |
| Less admin work | More predictable |
| Uses leases | Permanent until changed |

## 11. How Data Moves Across a Network

Scenario:

```text
Host A: 192.168.1.10/24
Gateway: 192.168.1.1
Destination: 8.8.8.8
```

Steps:

1. Host A checks if `8.8.8.8` is in same subnet.
2. It is not in `192.168.1.0/24`.
3. Host A chooses default gateway `192.168.1.1`.
4. Host A checks ARP cache for gateway MAC.
5. If missing, Host A sends ARP Request for `192.168.1.1`.
6. Gateway replies with its MAC.
7. Host A sends Ethernet frame:

```text
Source MAC:      Host A MAC
Destination MAC: Gateway MAC
Source IP:       192.168.1.10
Destination IP:  8.8.8.8
```

8. Router removes Ethernet header.
9. Router checks destination IP.
10. Router decrements TTL.
11. Router looks up route using longest prefix match.
12. Router sends packet to next hop with a new Ethernet header.
13. IP source and destination usually remain same until NAT happens.
14. Each hop changes MAC addresses, but IP addresses remain end-to-end unless NAT changes them.

Key point:

> MAC addresses change at every hop. IP addresses usually stay the same from source to destination, except when NAT is used.

## 12. Important Interview Comparisons

### IP Address vs MAC Address

| IP Address | MAC Address |
|---|---|
| Logical address | Physical/link-layer address |
| Network layer | Data link layer |
| Can change based on network | Usually fixed to NIC, though spoofable |
| Used for routing across networks | Used for delivery within local network |
| IPv4 32-bit, IPv6 128-bit | Usually 48-bit |

### Router vs Switch

| Router | Switch |
|---|---|
| Network layer device | Data link layer device |
| Uses IP address | Uses MAC address |
| Connects different networks | Connects devices in same LAN |
| Separates broadcast domains | Each VLAN is a separate broadcast domain |
| Maintains routing table | Maintains MAC address table |

### ARP vs DNS

| ARP | DNS |
|---|---|
| IP to MAC | Domain name to IP |
| Local network | Internet/application support |
| Broadcast request in IPv4 LAN | Usually queries DNS server |
| Data link support | Application layer service |

### ICMP vs TCP/UDP

| ICMP | TCP/UDP |
|---|---|
| Control/error messages | Transport layer data delivery |
| Used by ping/traceroute | Used by applications |
| No ports | Uses ports |
| Network layer support protocol | Transport layer protocols |

### NAT vs Proxy

| NAT | Proxy |
|---|---|
| Network/transport level translation | Application-level intermediary usually |
| Usually transparent to applications | Client may know/configure proxy |
| Translates IP/port | Makes request on behalf of client |
| Common in routers | Common in web filtering/caching |

### Subnetting vs Supernetting

| Subnetting | Supernetting |
|---|---|
| Divides one network into smaller networks | Combines networks into larger prefix |
| Increases prefix length | Decreases prefix length |
| Example: /24 to /26 | Example: four /24s to one /22 |
| Used inside organizations | Used for route aggregation |

## 13. Common Placement Questions and Answers

### What is the network layer?

The network layer is responsible for logical addressing, routing, and forwarding packets from source host to destination host across multiple networks. IP is the main network layer protocol.

### What is an IP address?

An IP address is a logical address assigned to a device so it can be identified and reached on an IP network.

### Why do we need subnetting?

Subnetting divides a large network into smaller networks. It improves address utilization, reduces broadcast domains, improves management, and helps apply security boundaries.

### What is CIDR?

CIDR is Classless Inter-Domain Routing. It uses prefix lengths like `/24` instead of fixed classful masks. It improves IP allocation and supports route aggregation.

### What is the difference between IPv4 and IPv6?

IPv4 uses 32-bit addresses and dotted decimal notation. IPv6 uses 128-bit addresses and hexadecimal colon notation. IPv6 has a larger address space, fixed header, no broadcast, and uses NDP instead of ARP.

### Why is IPv6 not fully replacing IPv4 yet?

Reasons include legacy systems, cost of migration, widespread NAT usage, application compatibility, operational complexity, and the need to support both protocols during transition.

### What is a default gateway?

A default gateway is the router used by a host to reach destinations outside its local subnet.

### What happens when a host wants to send data to another subnet?

The host sends the packet to its default gateway. It uses ARP to find the gateway's MAC address. The destination IP remains the remote host's IP, but the destination MAC is the gateway's MAC.

### What is ARP?

ARP maps an IPv4 address to a MAC address within a local network. It sends a broadcast ARP request and receives a usually unicast ARP reply.

### What is ICMP?

ICMP is used for network-layer error reporting and diagnostics. Ping and traceroute rely on ICMP messages.

### What is NAT?

NAT translates IP addresses, usually private IPv4 addresses to public IPv4 addresses, allowing many internal devices to share limited public IPs.

### What is DHCP?

DHCP automatically assigns IP configuration such as IP address, subnet mask, default gateway, DNS server, and lease time.

### Explain DHCP DORA.

DORA means Discover, Offer, Request, Acknowledge. The client discovers DHCP servers, receives an offer, requests an address, and gets acknowledgment from the server.

### What is longest prefix match?

Longest prefix match is the router rule that chooses the most specific matching route for a destination IP address.

### What is TTL?

TTL is a field in IPv4 that limits packet lifetime. Each router decrements it by one. If it reaches zero, the packet is dropped.

### What is the difference between routing and forwarding?

Routing computes paths and builds routing tables. Forwarding moves packets according to those tables.

### What is fragmentation?

Fragmentation splits a packet into smaller pieces when it is larger than the outgoing link MTU. IPv4 routers may fragment packets, but IPv6 routers do not.

### Why is ARP vulnerable?

ARP has no authentication. Attackers can send fake ARP replies, causing ARP spoofing or man-in-the-middle attacks.

### What is a broadcast domain?

A broadcast domain is a network area where broadcast frames are received by all devices. Routers separate broadcast domains. VLANs also create separate broadcast domains.

### Why does IPv6 not need ARP?

IPv6 uses Neighbor Discovery Protocol, which works with ICMPv6 and multicast instead of ARP broadcast.

## 14. Numericals Practice

### Problem 1

Find network address and broadcast address:

```text
IP: 192.168.5.130/25
```

Solution:

```text
/25 mask = 255.255.255.128
Block size = 128
Ranges: 0-127, 128-255
130 lies in 128-255
```

Answer:

```text
Network:   192.168.5.128
Broadcast: 192.168.5.255
Usable:    192.168.5.129 - 192.168.5.254
Hosts:     126
```

### Problem 2

How many usable hosts in `/27`?

```text
Host bits = 32 - 27 = 5
Usable hosts = 2^5 - 2 = 30
```

Answer: 30 usable hosts.

### Problem 3

What CIDR is needed for 200 usable hosts?

```text
2^7 - 2 = 126, not enough
2^8 - 2 = 254, enough
Host bits = 8
Prefix = 32 - 8 = /24
```

Answer: `/24`.

### Problem 4

Find subnet details:

```text
IP: 172.16.35.200/20
```

Solution:

```text
/20 mask = 255.255.240.0
Block size in third octet = 256 - 240 = 16
Third octet ranges: 0-15, 16-31, 32-47
35 lies in 32-47
```

Answer:

```text
Network:   172.16.32.0
Broadcast: 172.16.47.255
Usable:    172.16.32.1 - 172.16.47.254
Hosts:     4094
```

### Problem 5

Can these routes be summarized?

```text
192.168.4.0/24
192.168.5.0/24
192.168.6.0/24
192.168.7.0/24
```

Yes.

```text
192.168.4.0/22
```

Because `/22` covers:

```text
192.168.4.0 - 192.168.7.255
```

## 15. Commands Useful for Practical Knowledge

Windows:

```powershell
ipconfig
ipconfig /all
ping 8.8.8.8
tracert google.com
arp -a
route print
nslookup google.com
netstat -ano
```

Linux:

```bash
ip addr
ip route
ping 8.8.8.8
traceroute google.com
arp -n
ip neigh
ss -tulnp
dig google.com
```

Command meanings:

| Command | Purpose |
|---|---|
| `ipconfig` / `ip addr` | Show IP configuration |
| `ping` | Test reachability |
| `tracert` / `traceroute` | Show path to destination |
| `arp -a` / `ip neigh` | Show ARP/neighbor cache |
| `route print` / `ip route` | Show routing table |
| `nslookup` / `dig` | Query DNS |
| `netstat` / `ss` | Show network connections |

## 16. Troubleshooting Flow

When Internet is not working:

1. Check physical/Wi-Fi connection.
2. Check IP address, subnet mask, gateway, DNS.
3. If IP is `169.254.x.x`, DHCP likely failed.
4. Ping loopback:

```text
ping 127.0.0.1
```

5. Ping own IP.
6. Ping default gateway.
7. Ping public IP:

```text
ping 8.8.8.8
```

8. Ping domain:

```text
ping google.com
```

Interpretation:

| Result | Possible Issue |
|---|---|
| Cannot ping loopback | TCP/IP stack issue |
| Cannot ping own IP | Local NIC/IP issue |
| Cannot ping gateway | LAN, ARP, subnet, Wi-Fi, cable, gateway issue |
| Can ping 8.8.8.8 but not google.com | DNS issue |
| Can ping gateway but not Internet | Routing, NAT, ISP, firewall issue |

## 17. Must-Remember One-Liners

- IP address identifies a host logically in a network.
- MAC address identifies an interface in a LAN.
- Router uses IP address; switch uses MAC address.
- ARP maps IPv4 address to MAC address.
- DNS maps domain name to IP address.
- DHCP dynamically assigns IP configuration.
- ICMP reports network errors and supports diagnostics.
- NAT translates private IPs to public IPs.
- CIDR uses prefix length instead of classful addressing.
- Subnetting divides a network; supernetting combines networks.
- TTL prevents infinite packet looping.
- Longest prefix match chooses the most specific route.
- IPv6 has no broadcast and no ARP.
- IPv4 header has checksum; IPv6 header does not.
- Routers change MAC addresses at each hop, not destination IP address, unless NAT is involved.
- Default gateway is used to reach outside the local subnet.

## 18. High-Yield Interview Traps

### Trap 1: Does ARP work across routers?

No. ARP works only within the local broadcast domain.

### Trap 2: For remote destination, whose MAC is used?

The default gateway's MAC address is used as the frame destination MAC.

### Trap 3: Does NAT provide security?

Not directly. NAT hides internal addresses but is not a replacement for a firewall.

### Trap 4: Does ping use TCP or UDP?

Neither. Ping uses ICMP.

### Trap 5: Is IPv6 just IPv4 with bigger addresses?

No. IPv6 also changes header design, address resolution, autoconfiguration, fragmentation behavior, and broadcast behavior.

### Trap 6: Can routers fragment IPv6 packets?

No. IPv6 routers do not fragment packets. The source host handles fragmentation.

### Trap 7: What route is chosen if multiple routes match?

The route with the longest matching prefix is chosen.

### Trap 8: Can two devices have the same IP in one LAN?

No. It causes IP conflict. Gratuitous ARP can help detect it.

### Trap 9: Is broadcast available in IPv6?

No. IPv6 uses multicast instead of broadcast.

### Trap 10: Is `172.32.0.1` private?

No. Private 172 range is only `172.16.0.0` to `172.31.255.255`.

## 19. Quick Revision Sheet

| Topic | Key Fact |
|---|---|
| IPv4 size | 32 bits |
| IPv6 size | 128 bits |
| IPv4 private ranges | 10/8, 172.16/12, 192.168/16 |
| IPv4 loopback | 127.0.0.1 |
| IPv6 loopback | ::1 |
| IPv4 broadcast | 255.255.255.255 |
| IPv6 broadcast | Does not exist |
| ARP | IPv4 to MAC |
| NDP | IPv6 neighbor discovery |
| DHCP ports | UDP 67 server, UDP 68 client |
| DNS port | UDP/TCP 53 |
| RIP port | UDP 520 |
| OSPF protocol | IP protocol 89 |
| BGP port | TCP 179 |
| TCP protocol number | 6 |
| UDP protocol number | 17 |
| ICMP protocol number | 1 |
| Ethernet MTU | Usually 1500 bytes |
| IPv4 min header | 20 bytes |
| IPv6 header | 40 bytes |
| Default IPv4 route | 0.0.0.0/0 |
| Default IPv6 route | ::/0 |

## 20. Last-Minute Placement Checklist

Before an interview, be able to do these without notes:

- Convert `/24`, `/25`, `/26`, `/27`, `/28`, `/29`, `/30` to masks and host counts.
- Given an IP/CIDR, find network, broadcast, first usable, last usable.
- Explain ARP request/reply.
- Explain DHCP DORA.
- Explain what happens when a packet goes to another network.
- Explain NAT/PAT using ports.
- Explain ping and traceroute.
- Compare IPv4 and IPv6.
- Compare router and switch.
- Explain longest prefix match.
- Explain static vs dynamic routing.
- Explain RIP vs OSPF vs BGP.
- Explain why TTL exists.
- Explain why IPv6 does not use ARP or broadcast.

