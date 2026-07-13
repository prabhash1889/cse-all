# Sorting Algorithms

## 1. Overview

Sorting means arranging elements in a chosen order, usually increasing or decreasing.

In placements, online assessments, and competitive programming, sorting is not just a basic operation. It is often the first step that makes a harder problem simpler:

* Sort numbers, then use two pointers.
* Sort intervals, then merge or greedily choose.
* Sort jobs, then maximize profit or minimize waiting time.
* Sort graph nodes topologically when dependency order matters.
* Sort strings/numbers with non-comparison techniques when values have a limited range.

This guide covers:

* Selection sort
* Bubble sort
* Insertion sort
* Merge sort
* Quick sort
* Counting sort
* Custom comparator
* Sorting intervals
* Stable vs unstable sort
* Radix sort
* Bucket sort
* Topological sorting
* Sort + greedy
* External sorting
* TimSort idea

For interviews and CP, you should know both:

1. How standard sorting algorithms work internally.
2. How to use sorting as a problem-solving technique.

## 2. Intuition

Sorting is useful because order reveals structure.

If data is unsorted, every element can be anywhere. After sorting:

* Smaller values come before larger values.
* Equal values become adjacent.
* Intervals with earlier starts come first.
* Greedy choices become easier to justify.
* Duplicate counting becomes simpler.
* Binary search becomes possible.

Think of sorting like arranging books by height before comparing them. Without order, every comparison is random. With order, nearby items are naturally related.

Different sorting algorithms use different ideas:

| Algorithm | Core intuition |
|---|---|
| Selection sort | Repeatedly pick the smallest remaining element |
| Bubble sort | Repeatedly swap adjacent wrong pairs |
| Insertion sort | Insert each element into its correct position in the sorted prefix |
| Merge sort | Split, sort both halves, then merge |
| Quick sort | Pick a pivot, put smaller elements left and larger elements right |
| Counting sort | Count frequencies instead of comparing |
| Radix sort | Sort digits from least significant to most significant |
| Bucket sort | Distribute values into buckets, sort each bucket |
| Topological sort | Order nodes so every dependency appears before the dependent node |
| TimSort | Use natural sorted runs, then merge efficiently |

Why sorting works:

* Comparison sorting works by repeatedly using pairwise order decisions.
* Divide-and-conquer sorting works because sorted smaller pieces can be combined.
* Counting-based sorting works when values can be mapped to small integer indexes.
* Topological sorting works because nodes with zero remaining dependencies can safely come next.

## 3. When to Use It

Use sorting when the problem has clues like:

* "Find pairs/triplets with sum..."
* "Merge overlapping intervals"
* "Minimum number of platforms/rooms"
* "Schedule maximum activities"
* "Assign cookies/tasks/resources"
* "Find kth smallest/largest"
* "Group anagrams"
* "Count inversions"
* "Order by deadline/profit/start time"
* "Arrange to form largest number"
* "Dependency order"
* "Prerequisites"
* "Lexicographically smallest/topological order"
* "Values are in range 0 to k"
* "Sort huge file that does not fit in memory"

Common uses:

* Use `sort()` for general arrays/vectors.
* Use custom comparator for special ordering.
* Use interval sorting for merge/scheduling problems.
* Use counting sort when range is small.
* Use radix sort for fixed-width integer/string keys.
* Use topological sort when ordering depends on directed dependencies.
* Use external sorting for massive data outside memory.

## 4. When Not to Use It

Sorting is not always suitable.

| Situation | Better approach |
|---|---|
| Need frequent insert/delete with sorted order | Balanced BST, multiset, ordered set |
| Need min/max repeatedly | Heap |
| Need exact frequency only | Hash map |
| Need preserve original order | Stable algorithm or avoid sorting |
| Need one kth element only | Quickselect or heap |
| Values are too large for counting sort | Comparison sort or coordinate compression |
| Graph has cycles and asks dependency order | Topological ordering does not exist |
| Streaming data too large to store | Heap/windowing/external processing |
| Already nearly sorted small data | Insertion sort or TimSort-style method |

Common wrong assumptions:

* Sorting is always `O(n log n)`. Counting/radix can be linear under constraints.
* `std::sort` is stable. It is not guaranteed stable; use `stable_sort`.
* Custom comparators can use `<=`. They must define strict ordering using `<`.
* Topological sort is the same as numeric sorting. It is dependency-based ordering.
* Sorting intervals by end time and by start time solve different problems.

## 5. Core Concepts

### Comparison Sort

Comparison sort orders elements by comparing pairs.

Examples:

* Selection sort
* Bubble sort
* Insertion sort
* Merge sort
* Quick sort
* Heap sort
* `std::sort`

Why it matters:

* General-purpose comparison sorting has a lower bound of `Omega(n log n)` comparisons.
* If no special value constraints exist, this is usually the right family.

### Stable Sort

A stable sort keeps equal elements in their original relative order.

Example:

Initial records:

| Name | Marks | Original order |
|---|---:|---:|
| A | 90 | 1 |
| B | 80 | 2 |
| C | 90 | 3 |

Stable sort by marks descending gives:

| Name | Marks |
|---|---:|
| A | 90 |
| C | 90 |
| B | 80 |

`A` remains before `C` because both have equal marks.

Why it matters:

* Multi-key sorting often relies on stability.
* Example: sort by name, then stable sort by marks.

### Unstable Sort

An unstable sort may change the relative order of equal elements.

Examples:

* Selection sort is usually unstable.
* Quick sort is usually unstable.
* `std::sort` is not stable.

Use unstable sort when equal elements do not need original order preserved.

### In-place Sort

An in-place sort uses constant or small extra memory.

Examples:

* Selection sort
* Bubble sort
* Insertion sort
* Quick sort, ignoring recursion stack

Why it matters:

* Useful when memory limits are strict.

### Divide and Conquer

Divide the array into smaller parts, solve them, then combine.

Used by:

* Merge sort
* Quick sort

Why it matters:

* Gives clean recursive solutions.
* Often leads to `O(n log n)` time.

### Custom Comparator

A custom comparator defines your own order.

Example:

```cpp
sort(v.begin(), v.end(), [](const pair<int, int>& a, const pair<int, int>& b) {
    if (a.first != b.first) return a.first < b.first;
    return a.second > b.second;
});
```

This sorts by first value ascending, and if tied, second value descending.

Comparator rule:

* Return `true` only if `a` must come before `b`.
* Do not use `<=` or `>=`.

### Interval Sorting

Intervals are usually sorted by:

* Start time for merging overlaps.
* End time for activity selection.
* Start event/end event for sweep line.

Example:

`[1,3], [2,6], [8,10]`

Sort by start and merge first two into `[1,6]`.

### Topological Sorting

Topological sorting orders directed graph nodes so every edge `u -> v` places `u` before `v`.

Used for:

* Course schedule
* Build systems
* Task dependencies
* Alien dictionary

It only works on DAGs: directed acyclic graphs.

### External Sorting

External sorting is used when the data is too large to fit in memory.

Basic idea:

1. Read chunks that fit in memory.
2. Sort each chunk.
3. Write sorted chunks to disk.
4. Merge chunks using a min-heap.

### TimSort Idea

TimSort is a hybrid sorting algorithm used in languages like Python and Java object sorting.

Core idea:

* Real-world data often contains already sorted portions called runs.
* TimSort detects runs.
* Small runs are extended using insertion sort.
* Runs are merged like merge sort.

It is important conceptually, but you usually do not implement full TimSort in interviews.

## 6. Step-by-Step Algorithm

### Selection Sort

1. Start from index `i = 0`.
2. Find the minimum element from index `i` to `n - 1`.
3. Swap it with element at index `i`.
4. Move `i` forward.
5. Repeat until array is sorted.

### Bubble Sort

1. Compare adjacent pairs.
2. If a pair is in wrong order, swap it.
3. After one full pass, the largest element reaches the end.
4. Repeat for remaining unsorted part.
5. Stop early if a pass has no swaps.

### Insertion Sort

1. Treat the first element as sorted.
2. Pick the next element as `key`.
3. Shift larger elements in the sorted prefix one position right.
4. Insert `key` in the empty position.
5. Repeat for all elements.

### Merge Sort

1. If the array has one or zero elements, it is already sorted.
2. Split the array into two halves.
3. Recursively sort the left half.
4. Recursively sort the right half.
5. Merge both sorted halves.

### Quick Sort

1. Choose a pivot.
2. Partition the array so smaller elements go left and larger elements go right.
3. Recursively quicksort the left partition.
4. Recursively quicksort the right partition.
5. Stop when partition size is zero or one.

### Counting Sort

1. Find the value range.
2. Count frequency of each value.
3. Convert counts into prefix positions if stability is needed.
4. Place elements into output using counts.
5. Copy output back.

### Radix Sort

1. Sort numbers by unit digit using stable counting sort.
2. Sort by tens digit.
3. Continue for each digit.
4. Because each digit sort is stable, final numbers become fully sorted.

### Bucket Sort

1. Create buckets for value ranges.
2. Place each element into its bucket.
3. Sort each bucket individually.
4. Concatenate buckets.

### Topological Sort using Kahn's Algorithm

1. Compute indegree of every node.
2. Push all nodes with indegree `0` into a queue.
3. Pop a node and add it to answer.
4. Decrease indegree of its neighbors.
5. If any neighbor becomes indegree `0`, push it.
6. If answer size is less than number of nodes, a cycle exists.

## 7. Dry Run

### Merge Sort Dry Run

Input:

```text
[5, 2, 4, 1, 3]
```

Split phase:

```text
[5, 2, 4, 1, 3]
left  = [5, 2]
right = [4, 1, 3]

[5, 2] -> [5] and [2]
[4, 1, 3] -> [4] and [1, 3]
[1, 3] -> [1] and [3]
```

Merge phase:

| Merge | Result |
|---|---|
| `[5] + [2]` | `[2, 5]` |
| `[1] + [3]` | `[1, 3]` |
| `[4] + [1, 3]` | `[1, 3, 4]` |
| `[2, 5] + [1, 3, 4]` | `[1, 2, 3, 4, 5]` |

Final answer:

```text
[1, 2, 3, 4, 5]
```

### Quick Sort Partition Dry Run

Input:

```text
[7, 2, 1, 8, 6, 3, 5]
```

Choose pivot `5`.

| Element | Action | Left side | Right side |
|---:|---|---|---|
| 7 | greater than pivot | `[]` | `[7]` |
| 2 | smaller than pivot | `[2]` | `[7]` |
| 1 | smaller than pivot | `[2, 1]` | `[7]` |
| 8 | greater than pivot | `[2, 1]` | `[7, 8]` |
| 6 | greater than pivot | `[2, 1]` | `[7, 8, 6]` |
| 3 | smaller than pivot | `[2, 1, 3]` | `[7, 8, 6]` |

After partition:

```text
[2, 1, 3] + [5] + [7, 8, 6]
```

Then recursively sort both sides.

### Counting Sort Dry Run

Input:

```text
[4, 2, 2, 8, 3, 3, 1]
```

Frequency:

| Value | Count |
|---:|---:|
| 1 | 1 |
| 2 | 2 |
| 3 | 2 |
| 4 | 1 |
| 8 | 1 |

Output by counts:

```text
1, 2, 2, 3, 3, 4, 8
```

### Topological Sort Dry Run

Edges:

```text
0 -> 1
0 -> 2
1 -> 3
2 -> 3
```

Initial indegree:

| Node | Indegree |
|---:|---:|
| 0 | 0 |
| 1 | 1 |
| 2 | 1 |
| 3 | 2 |

Queue starts with `[0]`.

| Step | Popped | Queue after updates | Answer |
|---:|---:|---|---|
| 1 | 0 | `[1, 2]` | `[0]` |
| 2 | 1 | `[2]` | `[0, 1]` |
| 3 | 2 | `[3]` | `[0, 1, 2]` |
| 4 | 3 | `[]` | `[0, 1, 2, 3]` |

Valid topological order:

```text
[0, 1, 2, 3]
```

`[0, 2, 1, 3]` is also valid.

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

void selectionSort(vector<int>& a) {
    int n = (int)a.size();

    for (int i = 0; i < n; i++) {
        int minIndex = i;

        for (int j = i + 1; j < n; j++) {
            if (a[j] < a[minIndex]) {
                minIndex = j;
            }
        }

        swap(a[i], a[minIndex]);
    }
}

void bubbleSort(vector<int>& a) {
    int n = (int)a.size();

    for (int pass = 0; pass < n - 1; pass++) {
        bool swapped = false;

        for (int i = 0; i + 1 < n - pass; i++) {
            if (a[i] > a[i + 1]) {
                swap(a[i], a[i + 1]);
                swapped = true;
            }
        }

        if (!swapped) break;
    }
}

void insertionSort(vector<int>& a) {
    int n = (int)a.size();

    for (int i = 1; i < n; i++) {
        int key = a[i];
        int j = i - 1;

        while (j >= 0 && a[j] > key) {
            a[j + 1] = a[j];
            j--;
        }

        a[j + 1] = key;
    }
}

void mergeParts(vector<int>& a, int left, int mid, int right) {
    vector<int> temp;
    int i = left;
    int j = mid + 1;

    while (i <= mid && j <= right) {
        if (a[i] <= a[j]) {
            temp.push_back(a[i++]); // <= keeps merge sort stable
        } else {
            temp.push_back(a[j++]);
        }
    }

    while (i <= mid) temp.push_back(a[i++]);
    while (j <= right) temp.push_back(a[j++]);

    for (int k = 0; k < (int)temp.size(); k++) {
        a[left + k] = temp[k];
    }
}

void mergeSort(vector<int>& a, int left, int right) {
    if (left >= right) return;

    int mid = left + (right - left) / 2;
    mergeSort(a, left, mid);
    mergeSort(a, mid + 1, right);
    mergeParts(a, left, mid, right);
}

int partitionArray(vector<int>& a, int low, int high) {
    int pivot = a[high];
    int smallerBoundary = low - 1;

    for (int i = low; i < high; i++) {
        if (a[i] <= pivot) {
            smallerBoundary++;
            swap(a[smallerBoundary], a[i]);
        }
    }

    swap(a[smallerBoundary + 1], a[high]);
    return smallerBoundary + 1;
}

void quickSort(vector<int>& a, int low, int high) {
    if (low >= high) return;

    int pivotIndex = partitionArray(a, low, high);
    quickSort(a, low, pivotIndex - 1);
    quickSort(a, pivotIndex + 1, high);
}

vector<int> countingSortNonNegative(const vector<int>& a) {
    if (a.empty()) return {};

    int maxValue = *max_element(a.begin(), a.end());
    vector<int> count(maxValue + 1, 0);

    for (int x : a) {
        count[x]++;
    }

    vector<int> sorted;
    sorted.reserve(a.size());

    for (int value = 0; value <= maxValue; value++) {
        while (count[value]--) {
            sorted.push_back(value);
        }
    }

    return sorted;
}

vector<int> countingSortWithNegatives(const vector<int>& a) {
    if (a.empty()) return {};

    int minValue = *min_element(a.begin(), a.end());
    int maxValue = *max_element(a.begin(), a.end());
    int range = maxValue - minValue + 1;

    vector<int> count(range, 0);
    for (int x : a) {
        count[x - minValue]++;
    }

    vector<int> sorted;
    sorted.reserve(a.size());

    for (int i = 0; i < range; i++) {
        while (count[i]--) {
            sorted.push_back(i + minValue);
        }
    }

    return sorted;
}

void countingSortByDigit(vector<int>& a, int place) {
    int n = (int)a.size();
    vector<int> output(n);
    vector<int> count(10, 0);

    for (int x : a) {
        int digit = (x / place) % 10;
        count[digit]++;
    }

    for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
    }

    for (int i = n - 1; i >= 0; i--) {
        int digit = (a[i] / place) % 10;
        output[count[digit] - 1] = a[i];
        count[digit]--;
    }

    a = output;
}

void radixSortNonNegative(vector<int>& a) {
    if (a.empty()) return;

    int maxValue = *max_element(a.begin(), a.end());

    for (int place = 1; maxValue / place > 0; place *= 10) {
        countingSortByDigit(a, place);
    }
}

void bucketSortForZeroToOne(vector<double>& a) {
    int n = (int)a.size();
    if (n <= 1) return;

    vector<vector<double>> buckets(n);

    for (double x : a) {
        int bucketIndex = min(n - 1, (int)(x * n));
        buckets[bucketIndex].push_back(x);
    }

    for (auto& bucket : buckets) {
        sort(bucket.begin(), bucket.end());
    }

    int index = 0;
    for (auto& bucket : buckets) {
        for (double x : bucket) {
            a[index++] = x;
        }
    }
}

vector<vector<int>> mergeIntervals(vector<vector<int>> intervals) {
    if (intervals.empty()) return {};

    sort(intervals.begin(), intervals.end(), [](const vector<int>& a, const vector<int>& b) {
        if (a[0] != b[0]) return a[0] < b[0];
        return a[1] < b[1];
    });

    vector<vector<int>> merged;
    merged.push_back(intervals[0]);

    for (int i = 1; i < (int)intervals.size(); i++) {
        if (intervals[i][0] <= merged.back()[1]) {
            merged.back()[1] = max(merged.back()[1], intervals[i][1]);
        } else {
            merged.push_back(intervals[i]);
        }
    }

    return merged;
}

int maxNonOverlappingActivities(vector<pair<int, int>> activities) {
    sort(activities.begin(), activities.end(), [](const auto& a, const auto& b) {
        if (a.second != b.second) return a.second < b.second;
        return a.first < b.first;
    });

    int count = 0;
    int lastEnd = INT_MIN;

    for (auto [start, end] : activities) {
        if (start >= lastEnd) {
            count++;
            lastEnd = end;
        }
    }

    return count;
}

vector<int> topologicalSortKahn(int n, vector<vector<int>>& graph) {
    vector<int> indegree(n, 0);

    for (int u = 0; u < n; u++) {
        for (int v : graph[u]) {
            indegree[v]++;
        }
    }

    queue<int> q;
    for (int node = 0; node < n; node++) {
        if (indegree[node] == 0) {
            q.push(node);
        }
    }

    vector<int> order;

    while (!q.empty()) {
        int node = q.front();
        q.pop();
        order.push_back(node);

        for (int neighbor : graph[node]) {
            indegree[neighbor]--;
            if (indegree[neighbor] == 0) {
                q.push(neighbor);
            }
        }
    }

    if ((int)order.size() != n) {
        return {}; // cycle exists
    }

    return order;
}

void printVector(const vector<int>& a) {
    for (int x : a) cout << x << ' ';
    cout << '\n';
}

int main() {
    vector<int> a = {5, 2, 4, 1, 3};

    vector<int> b = a;
    mergeSort(b, 0, (int)b.size() - 1);
    cout << "Merge sort: ";
    printVector(b);

    b = a;
    quickSort(b, 0, (int)b.size() - 1);
    cout << "Quick sort: ";
    printVector(b);

    vector<int> c = {4, 2, 2, 8, 3, 3, 1};
    vector<int> counted = countingSortNonNegative(c);
    cout << "Counting sort: ";
    printVector(counted);

    vector<vector<int>> intervals = {{1, 3}, {2, 6}, {8, 10}, {15, 18}};
    vector<vector<int>> merged = mergeIntervals(intervals);
    cout << "Merged intervals: ";
    for (auto& interval : merged) {
        cout << "[" << interval[0] << "," << interval[1] << "] ";
    }
    cout << '\n';

    int n = 4;
    vector<vector<int>> graph(n);
    graph[0] = {1, 2};
    graph[1] = {3};
    graph[2] = {3};

    vector<int> topo = topologicalSortKahn(n, graph);
    cout << "Topological sort: ";
    printVector(topo);

    return 0;
}
```

Sample output:

```text
Merge sort: 1 2 3 4 5
Quick sort: 1 2 3 4 5
Counting sort: 1 2 2 3 3 4 8
Merged intervals: [1,6] [8,10] [15,18]
Topological sort: 0 1 2 3
```

## pYTHON IMPLEMENTATION

```python
from collections import deque


def selection_sort(a):
    a = a[:]
    n = len(a)

    for i in range(n):
        min_index = i
        for j in range(i + 1, n):
            if a[j] < a[min_index]:
                min_index = j
        a[i], a[min_index] = a[min_index], a[i]

    return a


def bubble_sort(a):
    a = a[:]
    n = len(a)

    for pass_no in range(n - 1):
        swapped = False
        for i in range(0, n - 1 - pass_no):
            if a[i] > a[i + 1]:
                a[i], a[i + 1] = a[i + 1], a[i]
                swapped = True
        if not swapped:
            break

    return a


def insertion_sort(a):
    a = a[:]

    for i in range(1, len(a)):
        key = a[i]
        j = i - 1

        while j >= 0 and a[j] > key:
            a[j + 1] = a[j]
            j -= 1

        a[j + 1] = key

    return a


def merge_sort(a):
    if len(a) <= 1:
        return a[:]

    mid = len(a) // 2
    left = merge_sort(a[:mid])
    right = merge_sort(a[mid:])

    result = []
    i = j = 0

    while i < len(left) and j < len(right):
        if left[i] <= right[j]:
            result.append(left[i])
            i += 1
        else:
            result.append(right[j])
            j += 1

    result.extend(left[i:])
    result.extend(right[j:])
    return result


def quick_sort(a):
    a = a[:]

    def partition(low, high):
        pivot = a[high]
        smaller_boundary = low - 1

        for i in range(low, high):
            if a[i] <= pivot:
                smaller_boundary += 1
                a[smaller_boundary], a[i] = a[i], a[smaller_boundary]

        a[smaller_boundary + 1], a[high] = a[high], a[smaller_boundary + 1]
        return smaller_boundary + 1

    def solve(low, high):
        if low >= high:
            return

        pivot_index = partition(low, high)
        solve(low, pivot_index - 1)
        solve(pivot_index + 1, high)

    solve(0, len(a) - 1)
    return a


def counting_sort(a):
    if not a:
        return []

    min_value = min(a)
    max_value = max(a)
    count = [0] * (max_value - min_value + 1)

    for x in a:
        count[x - min_value] += 1

    result = []
    for i, freq in enumerate(count):
        result.extend([i + min_value] * freq)

    return result


def radix_sort_non_negative(a):
    a = a[:]
    if not a:
        return []

    place = 1
    max_value = max(a)

    while max_value // place > 0:
        output = [0] * len(a)
        count = [0] * 10

        for x in a:
            digit = (x // place) % 10
            count[digit] += 1

        for i in range(1, 10):
            count[i] += count[i - 1]

        for i in range(len(a) - 1, -1, -1):
            digit = (a[i] // place) % 10
            output[count[digit] - 1] = a[i]
            count[digit] -= 1

        a = output
        place *= 10

    return a


def bucket_sort_zero_to_one(a):
    a = a[:]
    n = len(a)
    if n <= 1:
        return a

    buckets = [[] for _ in range(n)]

    for x in a:
        index = min(n - 1, int(x * n))
        buckets[index].append(x)

    result = []
    for bucket in buckets:
        result.extend(sorted(bucket))

    return result


def merge_intervals(intervals):
    if not intervals:
        return []

    intervals = sorted(intervals, key=lambda x: (x[0], x[1]))
    merged = [intervals[0]]

    for start, end in intervals[1:]:
        if start <= merged[-1][1]:
            merged[-1][1] = max(merged[-1][1], end)
        else:
            merged.append([start, end])

    return merged


def topological_sort(n, graph):
    indegree = [0] * n

    for u in range(n):
        for v in graph[u]:
            indegree[v] += 1

    q = deque([node for node in range(n) if indegree[node] == 0])
    order = []

    while q:
        node = q.popleft()
        order.append(node)

        for neighbor in graph[node]:
            indegree[neighbor] -= 1
            if indegree[neighbor] == 0:
                q.append(neighbor)

    if len(order) != n:
        return []

    return order


if __name__ == "__main__":
    arr = [5, 2, 4, 1, 3]
    print("Merge sort:", merge_sort(arr))
    print("Quick sort:", quick_sort(arr))
    print("Counting sort:", counting_sort([4, 2, 2, 8, 3, 3, 1]))
    print("Radix sort:", radix_sort_non_negative([170, 45, 75, 90, 802, 24, 2, 66]))
    print("Merged intervals:", merge_intervals([[1, 3], [2, 6], [8, 10], [15, 18]]))

    graph = [[1, 2], [3], [3], []]
    print("Topological sort:", topological_sort(4, graph))
```

## 10. Code Explanation

### Selection Sort

`selectionSort` keeps index `i` as the boundary between sorted and unsorted parts.

* `minIndex` stores the smallest element found in the unsorted part.
* After scanning, `swap(a[i], a[minIndex])` places the correct element at position `i`.
* It does at most one swap per outer loop.
* It is easy to understand but slow for large input.

### Bubble Sort

`bubbleSort` repeatedly compares adjacent elements.

* Larger elements move to the right after every pass.
* `swapped` detects if the array is already sorted.
* If no swap happens in a full pass, the algorithm stops early.
* Good for teaching, rarely used in CP.

### Insertion Sort

`insertionSort` maintains a sorted prefix.

* `key` is the element currently being inserted.
* Larger elements shift right.
* `key` is placed in the correct empty position.
* Very good for small or nearly sorted arrays.

### Merge Sort

`mergeSort` recursively splits the array.

* Base case: one element is already sorted.
* `mid` avoids overflow using `left + (right - left) / 2`.
* `mergeParts` combines two sorted halves.
* The condition `a[i] <= a[j]` keeps equal left-side elements before equal right-side elements, making merge sort stable.

### Quick Sort

`quickSort` uses partitioning.

* `pivot` is chosen as the last element.
* `smallerBoundary` tracks the end of the section containing elements `<= pivot`.
* After partitioning, pivot is placed at its final sorted index.
* Worst case occurs when pivot choices are consistently bad, such as already sorted input with last-element pivot.

In production or CP, prefer built-in `sort()` unless asked to implement quick sort.

### Counting Sort

`countingSortNonNegative` works when all values are non-negative and range is not too large.

* `count[x]` stores how many times value `x` appears.
* Then each value is output according to its frequency.
* `countingSortWithNegatives` shifts values by `minValue`, so negative values become valid indexes.

Important:

* If values are up to `1e9`, direct counting sort is impossible.
* Use coordinate compression if the number of distinct values is small.

### Radix Sort

`radixSortNonNegative` sorts integer digits one place at a time.

* `place = 1` sorts units digit.
* `place = 10` sorts tens digit.
* Stable counting sort is required at each digit.
* Processing output from right to left preserves stability.

### Bucket Sort

`bucketSortForZeroToOne` assumes values are uniformly distributed in `[0, 1)`.

* Each number goes into a bucket based on `x * n`.
* Individual buckets are sorted.
* Buckets are concatenated in order.

It is fast on uniform data but can degrade if all values fall into one bucket.

### Custom Comparator

The interval merge function uses:

```cpp
sort(intervals.begin(), intervals.end(), [](const vector<int>& a, const vector<int>& b) {
    if (a[0] != b[0]) return a[0] < b[0];
    return a[1] < b[1];
});
```

This means:

* Smaller start comes first.
* If starts are equal, smaller end comes first.
* The comparator uses `<`, not `<=`.

### Sorting Intervals

`mergeIntervals` sorts intervals by start.

* If current interval starts before or at the previous merged end, they overlap.
* Update the previous merged end using `max`.
* Otherwise, start a new interval.

### Sort + Greedy

`maxNonOverlappingActivities` sorts activities by ending time.

Why:

* Choosing the activity that ends earliest leaves maximum room for future activities.
* This is the classic activity selection proof idea.

### Topological Sort

`topologicalSortKahn` uses indegree.

* Nodes with indegree `0` have no remaining prerequisites.
* Removing a node decreases indegree of its neighbors.
* If all nodes are processed, graph is a DAG.
* If not, a cycle exists and no topological order is possible.

## 11. Complexity Analysis

| Algorithm / Technique | Best Time | Average Time | Worst Time | Space | Stable? | Notes |
|---|---:|---:|---:|---:|---|---|
| Selection sort | `O(n^2)` | `O(n^2)` | `O(n^2)` | `O(1)` | Usually no | Few swaps |
| Bubble sort | `O(n)` optimized | `O(n^2)` | `O(n^2)` | `O(1)` | Yes | Early stop helps |
| Insertion sort | `O(n)` | `O(n^2)` | `O(n^2)` | `O(1)` | Yes | Good for nearly sorted data |
| Merge sort | `O(n log n)` | `O(n log n)` | `O(n log n)` | `O(n)` | Yes | Reliable worst case |
| Quick sort | `O(n log n)` | `O(n log n)` | `O(n^2)` | `O(log n)` avg | Usually no | Pivot matters |
| Counting sort | `O(n + k)` | `O(n + k)` | `O(n + k)` | `O(k)` | Can be | `k` is range size |
| Radix sort | `O(d(n + b))` | `O(d(n + b))` | `O(d(n + b))` | `O(n + b)` | Yes if digit sort stable | `d` digits, base `b` |
| Bucket sort | `O(n)` | `O(n)` expected | `O(n^2)` | `O(n)` | Depends | Needs uniform distribution |
| Topological sort | `O(V + E)` | `O(V + E)` | `O(V + E)` | `O(V + E)` | Not applicable | Only for DAG |
| Sort intervals | `O(n log n)` | `O(n log n)` | `O(n log n)` | `O(1)` or `O(n)` | Depends | Sorting dominates |
| Sort + greedy | `O(n log n)` | `O(n log n)` | `O(n log n)` | Depends | Depends | Greedy after sorting |
| External sort | Depends on I/O | Depends on I/O | Depends on I/O | Limited RAM + disk | Usually yes | Used for huge files |
| TimSort idea | `O(n)` | `O(n log n)` | `O(n log n)` | `O(n)` | Yes | Excellent for real-world partially sorted data |

Preprocessing/query/update view:

| Use case | Preprocessing | Query | Update |
|---|---:|---:|---:|
| Sort once, answer many binary searches | `O(n log n)` | `O(log n)` | Costly |
| Counting frequency by value range | `O(n + k)` | `O(1)` for frequency | `O(1)` if count array maintained |
| Topological ordering | `O(V + E)` | Order lookup `O(1)` if indexed | Recompute usually |
| External sorting | Chunk sort + multiway merge | Sequential scan | Expensive |

## 12. Common Patterns

| Pattern | How to identify it | General approach | Example problems |
|---|---|---|---|
| Two pointers after sorting | Pair/triplet sum, closest sum | Sort, move left/right based on sum | Two Sum II, 3Sum, Boats to Save People |
| Merge intervals | Overlapping ranges | Sort by start, merge with last interval | Merge Intervals, Insert Interval |
| Activity selection | Maximum non-overlapping intervals | Sort by end time, greedily pick | Activity Selection, Non-overlapping Intervals |
| Meeting rooms/platforms | Minimum resources for intervals | Sort starts and ends separately or sweep events | Meeting Rooms II, Minimum Platforms |
| Custom ordering | "Arrange", "largest number", tie-breaking | Write strict comparator | Largest Number, Reorder Logs |
| Frequency sorting | Sort by count then value | Count using map, sort keys/items | Sort Characters by Frequency |
| Counting by range | Values bounded by small `k` | Count frequencies | Sort Colors, Counting Sort |
| Inversion count | Count pairs `i < j` and `a[i] > a[j]` | Merge sort modification | Count Inversions, Reverse Pairs |
| Dependency ordering | Prerequisites, build order | Topological sort | Course Schedule II, Alien Dictionary |
| Greedy with sorted order | Minimize/maximize after ordering | Sort by useful key, choose greedily | Assign Cookies, Minimum Arrows |
| Kth after ordering | kth smallest/largest | Sort, heap, or quickselect | Kth Largest Element |
| Anagram grouping | Same letters after sorting | Sort each string as key | Group Anagrams |
| Huge data sorting | File too large for RAM | External sort chunks and merge | Sort massive logs/file |

## 13. Common Mistakes

* Using `<=` inside a C++ comparator.
* Forgetting that `std::sort` is unstable.
* Sorting intervals by end time when the task requires merging by start time.
* Sorting intervals by start time when the task requires maximum non-overlap by end time.
* Off-by-one errors in merge sort boundaries.
* Infinite recursion in quick sort due to wrong partition indexes.
* Worst-case quick sort on sorted input with bad pivot choice.
* Counting sort with huge range like `1e9`.
* Forgetting to handle negative values in counting sort.
* Radix sort without stable digit sort.
* Bucket sort used when data is not uniformly distributed.
* Topological sort without cycle detection.
* Assuming topological order is unique.
* Integer overflow in comparator expressions like `return a - b < 0`.
* Mutating values in comparator.
* Comparator not being transitive.
* Forgetting that Python sort is stable but C++ `sort` is not.
* Using sort when a heap would be better for streaming top-k.
* Losing original indexes after sorting when the answer requires positions.

## 14. Edge Cases

Test these:

* Empty input: `[]`
* Single element: `[5]`
* Already sorted array: `[1, 2, 3, 4]`
* Reverse sorted array: `[4, 3, 2, 1]`
* All equal elements: `[7, 7, 7]`
* Duplicates: `[2, 1, 2, 1]`
* Negative values: `[-3, 0, -1, 2]`
* Large values: `[1e9, -1e9]`
* Counting sort with large range but few elements
* Radix sort with zero
* Bucket sort with values equal or very close
* Intervals touching at boundary: `[1, 3]` and `[3, 5]`
* Intervals fully nested: `[1, 10]`, `[2, 3]`
* Disconnected graph in topological sort
* Graph with cycle
* Multiple valid topological orders
* Custom comparator ties
* Need original indexes after sorting

## 15. Variations

### Selection Sort Variation

Find both minimum and maximum in each pass and place them at both ends.

Usefulness:

* Mostly academic.
* Not important for CP except concept clarity.

### Bubble Sort with Early Stop

Stop if no swaps happen in a pass.

Usefulness:

* Important to know best case can become `O(n)`.
* Rarely used in actual solutions.

### Binary Insertion Sort

Use binary search to find insertion position, then shift elements.

Usefulness:

* Reduces comparisons.
* Still `O(n^2)` due to shifting.

### Merge Sort for Inversion Count

While merging, count how many right-side elements jump before left-side elements.

Usefulness:

* Very important for placements and CP.

### Randomized Quick Sort

Choose a random pivot to reduce chance of worst case.

Usefulness:

* Important if implementing quick sort manually.

### Three-way Quick Sort

Partition into:

* Less than pivot
* Equal to pivot
* Greater than pivot

Usefulness:

* Good when many duplicates exist.

### Stable Counting Sort

Use prefix sums and fill output from right to left.

Usefulness:

* Required for radix sort.

### Coordinate Compression + Sorting

Map large values to smaller ranks.

Usefulness:

* Very common in CP for Fenwick tree, segment tree, frequency, and offline queries.

### Lexicographical Sorting

Sort strings or vectors dictionary-style.

Usefulness:

* Common in string and ordering problems.

### Topological Sort using DFS

Do DFS and push nodes after processing children, then reverse.

Usefulness:

* Common alternative to Kahn's algorithm.
* Cycle detection needs recursion state.

### Lexicographically Smallest Topological Sort

Use a min-heap instead of a queue for zero-indegree nodes.

Usefulness:

* Important when problem asks smallest valid order.

### External Merge Sort

Sort disk chunks and k-way merge with heap.

Usefulness:

* Important for system design and large-scale data interviews.

### TimSort

Detect existing sorted runs, insertion-sort small runs, merge runs.

Usefulness:

* Important conceptually.
* Rarely implemented fully in CP.

## 16. Related Algorithms/Data Structures

| Topic | Connection | How to choose |
|---|---|---|
| Heap | Maintains min/max without full sorting | Use for top-k, streaming, repeated extract-min |
| Binary Search | Needs sorted data | Sort first if queries justify preprocessing |
| Two Pointers | Often used after sorting | Use for pair/triplet/range problems |
| Hash Map | Alternative to sorting for frequency | Use when order is not needed |
| Balanced BST / Multiset | Maintains dynamic sorted order | Use when values change frequently |
| Fenwick Tree | Often combined with coordinate compression | Use for inversion count/order statistics |
| Segment Tree | Range queries after compression | Use for complex updates/queries |
| Priority Queue | K-way merge/external sort | Use when merging sorted streams |
| DFS | Alternative for topological sort | Use when recursive graph traversal is natural |
| BFS | Kahn's topological sort uses BFS-like queue | Use for dependency levels/order |
| Greedy | Sorting often enables greedy proof | Use when local sorted choice is globally optimal |
| Divide and Conquer | Merge/quick sort family | Use for recursive structure problems |

Examples:

* Heap vs Sorting: if you only need top `k`, heap may be `O(n log k)` instead of `O(n log n)`.
* Hash Map vs Sorting: for checking duplicates, hash set is `O(n)` average; sorting is `O(n log n)` but uses less extra memory sometimes.
* Merge Sort vs Quick Sort: merge sort gives stable `O(n log n)` worst case; quick sort is usually faster in-place but has `O(n^2)` worst case.
* Kahn vs DFS Topological Sort: Kahn is easier for cycle detection and lexicographically smallest order with heap.

## 17. Practice Problems

### Easy

| Problem | Platform | Main idea/pattern | Difficulty |
|---|---|---|---|
| Sort Colors | LeetCode | Counting sort / Dutch national flag | Easy-Medium |
| Merge Sorted Array | LeetCode | Two pointers from end | Easy |

### Medium

| Problem | Platform | Main idea/pattern | Difficulty |
|---|---|---|---|
| Merge Intervals | LeetCode | Sort intervals by start | Medium |
| 3Sum | LeetCode | Sort + two pointers | Medium |
| Course Schedule II | LeetCode | Topological sorting | Medium |

### Hard

| Problem | Platform | Main idea/pattern | Difficulty |
|---|---|---|---|
| Count Inversions | GFG / SPOJ | Merge sort modification | Hard |
| Reverse Pairs | LeetCode | Merge sort counting | Hard |
| Alien Dictionary | LeetCode / GFG | Graph construction + topological sort | Hard |

More useful practice:

| Problem | Platform | Main idea |
|---|---|---|
| Activity Selection | GFG | Sort by ending time |
| Minimum Platforms | GFG | Sort arrivals/departures |
| Restaurant Customers | CSES | Sweep line after sorting events |
| Apartments | CSES | Sort + two pointers |
| Towers | CSES | Multiset / sorted placement |
| Collecting Numbers | CSES | Order positions |
| Largest Number | LeetCode | Custom comparator |
| K Closest Points to Origin | LeetCode | Sorting/heap |

## 18. Interview Explanation

Sorting arranges data in a meaningful order, usually ascending or descending, so that patterns become easier to use. For general data, comparison sorts like merge sort and quick sort are common and usually take `O(n log n)`. Merge sort is stable and has guaranteed `O(n log n)` time but needs extra memory. Quick sort is usually fast and in-place but can degrade to `O(n^2)` with bad pivots. If the value range is small, counting sort can sort in `O(n + k)` without comparisons. In problem solving, I often sort first to enable two pointers, greedy selection, interval merging, binary search, or custom ordering.

## 19. Revision Notes

* Sorting reveals order, adjacency, duplicates, and boundaries.
* General comparison sorting usually costs `O(n log n)`.
* `std::sort` is fast but unstable.
* Use `stable_sort` when equal elements must keep original order.
* Comparator must use strict ordering: return `a < b` style, not `a <= b`.
* Merge intervals: sort by start.
* Activity selection: sort by end.
* Topological sort is for dependency ordering in DAGs.
* Counting sort: use when value range `k` is small.
* Radix sort needs stable counting sort per digit.
* Quick sort worst case is `O(n^2)` with bad pivots.
* Merge sort is reliable for inversion count.
* For top-k, heap may be better than full sort.
* For dynamic sorted data, use multiset/BST.
* For huge files, use external merge sort.
* TimSort exploits already sorted runs in real-world data.

## 20. Final Cheat Sheet

| Topic | When to use | Main operation/key idea | Complexity | Edge cases |
|---|---|---|---|---|
| Selection sort | Learning, tiny arrays | Pick minimum each pass | `O(n^2)` | Duplicates, already sorted |
| Bubble sort | Learning, nearly sorted check | Swap adjacent wrong pairs | `O(n)` best, `O(n^2)` worst | Early stop |
| Insertion sort | Small/nearly sorted arrays | Insert into sorted prefix | `O(n)` best, `O(n^2)` worst | Shifting indexes |
| Merge sort | Guaranteed sort, inversion count | Split and merge | `O(n log n)` time, `O(n)` space | Merge boundaries |
| Quick sort | Fast in-place average sort | Partition by pivot | `O(n log n)` avg, `O(n^2)` worst | Bad pivot, duplicates |
| Counting sort | Small integer range | Count frequencies | `O(n + k)` | Negative values, huge range |
| Radix sort | Fixed-width non-negative integers | Stable sort by digits | `O(d(n + b))` | Needs stable digit sort |
| Bucket sort | Uniform numeric distribution | Put into buckets | `O(n)` expected | Skewed distribution |
| Custom comparator | Special order/tie-breaks | Define strict ordering | `O(n log n)` | Never use `<=` |
| Sorting intervals | Ranges/time periods | Sort by start or end | `O(n log n)` | Touching/nested intervals |
| Stable sort | Equal order matters | Preserve equal relative order | Depends | Multi-key sorting |
| Topological sort | Dependencies/prerequisites | Process indegree zero nodes | `O(V + E)` | Cycles, disconnected graph |
| Sort + greedy | Scheduling/assignment | Sort by greedy key | Usually `O(n log n)` | Wrong sort key |
| External sorting | Data bigger than RAM | Sort chunks, k-way merge | I/O dominated | Memory limit, disk passes |
| TimSort idea | Real-world partially sorted data | Detect runs and merge | `O(n)` best, `O(n log n)` worst | Run detection |

Key code reminders:

```cpp
sort(v.begin(), v.end());

sort(v.begin(), v.end(), [](const auto& a, const auto& b) {
    if (a.first != b.first) return a.first < b.first;
    return a.second > b.second;
});

stable_sort(v.begin(), v.end(), comparator);
```

Final placement rule:

* If order helps, sort first.
* If only min/max repeatedly matters, use heap.
* If exact lookup/frequency matters, use hash map.
* If dependency order matters, use topological sort.
* If range is small, consider counting/radix.
* If intervals appear, decide whether to sort by start or end.
