# Recursion and Backtracking

## 1. Overview

Recursion is a technique where a function solves a problem by calling itself on smaller versions of the same problem.

Backtracking is a recursion-based search technique where we build a solution step by step, and whenever the current path cannot lead to a valid answer, we undo the last choice and try another option.

This guide covers the recursion/backtracking family used heavily in placements, coding interviews, online assessments, and competitive programming:

| Topic | Main Use |
|---|---|
| Basic recursion | Break a problem into smaller identical subproblems |
| Recursion tree | Understand branching, calls, and complexity |
| Backtracking template | Try choices, undo choices, explore all valid answers |
| Subsets | Generate all possible selections |
| Permutations | Generate all orderings |
| Combinations | Choose `k` elements from `n` |
| N-Queens | Place queens safely on a chessboard |
| Sudoku solver | Fill a grid using constraints |
| Rat in a maze | Explore paths in a grid |
| Generate parentheses | Build valid bracket strings |
| Word search | DFS path search in a grid |
| Palindrome partitioning | Split string into palindrome pieces |
| Combination sum | Choose numbers to reach a target |
| Hamiltonian path basics | Visit every vertex exactly once |
| Meet-in-the-middle | Split exponential search into two halves |
| Branch and bound | Prune search using best-known bound |

In interviews, recursion and backtracking are not just about writing code. You must be able to explain:

* What state your recursive function represents
* What choices are available at each step
* What base case stops recursion
* What pruning avoids useless work
* Why the complexity is usually exponential

## 2. Intuition

### Simple explanation

Think of recursion as asking a smaller version of the same question.

Example:

```text
factorial(5) = 5 * factorial(4)
factorial(4) = 4 * factorial(3)
...
factorial(1) = 1
```

The function keeps reducing the problem until it reaches a simple answer.

Backtracking adds one more idea: try a choice, explore it, then undo it.

```text
Choose something
Explore future possibilities
Undo the choice
Try the next choice
```

### Analogy

Imagine walking through a maze.

1. You choose one path.
2. If it reaches the exit, great.
3. If it hits a dead end, you walk back to the previous junction.
4. Then you try another path.

That is backtracking.

### Step-by-step reasoning

For any recursion/backtracking problem, ask five questions:

| Question | Meaning |
|---|---|
| What is the state? | What information changes between recursive calls? |
| What is the choice? | What options can I try now? |
| What is the base case? | When is one answer complete or impossible? |
| What should I return/store? | One answer, count, maximum/minimum, or all answers? |
| What can I prune? | Which branches can be skipped early? |

### Why it works

Backtracking works because it explores the decision tree completely.

Each path from root to leaf represents one possible candidate solution. By checking constraints at every step, we avoid continuing invalid candidates. This gives correctness through exhaustive search and efficiency through pruning.

Example decision tree for subsets of `[1, 2, 3]`:

```text
                  []
            /            \
        take 1          skip 1
        [1]              []
      /     \          /     \
  [1,2]   [1]        [2]     []
```

Every element has two choices: take or skip.

## 3. When to Use It

Use recursion/backtracking when a problem asks you to:

* Generate all possible answers
* Count all possible valid arrangements
* Search through choices under constraints
* Find one valid configuration
* Try every ordering, selection, partition, or path
* Solve puzzles like Sudoku, N-Queens, maze, word search
* Explore all paths in a graph/grid
* Choose elements with include/exclude logic
* Optimize using exhaustive search with pruning

Common trigger phrases:

* "Generate all..."
* "Find all possible..."
* "Return all combinations..."
* "Return all permutations..."
* "Can you place..."
* "Find a path..."
* "All valid arrangements..."
* "Partition the string..."
* "Each element can be used once/multiple times..."
* "Try every possible..."
* "Subject to constraints..."
* "Minimum cost by trying choices..."

Topic-specific triggers:

| Trigger | Likely Pattern |
|---|---|
| "subsets", "power set" | Subsets |
| "arrangements", "reorder" | Permutations |
| "choose k" | Combinations |
| "place queens" | N-Queens |
| "fill 9x9 grid" | Sudoku solver |
| "maze paths" | Rat in a maze |
| "valid parentheses" | Generate parentheses |
| "word exists in grid" | Word search |
| "split into palindromes" | Palindrome partitioning |
| "sum to target" | Combination sum |
| "visit every vertex once" | Hamiltonian path |
| `n <= 40` with subset search | Meet-in-the-middle |
| "best possible bound" | Branch and bound |

## 4. When Not to Use It

Recursion/backtracking is not always the best tool.

Avoid it when:

* A direct formula exists.
* A greedy solution is provably enough.
* Dynamic programming can reuse many repeated states.
* Input size is too large for exponential search.
* You only need shortest path in an unweighted graph: use BFS.
* You only need connected components: use DFS/DSU.
* You only need sorting/order statistics: use sorting, heap, or binary search.
* The problem has optimal substructure and overlapping subproblems: use DP or memoization.

Common wrong assumptions:

| Wrong Assumption | Reality |
|---|---|
| "Recursion is always slow." | It is fine when the tree is small or pruned well. |
| "Backtracking means DFS only." | It is DFS over a decision space, not just a graph. |
| "If it asks all answers, DP is better." | DP may count answers, but backtracking generates actual answers. |
| "Pruning changes correctness." | Valid pruning removes only branches that cannot lead to a valid answer. |
| "Memoization always helps." | It helps only when states repeat. Many generation problems have unique states. |

Edge cases where it becomes inefficient:

* Permutations for `n > 10` are usually too many.
* Subsets for `n > 25` are usually too many unless optimized.
* Hamiltonian path is NP-complete; brute force fails for large `n`.
* Sudoku without good pruning may be very slow.
* Combination sum with many duplicates can generate repeated answers.

## 5. Core Concepts

### 5.1 Basic Recursion

Basic recursion has two parts:

* Base case: stops recursion.
* Recursive case: reduces the problem.

Example:

```text
sum(n) = n + sum(n - 1)
sum(0) = 0
```

Why it matters:

* Most DFS, tree, DP, and backtracking solutions are built on recursion.
* A missing base case causes infinite recursion.
* A wrong recursive transition gives wrong answers.

### 5.2 Call Stack

Each recursive call is stored on the call stack until it finishes.

Example:

```text
factorial(3)
  factorial(2)
    factorial(1)
```

When `factorial(1)` returns, calls start completing in reverse order.

Why it matters:

* Space complexity includes recursion depth.
* Deep recursion may cause stack overflow.
* In C++, recursion depth around `10^5` can be risky.

### 5.3 Recursion Tree

A recursion tree shows all function calls.

Example Fibonacci:

```text
fib(4)
├── fib(3)
│   ├── fib(2)
│   └── fib(1)
└── fib(2)
```

Why it matters:

* Helps estimate time complexity.
* Shows repeated subproblems.
* Helps decide whether memoization is needed.

### 5.4 Backtracking Template

The standard template:

```text
backtrack(state):
    if answer complete:
        store answer
        return

    for each choice:
        if choice is valid:
            make choice
            backtrack(new state)
            undo choice
```

Why it matters:

* Almost every placement backtracking problem fits this pattern.
* The `undo choice` step is the most common source of bugs.

### 5.5 State

State is the information needed to continue recursion.

Examples:

| Problem | State |
|---|---|
| Subsets | Current index, current subset |
| Permutations | Current path, used elements |
| N-Queens | Current row, occupied columns/diagonals |
| Sudoku | Current empty cell index, board |
| Word search | Cell position, word index, visited cells |

### 5.6 Choice

Choice means what you can try next.

Examples:

| Problem | Choices |
|---|---|
| Subsets | Include or exclude current element |
| Permutations | Pick any unused element |
| Combinations | Pick next number from remaining range |
| Sudoku | Place digit `1` to `9` |
| Maze | Move up/down/left/right |

### 5.7 Constraint

Constraint decides whether a choice is valid.

Examples:

* N-Queens: no same column or diagonal.
* Sudoku: no same digit in row, column, or box.
* Parentheses: closing count cannot exceed opening count.
* Word search: next cell must match next character.

### 5.8 Pruning

Pruning means skipping useless branches.

Examples:

* If current sum exceeds target, stop.
* If remaining elements are fewer than required, stop.
* If a Sudoku digit violates row/column/box, skip.
* In branch and bound, if current bound is worse than best answer, skip.

### 5.9 Subsets

Subsets generate every possible selection from an array.

For each element:

* Take it
* Skip it

Number of subsets: `2^n`.

Example:

```text
[1, 2] -> [], [1], [2], [1, 2]
```

### 5.10 Permutations

Permutations generate every ordering.

Number of permutations: `n!`.

Example:

```text
[1, 2, 3] -> [1,2,3], [1,3,2], [2,1,3], ...
```

### 5.11 Combinations

Combinations choose `k` elements from `n`, ignoring order.

Example:

```text
n = 4, k = 2
[1,2], [1,3], [1,4], [2,3], [2,4], [3,4]
```

### 5.12 N-Queens

Place `n` queens on an `n x n` board so no two queens attack each other.

Constraints:

* One queen per row
* No same column
* No same main diagonal
* No same anti-diagonal

Important formulas:

```text
main diagonal: row - col
anti diagonal: row + col
```

### 5.13 Sudoku Solver

Fill empty cells in a 9x9 grid so:

* Every row has digits `1` to `9`
* Every column has digits `1` to `9`
* Every 3x3 box has digits `1` to `9`

Backtracking tries valid digits for each empty cell.

### 5.14 Rat in a Maze

Find paths from source to destination in a grid.

Usually:

* `1` means open cell
* `0` means blocked cell
* Start: `(0, 0)`
* End: `(n - 1, n - 1)`

Backtracking explores valid moves and marks cells visited.

### 5.15 Generate Parentheses

Generate all valid strings with `n` pairs of parentheses.

Rules:

* Add `(` if open count `< n`
* Add `)` if close count `< open count`

### 5.16 Word Search

Given a grid of letters and a word, check if the word exists as a path.

Rules:

* Move up/down/left/right
* Cannot reuse a cell in the same path
* Characters must match in order

### 5.17 Palindrome Partitioning

Split a string so every part is a palindrome.

Example:

```text
"aab" -> ["a","a","b"], ["aa","b"]
```

At each index, try every palindromic prefix.

### 5.18 Combination Sum

Find combinations of numbers that sum to target.

Common versions:

| Version | Rule |
|---|---|
| Combination Sum I | Reuse same number allowed |
| Combination Sum II | Each number used once, duplicates handled |
| Combination Sum III | Choose `k` numbers from `1..9` |

### 5.19 Hamiltonian Path Basics

A Hamiltonian path visits every vertex exactly once.

Backtracking state:

* Current vertex
* Visited vertices
* Path length

It is exponential and generally used for small `n`.

### 5.20 Meet-in-the-Middle

Meet-in-the-middle reduces `2^n` search by splitting input into two halves.

Example:

```text
n = 40
2^40 is too large
2^20 + 2^20 is manageable
```

Used for subset sum, closest sum, count subsets, and XOR/path problems.

### 5.21 Branch and Bound

Branch and bound is backtracking with an optimization bound.

It keeps the best answer found so far and avoids branches that cannot beat it.

Examples:

* Traveling Salesman Problem
* Assignment problem
* 0/1 knapsack search
* Minimum cost path with constraints

## 6. Step-by-Step Algorithm

### 6.1 General Recursion Algorithm

1. Define the function meaning clearly.
2. Identify the smallest input that can be answered directly.
3. Write the base case.
4. Reduce the problem in the recursive case.
5. Combine recursive answers if needed.
6. Return the final answer.

### 6.2 General Backtracking Algorithm

1. Define the current state.
2. Check if the current state is a complete answer.
3. If complete, store or return it.
4. Generate possible choices.
5. For each choice, check if it is valid.
6. Make the choice.
7. Recurse to the next state.
8. Undo the choice.
9. Continue with the next choice.

### 6.3 Subsets

1. Start at index `0` with an empty subset.
2. For each index, choose to skip the element.
3. Recurse to the next index.
4. Choose to take the element.
5. Recurse to the next index.
6. When index reaches `n`, store the subset.

### 6.4 Permutations

1. Start with an empty path.
2. If path size is `n`, store it.
3. Try every unused element.
4. Mark it used.
5. Add it to path.
6. Recurse.
7. Remove it from path.
8. Mark it unused.

### 6.5 Combinations

1. Start from number `1`.
2. Add numbers in increasing order.
3. Stop when path size becomes `k`.
4. Store the combination.
5. Backtrack and try the next number.

### 6.6 N-Queens

1. Place queens row by row.
2. For current row, try every column.
3. Check whether column and diagonals are safe.
4. Place queen.
5. Recurse to next row.
6. Remove queen.
7. If row equals `n`, store the board.

### 6.7 Sudoku Solver

1. Find all empty cells.
2. Pick an empty cell.
3. Try digits `1` to `9`.
4. Check row, column, and 3x3 box constraints.
5. Place a valid digit.
6. Recurse to next empty cell.
7. If recursion succeeds, return true.
8. Otherwise undo and try another digit.

### 6.8 Rat in a Maze

1. Start at `(0, 0)`.
2. If cell is destination, store path.
3. Mark current cell visited.
4. Try all four directions.
5. Move only if inside grid, open, and unvisited.
6. Recurse.
7. Unmark current cell.

### 6.9 Generate Parentheses

1. Start with empty string.
2. Add `(` while open count is less than `n`.
3. Add `)` while close count is less than open count.
4. When string length becomes `2n`, store it.

### 6.10 Word Search

1. Try every cell as a starting point.
2. If cell matches first character, start DFS.
3. At every DFS call, match current character.
4. Mark cell visited.
5. Try four neighbors.
6. Unmark cell before returning.
7. If all characters matched, return true.

### 6.11 Palindrome Partitioning

1. Start at index `0`.
2. Try every substring starting at current index.
3. If substring is palindrome, add it to path.
4. Recurse from the next index.
5. Remove substring.
6. If index reaches end, store path.

### 6.12 Combination Sum

1. Sort candidates.
2. Start from index `0` and target.
3. Try each candidate from current index.
4. If candidate exceeds remaining target, break.
5. Add candidate.
6. Recurse with reduced target.
7. Reuse same index if repetition is allowed.
8. Use next index if each candidate can be used once.

### 6.13 Hamiltonian Path

1. Try each vertex as a starting vertex.
2. Mark it visited.
3. Add it to path.
4. If path length equals number of vertices, answer exists.
5. Try all unvisited neighbors.
6. Backtrack if no neighbor works.

### 6.14 Meet-in-the-Middle

1. Split the array into two halves.
2. Generate all subset sums of the left half.
3. Generate all subset sums of the right half.
4. Sort one side.
5. For each sum from the other side, binary search the best complement.
6. Combine answers.

### 6.15 Branch and Bound

1. Start with an initial best answer.
2. Explore choices recursively.
3. For each partial solution, compute a bound.
4. If bound cannot beat best answer, prune.
5. Otherwise continue search.
6. Update best answer when a complete solution is found.

## 7. Dry Run

### 7.1 Subsets Dry Run

Input:

```text
nums = [1, 2]
```

Initial state:

```text
index = 0
current = []
answer = []
```

| Step | Index | Choice | Current Subset | Action |
|---:|---:|---|---|---|
| 1 | 0 | skip 1 | `[]` | move to index 1 |
| 2 | 1 | skip 2 | `[]` | store `[]` |
| 3 | 1 | take 2 | `[2]` | store `[2]` |
| 4 | 0 | take 1 | `[1]` | move to index 1 |
| 5 | 1 | skip 2 | `[1]` | store `[1]` |
| 6 | 1 | take 2 | `[1,2]` | store `[1,2]` |

Final answer:

```text
[[], [2], [1], [1,2]]
```

Order may differ depending on whether you take first or skip first.

### 7.2 Generate Parentheses Dry Run

Input:

```text
n = 2
```

State:

```text
current string, open count, close count
```

| Step | Current | Open | Close | Valid Next Choices |
|---:|---|---:|---:|---|
| 1 | `""` | 0 | 0 | add `(` |
| 2 | `"("` | 1 | 0 | add `(` or `)` |
| 3 | `"(("` | 2 | 0 | add `)` |
| 4 | `"(()"` | 2 | 1 | add `)` |
| 5 | `"(())"` | 2 | 2 | store |
| 6 | `"()"` | 1 | 1 | add `(` |
| 7 | `"()("` | 2 | 1 | add `)` |
| 8 | `"()()"` | 2 | 2 | store |

Final answer:

```text
["(())", "()()"]
```

### 7.3 N-Queens Dry Run for `n = 4`

Try placing queens row by row.

| Row | Tried Column | Safe? | Reason |
|---:|---:|---|---|
| 0 | 0 | Yes | First queen |
| 1 | 0 | No | Same column |
| 1 | 1 | No | Same diagonal |
| 1 | 2 | Yes | Place queen |
| 2 | 0 | No | Same column as row 0 |
| 2 | 1 | No | Diagonal conflict |
| 2 | 2 | No | Same column |
| 2 | 3 | No | Diagonal conflict |
| 1 | 2 | Backtrack | No valid row 2 |
| 1 | 3 | Yes | Place queen |
| 2 | 1 | Yes | Place queen |
| 3 | 2 | No | Diagonal conflict |
| 3 | all | No | Backtrack |

Eventually valid board:

```text
.Q..
...Q
Q...
..Q.
```

Another valid board:

```text
..Q.
Q...
...Q
.Q..
```

## 8. C++ Implementation

The following C++17 file contains reusable implementations for the most common recursion and backtracking patterns.

```cpp
#include <bits/stdc++.h>
using namespace std;

// ------------------------------------------------------------
// 1. Basic recursion
// ------------------------------------------------------------

long long factorial(int n) {
    if (n <= 1) return 1;
    return 1LL * n * factorial(n - 1);
}

long long recursiveSum(int n) {
    if (n == 0) return 0;
    return n + recursiveSum(n - 1);
}

// ------------------------------------------------------------
// 2. Subsets
// ------------------------------------------------------------

void generateSubsetsHelper(int index, vector<int>& nums, vector<int>& current,
                           vector<vector<int>>& answer) {
    if (index == (int)nums.size()) {
        answer.push_back(current);
        return;
    }

    // Do not take nums[index]
    generateSubsetsHelper(index + 1, nums, current, answer);

    // Take nums[index]
    current.push_back(nums[index]);
    generateSubsetsHelper(index + 1, nums, current, answer);
    current.pop_back();
}

vector<vector<int>> generateSubsets(vector<int> nums) {
    vector<vector<int>> answer;
    vector<int> current;
    generateSubsetsHelper(0, nums, current, answer);
    return answer;
}

// Handles duplicate values in subsets.
void subsetsWithDupHelper(int start, vector<int>& nums, vector<int>& current,
                          vector<vector<int>>& answer) {
    answer.push_back(current);

    for (int i = start; i < (int)nums.size(); i++) {
        if (i > start && nums[i] == nums[i - 1]) continue;
        current.push_back(nums[i]);
        subsetsWithDupHelper(i + 1, nums, current, answer);
        current.pop_back();
    }
}

vector<vector<int>> subsetsWithDup(vector<int> nums) {
    sort(nums.begin(), nums.end());
    vector<vector<int>> answer;
    vector<int> current;
    subsetsWithDupHelper(0, nums, current, answer);
    return answer;
}

// ------------------------------------------------------------
// 3. Permutations
// ------------------------------------------------------------

void permutationsHelper(vector<int>& nums, vector<int>& current,
                        vector<int>& used, vector<vector<int>>& answer) {
    if ((int)current.size() == (int)nums.size()) {
        answer.push_back(current);
        return;
    }

    for (int i = 0; i < (int)nums.size(); i++) {
        if (used[i]) continue;

        used[i] = 1;
        current.push_back(nums[i]);

        permutationsHelper(nums, current, used, answer);

        current.pop_back();
        used[i] = 0;
    }
}

vector<vector<int>> permute(vector<int> nums) {
    vector<vector<int>> answer;
    vector<int> current;
    vector<int> used(nums.size(), 0);
    permutationsHelper(nums, current, used, answer);
    return answer;
}

// Handles duplicate values in permutations.
void uniquePermutationsHelper(vector<int>& nums, vector<int>& current,
                              vector<int>& used, vector<vector<int>>& answer) {
    if ((int)current.size() == (int)nums.size()) {
        answer.push_back(current);
        return;
    }

    for (int i = 0; i < (int)nums.size(); i++) {
        if (used[i]) continue;
        if (i > 0 && nums[i] == nums[i - 1] && !used[i - 1]) continue;

        used[i] = 1;
        current.push_back(nums[i]);
        uniquePermutationsHelper(nums, current, used, answer);
        current.pop_back();
        used[i] = 0;
    }
}

vector<vector<int>> permuteUnique(vector<int> nums) {
    sort(nums.begin(), nums.end());
    vector<vector<int>> answer;
    vector<int> current;
    vector<int> used(nums.size(), 0);
    uniquePermutationsHelper(nums, current, used, answer);
    return answer;
}

// ------------------------------------------------------------
// 4. Combinations
// ------------------------------------------------------------

void combineHelper(int start, int n, int k, vector<int>& current,
                   vector<vector<int>>& answer) {
    if ((int)current.size() == k) {
        answer.push_back(current);
        return;
    }

    int need = k - (int)current.size();
    for (int value = start; value <= n - need + 1; value++) {
        current.push_back(value);
        combineHelper(value + 1, n, k, current, answer);
        current.pop_back();
    }
}

vector<vector<int>> combine(int n, int k) {
    vector<vector<int>> answer;
    vector<int> current;
    combineHelper(1, n, k, current, answer);
    return answer;
}

// ------------------------------------------------------------
// 5. N-Queens
// ------------------------------------------------------------

void nQueensHelper(int row, int n, vector<string>& board,
                   vector<int>& columnUsed, vector<int>& mainDiagUsed,
                   vector<int>& antiDiagUsed, vector<vector<string>>& answer) {
    if (row == n) {
        answer.push_back(board);
        return;
    }

    for (int col = 0; col < n; col++) {
        int mainDiag = row - col + n - 1;
        int antiDiag = row + col;

        if (columnUsed[col] || mainDiagUsed[mainDiag] || antiDiagUsed[antiDiag]) {
            continue;
        }

        board[row][col] = 'Q';
        columnUsed[col] = 1;
        mainDiagUsed[mainDiag] = 1;
        antiDiagUsed[antiDiag] = 1;

        nQueensHelper(row + 1, n, board, columnUsed, mainDiagUsed, antiDiagUsed, answer);

        board[row][col] = '.';
        columnUsed[col] = 0;
        mainDiagUsed[mainDiag] = 0;
        antiDiagUsed[antiDiag] = 0;
    }
}

vector<vector<string>> solveNQueens(int n) {
    vector<vector<string>> answer;
    vector<string> board(n, string(n, '.'));
    vector<int> columnUsed(n, 0), mainDiagUsed(2 * n - 1, 0), antiDiagUsed(2 * n - 1, 0);
    nQueensHelper(0, n, board, columnUsed, mainDiagUsed, antiDiagUsed, answer);
    return answer;
}

// ------------------------------------------------------------
// 6. Sudoku solver
// ------------------------------------------------------------

bool isValidSudokuMove(vector<vector<char>>& board, int row, int col, char digit) {
    for (int i = 0; i < 9; i++) {
        if (board[row][i] == digit) return false;
        if (board[i][col] == digit) return false;

        int boxRow = 3 * (row / 3) + i / 3;
        int boxCol = 3 * (col / 3) + i % 3;
        if (board[boxRow][boxCol] == digit) return false;
    }
    return true;
}

bool solveSudokuHelper(vector<vector<char>>& board) {
    for (int row = 0; row < 9; row++) {
        for (int col = 0; col < 9; col++) {
            if (board[row][col] != '.') continue;

            for (char digit = '1'; digit <= '9'; digit++) {
                if (!isValidSudokuMove(board, row, col, digit)) continue;

                board[row][col] = digit;
                if (solveSudokuHelper(board)) return true;
                board[row][col] = '.';
            }
            return false;
        }
    }
    return true;
}

void solveSudoku(vector<vector<char>>& board) {
    solveSudokuHelper(board);
}

// ------------------------------------------------------------
// 7. Rat in a maze
// ------------------------------------------------------------

void mazeHelper(int row, int col, vector<vector<int>>& maze, vector<vector<int>>& visited,
                string& path, vector<string>& answer) {
    int n = maze.size();

    if (row == n - 1 && col == n - 1) {
        answer.push_back(path);
        return;
    }

    static int dr[] = {1, 0, 0, -1};
    static int dc[] = {0, -1, 1, 0};
    static char moveChar[] = {'D', 'L', 'R', 'U'};

    visited[row][col] = 1;

    for (int dir = 0; dir < 4; dir++) {
        int nextRow = row + dr[dir];
        int nextCol = col + dc[dir];

        bool inside = nextRow >= 0 && nextRow < n && nextCol >= 0 && nextCol < n;
        if (!inside || maze[nextRow][nextCol] == 0 || visited[nextRow][nextCol]) {
            continue;
        }

        path.push_back(moveChar[dir]);
        mazeHelper(nextRow, nextCol, maze, visited, path, answer);
        path.pop_back();
    }

    visited[row][col] = 0;
}

vector<string> findMazePaths(vector<vector<int>> maze) {
    int n = maze.size();
    vector<string> answer;
    if (n == 0 || maze[0][0] == 0 || maze[n - 1][n - 1] == 0) return answer;

    vector<vector<int>> visited(n, vector<int>(n, 0));
    string path;
    mazeHelper(0, 0, maze, visited, path, answer);
    return answer;
}

// ------------------------------------------------------------
// 8. Generate parentheses
// ------------------------------------------------------------

void parenthesesHelper(int n, int openCount, int closeCount, string& current,
                       vector<string>& answer) {
    if ((int)current.size() == 2 * n) {
        answer.push_back(current);
        return;
    }

    if (openCount < n) {
        current.push_back('(');
        parenthesesHelper(n, openCount + 1, closeCount, current, answer);
        current.pop_back();
    }

    if (closeCount < openCount) {
        current.push_back(')');
        parenthesesHelper(n, openCount, closeCount + 1, current, answer);
        current.pop_back();
    }
}

vector<string> generateParenthesis(int n) {
    vector<string> answer;
    string current;
    parenthesesHelper(n, 0, 0, current, answer);
    return answer;
}

// ------------------------------------------------------------
// 9. Word search
// ------------------------------------------------------------

bool wordSearchDfs(int row, int col, int index, vector<vector<char>>& board, string& word) {
    if (index == (int)word.size()) return true;

    int rows = board.size();
    int cols = board[0].size();
    bool outside = row < 0 || row >= rows || col < 0 || col >= cols;
    if (outside || board[row][col] != word[index]) return false;

    char saved = board[row][col];
    board[row][col] = '#';

    bool found = wordSearchDfs(row + 1, col, index + 1, board, word) ||
                 wordSearchDfs(row - 1, col, index + 1, board, word) ||
                 wordSearchDfs(row, col + 1, index + 1, board, word) ||
                 wordSearchDfs(row, col - 1, index + 1, board, word);

    board[row][col] = saved;
    return found;
}

bool exist(vector<vector<char>> board, string word) {
    int rows = board.size();
    int cols = board[0].size();

    for (int row = 0; row < rows; row++) {
        for (int col = 0; col < cols; col++) {
            if (wordSearchDfs(row, col, 0, board, word)) return true;
        }
    }
    return false;
}

// ------------------------------------------------------------
// 10. Palindrome partitioning
// ------------------------------------------------------------

bool isPalindrome(const string& s, int left, int right) {
    while (left < right) {
        if (s[left] != s[right]) return false;
        left++;
        right--;
    }
    return true;
}

void partitionHelper(int start, string& s, vector<string>& current,
                     vector<vector<string>>& answer) {
    if (start == (int)s.size()) {
        answer.push_back(current);
        return;
    }

    for (int end = start; end < (int)s.size(); end++) {
        if (!isPalindrome(s, start, end)) continue;

        current.push_back(s.substr(start, end - start + 1));
        partitionHelper(end + 1, s, current, answer);
        current.pop_back();
    }
}

vector<vector<string>> partition(string s) {
    vector<vector<string>> answer;
    vector<string> current;
    partitionHelper(0, s, current, answer);
    return answer;
}

// ------------------------------------------------------------
// 11. Combination sum
// ------------------------------------------------------------

void combinationSumHelper(int start, int remainingTarget, vector<int>& candidates,
                          vector<int>& current, vector<vector<int>>& answer) {
    if (remainingTarget == 0) {
        answer.push_back(current);
        return;
    }

    for (int i = start; i < (int)candidates.size(); i++) {
        if (candidates[i] > remainingTarget) break;

        current.push_back(candidates[i]);
        combinationSumHelper(i, remainingTarget - candidates[i], candidates, current, answer);
        current.pop_back();
    }
}

vector<vector<int>> combinationSum(vector<int> candidates, int target) {
    sort(candidates.begin(), candidates.end());
    vector<vector<int>> answer;
    vector<int> current;
    combinationSumHelper(0, target, candidates, current, answer);
    return answer;
}

// Each candidate can be used once, input may contain duplicates.
void combinationSum2Helper(int start, int remainingTarget, vector<int>& candidates,
                           vector<int>& current, vector<vector<int>>& answer) {
    if (remainingTarget == 0) {
        answer.push_back(current);
        return;
    }

    for (int i = start; i < (int)candidates.size(); i++) {
        if (i > start && candidates[i] == candidates[i - 1]) continue;
        if (candidates[i] > remainingTarget) break;

        current.push_back(candidates[i]);
        combinationSum2Helper(i + 1, remainingTarget - candidates[i], candidates, current, answer);
        current.pop_back();
    }
}

vector<vector<int>> combinationSum2(vector<int> candidates, int target) {
    sort(candidates.begin(), candidates.end());
    vector<vector<int>> answer;
    vector<int> current;
    combinationSum2Helper(0, target, candidates, current, answer);
    return answer;
}

// ------------------------------------------------------------
// 12. Hamiltonian path basics
// ------------------------------------------------------------

bool hamiltonianDfs(int node, vector<vector<int>>& graph, vector<int>& visited, int visitedCount) {
    int n = graph.size();
    if (visitedCount == n) return true;

    for (int next : graph[node]) {
        if (visited[next]) continue;

        visited[next] = 1;
        if (hamiltonianDfs(next, graph, visited, visitedCount + 1)) return true;
        visited[next] = 0;
    }

    return false;
}

bool hasHamiltonianPath(vector<vector<int>>& graph) {
    int n = graph.size();
    for (int start = 0; start < n; start++) {
        vector<int> visited(n, 0);
        visited[start] = 1;
        if (hamiltonianDfs(start, graph, visited, 1)) return true;
    }
    return false;
}

// ------------------------------------------------------------
// 13. Meet-in-the-middle subset sum: closest sum <= target
// ------------------------------------------------------------

void generateSubsetSums(int index, int end, long long sum, vector<int>& nums,
                        vector<long long>& sums) {
    if (index == end) {
        sums.push_back(sum);
        return;
    }

    generateSubsetSums(index + 1, end, sum, nums, sums);
    generateSubsetSums(index + 1, end, sum + nums[index], nums, sums);
}

long long maxSubsetSumAtMostTarget(vector<int> nums, long long target) {
    int n = nums.size();
    int mid = n / 2;

    vector<long long> leftSums, rightSums;
    generateSubsetSums(0, mid, 0, nums, leftSums);
    generateSubsetSums(mid, n, 0, nums, rightSums);

    sort(rightSums.begin(), rightSums.end());

    long long best = LLONG_MIN;
    for (long long left : leftSums) {
        if (left > target) continue;
        long long need = target - left;
        auto it = upper_bound(rightSums.begin(), rightSums.end(), need);
        if (it == rightSums.begin()) {
            best = max(best, left);
        } else {
            --it;
            best = max(best, left + *it);
        }
    }
    return best;
}

// ------------------------------------------------------------
// 14. Branch and bound example: 0/1 knapsack maximum value
// ------------------------------------------------------------

struct Item {
    int weight;
    int value;
};

double fractionalBound(int index, int currentWeight, int currentValue,
                       int capacity, vector<Item>& items) {
    if (currentWeight > capacity) return 0.0;

    double bound = currentValue;
    int totalWeight = currentWeight;

    for (int i = index; i < (int)items.size(); i++) {
        if (totalWeight + items[i].weight <= capacity) {
            totalWeight += items[i].weight;
            bound += items[i].value;
        } else {
            int remain = capacity - totalWeight;
            bound += 1.0 * items[i].value * remain / items[i].weight;
            break;
        }
    }

    return bound;
}

void knapsackBranchBoundDfs(int index, int currentWeight, int currentValue,
                            int capacity, vector<Item>& items, int& bestValue) {
    if (currentWeight > capacity) return;

    if (index == (int)items.size()) {
        bestValue = max(bestValue, currentValue);
        return;
    }

    double bound = fractionalBound(index, currentWeight, currentValue, capacity, items);
    if (bound <= bestValue) return;

    // Choose current item
    knapsackBranchBoundDfs(index + 1, currentWeight + items[index].weight,
                           currentValue + items[index].value, capacity, items, bestValue);

    // Skip current item
    knapsackBranchBoundDfs(index + 1, currentWeight, currentValue, capacity, items, bestValue);
}

int knapsackBranchAndBound(vector<Item> items, int capacity) {
    sort(items.begin(), items.end(), [](const Item& a, const Item& b) {
        return 1.0 * a.value / a.weight > 1.0 * b.value / b.weight;
    });

    int bestValue = 0;
    knapsackBranchBoundDfs(0, 0, 0, capacity, items, bestValue);
    return bestValue;
}

// ------------------------------------------------------------
// Example usage
// ------------------------------------------------------------

int main() {
    vector<int> nums = {1, 2, 3};

    auto subsets = generateSubsets(nums);
    cout << "Subsets count: " << subsets.size() << '\n';

    auto permutations = permute(nums);
    cout << "Permutations count: " << permutations.size() << '\n';

    auto queens = solveNQueens(4);
    cout << "N-Queens solutions for n=4: " << queens.size() << '\n';

    auto parentheses = generateParenthesis(3);
    cout << "Valid parentheses strings for n=3: " << parentheses.size() << '\n';

    vector<int> candidates = {2, 3, 6, 7};
    auto sums = combinationSum(candidates, 7);
    cout << "Combination sum answers: " << sums.size() << '\n';

    return 0;
}
```

Sample output:

```text
Subsets count: 8
Permutations count: 6
N-Queens solutions for n=4: 2
Valid parentheses strings for n=3: 5
Combination sum answers: 2
```

## pYTHON IMPLEMENTATION

pROVIDE CLEAN PYTHON CODE

```python
from typing import List


def generate_subsets(nums: List[int]) -> List[List[int]]:
    answer = []
    current = []

    def backtrack(index: int) -> None:
        if index == len(nums):
            answer.append(current.copy())
            return

        backtrack(index + 1)

        current.append(nums[index])
        backtrack(index + 1)
        current.pop()

    backtrack(0)
    return answer


def permute(nums: List[int]) -> List[List[int]]:
    answer = []
    current = []
    used = [False] * len(nums)

    def backtrack() -> None:
        if len(current) == len(nums):
            answer.append(current.copy())
            return

        for i in range(len(nums)):
            if used[i]:
                continue

            used[i] = True
            current.append(nums[i])
            backtrack()
            current.pop()
            used[i] = False

    backtrack()
    return answer


def combine(n: int, k: int) -> List[List[int]]:
    answer = []
    current = []

    def backtrack(start: int) -> None:
        if len(current) == k:
            answer.append(current.copy())
            return

        need = k - len(current)
        for value in range(start, n - need + 2):
            current.append(value)
            backtrack(value + 1)
            current.pop()

    backtrack(1)
    return answer


def solve_n_queens(n: int) -> List[List[str]]:
    answer = []
    board = [["."] * n for _ in range(n)]
    columns = set()
    main_diagonals = set()
    anti_diagonals = set()

    def backtrack(row: int) -> None:
        if row == n:
            answer.append(["".join(r) for r in board])
            return

        for col in range(n):
            main_diag = row - col
            anti_diag = row + col

            if col in columns or main_diag in main_diagonals or anti_diag in anti_diagonals:
                continue

            board[row][col] = "Q"
            columns.add(col)
            main_diagonals.add(main_diag)
            anti_diagonals.add(anti_diag)

            backtrack(row + 1)

            board[row][col] = "."
            columns.remove(col)
            main_diagonals.remove(main_diag)
            anti_diagonals.remove(anti_diag)

    backtrack(0)
    return answer


def solve_sudoku(board: List[List[str]]) -> None:
    def valid(row: int, col: int, digit: str) -> bool:
        for i in range(9):
            if board[row][i] == digit:
                return False
            if board[i][col] == digit:
                return False

            box_row = 3 * (row // 3) + i // 3
            box_col = 3 * (col // 3) + i % 3
            if board[box_row][box_col] == digit:
                return False

        return True

    def backtrack() -> bool:
        for row in range(9):
            for col in range(9):
                if board[row][col] != ".":
                    continue

                for digit in "123456789":
                    if not valid(row, col, digit):
                        continue

                    board[row][col] = digit
                    if backtrack():
                        return True
                    board[row][col] = "."

                return False

        return True

    backtrack()


def find_maze_paths(maze: List[List[int]]) -> List[str]:
    n = len(maze)
    answer = []
    if n == 0 or maze[0][0] == 0 or maze[n - 1][n - 1] == 0:
        return answer

    visited = [[False] * n for _ in range(n)]
    directions = [(1, 0, "D"), (0, -1, "L"), (0, 1, "R"), (-1, 0, "U")]

    def backtrack(row: int, col: int, path: List[str]) -> None:
        if row == n - 1 and col == n - 1:
            answer.append("".join(path))
            return

        visited[row][col] = True

        for dr, dc, move in directions:
            nr, nc = row + dr, col + dc
            inside = 0 <= nr < n and 0 <= nc < n
            if inside and maze[nr][nc] == 1 and not visited[nr][nc]:
                path.append(move)
                backtrack(nr, nc, path)
                path.pop()

        visited[row][col] = False

    backtrack(0, 0, [])
    return answer


def generate_parenthesis(n: int) -> List[str]:
    answer = []

    def backtrack(current: List[str], open_count: int, close_count: int) -> None:
        if len(current) == 2 * n:
            answer.append("".join(current))
            return

        if open_count < n:
            current.append("(")
            backtrack(current, open_count + 1, close_count)
            current.pop()

        if close_count < open_count:
            current.append(")")
            backtrack(current, open_count, close_count + 1)
            current.pop()

    backtrack([], 0, 0)
    return answer


def exist(board: List[List[str]], word: str) -> bool:
    rows, cols = len(board), len(board[0])

    def dfs(row: int, col: int, index: int) -> bool:
        if index == len(word):
            return True

        outside = row < 0 or row >= rows or col < 0 or col >= cols
        if outside or board[row][col] != word[index]:
            return False

        saved = board[row][col]
        board[row][col] = "#"

        found = (
            dfs(row + 1, col, index + 1)
            or dfs(row - 1, col, index + 1)
            or dfs(row, col + 1, index + 1)
            or dfs(row, col - 1, index + 1)
        )

        board[row][col] = saved
        return found

    for row in range(rows):
        for col in range(cols):
            if dfs(row, col, 0):
                return True

    return False


def palindrome_partition(s: str) -> List[List[str]]:
    answer = []
    current = []

    def is_palindrome(left: int, right: int) -> bool:
        while left < right:
            if s[left] != s[right]:
                return False
            left += 1
            right -= 1
        return True

    def backtrack(start: int) -> None:
        if start == len(s):
            answer.append(current.copy())
            return

        for end in range(start, len(s)):
            if not is_palindrome(start, end):
                continue

            current.append(s[start : end + 1])
            backtrack(end + 1)
            current.pop()

    backtrack(0)
    return answer


def combination_sum(candidates: List[int], target: int) -> List[List[int]]:
    candidates.sort()
    answer = []
    current = []

    def backtrack(start: int, remaining: int) -> None:
        if remaining == 0:
            answer.append(current.copy())
            return

        for i in range(start, len(candidates)):
            if candidates[i] > remaining:
                break

            current.append(candidates[i])
            backtrack(i, remaining - candidates[i])
            current.pop()

    backtrack(0, target)
    return answer


def has_hamiltonian_path(graph: List[List[int]]) -> bool:
    n = len(graph)

    def dfs(node: int, visited: List[bool], count: int) -> bool:
        if count == n:
            return True

        for nxt in graph[node]:
            if visited[nxt]:
                continue

            visited[nxt] = True
            if dfs(nxt, visited, count + 1):
                return True
            visited[nxt] = False

        return False

    for start in range(n):
        visited = [False] * n
        visited[start] = True
        if dfs(start, visited, 1):
            return True

    return False


def max_subset_sum_at_most_target(nums: List[int], target: int) -> int:
    from bisect import bisect_right

    mid = len(nums) // 2

    def subset_sums(arr: List[int]) -> List[int]:
        sums = []

        def dfs(index: int, total: int) -> None:
            if index == len(arr):
                sums.append(total)
                return
            dfs(index + 1, total)
            dfs(index + 1, total + arr[index])

        dfs(0, 0)
        return sums

    left_sums = subset_sums(nums[:mid])
    right_sums = sorted(subset_sums(nums[mid:]))

    best = -10**30
    for left in left_sums:
        if left > target:
            continue
        pos = bisect_right(right_sums, target - left) - 1
        if pos >= 0:
            best = max(best, left + right_sums[pos])

    return best


if __name__ == "__main__":
    print("Subsets:", generate_subsets([1, 2, 3]))
    print("Permutations:", permute([1, 2, 3]))
    print("Combinations:", combine(4, 2))
    print("N-Queens count:", len(solve_n_queens(4)))
    print("Parentheses:", generate_parenthesis(3))
    print("Combination sum:", combination_sum([2, 3, 6, 7], 7))
```

## 10. Code Explanation

### Basic recursion

`factorial` and `recursiveSum` show the simplest recursion structure:

* The base case returns immediately.
* The recursive case reduces `n` by `1`.
* The answer is built while calls return.

### Subsets

Important blocks:

```cpp
generateSubsetsHelper(index + 1, nums, current, answer);
current.push_back(nums[index]);
generateSubsetsHelper(index + 1, nums, current, answer);
current.pop_back();
```

Meaning:

* First recursive call skips the current value.
* Then we add the current value.
* Second recursive call includes it.
* `pop_back()` restores the state.

For duplicates:

```cpp
if (i > start && nums[i] == nums[i - 1]) continue;
```

This skips repeated choices at the same recursion level.

### Permutations

Important state:

* `current`: the current ordering.
* `used[i]`: whether `nums[i]` is already in the permutation.

The code tries every unused value at every position.

For duplicate values:

```cpp
if (i > 0 && nums[i] == nums[i - 1] && !used[i - 1]) continue;
```

This prevents generating the same arrangement multiple times.

### Combinations

The function uses increasing values:

```cpp
combineHelper(value + 1, n, k, current, answer);
```

This prevents duplicate combinations like `[1,2]` and `[2,1]`.

The pruning:

```cpp
int need = k - current.size();
value <= n - need + 1
```

avoids loops where not enough numbers remain.

### N-Queens

The board stores the visible answer.

The helper arrays store constraints:

* `columnUsed[col]`
* `mainDiagUsed[row - col + n - 1]`
* `antiDiagUsed[row + col]`

The offset `+ n - 1` converts negative diagonal IDs into non-negative indexes.

### Sudoku

`isValidSudokuMove` checks:

* Same row
* Same column
* Same 3x3 box

This formula maps `i` from `0..8` to all cells of the 3x3 box:

```cpp
int boxRow = 3 * (row / 3) + i / 3;
int boxCol = 3 * (col / 3) + i % 3;
```

The recursive solver returns `true` as soon as one complete solution is found.

### Rat in a Maze

The path is stored as a string of moves:

* `D`: down
* `L`: left
* `R`: right
* `U`: up

Visited cells prevent cycles. The cell is unmarked after exploring all paths through it.

### Generate Parentheses

The two constraints are:

```cpp
openCount < n
closeCount < openCount
```

These guarantee:

* We never use more than `n` opening brackets.
* We never place a closing bracket before a matching opening bracket exists.

### Word Search

The code temporarily changes the board cell to `'#'` to mark it visited.

```cpp
char saved = board[row][col];
board[row][col] = '#';
...
board[row][col] = saved;
```

This avoids a separate visited matrix.

### Palindrome Partitioning

At every starting index, the code tries all possible ending indexes.

Only palindromic substrings are added to the path.

### Combination Sum

For Combination Sum I:

```cpp
combinationSumHelper(i, remainingTarget - candidates[i], ...)
```

uses `i` again, so the same candidate can be reused.

For Combination Sum II:

```cpp
combinationSum2Helper(i + 1, ...)
```

moves forward, so every candidate index is used at most once.

### Hamiltonian Path

The function starts DFS from every vertex because a Hamiltonian path can begin anywhere.

`visitedCount == n` means all vertices have been included exactly once.

### Meet-in-the-Middle

The code generates subset sums for both halves.

Then it sorts one side and uses `upper_bound` to find the best complement.

This changes the shape from:

```text
2^n
```

to:

```text
2^(n/2) log 2^(n/2)
```

### Branch and Bound

The knapsack example sorts items by value/weight ratio and computes a fractional upper bound.

If the optimistic bound is not better than the current best value, the branch is skipped.

This does not change worst-case exponential complexity, but it can be dramatically faster in practice.

## 11. Complexity Analysis

| Topic | Time Complexity | Space Complexity | Notes |
|---|---:|---:|---|
| Basic recursion factorial/sum | `O(n)` | `O(n)` | Stack depth is `n` |
| Recursion tree for Fibonacci without memo | `O(2^n)` | `O(n)` | Repeated subproblems |
| Subsets | `O(n * 2^n)` | `O(n * 2^n)` | Output itself has `2^n` subsets |
| Permutations | `O(n * n!)` | `O(n * n!)` | Output has `n!` permutations |
| Combinations | `O(k * C(n,k))` | `O(k * C(n,k))` | Output-sensitive |
| N-Queens | `O(n!)` approx | `O(n^2)` output excluded | Pruning reduces practical search |
| Sudoku solver | `O(9^e)` | `O(e)` | `e` = number of empty cells |
| Rat in a maze | `O(4^(n^2))` worst | `O(n^2)` | Usually less due to visited/pruning |
| Generate parentheses | `O(C_n * n)` | `O(C_n * n)` | `C_n` is nth Catalan number |
| Word search | `O(rows * cols * 4^L)` | `O(L)` | `L` = word length |
| Palindrome partitioning | `O(n * 2^n)` | `O(n * 2^n)` | Can optimize palindrome checks with DP |
| Combination sum | Exponential | Exponential output | Depends on target and candidates |
| Hamiltonian path | `O(n!)` | `O(n)` | NP-complete problem |
| Meet-in-the-middle subset sum | `O(2^(n/2) log 2^(n/2))` | `O(2^(n/2))` | Useful around `n <= 40` |
| Branch and bound | Exponential worst case | `O(n)` recursion | Faster with strong bounds |

More detail:

| Operation Type | Complexity Meaning |
|---|---|
| Preprocessing | Sorting candidates, building helper arrays, palindrome DP |
| Query | Usually one full search |
| Update | Usually make choice and undo choice in `O(1)` or `O(length)` |
| Overall | Search tree size multiplied by cost per node |

## 12. Common Patterns

| Pattern Name | How to Identify It | General Approach | Example Problems |
|---|---|---|---|
| Include/Exclude | Each element can be chosen or skipped | Recurse with index + take/skip | Subsets, subset sum |
| Pick Unused | Need all orderings | Track `used[]` | Permutations, arrange numbers |
| Choose K | Select exactly `k` items | Increasing start index | Combinations, k-combinations |
| Grid DFS | Move in 2D grid | Boundary check + visited | Rat in a maze, Word search |
| Constraint Placement | Place items safely | Track constraints with sets/arrays | N-Queens, Sudoku |
| Prefix Construction | Build string one char at a time | Add valid next characters | Generate parentheses |
| Partitioning | Split string/array into valid parts | Try every end index | Palindrome partitioning |
| Sum Search | Build combination to target | Sort + prune if sum too large | Combination Sum |
| Visit All Nodes | Need path through every vertex | DFS with visited count | Hamiltonian path |
| Split Search | `n` too large for `2^n`, but halves are okay | Meet-in-the-middle | Subset sum `n <= 40` |
| Optimization Search | Need best answer under constraints | Branch and bound | TSP, knapsack, assignment |

Example platforms:

* LeetCode: Subsets, Permutations, N-Queens, Sudoku Solver
* GFG: Rat in a Maze, Hamiltonian Path
* CSES: Creating Strings, Chessboard and Queens
* Codeforces: Meet-in-the-middle subset problems
* AtCoder: ABC/ARC subset enumeration and bitmask search

## 13. Common Mistakes

| Mistake | Why It Hurts | Fix |
|---|---|---|
| Missing base case | Infinite recursion | Always write base case first |
| Wrong base case order | Access out of bounds | Check completion before indexing |
| Forgetting to undo choice | Corrupts later branches | Always pair `push` with `pop` |
| Reusing visited incorrectly | Blocks valid paths or creates cycles | Mark before DFS, unmark after DFS |
| Not handling duplicates | Duplicate answers | Sort and skip same-level duplicates |
| Wrong diagonal formula in N-Queens | Allows attacking queens | Use `row - col + n - 1` and `row + col` |
| Closing parenthesis too early | Invalid strings | Require `closeCount < openCount` |
| Combination duplicates | `[2,3]` and `[3,2]` both appear | Use increasing start index |
| Using recursion for huge depth | Stack overflow | Use iterative DFS or increase stack only if allowed |
| Misunderstanding complexity | TLE in OA/CP | Estimate search tree before coding |
| Passing large objects by value | Slow copies | Pass by reference and backtrack |
| Wrong boundary condition in grid | Runtime error | Check row/col before using board cell |
| Integer overflow | Wrong sums/counts | Use `long long` for sums/counts |
| Bad pruning | Removes valid answers | Prune only when logically guaranteed |

## 14. Edge Cases

| Topic | Edge Cases to Test |
|---|---|
| Basic recursion | `n = 0`, `n = 1`, large `n`, negative input if allowed |
| Subsets | Empty array, single element, duplicate values, all equal values |
| Permutations | Empty array, one element, duplicate values |
| Combinations | `k = 0`, `k = n`, `k > n`, `n = 0` |
| N-Queens | `n = 1`, `n = 2`, `n = 3`, `n = 4` |
| Sudoku | Already solved board, invalid board, board with one empty cell |
| Rat in a maze | Start blocked, end blocked, no path, 1x1 grid, cycles |
| Generate parentheses | `n = 0`, `n = 1`, larger `n` like `8` |
| Word search | Empty word if allowed, one-cell board, repeated letters, word longer than cells |
| Palindrome partitioning | Empty string, one char, all same chars, no long palindrome |
| Combination sum | Target `0`, candidate greater than target, duplicates, no solution |
| Hamiltonian path | Single vertex, disconnected graph, complete graph, cycle graph |
| Meet-in-the-middle | Negative numbers, target smaller than all values, `n = 0`, large sums |
| Branch and bound | Zero capacity, all items overweight, equal value/weight ratios |

## 15. Variations

| Variation | What Changes | When Used | Importance |
|---|---|---|---|
| Recursion with memoization | Store repeated states | Fibonacci, DP-like recursion | Very important |
| Tail recursion | Recursive call is last operation | Functional style, simple loops | Low for C++ interviews |
| Iterative DFS | Manual stack instead of recursion | Very deep recursion | Medium |
| Subsets with duplicates | Sort and skip duplicates | Input has repeated values | Very important |
| Bitmask subsets | Use integers from `0` to `2^n - 1` | Small `n`, faster implementation | Very important in CP |
| Next permutation | Generate permutations lexicographically | Need one next ordering | Medium |
| Permutations with duplicates | Sort + used skip condition | Repeated values | Very important |
| Combination Sum I | Reuse numbers | Unlimited copies allowed | Very important |
| Combination Sum II | Use each index once | Duplicates in candidates | Very important |
| Combination Sum III | Choose `k` from `1..9` | Fixed small domain | Medium |
| Optimized Sudoku | Use bitmasks for row/col/box | Faster solver | Medium to high |
| N-Queens count only | Store count instead of boards | Ask number of solutions | Medium |
| Word search trie | Search many words at once | Word Search II | High |
| Palindrome DP precompute | `isPal[i][j]` table | Faster partitioning | Medium |
| Meet-in-the-middle count | Count pairs with binary search | Count subsets under limit | High in CP |
| Branch and bound with priority queue | Best-first search | TSP/assignment | Medium |

## 16. Related Algorithms/Data Structures

| Related Topic | Connection | How to Choose |
|---|---|---|
| DFS | Backtracking is DFS over choices | Use DFS for graph traversal, backtracking for solution generation |
| BFS | Explores level by level | Use BFS for shortest path in unweighted graph |
| Dynamic Programming | Recursion with cached repeated states | Use DP when states repeat and you need count/min/max |
| Bitmasking | Compact representation of chosen items | Use for subsets/permutations when `n <= 20` |
| Trie | Prefix tree for words | Use with backtracking for multiple word search |
| Graph algorithms | Hamiltonian path is graph search | Use DFS/backtracking for small exhaustive graph problems |
| Greedy | Makes locally best choice | Use only when proof exists |
| Branch and Bound vs Backtracking | B&B is optimized backtracking | Use B&B when searching for best objective |
| Meet-in-the-middle vs DP | MITM splits exponential search | Use MITM when values are large but `n` is around 30-45 |
| Stack | Simulates recursion | Use when recursion depth is too large |

Examples:

* DFS vs DSU: DFS explores paths/components; DSU answers connectivity under unions.
* BFS vs Dijkstra: BFS for unit weights; Dijkstra for positive weighted edges.
* Backtracking vs DP: backtracking generates all answers; DP usually counts or optimizes.
* Bitmask DP vs Backtracking: bitmask DP is better when states repeat across paths.

## 17. Practice Problems

### Easy

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Subsets | LeetCode | Include/exclude recursion | Easy-Medium |
| Generate Parentheses | LeetCode | Prefix construction with valid counts | Medium but beginner-friendly |

### Medium

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Permutations | LeetCode | Pick unused element | Medium |
| Combination Sum | LeetCode | Target-based backtracking | Medium |
| Rat in a Maze | GFG | Grid DFS with visited | Medium |

### Hard

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| N-Queens | LeetCode | Constraint placement | Hard |
| Sudoku Solver | LeetCode | Constraint satisfaction | Hard |
| Hamiltonian Path | GFG | Visit every vertex once | Hard |
| Meet in the Middle | Codeforces/CSES style | Split subset enumeration | Hard |
| Word Search II | LeetCode | Trie + backtracking | Hard |

Additional recommended practice:

| Problem | Platform | Pattern |
|---|---|---|
| Palindrome Partitioning | LeetCode | Partitioning |
| Combinations | LeetCode | Choose `k` |
| Combination Sum II | LeetCode | Duplicate handling |
| Letter Combinations of a Phone Number | LeetCode | String backtracking |
| Chessboard and Queens | CSES | N-Queens with blocked cells |
| Creating Strings | CSES | Unique permutations |
| Meet in the Middle | CSES | Subset sums |

## 18. Interview Explanation

Recursion solves a problem by reducing it into smaller versions of the same problem until a base case is reached. Backtracking is a recursive technique where I build a candidate solution step by step, try every valid choice, and undo the choice before trying the next one. I use it when the problem asks for all configurations, paths, combinations, permutations, or constraint-based placements. The key is to define the state, choices, base case, validity check, and pruning. The time complexity is usually exponential because the algorithm explores a decision tree, but pruning and constraints reduce the practical search space.

## 19. Revision Notes

* Recursion needs a base case and a smaller recursive call.
* Backtracking means make choice, recurse, undo choice.
* Always define state before coding.
* For subsets, each element has two choices: take or skip.
* For permutations, track used elements.
* For combinations, move forward with a `start` index.
* For duplicates, sort first and skip same-level repeated choices.
* For N-Queens, track columns and two diagonals.
* For Sudoku, check row, column, and 3x3 box.
* For grid problems, check boundary, blocked cells, and visited cells.
* For parentheses, only add `)` when `close < open`.
* For combination sum, sort and stop when candidate exceeds target.
* For Hamiltonian path, DFS with visited count.
* For meet-in-the-middle, split into halves and combine with binary search.
* For branch and bound, prune if optimistic bound cannot beat best answer.
* Common complexity: subsets `O(2^n)`, permutations `O(n!)`, combinations `O(C(n,k))`.
* Common trap: forgetting `pop_back()` or unmarking visited.

## 20. Final Cheat Sheet

| Item | Cheat Sheet |
|---|---|
| When to use | Generate/search all combinations, permutations, paths, partitions, placements |
| Core template | Check base case, loop choices, validate, make choice, recurse, undo |
| Main operations | `push`, mark visited, recurse, `pop`, unmark visited |
| Subsets | Take/skip each element, `2^n` |
| Permutations | Pick unused element, `n!` |
| Combinations | Increasing `start`, `C(n,k)` |
| N-Queens | Row by row, track column and diagonals |
| Sudoku | Empty cell by empty cell, try digits `1..9` |
| Maze/Word Search | DFS in four directions with visited |
| Parentheses | Add `(` if open `< n`; add `)` if close `< open` |
| Palindrome partition | Try every palindromic substring from current index |
| Combination sum | Sort, choose candidate, reduce target, prune if too large |
| Hamiltonian path | DFS from each start, visit all vertices exactly once |
| Meet-in-the-middle | Generate subset sums of two halves, sort and binary search |
| Branch and bound | Keep best answer, prune branches with weak bounds |
| Complexity | Usually exponential; output size often dominates |
| Important edge cases | Empty input, duplicates, blocked start/end, no solution, single element, large target/sum |
| Interview line | "I model this as a decision tree and use backtracking to explore valid branches while undoing state after each recursive call." |

