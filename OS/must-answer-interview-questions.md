# Must-Answer Operating Systems Interview Questions

## OS Fundamentals

1. What is an operating system?
2. Why do we need an operating system?
3. What are the main functions of an operating system?
4. What are the goals of an operating system?
5. What is the difference between hardware and software?
6. What is system software?
7. What is application software?
8. What is the difference between system software and application software?
9. What is a kernel?
10. What is the role of the kernel in an operating system?
11. What is a shell?
12. What is the difference between kernel and shell?
13. What is a command-line interface?
14. What is a graphical user interface?
15. What is batch processing?
16. What is multiprogramming?
17. What is multitasking?
18. What is multiprocessing?
19. What is multithreading?
20. What is time sharing?
21. What is real-time operating system?
22. What is distributed operating system?
23. What is network operating system?
24. What is embedded operating system?
25. What is mobile operating system?
26. What is the difference between 32-bit and 64-bit operating systems?
27. What is booting?
28. What happens during system boot?
29. What is BIOS?
30. What is UEFI?
31. What is bootloader?
32. What is firmware?
33. What is system call?
34. Why are system calls required?
35. What is an interrupt?
36. What is a trap?
37. What is the difference between interrupt and trap?
38. What is polling?
39. What is the difference between polling and interrupt?
40. What is context switching?
41. Why is context switching expensive?
42. What is kernel mode?
43. What is user mode?
44. Why do operating systems have user mode and kernel mode?
45. What is dual-mode operation?
46. What is privileged instruction?
47. What happens if a user program tries to execute a privileged instruction?
48. What is monolithic kernel?
49. What is microkernel?
50. What is hybrid kernel?
51. What is layered operating system structure?
52. What is modular operating system structure?
53. What are the advantages of a microkernel?
54. What are the disadvantages of a microkernel?
55. What are the advantages of a monolithic kernel?
56. What are the disadvantages of a monolithic kernel?
57. What is virtualization?
58. What is a virtual machine?
59. What is hypervisor?
60. What is the difference between type 1 and type 2 hypervisors?

## Processes

1. What is a process?
2. What is a program?
3. What is the difference between a program and a process?
4. What are the different states of a process?
5. What is the new state of a process?
6. What is the ready state of a process?
7. What is the running state of a process?
8. What is the waiting or blocked state of a process?
9. What is the terminated state of a process?
10. What is suspended ready state?
11. What is suspended blocked state?
12. What is process state transition?
13. What is Process Control Block?
14. What information is stored in a PCB?
15. Why is PCB important?
16. What is process ID?
17. What is parent process?
18. What is child process?
19. What is process creation?
20. What is process termination?
21. What is orphan process?
22. What is zombie process?
23. What is daemon process?
24. What is foreground process?
25. What is background process?
26. What is independent process?
27. What is cooperating process?
28. What is CPU-bound process?
29. What is I/O-bound process?
30. What is process hierarchy?
31. What is process table?
32. What is long-term scheduler?
33. What is short-term scheduler?
34. What is medium-term scheduler?
35. What is dispatcher?
36. What is dispatch latency?
37. What is process scheduling?
38. What is preemptive scheduling?
39. What is non-preemptive scheduling?
40. What is process starvation?
41. What is aging?
42. What is process migration?
43. What is process swapping?
44. What is a ready queue?
45. What is a job queue?
46. What is a device queue?
47. What is turnaround time?
48. What is waiting time?
49. What is response time?
50. What is throughput?
51. What is CPU utilization?
52. What is arrival time?
53. What is burst time?
54. What is completion time?
55. What is priority of a process?
56. How does the OS decide which process runs next?
57. Why is process isolation important?
58. How do processes communicate with each other?
59. What are the advantages of cooperating processes?
60. What are the disadvantages of cooperating processes?

## Threads

1. What is a thread?
2. What is the difference between process and thread?
3. Why are threads called lightweight processes?
4. What resources are shared between threads of the same process?
5. What resources are private to each thread?
6. What is multithreading?
7. What are the advantages of multithreading?
8. What are the disadvantages of multithreading?
9. What is user-level thread?
10. What is kernel-level thread?
11. What is the difference between user-level and kernel-level threads?
12. What is many-to-one threading model?
13. What is one-to-one threading model?
14. What is many-to-many threading model?
15. What is thread library?
16. What is thread scheduling?
17. What is thread synchronization?
18. What is thread safety?
19. What is thread pool?
20. Why are thread pools used?
21. What is a race condition in multithreading?
22. What is a critical section?
23. What is a mutex?
24. What is a semaphore?
25. What is condition variable?
26. What is monitor?
27. What is deadlock in multithreading?
28. What is livelock?
29. What is starvation?
30. What is busy waiting?
31. What is spinlock?
32. What is context switching between threads?
33. Is thread context switching faster than process context switching?
34. What is concurrency?
35. What is parallelism?
36. What is the difference between concurrency and parallelism?
37. What is hyper-threading?
38. What is thread cancellation?
39. What is asynchronous cancellation?
40. What is deferred cancellation?
41. What are signals in thread handling?
42. What is thread-local storage?
43. What is reentrant function?
44. What is non-reentrant function?
45. What is producer-consumer problem?
46. What is reader-writer problem?
47. What is dining philosophers problem?
48. What is sleeping barber problem?
49. How can multiple threads improve performance?
50. When can multithreading reduce performance?

## CPU Scheduling

1. What is CPU scheduling?
2. Why is CPU scheduling needed?
3. What are scheduling criteria?
4. What is CPU utilization?
5. What is throughput?
6. What is turnaround time?
7. What is waiting time?
8. What is response time?
9. What is fairness in scheduling?
10. What is preemptive scheduling?
11. What is non-preemptive scheduling?
12. What is First Come First Serve scheduling?
13. What are the advantages of FCFS?
14. What are the disadvantages of FCFS?
15. What is convoy effect?
16. What is Shortest Job First scheduling?
17. Why is SJF optimal for average waiting time?
18. What is the problem with SJF?
19. What is Shortest Remaining Time First scheduling?
20. What is priority scheduling?
21. What is preemptive priority scheduling?
22. What is non-preemptive priority scheduling?
23. What is starvation in priority scheduling?
24. How does aging solve starvation?
25. What is Round Robin scheduling?
26. What is time quantum?
27. How does time quantum affect Round Robin scheduling?
28. What happens if time quantum is too small?
29. What happens if time quantum is too large?
30. What is multilevel queue scheduling?
31. What is multilevel feedback queue scheduling?
32. What is real-time scheduling?
33. What is rate monotonic scheduling?
34. What is earliest deadline first scheduling?
35. What is proportional share scheduling?
36. What is lottery scheduling?
37. What is fair share scheduling?
38. What is load balancing in multiprocessor scheduling?
39. What is processor affinity?
40. What is soft affinity?
41. What is hard affinity?
42. What is symmetric multiprocessing?
43. What is asymmetric multiprocessing?
44. How is scheduling different on multiprocessor systems?
45. What is scheduling overhead?
46. Which scheduling algorithm is best for time-sharing systems?
47. Which scheduling algorithm is best for batch systems?
48. Which scheduling algorithm is best for real-time systems?
49. How do you calculate average waiting time?
50. How do you calculate average turnaround time?
51. How do you calculate response time?
52. How do you draw a Gantt chart for scheduling?
53. What scheduling algorithm can cause starvation?
54. What scheduling algorithm can cause convoy effect?
55. What is the difference between SJF and SRTF?
56. What is the difference between priority scheduling and Round Robin?
57. What is the difference between FCFS and Round Robin?
58. What is dispatcher latency?
59. What is context switch overhead in scheduling?
60. How does the OS estimate CPU burst time?

## Process Synchronization

1. What is process synchronization?
2. Why is process synchronization needed?
3. What is concurrent execution?
4. What is race condition?
5. What is critical section?
6. What is critical section problem?
7. What are the requirements for a critical section solution?
8. What is mutual exclusion?
9. What is progress condition?
10. What is bounded waiting?
11. What is Peterson's solution?
12. What are the limitations of Peterson's solution?
13. What is hardware synchronization?
14. What is test-and-set instruction?
15. What is compare-and-swap instruction?
16. What is atomic operation?
17. What is lock?
18. What is mutex lock?
19. What is spinlock?
20. What is busy waiting?
21. What is semaphore?
22. What is binary semaphore?
23. What is counting semaphore?
24. What are wait and signal operations?
25. What is `P()` operation?
26. What is `V()` operation?
27. What is monitor?
28. What is condition variable?
29. What is bounded-buffer problem?
30. What is producer-consumer problem?
31. What is readers-writers problem?
32. What is dining philosophers problem?
33. What is sleeping barber problem?
34. What is the difference between mutex and semaphore?
35. What is the difference between binary semaphore and mutex?
36. Can a semaphore cause deadlock?
37. Can synchronization cause starvation?
38. What is priority inversion?
39. What is priority inheritance?
40. What is barrier synchronization?
41. What is memory consistency?
42. What is happens-before relationship?
43. What is volatile variable?
44. What is lock-free programming?
45. What is wait-free programming?
46. What is synchronization overhead?
47. What is the difference between blocking and non-blocking synchronization?
48. What is reentrant lock?
49. What is recursive mutex?
50. What problems occur if synchronization is not used?

## Deadlocks

1. What is deadlock?
2. What is an example of deadlock?
3. What are the necessary conditions for deadlock?
4. What is mutual exclusion condition?
5. What is hold and wait condition?
6. What is no preemption condition?
7. What is circular wait condition?
8. Are all four deadlock conditions necessary?
9. What is resource allocation graph?
10. How does a resource allocation graph show deadlock?
11. What is a request edge?
12. What is an assignment edge?
13. What is a claim edge?
14. What is deadlock prevention?
15. How can mutual exclusion be prevented?
16. How can hold and wait be prevented?
17. How can no preemption be prevented?
18. How can circular wait be prevented?
19. What is deadlock avoidance?
20. What is safe state?
21. What is unsafe state?
22. Does unsafe state always mean deadlock?
23. What is Banker's algorithm?
24. What are the data structures used in Banker's algorithm?
25. What is available matrix?
26. What is maximum matrix?
27. What is allocation matrix?
28. What is need matrix?
29. How does Banker's algorithm check safe sequence?
30. What is deadlock detection?
31. What is wait-for graph?
32. How is deadlock detected using wait-for graph?
33. What is deadlock recovery?
34. How can a system recover from deadlock?
35. What is process termination in deadlock recovery?
36. What is resource preemption in deadlock recovery?
37. What is rollback in deadlock recovery?
38. What is starvation during deadlock recovery?
39. What is livelock?
40. What is the difference between deadlock and livelock?
41. What is the difference between deadlock and starvation?
42. What is the difference between deadlock prevention and deadlock avoidance?
43. What is the difference between deadlock detection and deadlock avoidance?
44. What is ostrich algorithm?
45. Why do some operating systems ignore deadlocks?
46. Can deadlock occur with a single resource type?
47. Can deadlock occur if resources are shareable?
48. Can deadlock occur in databases?
49. Can deadlock occur in multithreaded programs?
50. How do you avoid deadlock while writing code?

## Memory Management

1. What is memory management?
2. Why is memory management needed?
3. What is main memory?
4. What is secondary memory?
5. What is address space?
6. What is logical address?
7. What is physical address?
8. What is the difference between logical and physical address?
9. What is memory address binding?
10. What is compile-time address binding?
11. What is load-time address binding?
12. What is execution-time address binding?
13. What is Memory Management Unit?
14. What is relocation?
15. What is static relocation?
16. What is dynamic relocation?
17. What is contiguous memory allocation?
18. What is non-contiguous memory allocation?
19. What is fixed partitioning?
20. What is variable partitioning?
21. What is internal fragmentation?
22. What is external fragmentation?
23. What is compaction?
24. What is first fit?
25. What is best fit?
26. What is worst fit?
27. What is next fit?
28. Which memory allocation strategy is fastest?
29. Which memory allocation strategy reduces fragmentation?
30. What is paging?
31. Why is paging used?
32. What is page?
33. What is frame?
34. What is page table?
35. What is page table entry?
36. What is valid-invalid bit?
37. What is page number?
38. What is page offset?
39. How is logical address translated to physical address in paging?
40. What is Translation Lookaside Buffer?
41. Why is TLB used?
42. What is TLB hit?
43. What is TLB miss?
44. What is effective memory access time?
45. What is multilevel paging?
46. Why is multilevel paging used?
47. What is inverted page table?
48. What is hashed page table?
49. What is segmentation?
50. Why is segmentation used?
51. What is segment table?
52. What is segment number?
53. What is segment offset?
54. What is base register?
55. What is limit register?
56. What is the difference between paging and segmentation?
57. What is paged segmentation?
58. What is segmented paging?
59. What is memory protection?
60. What is shared memory?
61. What is dynamic loading?
62. What is dynamic linking?
63. What is static linking?
64. What is swapping?
65. What is swap space?
66. What is memory leak?
67. What is dangling pointer?
68. What is stack memory?
69. What is heap memory?
70. What is the difference between stack and heap?

## Virtual Memory

1. What is virtual memory?
2. Why is virtual memory needed?
3. What are the advantages of virtual memory?
4. What are the disadvantages of virtual memory?
5. What is demand paging?
6. What is lazy loading?
7. What is page fault?
8. What happens during a page fault?
9. What is page fault service time?
10. What is page fault rate?
11. What is pure demand paging?
12. What is prepaging?
13. What is copy-on-write?
14. What is memory-mapped file?
15. What is page replacement?
16. Why is page replacement needed?
17. What is FIFO page replacement?
18. What is optimal page replacement?
19. What is LRU page replacement?
20. What is MRU page replacement?
21. What is second chance page replacement?
22. What is clock page replacement?
23. What is LFU page replacement?
24. What is MFU page replacement?
25. What is Belady's anomaly?
26. Which page replacement algorithms can suffer from Belady's anomaly?
27. Which page replacement algorithm is theoretically optimal?
28. Why is optimal page replacement not practical?
29. How is LRU implemented?
30. What is reference bit?
31. What is modify bit?
32. What is dirty page?
33. What is clean page?
34. What is frame allocation?
35. What is equal allocation?
36. What is proportional allocation?
37. What is priority allocation?
38. What is global replacement?
39. What is local replacement?
40. What is thrashing?
41. Why does thrashing occur?
42. How can thrashing be prevented?
43. What is working set model?
44. What is locality of reference?
45. What is temporal locality?
46. What is spatial locality?
47. What is page size?
48. How does page size affect performance?
49. What is effective access time with page faults?
50. What is resident set?
51. What is virtual address space?
52. What is physical address space?
53. What is overcommitment of memory?
54. What is swap-in?
55. What is swap-out?
56. What is memory pressure?
57. What is minor page fault?
58. What is major page fault?
59. What is page fault frequency algorithm?
60. What is working set window?

## File Systems

1. What is a file?
2. What is a file system?
3. Why is a file system needed?
4. What are file attributes?
5. What is file name?
6. What is file type?
7. What is file size?
8. What is file location?
9. What is file permission?
10. What is file owner?
11. What is file timestamp?
12. What are common file operations?
13. What is file creation?
14. What is file deletion?
15. What is file opening?
16. What is file closing?
17. What is file reading?
18. What is file writing?
19. What is file seek?
20. What is file descriptor?
21. What is file pointer?
22. What is directory?
23. What is root directory?
24. What is current directory?
25. What is absolute path?
26. What is relative path?
27. What is single-level directory structure?
28. What is two-level directory structure?
29. What is tree-structured directory?
30. What is acyclic graph directory?
31. What is general graph directory?
32. What is file allocation?
33. What is contiguous allocation?
34. What are the advantages of contiguous allocation?
35. What are the disadvantages of contiguous allocation?
36. What is linked allocation?
37. What are the advantages of linked allocation?
38. What are the disadvantages of linked allocation?
39. What is indexed allocation?
40. What are the advantages of indexed allocation?
41. What are the disadvantages of indexed allocation?
42. What is inode?
43. What information is stored in an inode?
44. What is File Allocation Table?
45. What is directory entry?
46. What is free space management?
47. What is bit vector?
48. What is free list?
49. What is grouping in free space management?
50. What is counting in free space management?
51. What is mounting?
52. What is unmounting?
53. What is journaling file system?
54. Why is journaling used?
55. What is file system consistency?
56. What is fsck?
57. What is disk quota?
58. What is hard link?
59. What is symbolic link?
60. What is the difference between hard link and symbolic link?
61. What is access control list?
62. What are read, write, and execute permissions?
63. What is file locking?
64. What is mandatory locking?
65. What is advisory locking?
66. What is cache in file systems?
67. What is buffer cache?
68. What is write-through cache?
69. What is write-back cache?
70. What happens when a file is deleted?

## I/O Management

1. What is I/O management?
2. Why is I/O management important?
3. What is I/O device?
4. What is device controller?
5. What is device driver?
6. What is the role of a device driver?
7. What is character device?
8. What is block device?
9. What is network device?
10. What is I/O port?
11. What is memory-mapped I/O?
12. What is programmed I/O?
13. What is interrupt-driven I/O?
14. What is Direct Memory Access?
15. Why is DMA used?
16. What is DMA controller?
17. What is buffering?
18. Why is buffering used?
19. What is single buffering?
20. What is double buffering?
21. What is circular buffering?
22. What is caching?
23. What is spooling?
24. Why is spooling used?
25. What is device reservation?
26. What is blocking I/O?
27. What is non-blocking I/O?
28. What is asynchronous I/O?
29. What is synchronous I/O?
30. What is I/O scheduling?
31. What is disk scheduling?
32. What is seek time?
33. What is rotational latency?
34. What is transfer time?
35. What is disk access time?
36. What is FCFS disk scheduling?
37. What is SSTF disk scheduling?
38. What is SCAN disk scheduling?
39. What is C-SCAN disk scheduling?
40. What is LOOK disk scheduling?
41. What is C-LOOK disk scheduling?
42. Which disk scheduling algorithm can cause starvation?
43. What is RAID?
44. Why is RAID used?
45. What is RAID 0?
46. What is RAID 1?
47. What is RAID 5?
48. What is RAID 6?
49. What is SSD?
50. How is SSD different from HDD?
51. What is TRIM in SSD?
52. What is wear leveling?
53. What is interrupt handler?
54. What is interrupt vector?
55. What is interrupt priority?
56. What is nested interrupt?
57. What is I/O protection?
58. What is device independence?
59. What is plug and play?
60. What is hot swapping?

## Linux and Unix Basics

1. What is Linux?
2. What is Unix?
3. What is the difference between Linux and Unix?
4. What is Linux kernel?
5. What is Linux distribution?
6. What are common Linux distributions?
7. What is terminal?
8. What is shell in Linux?
9. What is Bash?
10. What is root user?
11. What is sudo?
12. What is home directory?
13. What is `/` directory?
14. What is `/bin`?
15. What is `/sbin`?
16. What is `/etc`?
17. What is `/home`?
18. What is `/var`?
19. What is `/tmp`?
20. What is `/usr`?
21. What is `/dev`?
22. What is `/proc`?
23. What is `/sys`?
24. What is process ID in Linux?
25. What is `ps` command?
26. What is `top` command?
27. What is `kill` command?
28. What is `nice` command?
29. What is `renice` command?
30. What is `chmod`?
31. What is `chown`?
32. What is `ls`?
33. What is `cd`?
34. What is `pwd`?
35. What is `mkdir`?
36. What is `rmdir`?
37. What is `cp`?
38. What is `mv`?
39. What is `rm`?
40. What is `cat`?
41. What is `grep`?
42. What is `find`?
43. What is `touch`?
44. What is `head`?
45. What is `tail`?
46. What is pipe in Linux?
47. What is redirection in Linux?
48. What is environment variable?
49. What is PATH variable?
50. What is cron job?
51. What is systemd?
52. What is service in Linux?
53. What is package manager?
54. What is apt?
55. What is yum?
56. What is dmesg?
57. What is log file?
58. What is swap partition?
59. What is fork in Unix?
60. What is exec in Unix?

## System Calls

1. What is a system call?
2. Why are system calls needed?
3. What happens when a system call is executed?
4. What is the difference between system call and function call?
5. What are process control system calls?
6. What are file management system calls?
7. What are device management system calls?
8. What are information maintenance system calls?
9. What are communication system calls?
10. What is `fork()`?
11. What does `fork()` return?
12. What is `exec()`?
13. What is the difference between `fork()` and `exec()`?
14. What is `wait()`?
15. What is `exit()`?
16. What is `getpid()`?
17. What is `getppid()`?
18. What is `open()`?
19. What is `read()`?
20. What is `write()`?
21. What is `close()`?
22. What is `lseek()`?
23. What is `stat()`?
24. What is `chmod()`?
25. What is `chown()`?
26. What is `pipe()`?
27. What is `dup()`?
28. What is `dup2()`?
29. What is `mmap()`?
30. What is `brk()`?
31. What is `sbrk()`?
32. What is `socket()`?
33. What is `bind()`?
34. What is `listen()`?
35. What is `accept()`?
36. What is `connect()`?
37. What is `send()`?
38. What is `recv()`?
39. What is signal system call?
40. What is system call table?

## Inter-Process Communication

1. What is inter-process communication?
2. Why is IPC needed?
3. What are the types of IPC?
4. What is shared memory?
5. What are the advantages of shared memory?
6. What are the disadvantages of shared memory?
7. What is message passing?
8. What are the advantages of message passing?
9. What are the disadvantages of message passing?
10. What is pipe?
11. What is anonymous pipe?
12. What is named pipe?
13. What is FIFO?
14. What is message queue?
15. What is socket?
16. What is signal?
17. What is semaphore in IPC?
18. What is memory-mapped file?
19. What is remote procedure call?
20. What is direct communication?
21. What is indirect communication?
22. What is blocking send?
23. What is non-blocking send?
24. What is blocking receive?
25. What is non-blocking receive?
26. What is mailbox in IPC?
27. What is port in IPC?
28. What is producer-consumer communication?
29. What is client-server communication?
30. Which IPC method is fastest?
31. Which IPC method is easiest to use?
32. Which IPC method works across machines?
33. How do processes synchronize shared memory access?
34. What problems can happen in IPC?
35. What is race condition in IPC?
36. What is deadlock in IPC?
37. What is starvation in IPC?
38. What is data consistency in IPC?
39. How is IPC different from thread communication?
40. How does the OS protect IPC resources?

## Security and Protection

1. What is protection in operating systems?
2. What is security in operating systems?
3. What is the difference between protection and security?
4. What is authentication?
5. What is authorization?
6. What is access control?
7. What is access matrix?
8. What is access control list?
9. What is capability list?
10. What is domain of protection?
11. What is least privilege principle?
12. What is privilege escalation?
13. What is user account?
14. What is root account?
15. What is superuser?
16. What is password hashing?
17. What is salt in password storage?
18. What is malware?
19. What is virus?
20. What is worm?
21. What is Trojan horse?
22. What is ransomware?
23. What is spyware?
24. What is rootkit?
25. What is buffer overflow?
26. What is stack overflow?
27. What is heap overflow?
28. What is race condition attack?
29. What is time-of-check to time-of-use attack?
30. What is denial of service attack?
31. What is sandboxing?
32. What is encryption?
33. What is file permission?
34. What is execute permission?
35. What is setuid?
36. What is setgid?
37. What is sticky bit?
38. What is audit log?
39. What is intrusion detection?
40. How does an OS isolate processes?

## Real-Time and Distributed OS

1. What is real-time operating system?
2. What is hard real-time system?
3. What is soft real-time system?
4. What is firm real-time system?
5. What are examples of real-time systems?
6. What is deadline in real-time systems?
7. What is deterministic response?
8. What is interrupt latency?
9. What is jitter?
10. What is priority-based scheduling in RTOS?
11. What is rate monotonic scheduling?
12. What is earliest deadline first scheduling?
13. What is priority inversion in RTOS?
14. What is priority inheritance?
15. What is watchdog timer?
16. What is embedded operating system?
17. What is distributed operating system?
18. What are the goals of distributed OS?
19. What is transparency in distributed OS?
20. What is location transparency?
21. What is migration transparency?
22. What is replication transparency?
23. What is fault tolerance?
24. What is distributed file system?
25. What is distributed shared memory?
26. What is clock synchronization?
27. What is logical clock?
28. What is Lamport timestamp?
29. What is mutual exclusion in distributed systems?
30. What is election algorithm?
31. What is bully algorithm?
32. What is ring election algorithm?
33. What is load sharing?
34. What is load balancing?
35. What is distributed deadlock?
36. What is distributed scheduling?
37. What is client-server model?
38. What is peer-to-peer model?
39. What are the challenges of distributed OS?
40. How is distributed OS different from network OS?

## Virtualization and Containers

1. What is virtualization?
2. Why is virtualization used?
3. What is virtual machine?
4. What is host operating system?
5. What is guest operating system?
6. What is hypervisor?
7. What is type 1 hypervisor?
8. What is type 2 hypervisor?
9. What is full virtualization?
10. What is para-virtualization?
11. What is hardware-assisted virtualization?
12. What is CPU virtualization?
13. What is memory virtualization?
14. What is I/O virtualization?
15. What is snapshot in virtualization?
16. What is live migration?
17. What are the advantages of virtual machines?
18. What are the disadvantages of virtual machines?
19. What is containerization?
20. What is a container?
21. How are containers different from virtual machines?
22. What is Docker?
23. What is container image?
24. What is container runtime?
25. What is namespace in Linux?
26. What is cgroup in Linux?
27. What is chroot?
28. How do containers provide isolation?
29. Do containers have their own kernel?
30. What are the security concerns with containers?

## Important Comparison Questions

1. What is the difference between process and program?
2. What is the difference between process and thread?
3. What is the difference between multiprocessing and multithreading?
4. What is the difference between multitasking and multiprogramming?
5. What is the difference between concurrency and parallelism?
6. What is the difference between user mode and kernel mode?
7. What is the difference between kernel and operating system?
8. What is the difference between kernel and shell?
9. What is the difference between interrupt and trap?
10. What is the difference between interrupt and system call?
11. What is the difference between system call and library call?
12. What is the difference between preemptive and non-preemptive scheduling?
13. What is the difference between FCFS and SJF?
14. What is the difference between SJF and SRTF?
15. What is the difference between Round Robin and priority scheduling?
16. What is the difference between mutex and semaphore?
17. What is the difference between binary semaphore and counting semaphore?
18. What is the difference between deadlock and starvation?
19. What is the difference between deadlock and livelock?
20. What is the difference between deadlock prevention and deadlock avoidance?
21. What is the difference between paging and segmentation?
22. What is the difference between internal and external fragmentation?
23. What is the difference between logical address and physical address?
24. What is the difference between virtual memory and physical memory?
25. What is the difference between page and frame?
26. What is the difference between TLB hit and TLB miss?
27. What is the difference between demand paging and swapping?
28. What is the difference between FIFO and LRU page replacement?
29. What is the difference between local and global page replacement?
30. What is the difference between file and directory?
31. What is the difference between hard link and soft link?
32. What is the difference between blocking and non-blocking I/O?
33. What is the difference between synchronous and asynchronous I/O?
34. What is the difference between buffering and caching?
35. What is the difference between HDD and SSD?
36. What is the difference between monolithic kernel and microkernel?
37. What is the difference between real-time OS and general-purpose OS?
38. What is the difference between distributed OS and network OS?
39. What is the difference between virtual machine and container?
40. What is the difference between authentication and authorization?

## Numericals and Practice Problems

1. Given arrival time and burst time, calculate completion time using FCFS.
2. Given arrival time and burst time, calculate turnaround time using FCFS.
3. Given arrival time and burst time, calculate waiting time using FCFS.
4. Draw the Gantt chart for FCFS scheduling.
5. Calculate average waiting time for FCFS scheduling.
6. Calculate average turnaround time for FCFS scheduling.
7. Given burst times, schedule processes using non-preemptive SJF.
8. Given arrival and burst times, schedule processes using preemptive SJF.
9. Draw the Gantt chart for SRTF scheduling.
10. Calculate average waiting time for SJF scheduling.
11. Calculate average turnaround time for SJF scheduling.
12. Given priorities, schedule processes using priority scheduling.
13. Calculate waiting time in priority scheduling.
14. Calculate turnaround time in priority scheduling.
15. Given time quantum, schedule processes using Round Robin.
16. Draw the Gantt chart for Round Robin scheduling.
17. Calculate average waiting time for Round Robin scheduling.
18. Calculate average turnaround time for Round Robin scheduling.
19. Compare FCFS, SJF, Priority, and Round Robin for the same process set.
20. Given resource allocation data, check whether the system is in a safe state.
21. Find the safe sequence using Banker's algorithm.
22. Given available, maximum, and allocation matrices, calculate need matrix.
23. Given a resource request, decide whether it can be granted.
24. Identify deadlock from a resource allocation graph.
25. Detect deadlock using a wait-for graph.
26. Given page reference string, calculate page faults using FIFO.
27. Given page reference string, calculate page faults using LRU.
28. Given page reference string, calculate page faults using optimal replacement.
29. Given page reference string, calculate page faults using second chance algorithm.
30. Compare page faults for FIFO, LRU, and optimal replacement.
31. Identify Belady's anomaly from page replacement examples.
32. Calculate effective memory access time with TLB.
33. Calculate effective memory access time with page faults.
34. Convert logical address to physical address using page table.
35. Convert logical address to physical address using segmentation table.
36. Calculate internal fragmentation for fixed partition allocation.
37. Calculate external fragmentation for variable partition allocation.
38. Allocate memory blocks using first fit.
39. Allocate memory blocks using best fit.
40. Allocate memory blocks using worst fit.
41. Compare first fit, best fit, and worst fit for the same memory blocks.
42. Calculate disk head movement using FCFS disk scheduling.
43. Calculate disk head movement using SSTF disk scheduling.
44. Calculate disk head movement using SCAN disk scheduling.
45. Calculate disk head movement using C-SCAN disk scheduling.
46. Calculate disk head movement using LOOK disk scheduling.
47. Calculate disk head movement using C-LOOK disk scheduling.
48. Compare disk scheduling algorithms for the same request queue.
49. Calculate average seek time.
50. Calculate disk access time using seek time, rotational latency, and transfer time.

## Tricky Interview Questions

1. Can a process have multiple threads?
2. Can a thread exist without a process?
3. Can two processes share the same memory?
4. Can two threads share the same stack?
5. Can a process be both I/O-bound and CPU-bound?
6. Can a system be in unsafe state without being deadlocked?
7. Can deadlock happen with only one process?
8. Can deadlock happen with only one resource?
9. Can starvation happen without deadlock?
10. Can deadlock happen without starvation?
11. Can paging have external fragmentation?
12. Can segmentation have internal fragmentation?
13. Can FIFO page replacement perform worse with more frames?
14. Can LRU suffer from Belady's anomaly?
15. Can a page fault occur if the page is already in memory?
16. Can a system call be made without switching to kernel mode?
17. Can context switching happen without scheduling?
18. Can a zombie process consume CPU?
19. Can an orphan process become a zombie?
20. Can a parent process continue without waiting for child process?
21. Why does `fork()` return twice?
22. Why is `exec()` usually called after `fork()`?
23. Why is shared memory faster than message passing?
24. Why can spinlocks be bad on single-core systems?
25. Why can mutexes be better than semaphores for mutual exclusion?
26. Why can Round Robin behave like FCFS?
27. Why can very small time quantum reduce CPU efficiency?
28. Why is optimal page replacement impossible to implement exactly?
29. Why is TLB important even when page tables exist?
30. Why does thrashing reduce CPU utilization?
31. Why does increasing memory sometimes improve CPU utilization?
32. Why does increasing degree of multiprogramming sometimes reduce performance?
33. Why are interrupts disabled inside some critical sections?
34. Why is kernel code more trusted than user code?
35. Why are system calls slower than normal function calls?
36. Why do operating systems cache disk data?
37. Why is file deletion sometimes recoverable?
38. Why are hard links not usually allowed for directories?
39. Why can symbolic links become dangling?
40. Why are containers lighter than virtual machines?

## Viva-Style Short Questions

1. Define operating system.
2. Define kernel.
3. Define process.
4. Define thread.
5. Define scheduler.
6. Define dispatcher.
7. Define semaphore.
8. Define mutex.
9. Define deadlock.
10. Define starvation.
11. Define aging.
12. Define paging.
13. Define segmentation.
14. Define virtual memory.
15. Define page fault.
16. Define thrashing.
17. Define TLB.
18. Define fragmentation.
19. Define inode.
20. Define file descriptor.
21. Define system call.
22. Define interrupt.
23. Define context switch.
24. Define race condition.
25. Define critical section.
26. Define demand paging.
27. Define swap space.
28. Define spooling.
29. Define buffering.
30. Define caching.
31. Define DMA.
32. Define disk scheduling.
33. Define seek time.
34. Define rotational latency.
35. Define RAID.
36. Define bootloader.
37. Define hypervisor.
38. Define virtual machine.
39. Define container.
40. Define access control.

## Final Revision Questions

1. Explain the complete lifecycle of a process.
2. Explain process scheduling with examples.
3. Explain Round Robin scheduling with a Gantt chart.
4. Explain deadlock with real-life example.
5. Explain Banker's algorithm step by step.
6. Explain paging with address translation.
7. Explain segmentation with address translation.
8. Explain virtual memory and demand paging.
9. Explain page replacement algorithms.
10. Explain thrashing and working set model.
11. Explain file allocation methods.
12. Explain disk scheduling algorithms.
13. Explain synchronization using semaphores.
14. Explain producer-consumer problem.
15. Explain readers-writers problem.
16. Explain dining philosophers problem.
17. Explain how a system call works.
18. Explain how `fork()` works.
19. Explain how threads share resources.
20. Explain how OS handles interrupts.
21. Explain how OS protects memory.
22. Explain how OS manages files.
23. Explain how OS manages I/O devices.
24. Explain how Linux permissions work.
25. Explain how virtual machines work.
26. Explain how containers work.
27. Explain the difference between deadlock, starvation, and livelock.
28. Explain the difference between paging and segmentation.
29. Explain the difference between process and thread.
30. Explain the difference between mutex and semaphore.

