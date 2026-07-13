# C++ Language Basics

## 1. Overview

C++ language basics are the foundational rules that control how C++ code is written, compiled, organized, and interpreted by the compiler.

This guide covers:

* Compilation process
* Headers
* Namespaces
* References
* Pointers
* `const`
* `static`
* `inline`
* `typedef` / `using`
* `auto`

### Definition

These are core C++ features that help you:

* Convert source code into an executable program
* Reuse declarations across files
* Manage names and avoid conflicts
* Work with memory addresses and aliases
* Express immutability and lifetime
* Improve code readability and type safety

### Why It Matters

C++ gives direct control over memory, object lifetime, compilation, and performance. These language basics are the tools you use every day to write correct and efficient C++ programs.

### Where It Is Used In Real Systems

These concepts appear in:

* Operating system kernels
* Game engines
* Database engines
* Browsers
* Trading systems
* Embedded software
* Backend systems written in performance-critical C++

### Why Interviewers Ask About It

Interviewers ask these topics because they reveal whether you understand C++ beyond syntax. They test:

* Memory understanding
* Compiler behavior
* Object lifetime
* Function call semantics
* Header/source organization
* Difference between declaration and definition
* Ability to debug tricky C++ code

## 2. Core Idea

The core idea of C++ language basics is this:

> C++ code is not just executed. It is first translated, checked, linked, and then run. The language gives you tools to control names, types, memory, object lifetime, and performance.

### Intuition

Think of a C++ program as a large machine built from many parts.

* Headers describe what parts exist.
* Source files implement how those parts work.
* The compiler checks and converts each source file.
* The linker connects all compiled parts.
* Pointers and references connect data efficiently.
* `const`, `static`, `inline`, `using`, and `auto` help control meaning, lifetime, visibility, and readability.

### Real-World Analogy

Building a C++ program is like building a car:

| C++ Concept | Car Analogy |
|---|---|
| Header file | Blueprint |
| Source file | Actual manufacturing |
| Compiler | Factory machine |
| Linker | Final assembly line |
| Namespace | Department name |
| Pointer | Address of a part |
| Reference | Another name for the same part |
| `const` | Do not modify sticker |
| `static` | Shared or long-lived component |
| `inline` | Small part inserted directly |
| `using` | Short name for a long part name |
| `auto` | Let the expert infer the type |

### Small Example

```cpp
#include <iostream>
using namespace std;

int add(const int& a, const int& b) {
    return a + b;
}

int main() {
    int x = 10;
    int y = 20;
    int* ptr = &x;

    cout << add(x, y) << endl;
    cout << *ptr << endl;

    return 0;
}
```

### Step-By-Step Explanation

1. `#include <iostream>` asks the preprocessor to include declarations for input/output.
2. `using namespace std;` allows using `cout` instead of `std::cout`.
3. `const int& a` passes an integer by reference without allowing modification.
4. `int* ptr = &x;` stores the address of `x`.
5. `*ptr` accesses the value stored at that address.
6. The compiler translates this code into object code.
7. The linker connects it with library code.
8. The final executable runs.

## 3. Important Subtopics

### 3.1 Compilation Process

#### What It Means

Compilation is the process of converting C++ source code into an executable program.

Main stages:

1. Preprocessing
2. Compilation
3. Assembly
4. Linking

#### Why It Matters

Many C++ errors are compilation or linking errors, not runtime errors. Understanding this helps debug problems like:

* Missing headers
* Multiple definitions
* Undefined references
* Include cycles
* Template errors

#### Example

```cpp
// math.h
int add(int a, int b);

// math.cpp
int add(int a, int b) {
    return a + b;
}

// main.cpp
#include "math.h"

int main() {
    return add(2, 3);
}
```

`main.cpp` knows `add` exists because of the header. The linker finds its actual implementation in `math.cpp`.

#### Common Interview Angle

Interviewers often ask:

> What is the difference between compilation error and linker error?

Key idea:

* Compilation error: compiler cannot understand a source file.
* Linker error: compiler understood files, but linker cannot connect definitions.

### 3.2 Headers

#### What It Means

A header file usually contains declarations that can be shared across source files.

Common header contents:

* Function declarations
* Class declarations
* Constants
* Templates
* Inline functions
* Type aliases

#### Why It Matters

Headers allow modular programming. Without headers, each source file would not know the interfaces of other files.

#### Example

```cpp
// user.h
#ifndef USER_H
#define USER_H

#include <string>

struct User {
    std::string name;
    int age;
};

#endif
```

#### Common Interview Angle

Interviewers may ask why include guards are needed.

Answer:

> Include guards prevent the same header from being included multiple times in one translation unit.

### 3.3 Namespaces

#### What It Means

A namespace groups names and avoids naming conflicts.

#### Why It Matters

Large projects may have thousands of functions and classes. Namespaces prevent collisions.

#### Example

```cpp
namespace payment {
    void process() {}
}

namespace notification {
    void process() {}
}

int main() {
    payment::process();
    notification::process();
}
```

#### Common Interview Angle

Interviewers ask why `using namespace std;` is discouraged in headers.

Answer:

> It pollutes every file that includes the header and can create name conflicts.

### 3.4 References

#### What It Means

A reference is an alias for an existing variable.

#### Why It Matters

References allow efficient parameter passing and modification of original objects.

#### Example

```cpp
void increment(int& x) {
    x++;
}

int main() {
    int a = 5;
    increment(a);
}
```

`x` is another name for `a`.

#### Common Interview Angle

Common question:

> Difference between pointer and reference?

Key points:

* Reference must be initialized.
* Reference usually cannot be reseated.
* Pointer can be null.
* Pointer stores an address explicitly.

### 3.5 Pointers

#### What It Means

A pointer is a variable that stores the memory address of another variable.

#### Why It Matters

Pointers are used for:

* Dynamic memory
* Data structures
* System programming
* Passing large objects efficiently
* Optional values
* Low-level APIs

#### Example

```cpp
int x = 10;
int* p = &x;

cout << p << endl;   // address
cout << *p << endl;  // value at address
```

#### Common Interview Angle

Interviewers ask about:

* Null pointers
* Dangling pointers
* Pointer arithmetic
* `new` and `delete`
* Difference between `int* p`, `int *p`, and `int * p`

### 3.6 `const`

#### What It Means

`const` means the value should not be modified through that name.

#### Why It Matters

It improves safety, documentation, and compiler checks.

#### Example

```cpp
void printName(const string& name) {
    cout << name << endl;
}
```

The function promises not to modify `name`.

#### Common Interview Angle

Interviewers often ask about:

```cpp
const int* p;
int* const p;
const int* const p;
```

Meaning:

| Declaration | Meaning |
|---|---|
| `const int* p` | Pointer to constant integer |
| `int* const p` | Constant pointer to integer |
| `const int* const p` | Constant pointer to constant integer |

### 3.7 `static`

#### What It Means

`static` changes lifetime, linkage, or sharing depending on where it is used.

#### Why It Matters

It controls whether something is:

* Preserved across function calls
* Shared among class objects
* Hidden inside one source file

#### Example

```cpp
void counter() {
    static int count = 0;
    count++;
    cout << count << endl;
}
```

`count` is initialized once and remembers its value between calls.

#### Common Interview Angle

Interviewers ask:

> What is the difference between local static variable and global static variable?

Answer:

* Local static: function scope, static lifetime.
* File-scope static: internal linkage, visible only in that source file.

### 3.8 `inline`

#### What It Means

`inline` suggests that a function can be defined in multiple translation units without violating the One Definition Rule, if definitions are identical.

It may also allow the compiler to replace a function call with function body code, but modern compilers decide optimization themselves.

#### Why It Matters

It is important for defining small functions in headers.

#### Example

```cpp
inline int square(int x) {
    return x * x;
}
```

#### Common Interview Angle

Common mistake:

> `inline` always forces function inlining.

Correct answer:

> No. It permits certain definitions in headers and only suggests optimization. The compiler decides whether to inline the call.

### 3.9 `typedef` and `using`

#### What It Means

Both create type aliases.

#### Why It Matters

They make complex types easier to read and maintain.

#### Example

```cpp
typedef long long ll;
using ll2 = long long;

using UserMap = unordered_map<int, string>;
```

#### Common Interview Angle

Interviewers ask why `using` is often preferred in modern C++.

Answer:

> `using` is more readable and supports alias templates.

### 3.10 `auto`

#### What It Means

`auto` asks the compiler to infer the variable type from the initializer.

#### Why It Matters

It reduces verbosity and prevents mistakes with complex iterator or template types.

#### Example

```cpp
vector<int> nums = {1, 2, 3};

for (auto x : nums) {
    cout << x << endl;
}
```

#### Common Interview Angle

Interviewers ask whether `auto` makes C++ dynamically typed.

Answer:

> No. `auto` is compile-time type deduction. The type is fixed after compilation.

## 4. Real-World Example

### Backend Server Module

Suppose a backend server has a user authentication module.

```cpp
// auth.h
#ifndef AUTH_H
#define AUTH_H

#include <string>

namespace auth {
    using UserId = long long;

    bool validateToken(const std::string& token);
    UserId getUserId(const std::string& token);
}

#endif
```

```cpp
// auth.cpp
#include "auth.h"
#include <unordered_map>

namespace {
    static std::unordered_map<std::string, auth::UserId> tokenStore;
}

namespace auth {
    bool validateToken(const std::string& token) {
        return tokenStore.find(token) != tokenStore.end();
    }

    UserId getUserId(const std::string& token) {
        return tokenStore[token];
    }
}
```

Concepts used:

| Concept | Usage |
|---|---|
| Header | Exposes module interface |
| Namespace | Groups authentication code |
| `using` | Creates readable `UserId` alias |
| `const string&` | Avoids copying token |
| `static` | Keeps storage internal |
| Compilation | `auth.cpp` and `main.cpp` compile separately |
| Linking | Final executable connects function calls |

## 5. Diagrams / Mental Models

### Compilation Flow

```text
source.cpp
   |
   v
Preprocessor
   |
   | expands #include, #define
   v
Expanded source
   |
   v
Compiler
   |
   | checks syntax and types
   v
Assembly / object code
   |
   v
Assembler
   |
   v
object file (.o / .obj)
   |
   v
Linker
   |
   | connects object files and libraries
   v
Executable
```

### Pointer Mental Model

```text
int x = 10;
int* p = &x;

Memory:

Address  Value
1000     10      <- x

p stores 1000
*p gives 10
```

### Reference Mental Model

```text
int a = 5;
int& r = a;

a and r are two names for the same object.

a ----\
       > same memory location
r ----/
```

### `const` Pointer Reading Rule

Read from right to left:

```cpp
const int* p;        // p points to int that is const through p
int* const p;        // p is const pointer to int
const int* const p;  // p is const pointer to const int
```

## 6. Common Interview Questions

### 1. What are the stages of C++ compilation?

Answer:

C++ compilation has preprocessing, compilation, assembly, and linking.

Key points interviewer expects:

* Preprocessor handles `#include` and macros.
* Compiler checks syntax and generates object code.
* Linker connects object files and libraries.

Common mistakes:

* Saying compilation directly creates executable.
* Ignoring linking.

### 2. What is the difference between declaration and definition?

Answer:

A declaration tells the compiler that something exists. A definition actually creates it or provides its body.

```cpp
int add(int, int);        // declaration
int add(int a, int b) {   // definition
    return a + b;
}
```

Key points:

* Declaration introduces name and type.
* Definition allocates storage or provides implementation.

Common mistakes:

* Treating every declaration as a definition.

### 3. Why do we use header files?

Answer:

Header files share declarations across multiple source files.

Key points:

* Enable modular programming.
* Avoid repeating declarations.
* Usually contain interfaces, not implementation.

Common mistakes:

* Putting non-inline function definitions in headers.

### 4. What are include guards?

Answer:

Include guards prevent a header from being processed multiple times in the same translation unit.

```cpp
#ifndef FILE_H
#define FILE_H

// content

#endif
```

Key points:

* Avoid duplicate declarations.
* Prevent redefinition errors.

Common mistakes:

* Thinking include guards prevent linking errors across files.

### 5. What is a namespace?

Answer:

A namespace groups related names and prevents naming conflicts.

Key points:

* Used in large projects.
* `std` is the standard library namespace.
* Avoid `using namespace std;` in headers.

Common mistakes:

* Saying namespaces improve runtime performance.

### 6. What is the difference between pointer and reference?

Answer:

A pointer stores an address. A reference is an alias for an existing object.

Key points:

* Pointer can be null.
* Reference must be initialized.
* Pointer can be reassigned.
* Reference usually cannot be reseated.

Common mistakes:

* Saying references are always implemented differently from pointers.
* Forgetting null pointer possibility.

### 7. What is a dangling pointer?

Answer:

A dangling pointer points to memory that is no longer valid.

```cpp
int* p;
{
    int x = 10;
    p = &x;
}
// p is dangling here
```

Key points:

* Accessing it causes undefined behavior.
* Common after returning address of local variable or deleting memory.

Common mistakes:

* Calling every null pointer dangling.

### 8. What does `const int* p` mean?

Answer:

It means `p` is a pointer to an integer that cannot be modified through `p`.

```cpp
const int* p = &x;
```

Key points:

* `p` can point somewhere else.
* `*p` cannot be modified through `p`.

Common mistakes:

* Saying the pointer itself is constant.

### 9. What is a static local variable?

Answer:

A static local variable is initialized once and keeps its value between function calls.

```cpp
void f() {
    static int count = 0;
    count++;
}
```

Key points:

* Scope is local to function.
* Lifetime is entire program.

Common mistakes:

* Saying it is recreated on every call.

### 10. What is the purpose of `inline`?

Answer:

`inline` allows a function definition to appear in multiple translation units if identical. It can also suggest call expansion, but the compiler decides optimization.

Key points:

* Useful in headers.
* Does not force inlining.
* Helps avoid multiple definition errors for header-defined functions.

Common mistakes:

* Saying inline always improves performance.

### 11. What is the difference between `typedef` and `using`?

Answer:

Both create aliases, but `using` is modern, more readable, and supports alias templates.

Key points:

* `typedef long long ll;`
* `using ll = long long;`
* Prefer `using` in modern C++.

Common mistakes:

* Saying `using` creates a new type. It creates an alias.

### 12. What does `auto` do in C++?

Answer:

`auto` lets the compiler deduce the variable type from its initializer at compile time.

Key points:

* C++ remains statically typed.
* Type is fixed after deduction.
* Useful for iterators and complex template types.

Common mistakes:

* Saying `auto` is like JavaScript `var`.

## 7. Deep-Dive Questions

### 1. What is the One Definition Rule?

Answer:

The One Definition Rule says that entities like functions and variables must have exactly one definition in the program, with some exceptions such as inline functions, templates, and certain constants.

Why it matters:

* Prevents linker conflicts.
* Explains why non-inline function definitions should not usually be placed in headers.

### 2. Why can templates be defined in headers?

Answer:

Templates are instantiated when used. The compiler needs the full template definition at the point of instantiation, so templates are usually placed in headers.

### 3. What is internal linkage?

Answer:

Internal linkage means a name is visible only within one translation unit.

Example:

```cpp
static int counter = 0;
```

At file scope, `static` gives internal linkage.

### 4. Can a reference be null?

Answer:

A normal reference should always refer to a valid object. Unlike pointers, references are not meant to be null. Forcing a null reference through unsafe code causes undefined behavior.

### 5. How does `auto` handle references and `const`?

Answer:

Plain `auto` usually drops top-level `const` and reference.

```cpp
const int x = 10;
auto a = x;        // int
const auto b = x;  // const int

int y = 5;
int& r = y;
auto c = r;        // int
auto& d = r;       // int&
```

Use `auto&`, `const auto&`, or `auto&&` when reference behavior matters.

## 8. Comparison Tables

### Declaration vs Definition

| Feature | Declaration | Definition |
|---|---|---|
| Meaning | Announces existence | Provides actual entity |
| Memory allocated? | Usually no | Often yes |
| Function body? | No | Yes |
| Can appear multiple times? | Usually yes | Usually once |
| Example | `int add(int, int);` | `int add(int a, int b) { return a + b; }` |

### Pointer vs Reference

| Feature | Pointer | Reference |
|---|---|---|
| Stores address | Yes | Conceptually alias |
| Can be null | Yes | Not normally |
| Must initialize | No | Yes |
| Can reseat | Yes | No |
| Syntax for access | `*p`, `p->x` | Direct access |
| Common use | Dynamic memory, optional values | Parameter passing, aliases |

### `const int*` vs `int* const`

| Declaration | Pointer can change? | Value through pointer can change? |
|---|---:|---:|
| `const int* p` | Yes | No |
| `int* const p` | No | Yes |
| `const int* const p` | No | No |

### `static` Uses

| Location | Meaning |
|---|---|
| Inside function | Static lifetime, local scope |
| File scope | Internal linkage |
| Class data member | Shared by all objects |
| Class member function | Can be called without object; no `this` pointer |

### `typedef` vs `using`

| Feature | `typedef` | `using` |
|---|---|---|
| Style | C-style legacy | Modern C++ |
| Readability | Worse for complex types | Better |
| Alias templates | Not supported directly | Supported |
| Recommended today | Less preferred | Preferred |

### `auto` vs Explicit Type

| Feature | `auto` | Explicit Type |
|---|---|---|
| Readability | Good for complex types | Good for simple obvious types |
| Type control | Inferred | Written directly |
| Risk | May hide copies or lost references | Can be verbose |
| Best use | Iterators, lambdas, templates | Public interfaces, simple variables |

## 9. Common Mistakes

* Thinking headers are compiled independently like source files.
* Putting ordinary function definitions in headers without `inline`.
* Using `using namespace std;` in header files.
* Confusing pointer address with pointer value.
* Dereferencing null or dangling pointers.
* Returning reference or pointer to a local variable.
* Thinking references can be freely reassigned.
* Misreading `const int*` and `int* const`.
* Believing `inline` always improves performance.
* Assuming `static` means the same thing everywhere.
* Thinking `auto` makes C++ dynamically typed.
* Forgetting `auto` may copy values unless `auto&` is used.

## 10. Edge Cases / Special Cases

### Header Definitions

This can cause linker errors:

```cpp
// bad in header
int add(int a, int b) {
    return a + b;
}
```

If included in multiple `.cpp` files, multiple definitions may occur.

Better:

```cpp
inline int add(int a, int b) {
    return a + b;
}
```

### Returning Local Address

```cpp
int* bad() {
    int x = 10;
    return &x;
}
```

`x` is destroyed when the function returns. The returned pointer is dangling.

### Reference Lifetime Extension

```cpp
const string& s = string("hello");
```

A temporary bound to a `const` reference can have its lifetime extended in specific cases.

### `auto` Copy Trap

```cpp
vector<int> v = {1, 2, 3};

for (auto x : v) {
    x++; // modifies copy
}

for (auto& x : v) {
    x++; // modifies original
}
```

### `static` Initialization

Function-local static variables are initialized the first time control reaches their declaration.

```cpp
void f() {
    static int x = expensiveCall();
}
```

### Macro vs Inline

Macros are preprocessor text substitution. Inline functions are real typed functions.

Prefer:

```cpp
inline int square(int x) {
    return x * x;
}
```

Avoid:

```cpp
#define SQUARE(x) x * x
```

`SQUARE(1 + 2)` becomes `1 + 2 * 1 + 2`, which is wrong.

## 11. How to Explain in Interview

C++ language basics are the foundation of how C++ code is organized, compiled, and executed. A C++ program goes through preprocessing, compilation, assembly, and linking. Headers expose declarations, source files provide definitions, and namespaces avoid name conflicts. References act as aliases, while pointers store addresses and are useful for memory-level programming. `const` protects values from modification, `static` controls lifetime or linkage, `inline` helps define small functions in headers, `using` creates readable type aliases, and `auto` allows compile-time type deduction. These features matter because they affect correctness, performance, memory safety, and code organization.

## 12. Quick Revision Notes

### Key Definitions

| Term | Meaning |
|---|---|
| Preprocessor | Handles `#include`, macros, conditional compilation |
| Compiler | Converts source code to object code |
| Linker | Connects object files and libraries |
| Header | Shared declaration file |
| Namespace | Named scope to avoid conflicts |
| Pointer | Variable storing address |
| Reference | Alias for existing object |
| `const` | Prevents modification through a name |
| `static` | Controls lifetime, linkage, or sharing |
| `inline` | Allows identical definitions in multiple translation units |
| `using` | Modern type alias syntax |
| `auto` | Compile-time type deduction |

### Important Points

* Headers usually contain declarations.
* Source files contain definitions.
* Pointers can be null; references normally cannot.
* `const int*` and `int* const` are different.
* `static` has different meanings in different contexts.
* `inline` does not force optimization.
* `auto` is not dynamic typing.

### Common Comparisons

* Pointer vs reference
* Declaration vs definition
* `const int*` vs `int* const`
* `typedef` vs `using`
* `auto` vs explicit type
* Compilation error vs linker error

### Must-Remember Facts

* Undefined reference usually means linker problem.
* Redefinition usually means duplicate definition.
* Never return address/reference of a local variable.
* Avoid `using namespace std;` in headers.
* Use `const auto&` in range loops when avoiding copies.

### Interview Traps

* `inline` is more about ODR/linkage than guaranteed speed.
* `auto` can silently copy.
* A reference is not meant to be null.
* `static` inside function is not the same as static class member.
* Header guards prevent repeated inclusion in one translation unit, not all linker issues.

## 13. Practice Tasks

### Task 1: Trace Compilation

Create three files:

```cpp
// math.h
int add(int a, int b);
```

```cpp
// math.cpp
#include "math.h"

int add(int a, int b) {
    return a + b;
}
```

```cpp
// main.cpp
#include <iostream>
#include "math.h"

int main() {
    std::cout << add(2, 3);
}
```

Explain:

* What each file contains
* What the compiler sees
* What the linker connects

### Task 2: Pointer Practice

Write a program that:

* Creates an integer
* Stores its address in a pointer
* Prints the address
* Prints the value using dereferencing
* Modifies the value through the pointer

### Task 3: Reference Practice

Write:

```cpp
void swapValues(int& a, int& b);
```

Then explain why references are useful here.

### Task 4: `const` Practice

For each declaration, explain what can and cannot be changed:

```cpp
const int* a;
int* const b;
const int* const c;
```

### Task 5: `static` Practice

Write a function:

```cpp
void visitCounter();
```

It should print how many times it has been called.

### Task 6: `auto` Practice

Use `auto`, `auto&`, and `const auto&` in a range-based loop over a vector. Observe when the original vector changes.

### Task 7: Header Mistake Debugging

Put a normal function definition in a header and include it in two `.cpp` files. Observe the linker error. Then fix it using `inline` or by moving the definition to a `.cpp` file.

## 14. Final Cheat Sheet

### Core Definition

C++ language basics are the rules and features that control compilation, code organization, names, memory access, type aliases, constants, object lifetime, and type deduction.

### Why It Matters

They directly affect correctness, performance, debugging, modularity, and memory safety.

### Most Asked Questions

* What are the stages of compilation?
* Declaration vs definition?
* Pointer vs reference?
* What is a dangling pointer?
* What does `const int*` mean?
* What is static local variable?
* Why avoid `using namespace std;` in headers?
* What does `inline` really do?
* `typedef` vs `using`?
* Does `auto` make C++ dynamically typed?

### Common Comparisons

| Comparison | One-Line Difference |
|---|---|
| Pointer vs Reference | Pointer stores address; reference is alias |
| Declaration vs Definition | Declaration announces; definition creates |
| `const int*` vs `int* const` | First protects value; second protects pointer |
| `typedef` vs `using` | Both alias types; `using` is modern and clearer |
| `auto` vs explicit type | `auto` infers; explicit type is written |
| Compile error vs Linker error | Compile error is per source file; linker error is connecting files |

### One-Line Interview Answer

C++ language basics define how code is compiled and organized, how names and types are managed, and how memory is accessed safely using concepts like headers, namespaces, references, pointers, `const`, `static`, `inline`, `using`, and `auto`.
