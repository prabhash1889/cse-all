# Network Models and Layer Roles

This note is for placement preparation in Computer Networks. It covers the OSI model, TCP/IP model, and the roles of the Application, Transport, Network, and Data-Link layers in detail.

---

## 1. Why Network Models Exist

Computer networks are complex. A single message sent from one device to another involves applications, operating systems, protocols, addresses, routing, error detection, physical transmission, and many other details.

Network models divide this complexity into layers.

Benefits of layered models:

- They make network design easier to understand.
- Each layer has a clear responsibility.
- One layer can change without redesigning the whole network.
- Different vendors can build compatible hardware and software.
- Troubleshooting becomes easier because problems can be isolated by layer.
- Protocols can be standardized.

Two important network models are:

- OSI Model
- TCP/IP Model

---

# 2. OSI Model

OSI stands for Open Systems Interconnection.

It is a conceptual reference model developed by ISO. It explains how data moves from one computer to another through a network.

The OSI model has 7 layers:

| Layer Number | Layer Name |
|---|---|
| 7 | Application |
| 6 | Presentation |
| 5 | Session |
| 4 | Transport |
| 3 | Network |
| 2 | Data-Link |
| 1 | Physical |

Mnemonic:

- From top to bottom: All People Seem To Need Data Processing
- From bottom to top: Please Do Not Throw Sausage Pizza Away

---

## 2.1 Layer 7: Application Layer

The Application layer is closest to the user.

It provides network services directly to user applications. This does not mean the application itself is the layer. Instead, the layer provides protocols that applications use to communicate over the network.

Main responsibilities:

- Provides services such as web browsing, email, file transfer, remote login, and name resolution.
- Defines how applications request and exchange data.
- Provides user-level network services.
- Identifies communication partners.
- Checks resource availability.
- Supports authentication and service discovery in some protocols.

Common protocols:

| Protocol | Full Form | Use |
|---|---|---|
| HTTP | HyperText Transfer Protocol | Web browsing |
| HTTPS | HTTP Secure | Secure web browsing |
| FTP | File Transfer Protocol | File transfer |
| SMTP | Simple Mail Transfer Protocol | Sending emails |
| POP3 | Post Office Protocol v3 | Retrieving emails |
| IMAP | Internet Message Access Protocol | Managing emails on mail server |
| DNS | Domain Name System | Converts domain names to IP addresses |
| DHCP | Dynamic Host Configuration Protocol | Assigns IP addresses automatically |
| SSH | Secure Shell | Secure remote login |
| Telnet | Teletype Network | Unsecured remote login |
| SNMP | Simple Network Management Protocol | Network monitoring and management |

Examples:

- When you open `google.com`, the browser uses DNS to find the IP address.
- The browser then uses HTTP or HTTPS to request the web page.
- When you send an email, SMTP is used.
- When you download a file using FTP, FTP works at the Application layer.

Important interview points:

- The Application layer provides network services to applications.
- HTTP, FTP, SMTP, DNS, DHCP, and SSH belong to the Application layer.
- DNS usually uses UDP port 53, but can also use TCP port 53.
- HTTP uses TCP port 80.
- HTTPS uses TCP port 443.

---

## 2.2 Layer 6: Presentation Layer

The Presentation layer is responsible for data format and representation.

It ensures that data sent by one system can be understood by another system.

Main responsibilities:

- Data translation
- Data formatting
- Encryption
- Decryption
- Compression
- Decompression

Examples:

- Converting character encoding such as ASCII to EBCDIC.
- Encrypting data before sending.
- Decrypting received encrypted data.
- Compressing images, audio, or video before transmission.

Common formats and technologies:

- JPEG
- PNG
- GIF
- MPEG
- ASCII
- Unicode
- SSL/TLS encryption is often associated with this layer in OSI discussions, though in the real TCP/IP stack it is implemented between Application and Transport.

Important interview point:

- Presentation layer handles syntax and semantics of transmitted data.

---

## 2.3 Layer 5: Session Layer

The Session layer manages sessions between communicating devices.

A session is a logical connection between two applications.

Main responsibilities:

- Establishes sessions.
- Maintains sessions.
- Terminates sessions.
- Provides synchronization.
- Supports dialog control.
- Allows checkpoints in long data transfers.

Examples:

- Login sessions.
- Video conferencing sessions.
- Remote procedure calls.
- Session recovery using checkpoints.

Important interview point:

- The Session layer is responsible for dialog control and synchronization.

---

## 2.4 Layer 4: Transport Layer

The Transport layer provides process-to-process communication.

It is responsible for delivering data from one application process on the source device to the correct application process on the destination device.

Main responsibilities:

- Segmentation and reassembly
- Reliable delivery
- Error recovery
- Flow control
- Congestion control
- Multiplexing and demultiplexing
- Port addressing
- End-to-end communication

Important protocols:

| Protocol | Type | Features |
|---|---|---|
| TCP | Connection-oriented | Reliable, ordered, error-controlled |
| UDP | Connectionless | Fast, lightweight, unreliable |

### TCP

TCP stands for Transmission Control Protocol.

Features of TCP:

- Connection-oriented
- Reliable
- Ordered delivery
- Error detection and retransmission
- Flow control
- Congestion control
- Uses acknowledgements
- Uses sequence numbers
- Uses three-way handshake

TCP is used when reliability is more important than speed.

Examples:

- Web browsing using HTTP/HTTPS
- Email
- File transfer
- Remote login using SSH

TCP three-way handshake:

1. SYN: Client requests connection.
2. SYN-ACK: Server acknowledges and agrees.
3. ACK: Client acknowledges server response.

TCP connection termination commonly uses four steps:

1. FIN from one side.
2. ACK from the other side.
3. FIN from the other side.
4. ACK from the first side.

### UDP

UDP stands for User Datagram Protocol.

Features of UDP:

- Connectionless
- No guarantee of delivery
- No ordering guarantee
- No retransmission by UDP itself
- Low overhead
- Faster than TCP

UDP is used when speed is more important than perfect reliability.

Examples:

- Online gaming
- Live video streaming
- Voice over IP
- DNS queries
- DHCP

### TCP vs UDP

| Feature | TCP | UDP |
|---|---|---|
| Connection | Connection-oriented | Connectionless |
| Reliability | Reliable | Unreliable |
| Ordering | Maintains order | No ordering guarantee |
| Speed | Slower | Faster |
| Overhead | Higher | Lower |
| Acknowledgement | Yes | No |
| Retransmission | Yes | No |
| Use cases | Web, email, file transfer | Streaming, DNS, gaming |

Important interview points:

- Transport layer uses port numbers.
- TCP is reliable; UDP is faster but unreliable.
- Transport layer provides end-to-end delivery.
- TCP provides flow control and congestion control.
- UDP does not perform flow control or congestion control at the protocol level.

---

## 2.5 Layer 3: Network Layer

The Network layer is responsible for host-to-host delivery across different networks.

It decides how packets travel from source to destination.

Main responsibilities:

- Logical addressing
- Routing
- Path determination
- Packet forwarding
- Fragmentation in IPv4
- Inter-network communication

Important protocols:

| Protocol | Use |
|---|---|
| IP | Logical addressing and packet delivery |
| ICMP | Error reporting and diagnostics |
| IGMP | Multicast group management |
| ARP | Maps IPv4 address to MAC address, often placed between Layer 2 and Layer 3 |
| OSPF | Routing protocol |
| RIP | Routing protocol |
| BGP | Internet routing protocol |

### IP Addressing

The Network layer uses IP addresses.

An IP address identifies a device logically on a network.

Types:

- IPv4: 32-bit address, example `192.168.1.10`
- IPv6: 128-bit address, example `2001:0db8::1`

IPv4 address classes:

| Class | Range | Default Mask | Use |
|---|---|---|---|
| A | 1.0.0.0 to 126.255.255.255 | 255.0.0.0 | Very large networks |
| B | 128.0.0.0 to 191.255.255.255 | 255.255.0.0 | Medium networks |
| C | 192.0.0.0 to 223.255.255.255 | 255.255.255.0 | Small networks |
| D | 224.0.0.0 to 239.255.255.255 | Not applicable | Multicast |
| E | 240.0.0.0 to 255.255.255.255 | Not applicable | Experimental |

Private IPv4 ranges:

| Range | Class |
|---|---|
| 10.0.0.0 to 10.255.255.255 | A |
| 172.16.0.0 to 172.31.255.255 | B |
| 192.168.0.0 to 192.168.255.255 | C |

### Routing

Routing is the process of selecting the best path for data packets.

Routers work mainly at the Network layer.

Types of routing:

- Static routing: Routes are manually configured.
- Dynamic routing: Routes are learned automatically using routing protocols.

Common routing protocols:

- RIP
- OSPF
- EIGRP
- BGP

Important interview points:

- Network layer uses IP addresses.
- Routers operate at the Network layer.
- The data unit at Network layer is called a packet.
- Routing happens at the Network layer.
- IP is connectionless and unreliable by itself.

---

## 2.6 Layer 2: Data-Link Layer

The Data-Link layer provides node-to-node delivery.

It transfers data between two directly connected devices on the same local network.

Main responsibilities:

- Framing
- Physical addressing using MAC addresses
- Error detection
- Flow control between directly connected nodes
- Media access control
- Reliable link-level delivery in some technologies

The Data-Link layer is often divided into two sublayers:

| Sublayer | Full Form | Role |
|---|---|---|
| LLC | Logical Link Control | Error control, flow control, interface with Network layer |
| MAC | Media Access Control | MAC addressing and access to transmission medium |

### MAC Address

A MAC address is a physical hardware address assigned to a network interface card.

Example:

`00:1A:2B:3C:4D:5E`

Features:

- 48-bit address in traditional Ethernet.
- Written in hexadecimal.
- Used for local delivery within a LAN.
- Switches use MAC addresses to forward frames.

### Framing

The Data-Link layer converts packets from the Network layer into frames.

A frame usually contains:

- Source MAC address
- Destination MAC address
- Type or length field
- Payload
- Error detection field such as CRC

### Error Detection

The Data-Link layer commonly detects errors using CRC.

CRC stands for Cyclic Redundancy Check.

If an error is detected, the frame may be discarded. Depending on the protocol, retransmission may or may not happen at Layer 2.

### Devices

Devices associated with the Data-Link layer:

- Switch
- Bridge
- Network Interface Card

Important interview points:

- Data-Link layer uses MAC addresses.
- Switches operate mainly at the Data-Link layer.
- The data unit at this layer is called a frame.
- Data-Link layer provides node-to-node delivery.
- Error detection is done using CRC.

---

## 2.7 Layer 1: Physical Layer

The Physical layer deals with actual transmission of raw bits over a physical medium.

Main responsibilities:

- Transmission of bits
- Defines cables, connectors, signals, voltages, and data rates
- Converts bits into electrical, optical, or radio signals
- Handles physical topology
- Defines transmission modes

Transmission media:

- Twisted pair cable
- Coaxial cable
- Fiber optic cable
- Radio waves
- Microwaves

Devices:

- Hub
- Repeater
- Cables
- Modems

Important interview points:

- Physical layer transmits raw bits.
- The data unit is a bit.
- Hubs and repeaters operate at the Physical layer.

---

# 3. Data Units in OSI Model

| OSI Layer | Data Unit |
|---|---|
| Application | Data |
| Presentation | Data |
| Session | Data |
| Transport | Segment for TCP, Datagram for UDP |
| Network | Packet |
| Data-Link | Frame |
| Physical | Bit |

---

# 4. Devices by OSI Layer

| Device | Layer |
|---|---|
| Hub | Physical |
| Repeater | Physical |
| Switch | Data-Link |
| Bridge | Data-Link |
| Router | Network |
| Layer 3 Switch | Network |
| Gateway | Can operate at multiple layers |
| Firewall | Can operate at Network, Transport, or Application layer depending on type |

---

# 5. Addressing by Layer

| Layer | Address Used | Example |
|---|---|---|
| Application | Domain name, URL, email address | `www.example.com` |
| Transport | Port number | 80, 443, 53 |
| Network | IP address | `192.168.1.1` |
| Data-Link | MAC address | `00:1A:2B:3C:4D:5E` |
| Physical | No logical address | Signals and bits |

---

# 6. TCP/IP Model

The TCP/IP model is the practical model used on the internet.

It was developed before the OSI model and is based on real protocols used in networks.

TCP/IP usually has 4 layers:

| TCP/IP Layer | Rough OSI Equivalent |
|---|---|
| Application | Application + Presentation + Session |
| Transport | Transport |
| Internet | Network |
| Network Access | Data-Link + Physical |

Some books use a 5-layer TCP/IP model:

| Layer |
|---|
| Application |
| Transport |
| Network |
| Data-Link |
| Physical |

Both are common. In placements, if asked, mention the 4-layer model first and say that some textbooks present it as a 5-layer internet model.

---

## 6.1 TCP/IP Application Layer

The Application layer in TCP/IP includes the functions of OSI Application, Presentation, and Session layers.

Responsibilities:

- Provides network services to user applications.
- Handles application-specific protocols.
- May handle data formatting, encryption, and session management depending on the protocol or software.

Protocols:

- HTTP
- HTTPS
- FTP
- SMTP
- POP3
- IMAP
- DNS
- DHCP
- SSH
- Telnet
- SNMP

---

## 6.2 TCP/IP Transport Layer

Responsibilities:

- Process-to-process communication.
- Segmentation and reassembly.
- Reliability if TCP is used.
- Port addressing.
- Flow control and congestion control in TCP.

Protocols:

- TCP
- UDP

---

## 6.3 TCP/IP Internet Layer

This corresponds to the OSI Network layer.

Responsibilities:

- Logical addressing.
- Routing.
- Packet forwarding.
- Delivery across multiple networks.

Protocols:

- IP
- ICMP
- IGMP
- ARP is often discussed near this layer, though it connects IP addresses with MAC addresses.

---

## 6.4 TCP/IP Network Access Layer

This combines OSI Data-Link and Physical layer responsibilities.

Responsibilities:

- Framing
- MAC addressing
- Error detection
- Access to the transmission medium
- Actual bit transmission

Technologies:

- Ethernet
- Wi-Fi
- PPP
- Frame Relay

---

# 7. OSI Model vs TCP/IP Model

| Feature | OSI Model | TCP/IP Model |
|---|---|---|
| Full form | Open Systems Interconnection | Transmission Control Protocol/Internet Protocol |
| Number of layers | 7 | Usually 4 |
| Nature | Reference model | Practical implementation model |
| Developed by | ISO | DARPA/DoD |
| Usage | Mainly conceptual and educational | Used in real internet communication |
| Top layers | Application, Presentation, Session separate | Combined into Application layer |
| Bottom layers | Data-Link and Physical separate | Combined into Network Access layer |
| Protocol dependency | Protocol independent | Protocol dependent |

Important interview answer:

The OSI model is a theoretical reference model with 7 layers, while TCP/IP is a practical protocol suite used on the internet with 4 layers.

---

# 8. Encapsulation and Decapsulation

## Encapsulation

Encapsulation happens at the sender side.

As data moves down the layers, each layer adds its own header. Some layers may also add a trailer.

Flow:

1. Application layer creates data.
2. Transport layer adds TCP/UDP header, forming a segment or datagram.
3. Network layer adds IP header, forming a packet.
4. Data-Link layer adds frame header and trailer, forming a frame.
5. Physical layer sends bits over the medium.

Example:

Data -> Segment -> Packet -> Frame -> Bits

## Decapsulation

Decapsulation happens at the receiver side.

As data moves up the layers, each layer removes and processes its corresponding header or trailer.

Flow:

Bits -> Frame -> Packet -> Segment -> Data

Important interview point:

Encapsulation adds headers while going down the protocol stack. Decapsulation removes headers while going up the stack.

---

# 9. Main Roles of Important Layers

The user specifically asked for Application, Transport, Network, and Data-Link roles. These are extremely important for placements.

---

## 9.1 Application Layer Roles

The Application layer provides services that allow user applications to communicate over the network.

Major roles:

### 1. User Network Services

It provides services for:

- Web access
- Email
- File transfer
- Remote login
- Name resolution
- Network management

Example:

A browser uses HTTP or HTTPS to communicate with a web server.

### 2. Protocol-Specific Communication

Every application-level task has a protocol.

Examples:

- Web pages: HTTP/HTTPS
- Email sending: SMTP
- Email retrieval: POP3/IMAP
- File transfer: FTP
- Domain resolution: DNS

### 3. Name Resolution

DNS converts human-readable domain names into IP addresses.

Example:

`www.google.com` -> IP address

### 4. Resource Sharing

The Application layer allows systems to share files, printers, databases, and other resources.

### 5. Authentication and Authorization

Some application protocols support login, authentication, tokens, or access permissions.

### 6. Data Exchange Rules

The Application layer defines request and response formats.

Example:

In HTTP:

- Client sends request.
- Server sends response.

Interview line:

The Application layer is responsible for providing network services directly to user applications using protocols such as HTTP, FTP, SMTP, DNS, and DHCP.

---

## 9.2 Transport Layer Roles

The Transport layer is one of the most important layers for interviews.

It provides end-to-end or process-to-process communication.

Major roles:

### 1. Process-to-Process Delivery

The Network layer delivers data to the destination host, but the Transport layer delivers it to the correct process on that host.

It uses port numbers for this.

Example:

On the same computer:

- Browser may use port 443 for HTTPS.
- DNS may use port 53.
- SSH may use port 22.

### 2. Segmentation and Reassembly

Large data is divided into smaller segments before transmission.

At the receiver side, segments are reassembled into the original data.

### 3. Multiplexing and Demultiplexing

Multiplexing:

Multiple applications can send data through the network at the same time.

Demultiplexing:

Received data is delivered to the correct application using port numbers.

### 4. Reliable Data Transfer

TCP provides reliable data transfer using:

- Sequence numbers
- Acknowledgements
- Retransmission
- Checksums
- Timers

### 5. Flow Control

Flow control prevents a fast sender from overwhelming a slow receiver.

TCP uses a receive window for flow control.

### 6. Congestion Control

Congestion control prevents too much traffic from overloading the network.

TCP uses algorithms such as:

- Slow start
- Congestion avoidance
- Fast retransmit
- Fast recovery

### 7. Connection Management

TCP establishes and terminates connections.

TCP connection establishment uses the three-way handshake.

Interview line:

The Transport layer provides process-to-process communication using port numbers and ensures reliable delivery, flow control, and congestion control when TCP is used.

---

## 9.3 Network Layer Roles

The Network layer delivers packets from source host to destination host across multiple networks.

Major roles:

### 1. Logical Addressing

The Network layer uses IP addresses.

IP addresses identify hosts logically.

### 2. Routing

Routing means selecting the best path from source to destination.

Routers use routing tables to forward packets.

### 3. Packet Forwarding

Each router receives a packet, checks the destination IP address, and forwards the packet to the next hop.

### 4. Internetworking

The Network layer allows different networks to communicate with each other.

Example:

Your home Wi-Fi network can communicate with a server in another country because of Network layer routing.

### 5. Fragmentation

In IPv4, if a packet is larger than the Maximum Transmission Unit of a link, it may be fragmented.

MTU stands for Maximum Transmission Unit.

IPv6 does not allow routers to fragment packets; fragmentation is handled by the source host.

### 6. Error Reporting

ICMP is used for error reporting and diagnostics.

Examples:

- Destination unreachable
- Time exceeded
- Ping
- Traceroute

Interview line:

The Network layer is responsible for logical addressing, routing, and host-to-host delivery across different networks.

---

## 9.4 Data-Link Layer Roles

The Data-Link layer provides reliable or controlled transfer of frames between directly connected nodes.

Major roles:

### 1. Framing

It converts packets into frames.

Frames make it easier to identify the start and end of transmitted data.

### 2. Physical Addressing

It uses MAC addresses for local delivery.

Source and destination MAC addresses are added to the frame.

### 3. Error Detection

The Data-Link layer detects errors using methods such as CRC.

If an error is detected, the frame is usually discarded.

### 4. Media Access Control

It decides how devices share the transmission medium.

This is important in broadcast networks like Ethernet and Wi-Fi.

Examples:

- Ethernet historically used CSMA/CD.
- Wi-Fi uses CSMA/CA.

### 5. Flow Control

Some Data-Link protocols provide flow control between adjacent nodes.

### 6. Local Delivery

The Data-Link layer handles delivery within the same LAN or between directly connected devices.

Interview line:

The Data-Link layer is responsible for node-to-node delivery, framing, MAC addressing, media access control, and error detection.

---

# 10. Important Protocols and Port Numbers

| Protocol | Port Number | Transport Protocol | Use |
|---|---:|---|---|
| HTTP | 80 | TCP | Web |
| HTTPS | 443 | TCP | Secure web |
| FTP Data | 20 | TCP | FTP data transfer |
| FTP Control | 21 | TCP | FTP control |
| SSH | 22 | TCP | Secure remote login |
| Telnet | 23 | TCP | Remote login, insecure |
| SMTP | 25 | TCP | Email sending |
| DNS | 53 | UDP/TCP | Name resolution |
| DHCP Server | 67 | UDP | Dynamic IP assignment |
| DHCP Client | 68 | UDP | Dynamic IP assignment |
| TFTP | 69 | UDP | Simple file transfer |
| POP3 | 110 | TCP | Email retrieval |
| IMAP | 143 | TCP | Email access |
| SNMP | 161 | UDP | Network management |
| RDP | 3389 | TCP/UDP | Remote desktop |

---

# 11. Common Placement Questions

## Q1. What is the OSI model?

The OSI model is a 7-layer reference model that explains how data is transmitted from one computer to another over a network. The layers are Application, Presentation, Session, Transport, Network, Data-Link, and Physical.

## Q2. What is the TCP/IP model?

The TCP/IP model is the practical model used for internet communication. It usually has 4 layers: Application, Transport, Internet, and Network Access.

## Q3. Difference between OSI and TCP/IP?

OSI is a theoretical 7-layer reference model, while TCP/IP is a practical 4-layer model used on the internet. OSI separates Application, Presentation, and Session layers, while TCP/IP combines them into the Application layer.

## Q4. Which layer is responsible for routing?

The Network layer is responsible for routing.

## Q5. Which layer uses IP addresses?

The Network layer uses IP addresses.

## Q6. Which layer uses MAC addresses?

The Data-Link layer uses MAC addresses.

## Q7. Which layer uses port numbers?

The Transport layer uses port numbers.

## Q8. Which layer is responsible for error detection?

Error detection can happen at multiple layers, but the Data-Link layer commonly performs frame-level error detection using CRC.

## Q9. Which layer is responsible for encryption?

In the OSI model, encryption is associated with the Presentation layer. In the real TCP/IP model, encryption such as TLS is implemented between the Application and Transport layers.

## Q10. What is encapsulation?

Encapsulation is the process of adding headers and trailers to data as it moves down the layers of the network model.

## Q11. What is decapsulation?

Decapsulation is the process of removing headers and trailers as data moves up the layers at the receiver side.

## Q12. What is the difference between a packet and a frame?

A packet is the data unit of the Network layer and contains IP addresses. A frame is the data unit of the Data-Link layer and contains MAC addresses.

## Q13. What is the difference between switch and router?

A switch connects devices within the same LAN and uses MAC addresses. A router connects different networks and uses IP addresses.

## Q14. What is the difference between TCP and UDP?

TCP is connection-oriented, reliable, ordered, and slower. UDP is connectionless, faster, lightweight, and does not guarantee delivery.

## Q15. Why is DNS usually UDP?

DNS usually uses UDP because DNS queries and responses are small and UDP has low overhead. DNS can also use TCP for large responses and zone transfers.

---

# 12. Layer-Wise Summary Table

| Layer | Main Role | Address/Data | Protocols/Devices |
|---|---|---|---|
| Application | User network services | Data | HTTP, FTP, SMTP, DNS |
| Presentation | Data format, encryption, compression | Data | JPEG, TLS conceptually |
| Session | Session management | Data | RPC, NetBIOS concepts |
| Transport | Process-to-process delivery | Ports, segments | TCP, UDP |
| Network | Host-to-host delivery and routing | IP, packets | IP, ICMP, routers |
| Data-Link | Node-to-node delivery | MAC, frames | Ethernet, switches |
| Physical | Bit transmission | Bits | Cables, hubs, repeaters |

---

# 13. Quick Memory Map

| Concept | Layer |
|---|---|
| HTTP | Application |
| DNS | Application |
| Encryption in OSI | Presentation |
| Dialog control | Session |
| TCP | Transport |
| UDP | Transport |
| Port number | Transport |
| IP address | Network |
| Routing | Network |
| Router | Network |
| Packet | Network |
| MAC address | Data-Link |
| Switch | Data-Link |
| Frame | Data-Link |
| CRC | Data-Link |
| Bits | Physical |
| Hub | Physical |

---

# 14. Example: Opening a Website

Suppose you enter:

`https://www.example.com`

What happens?

1. Application layer uses DNS to resolve the domain name to an IP address.
2. Application layer prepares an HTTPS request.
3. Transport layer uses TCP and establishes a connection using three-way handshake.
4. TLS secures the communication for HTTPS.
5. Transport layer segments the data and adds port numbers.
6. Network layer adds source and destination IP addresses.
7. Data-Link layer adds source and destination MAC addresses.
8. Physical layer transmits bits through cable, fiber, or wireless medium.
9. Routers forward packets based on IP addresses.
10. Switches forward frames based on MAC addresses.
11. At the destination, decapsulation happens.
12. The web server processes the request and sends a response back.

---

# 15. Most Important One-Line Answers

- OSI model has 7 layers.
- TCP/IP model usually has 4 layers.
- Application layer provides network services to user applications.
- Presentation layer handles data format, encryption, and compression.
- Session layer manages sessions and synchronization.
- Transport layer provides process-to-process communication.
- Network layer provides host-to-host communication across networks.
- Data-Link layer provides node-to-node communication.
- Physical layer transmits raw bits.
- TCP is reliable and connection-oriented.
- UDP is fast and connectionless.
- IP is responsible for logical addressing and routing.
- MAC address is used for local delivery.
- Port number identifies a process or service.
- Router uses IP address.
- Switch uses MAC address.
- Packet belongs to Network layer.
- Frame belongs to Data-Link layer.
- Segment belongs to Transport layer.
- Bit belongs to Physical layer.

---

# 16. Short Comparison: Host-to-Host, Process-to-Process, Node-to-Node

| Term | Layer | Meaning |
|---|---|---|
| Process-to-process | Transport | Delivery to the correct application process using ports |
| Host-to-host | Network | Delivery from source host to destination host using IP |
| Node-to-node | Data-Link | Delivery between directly connected devices using MAC |

Example:

When your browser contacts a web server:

- Network layer gets the packet to the correct server.
- Transport layer gets the data to the correct server process, such as HTTPS on port 443.
- Data-Link layer moves frames between neighboring devices on each local link.

---

# 17. Final Placement Revision Table

| Question | Answer |
|---|---|
| How many layers in OSI? | 7 |
| How many layers in TCP/IP? | Usually 4 |
| Which layer has HTTP? | Application |
| Which layer has TCP? | Transport |
| Which layer has IP? | Network/Internet |
| Which layer has Ethernet? | Data-Link and Physical |
| Which layer uses ports? | Transport |
| Which layer uses IP address? | Network |
| Which layer uses MAC address? | Data-Link |
| Which layer does routing? | Network |
| Which device uses MAC table? | Switch |
| Which device uses routing table? | Router |
| TCP or UDP for reliability? | TCP |
| TCP or UDP for speed? | UDP |
| Data unit at Transport layer? | Segment/datagram |
| Data unit at Network layer? | Packet |
| Data unit at Data-Link layer? | Frame |
| Data unit at Physical layer? | Bit |

