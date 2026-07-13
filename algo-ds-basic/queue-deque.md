# Queue and Deque

## 1. Overview

A **queue** is a linear data structure that follows **FIFO**:

> First In, First Out

The first element inserted is the first element removed.

Example:

```text
push 10
push 20
push 30

pop -> 10
pop -> 20
pop -> 30
```

A **deque** is a double-ended queue. It allows insertion and deletion from both ends:

```text
push_front()
push_back()
pop_front()
pop_back()
```

Queues and deques are extremely important in placements, online assessments, and competitive programming because they appear in graph traversal, sliding window problems, scheduling, simulations, shortest paths, and grid-based problems.

Topics covered in this guide:

| Topic | Main Use |
|---|---|
| Queue basics | FIFO processing |
| Circular queue | Fixed-size queue using array |
| Deque | Insert/delete from both ends |
| BFS using queue | Level-wise graph traversal |
| Sliding window maximum | Maximum in every window |
| Monotonic deque | Maintain useful candidates |
| First negative in every window | Window tracking |
| Rotten oranges | Multi-source BFS |
| Task scheduler | Queue/simulation/greedy |
| 0-1 BFS using deque | Shortest path with weights 0 and 1 |

## 2. Intuition

### Simple Explanation

A queue is like a line at a ticket counter:

* The person who comes first gets served first.
* New people join at the back.
* Service happens from the front.

A deque is like a line where people can enter or leave from both ends. This extra flexibility makes it useful when we need to keep the "best" candidates near the front while removing useless candidates from the back.

### Core Idea

Queues are useful when processing order matters:

* Process items in arrival order.
* Process graph nodes level by level.
* Process time-based events.
* Process windows from left to right.

Deques are useful when both ends matter:

* Add new elements at the back.
* Remove expired elements from the front.
* Remove worse candidates from the back.
* Push cheaper graph moves to the front in 0-1 BFS.

### Step-by-Step Reasoning

For a normal queue:

1. Insert new work at the back.
2. Always process the front item first.
3. Remove it after processing.
4. Continue until the queue is empty.

For a monotonic deque:

1. Store indices, not just values.
2. Remove indices outside the current window from the front.
3. Remove smaller or useless elements from the back.
4. The front always stores the best answer for the current window.

### Why It Works

Queues work because FIFO order naturally matches many problems:

* BFS needs nearest nodes before farther nodes.
* Simulations need earlier events before later events.
* Sliding windows need old elements removed before new windows are answered.

Deques work because we can maintain only useful candidates. Instead of checking every element in a window, we keep the best possible answer at the front.

## 3. When to Use It

Use a queue or deque when the problem has these signs:

| Trigger Phrase | Likely Technique |
|---|---|
| "first come first served" | Queue |
| "level order traversal" | BFS queue |
| "minimum number of steps" in unweighted graph/grid | BFS |
| "nearest distance" in unweighted graph | BFS |
| "spread infection/fire/rot" | Multi-source BFS |
| "sliding window maximum/minimum" | Monotonic deque |
| "first negative in every window" | Queue/deque of indices |
| "fixed-size queue" | Circular queue |
| "insert/delete from both ends" | Deque |
| "edge weights are only 0 and 1" | 0-1 BFS using deque |
| "CPU task scheduling with cooldown" | Queue + greedy/counting |
| "process in rounds/levels" | Queue |

Common situations:

* BFS on graphs and grids.
* Level order traversal of trees.
* Shortest path in an unweighted graph.
* Sliding window problems.
* Stream processing.
* Scheduling and simulation.
* Cache-like processing.
* Finding maximum/minimum in every subarray of size `k`.
* Processing multiple starting points together.

## 4. When Not to Use It

Do not use a queue/deque blindly.

| Situation | Better Choice |
|---|---|
| Need LIFO order | Stack |
| Need smallest/largest element globally | Heap / priority queue |
| Need sorted order with insert/delete/search | Balanced BST / set / multiset |
| Need range sum/min/max with updates | Segment tree / Fenwick tree |
| Graph has arbitrary positive weights | Dijkstra |
| Graph has negative weights | Bellman-Ford / SPFA carefully |
| Need random access in middle | Vector / array |
| Need recursion/backtracking | DFS |

Common wrong assumptions:

* BFS works for all shortest path problems. It only works directly for unweighted graphs.
* 0-1 BFS works for any weighted graph. It only works when edge weights are `0` or `1`.
* Sliding window maximum can be solved efficiently with a normal queue. A normal queue does not remove smaller useless elements.
* Circular queue grows automatically. Usually it has a fixed capacity.
* Deque is always better than vector. Deque has different memory layout and is not always best for random access heavy tasks.

Overkill cases:

* For a tiny input, a simple loop may be enough.
* For only one maximum query, no need for monotonic deque.
* For a graph with no need for shortest distance or levels, DFS may be simpler.

## 5. Core Concepts

### 5.1 Queue Operations

| Operation | Meaning | Complexity |
|---|---|---|
| `push(x)` | Insert at back | `O(1)` |
| `pop()` | Remove front | `O(1)` |
| `front()` | Read front element | `O(1)` |
| `empty()` | Check if empty | `O(1)` |
| `size()` | Number of elements | `O(1)` |

Why it matters:

Queue gives predictable FIFO order. This is the backbone of BFS.

Example:

```cpp
queue<int> q;
q.push(5);
q.push(10);
cout << q.front(); // 5
q.pop();
cout << q.front(); // 10
```

### 5.2 Circular Queue

A circular queue uses a fixed-size array and treats the end as connected to the beginning.

Why it matters:

If we use a normal array queue and keep moving forward, unused space at the beginning gets wasted. Circular queue reuses that space.

Important variables:

* `frontIndex`: index of the front element.
* `rearIndex`: index where the next element will be inserted.
* `count`: current number of elements.
* `capacity`: maximum size.

Formula:

```text
next index = (current index + 1) % capacity
```

Example with capacity `5`:

```text
indices: 0 1 2 3 4
after rear reaches 4, next rear becomes 0
```

### 5.3 Deque Operations

| Operation | Meaning | Complexity |
|---|---|---|
| `push_front(x)` | Insert at front | `O(1)` |
| `push_back(x)` | Insert at back | `O(1)` |
| `pop_front()` | Remove from front | `O(1)` |
| `pop_back()` | Remove from back | `O(1)` |
| `front()` | Read front | `O(1)` |
| `back()` | Read back | `O(1)` |

Why it matters:

Deque supports both queue-like and stack-like behavior. It is the key data structure for monotonic queues and 0-1 BFS.

### 5.4 BFS Using Queue

BFS means **Breadth-First Search**.

It explores:

1. Start node.
2. All nodes at distance `1`.
3. All nodes at distance `2`.
4. Continue level by level.

Why queue matters:

The queue stores nodes in the order they should be processed. Since nodes at smaller distance enter the queue first, they are processed first.

### 5.5 Multi-Source BFS

In normal BFS, we start from one source.

In multi-source BFS, we push all starting points into the queue initially.

Used in:

* Rotten oranges.
* Nearest zero in a binary matrix.
* Fire spread problems.
* Nearest hospital/police station type problems.

Why it works:

All sources start at distance/time `0`, so BFS spreads from all of them together.

### 5.6 Sliding Window

A sliding window is a range of fixed or variable size that moves across an array.

For fixed window size `k`:

```text
window 1: [0 ... k-1]
window 2: [1 ... k]
window 3: [2 ... k+1]
```

Why it matters:

Many array problems ask for something in every subarray of size `k`.

### 5.7 Monotonic Deque

A monotonic deque keeps elements in increasing or decreasing order.

For sliding window maximum:

* Keep values in decreasing order.
* Front is always the maximum.
* Remove smaller elements from the back because they can never become maximum while the current bigger element exists.

Usually store indices:

```text
deque stores indices, not values
```

Why indices matter:

Indices help remove elements that are outside the current window.

### 5.8 First Negative in Every Window

Maintain a queue/deque of indices whose values are negative.

For each window:

* Remove negative indices outside the window.
* Add current index if the value is negative.
* Front gives the first negative number.

### 5.9 Rotten Oranges

This is a grid BFS problem.

Each rotten orange spreads rot to adjacent fresh oranges in one minute.

Use queue for all initially rotten oranges.

Why multi-source BFS:

All rotten oranges spread simultaneously, so all rotten positions start at time `0`.

### 5.10 Task Scheduler

Classic problem:

Given tasks and cooldown `n`, find minimum CPU intervals needed.

Two common approaches:

1. Greedy formula using task frequencies.
2. Simulation using max heap and queue.

Queue matters in simulation because tasks in cooldown become available after a future time.

### 5.11 0-1 BFS Using Deque

0-1 BFS finds shortest path when every edge weight is only `0` or `1`.

Rule:

* If edge weight is `0`, push neighbor to front.
* If edge weight is `1`, push neighbor to back.

Why it works:

Cost `0` edges should be processed as soon as possible because they do not increase distance. Cost `1` edges can wait behind current equal-cost options.

## 6. Step-by-Step Algorithm

### 6.1 Queue Basics

1. Create an empty queue.
2. Insert elements using `push`.
3. Read the oldest element using `front`.
4. Remove the oldest element using `pop`.
5. Repeat while the queue is not empty.

### 6.2 Circular Queue

1. Create an array of size `capacity`.
2. Set `frontIndex = 0`, `rearIndex = 0`, and `count = 0`.
3. To push:
   1. If `count == capacity`, queue is full.
   2. Place value at `rearIndex`.
   3. Move `rearIndex = (rearIndex + 1) % capacity`.
   4. Increase `count`.
4. To pop:
   1. If `count == 0`, queue is empty.
   2. Read value at `frontIndex`.
   3. Move `frontIndex = (frontIndex + 1) % capacity`.
   4. Decrease `count`.

### 6.3 BFS Using Queue

1. Create a queue.
2. Mark the source as visited.
3. Push the source into the queue.
4. While the queue is not empty:
   1. Pop the front node.
   2. Visit all unvisited neighbors.
   3. Mark each neighbor visited.
   4. Push each neighbor into the queue.
5. Distances or levels can be stored while pushing neighbors.

### 6.4 Sliding Window Maximum Using Monotonic Deque

1. Create an empty deque of indices.
2. For each index `i`:
   1. Remove indices from the front if they are outside the window.
   2. Remove indices from the back while their values are less than or equal to `arr[i]`.
   3. Push `i` at the back.
   4. If the first window is complete, `arr[dq.front()]` is the maximum.

### 6.5 First Negative in Every Window

1. Create an empty deque of indices.
2. For each index `i`:
   1. Remove indices outside the window.
   2. If `arr[i] < 0`, push `i`.
   3. If window is complete:
      1. If deque is empty, answer is `0`.
      2. Else answer is `arr[dq.front()]`.

### 6.6 Rotten Oranges

1. Push all rotten oranges into the queue with time `0`.
2. Count all fresh oranges.
3. While the queue is not empty:
   1. Pop a cell.
   2. Check four neighboring cells.
   3. If a neighbor is fresh:
      1. Mark it rotten.
      2. Decrease fresh count.
      3. Push it with time `currentTime + 1`.
4. If fresh count becomes `0`, return total time.
5. Otherwise return `-1`.

### 6.7 Task Scheduler

Greedy formula approach:

1. Count frequency of each task.
2. Find maximum frequency `maxFreq`.
3. Count how many tasks have frequency `maxFreq`.
4. Minimum intervals:

```text
max(totalTasks, (maxFreq - 1) * (cooldown + 1) + maxFreqCount)
```

### 6.8 0-1 BFS

1. Initialize all distances as infinity.
2. Set source distance to `0`.
3. Push source into deque.
4. While deque is not empty:
   1. Pop node from front.
   2. For every neighbor:
      1. If `dist[node] + weight < dist[neighbor]`, update distance.
      2. If weight is `0`, push neighbor to front.
      3. If weight is `1`, push neighbor to back.

## 7. Dry Run

### 7.1 Queue Basics Dry Run

Operations:

```text
push 10
push 20
push 30
pop
push 40
pop
```

| Step | Operation | Queue Front to Back | Output |
|---|---|---|---|
| 1 | push 10 | `[10]` | - |
| 2 | push 20 | `[10, 20]` | - |
| 3 | push 30 | `[10, 20, 30]` | - |
| 4 | pop | `[20, 30]` | `10` |
| 5 | push 40 | `[20, 30, 40]` | - |
| 6 | pop | `[30, 40]` | `20` |

Final queue:

```text
[30, 40]
```

### 7.2 Sliding Window Maximum Dry Run

Input:

```text
arr = [1, 3, -1, -3, 5, 3, 6, 7]
k = 3
```

Expected output:

```text
[3, 3, 5, 5, 6, 7]
```

Deque stores indices. Values are maintained in decreasing order.

| i | arr[i] | Action | Deque Indices | Deque Values | Window Max |
|---|---:|---|---|---|---|
| 0 | 1 | push 0 | `[0]` | `[1]` | - |
| 1 | 3 | remove 0, push 1 | `[1]` | `[3]` | - |
| 2 | -1 | push 2 | `[1, 2]` | `[3, -1]` | `3` |
| 3 | -3 | push 3 | `[1, 2, 3]` | `[3, -1, -3]` | `3` |
| 4 | 5 | remove expired 1, remove 3,2, push 4 | `[4]` | `[5]` | `5` |
| 5 | 3 | push 5 | `[4, 5]` | `[5, 3]` | `5` |
| 6 | 6 | remove 5,4, push 6 | `[6]` | `[6]` | `6` |
| 7 | 7 | remove 6, push 7 | `[7]` | `[7]` | `7` |

Final answer:

```text
[3, 3, 5, 5, 6, 7]
```

### 7.3 First Negative in Every Window Dry Run

Input:

```text
arr = [12, -1, -7, 8, -15, 30, 16, 28]
k = 3
```

| Window | Elements | Negative Indices in Deque | First Negative |
|---|---|---|---|
| `[0..2]` | `[12, -1, -7]` | `[1, 2]` | `-1` |
| `[1..3]` | `[-1, -7, 8]` | `[1, 2]` | `-1` |
| `[2..4]` | `[-7, 8, -15]` | `[2, 4]` | `-7` |
| `[3..5]` | `[8, -15, 30]` | `[4]` | `-15` |
| `[4..6]` | `[-15, 30, 16]` | `[4]` | `-15` |
| `[5..7]` | `[30, 16, 28]` | `[]` | `0` |

Final answer:

```text
[-1, -1, -7, -15, -15, 0]
```

### 7.4 Rotten Oranges Dry Run

Grid:

```text
2 1 1
1 1 0
0 1 1
```

`2` = rotten, `1` = fresh, `0` = empty.

Initial:

```text
Queue = [(0, 0, time 0)]
fresh = 6
```

| Time | Rotten This Minute | Newly Rotten | Fresh Left |
|---:|---|---|---:|
| 0 | `(0,0)` | `(0,1), (1,0)` | 4 |
| 1 | `(0,1), (1,0)` | `(0,2), (1,1)` | 2 |
| 2 | `(0,2), (1,1)` | `(2,1)` | 1 |
| 3 | `(2,1)` | `(2,2)` | 0 |
| 4 | `(2,2)` | none | 0 |

Final answer:

```text
4
```

### 7.5 0-1 BFS Dry Run

Graph:

```text
0 --0--> 1
0 --1--> 2
1 --1--> 3
2 --0--> 3
```

Source = `0`

Initial:

```text
dist = [0, INF, INF, INF]
deque = [0]
```

| Step | Pop | Relaxation | Deque | Distance |
|---|---:|---|---|---|
| 1 | 0 | `0 -> 1` weight 0, push front | `[1]` | `[0, 0, INF, INF]` |
| 2 | 0 | `0 -> 2` weight 1, push back | `[1, 2]` | `[0, 0, 1, INF]` |
| 3 | 1 | `1 -> 3` weight 1, push back | `[2, 3]` | `[0, 0, 1, 1]` |
| 4 | 2 | `2 -> 3` gives `1`, no improvement | `[3]` | `[0, 0, 1, 1]` |
| 5 | 3 | no change | `[]` | `[0, 0, 1, 1]` |

Final shortest distances:

```text
[0, 0, 1, 1]
```

## 8. C++ Implementation

### 8.1 Queue Basics

```cpp
#include <bits/stdc++.h>
using namespace std;

void queueBasicsDemo() {
    queue<int> q;

    q.push(10);
    q.push(20);
    q.push(30);

    while (!q.empty()) {
        cout << q.front() << " ";
        q.pop();
    }
    cout << "\n";
}

int main() {
    queueBasicsDemo();
    return 0;
}
```

Output:

```text
10 20 30
```

### 8.2 Circular Queue Class

```cpp
#include <bits/stdc++.h>
using namespace std;

class CircularQueue {
private:
    vector<int> data;
    int frontIndex;
    int rearIndex;
    int count;
    int capacity;

public:
    CircularQueue(int size) {
        data.resize(size);
        frontIndex = 0;
        rearIndex = 0;
        count = 0;
        capacity = size;
    }

    bool isEmpty() const {
        return count == 0;
    }

    bool isFull() const {
        return count == capacity;
    }

    bool push(int value) {
        if (isFull()) {
            return false;
        }

        data[rearIndex] = value;
        rearIndex = (rearIndex + 1) % capacity;
        count++;
        return true;
    }

    bool pop() {
        if (isEmpty()) {
            return false;
        }

        frontIndex = (frontIndex + 1) % capacity;
        count--;
        return true;
    }

    int front() const {
        if (isEmpty()) {
            throw runtime_error("Queue is empty");
        }
        return data[frontIndex];
    }

    int size() const {
        return count;
    }
};

int main() {
    CircularQueue cq(3);

    cq.push(10);
    cq.push(20);
    cq.push(30);

    cout << cq.front() << "\n"; // 10
    cq.pop();

    cq.push(40);

    while (!cq.isEmpty()) {
        cout << cq.front() << " ";
        cq.pop();
    }

    return 0;
}
```

Output:

```text
10
20 30 40
```

### 8.3 BFS in an Unweighted Graph

```cpp
#include <bits/stdc++.h>
using namespace std;

vector<int> bfsShortestDistance(int n, vector<vector<int>>& graph, int source) {
    vector<int> distance(n, -1);
    queue<int> q;

    distance[source] = 0;
    q.push(source);

    while (!q.empty()) {
        int node = q.front();
        q.pop();

        for (int neighbor : graph[node]) {
            if (distance[neighbor] == -1) {
                distance[neighbor] = distance[node] + 1;
                q.push(neighbor);
            }
        }
    }

    return distance;
}

int main() {
    int n = 5;
    vector<vector<int>> graph(n);

    graph[0] = {1, 2};
    graph[1] = {0, 3};
    graph[2] = {0, 4};
    graph[3] = {1};
    graph[4] = {2};

    vector<int> distance = bfsShortestDistance(n, graph, 0);

    for (int d : distance) {
        cout << d << " ";
    }

    return 0;
}
```

Output:

```text
0 1 1 2 2
```

### 8.4 Sliding Window Maximum

```cpp
#include <bits/stdc++.h>
using namespace std;

vector<int> maxSlidingWindow(vector<int>& nums, int k) {
    vector<int> answer;
    deque<int> dq; // stores indices, values are decreasing

    for (int i = 0; i < (int)nums.size(); i++) {
        while (!dq.empty() && dq.front() <= i - k) {
            dq.pop_front();
        }

        while (!dq.empty() && nums[dq.back()] <= nums[i]) {
            dq.pop_back();
        }

        dq.push_back(i);

        if (i >= k - 1) {
            answer.push_back(nums[dq.front()]);
        }
    }

    return answer;
}

int main() {
    vector<int> nums = {1, 3, -1, -3, 5, 3, 6, 7};
    int k = 3;

    vector<int> answer = maxSlidingWindow(nums, k);

    for (int value : answer) {
        cout << value << " ";
    }

    return 0;
}
```

Output:

```text
3 3 5 5 6 7
```

### 8.5 First Negative in Every Window

```cpp
#include <bits/stdc++.h>
using namespace std;

vector<int> firstNegativeInWindow(vector<int>& nums, int k) {
    vector<int> answer;
    deque<int> dq; // stores indices of negative numbers

    for (int i = 0; i < (int)nums.size(); i++) {
        while (!dq.empty() && dq.front() <= i - k) {
            dq.pop_front();
        }

        if (nums[i] < 0) {
            dq.push_back(i);
        }

        if (i >= k - 1) {
            if (dq.empty()) {
                answer.push_back(0);
            } else {
                answer.push_back(nums[dq.front()]);
            }
        }
    }

    return answer;
}

int main() {
    vector<int> nums = {12, -1, -7, 8, -15, 30, 16, 28};
    int k = 3;

    vector<int> answer = firstNegativeInWindow(nums, k);

    for (int value : answer) {
        cout << value << " ";
    }

    return 0;
}
```

Output:

```text
-1 -1 -7 -15 -15 0
```

### 8.6 Rotten Oranges

```cpp
#include <bits/stdc++.h>
using namespace std;

int orangesRotting(vector<vector<int>>& grid) {
    int rows = grid.size();
    int cols = grid[0].size();
    queue<pair<int, int>> q;
    int fresh = 0;

    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (grid[r][c] == 2) {
                q.push({r, c});
            } else if (grid[r][c] == 1) {
                fresh++;
            }
        }
    }

    if (fresh == 0) {
        return 0;
    }

    vector<int> dr = {-1, 1, 0, 0};
    vector<int> dc = {0, 0, -1, 1};
    int minutes = 0;

    while (!q.empty()) {
        int levelSize = q.size();
        bool rottedThisMinute = false;

        for (int i = 0; i < levelSize; i++) {
            auto [r, c] = q.front();
            q.pop();

            for (int dir = 0; dir < 4; dir++) {
                int nr = r + dr[dir];
                int nc = c + dc[dir];

                if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) {
                    continue;
                }

                if (grid[nr][nc] == 1) {
                    grid[nr][nc] = 2;
                    fresh--;
                    rottedThisMinute = true;
                    q.push({nr, nc});
                }
            }
        }

        if (rottedThisMinute) {
            minutes++;
        }
    }

    return fresh == 0 ? minutes : -1;
}

int main() {
    vector<vector<int>> grid = {
        {2, 1, 1},
        {1, 1, 0},
        {0, 1, 1}
    };

    cout << orangesRotting(grid) << "\n";
    return 0;
}
```

Output:

```text
4
```

### 8.7 Task Scheduler

```cpp
#include <bits/stdc++.h>
using namespace std;

int leastInterval(vector<char>& tasks, int cooldown) {
    vector<int> frequency(26, 0);

    for (char task : tasks) {
        frequency[task - 'A']++;
    }

    int maxFreq = *max_element(frequency.begin(), frequency.end());
    int maxFreqCount = 0;

    for (int freq : frequency) {
        if (freq == maxFreq) {
            maxFreqCount++;
        }
    }

    int slotsNeeded = (maxFreq - 1) * (cooldown + 1) + maxFreqCount;
    return max((int)tasks.size(), slotsNeeded);
}

int main() {
    vector<char> tasks = {'A', 'A', 'A', 'B', 'B', 'B'};
    int cooldown = 2;

    cout << leastInterval(tasks, cooldown) << "\n";
    return 0;
}
```

Output:

```text
8
```

### 8.8 0-1 BFS

```cpp
#include <bits/stdc++.h>
using namespace std;

vector<int> zeroOneBFS(int n, vector<vector<pair<int, int>>>& graph, int source) {
    const int INF = 1e9;
    vector<int> distance(n, INF);
    deque<int> dq;

    distance[source] = 0;
    dq.push_front(source);

    while (!dq.empty()) {
        int node = dq.front();
        dq.pop_front();

        for (auto [neighbor, weight] : graph[node]) {
            if (distance[node] + weight < distance[neighbor]) {
                distance[neighbor] = distance[node] + weight;

                if (weight == 0) {
                    dq.push_front(neighbor);
                } else {
                    dq.push_back(neighbor);
                }
            }
        }
    }

    return distance;
}

int main() {
    int n = 4;
    vector<vector<pair<int, int>>> graph(n);

    graph[0].push_back({1, 0});
    graph[0].push_back({2, 1});
    graph[1].push_back({3, 1});
    graph[2].push_back({3, 0});

    vector<int> distance = zeroOneBFS(n, graph, 0);

    for (int d : distance) {
        cout << d << " ";
    }

    return 0;
}
```

Output:

```text
0 0 1 1
```

## pYTHON IMPLEMENTATION

### Queue Basics

```python
from collections import deque

q = deque()
q.append(10)
q.append(20)
q.append(30)

while q:
    print(q.popleft(), end=" ")
```

### Circular Queue

```python
class CircularQueue:
    def __init__(self, capacity):
        self.data = [0] * capacity
        self.capacity = capacity
        self.front_index = 0
        self.rear_index = 0
        self.count = 0

    def is_empty(self):
        return self.count == 0

    def is_full(self):
        return self.count == self.capacity

    def push(self, value):
        if self.is_full():
            return False
        self.data[self.rear_index] = value
        self.rear_index = (self.rear_index + 1) % self.capacity
        self.count += 1
        return True

    def pop(self):
        if self.is_empty():
            return False
        self.front_index = (self.front_index + 1) % self.capacity
        self.count -= 1
        return True

    def front(self):
        if self.is_empty():
            raise IndexError("Queue is empty")
        return self.data[self.front_index]


cq = CircularQueue(3)
cq.push(10)
cq.push(20)
cq.push(30)
print(cq.front())
cq.pop()
cq.push(40)

while not cq.is_empty():
    print(cq.front(), end=" ")
    cq.pop()
```

### BFS in an Unweighted Graph

```python
from collections import deque


def bfs_shortest_distance(graph, source):
    n = len(graph)
    distance = [-1] * n
    q = deque([source])
    distance[source] = 0

    while q:
        node = q.popleft()

        for neighbor in graph[node]:
            if distance[neighbor] == -1:
                distance[neighbor] = distance[node] + 1
                q.append(neighbor)

    return distance


graph = [
    [1, 2],
    [0, 3],
    [0, 4],
    [1],
    [2],
]

print(bfs_shortest_distance(graph, 0))
```

### Sliding Window Maximum

```python
from collections import deque


def max_sliding_window(nums, k):
    answer = []
    dq = deque()  # stores indices; values are decreasing

    for i, value in enumerate(nums):
        while dq and dq[0] <= i - k:
            dq.popleft()

        while dq and nums[dq[-1]] <= value:
            dq.pop()

        dq.append(i)

        if i >= k - 1:
            answer.append(nums[dq[0]])

    return answer


print(max_sliding_window([1, 3, -1, -3, 5, 3, 6, 7], 3))
```

### First Negative in Every Window

```python
from collections import deque


def first_negative_in_window(nums, k):
    answer = []
    dq = deque()  # stores indices of negative values

    for i, value in enumerate(nums):
        while dq and dq[0] <= i - k:
            dq.popleft()

        if value < 0:
            dq.append(i)

        if i >= k - 1:
            answer.append(nums[dq[0]] if dq else 0)

    return answer


print(first_negative_in_window([12, -1, -7, 8, -15, 30, 16, 28], 3))
```

### Rotten Oranges

```python
from collections import deque


def oranges_rotting(grid):
    rows, cols = len(grid), len(grid[0])
    q = deque()
    fresh = 0

    for r in range(rows):
        for c in range(cols):
            if grid[r][c] == 2:
                q.append((r, c))
            elif grid[r][c] == 1:
                fresh += 1

    if fresh == 0:
        return 0

    directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
    minutes = 0

    while q:
        level_size = len(q)
        rotted_this_minute = False

        for _ in range(level_size):
            r, c = q.popleft()

            for dr, dc in directions:
                nr, nc = r + dr, c + dc

                if 0 <= nr < rows and 0 <= nc < cols and grid[nr][nc] == 1:
                    grid[nr][nc] = 2
                    fresh -= 1
                    rotted_this_minute = True
                    q.append((nr, nc))

        if rotted_this_minute:
            minutes += 1

    return minutes if fresh == 0 else -1


grid = [
    [2, 1, 1],
    [1, 1, 0],
    [0, 1, 1],
]

print(oranges_rotting(grid))
```

### Task Scheduler

```python
from collections import Counter


def least_interval(tasks, cooldown):
    freq = Counter(tasks)
    max_freq = max(freq.values())
    max_freq_count = sum(1 for count in freq.values() if count == max_freq)

    slots_needed = (max_freq - 1) * (cooldown + 1) + max_freq_count
    return max(len(tasks), slots_needed)


print(least_interval(["A", "A", "A", "B", "B", "B"], 2))
```

### 0-1 BFS

```python
from collections import deque


def zero_one_bfs(graph, source):
    n = len(graph)
    inf = 10**18
    distance = [inf] * n
    dq = deque([source])
    distance[source] = 0

    while dq:
        node = dq.popleft()

        for neighbor, weight in graph[node]:
            new_dist = distance[node] + weight

            if new_dist < distance[neighbor]:
                distance[neighbor] = new_dist

                if weight == 0:
                    dq.appendleft(neighbor)
                else:
                    dq.append(neighbor)

    return distance


graph = [
    [(1, 0), (2, 1)],
    [(3, 1)],
    [(3, 0)],
    [],
]

print(zero_one_bfs(graph, 0))
```

## 10. Code Explanation

### Queue Basics

* `queue<int> q` creates a FIFO queue.
* `push` inserts at the back.
* `front` reads the oldest element.
* `pop` removes the oldest element.
* The loop continues until the queue becomes empty.

Important point:

```cpp
q.pop();
```

does not return the removed value in C++. Read `q.front()` before calling `pop()`.

### Circular Queue

The circular queue class stores:

| Variable | Purpose |
|---|---|
| `data` | Fixed-size array |
| `frontIndex` | Position of current front |
| `rearIndex` | Position where next value is inserted |
| `count` | Current number of elements |
| `capacity` | Maximum queue size |

Push:

```cpp
data[rearIndex] = value;
rearIndex = (rearIndex + 1) % capacity;
count++;
```

This inserts the value and wraps around when the rear reaches the end.

Pop:

```cpp
frontIndex = (frontIndex + 1) % capacity;
count--;
```

This logically removes the front element.

Edge handling:

* If `count == capacity`, push fails.
* If `count == 0`, pop fails.
* `front()` throws an error if the queue is empty.

### BFS

The BFS code uses:

```cpp
vector<int> distance(n, -1);
```

`-1` means unvisited.

When a neighbor is first discovered:

```cpp
distance[neighbor] = distance[node] + 1;
q.push(neighbor);
```

This works because the first time BFS reaches a node in an unweighted graph, it has found the shortest path to that node.

### Sliding Window Maximum

The deque stores indices, not values.

Remove expired indices:

```cpp
while (!dq.empty() && dq.front() <= i - k) {
    dq.pop_front();
}
```

If an index is outside the current window, it cannot be used.

Remove smaller values:

```cpp
while (!dq.empty() && nums[dq.back()] <= nums[i]) {
    dq.pop_back();
}
```

If the current value is greater than or equal to a previous value, that previous value is useless for future maximums.

Answer:

```cpp
answer.push_back(nums[dq.front()]);
```

The front always stores the index of the maximum value.

### First Negative in Every Window

Only negative numbers are stored in the deque.

For every new index:

* Remove expired negative indices.
* Add current index if it is negative.
* If the window is ready, front gives the first negative.

If the deque is empty, the window has no negative value, so answer is `0`.

### Rotten Oranges

The queue initially contains all rotten oranges.

Each BFS level represents one minute.

```cpp
int levelSize = q.size();
```

This freezes the current minute's oranges. Newly rotten oranges are processed in the next minute.

When a fresh orange is found:

```cpp
grid[nr][nc] = 2;
fresh--;
q.push({nr, nc});
```

Marking immediately avoids pushing the same orange multiple times.

### Task Scheduler

The greedy formula is based on the most frequent tasks.

Example:

```text
A A A, cooldown = 2
```

Arrange the most frequent task first:

```text
A _ _ A _ _ A
```

The number of base slots is:

```text
(maxFreq - 1) * (cooldown + 1) + maxFreqCount
```

Finally:

```cpp
return max((int)tasks.size(), slotsNeeded);
```

If there are enough other tasks to fill idle slots, answer is simply total task count.

### 0-1 BFS

The graph stores:

```cpp
neighbor, weight
```

For each relaxation:

```cpp
if (distance[node] + weight < distance[neighbor])
```

If a shorter path is found, update it.

Deque rule:

```cpp
if (weight == 0) dq.push_front(neighbor);
else dq.push_back(neighbor);
```

Weight `0` edges get priority because they do not increase the distance.

## 11. Complexity Analysis

| Topic | Preprocessing | Operation / Query | Overall Time | Space |
|---|---:|---:|---:|---:|
| Queue basics | `O(1)` | `O(1)` per operation | `O(number of operations)` | `O(n)` |
| Circular queue | `O(capacity)` | `O(1)` push/pop/front | `O(number of operations)` | `O(capacity)` |
| Deque | `O(1)` | `O(1)` at both ends | `O(number of operations)` | `O(n)` |
| BFS | `O(1)` | Visits node/edge once | `O(V + E)` | `O(V)` |
| Grid BFS | `O(1)` | Visits each cell once | `O(rows * cols)` | `O(rows * cols)` |
| Sliding window maximum | `O(1)` | Amortized `O(1)` per element | `O(n)` | `O(k)` |
| Monotonic deque | `O(1)` | Amortized `O(1)` per element | `O(n)` | `O(k)` or `O(n)` |
| First negative in window | `O(1)` | Amortized `O(1)` per element | `O(n)` | `O(k)` |
| Rotten oranges | `O(1)` | Each cell processed once | `O(rows * cols)` | `O(rows * cols)` |
| Task scheduler formula | `O(1)` for 26 tasks | `O(n)` counting | `O(n)` | `O(1)` |
| 0-1 BFS | `O(1)` | Edge relaxation | `O(V + E)` | `O(V)` |

Notes:

* Monotonic deque is `O(n)` because every index enters and leaves the deque at most once.
* BFS is `O(V + E)` for adjacency list representation.
* 0-1 BFS is faster than Dijkstra for weights `0` and `1`.

## 12. Common Patterns

| Pattern Name | How to Identify It | General Approach | Example Problems |
|---|---|---|---|
| FIFO simulation | Process in arrival order | Use queue | Implement Queue, Number of Students Unable to Eat Lunch |
| Level order traversal | Tree/graph levels | BFS queue | Binary Tree Level Order Traversal |
| Unweighted shortest path | Minimum steps/moves | BFS with distance array | Shortest Path in Binary Matrix |
| Multi-source BFS | Many starting points spread together | Push all sources initially | Rotten Oranges, 01 Matrix |
| Fixed sliding window | Every subarray of size `k` | Deque/queue depending on query | Sliding Window Maximum |
| Monotonic deque maximum | Need max/min in every window | Maintain decreasing/increasing deque | Sliding Window Maximum |
| First special element in window | First negative/first non-repeating | Store useful indices | First Negative Integer in Every Window |
| Cooldown scheduling | Task can be reused after time gap | Greedy formula or heap + queue | Task Scheduler |
| Binary edge weights | Edge weight only `0` or `1` | 0-1 BFS with deque | Minimum Cost to Make Valid Path in a Grid |
| Rot/infection/fire spread | Spread each minute | Grid multi-source BFS | Rotten Oranges, Fire Escape |

## 13. Common Mistakes

### Queue and Circular Queue

* Calling `front()` on an empty queue.
* Forgetting that `pop()` in C++ does not return the removed value.
* Not checking full condition in circular queue.
* Confusing `frontIndex` and `rearIndex`.
* Forgetting modulo while moving circular indices.
* Using only `front == rear` to detect both empty and full without an extra variable.

### BFS

* Marking visited after popping instead of when pushing, causing duplicate pushes.
* Using BFS for weighted graphs with arbitrary weights.
* Forgetting disconnected components.
* Not initializing distance correctly.
* Missing boundary checks in grid BFS.
* Counting BFS levels incorrectly.

### Sliding Window and Monotonic Deque

* Storing values instead of indices, making it hard to remove expired elements.
* Using `<` instead of `<=` incorrectly for duplicate handling.
* Forgetting to remove out-of-window indices.
* Adding answer before the first full window is formed.
* Thinking nested `while` loops make it `O(nk)`. They are amortized `O(n)`.

### Rotten Oranges

* Processing newly rotten oranges in the same minute.
* Forgetting to count unreachable fresh oranges.
* Not handling the case with no fresh oranges.
* Not marking oranges rotten immediately when pushed.

### Task Scheduler

* Forgetting multiple tasks can share the maximum frequency.
* Returning only the formula without taking max with total tasks.
* Misunderstanding idle slots when many other tasks exist.

### 0-1 BFS

* Using normal BFS for weights `0` and `1`.
* Pushing all neighbors to the back.
* Using 0-1 BFS when weights are not binary.
* Forgetting relaxation check before pushing.
* Not using a large enough infinity value.

## 14. Edge Cases

| Topic | Edge Cases to Test |
|---|---|
| Queue basics | Empty queue, one element, many pushes then pops |
| Circular queue | Capacity `1`, full queue, empty queue, wrap-around after pop |
| Deque | Push/pop from both ends, empty deque access |
| BFS | Single node, disconnected graph, cycle, multiple components |
| Grid BFS | Empty-like grid, one cell, blocked cells, all sources, no source |
| Sliding window maximum | `k = 1`, `k = n`, all equal, increasing array, decreasing array |
| First negative in window | No negatives, all negatives, negative at window boundary |
| Rotten oranges | No fresh oranges, no rotten oranges, unreachable fresh orange, all rotten |
| Task scheduler | `cooldown = 0`, all tasks same, all tasks different, many max-frequency tasks |
| 0-1 BFS | All weights `0`, all weights `1`, unreachable nodes, cycles, duplicate edges |

Important examples:

```text
Sliding window:
nums = [5], k = 1
answer = [5]

Rotten oranges:
grid = [[0, 2]]
answer = 0

Task scheduler:
tasks = [A, B, C], cooldown = 0
answer = 3

0-1 BFS:
unreachable node distance remains INF
```

## 15. Variations

| Variation | What Changes | When Used | Importance |
|---|---|---|---|
| Simple queue | Only front removal and back insertion | FIFO processing | Very important |
| Circular queue | Fixed array with wrap-around | Memory-constrained queues | Important for DS rounds |
| Deque | Both-end operations | Flexible queue/stack behavior | Very important |
| Monotonic increasing deque | Front stores minimum | Sliding window minimum | Very important |
| Monotonic decreasing deque | Front stores maximum | Sliding window maximum | Very important |
| BFS with distance | Store shortest distance | Unweighted shortest path | Very important |
| BFS with parent | Store path reconstruction | Print shortest path | Important |
| Multi-source BFS | Start from many nodes | Spread/nearest source problems | Very important |
| Bidirectional BFS | BFS from source and target | Large shortest path search | Medium importance |
| 0-1 BFS | Deque based shortest path | Binary edge weights | Very important for CP |
| Heap + queue scheduler | Simulate cooldown exactly | Scheduling variants | Medium importance |

### Placement vs CP Importance

| Topic | Placement | Competitive Programming |
|---|---|---|
| Queue basics | High | Medium |
| Circular queue | High for DS interviews | Low to Medium |
| BFS | Very High | Very High |
| Sliding window maximum | Very High | Very High |
| Monotonic deque | High | Very High |
| Rotten oranges | Very High | Medium |
| Task scheduler | High | Medium |
| 0-1 BFS | Medium | Very High |

## 16. Related Algorithms/Data Structures

| Topic | Connection | How to Choose |
|---|---|---|
| Stack | LIFO instead of FIFO | Use stack for undo, DFS, next greater element |
| Priority queue / heap | Processes highest/lowest priority first | Use heap for Dijkstra or scheduling by priority |
| BFS | Queue-based graph traversal | Use for shortest path in unweighted graph |
| DFS | Goes deep before wide | Use for components, recursion, backtracking |
| Dijkstra | Shortest path with positive weights | Use when weights are not just `0` and `1` |
| 0-1 BFS | Special Dijkstra optimization | Use only for weights `0` and `1` |
| Segment tree | Range queries with updates | Use when many range queries and updates exist |
| Sparse table | Static range min/max queries | Use when no updates and many queries |
| Heap vs Monotonic deque | Both can find max/min | Use deque for fixed sliding window in `O(n)`, heap for flexible priority |
| Queue vs Deque | Deque is more flexible | Use queue for simple FIFO, deque when both ends matter |

### BFS vs Dijkstra vs 0-1 BFS

| Problem Type | Best Algorithm |
|---|---|
| Unweighted graph | BFS |
| Edge weights only `0` and `1` | 0-1 BFS |
| Positive weighted graph | Dijkstra |
| Negative edges | Bellman-Ford or specialized approach |

### Sliding Window: Deque vs Heap vs Segment Tree

| Requirement | Best Choice |
|---|---|
| Maximum in every fixed window | Monotonic deque |
| Dynamic insert/delete with priority | Heap with lazy deletion |
| Many arbitrary range max queries | Segment tree / sparse table |

## 17. Practice Problems

### Easy

| Problem | Platform | Main Idea / Pattern | Difficulty |
|---|---|---|---|
| Implement Queue using Stacks | LeetCode | Queue behavior using two stacks | Easy |
| Number of Recent Calls | LeetCode | Queue for recent timestamp window | Easy |

### Medium

| Problem | Platform | Main Idea / Pattern | Difficulty |
|---|---|---|---|
| Binary Tree Level Order Traversal | LeetCode | BFS using queue | Medium |
| Rotting Oranges | LeetCode | Multi-source BFS | Medium |
| Task Scheduler | LeetCode | Greedy frequency formula / scheduling | Medium |

### Hard

| Problem | Platform | Main Idea / Pattern | Difficulty |
|---|---|---|---|
| Sliding Window Maximum | LeetCode | Monotonic deque | Hard |
| Minimum Cost to Make at Least One Valid Path in a Grid | LeetCode | 0-1 BFS | Hard |
| Monsters | CSES | Multi-source BFS + player BFS | Hard |

Additional good practice:

| Problem | Platform | Pattern |
|---|---|---|
| First Negative Integer in Every Window of Size K | GFG | Queue/deque of negative indices |
| 01 Matrix | LeetCode | Multi-source BFS |
| Shortest Path in Binary Matrix | LeetCode | Grid BFS |
| Labyrinth | CSES | BFS with parent reconstruction |
| Chef and Reversing | CodeChef | 0-1 BFS |

## 18. Interview Explanation

A queue is a FIFO data structure where insertion happens at the back and deletion happens from the front. It is useful whenever we need to process elements in the order they arrive, especially in BFS. In BFS, we push the source first, then process nodes level by level, which gives the shortest distance in an unweighted graph.

A deque is a double-ended queue that supports insertion and deletion from both ends. It is useful in sliding window problems and 0-1 BFS. For sliding window maximum, I use a monotonic deque of indices so that the front always stores the maximum of the current window. For 0-1 BFS, I push zero-weight edges to the front and one-weight edges to the back, which gives shortest paths in `O(V + E)` for graphs with edge weights only `0` and `1`.

## 19. Revision Notes

* Queue follows FIFO: first inserted, first removed.
* Deque supports both front and back operations.
* BFS uses queue and works for shortest path in unweighted graphs.
* Mark visited when pushing into the queue, not after popping.
* Circular queue wrap formula: `(index + 1) % capacity`.
* Sliding window maximum uses decreasing monotonic deque.
* Store indices in monotonic deque, not only values.
* Remove expired indices using `dq.front() <= i - k`.
* First negative in every window stores indices of negative numbers.
* Rotten oranges is multi-source BFS.
* Task scheduler formula:

```text
max(totalTasks, (maxFreq - 1) * (cooldown + 1) + maxFreqCount)
```

* 0-1 BFS:

```text
weight 0 -> push_front
weight 1 -> push_back
```

* BFS time complexity: `O(V + E)`.
* Sliding window maximum time complexity: `O(n)`.
* 0-1 BFS time complexity: `O(V + E)`.
* Use Dijkstra instead of 0-1 BFS if weights are not only `0` and `1`.

## 20. Final Cheat Sheet

| Topic | When to Use | Main Operations | Complexity | Key Code Idea | Edge Cases |
|---|---|---|---|---|---|
| Queue | FIFO processing | `push`, `front`, `pop` | `O(1)` per op | Process front first | Empty queue |
| Circular Queue | Fixed-size queue | Move front/rear by modulo | `O(1)` per op | `(idx + 1) % capacity` | Full vs empty |
| Deque | Both ends needed | `push_front`, `push_back`, `pop_front`, `pop_back` | `O(1)` per op | Use front/back based on priority | Empty deque |
| BFS | Unweighted shortest path | Push unvisited neighbors | `O(V + E)` | Queue + distance array | Disconnected graph |
| Grid BFS | Minimum moves in grid | Four/eight directions | `O(R*C)` | Boundary check + visited | Blocked cells |
| Multi-source BFS | Spread from many starts | Push all sources first | `O(V + E)` or `O(R*C)` | All sources start at distance `0` | No source, unreachable cells |
| Sliding Window Maximum | Max in every window `k` | Pop expired front, pop smaller back | `O(n)` | Decreasing deque of indices | `k=1`, duplicates |
| First Negative Window | First negative in every window | Store negative indices | `O(n)` | Front is first negative | No negatives |
| Rotten Oranges | Rot spreads per minute | BFS by levels | `O(R*C)` | Queue initially has all rotten oranges | Fresh unreachable |
| Task Scheduler | Tasks with cooldown | Frequency counting | `O(n)` | Most frequent task controls idle slots | `cooldown=0` |
| 0-1 BFS | Shortest path with weights `0/1` | `push_front` for 0, `push_back` for 1 | `O(V + E)` | Deque-based relaxation | Non-binary weights |

Core templates to remember:

```cpp
// BFS
queue<int> q;
distance[source] = 0;
q.push(source);

while (!q.empty()) {
    int node = q.front();
    q.pop();

    for (int neighbor : graph[node]) {
        if (distance[neighbor] == -1) {
            distance[neighbor] = distance[node] + 1;
            q.push(neighbor);
        }
    }
}
```

```cpp
// Sliding window maximum
deque<int> dq;

for (int i = 0; i < n; i++) {
    while (!dq.empty() && dq.front() <= i - k) {
        dq.pop_front();
    }

    while (!dq.empty() && nums[dq.back()] <= nums[i]) {
        dq.pop_back();
    }

    dq.push_back(i);

    if (i >= k - 1) {
        answer.push_back(nums[dq.front()]);
    }
}
```

```cpp
// 0-1 BFS
deque<int> dq;
distance[source] = 0;
dq.push_front(source);

while (!dq.empty()) {
    int node = dq.front();
    dq.pop_front();

    for (auto [neighbor, weight] : graph[node]) {
        if (distance[node] + weight < distance[neighbor]) {
            distance[neighbor] = distance[node] + weight;

            if (weight == 0) {
                dq.push_front(neighbor);
            } else {
                dq.push_back(neighbor);
            }
        }
    }
}
```

Final memory hook:

```text
Queue  -> FIFO -> BFS
Deque  -> Both ends -> Sliding window + 0-1 BFS
Front  -> Current answer / next item to process
Back   -> New candidates / lower priority items
```
