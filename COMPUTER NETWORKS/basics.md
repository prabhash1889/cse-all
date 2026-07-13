# Computer Networks Basics

This note covers the most common placement-interview basics:

- LAN and WAN
- Client-server architecture
- Peer-to-peer architecture
- Bandwidth
- Latency
- Throughput

The goal is to know the definition, real-world examples, differences, advantages, limitations, and the kind of answers interviewers expect.

---

## 1. Computer Network

A computer network is a group of devices connected together so they can communicate and share resources.

Examples of devices in a network:

- Computers
- Smartphones
- Servers
- Printers
- Routers
- Switches
- IoT devices

Examples of shared resources:

- Files
- Internet connection
- Printers
- Databases
- Applications
- Storage

### Simple Definition

A computer network allows two or more devices to exchange data using communication links.

### Why Networks Are Used

- To share data
- To share hardware resources
- To communicate quickly
- To access remote services
- To centralize storage and management
- To reduce cost by sharing infrastructure

---

# LAN and WAN

## 2. LAN

LAN stands for Local Area Network.

A LAN is a network that connects devices within a small geographical area.

Examples:

- Home Wi-Fi network
- School computer lab
- Office network
- College department network
- Library network

### Key Features of LAN

- Covers a small area
- Usually privately owned
- High speed
- Low latency
- Lower cost compared to WAN
- Easier to manage and troubleshoot
- Commonly uses Ethernet or Wi-Fi

### Common LAN Devices

- Switch
- Router
- Access point
- Ethernet cables
- Network interface card

### LAN Technologies

#### Ethernet

Ethernet is commonly used for wired LANs.

It uses cables such as twisted-pair cables and usually connects devices through switches.

Common Ethernet speeds:

- 100 Mbps
- 1 Gbps
- 10 Gbps

#### Wi-Fi

Wi-Fi is used for wireless LANs.

It allows devices to connect without cables using radio waves.

### LAN Example

In a college lab, 40 computers are connected to a switch. The switch is connected to a router. All computers can share files, access the internet, and use a common printer. This is a LAN.

### Advantages of LAN

- Fast data transfer
- Easy sharing of files and printers
- Lower setup cost for small areas
- Easy centralized control
- Low error rate compared to long-distance networks

### Disadvantages of LAN

- Limited geographical coverage
- Requires maintenance
- Security is needed to prevent unauthorized access
- If central devices fail, communication may be affected

---

## 3. WAN

WAN stands for Wide Area Network.

A WAN connects devices or networks over a large geographical area.

Examples:

- Internet
- Bank branches connected across cities
- Company offices connected across countries
- Railway reservation network
- ATM network

### Key Features of WAN

- Covers a large geographical area
- Connects multiple LANs
- Usually uses public or leased communication infrastructure
- Slower than LAN in many cases
- Higher latency than LAN
- More expensive to set up and maintain
- Requires routers and communication service providers

### WAN Example

A company has offices in Delhi, Mumbai, Bengaluru, and Chennai. Each office has its own LAN. These LANs are connected using leased lines, VPNs, or other WAN technologies. This whole network is a WAN.

### WAN Technologies

- Leased lines
- MPLS
- VPN
- Satellite communication
- Fiber optic links
- Cellular networks

### Advantages of WAN

- Connects users over long distances
- Enables communication between different branches
- Supports centralized data access
- Allows remote work and global business operations
- Connects multiple LANs together

### Disadvantages of WAN

- Higher cost
- Higher latency
- More complex management
- More security risks
- Depends on service providers
- Troubleshooting can be harder

---

## 4. LAN vs WAN

| Feature | LAN | WAN |
|---|---|---|
| Full form | Local Area Network | Wide Area Network |
| Area covered | Small area | Large area |
| Example | Home Wi-Fi, office network | Internet, bank network |
| Speed | Usually high | Usually lower than LAN |
| Latency | Low | Higher |
| Ownership | Usually private | Private plus public/service-provider infrastructure |
| Cost | Lower | Higher |
| Devices used | Switches, access points, routers | Routers, leased lines, service-provider equipment |
| Complexity | Less complex | More complex |
| Error rate | Lower | Higher compared to LAN |

### Interview Answer: Difference Between LAN and WAN

LAN is a network that covers a small geographical area such as a home, office, or college lab, while WAN covers a large geographical area such as cities, countries, or the entire world. LAN usually provides higher speed and lower latency because devices are physically close, whereas WAN has higher latency and more complex infrastructure because it connects distant networks. The internet is the largest example of a WAN.

---

# Client-Server Architecture

## 5. Client-Server Model

Client-server architecture is a network model where clients request services and servers provide those services.

### Client

A client is a device or program that requests a service.

Examples:

- Web browser
- Email app
- Mobile banking app
- Online shopping app
- Game client

### Server

A server is a device or program that provides services to clients.

Examples:

- Web server
- Database server
- Mail server
- File server
- DNS server

### Simple Example

When you open `www.google.com` in a browser:

1. Your browser acts as the client.
2. It sends a request to Google's web server.
3. The server processes the request.
4. The server sends back the web page.
5. Your browser displays the result.

### Basic Flow

```text
Client ---- request ----> Server
Client <--- response ---- Server
```

### Real-World Examples

#### Web Browsing

- Client: Browser
- Server: Web server
- Protocol: HTTP or HTTPS

#### Email

- Client: Gmail app, Outlook, webmail
- Server: Mail server
- Protocols: SMTP, IMAP, POP3

#### Database Application

- Client: Application frontend
- Server: Database server
- Example: A banking app requesting account balance

#### File Sharing in an Office

- Client: Employee computer
- Server: File server
- Service: Shared documents and folders

---

## 6. Characteristics of Client-Server Architecture

- Centralized service provider
- Clients depend on the server
- Server usually has more processing power and storage
- Server can manage authentication and permissions
- Easy to update and control data centrally
- Server failure can affect many clients

### Advantages

#### Centralized Management

Data and services are managed in one central place.

Example: In a company, employee records can be stored on a central server.

#### Better Security Control

Authentication, authorization, and access control can be handled centrally.

Example: Only HR employees can access salary records.

#### Easier Backup

Since data is stored centrally, backup becomes easier.

#### Scalability

Servers can be upgraded to handle more clients.

#### Data Consistency

All clients access the same central data, so duplicate and inconsistent copies are reduced.

### Disadvantages

#### Server Failure

If the server goes down, clients may not be able to access the service.

#### Network Dependency

Clients need a working network connection to communicate with the server.

#### Cost

Dedicated servers, maintenance, cooling, backup, and security can be expensive.

#### Bottleneck

If many clients send requests at the same time, the server may become overloaded.

---

## 7. Types of Servers

### Web Server

Delivers web pages to clients.

Example software:

- Apache
- Nginx
- Microsoft IIS

### Database Server

Stores and manages databases.

Example software:

- MySQL
- PostgreSQL
- Oracle Database
- MongoDB

### File Server

Stores and shares files across a network.

### Mail Server

Sends, receives, and stores email.

### DNS Server

Converts domain names into IP addresses.

Example:

```text
www.example.com -> 93.184.216.34
```

### Application Server

Runs application logic and business rules.

Example: A banking server that validates transactions.

---

## 8. Thin Client vs Thick Client

### Thin Client

A thin client depends heavily on the server for processing.

Example:

- Browser-based applications
- Cloud apps

Advantages:

- Easier to maintain
- Less powerful client hardware needed
- Centralized updates

Disadvantages:

- More dependent on network and server

### Thick Client

A thick client performs more processing on the client side.

Example:

- Desktop software
- Some games
- Offline-capable apps

Advantages:

- Can work with less server dependency
- Better local performance for some tasks

Disadvantages:

- Harder to update on many machines
- More powerful client hardware may be needed

---

# Peer-to-Peer Architecture

## 9. Peer-to-Peer Model

Peer-to-peer is a network model where each device can act as both client and server.

In peer-to-peer architecture, there is no strict central server. Each node, called a peer, can request resources and also provide resources.

### Simple Definition

In peer-to-peer networking, every computer can directly share resources with other computers.

### Basic Flow

```text
Peer A <---- data ----> Peer B
Peer A <---- data ----> Peer C
Peer B <---- data ----> Peer C
```

### Examples

- BitTorrent
- Blockchain networks
- Small home file sharing
- Some multiplayer game discovery systems
- Direct device-to-device sharing

---

## 10. Characteristics of Peer-to-Peer Networks

- No dedicated central server required
- Each peer can share resources
- Each peer can consume resources
- Management is decentralized
- Easy to set up for small networks
- Can become difficult to manage at large scale

### Advantages

#### Low Cost

No dedicated server is required.

#### Easy Setup

Useful for small networks where users want to share files or printers.

#### Resource Sharing

Each device contributes resources like storage, files, or processing power.

#### No Single Central Failure Point

If one peer goes down, others may still communicate.

This depends on the design. Some peer-to-peer systems may still depend on trackers, discovery servers, or special nodes.

### Disadvantages

#### Weak Central Control

No central administrator means security and permissions can be harder to enforce.

#### Backup Problems

Data may be spread across many devices, making backup harder.

#### Security Risk

Each peer may expose files or services to others.

#### Performance Variation

Performance depends on the speed and availability of individual peers.

#### Harder Management

In large networks, managing users, permissions, updates, and data consistency becomes difficult.

---

## 11. Client-Server vs Peer-to-Peer

| Feature | Client-Server | Peer-to-Peer |
|---|---|---|
| Main idea | Clients request, server responds | Every node can request and provide |
| Central server | Required | Not strictly required |
| Control | Centralized | Decentralized |
| Cost | Higher | Lower |
| Security management | Easier | Harder |
| Backup | Easier | Harder |
| Scalability | Good with proper server design | Can scale well in some systems but harder to control |
| Example | Web apps, banking systems | BitTorrent, blockchain |
| Failure impact | Server failure can affect all clients | One peer failure may not stop the whole network |

### Interview Answer: Client-Server vs Peer-to-Peer

In client-server architecture, clients request services from a central server, which manages data, security, and processing. It is easier to control and secure, but server failure can affect all clients. In peer-to-peer architecture, every node can act as both client and server. It is cheaper and decentralized, but security, backup, and management are harder.

---

# Bandwidth, Latency, and Throughput

These three terms are often confused in interviews. They are related, but they do not mean the same thing.

---

## 12. Bandwidth

Bandwidth is the maximum amount of data that can be transmitted over a network link per unit time.

It is like the capacity of the network connection.

### Units of Bandwidth

Bandwidth is usually measured in:

- bps: bits per second
- Kbps: kilobits per second
- Mbps: megabits per second
- Gbps: gigabits per second

### Important

Bandwidth is measured in bits, not bytes.

```text
1 byte = 8 bits
```

So:

```text
100 Mbps = 100 megabits per second
100 Mbps = 12.5 megabytes per second maximum theoretical transfer rate
```

### Simple Analogy

Bandwidth is like the width of a road.

A wider road can allow more vehicles to pass at the same time. Similarly, higher bandwidth allows more data to be transmitted per second.

### Example

If your internet plan says 100 Mbps, it means your connection can theoretically carry up to 100 million bits per second.

But your actual download speed may be lower because of:

- Network congestion
- Server speed
- Wi-Fi signal strength
- Protocol overhead
- Packet loss
- Distance
- Router limitations

---

## 13. Latency

Latency is the time taken for data to travel from source to destination.

It is usually measured in milliseconds.

### Simple Definition

Latency is delay.

### Example

If you ping a server and get:

```text
Reply time = 40 ms
```

That means the round-trip time between your device and the server is around 40 milliseconds.

### Round-Trip Time

Round-trip time is the time taken for a packet to go from source to destination and for the response to come back.

```text
Client ---- packet ----> Server
Client <--- reply ------ Server
```

### Causes of Latency

#### Propagation Delay

Time taken for a signal to physically travel through the medium.

Depends on distance and signal speed.

#### Transmission Delay

Time taken to push all bits of a packet onto the link.

Formula:

```text
Transmission delay = Packet size / Bandwidth
```

#### Processing Delay

Time taken by routers, switches, or hosts to process packet headers, check errors, and decide forwarding.

#### Queuing Delay

Time a packet waits in a queue before being transmitted.

This increases during congestion.

### Why Latency Matters

Latency is very important for:

- Online gaming
- Video calls
- Voice calls
- Remote desktop
- Stock trading systems
- Web browsing responsiveness
- Real-time applications

### High Bandwidth Does Not Always Mean Low Latency

A connection can have high bandwidth but still high latency.

Example:

A satellite internet link may have high bandwidth, but because the signal travels a long distance to satellites and back, latency can be high.

---

## 14. Throughput

Throughput is the actual amount of data successfully transferred per unit time.

It is the real achieved data transfer rate.

### Simple Definition

Throughput is the actual speed you get.

### Bandwidth vs Throughput

Bandwidth is the maximum possible capacity.

Throughput is the actual performance achieved.

Example:

Your internet plan is 100 Mbps, but during a speed test you get 72 Mbps. Here:

```text
Bandwidth = 100 Mbps
Throughput = 72 Mbps
```

### Why Throughput Is Lower Than Bandwidth

Throughput can be lower due to:

- Network congestion
- Packet loss
- Protocol overhead
- Server limitations
- Router or switch limitations
- Wi-Fi interference
- Long distance
- Firewall inspection
- TCP congestion control
- Poor cables or weak signal

### Goodput

Goodput is the amount of useful application data delivered per unit time.

Throughput may include protocol overhead, retransmissions, and headers. Goodput counts only useful payload data.

Example:

When downloading a file, goodput is the rate at which actual file data is delivered, excluding headers and retransmitted packets.

---

## 15. Bandwidth vs Latency vs Throughput

| Term | Meaning | Unit | Simple Analogy |
|---|---|---|---|
| Bandwidth | Maximum capacity of link | bps, Mbps, Gbps | Width of road |
| Latency | Delay in data travel | ms | Travel time |
| Throughput | Actual successful data rate | bps, Mbps, Gbps | Actual traffic flow |

### Example Scenario

Suppose you have a 100 Mbps internet connection.

- Bandwidth: 100 Mbps
- Latency to a website: 50 ms
- Throughput while downloading: 75 Mbps

This means the connection can theoretically carry 100 Mbps, a packet takes around 50 ms for the measured trip, and your actual download rate is 75 Mbps.

---

## 16. Common Interview Confusions

### Confusion 1: Bandwidth and Speed Are Same

Not exactly.

Bandwidth is capacity. Speed usually refers to how fast data appears to transfer, which depends on throughput and latency.

### Confusion 2: More Bandwidth Always Reduces Latency

False.

Increasing bandwidth can reduce transmission delay, especially for large packets or large transfers, but it does not greatly reduce propagation delay.

Distance still matters.

### Confusion 3: Throughput Equals Bandwidth

False.

Throughput is usually less than bandwidth because real networks have overhead, congestion, and packet loss.

### Confusion 4: Low Latency Is Only Needed for Games

False.

Low latency is also important for:

- Video conferencing
- Voice over IP
- Remote surgery
- Online trading
- Cloud gaming
- Interactive web apps
- Remote desktop

---

## 17. Important Formulas

### Convert Bits to Bytes

```text
Bytes = Bits / 8
```

Example:

```text
80 Mbps = 10 MB/s
```

### Transmission Delay

```text
Transmission delay = Packet size / Bandwidth
```

Example:

A packet of 1,000 bits is sent over a 1 Mbps link.

```text
Transmission delay = 1,000 / 1,000,000
Transmission delay = 0.001 seconds
Transmission delay = 1 ms
```

### File Download Time

```text
Download time = File size / Throughput
```

Example:

A 100 MB file is downloaded over an actual throughput of 10 MB/s.

```text
Download time = 100 / 10
Download time = 10 seconds
```

### Bandwidth-Delay Product

Bandwidth-delay product is the amount of data that can be "in flight" on a network path.

Formula:

```text
Bandwidth-delay product = Bandwidth x Round-trip time
```

This is important in high-speed long-distance networks.

Example:

If bandwidth is 100 Mbps and RTT is 100 ms:

```text
BDP = 100,000,000 bits/s x 0.1 s
BDP = 10,000,000 bits
BDP = 1.25 MB
```

This means about 1.25 MB of data can be in transit at once.

---

## 18. Practical Examples

### Example 1: Video Call

A video call needs:

- Enough bandwidth for audio and video
- Low latency for natural conversation
- Stable throughput to avoid freezing
- Low packet loss

If bandwidth is high but latency is very high, people may talk over each other because responses are delayed.

### Example 2: File Download

A file download mainly needs high throughput.

Latency matters less after the download starts, but high latency can affect connection setup and TCP performance.

### Example 3: Online Gaming

Online gaming usually does not need huge bandwidth, but it needs low latency and low jitter.

Jitter means variation in latency.

Example:

- 30 ms latency is good
- 300 ms latency feels laggy
- Latency changing from 30 ms to 250 ms repeatedly causes unstable gameplay

### Example 4: Web Browsing

Web browsing depends on both latency and throughput.

Many small requests are made for HTML, CSS, JavaScript, images, fonts, and APIs. High latency can make pages feel slow even if bandwidth is high.

---

## 19. Related Terms

### Jitter

Jitter is the variation in latency over time.

Example:

If packet delays are 20 ms, 25 ms, 22 ms, and 200 ms, the connection has high jitter.

Jitter affects:

- Voice calls
- Video calls
- Gaming
- Live streaming

### Packet Loss

Packet loss happens when data packets fail to reach the destination.

Causes:

- Congestion
- Weak Wi-Fi signal
- Faulty cables
- Router overload
- Network errors

Effects:

- Retransmission
- Lower throughput
- Poor call quality
- Lag in games

### Congestion

Congestion happens when too much traffic enters the network and devices cannot handle it quickly.

Effects:

- Increased latency
- Increased packet loss
- Reduced throughput

### Bottleneck

A bottleneck is the slowest part of a network path.

Example:

If your laptop supports 1 Gbps, your router supports 1 Gbps, but your internet plan is 100 Mbps, then the internet connection is the bottleneck.

---

## 20. Placement Interview Questions

### Q1. What is a LAN?

A LAN, or Local Area Network, connects devices within a small geographical area such as a home, office, or college lab. It usually provides high speed, low latency, and is privately managed.

### Q2. What is a WAN?

A WAN, or Wide Area Network, connects networks over large geographical areas such as cities, countries, or continents. The internet is the largest example of a WAN.

### Q3. What is the main difference between LAN and WAN?

LAN covers a small area and usually has high speed and low latency. WAN covers a large area, connects multiple LANs, and usually has higher latency and more complex infrastructure.

### Q4. What is client-server architecture?

Client-server architecture is a model where clients request services and servers provide those services. A browser requesting a web page from a web server is a common example.

### Q5. What is peer-to-peer architecture?

Peer-to-peer architecture is a model where each node can act as both client and server. Peers can directly share resources without depending on one central server.

### Q6. Give examples of client-server applications.

Examples include web browsing, email, online banking, cloud storage, database applications, and online shopping systems.

### Q7. Give examples of peer-to-peer systems.

Examples include BitTorrent, blockchain networks, and small local file-sharing systems.

### Q8. What is bandwidth?

Bandwidth is the maximum amount of data that can be transmitted over a network link per unit time. It is usually measured in bps, Mbps, or Gbps.

### Q9. What is latency?

Latency is the delay experienced by data while traveling from source to destination. It is usually measured in milliseconds.

### Q10. What is throughput?

Throughput is the actual amount of data successfully transferred over a network per unit time.

### Q11. Why is throughput usually less than bandwidth?

Throughput is usually less than bandwidth because of congestion, protocol overhead, packet loss, retransmissions, server limitations, device limitations, and interference.

### Q12. Can a network have high bandwidth but high latency?

Yes. Satellite internet can have high bandwidth but high latency because signals travel a long distance.

### Q13. Which is more important for online gaming: bandwidth or latency?

Latency is usually more important for online gaming. Games require quick response times and stable delay. Very high bandwidth is not useful if latency is poor.

### Q14. Which is more important for downloading large files?

Throughput is most important for large file downloads because it determines the actual data transfer rate.

### Q15. What is jitter?

Jitter is variation in latency. It causes unstable audio, video, and gaming performance.

---

## 21. Quick Revision Table

| Concept | One-line Meaning | Example |
|---|---|---|
| LAN | Network in a small area | Office Wi-Fi |
| WAN | Network across large areas | Internet |
| Client | Requests a service | Browser |
| Server | Provides a service | Web server |
| Client-server | Central server serves many clients | Online banking |
| Peer-to-peer | Each node can serve and request | BitTorrent |
| Bandwidth | Maximum link capacity | 100 Mbps plan |
| Latency | Delay | 40 ms ping |
| Throughput | Actual transfer rate | 72 Mbps speed test |
| Jitter | Variation in delay | Unstable video call |
| Packet loss | Packets fail to arrive | Choppy audio |

---

## 22. Memory Tricks

### LAN vs WAN

```text
LAN = Local = nearby
WAN = Wide = far away
```

### Bandwidth vs Throughput

```text
Bandwidth = promised/maximum capacity
Throughput = actual achieved rate
```

### Latency

```text
Latency = lag/delay
```

### Client-Server

```text
Client asks.
Server answers.
```

### Peer-to-Peer

```text
Everyone can ask.
Everyone can answer.
```

---

## 23. Common One-Minute Interview Explanation

Computer networks connect devices so they can exchange data and share resources. A LAN is a local network within a small area such as a home or office, while a WAN connects networks over large geographical areas, with the internet being the largest example. In client-server architecture, clients request services from a centralized server, which makes management and security easier but creates dependency on the server. In peer-to-peer architecture, every node can act as both client and server, making it cheaper and decentralized but harder to manage securely. Bandwidth is the maximum capacity of a link, latency is the delay in communication, and throughput is the actual successful data transfer rate achieved in real conditions.

---

## 24. Practice Problems

### Problem 1

Your internet plan is 200 Mbps, but your speed test shows 150 Mbps.

Identify:

- Bandwidth
- Throughput

Answer:

- Bandwidth = 200 Mbps
- Throughput = 150 Mbps

### Problem 2

A company connects its office computers using switches inside one building.

Is this LAN or WAN?

Answer:

This is a LAN because it covers a small geographical area.

### Problem 3

A company connects its Delhi office and Mumbai office over a private leased line.

Is this LAN or WAN?

Answer:

This is a WAN because it connects networks across a large geographical area.

### Problem 4

You open a browser and request a web page from a website.

Which is the client and which is the server?

Answer:

- Client = Browser
- Server = Website's web server

### Problem 5

A file is shared directly from one laptop to another without a dedicated server.

Which architecture is this?

Answer:

This is peer-to-peer architecture.

### Problem 6

A 500 MB file is downloaded at an actual throughput of 25 MB/s.

How much time will it take?

```text
Download time = File size / Throughput
Download time = 500 / 25
Download time = 20 seconds
```

Answer:

20 seconds.

---

## 25. Final Exam-Style Summary

LAN and WAN describe network size and geographical coverage. LAN is local, faster, cheaper, and easier to manage. WAN is wide-area, more expensive, more complex, and connects multiple LANs across large distances.

Client-server and peer-to-peer describe how devices cooperate. In client-server, clients depend on servers for services. In peer-to-peer, every device can act as both service requester and service provider.

Bandwidth, latency, and throughput describe network performance. Bandwidth is the maximum capacity, latency is the delay, and throughput is the actual achieved transfer rate. A good network needs enough bandwidth, low latency, stable throughput, low jitter, and low packet loss.
