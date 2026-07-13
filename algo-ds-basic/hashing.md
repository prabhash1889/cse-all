# Hashing

## 1. Overview

Hashing is a technique that maps data such as integers, strings, pairs, or objects to an index/key so that lookup, insertion, and deletion can usually be done in **O(1)** average time.

In C++ STL, the most common hashing containers are:

| Container | Stores | Main use |
|---|---|---|
| `unordered_map<Key, Value>` | key-value pairs | frequency count, index lookup, prefix sums |
| `unordered_set<Key>` | unique keys only | membership check, duplicate detection |

Hashing is one of the most important tools for placements and competitive programming because many brute-force **O(n^2)** solutions can be optimized to **O(n)** using fast membership checks.

Topics covered in this guide:

* `unordered_map`
* `unordered_set`
* Frequency counting
* Pair sum / two sum
* Subarray sum with hashmap
* Longest consecutive sequence
* Detect duplicates
* Custom hash
* Hashing pairs
* Coordinate compression
* Rolling hash
* Double hashing
* Universal hashing basics

## 2. Intuition

Imagine a library where each book has a unique shelf code. Instead of searching every shelf, you compute the shelf code and directly jump near the book.

Hashing works similarly:

1. You take a key, for example `42`, `"apple"`, or `(3, 7)`.
2. A hash function converts it into a number.
3. That number decides where the key should be stored internally.
4. Later, when you need the key again, the same hash function takes you to the same place.

This is why operations are fast.

The core idea is:

> Store information in a way that future questions can be answered instantly.

Examples:

* To check if a number appeared before, store all seen numbers in a set.
* To count frequency, store `value -> count`.
* To solve two sum, store previous numbers and check if `target - current` exists.
* To count subarrays with sum `k`, store prefix sums seen so far.
* To compare strings quickly, store polynomial hashes of substrings.

Why it works:

* Hashing replaces repeated searching with direct lookup.
* Many problems ask, "Have I seen this before?" or "How many times did this appear?"
* A hashmap is designed exactly for those questions.

## 3. When to Use It

Use hashing when the problem involves:

* Fast lookup: "check if X exists"
* Counting: "frequency", "occurrence", "most common"
* Duplicate detection
* Pair or complement search
* Prefix-sum based subarray queries
* Grouping by key
* Mapping large values to compressed ids
* Storing visited states
* Comparing strings or substrings efficiently
* Memoization of computed states

Common trigger phrases:

* "contains duplicate"
* "find pair with given sum"
* "two sum"
* "subarray sum equals k"
* "number of subarrays with sum k"
* "longest consecutive sequence"
* "count distinct"
* "first non-repeating"
* "group anagrams"
* "same frequency"
* "large coordinate values"
* "compare many substrings"
* "find repeated substring"
* "check if pattern appears"

## 4. When Not to Use It

Hashing is not always the best choice.

Avoid or be careful with hashing when:

* You need elements in sorted order. Use `map`, `set`, sorting, or balanced BST.
* You need range queries like min/max/sum over intervals. Use prefix sums, Fenwick tree, segment tree, or sparse table.
* The input size is tiny and a simple loop is clearer.
* Worst-case guarantees matter. `unordered_map` has average O(1), but worst-case O(n) under heavy collisions.
* You need predecessor/successor queries. Use `set`/`map`.
* You are using custom keys without defining a hash function.
* You use floating point numbers as keys without thinking about precision.
* You rely on iteration order. `unordered_map` and `unordered_set` do not preserve order.
* You store too much data and memory becomes the bottleneck.

Common wrong assumptions:

* `unordered_map` is always faster than `map`. Not always; bad hashing and large constants can hurt.
* Hash lookup is guaranteed O(1). It is average O(1), worst-case O(n).
* Hashes uniquely identify values. Different values can have the same hash, called a collision.
* Rolling hash equality always means strings are equal. It is probabilistic unless verified or double hashed.

## 5. Core Concepts

### Hash Function

A hash function converts a key into an integer.

Example:

```cpp
hash<int>{}(42);
hash<string>{}("coding");
```

Why it matters:

* Good hash functions spread keys evenly.
* Bad hash functions create many collisions.
* Collisions slow down lookup.

### Collision

A collision happens when two different keys get mapped to the same bucket.

Example:

```text
hash("abc") % 10 = 4
hash("xyz") % 10 = 4
```

Why it matters:

* Collisions are normal.
* STL handles them internally.
* Too many collisions can degrade performance.

### `unordered_map`

Stores key-value pairs.

```cpp
unordered_map<string, int> freq;
freq["apple"]++;
```

Use it when every key needs associated data:

* frequency
* latest index
* prefix sum count
* parent mapping
* compressed id

### `unordered_set`

Stores unique keys only.

```cpp
unordered_set<int> seen;
seen.insert(10);
if (seen.count(10)) {
    cout << "found";
}
```

Use it when only existence matters.

### Frequency Counting

Frequency counting stores how many times each value appears.

Example:

```text
arr = [2, 3, 2, 5, 3, 2]
freq = {2: 3, 3: 2, 5: 1}
```

Why it matters:

* Used in anagrams, majority element variants, counting pairs, frequency sorting.

### Pair Sum / Two Sum

For each number `x`, check if `target - x` was seen earlier.

Example:

```text
target = 9
x = 4
need = 5
```

If `5` exists in the map/set, pair found.

### Prefix Sum Hashing

For subarray sum problems:

```text
sum(l..r) = prefix[r] - prefix[l - 1]
```

If we need `sum(l..r) = k`, then:

```text
prefix[l - 1] = prefix[r] - k
```

So while scanning, store frequencies of previous prefix sums.

### Custom Hash

Used when:

* Hashing pairs
* Hashing vectors
* Avoiding hacking in Codeforces-style tests
* Improving distribution for integer keys

### Coordinate Compression

Coordinate compression maps large values to small ids while preserving order.

Example:

```text
values = [1000000000, -5, 42]
compressed = [2, 0, 1]
```

Why it matters:

* Useful when values are huge but number of distinct values is small.
* Common before Fenwick tree, segment tree, DSU on values, frequency arrays.

### Rolling Hash

Rolling hash turns a string or substring into a numeric fingerprint.

Example:

```text
"abc" -> hash value
```

Then substring comparisons can be done quickly after preprocessing.

### Double Hashing

Double hashing uses two different mod values or bases.

Why it matters:

* Reduces probability of collision.
* Important in competitive programming string problems.

### Universal Hashing

Universal hashing means choosing a hash function randomly from a family of functions.

Why it matters:

* Makes it hard for adversarial input to cause many collisions.
* Useful conceptually for understanding randomized hashing and custom hashes.

## 6. Step-by-Step Algorithm

Because hashing is a technique, not one single algorithm, here are the key workflows.

### A. Frequency Counting

1. Create an empty hashmap `freq`.
2. Traverse the array/string.
3. For each value `x`, do `freq[x]++`.
4. Use the frequency map to answer questions.

### B. Pair Sum / Two Sum

1. Create an empty hashmap `index`.
2. Traverse the array from left to right.
3. For current value `x`, compute `need = target - x`.
4. If `need` exists in `index`, answer is found.
5. Otherwise store `x` with its index.

### C. Subarray Sum Equals K

1. Initialize `prefixSum = 0`.
2. Store `prefixCount[0] = 1`.
3. Traverse the array.
4. Add current element to `prefixSum`.
5. Add `prefixCount[prefixSum - k]` to answer.
6. Increment `prefixCount[prefixSum]`.

### D. Longest Consecutive Sequence

1. Insert all numbers into an unordered set.
2. For each number `x`, check if `x - 1` does not exist.
3. If true, `x` is the start of a sequence.
4. Keep checking `x + 1`, `x + 2`, etc.
5. Track maximum length.

### E. Coordinate Compression

1. Copy all values to another vector.
2. Sort the copy.
3. Remove duplicates.
4. For each original value, its compressed id is its index in the sorted unique vector.

### F. Rolling Hash

1. Choose a base and modulus.
2. Precompute powers of base.
3. Build prefix hash array.
4. Get substring hash in O(1).
5. Compare hashes to compare substrings.

## 7. Dry Run

### Dry Run 1: Two Sum

Input:

```text
arr = [2, 7, 11, 15]
target = 9
```

Initial state:

```text
index = {}
```

| Step | Current `x` | Need `target - x` | Map before check | Action |
|---:|---:|---:|---|---|
| 0 | 2 | 7 | `{}` | 7 not found, store `2 -> 0` |
| 1 | 7 | 2 | `{2: 0}` | 2 found at index 0, answer `[0, 1]` |

Final answer:

```text
[0, 1]
```

### Dry Run 2: Subarray Sum Equals K

Input:

```text
arr = [1, 2, 3, -2, 5]
k = 3
```

Initial state:

```text
prefixSum = 0
prefixCount = {0: 1}
answer = 0
```

| i | arr[i] | prefixSum | Need `prefixSum - k` | Found count | answer | prefixCount after update |
|---:|---:|---:|---:|---:|---:|---|
| 0 | 1 | 1 | -2 | 0 | 0 | `{0:1, 1:1}` |
| 1 | 2 | 3 | 0 | 1 | 1 | `{0:1, 1:1, 3:1}` |
| 2 | 3 | 6 | 3 | 1 | 2 | `{0:1, 1:1, 3:1, 6:1}` |
| 3 | -2 | 4 | 1 | 1 | 3 | `{0:1, 1:1, 3:1, 6:1, 4:1}` |
| 4 | 5 | 9 | 6 | 1 | 4 | `{0:1, 1:1, 3:1, 6:1, 4:1, 9:1}` |

Subarrays with sum `3`:

* `[1, 2]`
* `[3]`
* `[2, 3, -2]`
* `[-2, 5]`

Final answer:

```text
4
```

### Dry Run 3: Longest Consecutive Sequence

Input:

```text
arr = [100, 4, 200, 1, 3, 2]
```

Set:

```text
{100, 4, 200, 1, 3, 2}
```

| Number | Is start? | Sequence checked | Length |
|---:|---|---|---:|
| 100 | yes, 99 missing | 100 | 1 |
| 4 | no, 3 exists | skip | - |
| 200 | yes, 199 missing | 200 | 1 |
| 1 | yes, 0 missing | 1, 2, 3, 4 | 4 |
| 3 | no, 2 exists | skip | - |
| 2 | no, 1 exists | skip | - |

Final answer:

```text
4
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

// Stronger hash for integers and pairs.
// Useful in competitive programming to reduce collision attacks.
struct CustomHash {
    static uint64_t splitmix64(uint64_t x) {
        x += 0x9e3779b97f4a7c15;
        x = (x ^ (x >> 30)) * 0xbf58476d1ce4e5b9;
        x = (x ^ (x >> 27)) * 0x94d049bb133111eb;
        return x ^ (x >> 31);
    }

    size_t operator()(uint64_t x) const {
        static const uint64_t FIXED_RANDOM =
            chrono::steady_clock::now().time_since_epoch().count();
        return splitmix64(x + FIXED_RANDOM);
    }

    size_t operator()(const pair<int, int>& p) const {
        uint64_t combined = ((uint64_t)(uint32_t)p.first << 32) ^ (uint32_t)p.second;
        return operator()(combined);
    }
};

unordered_map<int, int> frequencyCount(const vector<int>& nums) {
    unordered_map<int, int> freq;

    for (int x : nums) {
        freq[x]++;
    }

    return freq;
}

bool containsDuplicate(const vector<int>& nums) {
    unordered_set<int> seen;

    for (int x : nums) {
        if (seen.count(x)) {
            return true;
        }
        seen.insert(x);
    }

    return false;
}

vector<int> twoSum(const vector<int>& nums, int target) {
    unordered_map<int, int> index;

    for (int i = 0; i < (int)nums.size(); i++) {
        int need = target - nums[i];

        if (index.count(need)) {
            return {index[need], i};
        }

        index[nums[i]] = i;
    }

    return {-1, -1};
}

long long countSubarraysWithSumK(const vector<int>& nums, long long k) {
    unordered_map<long long, long long> prefixCount;
    prefixCount[0] = 1;

    long long prefixSum = 0;
    long long answer = 0;

    for (int x : nums) {
        prefixSum += x;
        answer += prefixCount[prefixSum - k];
        prefixCount[prefixSum]++;
    }

    return answer;
}

int longestConsecutiveSequence(const vector<int>& nums) {
    unordered_set<int> values(nums.begin(), nums.end());
    int best = 0;

    for (int x : values) {
        if (!values.count(x - 1)) {
            int current = x;
            int length = 1;

            while (values.count(current + 1)) {
                current++;
                length++;
            }

            best = max(best, length);
        }
    }

    return best;
}

vector<int> coordinateCompress(const vector<int>& nums) {
    vector<int> sortedValues = nums;
    sort(sortedValues.begin(), sortedValues.end());
    sortedValues.erase(unique(sortedValues.begin(), sortedValues.end()), sortedValues.end());

    vector<int> compressed;
    compressed.reserve(nums.size());

    for (int x : nums) {
        int id = lower_bound(sortedValues.begin(), sortedValues.end(), x) - sortedValues.begin();
        compressed.push_back(id);
    }

    return compressed;
}

class RollingHash {
private:
    static const long long MOD = 1000000007LL;
    static const long long BASE = 911382323LL;
    vector<long long> prefixHash;
    vector<long long> power;

public:
    RollingHash(const string& s) {
        int n = (int)s.size();
        prefixHash.assign(n + 1, 0);
        power.assign(n + 1, 1);

        for (int i = 0; i < n; i++) {
            power[i + 1] = (power[i] * BASE) % MOD;
            prefixHash[i + 1] = (prefixHash[i] * BASE + s[i]) % MOD;
        }
    }

    // Returns hash of substring s[left..right], 0-indexed and inclusive.
    long long getHash(int left, int right) const {
        long long result = prefixHash[right + 1] -
                           (prefixHash[left] * power[right - left + 1]) % MOD;

        if (result < 0) {
            result += MOD;
        }

        return result;
    }
};

class DoubleRollingHash {
private:
    static const long long MOD1 = 1000000007LL;
    static const long long MOD2 = 1000000009LL;
    static const long long BASE = 911382323LL;

    vector<long long> pref1, pref2, pow1, pow2;

public:
    DoubleRollingHash(const string& s) {
        int n = (int)s.size();
        pref1.assign(n + 1, 0);
        pref2.assign(n + 1, 0);
        pow1.assign(n + 1, 1);
        pow2.assign(n + 1, 1);

        for (int i = 0; i < n; i++) {
            pow1[i + 1] = (pow1[i] * BASE) % MOD1;
            pow2[i + 1] = (pow2[i] * BASE) % MOD2;

            pref1[i + 1] = (pref1[i] * BASE + s[i]) % MOD1;
            pref2[i + 1] = (pref2[i] * BASE + s[i]) % MOD2;
        }
    }

    pair<long long, long long> getHash(int left, int right) const {
        long long h1 = pref1[right + 1] - (pref1[left] * pow1[right - left + 1]) % MOD1;
        long long h2 = pref2[right + 1] - (pref2[left] * pow2[right - left + 1]) % MOD2;

        if (h1 < 0) h1 += MOD1;
        if (h2 < 0) h2 += MOD2;

        return {h1, h2};
    }
};

int main() {
    vector<int> nums = {1, 2, 3, -2, 5};

    auto freq = frequencyCount(nums);
    cout << "Frequency of 2: " << freq[2] << '\n';

    cout << "Contains duplicate: " << (containsDuplicate(nums) ? "Yes" : "No") << '\n';

    vector<int> pairAnswer = twoSum({2, 7, 11, 15}, 9);
    cout << "Two sum indices: " << pairAnswer[0] << " " << pairAnswer[1] << '\n';

    cout << "Subarrays with sum 3: " << countSubarraysWithSumK(nums, 3) << '\n';

    cout << "Longest consecutive length: "
         << longestConsecutiveSequence({100, 4, 200, 1, 3, 2}) << '\n';

    vector<int> compressed = coordinateCompress({1000000000, -5, 42, -5});
    cout << "Compressed values: ";
    for (int x : compressed) {
        cout << x << " ";
    }
    cout << '\n';

    string s = "abracadabra";
    DoubleRollingHash hash(s);
    cout << "Hash of substring [0, 2]: "
         << hash.getHash(0, 2).first << " "
         << hash.getHash(0, 2).second << '\n';

    unordered_map<pair<int, int>, int, CustomHash> pairFrequency;
    pairFrequency[{2, 3}]++;
    cout << "Frequency of pair (2, 3): " << pairFrequency[{2, 3}] << '\n';

    return 0;
}
```

Example output:

```text
Frequency of 2: 1
Contains duplicate: No
Two sum indices: 0 1
Subarrays with sum 3: 4
Longest consecutive length: 4
Compressed values: 2 0 1 0
Hash of substring [0, 2]: 983030449 843191546
Frequency of pair (2, 3): 1
```

## pYTHON IMPLEMENTATION

```python
from collections import Counter, defaultdict


def frequency_count(nums):
    return Counter(nums)


def contains_duplicate(nums):
    seen = set()

    for x in nums:
        if x in seen:
            return True
        seen.add(x)

    return False


def two_sum(nums, target):
    index = {}

    for i, x in enumerate(nums):
        need = target - x

        if need in index:
            return [index[need], i]

        index[x] = i

    return [-1, -1]


def count_subarrays_with_sum_k(nums, k):
    prefix_count = defaultdict(int)
    prefix_count[0] = 1

    prefix_sum = 0
    answer = 0

    for x in nums:
        prefix_sum += x
        answer += prefix_count[prefix_sum - k]
        prefix_count[prefix_sum] += 1

    return answer


def longest_consecutive_sequence(nums):
    values = set(nums)
    best = 0

    for x in values:
        if x - 1 not in values:
            current = x
            length = 1

            while current + 1 in values:
                current += 1
                length += 1

            best = max(best, length)

    return best


def coordinate_compress(nums):
    sorted_unique = sorted(set(nums))
    compressed_id = {value: i for i, value in enumerate(sorted_unique)}
    return [compressed_id[x] for x in nums]


class DoubleRollingHash:
    MOD1 = 1_000_000_007
    MOD2 = 1_000_000_009
    BASE = 911382323

    def __init__(self, s):
        n = len(s)
        self.pref1 = [0] * (n + 1)
        self.pref2 = [0] * (n + 1)
        self.pow1 = [1] * (n + 1)
        self.pow2 = [1] * (n + 1)

        for i, ch in enumerate(s):
            value = ord(ch)
            self.pow1[i + 1] = (self.pow1[i] * self.BASE) % self.MOD1
            self.pow2[i + 1] = (self.pow2[i] * self.BASE) % self.MOD2
            self.pref1[i + 1] = (self.pref1[i] * self.BASE + value) % self.MOD1
            self.pref2[i + 1] = (self.pref2[i] * self.BASE + value) % self.MOD2

    def get_hash(self, left, right):
        length = right - left + 1

        h1 = self.pref1[right + 1] - (self.pref1[left] * self.pow1[length]) % self.MOD1
        h2 = self.pref2[right + 1] - (self.pref2[left] * self.pow2[length]) % self.MOD2

        return h1 % self.MOD1, h2 % self.MOD2


if __name__ == "__main__":
    nums = [1, 2, 3, -2, 5]

    print("Frequency:", frequency_count(nums))
    print("Contains duplicate:", contains_duplicate(nums))
    print("Two sum:", two_sum([2, 7, 11, 15], 9))
    print("Subarrays with sum 3:", count_subarrays_with_sum_k(nums, 3))
    print("Longest consecutive:", longest_consecutive_sequence([100, 4, 200, 1, 3, 2]))
    print("Compressed:", coordinate_compress([1000000000, -5, 42, -5]))

    rh = DoubleRollingHash("abracadabra")
    print("Hash of substring [0, 2]:", rh.get_hash(0, 2))
```

## 10. Code Explanation

### `CustomHash`

`CustomHash` uses `splitmix64`, a strong mixing function.

Important blocks:

* `splitmix64` spreads nearby integers into very different-looking values.
* `FIXED_RANDOM` changes the hash seed at runtime.
* `operator()(uint64_t x)` hashes integers.
* `operator()(const pair<int, int>& p)` combines two integers into one 64-bit value and hashes it.

Why it matters:

* Normal `unordered_map<int, int>` is usually fine in interviews.
* In competitive programming, adversarial tests can cause collisions.
* Custom hash reduces this risk.

### `frequencyCount`

```cpp
unordered_map<int, int> freq;
for (int x : nums) {
    freq[x]++;
}
```

For each value, increment its count.

Edge handling:

* Missing keys automatically start from `0` when using `freq[x]++`.
* Works with negative and large integer values.

### `containsDuplicate`

```cpp
if (seen.count(x)) return true;
seen.insert(x);
```

The set stores elements already seen.

If an element appears again, it is a duplicate.

### `twoSum`

```cpp
int need = target - nums[i];
if (index.count(need)) return {index[need], i};
index[nums[i]] = i;
```

For every current value:

* `need` is the number required to complete the pair.
* If `need` appeared earlier, the answer is found.
* Otherwise, store the current number for future elements.

Why store after checking?

* To avoid using the same element twice.

### `countSubarraysWithSumK`

```cpp
prefixCount[0] = 1;
```

This handles subarrays starting from index `0`.

```cpp
prefixSum += x;
answer += prefixCount[prefixSum - k];
prefixCount[prefixSum]++;
```

If previous prefix sum was `prefixSum - k`, then the subarray between that previous index and current index has sum `k`.

Why `long long`?

* Prefix sums can overflow `int` when values or `n` are large.

### `longestConsecutiveSequence`

```cpp
if (!values.count(x - 1)) {
```

Only start counting from the beginning of a sequence.

Example:

* For sequence `1, 2, 3, 4`, start from `1`.
* Skip `2`, `3`, and `4` because they have predecessors.

This ensures each number is visited only a constant number of times overall.

### `coordinateCompress`

```cpp
sort(sortedValues.begin(), sortedValues.end());
sortedValues.erase(unique(...), sortedValues.end());
```

This creates a sorted list of unique values.

```cpp
lower_bound(...)
```

Finds the index of each original value in the sorted unique list.

This index is the compressed coordinate.

### `RollingHash` and `DoubleRollingHash`

The prefix hash formula is:

```text
hash[i + 1] = hash[i] * BASE + s[i]
```

Substring hash:

```text
hash(l..r) = prefix[r + 1] - prefix[l] * BASE^(r-l+1)
```

Double hashing calculates two independent hashes:

```cpp
return {h1, h2};
```

This makes accidental collisions much less likely.

## 11. Complexity Analysis

| Topic / Operation | Preprocessing | Query / Operation | Overall Time | Space |
|---|---:|---:|---:|---:|
| `unordered_map` insert/find/erase | - | O(1) average, O(n) worst | Depends on operations | O(n) |
| `unordered_set` insert/find/erase | - | O(1) average, O(n) worst | Depends on operations | O(n) |
| Frequency counting | - | - | O(n) average | O(d), `d` distinct values |
| Detect duplicates | - | - | O(n) average | O(n) |
| Two sum | - | - | O(n) average | O(n) |
| Subarray sum with hashmap | - | - | O(n) average | O(n) |
| Longest consecutive sequence | - | - | O(n) average | O(n) |
| Coordinate compression | sorting | O(log n) per lookup with `lower_bound` | O(n log n) | O(n) |
| Coordinate compression with map | sorting | O(1) average lookup after map build | O(n log n) | O(n) |
| Rolling hash | O(n) | O(1) substring hash | O(n + q) | O(n) |
| Double hashing | O(n) | O(1) substring hash | O(n + q) | O(n) |
| Universal hashing concept | depends on chosen family | O(1) expected | O(n) expected | O(n) |

Notes:

* `d` means number of distinct keys.
* Worst-case hashmap complexity can become O(n) per operation if many collisions occur.
* In CP, use custom hash when worried about adversarial tests.

## 12. Common Patterns

| Pattern | How to Identify It | General Approach | Example Problems |
|---|---|---|---|
| Frequency counting | asks count, mode, duplicate counts, anagram | store `value -> frequency` | Valid Anagram, Top K Frequent Elements |
| Existence lookup | asks if value appeared before | use `unordered_set` | Contains Duplicate |
| Complement search | asks pair with target sum/product/difference | check complement in map/set | Two Sum, Pair Sum |
| Prefix sum + hashmap | asks count/longest subarray with sum/zero sum | store previous prefix sums | Subarray Sum Equals K |
| First/last index tracking | asks longest distance or earliest occurrence | store first index of key | Longest Subarray with Sum K |
| Grouping by signature | asks group anagrams/equivalent items | hash sorted string or frequency vector | Group Anagrams |
| Consecutive sequence | asks longest consecutive unsorted sequence | set membership, start only at sequence head | Longest Consecutive Sequence |
| State hashing | repeated states in BFS/DP/game | encode state as key | Word Ladder visited states |
| Pair hashing | key is `(x, y)` | custom hash for pair | points on grid, graph edges |
| Coordinate compression | huge values but few distinct values | map values to sorted ids | CSES Nested Ranges, inversion count |
| Rolling hash | many substring comparisons | prefix polynomial hash | Rabin-Karp, repeated substring |
| Double hashing | collision risk in string hashing | store two hashes | substring equality in CP |

## 13. Common Mistakes

* Using `mp[key]` just to check existence. It inserts the key. Prefer `mp.count(key)` or `mp.find(key)`.
* Forgetting `prefixCount[0] = 1` in subarray sum problems.
* Using `int` for prefix sums when values can be large.
* Storing current value before checking complement in two sum, which may reuse the same index.
* Assuming `unordered_map` iteration is sorted.
* Using `unordered_map<pair<int, int>, int>` without a custom hash.
* Forgetting that duplicate values can overwrite indices in two sum variants.
* Treating rolling hash equality as 100% proof without verification or double hashing.
* Choosing a bad base/mod for string hashing.
* Negative modulo bugs in rolling hash.
* Not removing duplicates during coordinate compression.
* Using coordinate compression when the actual distance between coordinates matters.
* Forgetting that `unordered_map` worst-case can be slow under collisions.
* Not reserving space for large maps in performance-heavy code.
* Using floating point values directly as hash keys.

## 14. Edge Cases

Test these edge cases:

| Case | Why Important |
|---|---|
| Empty input | many functions should return 0, false, or empty result |
| Single element | duplicate and pair logic must not break |
| All equal elements | frequency and duplicates should work |
| All distinct elements | duplicate detection should return false |
| Negative values | prefix sums and hash keys must support them |
| Large values | coordinate compression and `long long` prefix sums matter |
| Target sum impossible | two sum should return no answer safely |
| Target sum using duplicate values | example `[3, 3]`, target `6` |
| Subarray starts at index 0 | needs `prefixCount[0] = 1` |
| Sum `k = 0` | common in zero-sum problems |
| Repeated prefix sums | count all valid subarrays, not just one |
| Already sorted consecutive numbers | longest consecutive should be O(n), not O(n^2) |
| Reverse sorted input | set-based sequence logic should still work |
| Large string | rolling hash arrays should be sized correctly |
| Same hash collision possibility | verify or use double hashing in critical cases |
| Pair keys with negative values | custom hash should handle them safely |

Graph-specific cases like disconnected graphs and cycles are usually not direct hashing edge cases, but hashing is often used to store visited nodes or states in those problems.

## 15. Variations

### Ordered Map vs Unordered Map

What changes:

* `map` keeps keys sorted.
* `unordered_map` does not.

When used:

* Use `map` for sorted traversal, lower/upper bound, predecessor/successor.
* Use `unordered_map` for fast average lookup.

Importance:

* Very important for both placements and CP.

### Frequency Array Instead of Hashmap

What changes:

* Use `vector<int> freq(maxValue + 1)` instead of hashmap.

When used:

* Values are small and non-negative.

Importance:

* Important for OAs because it is faster and simpler when constraints allow.

### Hashmap for Longest Subarray Sum K

What changes:

* Store first index of each prefix sum instead of count.

When used:

* Need maximum length, not number of subarrays.

Importance:

* Very common interview variation.

### Hashing Pairs

What changes:

* Key is a pair like `(row, col)` or `(u, v)`.
* Need custom hash in C++.

When used:

* Grid points, graph edges, coordinate states.

Importance:

* Important for CP and advanced interview problems.

### Coordinate Compression with Hashmap

What changes:

* After sorting unique values, build `value -> compressedId`.
* Then each lookup is O(1) average instead of O(log n).

When used:

* Many repeated coordinate lookups.

Importance:

* Important in CP.

### Rolling Hash for Pattern Matching

What changes:

* Hash pattern once.
* Compare with every substring hash of the same length.

When used:

* Rabin-Karp pattern searching.

Importance:

* More CP-focused, less common in basic placements.

### Double Hashing

What changes:

* Store two hashes instead of one.

When used:

* String equality, repeated substring, palindrome hashing where collision risk matters.

Importance:

* Important for CP string problems.

### Universal Hashing

What changes:

* Pick hash parameters randomly from a family.

When used:

* Theoretical hashing, randomized protection from adversarial input.

Importance:

* Useful to know conceptually; rarely implemented in placements.

## 16. Related Algorithms/Data Structures

| Topic | Connection | How to Choose |
|---|---|---|
| Array / vector | faster than hashmap for small integer ranges | use vector frequency if values are small |
| Sorting | can solve duplicates, pairs, grouping | use sorting when order is useful or memory should be lower |
| Two pointers | pair sum in sorted arrays | use two pointers after sorting if indices/order are not important |
| Prefix sum | works with hashmap for subarray sums | use prefix sum alone for fixed range queries, hashmap for arbitrary target counts |
| Sliding window | subarray problems with non-negative numbers | use hashmap prefix sums when negatives exist |
| `map` / `set` | ordered alternatives | use when sorted order or bounds are needed |
| Heap | top K frequent elements | use hashmap for counts, heap for top K extraction |
| Trie | string prefix queries | use trie for prefix structure, rolling hash for substring equality |
| KMP | exact pattern matching | KMP is deterministic, rolling hash is simpler but probabilistic |
| Z Algorithm | pattern/string matching | Z is deterministic and linear; rolling hash helps with many substring queries |
| Fenwick Tree | range frequency after compression | coordinate compress first, then use Fenwick |
| Segment Tree | range min/max/sum after compression | use when updates and range queries are needed |
| DSU | connected components | hashing can map arbitrary labels to DSU ids |
| BFS/DFS visited set | state tracking | use hash set for visited states in graph/search problems |

## 17. Practice Problems

### Easy

| Problem | Platform | Main Idea / Pattern | Difficulty |
|---|---|---|---|
| Contains Duplicate | LeetCode | unordered set for duplicate detection | Easy |
| Valid Anagram | LeetCode | frequency counting | Easy |

### Medium

| Problem | Platform | Main Idea / Pattern | Difficulty |
|---|---|---|---|
| Two Sum | LeetCode | complement lookup using hashmap | Easy/Medium pattern |
| Subarray Sum Equals K | LeetCode | prefix sum + hashmap count | Medium |
| Longest Consecutive Sequence | LeetCode | unordered set and sequence starts | Medium |

### Hard

| Problem | Platform | Main Idea / Pattern | Difficulty |
|---|---|---|---|
| Minimum Window Substring | LeetCode | frequency map + sliding window | Hard |
| Count Subarrays With Median K | LeetCode | transformed prefix balance + hashmap | Hard |
| String Matching / Finding Borders with Hashing | Codeforces / CSES | rolling hash or double hashing | Hard |

Additional useful practice:

| Problem | Platform | Main Idea / Pattern | Difficulty |
|---|---|---|---|
| Group Anagrams | LeetCode | hash by sorted string or frequency signature | Medium |
| Top K Frequent Elements | LeetCode | hashmap + heap/bucket sort | Medium |
| 4Sum II | LeetCode | hashmap of pair sums | Medium |
| Longest Subarray with Sum K | GFG | prefix sum + first index map | Medium |
| Distinct Numbers | CSES | set / sorting | Easy |
| Rabin-Karp Algorithm | GFG | rolling hash pattern matching | Medium |

## 18. Interview Explanation

Hashing stores data in a way that makes lookup, insertion, and deletion O(1) on average. I use `unordered_set` when I only need to know whether something exists, and `unordered_map` when I need to store extra information like frequency, index, or prefix-sum count. Many problems become efficient by storing previously seen values and asking whether the current value has a required complement or matching prefix. I also remember that hashing has collision risk, unordered containers do not maintain order, and prefix sums should often use `long long`.

## 19. Revision Notes

* Key idea: replace repeated searching with fast lookup.
* `unordered_set`: use for existence and duplicate detection.
* `unordered_map`: use for frequency, index, prefix sum count, grouping.
* Two sum: check `target - x` before storing `x`.
* Subarray sum equals `k`: store counts of prefix sums.
* Formula: if `prefix[r] - prefix[l - 1] = k`, then `prefix[l - 1] = prefix[r] - k`.
* Longest consecutive: only start from `x` if `x - 1` is missing.
* Coordinate compression: sort, unique, map value to index.
* Rolling hash substring formula: `H(l, r) = pref[r + 1] - pref[l] * base^(r-l+1)`.
* Use double hashing when string collision risk matters.
* Complexity: most hashmap patterns are O(n) average time and O(n) space.
* Common traps: `mp[key]` inserts, missing `prefixCount[0]`, integer overflow, assuming order, pair key without custom hash.

## 20. Final Cheat Sheet

| Need | Use | Key Code Idea | Complexity |
|---|---|---|---|
| Check duplicates | `unordered_set` | if seen before, duplicate exists | O(n) average |
| Count frequency | `unordered_map<T, int>` | `freq[x]++` | O(n) average |
| Two sum | `unordered_map<int, int>` | check `target - x` | O(n) average |
| Count subarrays sum `k` | prefix sum + hashmap | `ans += count[prefix - k]` | O(n) average |
| Longest consecutive | `unordered_set` | start only when `x - 1` missing | O(n) average |
| Hash pair | custom hash | combine two ints into one hash | O(1) average per op |
| Compress coordinates | sorting + map/index | sorted unique ids | O(n log n) |
| Compare substrings | rolling hash | prefix hash and powers | O(n + q) |
| Reduce string collision | double hashing | store two mod hashes | O(n + q) |
| Avoid adversarial collisions | custom/universal-style hash | randomized mixing | O(1) expected |

Important edge cases:

* Empty array/string
* Single element
* Duplicates
* Negative values
* Large values and overflow
* Subarray starting at index `0`
* `k = 0`
* Pair requiring duplicate values
* Hash collision risk
* Unordered iteration order

Main interview template:

```cpp
unordered_map<long long, int> count;
count[0] = 1;

long long prefix = 0;
long long answer = 0;

for (int x : nums) {
    prefix += x;
    answer += count[prefix - k];
    count[prefix]++;
}
```

Main CP reminder:

```cpp
unordered_map<long long, int, CustomHash> mp;
unordered_set<long long, CustomHash> st;
```
