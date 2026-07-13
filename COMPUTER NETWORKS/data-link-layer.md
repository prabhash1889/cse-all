# Data Link Layer: MAC Address, Ethernet, Switches, Frames, CRC, and Collision Basics

This note is for placement preparation in Computer Networks. It focuses on the Data Link Layer and the most commonly asked topics around MAC addresses, Ethernet, switching, frames, CRC, collision handling, and related interview concepts.

---

## 1. Data Link Layer Overview

The Data Link Layer is Layer 2 of the OSI model.

It sits between:

- Layer 3: Network Layer
- Layer 1: Physical Layer

The Network Layer deals with logical addressing and routing using IP addresses. The Physical Layer deals with actual transmission of bits as electrical, optical, or wireless signals. The Data Link Layer provides reliable node-to-node delivery over a directly connected link.

In simple words:

The Data Link Layer takes packets from the Network Layer, wraps them into frames, adds MAC addresses, performs error detection, and sends them over the physical medium.

---

## 2. Main Responsibilities of the Data Link Layer

The Data Link Layer performs the following functions:

| Responsibility | Meaning |
|---|---|
| Framing | Divides raw bit stream into manageable units called frames |
| Physical addressing | Adds source and destination MAC addresses |
| Error detection | Detects corrupted frames using CRC or checksum-like techniques |
| Error control | May retransmit damaged/lost frames in some protocols |
| Flow control | Prevents sender from overwhelming receiver |
| Medium access control | Decides who can transmit on a shared medium |
| Link management | Establishes and manages direct communication between nodes |

Important placement line:

The Data Link Layer is responsible for node-to-node delivery, while the Network Layer is responsible for host-to-host delivery across multiple networks.

---

## 3. Data Link Layer Sublayers

The IEEE 802 standards divide the Data Link Layer into two sublayers:

| Sublayer | Full Form | Responsibility |
|---|---|---|
| LLC | Logical Link Control | Interface with Network Layer, flow/error control support |
| MAC | Media Access Control | MAC addressing and access to shared medium |

### 3.1 Logical Link Control Sublayer

The LLC sublayer:

- Provides an interface between the Network Layer and MAC sublayer.
- Identifies which Network Layer protocol is being carried.
- Can support flow control and error control depending on the protocol.
- Makes different LAN technologies appear similar to the upper layers.

### 3.2 Media Access Control Sublayer

The MAC sublayer:

- Handles MAC addressing.
- Builds and interprets MAC frames.
- Controls access to the transmission medium.
- Deals with collision handling in older shared Ethernet networks.
- Is closely related to Ethernet, Wi-Fi, switches, and LAN communication.

---

## 4. Data Link Layer Devices

Common Layer 2 devices:

| Device | Layer | Main Function |
|---|---|---|
| Network Interface Card | Layer 1 and Layer 2 | Connects device to network and has MAC address |
| Bridge | Layer 2 | Connects LAN segments and filters frames |
| Switch | Layer 2 | Forwards frames using MAC address table |
| Wireless Access Point | Layer 2 | Bridges wireless clients to wired LAN |

Important distinction:

- Hub works at Layer 1.
- Switch works mainly at Layer 2.
- Router works at Layer 3.

---

## 5. What Is a Frame?

A frame is the Protocol Data Unit of the Data Link Layer.

PDU by layer:

| OSI Layer | PDU Name |
|---|---|
| Application/Presentation/Session | Data |
| Transport | Segment for TCP, Datagram for UDP |
| Network | Packet |
| Data Link | Frame |
| Physical | Bits |

The Data Link Layer receives an IP packet from the Network Layer and encapsulates it inside a frame.

Encapsulation:

```text
Application Data
-> Transport Segment
-> IP Packet
-> Data Link Frame
-> Bits
```

At the receiver side, decapsulation happens in the reverse direction.

---

## 6. Generic Frame Format

A general Data Link Layer frame contains:

| Field | Purpose |
|---|---|
| Header | Contains addressing and control information |
| Payload/Data | Contains the packet from the Network Layer |
| Trailer | Usually contains error detection information |

Generic view:

```text
+----------------+----------------------+----------------+
| Frame Header   | Payload / Data        | Frame Trailer  |
+----------------+----------------------+----------------+
```

The header usually contains source and destination MAC addresses. The trailer commonly contains CRC.

---

## 7. Ethernet Frame Format

Ethernet is the most widely used LAN technology.

Standard Ethernet frame:

```text
+----------+-----+-----------------+----------------+------------+------------+------+
| Preamble | SFD | Destination MAC | Source MAC     | Type/Length| Payload    | FCS  |
+----------+-----+-----------------+----------------+------------+------------+------+
| 7 bytes  |1byte| 6 bytes         | 6 bytes        | 2 bytes    |46-1500 B   |4 B   |
+----------+-----+-----------------+----------------+------------+------------+------+
```

### 7.1 Ethernet Frame Fields

| Field | Size | Purpose |
|---|---:|---|
| Preamble | 7 bytes | Synchronizes receiver clock |
| SFD | 1 byte | Start Frame Delimiter, marks beginning of actual frame |
| Destination MAC | 6 bytes | MAC address of receiving device |
| Source MAC | 6 bytes | MAC address of sending device |
| Type/Length | 2 bytes | Indicates upper-layer protocol or payload length |
| Payload | 46 to 1500 bytes | Data from Network Layer, usually IP packet |
| FCS | 4 bytes | Frame Check Sequence, contains CRC |

### 7.2 Ethernet Frame Size

Minimum Ethernet frame size:

```text
64 bytes
```

This includes:

- Destination MAC: 6 bytes
- Source MAC: 6 bytes
- Type/Length: 2 bytes
- Payload: minimum 46 bytes
- FCS: 4 bytes

Maximum standard Ethernet frame size:

```text
1518 bytes
```

This includes:

- 14-byte Ethernet header
- 1500-byte payload
- 4-byte FCS

Preamble and SFD are usually not counted in the 64-byte or 1518-byte frame size.

### 7.3 Ethernet MTU

MTU stands for Maximum Transmission Unit.

For standard Ethernet:

```text
MTU = 1500 bytes
```

This means the maximum payload carried by a normal Ethernet frame is 1500 bytes.

If an IP packet is larger than the MTU, fragmentation may be needed at the IP layer, unless Path MTU Discovery avoids it.

### 7.4 Jumbo Frames

Jumbo frames are Ethernet frames with payload larger than 1500 bytes, commonly around 9000 bytes.

They are used in:

- Data centers
- Storage networks
- High-performance LANs

Advantages:

- Less header overhead
- Fewer frames to process
- Better throughput in controlled networks

Disadvantages:

- Must be supported by all devices in the path
- Can cause compatibility issues
- Not normally used on the public Internet

---

## 8. MAC Address

MAC stands for Media Access Control.

A MAC address is a physical or hardware address assigned to a network interface card.

Example:

```text
3C:52:82:AA:12:4F
```

It is usually written as 6 hexadecimal pairs.

Each pair has 8 bits.

So:

```text
6 bytes = 48 bits
```

MAC addresses are mainly used for communication inside a local network.

Important:

- IP address identifies a device logically across networks.
- MAC address identifies a network interface on the local network.

---

## 9. Structure of a MAC Address

A 48-bit MAC address has two main parts:

```text
+----------------------+----------------------+
| OUI                  | NIC Specific Part    |
+----------------------+----------------------+
| First 24 bits        | Last 24 bits         |
+----------------------+----------------------+
```

### 9.1 OUI

OUI stands for Organizationally Unique Identifier.

It is assigned to manufacturers by IEEE.

Example:

If the MAC address is:

```text
3C:52:82:AA:12:4F
```

Then:

```text
3C:52:82
```

is the OUI.

It may identify the vendor/manufacturer of the NIC.

### 9.2 NIC Specific Part

The last 24 bits are assigned by the manufacturer to uniquely identify a network interface.

In:

```text
3C:52:82:AA:12:4F
```

the NIC-specific part is:

```text
AA:12:4F
```

---

## 10. Types of MAC Addresses

### 10.1 Unicast MAC Address

A unicast MAC address identifies a single network interface.

Example use:

One computer sends an Ethernet frame to another specific computer in the same LAN.

### 10.2 Broadcast MAC Address

Broadcast means one-to-all communication within a LAN.

Broadcast MAC address:

```text
FF:FF:FF:FF:FF:FF
```

Every device in the broadcast domain receives and processes a broadcast frame.

Example:

ARP request uses broadcast.

### 10.3 Multicast MAC Address

Multicast means one-to-many communication.

It is used when a frame should be delivered to a group of interested devices, not all devices.

Example:

- IPv4 multicast
- IPv6 neighbor discovery
- Streaming or group communication protocols

---

## 11. Universally Administered and Locally Administered MAC Addresses

### 11.1 Universally Administered Address

A universally administered MAC address is assigned by the manufacturer.

It is globally intended to be unique.

### 11.2 Locally Administered Address

A locally administered MAC address is manually or automatically assigned by software.

It may be used in:

- Virtual machines
- Containers
- Privacy MAC randomization
- Network testing

Modern operating systems often use randomized MAC addresses for Wi-Fi privacy.

---

## 12. MAC Address vs IP Address

| Feature | MAC Address | IP Address |
|---|---|---|
| Layer | Data Link Layer | Network Layer |
| Type | Physical/hardware address | Logical address |
| Used for | Local network delivery | End-to-end delivery across networks |
| Assigned by | Manufacturer or software | Network admin, DHCP, ISP, or manual config |
| Changes across networks? | Usually no, but can be spoofed/randomized | Yes, usually changes when network changes |
| Example | 3C:52:82:AA:12:4F | 192.168.1.10 |
| Device used | Switch | Router |

Important interview answer:

MAC addresses are used for delivery inside the same local network. IP addresses are used to identify source and destination hosts across different networks.

---

## 13. Why Do We Need Both MAC and IP Addresses?

We need both because they solve different problems.

IP address:

- Tells where the destination host is logically located.
- Helps routers forward packets across networks.
- Can change when the device moves to another network.

MAC address:

- Tells which exact interface should receive the frame on the local link.
- Is used by switches to deliver frames within a LAN.
- Is needed for the final hop inside a local network.

Example:

If your laptop sends data to a website:

1. Your laptop creates an IP packet with the website server's IP address.
2. The packet must first go to your default gateway/router.
3. Your laptop uses ARP to find the router's MAC address.
4. It sends an Ethernet frame to the router's MAC address.
5. The router removes the old Ethernet frame and creates a new frame for the next hop.
6. The IP destination remains the website server, but the MAC addresses change at every hop.

Key point:

IP addresses usually stay end-to-end, but MAC addresses change hop-by-hop.

---

## 14. ARP and MAC Address Resolution

ARP stands for Address Resolution Protocol.

It maps an IPv4 address to a MAC address inside a local network.

Example:

Your computer wants to send data to:

```text
192.168.1.20
```

but it only knows the IP address, not the MAC address.

It sends an ARP request:

```text
Who has 192.168.1.20? Tell 192.168.1.10.
```

The device with IP `192.168.1.20` replies:

```text
192.168.1.20 is at AA:BB:CC:DD:EE:FF.
```

Then the sender stores this mapping in the ARP cache.

Important:

- ARP request is broadcast.
- ARP reply is usually unicast.
- ARP is used with IPv4.
- IPv6 uses Neighbor Discovery Protocol instead of ARP.

---

## 15. Ethernet

Ethernet is a family of wired LAN technologies standardized mainly under IEEE 802.3.

Ethernet defines:

- Frame format
- MAC addressing
- Access method
- Physical layer standards
- Speeds and cable types

Common Ethernet speeds:

| Name | Speed |
|---|---:|
| Ethernet | 10 Mbps |
| Fast Ethernet | 100 Mbps |
| Gigabit Ethernet | 1 Gbps |
| 10 Gigabit Ethernet | 10 Gbps |
| 40 Gigabit Ethernet | 40 Gbps |
| 100 Gigabit Ethernet | 100 Gbps |
| 400 Gigabit Ethernet | 400 Gbps |

---

## 16. Ethernet Standards

Common examples:

| Standard | Speed | Medium |
|---|---:|---|
| 10BASE-T | 10 Mbps | Twisted pair copper |
| 100BASE-TX | 100 Mbps | Twisted pair copper |
| 1000BASE-T | 1 Gbps | Twisted pair copper |
| 10GBASE-T | 10 Gbps | Twisted pair copper |
| 1000BASE-SX | 1 Gbps | Fiber |
| 1000BASE-LX | 1 Gbps | Fiber |

Meaning of 100BASE-TX:

- 100 = 100 Mbps
- BASE = baseband transmission
- TX = twisted pair variant

Meaning of 10BASE-T:

- 10 = 10 Mbps
- BASE = baseband
- T = twisted pair

---

## 17. Ethernet Communication Types

### 17.1 Half-Duplex

In half-duplex communication, a device can either send or receive at a time, but not both simultaneously.

Old shared Ethernet used half-duplex.

Collisions are possible in half-duplex Ethernet.

### 17.2 Full-Duplex

In full-duplex communication, a device can send and receive at the same time.

Modern switched Ethernet is full-duplex.

Collisions do not occur in full-duplex Ethernet.

Important interview line:

CSMA/CD is not used in modern full-duplex switched Ethernet because collisions do not occur.

---

## 18. Switches

A switch is a Layer 2 device that connects devices in a LAN and forwards Ethernet frames based on MAC addresses.

Unlike a hub, a switch does not blindly repeat every signal to every port. It learns MAC addresses and forwards frames only to the correct port when possible.

Main functions:

- Learns MAC addresses.
- Maintains a MAC address table.
- Forwards known unicast frames.
- Floods unknown unicast frames.
- Floods broadcast and multicast frames unless controlled.
- Separates collision domains.
- Usually supports full-duplex communication.

---

## 19. MAC Address Table

A switch maintains a MAC address table, also called a CAM table.

CAM stands for Content Addressable Memory.

Example:

| MAC Address | Switch Port |
|---|---|
| AA:AA:AA:AA:AA:AA | Port 1 |
| BB:BB:BB:BB:BB:BB | Port 2 |
| CC:CC:CC:CC:CC:CC | Port 3 |

When the switch receives a frame, it checks the destination MAC address and forwards the frame to the correct port if known.

---

## 20. How a Switch Learns MAC Addresses

Switch learning is based on the source MAC address.

When a frame enters a switch port:

1. The switch reads the source MAC address.
2. It records that the source MAC is reachable through the incoming port.
3. It stores this mapping in the MAC address table.
4. It uses the destination MAC address to decide where to forward the frame.

Example:

If a frame from `AA:AA:AA:AA:AA:AA` enters on Port 1, the switch learns:

```text
AA:AA:AA:AA:AA:AA -> Port 1
```

---

## 21. Switch Forwarding Behavior

### 21.1 Known Unicast

If the destination MAC address is present in the MAC table, the switch forwards the frame only to the associated port.

Example:

```text
Destination MAC BB:BB:BB:BB:BB:BB -> Port 2
```

The switch sends the frame only out Port 2.

### 21.2 Unknown Unicast

If the destination MAC address is not present in the MAC table, the switch floods the frame out all ports except the incoming port.

This is called unknown unicast flooding.

Once the destination replies, the switch learns its MAC address.

### 21.3 Broadcast

If the destination MAC is:

```text
FF:FF:FF:FF:FF:FF
```

the switch floods the frame out all ports except the incoming port.

### 21.4 Multicast

Basic switches may flood multicast frames like broadcast frames.

Managed switches can use features like IGMP snooping to forward multicast more intelligently.

---

## 22. Switch vs Hub

| Feature | Hub | Switch |
|---|---|---|
| OSI Layer | Layer 1 | Layer 2 |
| Forwarding basis | Electrical signal | MAC address |
| Intelligence | No MAC learning | Learns MAC addresses |
| Collision domains | One shared collision domain | Each port is separate collision domain |
| Duplex | Usually half-duplex | Usually full-duplex |
| Security | Very poor | Better than hub |
| Performance | Low | High |

Important:

A hub repeats incoming bits to all ports. A switch forwards frames based on MAC addresses.

---

## 23. Switch vs Router

| Feature | Switch | Router |
|---|---|---|
| OSI Layer | Layer 2 | Layer 3 |
| Address used | MAC address | IP address |
| Main job | Connect devices in same LAN | Connect different networks |
| Table used | MAC/CAM table | Routing table |
| Broadcast domain | Does not break broadcast domain by default | Breaks broadcast domains |
| Example | Connect PCs in office LAN | Connect home LAN to Internet |

Important:

A switch connects devices within the same network. A router connects different networks.

---

## 24. Collision Domain and Broadcast Domain

### 24.1 Collision Domain

A collision domain is a network segment where packet collisions can occur if two devices transmit at the same time.

In old hub-based Ethernet:

- All devices connected to a hub share one collision domain.
- If two devices transmit simultaneously, a collision occurs.

In switch-based Ethernet:

- Each switch port is a separate collision domain.
- In full-duplex mode, collisions do not occur.

### 24.2 Broadcast Domain

A broadcast domain is the set of devices that receive each other's broadcast frames.

Switches forward broadcasts by default, so all ports in the same VLAN are part of one broadcast domain.

Routers do not forward Layer 2 broadcasts by default, so routers separate broadcast domains.

VLANs can also separate broadcast domains on switches.

---

## 25. Collision Basics

A collision occurs when two devices transmit at the same time on a shared medium and their signals interfere.

Collisions were common in:

- Bus topology Ethernet
- Hub-based Ethernet
- Half-duplex Ethernet

Collisions are not a normal issue in modern switched full-duplex Ethernet.

---

## 26. CSMA/CD

CSMA/CD stands for Carrier Sense Multiple Access with Collision Detection.

It was used in traditional Ethernet to handle collisions on shared media.

Meaning:

| Term | Meaning |
|---|---|
| Carrier Sense | Listen before transmitting |
| Multiple Access | Many devices share the same medium |
| Collision Detection | Detect if collision occurs during transmission |

### 26.1 CSMA/CD Working

Steps:

1. A device listens to the medium.
2. If the medium is idle, it starts transmitting.
3. If the medium is busy, it waits.
4. While transmitting, it monitors for collision.
5. If collision is detected, it sends a jam signal.
6. It stops transmitting.
7. It waits for a random backoff time.
8. It tries again.

### 26.2 Binary Exponential Backoff

After a collision, devices wait for a random time before retransmitting.

After repeated collisions, the range of possible waiting times increases.

This is called binary exponential backoff.

Purpose:

- Reduces the chance of repeated collisions.
- Helps stabilize the network under load.

### 26.3 Jam Signal

A jam signal is sent after detecting a collision.

Purpose:

- Ensures all devices know a collision happened.
- Forces devices to discard the corrupted frame.

---

## 27. Why Minimum Ethernet Frame Size Is 64 Bytes

The minimum Ethernet frame size is related to collision detection in classic half-duplex Ethernet.

In CSMA/CD, the sender must still be transmitting when a collision from the farthest point in the network can propagate back to it.

If the frame is too small, the sender may finish transmission before detecting the collision.

Therefore Ethernet defines a minimum frame size of 64 bytes.

If the payload is smaller than 46 bytes, padding is added.

Important placement answer:

The minimum Ethernet frame size ensures that collisions can be detected during transmission in half-duplex Ethernet.

---

## 28. Collision Domain Examples

### Example 1: Hub

If 5 devices are connected to one hub:

```text
Number of collision domains = 1
```

All devices share the same collision domain.

### Example 2: Switch

If 5 devices are connected to a switch:

```text
Number of collision domains = 5
```

Each switch port is a separate collision domain.

### Example 3: Switch in Full-Duplex Mode

In modern switched full-duplex Ethernet:

```text
Collisions = practically absent
```

The concept of collision domains is still asked in exams, but collisions are not normally seen in modern LANs.

---

## 29. CRC

CRC stands for Cyclic Redundancy Check.

It is an error detection technique used in Data Link Layer protocols such as Ethernet.

In Ethernet, CRC is stored in the FCS field.

CRC is used to detect accidental changes in data during transmission.

It can detect many common errors, such as:

- Single-bit errors
- Multiple-bit errors
- Burst errors

Important:

CRC detects errors. It does not correct errors by itself.

---

## 30. FCS

FCS stands for Frame Check Sequence.

In Ethernet:

```text
FCS = 4 bytes
```

The FCS contains the CRC value calculated over the frame.

At the sender:

1. CRC is calculated.
2. CRC value is placed in the FCS field.
3. Frame is transmitted.

At the receiver:

1. Receiver calculates CRC again.
2. Receiver compares it with received FCS.
3. If values match, frame is accepted.
4. If values do not match, frame is discarded.

Ethernet does not normally request retransmission at Layer 2 after a CRC error. Higher layers, such as TCP, may handle recovery.

---

## 31. How CRC Works: Conceptual Explanation

CRC treats the data bits as a binary number or polynomial.

The sender divides the data polynomial by a fixed generator polynomial. The remainder of this division is the CRC.

The sender appends this remainder to the frame.

The receiver performs the same division. If the remainder is zero or matches the expected value, the frame is considered valid. If not, the frame is considered corrupted.

Simplified idea:

```text
Data + CRC remainder -> transmitted frame
Receiver checks whether the received bits divide correctly by the generator
```

CRC is popular because it is:

- Fast in hardware
- Good at detecting burst errors
- Simple to verify
- Better than simple parity for network frames

---

## 32. CRC vs Checksum vs Parity

| Technique | Used For | Strength |
|---|---|---|
| Parity bit | Simple error detection | Detects odd number of bit errors |
| Checksum | Used in protocols like IP, TCP, UDP | Moderate error detection |
| CRC | Used in Ethernet and storage | Strong burst error detection |

Parity is simple but weak. CRC is much stronger for network frames.

---

## 33. Error Control at Data Link Layer

The Data Link Layer may provide error control depending on the protocol.

Error control can include:

- Error detection
- Acknowledgement
- Retransmission
- Sequence numbers

However, Ethernet mainly performs error detection using CRC. It discards corrupted frames and leaves recovery to higher layers.

Protocols that may provide stronger link-level reliability include some wireless and point-to-point protocols.

---

## 34. Flow Control at Data Link Layer

Flow control prevents a fast sender from overwhelming a slow receiver.

Common flow control methods:

- Stop-and-Wait
- Sliding Window

### 34.1 Stop-and-Wait

The sender sends one frame and waits for acknowledgement before sending the next frame.

Advantage:

- Simple

Disadvantage:

- Inefficient for long-delay links

### 34.2 Sliding Window

The sender can send multiple frames before waiting for acknowledgement.

Advantage:

- Better utilization of bandwidth

Disadvantage:

- More complex

Note:

These ideas are often discussed in Data Link Layer theory. Ethernet itself does not use Stop-and-Wait for normal LAN communication.

---

## 35. Framing Methods

Framing is the process of dividing a stream of bits into frames.

Common framing methods:

| Method | Idea |
|---|---|
| Character count | Header contains number of characters in frame |
| Byte stuffing | Special flag bytes mark frame boundaries; escape bytes handle data conflict |
| Bit stuffing | Special bit pattern marks frame boundaries; extra bits inserted to avoid confusion |
| Physical layer coding violations | Special signal patterns mark boundaries |

### 35.1 Byte Stuffing

In byte stuffing, special flag bytes mark the start and end of a frame.

If the same flag byte appears in the data, an escape byte is inserted before it.

Used in byte-oriented protocols.

### 35.2 Bit Stuffing

In bit stuffing, a special bit pattern marks frame boundaries.

For example, HDLC uses:

```text
01111110
```

If five consecutive `1`s appear in the data, the sender inserts a `0` after them.

The receiver removes the stuffed `0`.

Purpose:

- Prevents data from being confused with frame boundary flags.

---

## 36. VLAN Basics

VLAN stands for Virtual Local Area Network.

A VLAN logically divides a switch into multiple broadcast domains.

Without VLANs:

- One switch usually means one broadcast domain.

With VLANs:

- One switch can have multiple logical broadcast domains.

Example:

| VLAN | Department |
|---|---|
| VLAN 10 | HR |
| VLAN 20 | Engineering |
| VLAN 30 | Finance |

Devices in different VLANs usually need a router or Layer 3 switch to communicate.

### 36.1 Access Port

An access port belongs to one VLAN.

It is usually connected to an end device such as a PC or printer.

### 36.2 Trunk Port

A trunk port carries traffic for multiple VLANs.

It is usually used between switches or between a switch and a router.

### 36.3 802.1Q Tag

IEEE 802.1Q adds a VLAN tag to Ethernet frames.

The VLAN tag identifies which VLAN the frame belongs to.

The VLAN tag is 4 bytes long.

With VLAN tagging, the maximum Ethernet frame size becomes 1522 bytes instead of 1518 bytes.

---

## 37. STP Basics

STP stands for Spanning Tree Protocol.

It prevents Layer 2 loops in switched networks.

Layer 2 loops are dangerous because Ethernet frames do not have a TTL field like IP packets.

Problems caused by Layer 2 loops:

- Broadcast storms
- MAC table instability
- Duplicate frames
- Network congestion

STP creates a loop-free logical topology by blocking some redundant links.

Important:

Switches forward broadcast frames, and Ethernet frames do not have TTL. This is why loops at Layer 2 can be severe.

---

## 38. Broadcast Storm

A broadcast storm occurs when broadcast frames multiply and consume network bandwidth.

It can happen because of:

- Layer 2 loops
- Misconfigured switches
- Faulty devices
- Excessive ARP traffic

Effects:

- Network slowdown
- High switch CPU usage
- Packet loss
- LAN becoming unusable

STP helps prevent broadcast storms caused by loops.

---

## 39. Full-Duplex Switched Ethernet and Modern LANs

Modern Ethernet networks usually use:

- Switches instead of hubs
- Full-duplex links
- Twisted pair or fiber
- Auto-negotiation
- VLANs in enterprise networks

Because each device has a dedicated switch port and can transmit and receive simultaneously, collisions are no longer a normal concern.

Placement point:

Collision handling is historically important and still asked in interviews, but modern switched Ethernet avoids collisions by design.

---

## 40. Important Interview Questions and Answers

### Q1. What is the Data Link Layer?

The Data Link Layer is Layer 2 of the OSI model. It provides node-to-node delivery over a physical link. It performs framing, MAC addressing, error detection, flow control, and medium access control.

### Q2. What is the PDU of the Data Link Layer?

The PDU of the Data Link Layer is a frame.

### Q3. What is a MAC address?

A MAC address is a 48-bit hardware address assigned to a network interface. It is used for local network communication at the Data Link Layer.

### Q4. What is the size of a MAC address?

A traditional MAC address is 48 bits or 6 bytes.

### Q5. What is the broadcast MAC address?

The broadcast MAC address is:

```text
FF:FF:FF:FF:FF:FF
```

### Q6. What is Ethernet?

Ethernet is a widely used LAN technology standardized mainly by IEEE 802.3. It defines frame format, MAC addressing, access methods, and physical transmission standards.

### Q7. What is the minimum and maximum Ethernet frame size?

Minimum Ethernet frame size is 64 bytes. Maximum standard Ethernet frame size is 1518 bytes, excluding preamble and SFD.

### Q8. What is MTU in Ethernet?

MTU stands for Maximum Transmission Unit. For standard Ethernet, the MTU is 1500 bytes.

### Q9. What is CRC?

CRC stands for Cyclic Redundancy Check. It is an error detection technique used to detect corrupted frames.

### Q10. Does CRC correct errors?

No. CRC detects errors but does not correct them.

### Q11. What happens if Ethernet detects a CRC error?

The corrupted frame is discarded. Ethernet normally does not retransmit it at Layer 2. Higher layers such as TCP may recover from the loss.

### Q12. What is FCS?

FCS stands for Frame Check Sequence. It is the trailer field in an Ethernet frame that stores the CRC value.

### Q13. What is a switch?

A switch is a Layer 2 device that forwards Ethernet frames based on MAC addresses. It learns MAC addresses and stores them in a MAC address table.

### Q14. How does a switch learn MAC addresses?

A switch learns MAC addresses by examining the source MAC address of incoming frames and associating it with the incoming port.

### Q15. What does a switch do with an unknown unicast frame?

It floods the frame out all ports except the port on which it was received.

### Q16. What is the difference between a hub and a switch?

A hub is a Layer 1 device that repeats signals to all ports. A switch is a Layer 2 device that forwards frames intelligently using MAC addresses.

### Q17. What is a collision domain?

A collision domain is a network segment where devices may collide if they transmit at the same time.

### Q18. How many collision domains are there in a switch?

Each switch port is a separate collision domain. In full-duplex switched Ethernet, collisions do not normally occur.

### Q19. What is a broadcast domain?

A broadcast domain is the set of devices that receive each other's broadcast frames.

### Q20. Do switches break broadcast domains?

Not by default. A switch forwards broadcasts within the same VLAN. Routers and VLANs separate broadcast domains.

### Q21. What is CSMA/CD?

CSMA/CD stands for Carrier Sense Multiple Access with Collision Detection. It is a method used in older shared Ethernet networks to detect and handle collisions.

### Q22. Is CSMA/CD used in modern Ethernet?

Not normally. Modern Ethernet uses switches and full-duplex links, so collisions do not occur and CSMA/CD is unnecessary.

### Q23. Why is the Ethernet minimum frame size 64 bytes?

It ensures that a sender is still transmitting when a collision signal can propagate back from the farthest point in a half-duplex Ethernet network.

### Q24. What is ARP?

ARP maps an IPv4 address to a MAC address in a local network.

### Q25. Are MAC addresses changed by routers?

Yes. MAC addresses are used hop-by-hop and change at every router hop. The IP source and destination addresses generally remain the same end-to-end, except in cases like NAT.

---

## 41. Common Numerical Facts to Memorize

| Concept | Value |
|---|---:|
| MAC address size | 48 bits / 6 bytes |
| Ethernet destination MAC field | 6 bytes |
| Ethernet source MAC field | 6 bytes |
| Ethernet Type/Length field | 2 bytes |
| Ethernet FCS field | 4 bytes |
| Ethernet minimum payload | 46 bytes |
| Ethernet maximum payload / MTU | 1500 bytes |
| Minimum Ethernet frame size | 64 bytes |
| Maximum standard Ethernet frame size | 1518 bytes |
| Preamble | 7 bytes |
| SFD | 1 byte |
| 802.1Q VLAN tag | 4 bytes |
| Broadcast MAC | FF:FF:FF:FF:FF:FF |

---

## 42. Quick Comparison Table

| Topic | Key Point |
|---|---|
| Data Link Layer | Node-to-node delivery |
| Frame | Data Link Layer PDU |
| MAC address | Local physical address |
| Ethernet | Most common wired LAN technology |
| Switch | Forwards frames using MAC table |
| Hub | Repeats bits to all ports |
| Router | Forwards packets using IP address |
| CRC | Error detection |
| FCS | Field containing CRC |
| Collision | Signal interference on shared medium |
| CSMA/CD | Old Ethernet collision handling method |
| VLAN | Logical broadcast domain |
| STP | Prevents Layer 2 loops |

---

## 43. Data Link Layer vs Network Layer

| Feature | Data Link Layer | Network Layer |
|---|---|---|
| OSI Layer | Layer 2 | Layer 3 |
| PDU | Frame | Packet |
| Address | MAC address | IP address |
| Delivery | Node-to-node | Host-to-host |
| Main device | Switch | Router |
| Error detection | CRC/FCS | Header checksum in IPv4, other checks in upper layers |
| Scope | Same link/local network | Across multiple networks |

---

## 44. Important Placement Traps

### Trap 1: Switches and broadcasts

Incorrect:

Switches never forward frames to all ports.

Correct:

Switches forward broadcasts and unknown unicasts to all ports except the incoming port.

### Trap 2: MAC address and IP address

Incorrect:

MAC address is used to route packets across the Internet.

Correct:

IP address is used for routing across networks. MAC address is used for local delivery on each link.

### Trap 3: CRC

Incorrect:

CRC corrects errors.

Correct:

CRC detects errors. It does not correct errors.

### Trap 4: CSMA/CD

Incorrect:

CSMA/CD is used in all Ethernet networks today.

Correct:

CSMA/CD was used in half-duplex shared Ethernet. Modern full-duplex switched Ethernet does not need it.

### Trap 5: Router and MAC address

Incorrect:

The destination MAC address remains same from source to final destination.

Correct:

MAC addresses change at every hop. IP addresses are used end-to-end.

### Trap 6: Ethernet frame size

Incorrect:

Ethernet frame maximum size is 1500 bytes.

Correct:

1500 bytes is the standard Ethernet payload MTU. The full Ethernet frame is 1518 bytes excluding preamble and SFD.

---

## 45. Example: Sending Data in a LAN

Suppose PC A wants to send data to PC B in the same LAN.

PC A:

```text
IP address: 192.168.1.10
MAC address: AA:AA:AA:AA:AA:AA
```

PC B:

```text
IP address: 192.168.1.20
MAC address: BB:BB:BB:BB:BB:BB
```

Steps:

1. PC A checks whether PC B is in the same network.
2. PC A checks ARP cache for PC B's MAC address.
3. If missing, PC A sends an ARP request using broadcast MAC.
4. PC B replies with its MAC address.
5. PC A creates an Ethernet frame.
6. Source MAC = PC A's MAC.
7. Destination MAC = PC B's MAC.
8. Switch receives the frame.
9. Switch learns PC A's MAC from source address.
10. Switch forwards frame to PC B's port if known, otherwise floods it.
11. PC B receives the frame and passes the payload upward.

---

## 46. Example: Sending Data to the Internet

Suppose your laptop sends data to a website.

Your laptop:

```text
IP: 192.168.1.10
MAC: AA:AA:AA:AA:AA:AA
```

Router:

```text
IP: 192.168.1.1
MAC: RR:RR:RR:RR:RR:RR
```

Website server:

```text
IP: 93.184.216.34
```

The laptop sees that the website IP is outside the local network. So it sends the frame to the default gateway.

Ethernet frame on the first hop:

```text
Source MAC: AA:AA:AA:AA:AA:AA
Destination MAC: RR:RR:RR:RR:RR:RR
Source IP: 192.168.1.10
Destination IP: 93.184.216.34
```

At the next hop, the router creates a new Layer 2 frame with new MAC addresses.

Key point:

The destination IP remains the website server IP, but the destination MAC is only the next-hop device's MAC.

---

## 47. Security-Related Concepts

### 47.1 MAC Spoofing

MAC spoofing means changing the MAC address used by a network interface.

It may be used for:

- Privacy
- Testing
- Bypassing weak MAC filtering
- Attacks

Important:

MAC addresses are not strong security identifiers because they can be changed in software.

### 47.2 MAC Flooding

MAC flooding is an attack against switches.

The attacker sends many frames with fake source MAC addresses. This fills the switch's MAC table.

If the MAC table becomes full, some switches may start flooding frames, making the network behave more like a hub.

Protection:

- Port security
- Limiting MAC addresses per port
- 802.1X authentication
- Monitoring and switch security features

### 47.3 ARP Spoofing

ARP spoofing is an attack where an attacker sends fake ARP messages to associate their MAC address with another IP address, such as the default gateway.

Effects:

- Man-in-the-middle attack
- Traffic interception
- Denial of service

Protection:

- Dynamic ARP Inspection
- Static ARP entries for critical systems
- Secure switches
- Encryption at higher layers, such as HTTPS and SSH

---

## 48. Short Revision Sheet

Remember these one-liners:

- Data Link Layer = node-to-node delivery.
- Frame = Data Link Layer PDU.
- MAC address = Layer 2 physical/local address.
- Ethernet = most common wired LAN technology.
- Switch = forwards frames using MAC address table.
- Hub = repeats bits to all ports.
- Router = forwards packets using IP addresses.
- ARP = maps IPv4 address to MAC address.
- CRC = detects transmission errors.
- FCS = field that stores CRC.
- Broadcast MAC = `FF:FF:FF:FF:FF:FF`.
- Ethernet MTU = 1500 bytes.
- Minimum Ethernet frame = 64 bytes.
- Maximum standard Ethernet frame = 1518 bytes.
- CSMA/CD = old collision handling method for half-duplex Ethernet.
- Modern full-duplex switched Ethernet has no collisions.
- Switches separate collision domains.
- Routers separate broadcast domains.
- VLANs also separate broadcast domains.
- MAC addresses change hop-by-hop.
- IP addresses are used end-to-end.

---

## 49. Best Final Interview Answer

If asked to explain the Data Link Layer briefly:

The Data Link Layer is Layer 2 of the OSI model and is responsible for node-to-node delivery over a physical link. It takes packets from the Network Layer and encapsulates them into frames. It adds source and destination MAC addresses, performs error detection using CRC in the FCS field, and controls access to the medium. Ethernet is the most common Data Link Layer technology in LANs. Switches operate at this layer and forward frames using MAC address tables. In older shared Ethernet, collisions were handled using CSMA/CD, but modern switched full-duplex Ethernet avoids collisions.

