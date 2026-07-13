# Stack

## 1. Overview

A stack is a linear data structure that follows **LIFO: Last In, First Out**.

The last element inserted is the first element removed, just like a stack of plates.

In coding interviews and competitive programming, stacks are used for:

* Reversing order
* Matching pairs
* Keeping pending elements
* Solving nearest greater/smaller problems
* Handling nested structures
* Maintaining monotonic order
* Evaluating expressions

This guide covers both the basic stack data structure and the most important stack-based algorithms:

* Basic stack operations
* Balanced parentheses
* Next greater element
* Previous greater element
* Next smaller element
* Previous smaller element
* Monotonic stack
* Min stack
* Evaluate postfix/prefix expression
* Largest rectangle in histogram
* Maximal rectangle
* Stock span
* Asteroid collision
* Decode string
* Remove duplicate letters

## 2. Intuition

A stack helps when the most recent unresolved item should be handled first.

Simple analogy:

* You place books one by one on a table.
* The newest book is on top.
* If you remove a book, you remove the top one first.

That is exactly how a stack works.

Core idea:

1. Push items when they are waiting to be processed.
2. Pop items when the current item resolves them.
3. Peek at the top when only the latest unresolved item matters.

Why it works:

Many problems have a natural "last opened, first closed" or "nearest unresolved element" behavior.

Examples:

* In parentheses, the latest opening bracket must close first.
* In a histogram, a bar remains useful until a smaller bar appears.
* In asteroid collision, the latest right-moving asteroid is the first one hit by a left-moving asteroid.
* In decoding strings like `3[a2[c]]`, the innermost expression must be decoded first.

## 3. When to Use It

Use stack when the problem contains these signals:

* "Last opened must close first"
* "Nested expression"
* "Undo previous operation"
* "Nearest greater element"
* "Nearest smaller element"
* "Next greater element"
* "Previous greater element"
* "Next smaller element"
* "Previous smaller element"
* "Span"
* "Histogram rectangle"
* "Remove elements while condition is true"
* "Maintain increasing/decreasing order"
* "Expression evaluation"
* "Decode nested string"
* "Collision with previous active objects"

Common problem types:

* Parentheses validation
* Monotonic stack problems
* Expression parsing
* Stock span
* Histogram area
* String cleanup
* Simulation problems where only recent active items matter

## 4. When Not to Use It

A stack is not suitable when:

* You need random access to all elements.
* You need the smallest/largest element globally with frequent updates. Use heap, multiset, or segment tree.
* You need FIFO order. Use queue.
* You need range queries. Use prefix sums, Fenwick tree, or segment tree.
* You need to search arbitrary elements quickly. Use hash map or balanced BST.
* The problem needs full graph traversal. Use DFS/BFS, not just stack as a data structure.

Overkill cases:

* Reversing a simple string can be done with two pointers or built-in reverse.
* Checking only count of one bracket type may not require stack if there are no bracket types and no ordering issues.

Common wrong assumptions:

* Stack does not automatically give sorted order.
* Stack top is not always the answer; sometimes stack stores indices, not values.
* Monotonic stack is not a data structure with dynamic queries; it is usually a one-pass technique.

## 5. Core Concepts

### LIFO Order

The last pushed element is removed first.

Why it matters:

Nested and recent-pair problems naturally follow this order.

Example:

```text
push 10
push 20
pop -> 20
pop -> 10
```

### Stack Operations

| Operation | Meaning | C++ STL | Complexity |
|---|---|---|---|
| Push | Insert at top | `push()` | O(1) |
| Pop | Remove top | `pop()` | O(1) |
| Top | Read top | `top()` | O(1) |
| Empty | Check if empty | `empty()` | O(1) |
| Size | Count elements | `size()` | O(1) |

### Storing Values vs Indices

In many array problems, store indices instead of values.

Why indices matter:

* You can calculate distance.
* You can access original value.
* You can fill answer at the correct position.

Example:

For stock span, store indices because span is `currentIndex - previousGreaterIndex`.

### Monotonic Stack

A monotonic stack keeps elements in increasing or decreasing order.

It is used for nearest greater/smaller element problems.

Types:

| Type | Stack order | Useful for |
|---|---|---|
| Increasing stack | Small to large | Next smaller, previous smaller |
| Decreasing stack | Large to small | Next greater, previous greater |

### Sentinel Values

Sentinels help handle empty stack or boundary cases.

Examples:

* Previous greater missing -> `-1`
* Next greater missing -> `-1`
* Histogram right boundary -> `n`
* Histogram left boundary -> `-1`

### Stack as Simulation

Some problems simulate real behavior using stack.

Examples:

* Asteroid collision
* Backspace string compare
* Remove adjacent duplicates

The stack stores active elements that have not been removed yet.

## 6. Step-by-Step Algorithm

Because stack has many important applications, here are the main algorithms.

### A. Basic Stack Operations

1. Create an empty stack.
2. Push elements using `push`.
3. Read top using `top`.
4. Remove top using `pop`.
5. Always check `empty` before calling `top` or `pop`.

### B. Balanced Parentheses

1. Traverse each character.
2. If it is an opening bracket, push it.
3. If it is a closing bracket:
   * If stack is empty, return false.
   * If top does not match, return false.
   * Otherwise pop top.
4. At the end, return true only if stack is empty.

### C. Next Greater Element

1. Traverse array from right to left.
2. Maintain a decreasing stack.
3. While stack top is less than or equal to current element, pop.
4. If stack is empty, answer is `-1`.
5. Otherwise answer is stack top.
6. Push current element.

### D. Previous Greater Element

1. Traverse array from left to right.
2. Maintain a decreasing stack.
3. Pop while stack top is less than or equal to current.
4. Top is previous greater if stack is not empty.
5. Push current element.

### E. Next Smaller Element

1. Traverse from right to left.
2. Maintain an increasing stack.
3. Pop while stack top is greater than or equal to current.
4. Top is next smaller if stack is not empty.
5. Push current element.

### F. Previous Smaller Element

1. Traverse from left to right.
2. Maintain an increasing stack.
3. Pop while stack top is greater than or equal to current.
4. Top is previous smaller if stack is not empty.
5. Push current element.

### G. Min Stack

1. Use one normal stack for values.
2. Use another stack for current minimum values.
3. On push, also push `min(x, currentMin)` into min stack.
4. On pop, pop from both stacks.
5. Current minimum is top of min stack.

### H. Postfix Expression Evaluation

1. Traverse tokens left to right.
2. If token is number, push it.
3. If token is operator:
   * Pop second operand.
   * Pop first operand.
   * Apply operator.
   * Push result.
4. Final stack top is answer.

### I. Prefix Expression Evaluation

1. Traverse tokens right to left.
2. If token is number, push it.
3. If token is operator:
   * Pop first operand.
   * Pop second operand.
   * Apply operator.
   * Push result.
4. Final stack top is answer.

### J. Largest Rectangle in Histogram

1. Traverse bars from left to right.
2. Maintain stack of indices with increasing heights.
3. When current height is smaller than stack top height:
   * Pop the top index.
   * Treat popped height as rectangle height.
   * Right boundary is current index.
   * Left boundary is new stack top.
   * Calculate area.
4. Push current index.
5. Add a sentinel height `0` at the end to flush remaining bars.

### K. Maximal Rectangle

1. Treat each row of binary matrix as base of a histogram.
2. Build heights of consecutive `1`s column-wise.
3. For every row, compute largest rectangle in histogram.
4. Maximum over all rows is answer.

### L. Stock Span

1. Traverse prices left to right.
2. Maintain stack of indices with strictly greater prices.
3. Pop while previous price is less than or equal to current price.
4. If stack is empty, span is `i + 1`.
5. Else span is `i - stack.top()`.
6. Push current index.

### M. Asteroid Collision

1. Traverse asteroids.
2. If asteroid moves right, push it.
3. If asteroid moves left, compare with right-moving asteroids on stack top.
4. Smaller asteroid explodes.
5. Equal asteroids both explode.
6. If current survives, push it.

### N. Decode String

1. Use stack for previous strings and repeat counts.
2. Build current number when digits appear.
3. On `[`, save current string and count.
4. On `]`, repeat current string and append to previous string.
5. Letters are appended to current string.

### O. Remove Duplicate Letters

1. Count last occurrence of each character.
2. Traverse string.
3. Skip character if already used.
4. While stack top is larger than current character and appears later again:
   * Remove stack top.
   * Mark it unused.
5. Push current character and mark used.
6. Stack gives lexicographically smallest result with unique letters.

## 7. Dry Run

### Dry Run 1: Next Greater Element

Input:

```text
arr = [2, 1, 2, 4, 3]
```

Traverse right to left.

| i | arr[i] | Stack before | Action | Answer | Stack after |
|---|---:|---|---|---:|---|
| 4 | 3 | [] | No greater | -1 | [3] |
| 3 | 4 | [3] | Pop 3 | -1 | [4] |
| 2 | 2 | [4] | Top 4 is greater | 4 | [4, 2] |
| 1 | 1 | [4, 2] | Top 2 is greater | 2 | [4, 2, 1] |
| 0 | 2 | [4, 2, 1] | Pop 1, pop 2, top 4 | 4 | [4, 2] |

Final answer:

```text
[4, 2, 4, -1, -1]
```

### Dry Run 2: Balanced Parentheses

Input:

```text
s = "{[()]}"
```

| Character | Stack before | Action | Stack after |
|---|---|---|---|
| `{` | [] | Push | [`{`] |
| `[` | [`{`] | Push | [`{`, `[`] |
| `(` | [`{`, `[`] | Push | [`{`, `[`, `(`] |
| `)` | [`{`, `[`, `(`] | Match and pop | [`{`, `[`] |
| `]` | [`{`, `[`] | Match and pop | [`{`] |
| `}` | [`{`] | Match and pop | [] |

Stack is empty, so the string is balanced.

### Dry Run 3: Largest Rectangle in Histogram

Input:

```text
heights = [2, 1, 5, 6, 2, 3]
```

Add sentinel:

```text
[2, 1, 5, 6, 2, 3, 0]
```

| i | height | Stack indices | Important action | Max area |
|---|---:|---|---|---:|
| 0 | 2 | [] | Push 0 | 0 |
| 1 | 1 | [0] | Pop 0, area = 2 * 1 | 2 |
| 2 | 5 | [1] | Push 2 | 2 |
| 3 | 6 | [1, 2] | Push 3 | 2 |
| 4 | 2 | [1, 2, 3] | Pop 3, area = 6 * 1 | 6 |
| 4 | 2 | [1, 2] | Pop 2, area = 5 * 2 | 10 |
| 5 | 3 | [1, 4] | Push 5 | 10 |
| 6 | 0 | [1, 4, 5] | Pop remaining bars | 10 |

Final answer:

```text
10
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

class MinStack {
private:
    stack<int> values;
    stack<int> minimums;

public:
    void push(int x) {
        values.push(x);

        if (minimums.empty()) {
            minimums.push(x);
        } else {
            minimums.push(min(x, minimums.top()));
        }
    }

    void pop() {
        if (values.empty()) return;
        values.pop();
        minimums.pop();
    }

    int top() {
        return values.top();
    }

    int getMin() {
        return minimums.top();
    }

    bool empty() {
        return values.empty();
    }
};

bool isBalancedParentheses(const string& s) {
    stack<char> st;
    unordered_map<char, char> matching = {
        {')', '('},
        {']', '['},
        {'}', '{'}
    };

    for (char ch : s) {
        if (ch == '(' || ch == '[' || ch == '{') {
            st.push(ch);
        } else if (ch == ')' || ch == ']' || ch == '}') {
            if (st.empty() || st.top() != matching[ch]) {
                return false;
            }
            st.pop();
        }
    }

    return st.empty();
}

vector<int> nextGreaterElement(const vector<int>& arr) {
    int n = arr.size();
    vector<int> answer(n, -1);
    stack<int> st;

    for (int i = n - 1; i >= 0; i--) {
        while (!st.empty() && st.top() <= arr[i]) {
            st.pop();
        }

        if (!st.empty()) {
            answer[i] = st.top();
        }

        st.push(arr[i]);
    }

    return answer;
}

vector<int> previousGreaterElement(const vector<int>& arr) {
    int n = arr.size();
    vector<int> answer(n, -1);
    stack<int> st;

    for (int i = 0; i < n; i++) {
        while (!st.empty() && st.top() <= arr[i]) {
            st.pop();
        }

        if (!st.empty()) {
            answer[i] = st.top();
        }

        st.push(arr[i]);
    }

    return answer;
}

vector<int> nextSmallerElement(const vector<int>& arr) {
    int n = arr.size();
    vector<int> answer(n, -1);
    stack<int> st;

    for (int i = n - 1; i >= 0; i--) {
        while (!st.empty() && st.top() >= arr[i]) {
            st.pop();
        }

        if (!st.empty()) {
            answer[i] = st.top();
        }

        st.push(arr[i]);
    }

    return answer;
}

vector<int> previousSmallerElement(const vector<int>& arr) {
    int n = arr.size();
    vector<int> answer(n, -1);
    stack<int> st;

    for (int i = 0; i < n; i++) {
        while (!st.empty() && st.top() >= arr[i]) {
            st.pop();
        }

        if (!st.empty()) {
            answer[i] = st.top();
        }

        st.push(arr[i]);
    }

    return answer;
}

int applyOperator(int a, int b, const string& op) {
    if (op == "+") return a + b;
    if (op == "-") return a - b;
    if (op == "*") return a * b;
    if (op == "/") return a / b;
    throw invalid_argument("Unsupported operator");
}

int evaluatePostfix(const vector<string>& tokens) {
    stack<int> st;

    for (const string& token : tokens) {
        if (token == "+" || token == "-" || token == "*" || token == "/") {
            int b = st.top();
            st.pop();
            int a = st.top();
            st.pop();
            st.push(applyOperator(a, b, token));
        } else {
            st.push(stoi(token));
        }
    }

    return st.top();
}

int evaluatePrefix(const vector<string>& tokens) {
    stack<int> st;

    for (int i = (int)tokens.size() - 1; i >= 0; i--) {
        string token = tokens[i];

        if (token == "+" || token == "-" || token == "*" || token == "/") {
            int a = st.top();
            st.pop();
            int b = st.top();
            st.pop();
            st.push(applyOperator(a, b, token));
        } else {
            st.push(stoi(token));
        }
    }

    return st.top();
}

int largestRectangleArea(vector<int> heights) {
    heights.push_back(0);
    stack<int> st;
    int maxArea = 0;

    for (int i = 0; i < (int)heights.size(); i++) {
        while (!st.empty() && heights[st.top()] > heights[i]) {
            int height = heights[st.top()];
            st.pop();

            int rightBoundary = i;
            int leftBoundary = st.empty() ? -1 : st.top();
            int width = rightBoundary - leftBoundary - 1;

            maxArea = max(maxArea, height * width);
        }

        st.push(i);
    }

    return maxArea;
}

int maximalRectangle(vector<vector<char>>& matrix) {
    if (matrix.empty() || matrix[0].empty()) return 0;

    int rows = matrix.size();
    int cols = matrix[0].size();
    vector<int> heights(cols, 0);
    int answer = 0;

    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
            if (matrix[r][c] == '1') {
                heights[c]++;
            } else {
                heights[c] = 0;
            }
        }

        answer = max(answer, largestRectangleArea(heights));
    }

    return answer;
}

vector<int> stockSpan(const vector<int>& prices) {
    int n = prices.size();
    vector<int> span(n);
    stack<int> st;

    for (int i = 0; i < n; i++) {
        while (!st.empty() && prices[st.top()] <= prices[i]) {
            st.pop();
        }

        span[i] = st.empty() ? i + 1 : i - st.top();
        st.push(i);
    }

    return span;
}

vector<int> asteroidCollision(const vector<int>& asteroids) {
    vector<int> st;

    for (int asteroid : asteroids) {
        bool alive = true;

        while (alive && asteroid < 0 && !st.empty() && st.back() > 0) {
            if (st.back() < -asteroid) {
                st.pop_back();
            } else if (st.back() == -asteroid) {
                st.pop_back();
                alive = false;
            } else {
                alive = false;
            }
        }

        if (alive) {
            st.push_back(asteroid);
        }
    }

    return st;
}

string decodeString(const string& s) {
    stack<int> countStack;
    stack<string> stringStack;
    string current = "";
    int number = 0;

    for (char ch : s) {
        if (isdigit(ch)) {
            number = number * 10 + (ch - '0');
        } else if (ch == '[') {
            countStack.push(number);
            stringStack.push(current);
            number = 0;
            current = "";
        } else if (ch == ']') {
            int repeat = countStack.top();
            countStack.pop();

            string previous = stringStack.top();
            stringStack.pop();

            string repeated = "";
            for (int i = 0; i < repeat; i++) {
                repeated += current;
            }

            current = previous + repeated;
        } else {
            current += ch;
        }
    }

    return current;
}

string removeDuplicateLetters(const string& s) {
    vector<int> lastIndex(26, -1);
    vector<bool> used(26, false);
    string st = "";

    for (int i = 0; i < (int)s.size(); i++) {
        lastIndex[s[i] - 'a'] = i;
    }

    for (int i = 0; i < (int)s.size(); i++) {
        char ch = s[i];
        int id = ch - 'a';

        if (used[id]) continue;

        while (!st.empty() && st.back() > ch && lastIndex[st.back() - 'a'] > i) {
            used[st.back() - 'a'] = false;
            st.pop_back();
        }

        st.push_back(ch);
        used[id] = true;
    }

    return st;
}

void printVector(const vector<int>& values) {
    for (int value : values) {
        cout << value << " ";
    }
    cout << '\n';
}

int main() {
    vector<int> arr = {2, 1, 2, 4, 3};

    cout << "Next Greater Element: ";
    printVector(nextGreaterElement(arr));

    cout << "Previous Greater Element: ";
    printVector(previousGreaterElement(arr));

    cout << "Next Smaller Element: ";
    printVector(nextSmallerElement(arr));

    cout << "Previous Smaller Element: ";
    printVector(previousSmallerElement(arr));

    string brackets = "{[()]}";
    cout << "Balanced Parentheses: "
         << (isBalancedParentheses(brackets) ? "YES" : "NO") << '\n';

    vector<string> postfix = {"2", "1", "+", "3", "*"};
    cout << "Postfix Evaluation: " << evaluatePostfix(postfix) << '\n';

    vector<string> prefix = {"*", "+", "2", "1", "3"};
    cout << "Prefix Evaluation: " << evaluatePrefix(prefix) << '\n';

    vector<int> heights = {2, 1, 5, 6, 2, 3};
    cout << "Largest Rectangle Area: " << largestRectangleArea(heights) << '\n';

    vector<int> prices = {100, 80, 60, 70, 60, 75, 85};
    cout << "Stock Span: ";
    printVector(stockSpan(prices));

    vector<int> asteroids = {5, 10, -5};
    cout << "Asteroid Collision: ";
    printVector(asteroidCollision(asteroids));

    cout << "Decode String: " << decodeString("3[a2[c]]") << '\n';
    cout << "Remove Duplicate Letters: " << removeDuplicateLetters("cbacdcbc") << '\n';

    MinStack minStack;
    minStack.push(3);
    minStack.push(5);
    minStack.push(2);
    cout << "Min Stack Minimum: " << minStack.getMin() << '\n';

    return 0;
}
```

Example output:

```text
Next Greater Element: 4 2 4 -1 -1
Previous Greater Element: -1 2 -1 -1 4
Next Smaller Element: 1 -1 -1 3 -1
Previous Smaller Element: -1 -1 1 2 2
Balanced Parentheses: YES
Postfix Evaluation: 9
Prefix Evaluation: 9
Largest Rectangle Area: 10
Stock Span: 1 1 1 2 1 4 6
Asteroid Collision: 5 10
Decode String: accaccacc
Remove Duplicate Letters: acdb
Min Stack Minimum: 2
```

## pYTHON IMPLEMENTATION

pROVIDE CLEAN PYTHON CODE

```python
from typing import List


class MinStack:
    def __init__(self) -> None:
        self.values = []
        self.minimums = []

    def push(self, x: int) -> None:
        self.values.append(x)
        if not self.minimums:
            self.minimums.append(x)
        else:
            self.minimums.append(min(x, self.minimums[-1]))

    def pop(self) -> None:
        if not self.values:
            return
        self.values.pop()
        self.minimums.pop()

    def top(self) -> int:
        return self.values[-1]

    def get_min(self) -> int:
        return self.minimums[-1]


def is_balanced_parentheses(s: str) -> bool:
    stack = []
    matching = {")": "(", "]": "[", "}": "{"}

    for ch in s:
        if ch in "([{":
            stack.append(ch)
        elif ch in ")]}":
            if not stack or stack[-1] != matching[ch]:
                return False
            stack.pop()

    return not stack


def next_greater_element(arr: List[int]) -> List[int]:
    ans = [-1] * len(arr)
    stack = []

    for i in range(len(arr) - 1, -1, -1):
        while stack and stack[-1] <= arr[i]:
            stack.pop()
        if stack:
            ans[i] = stack[-1]
        stack.append(arr[i])

    return ans


def previous_greater_element(arr: List[int]) -> List[int]:
    ans = [-1] * len(arr)
    stack = []

    for i, value in enumerate(arr):
        while stack and stack[-1] <= value:
            stack.pop()
        if stack:
            ans[i] = stack[-1]
        stack.append(value)

    return ans


def next_smaller_element(arr: List[int]) -> List[int]:
    ans = [-1] * len(arr)
    stack = []

    for i in range(len(arr) - 1, -1, -1):
        while stack and stack[-1] >= arr[i]:
            stack.pop()
        if stack:
            ans[i] = stack[-1]
        stack.append(arr[i])

    return ans


def previous_smaller_element(arr: List[int]) -> List[int]:
    ans = [-1] * len(arr)
    stack = []

    for i, value in enumerate(arr):
        while stack and stack[-1] >= value:
            stack.pop()
        if stack:
            ans[i] = stack[-1]
        stack.append(value)

    return ans


def apply_operator(a: int, b: int, op: str) -> int:
    if op == "+":
        return a + b
    if op == "-":
        return a - b
    if op == "*":
        return a * b
    if op == "/":
        return int(a / b)
    raise ValueError("Unsupported operator")


def evaluate_postfix(tokens: List[str]) -> int:
    stack = []

    for token in tokens:
        if token in {"+", "-", "*", "/"}:
            b = stack.pop()
            a = stack.pop()
            stack.append(apply_operator(a, b, token))
        else:
            stack.append(int(token))

    return stack[-1]


def evaluate_prefix(tokens: List[str]) -> int:
    stack = []

    for token in reversed(tokens):
        if token in {"+", "-", "*", "/"}:
            a = stack.pop()
            b = stack.pop()
            stack.append(apply_operator(a, b, token))
        else:
            stack.append(int(token))

    return stack[-1]


def largest_rectangle_area(heights: List[int]) -> int:
    heights = heights + [0]
    stack = []
    max_area = 0

    for i, height in enumerate(heights):
        while stack and heights[stack[-1]] > height:
            h = heights[stack.pop()]
            left_boundary = stack[-1] if stack else -1
            width = i - left_boundary - 1
            max_area = max(max_area, h * width)

        stack.append(i)

    return max_area


def maximal_rectangle(matrix: List[List[str]]) -> int:
    if not matrix or not matrix[0]:
        return 0

    cols = len(matrix[0])
    heights = [0] * cols
    answer = 0

    for row in matrix:
        for c in range(cols):
            if row[c] == "1":
                heights[c] += 1
            else:
                heights[c] = 0

        answer = max(answer, largest_rectangle_area(heights))

    return answer


def stock_span(prices: List[int]) -> List[int]:
    span = [0] * len(prices)
    stack = []

    for i, price in enumerate(prices):
        while stack and prices[stack[-1]] <= price:
            stack.pop()

        span[i] = i + 1 if not stack else i - stack[-1]
        stack.append(i)

    return span


def asteroid_collision(asteroids: List[int]) -> List[int]:
    stack = []

    for asteroid in asteroids:
        alive = True

        while alive and asteroid < 0 and stack and stack[-1] > 0:
            if stack[-1] < -asteroid:
                stack.pop()
            elif stack[-1] == -asteroid:
                stack.pop()
                alive = False
            else:
                alive = False

        if alive:
            stack.append(asteroid)

    return stack


def decode_string(s: str) -> str:
    count_stack = []
    string_stack = []
    current = ""
    number = 0

    for ch in s:
        if ch.isdigit():
            number = number * 10 + int(ch)
        elif ch == "[":
            count_stack.append(number)
            string_stack.append(current)
            number = 0
            current = ""
        elif ch == "]":
            repeat = count_stack.pop()
            previous = string_stack.pop()
            current = previous + current * repeat
        else:
            current += ch

    return current


def remove_duplicate_letters(s: str) -> str:
    last_index = {ch: i for i, ch in enumerate(s)}
    used = set()
    stack = []

    for i, ch in enumerate(s):
        if ch in used:
            continue

        while stack and stack[-1] > ch and last_index[stack[-1]] > i:
            used.remove(stack.pop())

        stack.append(ch)
        used.add(ch)

    return "".join(stack)


if __name__ == "__main__":
    arr = [2, 1, 2, 4, 3]

    print("Next Greater Element:", next_greater_element(arr))
    print("Previous Greater Element:", previous_greater_element(arr))
    print("Next Smaller Element:", next_smaller_element(arr))
    print("Previous Smaller Element:", previous_smaller_element(arr))
    print("Balanced Parentheses:", is_balanced_parentheses("{[()]}"))
    print("Postfix Evaluation:", evaluate_postfix(["2", "1", "+", "3", "*"]))
    print("Prefix Evaluation:", evaluate_prefix(["*", "+", "2", "1", "3"]))
    print("Largest Rectangle Area:", largest_rectangle_area([2, 1, 5, 6, 2, 3]))
    print("Stock Span:", stock_span([100, 80, 60, 70, 60, 75, 85]))
    print("Asteroid Collision:", asteroid_collision([5, 10, -5]))
    print("Decode String:", decode_string("3[a2[c]]"))
    print("Remove Duplicate Letters:", remove_duplicate_letters("cbacdcbc"))

    min_stack = MinStack()
    min_stack.push(3)
    min_stack.push(5)
    min_stack.push(2)
    print("Min Stack Minimum:", min_stack.get_min())
```

## 10. Code Explanation

### Min Stack

The `MinStack` class uses two stacks.

* `values` stores actual elements.
* `minimums` stores the minimum value at every stack depth.

When pushing `x`, we also push the smaller value between `x` and the previous minimum.

This makes `getMin()` O(1), because the current minimum is always at the top of `minimums`.

### Balanced Parentheses

The stack stores opening brackets.

When a closing bracket appears:

* If the stack is empty, there is no matching opening bracket.
* If the top bracket is not the correct match, the expression is invalid.
* Otherwise, pop the matching opening bracket.

At the end, the stack must be empty.

### Next and Previous Greater/Smaller Elements

These functions use monotonic stacks.

Important points:

* For next problems, traverse from right to left.
* For previous problems, traverse from left to right.
* For greater problems, remove smaller or equal elements.
* For smaller problems, remove greater or equal elements.

Equal elements are popped because the question usually asks for strictly greater or strictly smaller.

### Expression Evaluation

For postfix:

* Operators appear after operands.
* Traverse left to right.
* Pop `b` first, then `a`.
* Calculate `a op b`.

For prefix:

* Operators appear before operands.
* Traverse right to left.
* Pop `a` first, then `b`.
* Calculate `a op b`.

Order matters for subtraction and division.

### Largest Rectangle in Histogram

The stack stores indices of bars in increasing height order.

When a smaller height appears, it means the previous taller bars cannot extend further right.

For a popped bar:

* Height = popped bar height.
* Right boundary = current index.
* Left boundary = index now on top of stack.
* Width = `rightBoundary - leftBoundary - 1`.

The sentinel `0` at the end forces all remaining bars to be processed.

### Maximal Rectangle

Each matrix row becomes the base of a histogram.

For every column:

* If cell is `1`, increase height.
* If cell is `0`, reset height to `0`.

Then apply largest rectangle in histogram for each row.

### Stock Span

The stack stores indices of previous days with greater price.

If previous prices are less than or equal to current price, they are included in current span and popped.

The nearest previous greater price limits the span.

### Asteroid Collision

Only a positive asteroid followed by a negative asteroid can collide.

That is why the loop checks:

```text
current asteroid < 0 and stack top > 0
```

The smaller asteroid is removed. If equal, both are removed.

### Decode String

When `[` appears, the current count and string are saved.

When `]` appears:

* The current substring is complete.
* Repeat it using saved count.
* Append it to the previous string.

This naturally handles nested expressions.

### Remove Duplicate Letters

The stack stores the result being built.

For every character:

* Skip if already used.
* Remove larger stack-top characters if they appear later again.
* Push current character.

This gives the smallest lexicographical string while keeping one occurrence of every character.

## 11. Complexity Analysis

| Algorithm | Time Complexity | Space Complexity | Notes |
|---|---:|---:|---|
| Basic stack operations | O(1) per operation | O(n) | `n` pushed elements |
| Balanced parentheses | O(n) | O(n) | Each bracket pushed/popped once |
| Next greater element | O(n) | O(n) | Each element pushed/popped once |
| Previous greater element | O(n) | O(n) | Each element pushed/popped once |
| Next smaller element | O(n) | O(n) | Each element pushed/popped once |
| Previous smaller element | O(n) | O(n) | Each element pushed/popped once |
| Monotonic stack | O(n) | O(n) | Amortized O(1) per element |
| Min stack | O(1) per operation | O(n) | Extra minimum stack |
| Postfix evaluation | O(n) | O(n) | One pass over tokens |
| Prefix evaluation | O(n) | O(n) | One reverse pass over tokens |
| Largest rectangle in histogram | O(n) | O(n) | Each index pushed/popped once |
| Maximal rectangle | O(rows * cols) | O(cols) | Histogram per row |
| Stock span | O(n) | O(n) | Monotonic decreasing stack |
| Asteroid collision | O(n) | O(n) | Each asteroid removed at most once |
| Decode string | O(output length) | O(n) | Repeated string construction |
| Remove duplicate letters | O(n) | O(1) or O(k) | `k` is alphabet size |

## 12. Common Patterns

| Pattern | How to Identify | General Approach | Example Problems |
|---|---|---|---|
| Bracket matching | Valid parentheses, matching pairs | Push openings, match closings | Valid Parentheses, Minimum Add to Make Parentheses Valid |
| Next greater | Find first greater element to right | Traverse right to left with decreasing stack | Next Greater Element I/II |
| Previous greater | Find first greater element to left | Traverse left to right with decreasing stack | Stock Span |
| Next smaller | Find first smaller element to right | Traverse right to left with increasing stack | Sum of Subarray Minimums |
| Previous smaller | Find first smaller element to left | Traverse left to right with increasing stack | Largest Rectangle in Histogram |
| Monotonic stack contribution | Count subarrays where element is min/max | Find previous/next boundaries | Sum of Subarray Minimums |
| Histogram area | Max rectangle from bar heights | Increasing index stack | Largest Rectangle in Histogram |
| Matrix rectangle | Largest rectangle of `1`s | Convert rows to histograms | Maximal Rectangle |
| Expression evaluation | Prefix/postfix tokens | Use operand stack | Evaluate Reverse Polish Notation |
| Nested decoding | Strings with brackets and multipliers | Stack counts and previous strings | Decode String |
| Collision simulation | Current item interacts with previous active item | Use stack as active state | Asteroid Collision |
| Lexicographical stack | Remove characters for smallest result | Pop larger chars if available later | Remove Duplicate Letters |

## 13. Common Mistakes

* Calling `top()` or `pop()` on an empty stack.
* Using `<` instead of `<=` or `>` instead of `>=` incorrectly.
* Forgetting that equal values affect strict greater/smaller answers.
* Storing values when indices are needed for distance or width.
* Storing indices when values are enough, making code harder than necessary.
* Forgetting to push the current element after popping.
* Traversing in the wrong direction for next/previous problems.
* In postfix evaluation, reversing operand order for `-` and `/`.
* In prefix evaluation, using postfix operand order by mistake.
* Forgetting sentinel `0` in histogram problems.
* Calculating histogram width as `right - left` instead of `right - left - 1`.
* Not resetting histogram height to `0` on matrix cell `0`.
* In asteroid collision, checking collisions between asteroids moving away from each other.
* In decode string, not handling multi-digit numbers.
* In remove duplicate letters, popping a character even when it does not appear later.
* Assuming stack algorithms are always O(n log n). Most monotonic stack algorithms are O(n).

## 14. Edge Cases

| Problem Type | Edge Cases |
|---|---|
| Basic stack | Empty stack, one element, repeated push/pop |
| Balanced parentheses | Empty string, only opening brackets, only closing brackets, mixed bracket types |
| Next/previous greater/smaller | Empty array, one element, all equal, sorted increasing, sorted decreasing, negative values |
| Monotonic stack | Duplicate values, strict vs non-strict comparison |
| Min stack | Repeated minimum, popping current minimum, negative values |
| Postfix/prefix | Single number, negative numbers, division, invalid expression |
| Histogram | Empty heights, one bar, all equal, increasing heights, decreasing heights, zero height |
| Maximal rectangle | Empty matrix, all zeros, all ones, single row, single column |
| Stock span | All increasing, all decreasing, all equal |
| Asteroid collision | All positive, all negative, equal collision, chain collision |
| Decode string | Multi-digit repeat count, nested brackets, no brackets |
| Remove duplicate letters | Already unique, all same, reverse sorted characters, repeated letters |

## 15. Variations

### Next Greater Element II

Array is circular.

What changes:

* Traverse `2 * n` positions.
* Use `i % n`.

Importance:

Very common in interviews and LeetCode.

### Next Greater Frequency Element

Instead of comparing values, compare frequencies.

What changes:

* Precompute frequency map.
* Use monotonic stack based on frequency.

Importance:

Common in GFG and online assessments.

### Min Stack With Encoded Values

Use one stack and a variable `minValue`.

What changes:

* Store encoded values when new minimum appears.
* Saves extra stack space but is harder to implement.

Importance:

Good interview follow-up.

### Sum of Subarray Minimums

Use previous smaller and next smaller boundaries.

What changes:

* Each element contributes as minimum in several subarrays.
* Contribution = `arr[i] * leftCount * rightCount`.

Importance:

Important for CP and advanced interviews.

### Largest Rectangle With Previous/Next Smaller Arrays

Instead of one-pass stack, compute:

* Previous smaller index
* Next smaller index

Then:

```text
area = height[i] * (nextSmaller[i] - previousSmaller[i] - 1)
```

Importance:

Easier to understand, slightly more memory.

### Infix Expression Evaluation

Expression contains operators between operands.

What changes:

* Need operator precedence.
* Usually use two stacks: operands and operators.

Importance:

Useful for compiler-style and calculator problems.

### Remove K Digits

Build smallest number by removing `k` digits.

What changes:

* Similar lexicographical monotonic stack.
* Pop while stack top is greater than current digit and removals remain.

Importance:

Very common stack pattern.

## 16. Related Algorithms/Data Structures

| Topic | Connection | How to Choose |
|---|---|---|
| Stack vs Queue | Stack is LIFO, queue is FIFO | Use stack for nested/recent-first, queue for level-order/oldest-first |
| Stack vs Deque | Deque supports both ends | Use deque for sliding window or double-ended operations |
| Stack vs Recursion | Recursion uses call stack internally | Use explicit stack to avoid recursion depth or simulate DFS |
| Monotonic Stack vs Heap | Heap gives global min/max, stack gives nearest boundary | Use stack for nearest greater/smaller, heap for repeated global priority |
| Monotonic Stack vs Segment Tree | Segment tree supports dynamic range queries | Use stack for one-pass static arrays |
| Stack vs DFS | DFS can be implemented with stack | Use DFS logic for graph traversal, stack as implementation detail |
| Stack vs Hash Map | Hash map gives direct lookup | Use hash map for membership/frequency, stack for order |
| Stack vs Balanced BST | BST supports sorted dynamic operations | Use BST for dynamic ordered set queries |

## 17. Practice Problems

### Easy

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Valid Parentheses | LeetCode | Bracket matching using stack | Easy |
| Implement Stack using Queues | LeetCode | Stack operations simulation | Easy |

### Medium

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Next Greater Element II | LeetCode | Circular monotonic stack | Medium |
| Online Stock Span | LeetCode | Previous greater with stack | Medium |
| Decode String | LeetCode | Nested string stack | Medium |

### Hard

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Largest Rectangle in Histogram | LeetCode | Monotonic increasing stack | Hard |
| Maximal Rectangle | LeetCode | Histogram per matrix row | Hard |
| Remove Duplicate Letters | LeetCode | Lexicographical monotonic stack | Hard |

More useful practice:

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Asteroid Collision | LeetCode | Stack simulation | Medium |
| Evaluate Reverse Polish Notation | LeetCode | Postfix evaluation | Medium |
| Sum of Subarray Minimums | LeetCode | Previous/next smaller contribution | Medium |
| The Stock Span Problem | GFG | Previous greater index | Medium |
| Nearest Smaller Values | CSES | Previous smaller element | Medium |

## 18. Interview Explanation

A stack is a LIFO data structure where the last inserted element is removed first. I use it when the problem depends on the most recent unresolved item, such as matching parentheses, nested expressions, or nearest greater/smaller element problems. For monotonic stack problems, I maintain the stack in increasing or decreasing order and pop elements that can no longer be useful. Since each element is pushed and popped at most once, these solutions are usually O(n) time with O(n) space.

## 19. Revision Notes

* Stack means **last in, first out**.
* Always check empty before `top()` or `pop()`.
* Parentheses: push opening, match closing, final stack must be empty.
* Next greater: traverse right to left, pop `<= current`.
* Previous greater: traverse left to right, pop `<= current`.
* Next smaller: traverse right to left, pop `>= current`.
* Previous smaller: traverse left to right, pop `>= current`.
* Histogram: increasing stack of indices, area = `height * width`.
* Histogram width = `rightBoundary - leftBoundary - 1`.
* Stock span uses previous greater element.
* Asteroid collision only happens when stack top is positive and current is negative.
* Decode string needs stacks for counts and previous strings.
* Remove duplicate letters pops larger characters only if they appear later.
* Most stack algorithms are O(n), because every element is pushed and popped once.

## 20. Final Cheat Sheet

| Topic | Cheat Sheet |
|---|---|
| When to use | Recent unresolved element, nested structure, nearest greater/smaller, monotonic order |
| Main operations | `push`, `pop`, `top`, `empty`, `size` |
| Basic complexity | O(1) per stack operation |
| Monotonic stack complexity | O(n) time, O(n) space |
| Next greater | Right to left, decreasing stack, pop `<= current` |
| Previous greater | Left to right, decreasing stack, pop `<= current` |
| Next smaller | Right to left, increasing stack, pop `>= current` |
| Previous smaller | Left to right, increasing stack, pop `>= current` |
| Histogram key idea | Pop when current height is smaller; popped bar becomes rectangle height |
| Histogram formula | `area = height * (right - left - 1)` |
| Stock span | `span = i + 1` if no previous greater, else `i - previousGreaterIndex` |
| Min stack | Use extra stack storing minimum at each depth |
| Postfix | Traverse left to right, pop `b`, pop `a`, compute `a op b` |
| Prefix | Traverse right to left, pop `a`, pop `b`, compute `a op b` |
| Decode string | Save count and previous string on `[` |
| Remove duplicate letters | Pop larger chars only if they appear again later |
| Important edge cases | Empty input, single element, duplicates, sorted arrays, reverse sorted arrays, nested brackets, repeated minimum |

