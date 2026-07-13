# Bit Manipulation

## 1. Overview

Bit manipulation means working directly with the binary representation of numbers.

Every integer is stored as bits: `0`s and `1`s. Bit manipulation uses operators like `&`, `|`, `^`, `~`, `<<`, and `>>` to test, modify, combine, and optimize computations on these bits.

It is heavily used in:

* coding interviews
* online assessments
* competitive programming
* subset generation
* dynamic programming over masks
* parity/counting problems
* memory-efficient optimizations
* graph/state compression problems

Example:

```text
5 = 101
3 = 011

5 & 3 = 001 = 1
5 | 3 = 111 = 7
5 ^ 3 = 110 = 6
```

Bit manipulation is not just a trick topic. It is a compact way to represent sets, states, choices, and boolean conditions.

## 2. Intuition

Think of an integer as a row of switches.

```text
bit index:  3 2 1 0
number 13:  1 1 0 1
```

Each bit can be either:

* `0`: switch is OFF
* `1`: switch is ON

Bit operations let us ask or change questions about these switches:

* Is switch `i` ON? Use `&`.
* Turn switch `i` ON. Use `|`.
* Turn switch `i` OFF. Use `& ~`.
* Flip switch `i`. Use `^`.
* Move all switches left or right. Use shifts.

Why this works:

* Powers of two have exactly one bit set.
* `1 << i` creates a number where only the `i`-th bit is set.
* Combining a number with this mask affects only that bit.

Example:

```text
n = 10 = 1010
i = 1
mask = 1 << 1 = 0010

n & mask = 1010 & 0010 = 0010
```

Since the result is non-zero, bit `1` is set.

For advanced problems, a bitmask can represent a set.

```text
mask = 10101
means elements {0, 2, 4} are selected
```

This turns subset/state problems into integer operations.

## 3. When to Use It

Use bit manipulation when the problem mentions or suggests:

* binary representation
* bits, set bits, unset bits
* XOR, AND, OR
* odd/even parity
* power of two
* every number appears twice except one
* subset generation
* all masks/submasks
* choose/not choose states
* state compression DP
* constraints like `n <= 20`
* boolean states for each item
* optimize memory using bitsets
* pairwise XOR, maximum XOR, XOR basis
* subset sum over bitmasks
* SOS DP, subset convolution, FWHT

Common trigger phrases:

* "find the single number"
* "count set bits"
* "check if a number is power of two"
* "generate all subsets"
* "minimum cost to visit all nodes"
* "assign jobs to workers"
* "maximum XOR"
* "number of subsets with property"
* "for every subset, compute..."
* "queries on many boolean values"
* "n is small, values are large"

## 4. When Not to Use It

Bit manipulation is not always the cleanest solution.

Avoid it when:

* A simple loop or array is clearer and fast enough.
* The problem is not actually about binary/state compression.
* `n` is too large for `2^n` algorithms.
* You need arbitrary precision and language integer behavior is tricky.
* Negative numbers are involved and the sign bit matters.
* Readability matters more than a small constant-factor optimization.
* A hash map, sorting, prefix sum, graph traversal, or greedy solution is simpler.

Common wrong assumptions:

* Assuming `x ^ y` is always related to difference. XOR is bitwise difference, not arithmetic difference.
* Assuming right shift behaves the same for negative numbers in every language.
* Assuming `1 << i` is safe for large `i` in C++ when `1` is an `int`.
* Using bitmask DP when `n = 30`, because `2^30` is too large.
* Forgetting that bit indexes are zero-based.

## 5. Core Concepts

### Binary Representation

Every integer is represented in base 2.

```text
13 = 1101
```

This matters because bit operations directly modify this representation.

### AND `&`

AND keeps a bit as `1` only if both bits are `1`.

| A | B | A & B |
|---|---|-------|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

Uses:

* check if a bit is set
* clear a bit
* extract common set bits
* test parity: `n & 1`

Example:

```text
6 & 3 = 110 & 011 = 010 = 2
```

### OR `|`

OR makes a bit `1` if at least one bit is `1`.

| A | B | A \| B |
|---|---|--------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 1 |

Uses:

* set a bit
* combine masks
* mark visited states

Example:

```text
8 | 2 = 1000 | 0010 = 1010 = 10
```

### XOR `^`

XOR makes a bit `1` if the two bits are different.

| A | B | A ^ B |
|---|---|-------|
| 0 | 0 | 0 |
| 0 | 1 | 1 |
| 1 | 0 | 1 |
| 1 | 1 | 0 |

Uses:

* toggle bits
* cancel equal values
* find single number
* parity
* maximum XOR problems

Important properties:

```text
x ^ x = 0
x ^ 0 = x
x ^ y = y ^ x
(x ^ y) ^ z = x ^ (y ^ z)
```

### NOT `~`

NOT flips every bit.

In C++, `~x` also flips sign bits because integers have fixed width and use two's complement.

Use carefully:

```cpp
n & ~(1 << i)
```

This clears bit `i`.

### Left Shift `<<`

`x << k` shifts bits left by `k`.

For non-overflowing positive integers:

```text
x << k = x * 2^k
```

Example:

```text
3 << 2 = 0011 << 2 = 1100 = 12
```

### Right Shift `>>`

`x >> k` shifts bits right by `k`.

For non-negative integers:

```text
x >> k = floor(x / 2^k)
```

Example:

```text
13 >> 2 = 1101 >> 2 = 0011 = 3
```

### Check if Bit is Set

```cpp
bool isSet = (n & (1LL << i)) != 0;
```

Why it matters:

* tests membership in a mask
* checks flags
* helps iterate selected elements

### Set Bit

```cpp
n = n | (1LL << i);
```

Turns bit `i` ON.

### Clear Bit

```cpp
n = n & ~(1LL << i);
```

Turns bit `i` OFF.

### Toggle Bit

```cpp
n = n ^ (1LL << i);
```

Flips bit `i`.

### Count Set Bits

Count how many `1` bits a number has.

```cpp
__builtin_popcount(x);      // int
__builtin_popcountll(x);    // long long
```

Used in:

* Hamming weight
* subset size
* parity checks
* DP by number of chosen items

### Power of Two Check

A positive power of two has exactly one set bit.

```cpp
bool isPowerOfTwo = n > 0 && (n & (n - 1)) == 0;
```

Example:

```text
8  = 1000
7  = 0111
8 & 7 = 0000
```

### Brian Kernighan Algorithm

Repeatedly remove the lowest set bit.

```cpp
while (x > 0) {
    x &= (x - 1);
    count++;
}
```

Runs in `O(number of set bits)`.

### Lowest Set Bit

The lowest set bit can be isolated using:

```cpp
x & -x
```

Example:

```text
x = 12 = 1100
x & -x = 0100 = 4
```

Used in:

* Fenwick Tree
* submask iteration
* bit decomposition

### Bitmasking

A bitmask stores a subset or state inside an integer.

```text
mask = 01011
selected indices = {0, 1, 3}
```

With `n` items, there are `2^n` masks from `0` to `(1 << n) - 1`.

### Subsets Using Bitmask

For every mask, include item `i` if bit `i` is set.

```cpp
for (int mask = 0; mask < (1 << n); mask++) {
    for (int i = 0; i < n; i++) {
        if (mask & (1 << i)) {
            // item i is included
        }
    }
}
```

### DP with Bitmask

Use `dp[mask]` to store the best answer for a subset/state.

Example:

```text
dp[mask] = minimum cost after choosing the items in mask
```

Common when `n <= 20`.

### XOR Basis Basics

An XOR basis is a set of numbers that can represent many XOR combinations.

It is like Gaussian elimination over bits.

Used for:

* maximum subset XOR
* checking if a value can be formed by XOR of subset
* rank of XOR space

### SOS DP

SOS means Sum Over Subsets.

It computes values like:

```text
g[mask] = sum of f[submask] for every submask of mask
```

Efficient complexity:

```text
O(n * 2^n)
```

instead of checking all submasks separately.

### Fast Walsh-Hadamard Transform

FWHT speeds up XOR/AND/OR convolution.

Use it when you need to combine functions over masks:

```text
c[k] = sum of a[i] * b[j] where i ^ j = k
```

Important mostly for advanced CP.

### Bitset Optimization

`std::bitset` stores many booleans compactly and processes them in machine-word chunks.

Used for:

* subset sum optimization
* graph reachability
* fast set intersections
* DP with boolean states

Example:

```cpp
bits |= (bits << value);
```

## 6. Step-by-Step Algorithm

Since bit manipulation is a toolkit, the steps depend on the pattern.

### Basic Bit Operation Steps

1. Decide which bit index `i` matters.
2. Build a mask using `1LL << i`.
3. Use the correct operator:
   * `&` to check or keep bits
   * `|` to set bits
   * `^` to toggle bits
   * `& ~` to clear bits
4. Store or compare the result.
5. Be careful with overflow and sign.

### Single Number Using XOR

1. Initialize `answer = 0`.
2. XOR every number into `answer`.
3. Equal numbers cancel because `x ^ x = 0`.
4. The remaining value is the number that appears once.

### Subsets Using Bitmask

1. Let `n` be the number of elements.
2. Iterate `mask` from `0` to `(1 << n) - 1`.
3. For each bit `i`, check if it is set in `mask`.
4. If set, include `arr[i]` in the current subset.
5. Process or store the subset.

### DP with Bitmask

1. Define what `mask` represents.
2. Define `dp[mask]`.
3. Initialize base states, usually `dp[0]`.
4. Iterate over masks.
5. Try adding/removing one element using bit operations.
6. Update the next state.
7. Return the required full-mask or best state.

### SOS DP

1. Store base values in `dp[mask]`.
2. For every bit `i`, iterate every `mask`.
3. If bit `i` is set in `mask`, add contribution from `mask ^ (1 << i)`.
4. After all bits, `dp[mask]` stores sum over all submasks.

### XOR Basis

1. Process numbers one by one.
2. For a number `x`, try to reduce it using existing basis vectors.
3. If it cannot be reduced to `0`, insert it as a new basis vector.
4. For maximum XOR, greedily try improving the answer from highest bit to lowest bit.

## 7. Dry Run

### Dry Run 1: Single Number

Input:

```text
nums = [4, 1, 2, 1, 2]
```

Initial state:

```text
answer = 0
```

| Step | Current number | Operation | Binary result | Decimal answer |
|------|----------------|-----------|---------------|----------------|
| 1 | 4 | `0 ^ 4` | `000 ^ 100 = 100` | 4 |
| 2 | 1 | `4 ^ 1` | `100 ^ 001 = 101` | 5 |
| 3 | 2 | `5 ^ 2` | `101 ^ 010 = 111` | 7 |
| 4 | 1 | `7 ^ 1` | `111 ^ 001 = 110` | 6 |
| 5 | 2 | `6 ^ 2` | `110 ^ 010 = 100` | 4 |

Final answer:

```text
4
```

Why:

```text
1 ^ 1 = 0
2 ^ 2 = 0
0 ^ 4 = 4
```

### Dry Run 2: Subsets Using Bitmask

Input:

```text
arr = [10, 20, 30]
```

There are `2^3 = 8` subsets.

| Mask | Binary | Selected indices | Subset |
|------|--------|------------------|--------|
| 0 | `000` | none | `[]` |
| 1 | `001` | 0 | `[10]` |
| 2 | `010` | 1 | `[20]` |
| 3 | `011` | 0, 1 | `[10, 20]` |
| 4 | `100` | 2 | `[30]` |
| 5 | `101` | 0, 2 | `[10, 30]` |
| 6 | `110` | 1, 2 | `[20, 30]` |
| 7 | `111` | 0, 1, 2 | `[10, 20, 30]` |

### Dry Run 3: Brian Kernighan Algorithm

Input:

```text
x = 13
```

Binary:

```text
13 = 1101
```

| Iteration | x before | x - 1 | x & (x - 1) | Count |
|-----------|----------|-------|-------------|-------|
| 1 | `1101` | `1100` | `1100` | 1 |
| 2 | `1100` | `1011` | `1000` | 2 |
| 3 | `1000` | `0111` | `0000` | 3 |

Final count:

```text
3
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

using ll = long long;

bool isBitSet(ll number, int bit) {
    return (number & (1LL << bit)) != 0;
}

ll setBit(ll number, int bit) {
    return number | (1LL << bit);
}

ll clearBit(ll number, int bit) {
    return number & ~(1LL << bit);
}

ll toggleBit(ll number, int bit) {
    return number ^ (1LL << bit);
}

int countSetBitsKernighan(ll number) {
    int count = 0;
    while (number > 0) {
        number &= (number - 1); // removes the lowest set bit
        count++;
    }
    return count;
}

bool isPowerOfTwo(ll number) {
    return number > 0 && (number & (number - 1)) == 0;
}

ll lowestSetBit(ll number) {
    return number & -number;
}

int singleNumber(const vector<int>& nums) {
    int answer = 0;
    for (int value : nums) {
        answer ^= value;
    }
    return answer;
}

vector<vector<int>> generateSubsets(const vector<int>& nums) {
    int n = (int)nums.size();
    vector<vector<int>> subsets;

    for (int mask = 0; mask < (1 << n); mask++) {
        vector<int> current;
        for (int bit = 0; bit < n; bit++) {
            if (mask & (1 << bit)) {
                current.push_back(nums[bit]);
            }
        }
        subsets.push_back(current);
    }

    return subsets;
}

int minimumAssignmentCost(const vector<vector<int>>& cost) {
    int n = (int)cost.size();
    int totalMasks = 1 << n;
    const int INF = 1e9;

    vector<int> dp(totalMasks, INF);
    dp[0] = 0;

    for (int mask = 0; mask < totalMasks; mask++) {
        int worker = __builtin_popcount((unsigned)mask);
        if (worker >= n) continue;

        for (int job = 0; job < n; job++) {
            if ((mask & (1 << job)) == 0) {
                int nextMask = mask | (1 << job);
                dp[nextMask] = min(dp[nextMask], dp[mask] + cost[worker][job]);
            }
        }
    }

    return dp[totalMasks - 1];
}

vector<long long> sosDp(vector<long long> values, int bits) {
    // After this, values[mask] = sum of original values[submask] for all submasks of mask.
    for (int bit = 0; bit < bits; bit++) {
        for (int mask = 0; mask < (1 << bits); mask++) {
            if (mask & (1 << bit)) {
                values[mask] += values[mask ^ (1 << bit)];
            }
        }
    }
    return values;
}

struct XorBasis {
    static const int LOG = 62;
    long long basis[LOG + 1]{};

    void insertVector(long long x) {
        for (int bit = LOG; bit >= 0; bit--) {
            if (((x >> bit) & 1LL) == 0) continue;

            if (basis[bit] == 0) {
                basis[bit] = x;
                return;
            }

            x ^= basis[bit];
        }
    }

    long long getMaxXor() const {
        long long answer = 0;
        for (int bit = LOG; bit >= 0; bit--) {
            answer = max(answer, answer ^ basis[bit]);
        }
        return answer;
    }

    bool canRepresent(long long x) const {
        for (int bit = LOG; bit >= 0; bit--) {
            if (((x >> bit) & 1LL) == 0) continue;
            if (basis[bit] == 0) return false;
            x ^= basis[bit];
        }
        return true;
    }
};

void fwhtXor(vector<long long>& a, bool inverse) {
    int n = (int)a.size();

    for (int length = 1; 2 * length <= n; length <<= 1) {
        for (int i = 0; i < n; i += 2 * length) {
            for (int j = 0; j < length; j++) {
                long long u = a[i + j];
                long long v = a[i + j + length];

                a[i + j] = u + v;
                a[i + j + length] = u - v;
            }
        }
    }

    if (inverse) {
        for (long long& value : a) {
            value /= n;
        }
    }
}

vector<long long> xorConvolution(vector<long long> a, vector<long long> b) {
    int n = 1;
    while (n < (int)max(a.size(), b.size())) n <<= 1;

    a.resize(n);
    b.resize(n);

    fwhtXor(a, false);
    fwhtXor(b, false);

    for (int i = 0; i < n; i++) {
        a[i] *= b[i];
    }

    fwhtXor(a, true);
    return a;
}

int main() {
    ll number = 10; // binary: 1010
    int bit = 1;

    cout << "Original number: " << number << '\n';
    cout << "Is bit set? " << isBitSet(number, bit) << '\n';
    cout << "After setting bit 0: " << setBit(number, 0) << '\n';
    cout << "After clearing bit 1: " << clearBit(number, 1) << '\n';
    cout << "After toggling bit 3: " << toggleBit(number, 3) << '\n';
    cout << "Set bits in 13: " << countSetBitsKernighan(13) << '\n';
    cout << "Is 16 power of two? " << isPowerOfTwo(16) << '\n';
    cout << "Lowest set bit of 12: " << lowestSetBit(12) << '\n';

    vector<int> nums = {4, 1, 2, 1, 2};
    cout << "Single number: " << singleNumber(nums) << '\n';

    vector<int> arr = {10, 20, 30};
    vector<vector<int>> subsets = generateSubsets(arr);
    cout << "Subsets:\n";
    for (const auto& subset : subsets) {
        cout << "{ ";
        for (int value : subset) cout << value << ' ';
        cout << "}\n";
    }

    vector<vector<int>> cost = {
        {9, 2, 7},
        {6, 4, 3},
        {5, 8, 1}
    };
    cout << "Minimum assignment cost: " << minimumAssignmentCost(cost) << '\n';

    XorBasis basis;
    basis.insertVector(3);
    basis.insertVector(10);
    basis.insertVector(5);
    cout << "Maximum subset XOR: " << basis.getMaxXor() << '\n';

    return 0;
}
```

Example output:

```text
Original number: 10
Is bit set? 1
After setting bit 0: 11
After clearing bit 1: 8
After toggling bit 3: 2
Set bits in 13: 3
Is 16 power of two? 1
Lowest set bit of 12: 4
Single number: 4
Subsets:
{ }
{ 10 }
{ 20 }
{ 10 20 }
{ 30 }
{ 10 30 }
{ 20 30 }
{ 10 20 30 }
Minimum assignment cost: 9
Maximum subset XOR: 15
```

## pYTHON IMPLEMENTATION

pROVIDE CLEAN PYTHON CODE

```python
def is_bit_set(number: int, bit: int) -> bool:
    return (number & (1 << bit)) != 0


def set_bit(number: int, bit: int) -> int:
    return number | (1 << bit)


def clear_bit(number: int, bit: int) -> int:
    return number & ~(1 << bit)


def toggle_bit(number: int, bit: int) -> int:
    return number ^ (1 << bit)


def count_set_bits_kernighan(number: int) -> int:
    count = 0
    while number > 0:
        number &= number - 1
        count += 1
    return count


def is_power_of_two(number: int) -> bool:
    return number > 0 and (number & (number - 1)) == 0


def lowest_set_bit(number: int) -> int:
    return number & -number


def single_number(nums: list[int]) -> int:
    answer = 0
    for value in nums:
        answer ^= value
    return answer


def generate_subsets(nums: list[int]) -> list[list[int]]:
    n = len(nums)
    subsets = []

    for mask in range(1 << n):
        current = []
        for bit in range(n):
            if mask & (1 << bit):
                current.append(nums[bit])
        subsets.append(current)

    return subsets


def minimum_assignment_cost(cost: list[list[int]]) -> int:
    n = len(cost)
    total_masks = 1 << n
    inf = 10**18
    dp = [inf] * total_masks
    dp[0] = 0

    for mask in range(total_masks):
        worker = mask.bit_count()
        if worker >= n:
            continue

        for job in range(n):
            if (mask & (1 << job)) == 0:
                next_mask = mask | (1 << job)
                dp[next_mask] = min(dp[next_mask], dp[mask] + cost[worker][job])

    return dp[total_masks - 1]


def sos_dp(values: list[int], bits: int) -> list[int]:
    values = values[:]
    for bit in range(bits):
        for mask in range(1 << bits):
            if mask & (1 << bit):
                values[mask] += values[mask ^ (1 << bit)]
    return values


class XorBasis:
    def __init__(self, log: int = 62):
        self.log = log
        self.basis = [0] * (log + 1)

    def insert(self, x: int) -> None:
        for bit in range(self.log, -1, -1):
            if ((x >> bit) & 1) == 0:
                continue

            if self.basis[bit] == 0:
                self.basis[bit] = x
                return

            x ^= self.basis[bit]

    def max_xor(self) -> int:
        answer = 0
        for bit in range(self.log, -1, -1):
            answer = max(answer, answer ^ self.basis[bit])
        return answer

    def can_represent(self, x: int) -> bool:
        for bit in range(self.log, -1, -1):
            if ((x >> bit) & 1) == 0:
                continue
            if self.basis[bit] == 0:
                return False
            x ^= self.basis[bit]
        return True


def fwht_xor(a: list[int], inverse: bool) -> None:
    n = len(a)
    length = 1

    while 2 * length <= n:
        for i in range(0, n, 2 * length):
            for j in range(length):
                u = a[i + j]
                v = a[i + j + length]
                a[i + j] = u + v
                a[i + j + length] = u - v
        length <<= 1

    if inverse:
        for i in range(n):
            a[i] //= n


def xor_convolution(a: list[int], b: list[int]) -> list[int]:
    n = 1
    while n < max(len(a), len(b)):
        n <<= 1

    a = a + [0] * (n - len(a))
    b = b + [0] * (n - len(b))

    fwht_xor(a, inverse=False)
    fwht_xor(b, inverse=False)

    for i in range(n):
        a[i] *= b[i]

    fwht_xor(a, inverse=True)
    return a


if __name__ == "__main__":
    number = 10
    bit = 1

    print("Original number:", number)
    print("Is bit set?", is_bit_set(number, bit))
    print("After setting bit 0:", set_bit(number, 0))
    print("After clearing bit 1:", clear_bit(number, 1))
    print("After toggling bit 3:", toggle_bit(number, 3))
    print("Set bits in 13:", count_set_bits_kernighan(13))
    print("Is 16 power of two?", is_power_of_two(16))
    print("Lowest set bit of 12:", lowest_set_bit(12))

    nums = [4, 1, 2, 1, 2]
    print("Single number:", single_number(nums))

    arr = [10, 20, 30]
    print("Subsets:", generate_subsets(arr))

    cost = [
        [9, 2, 7],
        [6, 4, 3],
        [5, 8, 1],
    ]
    print("Minimum assignment cost:", minimum_assignment_cost(cost))

    basis = XorBasis()
    for value in [3, 10, 5]:
        basis.insert(value)
    print("Maximum subset XOR:", basis.max_xor())
```

## 10. Code Explanation

### Basic Bit Functions

```cpp
bool isBitSet(ll number, int bit)
```

Checks whether the `bit`-th bit is set by ANDing the number with a mask.

```cpp
1LL << bit
```

Creates a mask with only one bit set. `1LL` is used to avoid overflow when shifting beyond normal `int` range.

```cpp
setBit(number, bit)
```

Uses OR because OR with `1` turns a bit ON while leaving other bits unchanged.

```cpp
clearBit(number, bit)
```

Uses `~(1LL << bit)` to create a mask where every bit is `1` except the target bit. ANDing clears only that bit.

```cpp
toggleBit(number, bit)
```

Uses XOR because XOR with `1` flips a bit and XOR with `0` keeps a bit unchanged.

### Count Set Bits

```cpp
number &= (number - 1);
```

This removes the lowest set bit. The loop runs once per set bit, not once per binary digit.

### Power of Two

```cpp
number > 0 && (number & (number - 1)) == 0
```

The `number > 0` check is necessary because `0 & -1` is also `0`, but `0` is not a power of two.

### Single Number

```cpp
answer ^= value;
```

Duplicates cancel out. Since XOR is associative and commutative, order does not matter.

### Generate Subsets

```cpp
for (int mask = 0; mask < (1 << n); mask++)
```

Each mask represents one subset.

```cpp
if (mask & (1 << bit))
```

If bit `bit` is set, include `nums[bit]`.

### Bitmask DP

```cpp
dp[mask] = minimum cost after assigning jobs represented by mask
```

The number of set bits in `mask` tells which worker is being assigned next.

```cpp
nextMask = mask | (1 << job)
```

This marks the chosen job as assigned.

### SOS DP

```cpp
values[mask] += values[mask ^ (1 << bit)];
```

When bit `bit` is set in `mask`, `mask ^ (1 << bit)` is the same mask with that bit removed. This adds contributions from submasks.

### XOR Basis

The array `basis[bit]` stores a representative number whose highest set bit is `bit`.

During insertion:

* If the current highest bit has no basis vector, insert the number.
* Otherwise XOR with the existing vector to remove that highest bit.
* If the number becomes `0`, it was already representable.

For maximum XOR:

```cpp
answer = max(answer, answer ^ basis[bit]);
```

Try to improve the answer greedily from high bits to low bits.

### FWHT

The transform combines pairs:

```cpp
u + v
u - v
```

After transforming both arrays, multiply pointwise, then apply inverse transform.

For XOR convolution, this computes:

```text
result[k] = sum a[i] * b[j] for all i ^ j = k
```

## 11. Complexity Analysis

| Operation / Algorithm | Time Complexity | Space Complexity | Notes |
|---|---:|---:|---|
| Check bit | `O(1)` | `O(1)` | Uses one mask |
| Set bit | `O(1)` | `O(1)` | OR operation |
| Clear bit | `O(1)` | `O(1)` | AND with negated mask |
| Toggle bit | `O(1)` | `O(1)` | XOR operation |
| Count set bits using loop over bits | `O(log n)` | `O(1)` | Checks every bit |
| Brian Kernighan count | `O(number of set bits)` | `O(1)` | Faster for sparse numbers |
| Power of two check | `O(1)` | `O(1)` | One AND operation |
| Single number using XOR | `O(n)` | `O(1)` | Works when duplicates appear exactly twice |
| Generate subsets | `O(n * 2^n)` | `O(n * 2^n)` | Output itself is exponential |
| Bitmask DP | Usually `O(n * 2^n)` | `O(2^n)` | Depends on transitions |
| Submask iteration for one mask | `O(3^n)` over all masks | `O(1)` extra | Common CP technique |
| SOS DP | `O(n * 2^n)` | `O(2^n)` | Sum over subsets/supersets |
| XOR basis insertion | `O(LOG)` | `O(LOG)` | `LOG` usually 30, 60, or 62 |
| FWHT XOR convolution | `O(n log n)` | `O(n)` | `n` must be power of two after padding |
| Bitset subset sum | `O(n * sum / word_size)` | `O(sum)` bits | Very fast in practice |

## 12. Common Patterns

| Pattern name | How to identify it | General approach | Example problems |
|---|---|---|---|
| Single number | Every element appears twice except one | XOR all values | LeetCode Single Number |
| Two single numbers | Every element appears twice except two | XOR all, split by lowest set bit | LeetCode Single Number III |
| Power of two | Need to test exact power of two | `n > 0 && (n & (n - 1)) == 0` | LeetCode Power of Two |
| Count set bits | Need number of `1`s in binary | Builtin or Brian Kernighan | LeetCode Number of 1 Bits |
| Hamming distance | Count differing bits | `popcount(x ^ y)` | LeetCode Hamming Distance |
| Generate all subsets | `n <= 20`, all choices needed | Iterate masks | LeetCode Subsets |
| State compression DP | Small `n`, each item chosen/not chosen | `dp[mask]` transitions | Assignment Problem, TSP |
| Submask enumeration | Need all submasks of a mask | `sub = (sub - 1) & mask` | Codeforces subset DP tasks |
| Sum over subsets | For each mask, aggregate submasks | SOS DP | Codeforces SOS DP problems |
| Maximum XOR | Need max XOR pair/subset | Trie or XOR basis | LeetCode Maximum XOR of Two Numbers |
| XOR convolution | Combine masks by XOR relation | FWHT | AtCoder/Codeforces advanced convolution |
| Bitset DP | Boolean DP with large states | `bitset |= bitset << x` | CSES Money Sums |

## 13. Common Mistakes

* Using `1 << bit` instead of `1LL << bit` when `bit >= 31`.
* Forgetting that bits are zero-indexed.
* Checking `n & (n - 1) == 0` without parentheses in languages where precedence may confuse readability.
* Forgetting `n > 0` in power-of-two checks.
* Using bitmask DP when `n` is too large.
* Shifting by a negative value or by at least the width of the type in C++.
* Applying right shift to negative numbers without understanding language behavior.
* Forgetting to initialize `dp[0]`.
* Using `int` for masks when `n` can be larger than 30.
* Assuming XOR solves problems where numbers appear three times.
* Forgetting that `~mask` flips all bits, including high/sign bits.
* Not padding arrays to power of two for FWHT.
* Not dividing by `n` in inverse FWHT.
* Mixing `popcount` overloads: use `__builtin_popcountll` for `long long`.
* Creating all subsets when only count or existence is needed.

## 14. Edge Cases

Test these cases:

* `n = 0`
* `n = 1`
* number is `0`
* number is `1`
* all bits unset
* all relevant bits set
* bit index `0`
* highest allowed bit index
* duplicate values
* all equal values
* exactly one unique number
* two unique numbers
* negative values if problem allows them
* very large values near `1e9`, `1e18`, or `LLONG_MAX`
* empty array
* single-element array
* `n = 20` for bitmask DP boundary
* impossible DP states
* masks with no submasks except `0`
* FWHT input size not initially power of two
* XOR basis with linearly dependent numbers

## 15. Variations

### Single Number Where Others Appear Twice

Use XOR of all numbers.

Important for placements: very important.

### Single Number Where Others Appear Thrice

Count bits modulo `3`, or use finite-state bit logic with `ones` and `twos`.

Important for placements: important.

### Two Single Numbers

XOR all numbers to get `a ^ b`, isolate one differing bit, then split numbers into two groups.

Important for placements: important.

### Maximum XOR Pair

Use a binary trie or bitwise greedy approach.

Important for placements: medium; important in CP.

### Maximum Subset XOR

Use XOR basis.

Important for placements: less common; important in CP.

### Bitmask DP for Assignment

Use `dp[mask]` where set bits represent assigned jobs.

Important for placements: common in hard OA/interview rounds.

### TSP DP

Use:

```text
dp[mask][last] = minimum cost to visit mask and end at last
```

Important for CP: very important.

### SOS DP Over Subsets

Computes aggregate over submasks efficiently.

Important for CP: advanced.

### SOS DP Over Supersets

Reverse condition:

```cpp
if ((mask & (1 << bit)) == 0)
    dp[mask] += dp[mask | (1 << bit)];
```

Important for CP: advanced.

### FWHT for XOR/AND/OR Convolution

Used when combining mask-indexed arrays under bitwise operators.

Important for CP: advanced.

### Bitset Subset Sum

Use bitset shifts to solve boolean subset sum quickly.

Important for placements: useful; important in CP.

## 16. Related Algorithms/Data Structures

* Hash Map vs XOR: Use XOR only when cancellation properties match exactly. Use hash maps for general frequency counting.
* Binary Trie vs XOR Basis: Use trie for maximum XOR pair/query with inserted values. Use XOR basis for maximum XOR of any subset.
* Backtracking vs Bitmask Subsets: Backtracking is clearer for recursive subset generation. Bitmasking is compact and useful for DP.
* Bitmask DP vs Graph BFS: Use bitmask DP when state is a subset. Use BFS when all transitions have equal cost and states form a graph.
* Bitmask DP vs Greedy: Use greedy only when local choices are provably safe. Assignment/TSP-style subset states usually need DP.
* Fenwick Tree vs Lowest Set Bit: Fenwick Tree uses `i & -i` to jump through ranges.
* Segment Tree vs Bitset: Segment tree handles dynamic range queries. Bitset is best for dense boolean operations.
* Meet-in-the-Middle vs Bitmask DP: Use meet-in-the-middle when `n` is around `30-40` and full `2^n` is too large.
* SOS DP vs Submask Enumeration: SOS DP is better when you need aggregate values for every mask.
* FWHT vs SOS DP: SOS DP aggregates subset/superset sums. FWHT performs convolution under XOR/AND/OR.

## 17. Practice Problems

### Easy

| Problem | Platform | Main idea/pattern | Difficulty |
|---|---|---|---|
| Single Number | LeetCode | XOR cancellation | Easy |
| Number of 1 Bits | LeetCode | Count set bits / Brian Kernighan | Easy |

### Medium

| Problem | Platform | Main idea/pattern | Difficulty |
|---|---|---|---|
| Subsets | LeetCode | Generate subsets using masks | Medium |
| Single Number III | LeetCode | XOR split by lowest set bit | Medium |
| Maximum XOR of Two Numbers in an Array | LeetCode | Bitwise trie / greedy XOR | Medium |

### Hard

| Problem | Platform | Main idea/pattern | Difficulty |
|---|---|---|---|
| Minimum XOR Sum of Two Arrays | LeetCode | Bitmask DP assignment | Hard |
| Traveling Salesman Problem | GFG / CSES-style | `dp[mask][last]` state compression | Hard |
| Compatible Numbers | Codeforces | SOS DP over masks | Hard |

More CP practice:

| Problem | Platform | Main idea/pattern | Difficulty |
|---|---|---|---|
| Money Sums | CSES | Bitset/subset sum DP | Medium |
| Close Group | AtCoder DP Contest | Bitmask DP | Hard |
| Vasya and a Tree/XOR variants | Codeforces | XOR basis / trie ideas | Hard |

## 18. Interview Explanation

Bit manipulation is a technique where we use the binary representation of integers directly. Each bit can represent a flag, choice, or membership in a subset. Operators like AND, OR, XOR, and shifts let us check, set, clear, toggle, and combine bits in constant time. It is especially useful when a problem has powers of two, parity, repeated numbers that cancel with XOR, or small `n` subset states. For example, in the single-number problem, XOR works because equal numbers cancel out and `x ^ 0 = x`, so XORing the entire array leaves only the unique element.

## 19. Revision Notes

* Key idea: represent boolean choices or binary states using bits.
* Check bit: `(mask & (1LL << i)) != 0`.
* Set bit: `mask | (1LL << i)`.
* Clear bit: `mask & ~(1LL << i)`.
* Toggle bit: `mask ^ (1LL << i)`.
* Count bits: `__builtin_popcountll(x)` or Brian Kernighan.
* Power of two: `x > 0 && (x & (x - 1)) == 0`.
* Lowest set bit: `x & -x`.
* XOR cancellation: `x ^ x = 0`, `x ^ 0 = x`.
* Subsets: iterate `mask` from `0` to `(1 << n) - 1`.
* Bitmask DP: `dp[mask]` often means best answer for selected set.
* SOS DP: aggregate over all submasks in `O(n * 2^n)`.
* XOR basis: Gaussian elimination over bits.
* FWHT: convolution under XOR/AND/OR.
* Common trap: `1 << 31` can overflow an `int`; use `1LL`.
* Common trap: bitmask DP is exponential, so usually `n <= 20`.

## 20. Final Cheat Sheet

| Need | Code idea | Complexity | Notes |
|---|---|---:|---|
| Check if bit `i` is set | `x & (1LL << i)` | `O(1)` | Non-zero means set |
| Set bit `i` | `x OR (1LL << i)` | `O(1)` | Turns bit ON |
| Clear bit `i` | `x & ~(1LL << i)` | `O(1)` | Turns bit OFF |
| Toggle bit `i` | `x ^ (1LL << i)` | `O(1)` | Flips bit |
| Count set bits | `__builtin_popcountll(x)` | `O(1)` practical | Compiler builtin |
| Count set bits manually | `x &= x - 1` loop | `O(set bits)` | Brian Kernighan |
| Power of two | `x > 0 && (x & (x - 1)) == 0` | `O(1)` | Exactly one set bit |
| Lowest set bit | `x & -x` | `O(1)` | Used in Fenwick Tree |
| Single number | XOR all values | `O(n)` | Works for pairs cancellation |
| Generate subsets | Loop all masks | `O(n * 2^n)` | Good for `n <= 20` |
| Bitmask DP | `dp[mask]` | Usually `O(n * 2^n)` | State compression |
| SOS DP | Add from smaller masks | `O(n * 2^n)` | Sum over subsets |
| XOR basis | Insert by highest bit | `O(LOG)` each | Maximum subset XOR |
| FWHT | Transform, multiply, inverse | `O(n log n)` | XOR convolution |
| Bitset optimization | `bits |= bits << value` | `O(n * sum / word_size)` | Fast boolean DP |

Important edge cases:

* `0` is not a power of two.
* Use `1LL << bit` in C++ for large bit positions.
* Negative numbers need careful handling.
* `2^n` algorithms become too slow after around `n = 22-25`.
* FWHT arrays must be padded to a power of two.
* For XOR problems, confirm the frequency pattern before applying cancellation.
