# Binary Search

## 1. Overview

Binary search is a searching and optimization technique that repeatedly cuts the search space in half.

In its most basic form, it finds whether a value exists in a sorted array. In competitive programming and placements, binary search is much more powerful: it can find boundaries, first/last occurrences, answers to optimization problems, floating-point values, rotated-array positions, and even support advanced offline techniques like parallel binary search.

The core requirement is not always "array must be sorted". The real requirement is:

> The search space must have a monotonic structure.

Monotonic means once a condition becomes true, it stays true, or once it becomes false, it stays false.

Examples:

* In sorted array search: values before target are smaller, values after target are larger.
* In lower bound: `a[i] >= x` is false, false, false, then true, true.
* In binary search on answer: "Can we do the task with answer `mid`?" becomes true after some point or false after some point.
* In maximum possible minimum problems: "Can we keep minimum distance at least `mid`?" usually becomes harder as `mid` increases.

Binary search is a must-know topic for coding interviews, online assessments, and competitive programming because it converts many `O(n)` or `O(answer_range * n)` solutions into `O(log n)` or `O(n log answer_range)`.

## 2. Intuition

Imagine searching for a word in a dictionary. You do not start from page 1 and scan every page. You open the middle:

* If the word should come before the middle page, discard the right half.
* If it should come after, discard the left half.
* Repeat until the word is found or the search space is empty.

That is binary search.

The important idea is that every check gives enough information to throw away half of the remaining possibilities.

Step-by-step reasoning:

1. Maintain a range of possible answers.
2. Pick the middle candidate.
3. Ask a yes/no or comparison question.
4. Based on the answer, remove half of the range.
5. Continue until the range collapses to the answer.

Why it works:

* The range is ordered or monotonic.
* The middle check tells us which side cannot contain the answer.
* Every step reduces the number of candidates roughly by half.
* Halving repeatedly takes only `O(log n)` steps.

For `n = 1,000,000`, binary search needs about 20 checks. That is why it is so important in time-limited coding rounds.

## 3. When to Use It

Use binary search when:

* The array or search space is sorted.
* You need to find an element, boundary, first occurrence, or last occurrence.
* A problem asks for the minimum possible value satisfying a condition.
* A problem asks for the maximum possible value satisfying a condition.
* You can write a `check(mid)` function that returns true/false.
* The condition is monotonic.
* The answer range is large, such as `1` to `1e18`.
* Direct simulation for every answer is too slow.
* You need precision-based search on real numbers.
* You are optimizing capacity, time, distance, speed, pages, maximum load, minimum distance, or threshold.

Common trigger phrases:

* "minimum possible maximum"
* "maximize the minimum"
* "smallest value such that"
* "largest value such that"
* "at least K"
* "not less than"
* "first position where"
* "last position where"
* "sorted array"
* "rotated sorted array"
* "answer within 1e-6"
* "can we do this in X time?"
* "minimum capacity"
* "maximum minimum distance"
* "allocate books"
* "aggressive cows"
* "ship packages within D days"

## 4. When Not to Use It

Do not use binary search when:

* The data is unsorted and has no monotonic property.
* The condition `check(mid)` is not monotonic.
* A simple hash map gives `O(1)` lookup and order is irrelevant.
* The input size is tiny and direct scanning is simpler.
* The problem needs all valid answers, not just one boundary.
* The array changes frequently and sorting every time is expensive.
* The search space is graph-like without an ordered answer.
* Floating-point precision requirements cannot be handled safely.

Common wrong assumptions:

* "I can binary search any array." Wrong. You need sorted order or monotonic behavior.
* "If the answer is numeric, binary search works." Wrong. `check(mid)` must divide the answer space into one false block and one true block, or the reverse.
* "Duplicates do not matter." Wrong. Duplicates are exactly where lower bound, upper bound, first occurrence, and last occurrence matter.
* "Mid calculation cannot overflow." Wrong in C++ if `low + high` exceeds integer range. Use `low + (high - low) / 2`.

Simpler alternatives:

* Use linear search for one query on a small array.
* Use `unordered_map` for exact lookup without ordering.
* Use two pointers when the array is sorted and both ends move monotonically.
* Use prefix sums when checking repeated range sums.
* Use heap or balanced BST when you need dynamic min/max operations.

## 5. Core Concepts

### Sorted Search Space

Binary search needs an ordered space where comparison makes sense.

Example:

```text
a = [2, 5, 8, 12, 16, 23]
target = 12
```

If `a[mid] < target`, all elements before `mid` are also too small.

Why it matters:

This allows discarding half the array safely.

### Monotonic Predicate

A predicate is a function that returns true or false.

Example:

```text
check(x) = can ship all packages within D days using capacity x
```

If capacity `x` works, then any capacity larger than `x` also works.

Pattern:

```text
false false false true true true
```

or:

```text
true true true false false false
```

Why it matters:

Binary search on answer depends completely on monotonicity.

### Closed Interval vs Half-Open Interval

Closed interval:

```text
low <= high
search space is [low, high]
```

Half-open interval:

```text
low < high
search space is [low, high)
```

Both are valid. In interviews, use one style consistently.

This guide mainly uses:

* `while (low <= high)` for exact search.
* `while (low < high)` for boundary and answer search.

### Lower Bound

Lower bound is the first index `i` such that:

```text
a[i] >= target
```

Example:

```text
a = [1, 2, 4, 4, 4, 7]
target = 4
lower_bound = 2
```

Why it matters:

It finds insertion position and first valid boundary.

### Upper Bound

Upper bound is the first index `i` such that:

```text
a[i] > target
```

Example:

```text
a = [1, 2, 4, 4, 4, 7]
target = 4
upper_bound = 5
```

Why it matters:

The count of `target` is:

```text
upper_bound(target) - lower_bound(target)
```

### First and Last Occurrence

For duplicates:

```text
a = [1, 2, 4, 4, 4, 7]
target = 4
first = 2
last = 4
```

First occurrence is lower bound if `a[index] == target`.

Last occurrence is `upper_bound(target) - 1` if target exists.

### Binary Search on Answer

Instead of searching an array, search possible answers.

Example:

Find minimum ship capacity to ship packages in `D` days.

* Candidate answer: capacity `mid`.
* Check: can we ship using this capacity?
* If yes, try smaller capacity.
* If no, need bigger capacity.

### Minimum Possible Maximum

You minimize the largest value among groups, partitions, days, loads, or pages.

Example:

Allocate books to students such that maximum pages assigned to any student is minimized.

Check:

Can we divide books into at most `students` groups where each group sum is at most `mid`?

### Maximum Possible Minimum

You maximize the smallest distance, value, or gap.

Example:

Aggressive cows: place cows in stalls so the minimum distance between any two cows is as large as possible.

Check:

Can we place at least `k` cows with distance at least `mid`?

### Floating-Point Binary Search

Used when the answer is real-valued.

Example:

Find square root of `x`, or minimum speed with decimal precision.

Instead of `low <= high`, run fixed iterations:

```text
for 80 iterations:
    mid = (low + high) / 2
```

Why 80?

It is enough for `double` precision in most CP problems.

### Ternary Search

Ternary search is used for unimodal functions, not monotonic functions.

Unimodal means:

* First increasing then decreasing, or
* First decreasing then increasing.

Example:

Find maximum value of a concave function.

It splits the range into three parts instead of two.

### Binary Lifting

Binary lifting precomputes jumps of size `2^j`.

Common use:

* Find kth ancestor in a tree.
* Find LCA.
* Jump along functional graph.

It is related to binary search because it uses powers of two to skip large parts efficiently.

### Parallel Binary Search

Parallel binary search solves many offline binary searches together.

Use when:

* There are many queries.
* Each query is searching over time/index/answer.
* Updates can be applied incrementally.

Instead of running one full binary search per query independently, it groups queries by mid and processes them batch-wise.

### Parametric Search

Parametric search means converting an optimization problem into a decision problem.

Optimization:

```text
Find minimum X.
```

Decision:

```text
Is X possible?
```

Then binary search over `X`.

Advanced parametric search may involve greedy checks, DP checks, max flow checks, MST checks, or data structures.

## 6. Step-by-Step Algorithm

### Basic Binary Search

1. Set `low = 0`, `high = n - 1`.
2. While `low <= high`:
3. Compute `mid = low + (high - low) / 2`.
4. If `a[mid] == target`, return `mid`.
5. If `a[mid] < target`, search right half: `low = mid + 1`.
6. Otherwise search left half: `high = mid - 1`.
7. If loop ends, return `-1`.

### Lower Bound

1. Set `low = 0`, `high = n`.
2. While `low < high`:
3. Compute `mid`.
4. If `a[mid] >= target`, answer may be `mid`, so move `high = mid`.
5. Else move `low = mid + 1`.
6. Return `low`.

### Upper Bound

1. Set `low = 0`, `high = n`.
2. While `low < high`:
3. Compute `mid`.
4. If `a[mid] > target`, move `high = mid`.
5. Else move `low = mid + 1`.
6. Return `low`.

### First Occurrence

1. Find `idx = lowerBound(a, target)`.
2. If `idx < n` and `a[idx] == target`, return `idx`.
3. Otherwise return `-1`.

### Last Occurrence

1. Find `idx = upperBound(a, target) - 1`.
2. If `idx >= 0` and `a[idx] == target`, return `idx`.
3. Otherwise return `-1`.

### Search in Rotated Sorted Array

1. Set `low = 0`, `high = n - 1`.
2. While `low <= high`:
3. Compute `mid`.
4. If `a[mid] == target`, return `mid`.
5. If left half `a[low..mid]` is sorted:
   * If target lies inside it, move left.
   * Else move right.
6. Else right half `a[mid..high]` is sorted:
   * If target lies inside it, move right.
   * Else move left.
7. Return `-1`.

### Binary Search on Answer

1. Decide what the answer represents.
2. Find the minimum and maximum possible answer.
3. Write a monotonic `check(mid)`.
4. If searching minimum feasible answer:
   * If `check(mid)` is true, move left.
   * Else move right.
5. If searching maximum feasible answer:
   * If `check(mid)` is true, move right.
   * Else move left.
6. Return final boundary.

## 7. Dry Run

### Dry Run 1: Lower Bound

Array:

```text
a = [1, 3, 5, 5, 5, 8, 10]
target = 5
```

Goal: find first index where `a[i] >= 5`.

Initial state:

```text
low = 0, high = 7
```

| Step | low | high | mid | a[mid] | Decision |
|---:|---:|---:|---:|---:|---|
| 1 | 0 | 7 | 3 | 5 | `a[mid] >= 5`, move `high = 3` |
| 2 | 0 | 3 | 1 | 3 | `a[mid] < 5`, move `low = 2` |
| 3 | 2 | 3 | 2 | 5 | `a[mid] >= 5`, move `high = 2` |

Stop because `low == high == 2`.

Answer:

```text
lower_bound = 2
```

### Dry Run 2: Binary Search on Answer

Problem:

Given weights `[3, 2, 2, 4, 1, 4]`, find minimum ship capacity to ship within `3` days.

Search space:

```text
low = max(weights) = 4
high = sum(weights) = 16
```

Check function:

Can we ship all weights in at most `3` days if capacity is `mid`?

| Step | low | high | mid | Days Needed | Feasible? | Move |
|---:|---:|---:|---:|---:|---|---|
| 1 | 4 | 16 | 10 | 2 | Yes | `high = 10` |
| 2 | 4 | 10 | 7 | 3 | Yes | `high = 7` |
| 3 | 4 | 7 | 5 | 4 | No | `low = 6` |
| 4 | 6 | 7 | 6 | 3 | Yes | `high = 6` |

Stop:

```text
low = high = 6
```

Minimum possible capacity is:

```text
6
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

int binarySearch(const vector<int>& a, int target) {
    int low = 0, high = (int)a.size() - 1;

    while (low <= high) {
        int mid = low + (high - low) / 2;

        if (a[mid] == target) return mid;
        if (a[mid] < target) low = mid + 1;
        else high = mid - 1;
    }

    return -1;
}

int lowerBoundCustom(const vector<int>& a, int target) {
    int low = 0, high = (int)a.size();

    while (low < high) {
        int mid = low + (high - low) / 2;

        if (a[mid] >= target) high = mid;
        else low = mid + 1;
    }

    return low;
}

int upperBoundCustom(const vector<int>& a, int target) {
    int low = 0, high = (int)a.size();

    while (low < high) {
        int mid = low + (high - low) / 2;

        if (a[mid] > target) high = mid;
        else low = mid + 1;
    }

    return low;
}

int firstOccurrence(const vector<int>& a, int target) {
    int idx = lowerBoundCustom(a, target);
    if (idx < (int)a.size() && a[idx] == target) return idx;
    return -1;
}

int lastOccurrence(const vector<int>& a, int target) {
    int idx = upperBoundCustom(a, target) - 1;
    if (idx >= 0 && a[idx] == target) return idx;
    return -1;
}

int searchRotatedSortedArray(const vector<int>& a, int target) {
    int low = 0, high = (int)a.size() - 1;

    while (low <= high) {
        int mid = low + (high - low) / 2;

        if (a[mid] == target) return mid;

        if (a[low] <= a[mid]) {
            // Left half is sorted.
            if (a[low] <= target && target < a[mid]) {
                high = mid - 1;
            } else {
                low = mid + 1;
            }
        } else {
            // Right half is sorted.
            if (a[mid] < target && target <= a[high]) {
                low = mid + 1;
            } else {
                high = mid - 1;
            }
        }
    }

    return -1;
}

bool canShipWithinDays(const vector<int>& weights, int days, long long capacity) {
    int usedDays = 1;
    long long currentLoad = 0;

    for (int weight : weights) {
        if (weight > capacity) return false;

        if (currentLoad + weight <= capacity) {
            currentLoad += weight;
        } else {
            usedDays++;
            currentLoad = weight;
        }
    }

    return usedDays <= days;
}

long long minimumShipCapacity(const vector<int>& weights, int days) {
    long long low = *max_element(weights.begin(), weights.end());
    long long high = accumulate(weights.begin(), weights.end(), 0LL);

    while (low < high) {
        long long mid = low + (high - low) / 2;

        if (canShipWithinDays(weights, days, mid)) {
            high = mid;
        } else {
            low = mid + 1;
        }
    }

    return low;
}

bool canPlaceCows(const vector<int>& stalls, int cows, int minDistance) {
    int placed = 1;
    int lastPosition = stalls[0];

    for (int i = 1; i < (int)stalls.size(); i++) {
        if (stalls[i] - lastPosition >= minDistance) {
            placed++;
            lastPosition = stalls[i];
        }
    }

    return placed >= cows;
}

int maximumMinimumDistance(vector<int> stalls, int cows) {
    sort(stalls.begin(), stalls.end());

    int low = 0;
    int high = stalls.back() - stalls.front();
    int answer = 0;

    while (low <= high) {
        int mid = low + (high - low) / 2;

        if (canPlaceCows(stalls, cows, mid)) {
            answer = mid;
            low = mid + 1;
        } else {
            high = mid - 1;
        }
    }

    return answer;
}

double squareRootBinarySearch(double x) {
    double low = 0.0;
    double high = max(1.0, x);

    for (int iter = 0; iter < 80; iter++) {
        double mid = (low + high) / 2.0;

        if (mid * mid <= x) low = mid;
        else high = mid;
    }

    return low;
}

double ternarySearchMax(double low, double high) {
    auto f = [](double x) {
        return -(x - 3.0) * (x - 3.0) + 10.0;
    };

    for (int iter = 0; iter < 100; iter++) {
        double mid1 = low + (high - low) / 3.0;
        double mid2 = high - (high - low) / 3.0;

        if (f(mid1) < f(mid2)) {
            low = mid1;
        } else {
            high = mid2;
        }
    }

    return (low + high) / 2.0;
}

struct BinaryLifting {
    int n;
    int logN;
    vector<vector<int>> up;

    BinaryLifting(const vector<int>& parent) {
        n = (int)parent.size();
        logN = 1;
        while ((1 << logN) <= n) logN++;

        up.assign(logN, vector<int>(n, -1));
        up[0] = parent;

        for (int j = 1; j < logN; j++) {
            for (int node = 0; node < n; node++) {
                int halfAncestor = up[j - 1][node];
                if (halfAncestor != -1) {
                    up[j][node] = up[j - 1][halfAncestor];
                }
            }
        }
    }

    int kthAncestor(int node, int k) const {
        for (int bit = 0; bit < logN; bit++) {
            if (k & (1 << bit)) {
                node = up[bit][node];
                if (node == -1) return -1;
            }
        }
        return node;
    }
};

int main() {
    vector<int> a = {1, 3, 5, 5, 5, 8, 10};

    cout << "Binary search index of 8: " << binarySearch(a, 8) << "\n";
    cout << "Lower bound of 5: " << lowerBoundCustom(a, 5) << "\n";
    cout << "Upper bound of 5: " << upperBoundCustom(a, 5) << "\n";
    cout << "First occurrence of 5: " << firstOccurrence(a, 5) << "\n";
    cout << "Last occurrence of 5: " << lastOccurrence(a, 5) << "\n";

    vector<int> rotated = {4, 5, 6, 7, 0, 1, 2};
    cout << "Index of 0 in rotated array: "
         << searchRotatedSortedArray(rotated, 0) << "\n";

    vector<int> weights = {3, 2, 2, 4, 1, 4};
    cout << "Minimum ship capacity: "
         << minimumShipCapacity(weights, 3) << "\n";

    vector<int> stalls = {1, 2, 4, 8, 9};
    cout << "Maximum minimum distance: "
         << maximumMinimumDistance(stalls, 3) << "\n";

    cout << fixed << setprecision(6);
    cout << "sqrt(10): " << squareRootBinarySearch(10.0) << "\n";
    cout << "Ternary search maximum near x: "
         << ternarySearchMax(-10.0, 10.0) << "\n";

    vector<int> parent = {-1, 0, 0, 1, 1, 2};
    BinaryLifting lifting(parent);
    cout << "2nd ancestor of node 4: "
         << lifting.kthAncestor(4, 2) << "\n";

    return 0;
}
```

Example output:

```text
Binary search index of 8: 5
Lower bound of 5: 2
Upper bound of 5: 5
First occurrence of 5: 2
Last occurrence of 5: 4
Index of 0 in rotated array: 4
Minimum ship capacity: 6
Maximum minimum distance: 3
sqrt(10): 3.162278
Ternary search maximum near x: 3.000000
2nd ancestor of node 4: 0
```

## pYTHON IMPLEMENTATION

```python
from typing import List


def binary_search(a: List[int], target: int) -> int:
    low, high = 0, len(a) - 1

    while low <= high:
        mid = low + (high - low) // 2

        if a[mid] == target:
            return mid
        if a[mid] < target:
            low = mid + 1
        else:
            high = mid - 1

    return -1


def lower_bound(a: List[int], target: int) -> int:
    low, high = 0, len(a)

    while low < high:
        mid = low + (high - low) // 2

        if a[mid] >= target:
            high = mid
        else:
            low = mid + 1

    return low


def upper_bound(a: List[int], target: int) -> int:
    low, high = 0, len(a)

    while low < high:
        mid = low + (high - low) // 2

        if a[mid] > target:
            high = mid
        else:
            low = mid + 1

    return low


def first_occurrence(a: List[int], target: int) -> int:
    idx = lower_bound(a, target)
    return idx if idx < len(a) and a[idx] == target else -1


def last_occurrence(a: List[int], target: int) -> int:
    idx = upper_bound(a, target) - 1
    return idx if idx >= 0 and a[idx] == target else -1


def search_rotated_sorted_array(a: List[int], target: int) -> int:
    low, high = 0, len(a) - 1

    while low <= high:
        mid = low + (high - low) // 2

        if a[mid] == target:
            return mid

        if a[low] <= a[mid]:
            if a[low] <= target < a[mid]:
                high = mid - 1
            else:
                low = mid + 1
        else:
            if a[mid] < target <= a[high]:
                low = mid + 1
            else:
                high = mid - 1

    return -1


def can_ship_within_days(weights: List[int], days: int, capacity: int) -> bool:
    used_days = 1
    current_load = 0

    for weight in weights:
        if weight > capacity:
            return False

        if current_load + weight <= capacity:
            current_load += weight
        else:
            used_days += 1
            current_load = weight

    return used_days <= days


def minimum_ship_capacity(weights: List[int], days: int) -> int:
    low, high = max(weights), sum(weights)

    while low < high:
        mid = low + (high - low) // 2

        if can_ship_within_days(weights, days, mid):
            high = mid
        else:
            low = mid + 1

    return low


def can_place_cows(stalls: List[int], cows: int, min_distance: int) -> bool:
    placed = 1
    last_position = stalls[0]

    for position in stalls[1:]:
        if position - last_position >= min_distance:
            placed += 1
            last_position = position

    return placed >= cows


def maximum_minimum_distance(stalls: List[int], cows: int) -> int:
    stalls.sort()
    low, high = 0, stalls[-1] - stalls[0]
    answer = 0

    while low <= high:
        mid = low + (high - low) // 2

        if can_place_cows(stalls, cows, mid):
            answer = mid
            low = mid + 1
        else:
            high = mid - 1

    return answer


def sqrt_binary_search(x: float) -> float:
    low, high = 0.0, max(1.0, x)

    for _ in range(80):
        mid = (low + high) / 2.0

        if mid * mid <= x:
            low = mid
        else:
            high = mid

    return low


def ternary_search_max(low: float, high: float) -> float:
    def f(x: float) -> float:
        return -((x - 3.0) ** 2) + 10.0

    for _ in range(100):
        mid1 = low + (high - low) / 3.0
        mid2 = high - (high - low) / 3.0

        if f(mid1) < f(mid2):
            low = mid1
        else:
            high = mid2

    return (low + high) / 2.0


class BinaryLifting:
    def __init__(self, parent: List[int]):
        self.n = len(parent)
        self.log_n = 1
        while (1 << self.log_n) <= self.n:
            self.log_n += 1

        self.up = [[-1] * self.n for _ in range(self.log_n)]
        self.up[0] = parent[:]

        for j in range(1, self.log_n):
            for node in range(self.n):
                half_ancestor = self.up[j - 1][node]
                if half_ancestor != -1:
                    self.up[j][node] = self.up[j - 1][half_ancestor]

    def kth_ancestor(self, node: int, k: int) -> int:
        bit = 0
        while k > 0 and node != -1:
            if k & 1:
                node = self.up[bit][node]
            k >>= 1
            bit += 1
        return node


if __name__ == "__main__":
    a = [1, 3, 5, 5, 5, 8, 10]
    print(binary_search(a, 8))
    print(lower_bound(a, 5))
    print(upper_bound(a, 5))
    print(first_occurrence(a, 5))
    print(last_occurrence(a, 5))

    rotated = [4, 5, 6, 7, 0, 1, 2]
    print(search_rotated_sorted_array(rotated, 0))

    weights = [3, 2, 2, 4, 1, 4]
    print(minimum_ship_capacity(weights, 3))

    stalls = [1, 2, 4, 8, 9]
    print(maximum_minimum_distance(stalls, 3))

    print(round(sqrt_binary_search(10.0), 6))
    print(round(ternary_search_max(-10.0, 10.0), 6))

    lifting = BinaryLifting([-1, 0, 0, 1, 1, 2])
    print(lifting.kth_ancestor(4, 2))
```

## 10. Code Explanation

### Basic Binary Search

```cpp
int low = 0, high = n - 1;
```

The search space contains valid array indices.

```cpp
int mid = low + (high - low) / 2;
```

This avoids overflow compared to `(low + high) / 2`.

```cpp
if (a[mid] == target) return mid;
```

If the middle value is the target, we are done.

```cpp
if (a[mid] < target) low = mid + 1;
else high = mid - 1;
```

Because the array is sorted, if `a[mid]` is too small, all values before it are also too small. If it is too large, all values after it are too large.

### Lower Bound

`high` starts at `n`, not `n - 1`, because the answer can be `n` when all elements are smaller than the target.

```cpp
if (a[mid] >= target) high = mid;
```

`mid` may be the answer, so we keep it in the search range.

```cpp
else low = mid + 1;
```

`mid` is too small, so it cannot be the answer.

### Upper Bound

Upper bound is almost identical to lower bound, but the condition changes from:

```text
a[mid] >= target
```

to:

```text
a[mid] > target
```

This finds the first strictly greater value.

### First and Last Occurrence

First occurrence uses lower bound. If the returned index is inside the array and equals target, it is the first occurrence.

Last occurrence uses `upper_bound - 1`. Upper bound points to the first value greater than target, so the previous index is the last equal value.

### Rotated Sorted Array

At every step, at least one half of the array is sorted.

```cpp
if (a[low] <= a[mid])
```

This means left half is sorted.

Then check whether target lies between `a[low]` and `a[mid]`. If yes, discard the right half. Otherwise discard the left half.

If left half is not sorted, the right half must be sorted. Apply the same idea on the right side.

Note:

This version assumes distinct elements. With many duplicates, the condition becomes ambiguous and may degrade to `O(n)` because sometimes you must shrink both ends.

### Minimum Ship Capacity

The answer cannot be smaller than the maximum single package.

```cpp
low = max(weights)
```

The answer never needs to be larger than the sum of all packages.

```cpp
high = sum(weights)
```

The check greedily fills one day until adding the next weight would exceed capacity. Then it starts a new day.

If a capacity works, all larger capacities also work, so we search left for the minimum feasible capacity.

### Maximum Minimum Distance

The stalls are sorted first.

For a candidate distance `mid`, greedily place the first cow in the first stall, then place each next cow at the earliest possible stall that is at least `mid` away.

If we can place all cows, try a larger distance. If not, try a smaller distance.

### Floating-Point Binary Search

Floating-point binary search runs a fixed number of iterations instead of relying on exact equality.

`80` iterations is usually enough for `double` precision.

### Ternary Search

Ternary search compares two middle points:

```text
mid1 = low + (high - low) / 3
mid2 = high - (high - low) / 3
```

For maximum of a unimodal function:

* If `f(mid1) < f(mid2)`, the maximum is to the right.
* Else it is to the left.

### Binary Lifting

`up[j][node]` stores the `2^j`-th ancestor of `node`.

To find the kth ancestor, decompose `k` into binary powers and jump accordingly.

Example:

```text
k = 13 = 8 + 4 + 1
```

So jump by `2^3`, then `2^2`, then `2^0`.

## 11. Complexity Analysis

| Technique | Preprocessing | Query/Check Time | Total Time | Space |
|---|---:|---:|---:|---:|
| Basic binary search | `O(1)` | `O(log n)` | `O(log n)` | `O(1)` |
| Lower bound | `O(1)` | `O(log n)` | `O(log n)` | `O(1)` |
| Upper bound | `O(1)` | `O(log n)` | `O(log n)` | `O(1)` |
| First/last occurrence | `O(1)` | `O(log n)` | `O(log n)` | `O(1)` |
| Rotated sorted array search | `O(1)` | `O(log n)` | `O(log n)` | `O(1)` |
| Rotated search with many duplicates | `O(1)` | up to `O(n)` | up to `O(n)` | `O(1)` |
| Binary search on answer | depends on check | `O(check)` | `O(check * log range)` | depends on check |
| Minimum possible maximum | often sorting optional | `O(n)` | `O(n log range)` | `O(1)` |
| Maximum possible minimum | usually `O(n log n)` sort | `O(n)` | `O(n log n + n log range)` | `O(1)` or sort space |
| Floating-point binary search | `O(1)` | `O(check)` | `O(iterations * check)` | depends on check |
| Ternary search | `O(1)` | `O(f)` | `O(iterations * f)` | `O(1)` |
| Binary lifting | `O(n log n)` | `O(log n)` | `O(n log n + q log n)` | `O(n log n)` |
| Parallel binary search | depends on updates | batched | often `O((updates + queries) log range * data_structure_cost)` | depends on data structure |

For integer binary search:

```text
Number of iterations = O(log(high - low + 1))
```

For floating-point binary search:

```text
Number of iterations = fixed, usually 60 to 100
```

## 12. Common Patterns

| Pattern | How to Identify It | General Approach | Example Problems |
|---|---|---|---|
| Exact search | Sorted array, find target | Compare `a[mid]` with target | Binary Search, Search Insert Position |
| First true | Need first index satisfying condition | Lower-bound style binary search | First Bad Version, Lower Bound |
| Last true | Need last index satisfying condition | Store answer and move right | Last position satisfying condition |
| Count duplicates | Sorted array with repeated values | `upper_bound - lower_bound` | Count Occurrences in Sorted Array |
| Rotated sorted array | Sorted array rotated at pivot | Identify sorted half each step | LeetCode Search in Rotated Sorted Array |
| Minimum possible maximum | Minimize largest load/capacity/time | Binary search answer, greedy check | Allocate Books, Split Array Largest Sum |
| Maximum possible minimum | Maximize smallest distance/gap | Binary search answer, greedy placement | Aggressive Cows, Magnetic Force Between Balls |
| Kth value in sorted structure | Need kth smallest in matrix/table | Count values `<= mid` | Kth Smallest in Sorted Matrix |
| Real answer precision | Decimal answer accepted with error | Fixed-iteration binary search | Square Root, Minimum Speed |
| Unimodal optimization | Function increases then decreases | Ternary search | Maximum value of unimodal function |
| Tree jumping | kth ancestor, LCA | Binary lifting table | Kth Ancestor of Tree Node, LCA |
| Offline many queries | Many queries binary search over same timeline | Parallel binary search | Dynamic connectivity offline, kth query threshold |

## 13. Common Mistakes

* Using binary search on an unsorted/non-monotonic space.
* Writing `mid = (low + high) / 2` with large `int` bounds, causing overflow.
* Forgetting that lower bound can return `n`.
* Accessing `a[idx]` without checking `idx < n`.
* Confusing lower bound and upper bound.
* Returning `low` without proving what `low` represents.
* Infinite loop due to wrong boundary update.
* Using `low = mid` instead of `low = mid + 1` in integer search.
* Using `high = mid - 1` in a lower-bound style loop where `mid` may still be answer.
* Not sorting before binary search or greedy placement.
* Assuming rotated-array search with duplicates is always `O(log n)`.
* Writing a greedy `check(mid)` that is not actually correct.
* Binary searching the wrong answer range.
* Choosing `low = 0` when answer must be at least `max(a)`.
* Choosing `high = 1e9` blindly when a tighter bound exists.
* Forgetting to use `long long` for sums, capacities, products, and answer ranges.
* In floating-point binary search, stopping on exact equality.
* In ternary search, using it on non-unimodal functions.
* In binary lifting, not handling `-1` ancestors.

## 14. Edge Cases

Important cases to test:

* Empty array.
* Single element array.
* Target smaller than all elements.
* Target greater than all elements.
* Target appears once.
* Target appears many times.
* All elements equal.
* Lower bound returns `0`.
* Lower bound returns `n`.
* Upper bound returns `0`.
* Upper bound returns `n`.
* Rotated array not rotated.
* Rotated array rotated by one position.
* Rotated array with target at pivot.
* Rotated array with target absent.
* Large values near `1e9`.
* Large sums near `1e18`.
* Negative values in sorted array.
* Answer range of size `1`.
* `check(low)` already true.
* `check(high)` barely true.
* Floating answer less than `1`.
* Precision requirement like `1e-6`.
* Tree root ancestor in binary lifting.
* kth ancestor beyond root.

Graph-specific edge cases like disconnected graphs and cycles are not relevant to basic binary search, but they matter if your `check(mid)` uses graph algorithms.

## 15. Variations

### Basic Binary Search

What changes:

Searches exact target in sorted array.

When used:

Direct lookup in sorted data.

Importance:

Essential for placements and CP.

### Lower Bound

What changes:

Finds first index where value is at least target.

When used:

Insertion position, first valid value, coordinate compression, LIS.

Importance:

Very important.

### Upper Bound

What changes:

Finds first index where value is greater than target.

When used:

Counting duplicates, range frequency, last occurrence.

Importance:

Very important.

### First Occurrence

What changes:

Uses lower bound and verifies target exists.

When used:

Duplicate-heavy sorted arrays.

Importance:

Common in interviews.

### Last Occurrence

What changes:

Uses upper bound minus one.

When used:

Finding range of target values.

Importance:

Common in interviews.

### Search in Rotated Sorted Array

What changes:

Instead of the whole array being sorted, one half is sorted at each step.

When used:

Rotated sorted arrays, pivot-based search.

Importance:

Very common interview question.

### Binary Search on Answer

What changes:

Searches possible answers, not indices.

When used:

Optimization problems with monotonic feasibility.

Importance:

Extremely important for CP and online assessments.

### Minimum Possible Maximum

What changes:

Minimize the largest load, sum, time, or capacity.

When used:

Book allocation, ship packages, split array largest sum.

Importance:

Very important.

### Maximum Possible Minimum

What changes:

Maximize the smallest distance, value, or gap.

When used:

Aggressive cows, magnetic force, router placement.

Importance:

Very important.

### Floating-Point Binary Search

What changes:

Uses fixed iterations and `double`.

When used:

Precision answers, geometry, rates, roots.

Importance:

Useful in CP; less common in placements.

### Ternary Search

What changes:

Works on unimodal functions instead of monotonic predicates.

When used:

Optimize a single-peaked or single-valley function.

Importance:

Moderate in CP; rare in placements.

### Binary Search with Greedy Check

What changes:

The feasibility function uses greedy logic.

When used:

Capacity, partition, placement, scheduling.

Importance:

Extremely important.

### Binary Lifting Basics

What changes:

Uses powers of two to jump through tree ancestors.

When used:

Kth ancestor, LCA, functional graphs.

Importance:

Important for CP; useful for advanced interviews.

### Parallel Binary Search

What changes:

Many queries are binary searched together offline.

When used:

Many threshold queries with incremental updates.

Importance:

Advanced CP.

### Parametric Search Advanced

What changes:

Transforms optimization into repeated decision checks.

When used:

Greedy, DP, graph, MST, max flow, or data structure feasibility checks.

Importance:

Advanced CP and strong interview signal.

## 16. Related Algorithms/Data Structures

| Topic | Connection | How to Choose |
|---|---|---|
| Linear Search | Searches without sorted order | Use for small or unsorted data |
| Two Pointers | Also uses sorted/order structure | Use when both ends move based on pair/range conditions |
| Prefix Sum | Often used inside `check(mid)` | Use when feasibility needs fast range sums |
| Sorting | Often required before binary search | Sort first if order is needed and updates are absent |
| Hash Map | Exact lookup in average `O(1)` | Use when order/boundary is not needed |
| Balanced BST | Dynamic ordered search | Use when insert/delete and order queries are needed |
| Fenwick Tree | Prefix sums with updates | Use inside advanced checks or parallel binary search |
| Segment Tree | Range queries/updates | Use when `check(mid)` needs dynamic range information |
| Greedy | Common feasibility checker | Use when local choices can prove feasibility |
| Dynamic Programming | Sometimes used in `check(mid)` | Use when feasibility has states and greedy fails |
| BFS/DFS | Can be used inside `check(mid)` | Use for graph reachability under threshold |
| Dijkstra | Threshold or shortest path checks | Use when weighted graph feasibility depends on cost |
| Ternary Search | Optimizes unimodal function | Use when function is not monotonic but has one peak/valley |
| Binary Lifting | Power-of-two jumps | Use for tree/functional graph jumps, not array boundary search |

## 17. Practice Problems

### Easy

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Binary Search | LeetCode | Basic exact search in sorted array | Easy |
| Search Insert Position | LeetCode | Lower bound / insertion index | Easy |

### Medium

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Find First and Last Position of Element in Sorted Array | LeetCode | Lower bound + upper bound | Medium |
| Search in Rotated Sorted Array | LeetCode | Identify sorted half | Medium |
| Capacity To Ship Packages Within D Days | LeetCode | Minimum possible maximum with greedy check | Medium |

### Hard

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Split Array Largest Sum | LeetCode | Minimize maximum partition sum | Hard |
| Median of Two Sorted Arrays | LeetCode | Binary search partition | Hard |
| K-th Number in the Union of Segments | Codeforces | Binary search answer with counting check | Hard |

Additional CP practice:

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Aggressive Cows | SPOJ/GFG | Maximum possible minimum distance | Medium |
| Factory Machines | CSES | Minimum time with monotonic production check | Medium |
| Kth Smallest Number in Multiplication Table | LeetCode | Count values `<= mid` | Hard |
| Closest to the Left | Codeforces EDU | Upper-bound style search | Easy |
| Packing Rectangles | Codeforces EDU | Binary search answer | Medium |
| Queries about less or equal elements | Codeforces | Upper bound counting | Easy |

## 18. Interview Explanation

Binary search is used when the search space is sorted or when the answer has a monotonic feasibility condition. I keep two boundaries, choose the middle, and use the comparison or check result to discard half of the search space. For exact search, I compare `a[mid]` with the target. For boundary problems, I use lower-bound or upper-bound style search. For optimization problems, I binary search the answer and write a `check(mid)` function that tells whether a candidate answer is feasible. The complexity is usually `O(log n)` for array search or `O(check * log range)` for answer search.

## 19. Revision Notes

* Key idea: repeatedly discard half of a sorted or monotonic search space.
* Basic search condition: `a[mid] == target`, `< target`, `> target`.
* Safe midpoint: `mid = low + (high - low) / 2`.
* Lower bound: first `a[i] >= x`.
* Upper bound: first `a[i] > x`.
* Count of `x`: `upper_bound(x) - lower_bound(x)`.
* First occurrence: lower bound if target exists.
* Last occurrence: upper bound minus one if target exists.
* Binary search on answer needs a monotonic `check(mid)`.
* Minimum feasible answer: if `check(mid)` true, move left.
* Maximum feasible answer: if `check(mid)` true, move right.
* Use `long long` for large answer ranges.
* Floating binary search: use fixed iterations, usually 60 to 100.
* Ternary search is for unimodal functions, not monotonic predicates.
* Rotated search works cleanly with distinct elements.
* Common trap: wrong boundary updates causing infinite loop.
* Complexity: `O(log n)` or `O(check * log range)`.

## 20. Final Cheat Sheet

| Need | Use | Key Code Idea | Complexity |
|---|---|---|---|
| Find target in sorted array | Basic binary search | `low <= high` | `O(log n)` |
| First index `>= x` | Lower bound | if `a[mid] >= x`, `high = mid` | `O(log n)` |
| First index `> x` | Upper bound | if `a[mid] > x`, `high = mid` | `O(log n)` |
| First occurrence | Lower bound + verify | `idx < n && a[idx] == x` | `O(log n)` |
| Last occurrence | Upper bound - 1 + verify | `idx >= 0 && a[idx] == x` | `O(log n)` |
| Rotated sorted array | Sorted-half detection | check whether left or right half is sorted | `O(log n)` |
| Minimum possible maximum | Binary search answer | feasible means try smaller | `O(check * log range)` |
| Maximum possible minimum | Binary search answer | feasible means try larger | `O(check * log range)` |
| Decimal answer | Floating binary search | fixed 60 to 100 iterations | `O(iterations * check)` |
| Unimodal function | Ternary search | compare `f(mid1)` and `f(mid2)` | `O(iterations * f)` |
| Kth ancestor/LCA | Binary lifting | precompute `2^j` jumps | build `O(n log n)`, query `O(log n)` |
| Many offline threshold queries | Parallel binary search | group queries by midpoint | advanced |

Important edge cases:

* Empty array.
* One element.
* All duplicates.
* Target absent.
* Target at first or last index.
* Lower/upper bound returns `0` or `n`.
* Answer range has one value.
* Very large values requiring `long long`.
* Floating precision.
* Rotated array with duplicates.

Most reusable templates:

```cpp
// Minimum feasible answer: false false true true
while (low < high) {
    long long mid = low + (high - low) / 2;
    if (check(mid)) high = mid;
    else low = mid + 1;
}
return low;
```

```cpp
// Maximum feasible answer: true true false false
long long answer = low;
while (low <= high) {
    long long mid = low + (high - low) / 2;
    if (check(mid)) {
        answer = mid;
        low = mid + 1;
    } else {
        high = mid - 1;
    }
}
return answer;
```
