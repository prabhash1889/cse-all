# Linked List

## 1. Overview

A linked list is a linear data structure where elements are stored in nodes. Each node stores data and one or more links to other nodes.

Unlike arrays, linked lists do not need contiguous memory. Nodes can be created anywhere in memory and connected using pointers.

Common linked list types:

| Type | Node Stores | Direction |
|---|---|---|
| Singly linked list | `value`, `next` | Forward only |
| Doubly linked list | `value`, `prev`, `next` | Forward and backward |
| Circular linked list | Last node points back to first | Circular traversal |
| Random pointer list | `value`, `next`, `random` | Extra arbitrary pointer |

Linked lists are very common in placements and competitive programming because they test pointer manipulation, edge cases, and in-place algorithms.

Must-practice problems:

* Reverse linked list
* Cycle detection
* Middle node
* Merge two sorted lists
* LRU cache
* Copy list with random pointer

## 2. Intuition

A linked list is like a chain of connected boxes.

Each box knows:

* Its own value
* Where the next box is
* In a doubly linked list, where the previous box is too

In an array, if you want the 5th element, you can directly jump to index `4`. In a linked list, you must start at the head and move one node at a time.

The core idea is pointer redirection.

For example, reversing:

```text
1 -> 2 -> 3 -> NULL
```

Instead of creating a new list, we change links:

```text
NULL <- 1 <- 2 <- 3
```

Most linked list problems are not about complex formulas. They are about carefully maintaining references before changing pointers.

Why linked list algorithms work:

* Every node is reachable through links.
* If we store the next node before changing a link, we do not lose the remaining list.
* Dummy nodes simplify head changes.
* Two-pointer techniques solve many problems without extra memory.
* Fast and slow pointers use relative speed to detect structure, cycles, or middle positions.

## 3. When to Use It

Use linked lists when:

* Frequent insertion/deletion is needed after locating a node.
* You need O(1) deletion with direct node reference.
* The problem explicitly gives a `ListNode`.
* Memory does not need to be contiguous.
* You need to model sequences with flexible updates.
* You need an LRU cache with O(1) remove and move-to-front operations.
* You need in-place pointer manipulation.

Common trigger phrases:

* "Given the head of a linked list"
* "Reverse the list"
* "Detect if a cycle exists"
* "Find the middle node"
* "Remove nth node from the end"
* "Merge two sorted linked lists"
* "Copy a list with random pointer"
* "Flatten a linked list"
* "Least Recently Used cache"
* "Do it in O(1) extra space"
* "Do not modify node values, change links instead"

## 4. When Not to Use It

Linked lists are not suitable when:

* You need fast random access by index.
* Binary search by index is required.
* Cache locality matters heavily.
* You only need simple storage and arrays/vectors are easier.
* You need frequent traversal but few insertions/deletions.
* You need sorting and can simply use an array/vector.

Simpler alternatives:

| Need | Prefer |
|---|---|
| Random access | Array/vector |
| Stack behavior | `stack`, vector |
| Queue behavior | `queue`, deque |
| Sorted dynamic set | `set`, `multiset` |
| O(1) key lookup | `unordered_map` |
| LRU behavior | Doubly linked list + hashmap |

Common wrong assumptions:

* Linked list insertion is always O(1). It is O(1) only if you already have the node position.
* Linked lists are always better for memory. Extra pointers increase memory usage.
* Cycle detection can be done by checking `head == NULL`. A cycle may never reach `NULL`.
* Reversing can be done by swapping values. In interviews, usually links should be changed.

## 5. Core Concepts

### Node

A node is the basic unit of a linked list.

For singly linked list:

```cpp
struct ListNode {
    int val;
    ListNode* next;
};
```

Why it matters:

* Every operation changes node connections.
* Losing a pointer can make part of the list unreachable.

### Head

The head is the first node of the list.

Example:

```text
head
 |
 v
10 -> 20 -> 30 -> NULL
```

Why it matters:

* If the head changes, return the new head.
* Reverse, delete first node, and merge operations often change head.

### Tail

The tail is the last node. Its `next` is usually `NULL`.

Why it matters:

* Useful for appending.
* In cycle problems, tail may point to an earlier node instead of `NULL`.

### Dummy Node

A dummy node is a fake node placed before the real head.

```text
dummy -> real_head
```

Why it matters:

* Simplifies deletion and merging.
* Avoids special handling when the head itself changes.

### Previous, Current, Next

These three pointers are common in reversal.

```text
prev <- curr    next
        |       |
        v       v
        2  ->   3
```

Why it matters:

* `next` saves the remaining list before breaking `curr->next`.
* `prev` stores the reversed part.
* `curr` processes the current node.

### Fast and Slow Pointers

Two pointers move at different speeds.

```text
slow moves 1 step
fast moves 2 steps
```

Why it matters:

* Detect cycle
* Find middle node
* Find cycle start
* Split list for merge sort
* Check palindrome

### Doubly Linked List

Each node has both `prev` and `next`.

```text
NULL <- 1 <-> 2 <-> 3 -> NULL
```

Why it matters:

* Allows O(1) deletion if node pointer is known.
* Essential for LRU cache.

### Random Pointer

Each node has an extra pointer that can point to any node or `NULL`.

Why it matters:

* Simple `next` traversal is not enough to copy the structure.
* Need mapping or interleaving technique.

## 6. Step-by-Step Algorithm

This section covers the main linked-list algorithms required for placements and CP.

### A. Singly Linked List Traversal

1. Start from `head`.
2. While current node is not `NULL`, process it.
3. Move to `current->next`.
4. Stop when current becomes `NULL`.

### B. Reverse Linked List

1. Initialize `prev = NULL`.
2. Initialize `curr = head`.
3. While `curr != NULL`:
   1. Store `nextNode = curr->next`.
   2. Change `curr->next = prev`.
   3. Move `prev = curr`.
   4. Move `curr = nextNode`.
4. Return `prev` as the new head.

### C. Fast and Slow Pointers

1. Put both `slow` and `fast` at `head`.
2. Move `slow` by one step.
3. Move `fast` by two steps.
4. Use their relationship:
   * If `fast` reaches `NULL`, there is no cycle.
   * If `slow == fast`, a cycle exists.
   * When `fast` reaches the end, `slow` is near the middle.

### D. Detect Cycle

1. Start `slow = head`, `fast = head`.
2. Move `slow` one step and `fast` two steps.
3. If they meet, cycle exists.
4. If `fast` or `fast->next` becomes `NULL`, no cycle exists.

### E. Find Middle

1. Start `slow = head`, `fast = head`.
2. Move slow one step and fast two steps.
3. When fast reaches the end, slow is at the middle.
4. For even length, this returns the second middle.

### F. Merge Two Sorted Lists

1. Create a dummy node.
2. Maintain a `tail` pointer.
3. Compare the current nodes of both lists.
4. Attach the smaller node to `tail`.
5. Move that list pointer forward.
6. Attach the remaining list.
7. Return `dummy.next`.

### G. Remove Nth Node From End

1. Create a dummy node before head.
2. Put `fast` and `slow` at dummy.
3. Move `fast` `n` steps ahead.
4. Move both until `fast->next == NULL`.
5. Now `slow->next` is the node to delete.
6. Update `slow->next = slow->next->next`.
7. Return `dummy.next`.

### H. Intersection of Linked Lists

1. Use two pointers `a` and `b`.
2. Move both one step at a time.
3. When `a` reaches end, move it to `headB`.
4. When `b` reaches end, move it to `headA`.
5. They meet at intersection or both become `NULL`.

### I. Palindrome Linked List

1. Find the middle using fast and slow pointers.
2. Reverse the second half.
3. Compare first half and reversed second half.
4. Optional: restore the second half.
5. Return whether all compared values match.

### J. Reverse Nodes in k-Group

1. Use a dummy node before head.
2. Before reversing a group, check whether at least `k` nodes remain.
3. Reverse exactly `k` nodes.
4. Connect previous group to reversed group.
5. Move to next group.
6. Leave remaining nodes unchanged if fewer than `k`.

### K. Copy List with Random Pointer

Using hashmap:

1. First pass: create copied node for every original node.
2. Store mapping `original -> copy`.
3. Second pass: set `copy->next` and `copy->random`.
4. Return copied head.

Using O(1) extra space:

1. Insert copied nodes between original nodes.
2. Set random pointers using `original->random->next`.
3. Separate the copied list from original list.

### L. Flatten Linked List

Common versions:

* Multilevel doubly linked list with `child` pointer.
* Sorted linked list with `bottom` pointer.

General approach:

1. Traverse nodes.
2. When a child/sublist exists, merge or splice it into the main list.
3. Preserve order according to problem statement.
4. Fix all required links.

### M. LRU Cache Using DLL + Hashmap

1. Store key-value pairs in DLL nodes.
2. Most recently used node stays near the front.
3. Least recently used node stays near the back.
4. Hashmap maps `key -> node address`.
5. On `get`, move node to front.
6. On `put`, update or insert at front.
7. If capacity exceeded, remove node from back.

## 7. Dry Run

### Dry Run 1: Reverse Linked List

Input:

```text
1 -> 2 -> 3 -> 4 -> NULL
```

Initial:

| Variable | Value |
|---|---|
| `prev` | `NULL` |
| `curr` | `1` |

Steps:

| Step | `curr` | `nextNode` | Link Changed | `prev` after step | List direction processed |
|---|---:|---:|---|---:|---|
| 1 | 1 | 2 | `1->next = NULL` | 1 | `NULL <- 1` |
| 2 | 2 | 3 | `2->next = 1` | 2 | `NULL <- 1 <- 2` |
| 3 | 3 | 4 | `3->next = 2` | 3 | `NULL <- 1 <- 2 <- 3` |
| 4 | 4 | `NULL` | `4->next = 3` | 4 | `NULL <- 1 <- 2 <- 3 <- 4` |

Final:

```text
4 -> 3 -> 2 -> 1 -> NULL
```

### Dry Run 2: Cycle Detection

List:

```text
1 -> 2 -> 3 -> 4 -> 5
          ^         |
          |_________|
```

Cycle starts at node `3`.

| Iteration | Slow | Fast |
|---|---:|---:|
| Start | 1 | 1 |
| 1 | 2 | 3 |
| 2 | 3 | 5 |
| 3 | 4 | 4 |

Since `slow == fast`, a cycle exists.

To find cycle start:

1. Put one pointer at head.
2. Keep the other at meeting point.
3. Move both one step.
4. They meet at cycle start.

| Step | Pointer 1 | Pointer 2 |
|---|---:|---:|
| Start | 1 | 4 |
| 1 | 2 | 5 |
| 2 | 3 | 3 |

Cycle start is `3`.

### Dry Run 3: Remove 2nd Node From End

Input:

```text
1 -> 2 -> 3 -> 4 -> 5
n = 2
```

Use dummy:

```text
0 -> 1 -> 2 -> 3 -> 4 -> 5
```

Move `fast` 2 steps:

| Move | Fast |
|---|---:|
| Start | 0 |
| 1 | 1 |
| 2 | 2 |

Move both until `fast->next == NULL`:

| Step | Slow | Fast |
|---|---:|---:|
| Start | 0 | 2 |
| 1 | 1 | 3 |
| 2 | 2 | 4 |
| 3 | 3 | 5 |

Now `slow->next` is `4`. Delete it.

Final:

```text
1 -> 2 -> 3 -> 5
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

struct ListNode {
    int val;
    ListNode* next;

    ListNode(int value) {
        val = value;
        next = nullptr;
    }
};

struct DoublyNode {
    int key;
    int value;
    DoublyNode* prev;
    DoublyNode* next;

    DoublyNode(int k, int v) {
        key = k;
        value = v;
        prev = nullptr;
        next = nullptr;
    }
};

struct RandomNode {
    int val;
    RandomNode* next;
    RandomNode* random;

    RandomNode(int value) {
        val = value;
        next = nullptr;
        random = nullptr;
    }
};

ListNode* buildList(const vector<int>& values) {
    ListNode dummy(0);
    ListNode* tail = &dummy;

    for (int value : values) {
        tail->next = new ListNode(value);
        tail = tail->next;
    }

    return dummy.next;
}

void printList(ListNode* head) {
    while (head != nullptr) {
        cout << head->val;
        if (head->next != nullptr) cout << " -> ";
        head = head->next;
    }
    cout << '\n';
}

ListNode* reverseList(ListNode* head) {
    ListNode* previous = nullptr;
    ListNode* current = head;

    while (current != nullptr) {
        ListNode* nextNode = current->next;
        current->next = previous;
        previous = current;
        current = nextNode;
    }

    return previous;
}

bool hasCycle(ListNode* head) {
    ListNode* slow = head;
    ListNode* fast = head;

    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;

        if (slow == fast) return true;
    }

    return false;
}

ListNode* detectCycleStart(ListNode* head) {
    ListNode* slow = head;
    ListNode* fast = head;

    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;

        if (slow == fast) {
            ListNode* pointer = head;
            while (pointer != slow) {
                pointer = pointer->next;
                slow = slow->next;
            }
            return pointer;
        }
    }

    return nullptr;
}

ListNode* middleNode(ListNode* head) {
    ListNode* slow = head;
    ListNode* fast = head;

    while (fast != nullptr && fast->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    return slow;
}

ListNode* mergeTwoSortedLists(ListNode* list1, ListNode* list2) {
    ListNode dummy(0);
    ListNode* tail = &dummy;

    while (list1 != nullptr && list2 != nullptr) {
        if (list1->val <= list2->val) {
            tail->next = list1;
            list1 = list1->next;
        } else {
            tail->next = list2;
            list2 = list2->next;
        }
        tail = tail->next;
    }

    tail->next = (list1 != nullptr) ? list1 : list2;
    return dummy.next;
}

ListNode* removeNthFromEnd(ListNode* head, int n) {
    ListNode dummy(0);
    dummy.next = head;

    ListNode* fast = &dummy;
    ListNode* slow = &dummy;

    for (int i = 0; i < n; i++) {
        fast = fast->next;
    }

    while (fast->next != nullptr) {
        fast = fast->next;
        slow = slow->next;
    }

    ListNode* nodeToDelete = slow->next;
    slow->next = slow->next->next;
    delete nodeToDelete;

    return dummy.next;
}

ListNode* getIntersectionNode(ListNode* headA, ListNode* headB) {
    ListNode* pointerA = headA;
    ListNode* pointerB = headB;

    while (pointerA != pointerB) {
        pointerA = (pointerA == nullptr) ? headB : pointerA->next;
        pointerB = (pointerB == nullptr) ? headA : pointerB->next;
    }

    return pointerA;
}

bool isPalindrome(ListNode* head) {
    if (head == nullptr || head->next == nullptr) return true;

    ListNode* slow = head;
    ListNode* fast = head;

    while (fast->next != nullptr && fast->next->next != nullptr) {
        slow = slow->next;
        fast = fast->next->next;
    }

    ListNode* secondHalf = reverseList(slow->next);
    ListNode* firstPointer = head;
    ListNode* secondPointer = secondHalf;

    bool palindrome = true;
    while (secondPointer != nullptr) {
        if (firstPointer->val != secondPointer->val) {
            palindrome = false;
            break;
        }
        firstPointer = firstPointer->next;
        secondPointer = secondPointer->next;
    }

    slow->next = reverseList(secondHalf);
    return palindrome;
}

ListNode* reverseKGroup(ListNode* head, int k) {
    if (head == nullptr || k <= 1) return head;

    ListNode dummy(0);
    dummy.next = head;
    ListNode* groupPrevious = &dummy;

    while (true) {
        ListNode* kth = groupPrevious;
        for (int i = 0; i < k && kth != nullptr; i++) {
            kth = kth->next;
        }

        if (kth == nullptr) break;

        ListNode* groupNext = kth->next;
        ListNode* previous = groupNext;
        ListNode* current = groupPrevious->next;

        while (current != groupNext) {
            ListNode* nextNode = current->next;
            current->next = previous;
            previous = current;
            current = nextNode;
        }

        ListNode* oldGroupHead = groupPrevious->next;
        groupPrevious->next = kth;
        groupPrevious = oldGroupHead;
    }

    return dummy.next;
}

RandomNode* copyRandomList(RandomNode* head) {
    if (head == nullptr) return nullptr;

    unordered_map<RandomNode*, RandomNode*> copyOf;

    RandomNode* current = head;
    while (current != nullptr) {
        copyOf[current] = new RandomNode(current->val);
        current = current->next;
    }

    current = head;
    while (current != nullptr) {
        copyOf[current]->next = copyOf[current->next];
        copyOf[current]->random = copyOf[current->random];
        current = current->next;
    }

    return copyOf[head];
}

class LRUCache {
private:
    int capacity;
    unordered_map<int, DoublyNode*> nodeByKey;
    DoublyNode* head;
    DoublyNode* tail;

    void removeNode(DoublyNode* node) {
        node->prev->next = node->next;
        node->next->prev = node->prev;
    }

    void insertAfterHead(DoublyNode* node) {
        node->next = head->next;
        node->prev = head;
        head->next->prev = node;
        head->next = node;
    }

    void moveToFront(DoublyNode* node) {
        removeNode(node);
        insertAfterHead(node);
    }

public:
    LRUCache(int cap) {
        capacity = cap;
        head = new DoublyNode(-1, -1);
        tail = new DoublyNode(-1, -1);
        head->next = tail;
        tail->prev = head;
    }

    int get(int key) {
        if (nodeByKey.find(key) == nodeByKey.end()) return -1;

        DoublyNode* node = nodeByKey[key];
        moveToFront(node);
        return node->value;
    }

    void put(int key, int value) {
        if (nodeByKey.find(key) != nodeByKey.end()) {
            DoublyNode* node = nodeByKey[key];
            node->value = value;
            moveToFront(node);
            return;
        }

        DoublyNode* node = new DoublyNode(key, value);
        nodeByKey[key] = node;
        insertAfterHead(node);

        if ((int)nodeByKey.size() > capacity) {
            DoublyNode* leastRecentlyUsed = tail->prev;
            removeNode(leastRecentlyUsed);
            nodeByKey.erase(leastRecentlyUsed->key);
            delete leastRecentlyUsed;
        }
    }
};

int main() {
    vector<int> values = {1, 2, 3, 4, 5};
    ListNode* head = buildList(values);

    cout << "Original list: ";
    printList(head);

    head = reverseList(head);
    cout << "Reversed list: ";
    printList(head);

    cout << "Middle node: " << middleNode(head)->val << '\n';

    ListNode* list1 = buildList({1, 3, 5});
    ListNode* list2 = buildList({2, 4, 6});
    ListNode* merged = mergeTwoSortedLists(list1, list2);

    cout << "Merged list: ";
    printList(merged);

    LRUCache cache(2);
    cache.put(1, 10);
    cache.put(2, 20);
    cout << "Get 1: " << cache.get(1) << '\n';
    cache.put(3, 30);
    cout << "Get 2: " << cache.get(2) << '\n';

    return 0;
}
```

Sample output:

```text
Original list: 1 -> 2 -> 3 -> 4 -> 5
Reversed list: 5 -> 4 -> 3 -> 2 -> 1
Middle node: 3
Merged list: 1 -> 2 -> 3 -> 4 -> 5 -> 6
Get 1: 10
Get 2: -1
```

## pYTHON IMPLEMENTATION

pROVIDE CLEAN PYTHON CODE

```python
class ListNode:
    def __init__(self, val=0, next=None):
        self.val = val
        self.next = next


class RandomNode:
    def __init__(self, val=0, next=None, random=None):
        self.val = val
        self.next = next
        self.random = random


def build_list(values):
    dummy = ListNode(0)
    tail = dummy

    for value in values:
        tail.next = ListNode(value)
        tail = tail.next

    return dummy.next


def print_list(head):
    values = []
    while head:
        values.append(str(head.val))
        head = head.next
    print(" -> ".join(values))


def reverse_list(head):
    previous = None
    current = head

    while current:
        next_node = current.next
        current.next = previous
        previous = current
        current = next_node

    return previous


def has_cycle(head):
    slow = head
    fast = head

    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next

        if slow is fast:
            return True

    return False


def detect_cycle_start(head):
    slow = head
    fast = head

    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next

        if slow is fast:
            pointer = head
            while pointer is not slow:
                pointer = pointer.next
                slow = slow.next
            return pointer

    return None


def middle_node(head):
    slow = head
    fast = head

    while fast and fast.next:
        slow = slow.next
        fast = fast.next.next

    return slow


def merge_two_sorted_lists(list1, list2):
    dummy = ListNode(0)
    tail = dummy

    while list1 and list2:
        if list1.val <= list2.val:
            tail.next = list1
            list1 = list1.next
        else:
            tail.next = list2
            list2 = list2.next
        tail = tail.next

    tail.next = list1 if list1 else list2
    return dummy.next


def remove_nth_from_end(head, n):
    dummy = ListNode(0, head)
    fast = dummy
    slow = dummy

    for _ in range(n):
        fast = fast.next

    while fast.next:
        fast = fast.next
        slow = slow.next

    slow.next = slow.next.next
    return dummy.next


def get_intersection_node(head_a, head_b):
    pointer_a = head_a
    pointer_b = head_b

    while pointer_a is not pointer_b:
        pointer_a = head_b if pointer_a is None else pointer_a.next
        pointer_b = head_a if pointer_b is None else pointer_b.next

    return pointer_a


def is_palindrome(head):
    if not head or not head.next:
        return True

    slow = head
    fast = head

    while fast.next and fast.next.next:
        slow = slow.next
        fast = fast.next.next

    second_half = reverse_list(slow.next)
    first_pointer = head
    second_pointer = second_half
    answer = True

    while second_pointer:
        if first_pointer.val != second_pointer.val:
            answer = False
            break
        first_pointer = first_pointer.next
        second_pointer = second_pointer.next

    slow.next = reverse_list(second_half)
    return answer


def reverse_k_group(head, k):
    if not head or k <= 1:
        return head

    dummy = ListNode(0, head)
    group_previous = dummy

    while True:
        kth = group_previous
        for _ in range(k):
            kth = kth.next
            if kth is None:
                return dummy.next

        group_next = kth.next
        previous = group_next
        current = group_previous.next

        while current is not group_next:
            next_node = current.next
            current.next = previous
            previous = current
            current = next_node

        old_group_head = group_previous.next
        group_previous.next = kth
        group_previous = old_group_head


def copy_random_list(head):
    if not head:
        return None

    copy_of = {}
    current = head

    while current:
        copy_of[current] = RandomNode(current.val)
        current = current.next

    current = head
    while current:
        copy_of[current].next = copy_of.get(current.next)
        copy_of[current].random = copy_of.get(current.random)
        current = current.next

    return copy_of[head]


class DLLNode:
    def __init__(self, key=0, value=0):
        self.key = key
        self.value = value
        self.prev = None
        self.next = None


class LRUCache:
    def __init__(self, capacity):
        self.capacity = capacity
        self.node_by_key = {}
        self.head = DLLNode()
        self.tail = DLLNode()
        self.head.next = self.tail
        self.tail.prev = self.head

    def _remove_node(self, node):
        node.prev.next = node.next
        node.next.prev = node.prev

    def _insert_after_head(self, node):
        node.next = self.head.next
        node.prev = self.head
        self.head.next.prev = node
        self.head.next = node

    def _move_to_front(self, node):
        self._remove_node(node)
        self._insert_after_head(node)

    def get(self, key):
        if key not in self.node_by_key:
            return -1

        node = self.node_by_key[key]
        self._move_to_front(node)
        return node.value

    def put(self, key, value):
        if key in self.node_by_key:
            node = self.node_by_key[key]
            node.value = value
            self._move_to_front(node)
            return

        node = DLLNode(key, value)
        self.node_by_key[key] = node
        self._insert_after_head(node)

        if len(self.node_by_key) > self.capacity:
            lru = self.tail.prev
            self._remove_node(lru)
            del self.node_by_key[lru.key]


if __name__ == "__main__":
    head = build_list([1, 2, 3, 4, 5])
    print("Original list:")
    print_list(head)

    head = reverse_list(head)
    print("Reversed list:")
    print_list(head)

    print("Middle node:", middle_node(head).val)

    list1 = build_list([1, 3, 5])
    list2 = build_list([2, 4, 6])
    merged = merge_two_sorted_lists(list1, list2)
    print("Merged list:")
    print_list(merged)

    cache = LRUCache(2)
    cache.put(1, 10)
    cache.put(2, 20)
    print("Get 1:", cache.get(1))
    cache.put(3, 30)
    print("Get 2:", cache.get(2))
```

## 10. Code Explanation

### ListNode

`ListNode` stores:

* `val`: the node value
* `next`: pointer/reference to the next node

This is the standard structure used by LeetCode, GFG, and interview problems.

### buildList / build_list

Creates a linked list from an array.

Why dummy node is used:

* It avoids checking whether the list is empty during insertion.
* `tail` always points to the last node.
* Final answer is `dummy.next`.

### printList / print_list

Traverses the list from head to end and prints values.

Important:

* This should not be used on a cyclic list unless cycle handling is added.
* Traversal ends only when the pointer becomes `NULL`/`None`.

### reverseList / reverse_list

Uses three pointers:

| Pointer | Meaning |
|---|---|
| `previous` | Head of reversed part |
| `current` | Node currently being processed |
| `nextNode` | Saves remaining list |

The order matters:

1. Save `current->next`.
2. Reverse `current->next`.
3. Move `previous`.
4. Move `current`.

If you reverse before saving `nextNode`, you lose access to the rest of the list.

### hasCycle

Uses Floyd's cycle detection.

If there is no cycle:

* `fast` reaches `NULL`.

If there is a cycle:

* `fast` eventually catches `slow`.

This works because fast reduces the distance to slow by one node per iteration inside the cycle.

### detectCycleStart

After slow and fast meet:

* Put one pointer at head.
* Keep the other at meeting point.
* Move both one step.

They meet at the cycle start.

This is a standard result of Floyd's algorithm and is heavily asked in interviews.

### middleNode

Fast moves twice as quickly as slow.

When fast reaches the end:

* Slow has covered half the distance.
* Slow points to the middle.

For even length lists, this implementation returns the second middle.

### mergeTwoSortedLists

Uses a dummy node and a tail pointer.

At every step:

* Compare current values.
* Attach smaller node.
* Move that list pointer.
* Move tail.

No new nodes are created; existing nodes are relinked.

### removeNthFromEnd

Uses a gap of `n` nodes between fast and slow.

When fast reaches the last node:

* slow is just before the node to delete.

Dummy node handles deletion of the original head.

Example:

```text
Remove 5th from end in 1 -> 2 -> 3 -> 4 -> 5
```

The deleted node is `1`, so head changes. Dummy makes this easy.

### getIntersectionNode

Two pointers traverse both lists.

If lists intersect:

* Both pointers travel equal total distance.
* They meet at intersection.

If not:

* Both become `NULL`.

No extra memory is needed.

### isPalindrome

Steps:

1. Find first half end.
2. Reverse second half.
3. Compare values.
4. Restore list.

Restoring is good interview practice because it avoids surprising side effects.

### reverseKGroup

Important details:

* Check if `k` nodes exist before reversing.
* Reverse only complete groups.
* Keep `groupPrevious` to connect groups.
* `oldGroupHead` becomes the tail after reversal.

This problem is pointer-heavy and excellent for interview preparation.

### copyRandomList

Hashmap approach:

* First pass creates copied nodes.
* Second pass connects `next` and `random`.

The map allows random pointers to be assigned even if they point forward, backward, or to the same node.

### LRUCache

Uses:

* Hashmap for O(1) key lookup.
* Doubly linked list for O(1) removal and insertion.

Two dummy nodes are used:

```text
head <-> most recent <-> ... <-> least recent <-> tail
```

On `get(key)`:

* If key missing, return `-1`.
* If present, move node to front and return value.

On `put(key, value)`:

* If key exists, update and move to front.
* If key does not exist, insert at front.
* If capacity is exceeded, remove node before tail.

## 11. Complexity Analysis

| Algorithm / Operation | Time Complexity | Space Complexity | Notes |
|---|---:|---:|---|
| Singly list traversal | O(n) | O(1) | Visits each node once |
| Insert after known node | O(1) | O(1) | Position must already be known |
| Delete after known node | O(1) | O(1) | Need previous node in singly list |
| Search by value | O(n) | O(1) | No random access |
| Reverse list | O(n) | O(1) | In-place |
| Detect cycle | O(n) | O(1) | Floyd's algorithm |
| Find cycle start | O(n) | O(1) | After meeting point |
| Find middle | O(n) | O(1) | Fast/slow pointers |
| Merge two sorted lists | O(n + m) | O(1) | Reuses nodes |
| Remove nth from end | O(n) | O(1) | One pass after gap |
| Intersection of lists | O(n + m) | O(1) | Pointer switching |
| Palindrome list | O(n) | O(1) | Reverse second half |
| Reverse k-group | O(n) | O(1) | Each node reversed once |
| Copy random pointer list | O(n) | O(n) | Hashmap method |
| Copy random pointer list, interleaving | O(n) | O(1) | More complex |
| Flatten multilevel list | O(n) | O(1) to O(depth) | Depends on iterative/recursive method |
| LRU `get` | O(1) | O(capacity) | Hashmap + DLL |
| LRU `put` | O(1) | O(capacity) | Hashmap + DLL |

Preprocessing:

* Most linked list problems do not require preprocessing.
* LRU cache initializes dummy head and tail in O(1).
* Copy random list builds a hashmap in O(n).

Best/worst cases:

| Problem | Best Case | Worst Case |
|---|---:|---:|
| Search | O(1), value at head | O(n), value absent/end |
| Cycle detection | O(1), tiny cycle | O(n) |
| Remove nth from end | O(n) | O(n) |
| Merge lists | O(min(n, m)) if one ends early, but links remaining | O(n + m) |

## 12. Common Patterns

| Pattern | How to Identify | General Approach | Example Problems |
|---|---|---|---|
| Pointer reversal | Need to reverse links | Use `prev`, `curr`, `next` | Reverse Linked List, Reverse k-Group |
| Fast and slow pointers | Middle, cycle, half split | Move one pointer faster | Linked List Cycle, Middle of Linked List |
| Dummy node | Head may change | Use fake node before head | Merge Lists, Remove Nth From End |
| Two list pointer switching | Intersection of lists | Traverse A+B and B+A | Intersection of Two Linked Lists |
| Merge pattern | Sorted linked lists | Compare heads, attach smaller | Merge Two Sorted Lists |
| Split and reverse | Palindrome or reorder | Find middle, reverse half | Palindrome Linked List, Reorder List |
| Hashmap with nodes | Need clone or O(1) access | Map original/key to node | Copy Random Pointer, LRU Cache |
| DLL remove and insert | Need O(1) deletion and move | Maintain `prev` and `next` | LRU Cache |
| Group processing | Reverse/process k nodes | Check group length first | Reverse Nodes in k-Group |
| Flattening | Nodes have child/bottom links | DFS/stack/merge | Flatten Multilevel DLL, Flatten Sorted LL |

## 13. Common Mistakes

* Forgetting to save `nextNode` before changing `current->next`.
* Returning old head after reversal instead of new head.
* Not using a dummy node when deletion may affect head.
* Moving `fast` incorrectly in remove nth node problem.
* Using `while (fast && fast->next)` when a problem expects first middle instead of second middle.
* Comparing node values instead of node addresses in intersection problems.
* Using a visited set for cycle detection when O(1) space is expected.
* Forgetting to attach the remaining list after merging.
* Losing the original second half in palindrome check.
* Not restoring the list after palindrome check when required.
* Reversing incomplete k-groups in reverse k-group.
* Forgetting to update both `prev` and `next` in a doubly linked list.
* In LRU cache, updating hashmap but not moving node to front.
* In LRU cache, deleting tail dummy instead of `tail->prev`.
* In copy random pointer, assigning random pointers before all copied nodes exist.
* Using recursion for very long lists and causing stack overflow.
* Infinite loop while printing/traversing a cyclic list.

## 14. Edge Cases

Important edge cases to test:

| Case | Example | Why Important |
|---|---|---|
| Empty list | `head = NULL` | Should not dereference null |
| Single node | `1` | Reverse, middle, palindrome should work |
| Two nodes | `1 -> 2` | Common pointer boundary bugs |
| All equal values | `2 -> 2 -> 2` | Palindrome and merge comparisons |
| Already sorted | `1 -> 2 -> 3` | Merge and traversal |
| Reverse sorted | `3 -> 2 -> 1` | Sorting/merge assumptions |
| Delete head | Remove nth where `n = length` | Requires dummy node |
| Delete tail | `n = 1` | Tail update |
| Cycle at head | `tail->next = head` | Cycle start detection |
| Cycle in middle | `tail->next = node 3` | Standard case |
| No cycle | `1 -> 2 -> NULL` | Fast reaches null |
| Odd length | `1 -> 2 -> 3` | Middle is unique |
| Even length | `1 -> 2 -> 3 -> 4` | First/second middle decision |
| Duplicate values | `1 -> 2 -> 1 -> 2` | Intersection must compare addresses |
| Negative values | `-3 -> -1 -> 2` | Values do not affect pointers |
| Large list | `10^5` nodes | Avoid recursion unless safe |
| Random points to self | `node.random = node` | Copy random pointer edge case |
| Random is NULL | `node.random = NULL` | Map lookup must handle null |
| LRU capacity 1 | Only one item allowed | Eviction every new key |

## 15. Variations

### Singly Linked List

Only forward traversal is possible.

Used for:

* Basic linked list problems
* Reversal
* Cycle detection
* Merge lists

Importance:

* Very important for placements and CP.

### Doubly Linked List

Each node stores `prev` and `next`.

Used for:

* LRU cache
* Browser history
* Deque-like operations
* O(1) removal with node pointer

Importance:

* Very important for system-design-flavored DSA questions like LRU.

### Circular Linked List

Last node points back to an earlier node, often the head.

Used for:

* Cycle problems
* Round-robin scheduling
* Josephus problem variants

Importance:

* Medium for placements, useful for understanding cycles.

### Reverse Linked List Recursively

Uses recursion instead of iterative pointers.

What changes:

* Call recursively until tail.
* Reverse links while returning.

Importance:

* Good for interviews, but iterative is safer for large CP constraints.

### Reverse Nodes in k-Group

Reverse only groups of size `k`.

Used when:

* Problem asks group-wise reversal.
* Remaining nodes should stay unchanged.

Importance:

* High for placements.

### Copy Random Pointer List

Nodes have `random` pointer.

Used when:

* Deep copy with arbitrary references is required.

Importance:

* High for placements.

### Flatten Multilevel Doubly Linked List

Nodes may have child lists.

Used when:

* List structure behaves like DFS traversal.

Importance:

* Medium to high for interviews.

### Flatten Sorted Linked List with Bottom Pointer

Each node may point down to a sorted list.

Used when:

* Need merge-like flattening of sorted chains.

Importance:

* Common on GFG and placement sheets.

### LRU Cache

Combines doubly linked list and hashmap.

Used when:

* Need O(1) `get` and `put`.
* Need to evict least recently used item.

Importance:

* Very high for placements.

## 16. Related Algorithms/Data Structures

| Related Topic | Connection | How to Choose |
|---|---|---|
| Array/vector | Stores linear data | Choose array when random access matters |
| Stack | LIFO behavior | Choose stack for undo, brackets, DFS |
| Queue | FIFO behavior | Choose queue for BFS/order processing |
| Deque | Insert/delete both ends | Choose deque over DLL unless custom node removal is needed |
| Hashmap | O(1) key lookup | Combine with DLL for LRU |
| Recursion | Natural for list reversal/DFS flattening | Avoid if list can be very large |
| Two pointers | Core linked-list technique | Use for middle, cycle, nth from end |
| Merge sort | Efficient linked-list sorting | Splitting uses fast/slow pointers |
| Heap | Repeated minimum extraction | Use for merging k sorted lists |
| Balanced BST | Sorted dynamic keys | Use when order queries are needed |

Linked list vs array:

| Feature | Linked List | Array/vector |
|---|---|---|
| Random access | O(n) | O(1) |
| Insert/delete after known node | O(1) | O(n) |
| Memory locality | Poor | Good |
| Extra memory per element | Pointer overhead | Low |
| Binary search | Inefficient | Efficient |

Singly vs doubly linked list:

| Feature | Singly LL | Doubly LL |
|---|---|---|
| Memory | Lower | Higher |
| Backward traversal | No | Yes |
| Delete known node | Hard without previous | Easy |
| LRU cache | Not ideal | Best fit |

## 17. Practice Problems

### Easy

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Reverse Linked List | LeetCode 206 | Pointer reversal | Easy |
| Middle of the Linked List | LeetCode 876 | Fast and slow pointers | Easy |

### Medium

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Linked List Cycle II | LeetCode 142 | Floyd cycle start | Medium |
| Remove Nth Node From End of List | LeetCode 19 | Two pointers with gap | Medium |
| Copy List with Random Pointer | LeetCode 138 | Hashmap/deep copy | Medium |

### Hard

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Reverse Nodes in k-Group | LeetCode 25 | Group reversal | Hard |
| Merge k Sorted Lists | LeetCode 23 | Heap or divide and conquer | Hard |
| LRU Cache | LeetCode 146 | DLL + hashmap | Medium/Hard in interviews |

Additional useful problems:

| Problem | Platform | Main Idea/Pattern | Difficulty |
|---|---|---|---|
| Merge Two Sorted Lists | LeetCode 21 | Dummy node merge | Easy |
| Intersection of Two Linked Lists | LeetCode 160 | Pointer switching | Easy |
| Palindrome Linked List | LeetCode 234 | Reverse second half | Easy/Medium |
| Flattening a Linked List | GFG | Merge bottom lists | Medium |
| Flatten a Multilevel Doubly Linked List | LeetCode 430 | DFS/splicing | Medium |

## 18. Interview Explanation

A linked list is a sequence of nodes where each node stores data and a pointer to the next node. Unlike arrays, linked lists do not support O(1) random access, but they allow efficient insertion and deletion when we already have the node position. Most linked list problems are solved by careful pointer manipulation. I usually use dummy nodes when the head may change, fast and slow pointers for middle or cycle problems, and `prev-current-next` pointers for reversal. For LRU cache, I combine a hashmap with a doubly linked list so that lookup, deletion, and moving a node to the most recently used position all happen in O(1).

## 19. Revision Notes

* Key idea: linked list problems are mostly pointer manipulation.
* Always save `nextNode` before changing `current->next`.
* Reverse template: `prev = NULL`, `curr = head`, loop until `curr == NULL`.
* Cycle detection: slow moves 1, fast moves 2.
* Middle node: slow/fast pointer; even length returns second middle in standard template.
* Remove nth from end: use dummy + gap of `n`.
* Merge lists: use dummy + tail.
* Intersection: compare node addresses, not values.
* Palindrome: find middle, reverse second half, compare, restore.
* k-group reversal: check k nodes exist before reversing.
* Copy random pointer: hashmap is easiest; interleaving gives O(1) extra space.
* LRU cache: hashmap + doubly linked list with dummy head/tail.
* Complexity for most linked-list algorithms: O(n) time, O(1) extra space.
* Common trap: losing part of the list after pointer update.
* Common trap: infinite loop on cyclic list.
* Common trap: forgetting head can change.

## 20. Final Cheat Sheet

| Topic | Cheat Sheet |
|---|---|
| When to use | Problems involving `ListNode`, in-place deletion/reversal, cycle detection, middle node, LRU cache |
| Main operations | Traverse, insert, delete, reverse, merge, split, detect cycle |
| Reverse key idea | Save next, point current to previous, move both pointers |
| Fast/slow key idea | Slow moves 1 step, fast moves 2 steps |
| Dummy node use | When head can change: merge, delete, k-group |
| Cycle detection | If slow meets fast, cycle exists |
| Find middle | When fast reaches end, slow is middle |
| Remove nth from end | Maintain gap of `n` between fast and slow |
| Merge lists | Attach smaller node to tail each time |
| Intersection | Traverse A+B and B+A; compare addresses |
| Palindrome | Reverse second half and compare |
| k-group | Reverse only if k nodes are available |
| Copy random pointer | Map original node to copied node |
| LRU cache | Hashmap gives lookup, DLL gives O(1) remove/move |
| Singly LL complexity | Search O(n), insert/delete after known node O(1) |
| Doubly LL complexity | Delete known node O(1), extra memory for `prev` |
| LRU complexity | `get` O(1), `put` O(1), space O(capacity) |
| Important edge cases | Empty list, one node, two nodes, delete head, cycle at head, even length, duplicate values, capacity 1 |
| Most important templates | Reverse list, fast/slow, dummy merge, remove nth, LRU DLL operations |

