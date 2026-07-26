# Semantic Analysis (Compiler Design) - Complete Interview Guide

> **Phase of the compiler:** After lexical analysis (tokens) and syntax analysis (parse tree), the compiler runs **semantic analysis** to check *meaning* - "Is this syntactically-valid program actually valid?" It catches things a grammar cannot: undeclared variables, type mismatches, wrong number of function arguments, etc.
>
> This guide covers 12 core sub-topics, each with the same 14-section deep-dive structure, tuned for SDE placements, online assessments, and technical interviews.

---

## Table of Contents

1. [Type Checking](#1-type-checking)
2. [Scope Checking](#2-scope-checking)
3. [Symbol Tables](#3-symbol-tables)
4. [Static vs Dynamic Typing](#4-static-vs-dynamic-typing)
5. [Type Conversion](#5-type-conversion)
6. [Type Coercion](#6-type-coercion)
7. [Syntax-Directed Definitions (SDD)](#7-syntax-directed-definitions-sdd)
8. [Attribute Grammars](#8-attribute-grammars)
9. [Type Inference Basics](#9-type-inference-basics)
10. [Overloading Resolution](#10-overloading-resolution)
11. [Name Binding](#11-name-binding)
12. [Dependent Types Basics](#12-dependent-types-basics)

---

## Where Semantic Analysis Sits (Big Picture)

```
Source code
   │
   ▼
[ Lexical Analyzer ]  ──►  tokens
   │
   ▼
[ Syntax Analyzer  ]  ──►  parse tree / AST      (checks GRAMMAR / structure)
   │
   ▼
[ SEMANTIC ANALYZER ]  ──►  annotated AST + symbol table   (checks MEANING)
   │   • type checking
   │   • scope checking
   │   • name binding
   │   • overloading resolution
   ▼
[ Intermediate Code Gen ] ──► IR
   │
   ▼
[ Optimizer ] ──► [ Code Generator ] ──► machine code
```

**Key one-liner:** *Syntax analysis asks "is the sentence grammatically correct?"; semantic analysis asks "does the sentence make sense?"*

---
---

# 1. Type Checking

## 1. Overview

**Definition:** Type checking is the process of verifying and enforcing that operations in a program are applied to operands of the correct type. For example, `"hello" - 5` should be flagged if the language does not allow subtracting an integer from a string.

**Why it matters:**
- Prevents whole classes of runtime bugs *before* the program runs (or early during it).
- Enables the compiler to choose correct machine instructions (integer add vs floating-point add).
- Improves safety, readability, and self-documentation of code.

**Where it is used in real systems:**
- Compilers (C++, Java, Rust, Go) reject ill-typed programs at compile time.
- IDE red-squiggles and autocomplete rely on the same type-checking engine.
- TypeScript adds a type checker on top of JavaScript.
- Database query planners type-check column expressions.

**Why interviewers ask about it:** It tests whether you understand the difference between *syntax* and *semantics*, how compilers reason about programs, and the trade-offs between catching errors early vs. flexibility.

## 2. Core Idea

**Intuition:** Every expression in a program has a *type* (int, float, bool, string, a custom class, a function type). A type checker walks the AST bottom-up, computes the type of each sub-expression, and checks that each operator/function receives operands of acceptable types.

**Real-world analogy:** A power socket. A 3-pin plug (type A) only fits a 3-pin socket. The socket "type checks" the plug before allowing current to flow. Forcing a mismatched plug is like a type error.

**Small example (conceptual):**
```
Expression:   x + y * 2
AST:                (+)
                   /   \
                  x     (*)
                       /   \
                      y     2

If x : int, y : int, 2 : int
  → y * 2 : int      (int * int → int)  ✓
  → x + (int) : int  (int + int → int)  ✓
Type of whole expression: int
```

**Step-by-step:**
1. Leaf nodes get types from the symbol table (variables) or literal rules (`2` is int).
2. For each internal node, look up the operator's type rule.
3. Check operand types against the rule; report an error if they don't match.
4. Assign the result type to the node and propagate upward.

## 3. Important Subtopics

### a) Type Rules (Typing Judgments)
- **What:** Formal rules that say "under context Γ, expression e has type T", written `Γ ⊢ e : T`.
- **Why:** They give a precise, unambiguous specification of what the checker must enforce.
- **Example:** Rule for `+`: `if Γ ⊢ e1 : int and Γ ⊢ e2 : int then Γ ⊢ e1 + e2 : int`.
- **Interview angle:** "Write the typing rule for an if-expression." Answer: condition must be bool, both branches must have the same type T, result is T.

### b) Type Environment (Context Γ)
- **What:** A mapping from variable names to their types, usually backed by the symbol table.
- **Why:** The checker needs to know what type `x` was declared as.
- **Example:** `{ x: int, y: float, f: (int) -> bool }`.
- **Interview angle:** How does the environment change when entering a new scope? (You push a new frame.)

### c) Type Equivalence
- **What:** Deciding whether two types are "the same". Two flavors:
  - **Structural equivalence:** same structure = same type (Go, some ML dialects).
  - **Name (nominal) equivalence:** same declared name = same type (C, Java, C++ classes).
- **Why:** Determines whether `typedef int Age; typedef int Height;` are interchangeable.
- **Example:** In C, `struct A {int x;}` and `struct B {int x;}` are different types (nominal). In structural typing they'd be the same.
- **Interview angle:** "Are two structurally identical structs interchangeable in C?" No - C uses name equivalence for structs.

### d) Type Compatibility & Subtyping
- **What:** Even if types differ, one may be usable where another is expected (e.g., `Dog` where `Animal` is expected).
- **Why:** Enables polymorphism and inheritance.
- **Example:** `Animal a = new Dog();` is allowed because `Dog <: Animal` (Dog is a subtype of Animal).
- **Interview angle:** Explain covariance/contravariance (return types can be more specific, parameter types more general).

### e) Static vs Dynamic Checking
- **What:** Static = at compile time; dynamic = at runtime (checks embedded in generated code).
- **Why:** Trade-off between early error detection and flexibility.
- **Example:** Java arrays store a runtime type and throw `ArrayStoreException` (dynamic check) even though Java is mostly statically typed.
- **Interview angle:** Give an example where a statically-typed language still needs a runtime type check (downcasts, array covariance).

## 4. Real-World Example

**Backend server (Java/Spring):** When you write a REST endpoint returning a `User` object serialized to JSON, the Java compiler type-checks that the method actually returns a `User` and that every field access (`user.getName()`) exists and has the right type. This catches a typo like `user.getNam()` at compile time, long before a client hits a 500 error.

**TypeScript in a browser app:** `const total: number = price * quantity;` - if `price` was accidentally typed as `string` (a common bug when reading from a form input), the TS type checker flags it before the code ships, preventing `"10" * 2` style bugs.

## 5. Diagrams / Mental Models

**Bottom-up type propagation:**
```
        (assign)                 result: ok if RHS type ⊆ LHS type
        /      \
      x:int    (+):int
              /      \
          a:int     b:int
```

**Type checking as a table lookup:**

| Operator | Left type | Right type | Result type |
|----------|-----------|------------|-------------|
| `+`      | int       | int        | int         |
| `+`      | float     | float      | float       |
| `+`      | string    | string     | string      |
| `<`      | int       | int        | bool        |
| `&&`     | bool      | bool       | bool        |
| `+`      | int       | string     | **ERROR**   |

## 6. Common Interview Questions

**Q1. What is type checking and at what compiler phase does it happen?**
- **Answer:** Verifying operations get correctly-typed operands; done in the semantic analysis phase, after parsing.
- **Expected:** Mention it uses the AST and symbol table.
- **Mistake:** Confusing it with lexical/syntax analysis.

**Q2. Difference between static and dynamic type checking?**
- **Answer:** Static = compile time (C, Java); dynamic = runtime (Python, JS).
- **Expected:** Trade-offs: safety/performance vs flexibility.
- **Mistake:** Saying dynamic means "no types" - dynamic languages have types, just checked at runtime.

**Q3. What is structural vs nominal type equivalence?**
- **Answer:** Structural = same shape; nominal = same declared name.
- **Expected:** Example per each (Go interfaces vs Java classes).
- **Mistake:** Mixing them up.

**Q4. Give the typing rule for `if c then e1 else e2`.**
- **Answer:** `c : bool`, `e1 : T`, `e2 : T` ⇒ whole expression `: T`.
- **Expected:** Both branches must agree in type.
- **Mistake:** Forgetting the condition-is-bool requirement.

**Q5. How does a type checker handle a function call `f(a, b)`?**
- **Answer:** Look up `f`'s signature `(T1, T2) -> R`, check `a : T1`, `b : T2`, assign result type `R`.
- **Expected:** Arity (count) check too.
- **Mistake:** Ignoring argument count mismatch.

**Q6. What is type coercion vs type checking?**
- **Answer:** Coercion is *automatic* type conversion the checker inserts; type checking is *verification*. Coercion is one action a checker may take when types don't exactly match but are compatible.
- **Mistake:** Treating them as unrelated.

**Q7. Can a statically-typed language have runtime type errors?**
- **Answer:** Yes - downcasts (`(Dog) animal`), array covariance (`ArrayStoreException`), or `null` dereferences.
- **Mistake:** Claiming static typing eliminates all runtime type errors.

**Q8. What is the difference between weak and strong typing?**
- **Answer:** Strong typing enforces types strictly (few implicit conversions); weak typing allows many implicit/unsafe conversions (e.g., C letting you reinterpret memory).
- **Mistake:** Conflating strong/weak with static/dynamic - they're orthogonal.

**Q9. How does subtyping affect type checking?**
- **Answer:** Instead of exact match, the checker accepts any subtype where a supertype is expected (`Dog` for `Animal`).
- **Mistake:** Forgetting variance rules for generics.

**Q10. What data structure supports type checking?**
- **Answer:** The symbol table (for variable/function types) plus the AST (to walk expressions).
- **Mistake:** Forgetting the symbol table's role.

## 7. Deep-Dive Questions

**D1. How would you type-check a recursive function?**
Add the function's declared signature to the environment *before* checking its body, so recursive calls resolve. This is why languages require you to declare the return type of a recursive function (or use inference with a fixed-point solver).

**D2. What are covariance and contravariance in type checking?**
For function types `A -> B`: return type `B` is *covariant* (a subtype return is safe), parameter type `A` is *contravariant* (a supertype parameter is safe). This is the Liskov Substitution Principle at the type level. Java arrays are (unsoundly) covariant, which is why they need a runtime `ArrayStoreException`.

**D3. How do type checkers handle generics/parametric polymorphism?**
They treat type variables as unknowns and either instantiate them at call sites (C++ templates, monomorphization) or check the body once with an abstract type (Java generics with erasure, ML). Constraints (bounds) like `<T extends Comparable<T>>` restrict allowed instantiations.

**D4. What is a "soundness" vs "completeness" trade-off in a type system?**
- **Sound:** never accepts a program that will have a type error (no false negatives).
- **Complete:** never rejects a program that is actually safe (no false positives).
Most practical type systems are sound but incomplete - they reject some safe programs to stay decidable and simple.

**D5. How do you type-check `null`/`nil` and avoid null-pointer errors?**
Modern systems use **option/nullable types** (`T?`) so the checker forces you to handle the `null` case before dereferencing. Kotlin, Swift, and Rust (`Option<T>`) do this, eliminating null-pointer exceptions at compile time.

## 8. Comparison Tables

**Static vs Dynamic Type Checking**

| Aspect | Static | Dynamic |
|--------|--------|---------|
| When | Compile time | Runtime |
| Error timing | Early | Late (during execution) |
| Performance | Faster (no runtime checks) | Slower |
| Flexibility | Lower | Higher |
| Examples | C, C++, Java, Rust | Python, JS, Ruby |

**Structural vs Nominal Equivalence**

| Aspect | Structural | Nominal |
|--------|-----------|---------|
| Basis | Same shape/fields | Same declared name |
| Flexibility | High | Low (safer) |
| Examples | Go interfaces, TypeScript | C structs, Java classes |

**Strong vs Weak Typing**

| Aspect | Strong | Weak |
|--------|--------|------|
| Implicit conversions | Few/none | Many |
| Safety | High | Low |
| Examples | Python, Java | C, JavaScript (`==`) |

## 9. Common Mistakes

- Thinking type checking is part of syntax analysis (it's semantic analysis).
- Believing dynamic typing means "no types."
- Confusing strong/weak with static/dynamic (they're independent axes).
- Assuming static typing guarantees zero runtime type errors.
- Forgetting arity checks (argument count) are part of type checking too.

## 10. Edge Cases / Special Cases

- **Array covariance (Java):** `Object[] a = new String[1]; a[0] = 42;` compiles but throws `ArrayStoreException` at runtime.
- **Integer overflow:** Type checker says `int + int : int`, but the value may overflow - types don't capture value ranges (unless you use dependent types).
- **`void` / unit type:** Expressions with no value need special handling.
- **Recursive/mutually recursive types:** `type List = Nil | Cons(int, List)` needs the type in scope while defining itself.
- **`any`/`dynamic` types:** Escape hatches that turn off checking for a value.

## 11. How to Explain in Interview

> "Type checking is the semantic-analysis step where the compiler walks the AST bottom-up, assigns a type to every expression using the symbol table, and verifies that each operator and function call gets operands of the right type. It catches errors like adding a string to an int before the program runs. It can be static (compile time, like Java) or dynamic (runtime, like Python), and it relies on type rules plus a type environment to make its decisions."

## 12. Quick Revision Notes

- **Definition:** Verify operations get correctly-typed operands.
- **Phase:** Semantic analysis (post-parse).
- **Inputs:** AST + symbol table.
- **Type rule notation:** `Γ ⊢ e : T`.
- **Equivalence:** structural vs nominal.
- **Axes:** static/dynamic and strong/weak are independent.
- **Trap:** static typing ≠ no runtime type errors (downcasts, arrays).

## 13. Practice Tasks

1. On paper, type-check `(a > b) && (c + 1)` given `a:int, b:int, c:bool`. (Answer: error - `c + 1` needs int, and `&&` needs two bools.)
2. Write typing rules for `while`, `if`, and assignment.
3. In Python, run `"5" + 5` and observe the runtime `TypeError`; then try `"5" * 3` and explain why it works.
4. In TypeScript, declare `let x: number = "hi";` and read the compiler error.
5. Implement a tiny expression type checker in Python for `+, -, *, <` over int/bool.

```python
# Tiny type checker demo (Practice Task 5)
def type_of(node, env):
    if isinstance(node, int):   return "int"
    if isinstance(node, bool):  return "bool"
    if isinstance(node, str):   return env[node]        # variable
    op, l, r = node
    lt, rt = type_of(l, env), type_of(r, env)
    rules = {"+": ("int","int","int"), "*": ("int","int","int"),
             "<": ("int","int","bool"), "&&": ("bool","bool","bool")}
    a, b, res = rules[op]
    if (lt, rt) != (a, b):
        raise TypeError(f"{op} expected {a},{b} got {lt},{rt}")
    return res

env = {"x": "int", "y": "int"}
print(type_of(("+", "x", ("*", "y", 2)), env))   # int
```

## 14. Final Cheat Sheet

- **Core definition:** Enforce that operations get operands of valid types.
- **Why it matters:** Catches bugs early, enables correct code generation.
- **Most asked:** static vs dynamic, structural vs nominal, typing rule for `if`.
- **Comparisons:** static/dynamic, strong/weak, structural/nominal.
- **One-liner:** "Bottom-up AST walk that assigns and verifies a type for every expression using the symbol table."

---
---

# 2. Scope Checking

## 1. Overview

**Definition:** Scope checking verifies that every name (variable, function, class) used in the program is *visible* (in scope) and *declared* at the point of use, and resolves each use to the correct declaration.

**Why it matters:**
- Catches "undeclared variable" and "used before declaration" errors.
- Determines *which* `x` a use refers to when multiple `x`'s exist in nested blocks.
- Foundational for correct name binding and type checking.

**Where it is used in real systems:**
- Every compiler/interpreter (`error: 'foo' undeclared`).
- IDE "Go to definition" and rename-refactoring.
- Linters (`no-undef` in ESLint).
- Shell variable resolution, CSS cascade (a form of scoping).

**Why interviewers ask:** It tests understanding of nested scopes, shadowing, and the symbol-table structure needed to model program visibility.

## 2. Core Idea

**Intuition:** A program is divided into regions (blocks, functions, classes) called *scopes*. A name declared in a scope is visible within that scope (and usually its nested scopes). Scope checking walks the program, keeps a stack of active scopes, and for each name use, searches from the innermost scope outward until it finds a declaration.

**Real-world analogy:** Nested folders on a computer. A file named `notes.txt` in your current folder shadows one with the same name in a parent folder. When you type `notes.txt`, the system looks in the current folder first, then parents.

**Small example:**
```c
int x = 1;          // scope: global
void f() {
    int x = 2;      // scope: f (shadows global x)
    {
        int y = x;  // 'x' resolves to f's x (=2), 'y' to inner block
    }
    // y is NOT visible here
}
```

**Step-by-step:**
1. On entering a scope (block/function), push a new symbol-table frame.
2. On a declaration, add the name to the current frame (error if duplicate in same scope).
3. On a name use, search current frame → outer frames → global.
4. If not found anywhere: "undeclared identifier" error.
5. On exiting the scope, pop the frame.

## 3. Important Subtopics

### a) Static (Lexical) Scope
- **What:** A name's scope is determined by the program's *text structure* (where blocks are nested), decided at compile time.
- **Why:** Predictable; you can resolve names by reading the code.
- **Example:** C, Java, Python, most modern languages.
- **Interview angle:** "How is lexical scope resolved?" By nesting of code blocks, not call order.

### b) Dynamic Scope
- **What:** A name refers to the most recent binding in the *call stack* at runtime.
- **Why:** Historically simpler for interpreters; now rare due to unpredictability.
- **Example:** Old Lisp, Bash variables, Emacs Lisp (`let`).
- **Interview angle:** Given nested function calls, trace which binding is used under dynamic vs static scope (classic trick question).

### c) Shadowing
- **What:** An inner-scope declaration hides an outer one with the same name.
- **Why:** Allows local reuse of names; can cause bugs if unintended.
- **Example:** `int x=1; { int x=2; /* inner x hides outer */ }`.
- **Interview angle:** Difference between shadowing and overwriting (shadowing keeps the outer variable alive, just hidden).

### d) Scope of Declaration (Point of Visibility)
- **What:** From where in the code a declared name becomes usable.
- **Why:** Languages differ: C = from declaration onward; some allow use-before-declaration (hoisting).
- **Example:** JavaScript `var` hoists (visible in whole function); `let` has a temporal dead zone.
- **Interview angle:** Explain JS hoisting as a scoping rule.

### e) Forward References & Two-Pass Analysis
- **What:** Using a name declared *later* (e.g., mutually recursive functions).
- **Why:** Requires collecting all declarations first (pass 1), then checking uses (pass 2).
- **Example:** `f` calls `g`, `g` calls `f`, both declared at top level.
- **Interview angle:** Why do C functions need forward declarations but Java methods don't? (Java does a full-class symbol collection pass first.)

## 4. Real-World Example

**Browser / JavaScript engine:** When V8 parses your JS, it builds a scope chain. A closure captures the scope in which it was *defined* (lexical scope), so:
```js
function counter() {
  let count = 0;
  return () => ++count;   // inner function captures 'count' by lexical scope
}
const c = counter();
c(); c();   // 1, 2  — 'count' stays alive via the closure's scope
```
Scope checking here decides that `count` inside the arrow function refers to the `count` in `counter`, enabling closures.

**Operating system / shell:** Bash uses *dynamic* scope for variables - a variable set in a calling function is visible in called functions, which surprises many developers.

## 5. Diagrams / Mental Models

**Scope stack (symbol-table frames):**
```
Innermost  ┌──────────────┐  ← searched first
   ▲       │ block scope  │    { y }
   │       ├──────────────┤
   │       │ function f   │    { x }
   │       ├──────────────┤
Outermost  │ global       │    { x, f }  ← searched last
           └──────────────┘
```
Name lookup goes bottom (innermost) → top (global).

**Static vs Dynamic scope trace:**
```
int x = 10;
void g() { print(x); }       // static: x=10 (global)
void f() { int x = 20; g(); }// dynamic: x=20 (caller's)
f();
  Static scope prints 10
  Dynamic scope prints 20
```

## 6. Common Interview Questions

**Q1. What is scope checking?**
- **Answer:** Verifying each name used is declared and visible, and resolving it to its declaration.
- **Mistake:** Confusing it with type checking.

**Q2. Static vs dynamic scope - difference?**
- **Answer:** Static = by code nesting (compile time); dynamic = by call stack (runtime).
- **Mistake:** Saying static means "global" - it means lexically determined.

**Q3. What is variable shadowing?**
- **Answer:** An inner declaration hiding an outer same-named one.
- **Mistake:** Thinking the outer variable is destroyed - it's just hidden.

**Q4. How does the compiler resolve a name to its declaration?**
- **Answer:** Search innermost scope outward using the symbol-table stack.
- **Mistake:** Forgetting the "innermost first" order.

**Q5. Why do mutually recursive functions need two passes?**
- **Answer:** Pass 1 collects all declarations; pass 2 checks uses, so forward references resolve.
- **Mistake:** Saying it's impossible without forward declarations in all languages.

**Q6. What is a closure and how does it relate to scope?**
- **Answer:** A function bundled with the lexical scope it was defined in, keeping captured variables alive.
- **Mistake:** Confusing captured-by-reference vs by-value.

**Q7. What is JavaScript hoisting?**
- **Answer:** `var`/function declarations are conceptually moved to the top of their scope; `let`/`const` are hoisted but stay in a temporal dead zone until declared.
- **Mistake:** Saying `let` is not hoisted at all.

**Q8. What data structure supports scope checking?**
- **Answer:** A stack of symbol tables (one frame per scope).
- **Mistake:** A single flat table (loses nesting info).

**Q9. Can two variables have the same name in a program?**
- **Answer:** Yes, in different (or nested) scopes; resolved by scope rules.
- **Mistake:** Saying names must be globally unique.

**Q10. What error does scope checking catch?**
- **Answer:** Use of undeclared identifiers, use-before-declaration, duplicate declarations in the same scope.
- **Mistake:** Listing type errors instead.

## 7. Deep-Dive Questions

**D1. How do closures keep variables alive after a function returns?**
The captured variables are moved from the stack to the heap (or stored in an environment record). The closure holds a reference to that environment, so the garbage collector keeps it alive as long as the closure exists.

**D2. How would you implement scope checking efficiently for large programs?**
Use a **hash table per scope** with a parent pointer (spaghetti stack), giving O(1) average lookup per level. Or use a single hash table keyed by name mapping to a stack of declarations, pushing/popping on scope entry/exit for O(1) lookup regardless of nesting depth.

**D3. What is the "temporal dead zone" and why does it exist?**
In JS, `let`/`const` bindings exist in scope from the block's start but cannot be accessed until the declaration line. It exists to catch use-before-initialization bugs while still block-scoping the name.

**D4. How does namespace/module scoping extend basic scope checking?**
Modules add an extra outer scope layer with explicit import/export control. Name resolution must consult imported symbols and qualified names (`std::vector`, `math.pi`), often via a separate namespace symbol table.

**D5. Static vs dynamic scope - which is easier to reason about and why?**
Static scope is easier: you can determine what a name refers to by reading the code, independent of runtime call paths. Dynamic scope makes a function's behavior depend on its callers, breaking modularity and hindering optimization.

## 8. Comparison Tables

**Static vs Dynamic Scope**

| Aspect | Static (Lexical) | Dynamic |
|--------|------------------|---------|
| Resolved by | Code nesting | Call stack |
| When | Compile time | Runtime |
| Predictability | High | Low |
| Examples | C, Java, Python | Bash, old Lisp |
| Closures | Natural | Awkward |

**Shadowing vs Overwriting**

| Aspect | Shadowing | Overwriting |
|--------|-----------|-------------|
| Outer variable | Hidden, still exists | Value replaced |
| Scope | Different scopes | Same variable |
| After inner scope ends | Outer reappears | Change persists |

## 9. Common Mistakes

- Thinking shadowing deletes the outer variable.
- Assuming all languages use static scope (Bash, Emacs Lisp use dynamic).
- Believing name resolution goes outer→inner (it's inner→outer).
- Forgetting that closures capture scope, not just values.
- Assuming `let` in JS isn't hoisted (it is, but in the TDZ).

## 10. Edge Cases / Special Cases

- **Same-scope redeclaration:** usually an error (`int x; int x;`), but `var x` twice in JS is allowed.
- **Block scope in a `for` loop:** loop variable scope differs between C89, C99, and JS `let` vs `var` (classic closure-in-loop bug).
- **Recursive lambda:** needs its own name in scope, tricky in some languages.
- **Label scoping** (goto): labels have function scope, separate from variables.
- **`this`/`self`** resolution: has special scoping rules distinct from ordinary variables.

## 11. How to Explain in Interview

> "Scope checking is a semantic-analysis step that makes sure every name you use is actually declared and visible at that point, and figures out which declaration it refers to. The compiler keeps a stack of symbol tables - one per block or function - and to resolve a name it searches from the innermost scope outward to the global scope. Most languages use static/lexical scope, meaning a name's meaning is fixed by where it appears in the code, which is what makes closures and 'go to definition' work reliably."

## 12. Quick Revision Notes

- **Definition:** Ensure names are declared and visible; resolve uses to declarations.
- **Data structure:** Stack of symbol-table frames.
- **Lookup order:** innermost → outermost.
- **Static scope:** by code nesting (default). **Dynamic scope:** by call stack (rare).
- **Shadowing:** inner hides outer (outer still alive).
- **Trap:** closures capture scope; JS `let` has a temporal dead zone.

## 13. Practice Tasks

1. Trace this and give the printed value under both static and dynamic scope:
   ```
   x = 10
   def g(): print(x)
   def f(): x = 20; g()
   f()
   ```
   (Static: 10; Dynamic: 20. Python uses static, so it prints 10.)
2. Write nested C blocks with shadowed `x` and predict each `printf`.
3. Reproduce the JS closure-in-loop bug with `var`, then fix with `let`.
4. Draw the scope stack for a function with two nested blocks.
5. In your language, cause "undeclared variable" and "use before declaration" errors.

## 14. Final Cheat Sheet

- **Core definition:** Verify names are declared/visible and resolve them to declarations.
- **Why it matters:** Catches undeclared-name bugs; enables closures and refactoring.
- **Most asked:** static vs dynamic scope, shadowing, closures.
- **Comparisons:** static/dynamic scope, shadowing/overwriting.
- **One-liner:** "Search a stack of symbol tables innermost-first to bind each name to its declaration."

---
---

# 3. Symbol Tables

## 1. Overview

**Definition:** A symbol table is a data structure used by the compiler to store information about every identifier (variables, functions, classes, types) in a program - its name, type, scope, memory location, and other attributes.

**Why it matters:**
- It is the compiler's central "database" that scope checking, type checking, and code generation all consult.
- Without it, the compiler couldn't remember that `x` was declared as an `int` on line 3 when it's used on line 30.

**Where it is used in real systems:**
- Every compiler and interpreter.
- Debuggers (map variable names to memory addresses/registers).
- Linkers (global symbol tables to resolve cross-file references).
- IDEs (autocomplete, jump-to-definition).

**Why interviewers ask:** It combines data-structure knowledge (hash tables, trees) with compiler concepts. It's a favorite because it connects DSA and systems.

## 2. Core Idea

**Intuition:** Think of it as a dictionary: key = identifier name, value = a record of everything the compiler knows about it. As the compiler parses declarations, it *inserts* entries; as it checks uses, it *looks up* entries.

**Real-world analogy:** A hotel's guest registry. When a guest checks in (declaration), the front desk records their name, room number, and details (attributes). When someone asks "which room is Alice in?" (use), the clerk looks it up. Multiple hotels (scopes) each have their own registry.

**Small example:**
```c
int count = 0;
float avg;
int add(int a, int b) { return a + b; }
```
Symbol table (global scope):

| Name | Kind | Type | Scope | Extra |
|------|------|------|-------|-------|
| count | variable | int | global | offset 0 |
| avg | variable | float | global | offset 4 |
| add | function | (int,int)→int | global | 2 params |

**Step-by-step:**
1. Parser encounters a declaration → build an entry with all known attributes → *insert*.
2. Parser encounters a use → *look up* the name → retrieve attributes for type/scope checking.
3. On entering a new scope → create a new (nested) table.
4. On exiting a scope → discard/close that table.

## 3. Important Subtopics

### a) Entries and Attributes
- **What:** Each entry stores name, kind (var/func/type), data type, scope level, memory offset, and flags (const, static).
- **Why:** Later phases need all this info (e.g., code gen needs the offset).
- **Example:** For a function: name, return type, parameter types and count.
- **Interview angle:** "What attributes does a symbol table store?" - list at least name, type, scope, address.

### b) Implementation: Hash Table
- **What:** Name → entry using a hash function; the most common implementation.
- **Why:** O(1) average insert/lookup, crucial for large programs.
- **Example:** GCC uses hash tables with chaining for collisions.
- **Interview angle:** How do you handle collisions? (Chaining or open addressing.)

### c) Implementation: Other Structures
- **What:** Linear list (simple, O(n)), binary search tree (O(log n), ordered), self-organizing list.
- **Why:** Trade-offs of simplicity vs speed; ordered structures help error messages.
- **Example:** Small scopes may use a list; large ones a hash table.
- **Interview angle:** When would a BST beat a hash table? (When you need ordered traversal or predictable worst case.)

### d) Scope Handling (Nested Tables)
- **What:** Maintain a stack/tree of tables, one per scope, with parent pointers.
- **Why:** Supports lexical scoping and shadowing.
- **Example:** Global → function → block, each a table; lookup walks up parent pointers.
- **Interview angle:** Two common designs: (1) one table per scope with parent links; (2) single global table where each name maps to a stack of declarations.

### e) Operations
- **What:** `insert(name, attrs)`, `lookup(name)`, `enterScope()`, `exitScope()`.
- **Why:** These four drive the whole semantic analysis.
- **Example:** `enterScope` on `{`, `exitScope` on `}`.
- **Interview angle:** What does `lookup` return if the name isn't found? (null → undeclared error.)

## 4. Real-World Example

**Linker in the OS toolchain:** When you compile multiple `.c` files, each produces an object file with a *symbol table* listing defined and referenced symbols (functions, globals). The linker merges these tables to resolve `printf` in your file to its definition in libc. An "undefined reference to `foo`" linker error is literally a failed symbol-table lookup.

**Database engine:** A DBMS keeps a *system catalog* (a symbol table for the schema) storing table names, column names, types, and constraints. When you run `SELECT age FROM users`, the query compiler looks up `users` and `age` in the catalog to type-check and plan the query.

## 5. Diagrams / Mental Models

**Nested symbol tables with parent pointers:**
```
   ┌─────────────── Global table ───────────────┐
   │ main:func   x:int   printf:func             │
   └───────▲─────────────────────────────────────┘
           │ parent
   ┌───────┴──── main() scope ────┐
   │ a:int   b:float               │
   └───────▲───────────────────────┘
           │ parent
   ┌───────┴──── inner block ──────┐
   │ i:int                          │
   └────────────────────────────────┘
lookup("x") from inner block → not here → main → not here → global ✓
```

**Hash-table entry:**
```
hash("count") → bucket 5 → [ count | int | global | offset 0 ] → next → ...
```

## 6. Common Interview Questions

**Q1. What is a symbol table and why is it needed?**
- **Answer:** A data structure storing identifier info; needed by scope/type checking and code gen.
- **Mistake:** Calling it just "a list of variables" - it stores rich attributes.

**Q2. What operations does a symbol table support?**
- **Answer:** insert, lookup, enterScope, exitScope.
- **Mistake:** Forgetting scope operations.

**Q3. Which data structures implement a symbol table? Trade-offs?**
- **Answer:** Hash table (O(1), most common), BST (O(log n), ordered), list (O(n), simple).
- **Mistake:** Only naming hash table.

**Q4. How does the symbol table handle nested scopes?**
- **Answer:** A stack/tree of tables with parent pointers; lookup walks up.
- **Mistake:** A single flat table.

**Q5. What attributes are stored per entry?**
- **Answer:** Name, kind, type, scope level, memory offset, flags.
- **Mistake:** Only name and type.

**Q6. How do you handle collisions in a hash-table symbol table?**
- **Answer:** Chaining (linked lists per bucket) or open addressing.
- **Mistake:** Not knowing collision resolution.

**Q7. How is shadowing represented?**
- **Answer:** The inner scope's table has its own entry, found first during lookup.
- **Mistake:** Overwriting the outer entry.

**Q8. What happens on `exitScope`?**
- **Answer:** The current scope's entries are removed/closed so they're no longer visible.
- **Mistake:** Leaving them accessible.

**Q9. Difference between compile-time symbol table and runtime data?**
- **Answer:** The symbol table is a compile-time structure; at runtime, addresses/registers hold the actual data (though debuggers keep symbol info).
- **Mistake:** Thinking it exists at runtime for normal execution.

**Q10. How do linkers use symbol tables?**
- **Answer:** To resolve external references across object files (defined vs undefined symbols).
- **Mistake:** Ignoring the linker's role.

## 7. Deep-Dive Questions

**D1. How would you design a symbol table that supports O(1) lookup regardless of nesting depth?**
Use a single global hash table where each name maps to a *stack* of declarations (most recent on top). `insert` pushes, `lookup` reads the top, `exitScope` pops all names declared at that level (track them in a per-scope list). Lookup is O(1) even with deep nesting.

**D2. How do symbol tables interact with forward references and recursion?**
Insert a declaration's entry *before* processing its body so recursive/forward uses resolve. For mutually recursive top-level definitions, do a declaration-collection pass first, then a body-checking pass.

**D3. What's stored for a class/struct in an OO language?**
A nested symbol table for members (fields, methods) plus inheritance links to the parent class's table, so member lookup can walk the inheritance chain. Access modifiers (private/public) are attributes checked during lookup.

**D4. How do symbol tables support debugging (DWARF/symbols)?**
The compiler emits debug symbol tables mapping source names → memory locations, line numbers, and types into the binary (e.g., DWARF sections). Debuggers read these to show variable names/values, which is why "release" builds with stripped symbols are hard to debug.

**D5. How would you make symbol-table operations thread-safe or incremental (for an IDE)?**
IDEs use *incremental* symbol tables that update only the changed subtree on each keystroke, often with persistent/immutable data structures so old versions stay valid for background threads. This avoids re-parsing the whole project on every edit.

## 8. Comparison Tables

**Symbol Table Implementations**

| Structure | Lookup | Insert | Ordered? | Use case |
|-----------|--------|--------|----------|----------|
| Hash table | O(1) avg | O(1) avg | No | Default, large programs |
| BST | O(log n) | O(log n) | Yes | Need ordered traversal |
| Linear list | O(n) | O(1) | No | Tiny scopes, simplicity |
| Balanced tree | O(log n) | O(log n) | Yes | Worst-case guarantees |

**Symbol Table vs AST**

| Aspect | Symbol Table | AST |
|--------|--------------|-----|
| Stores | Identifier info | Program structure |
| Access | By name (key) | By tree traversal |
| Role | "What is x?" | "What is the code doing?" |

## 9. Common Mistakes

- Thinking it's just a list of variable names (it stores rich attributes).
- Using one flat table and losing scope/shadowing info.
- Forgetting `enterScope`/`exitScope` operations.
- Believing the symbol table exists at runtime for normal execution.
- Not handling hash collisions.

## 10. Edge Cases / Special Cases

- **Duplicate declaration in same scope:** must be detected as an error.
- **Overloaded functions:** one name → multiple entries (need signature to disambiguate).
- **Recursive types/functions:** entry must exist before body is processed.
- **Namespaces/modules:** qualified names need multi-level lookup.
- **Very deep nesting:** naive per-scope tables can slow lookup; use the stack-of-declarations design.

## 11. How to Explain in Interview

> "A symbol table is the compiler's central database of identifiers. For each name - variable, function, type - it stores attributes like the data type, scope level, and memory offset. It supports four key operations: insert on declaration, lookup on use, and enter/exit scope. It's usually a hash table for O(1) access, and to handle nested scopes we keep a stack or tree of tables with parent pointers, so a lookup searches from the innermost scope outward. Type checking, scope checking, and code generation all rely on it."

## 12. Quick Revision Notes

- **Definition:** Compile-time database of identifier attributes.
- **Attributes:** name, kind, type, scope, offset, flags.
- **Operations:** insert, lookup, enterScope, exitScope.
- **Implementations:** hash table (default), BST, list.
- **Scopes:** stack/tree of tables with parent pointers.
- **Trap:** it's compile-time (except debug symbols); collisions need chaining.

## 13. Practice Tasks

1. Implement a symbol table in Python with `insert`, `lookup`, `enter_scope`, `exit_scope`.
   ```python
   class SymbolTable:
       def __init__(self):
           self.scopes = [{}]                    # stack of dicts
       def enter_scope(self): self.scopes.append({})
       def exit_scope(self):  self.scopes.pop()
       def insert(self, name, attrs):
           if name in self.scopes[-1]:
               raise Exception(f"redeclared: {name}")
           self.scopes[-1][name] = attrs
       def lookup(self, name):
           for scope in reversed(self.scopes):   # innermost first
               if name in scope: return scope[name]
           raise Exception(f"undeclared: {name}")
   ```
2. Add hash-collision handling with chaining to a from-scratch table.
3. Model an overloaded function (same name, two signatures) in your table.
4. Trace insert/lookup for a 3-level nested program on paper.
5. Inspect a real symbol table: run `nm a.out` (Linux) or `dumpbin /symbols` (Windows) on a compiled binary.

## 14. Final Cheat Sheet

- **Core definition:** Compile-time structure storing identifier attributes (type, scope, address).
- **Why it matters:** Backbone of scope checking, type checking, code gen, linking.
- **Most asked:** operations, implementations & trade-offs, nested-scope handling.
- **Comparisons:** hash vs BST vs list; symbol table vs AST.
- **One-liner:** "A per-scope hash-table dictionary from names to their attributes that every later compiler phase consults."

---
---

# 4. Static vs Dynamic Typing

## 1. Overview

**Definition:** This is about *when* type checking happens.
- **Static typing:** types are checked at **compile time**; variables have fixed types known before running.
- **Dynamic typing:** types are checked at **runtime**; a variable can hold values of different types over its life.

**Why it matters:**
- Determines when you find type errors (before shipping vs while running).
- Affects performance, tooling, safety, and developer flexibility.
- Central to language design and to choosing the right tool for a job.

**Where it is used in real systems:**
- Static: C, C++, Java, Go, Rust, TypeScript - used for performance-critical and large systems.
- Dynamic: Python, JavaScript, Ruby, PHP - used for scripting, rapid prototyping, data science.

**Why interviewers ask:** It's a fundamental language-design concept that reveals whether you understand trade-offs, and it comes up constantly when discussing why a team chose a particular language.

## 2. Core Idea

**Intuition:** In static typing, the type is a property of the *variable/expression*, fixed at compile time. In dynamic typing, the type is a property of the *value*, carried at runtime, and the variable is just a label that can point to any value.

**Real-world analogy:**
- **Static:** Labeled shipping containers - a container marked "FROZEN" can only hold frozen goods; checked at the port before the ship leaves.
- **Dynamic:** A generic cardboard box - you can put anything in it; contents are checked only when someone opens it at delivery.

**Small example:**
```java
// Static (Java): type fixed, checked at compile time
int x = 5;
x = "hello";   // COMPILE ERROR
```
```python
# Dynamic (Python): type follows the value, checked at runtime
x = 5
x = "hello"    # fine; x now refers to a string
x + 1          # RUNTIME TypeError (str + int)
```

**Step-by-step (static):**
1. Declare variable with a type (or infer it).
2. Compiler records the type in the symbol table.
3. Every use is checked against that type at compile time.
4. Type errors stop compilation.

**Step-by-step (dynamic):**
1. Variable created by assignment; no fixed type.
2. Each value carries a type tag at runtime.
3. Operations check tags at execution time.
4. Type errors raise runtime exceptions.

## 3. Important Subtopics

### a) Type Annotations vs Inference
- **What:** Static languages either require annotations (`int x`) or infer them (`auto`, `var`, ML).
- **Why:** Inference gives static safety with less boilerplate.
- **Example:** `auto x = 5;` (C++), `var x = 5;` (Java 10+) - still statically typed.
- **Interview angle:** "Is a language with type inference static or dynamic?" Static - the type is fixed at compile time, just not written out.

### b) Gradual Typing
- **What:** Mix static and dynamic in one language (annotate some parts, leave others dynamic).
- **Why:** Add safety incrementally to dynamic codebases.
- **Example:** TypeScript, Python type hints + mypy, Dart.
- **Interview angle:** How does TypeScript relate to JavaScript? (Static layer compiled away to dynamic JS.)

### c) Performance Implications
- **What:** Static types let the compiler generate specialized machine code and skip runtime type tags/checks.
- **Why:** Dynamic typing needs runtime type dispatch, boxing, and checks → slower.
- **Example:** A Java `int` loop vs a Python `int` loop (Python is ~10-100x slower partly due to dynamic typing).
- **Interview angle:** Why is CPython slower than C? (Runtime type checks, boxing, dynamic dispatch.)

### d) Duck Typing
- **What:** In dynamic languages, an object's suitability is determined by the methods it has, not its declared type ("if it walks like a duck...").
- **Why:** Flexible polymorphism without inheritance.
- **Example:** Python `for x in anything_iterable` works if the object has `__iter__`.
- **Interview angle:** How does duck typing differ from interface-based polymorphism?

### e) Type Safety & Error Timing
- **What:** Static catches errors before deployment; dynamic may let a bug reach production and fail on a rare code path.
- **Why:** Affects reliability of large systems.
- **Example:** A typo in a rarely-run branch is caught immediately in Java, but only when that branch executes in Python.
- **Interview angle:** Why do large teams often prefer static typing? (Early errors, better tooling, safer refactors.)

## 4. Real-World Example

**Frontend evolution (browser apps):** JavaScript is dynamically typed. As web apps grew huge, teams adopted **TypeScript** to add static typing on top. A function `function total(items) {...}` could be called with the wrong shape and crash at runtime; with TS, `function total(items: Item[])` catches misuse at compile time. This is why most large frontend codebases (VS Code, Slack) moved to TypeScript.

**Data science (Python):** Dynamic typing lets a data scientist quickly write `df['col'] * 2` without declaring types, enabling fast experimentation in Jupyter. The trade-off - a type bug in a data pipeline may surface only after hours of processing.

## 5. Diagrams / Mental Models

**When the check happens:**
```
STATIC:   write code → [compile: TYPE CHECK] → run
                            ▲ errors caught here

DYNAMIC:  write code → run → [execute: TYPE CHECK per operation]
                                   ▲ errors caught here (late)
```

**Type belongs to variable vs value:**
```
Static:   x : int   ───► [ 5 ]          (variable typed)
Dynamic:  x  ───►  [ 5 : int ]          (value typed; x can repoint)
                   [ "hi" : str ]
```

## 6. Common Interview Questions

**Q1. Static vs dynamic typing - core difference?**
- **Answer:** When types are checked - compile time (static) vs runtime (dynamic).
- **Mistake:** Saying dynamic languages have no types.

**Q2. Is Python strongly or weakly typed? Static or dynamic?**
- **Answer:** Dynamically typed *and* strongly typed (few implicit conversions; `"1"+1` errors).
- **Mistake:** Confusing dynamic with weak.

**Q3. Advantages of static typing?**
- **Answer:** Early error detection, better performance, superior tooling/refactoring, self-documenting.
- **Mistake:** Only mentioning speed.

**Q4. Advantages of dynamic typing?**
- **Answer:** Flexibility, faster prototyping, less boilerplate, duck typing.
- **Mistake:** Saying "none" - it has real productivity benefits.

**Q5. Does type inference make a language dynamic?**
- **Answer:** No - inference is compile-time; the language is still static.
- **Mistake:** Thinking `auto`/`var` means dynamic.

**Q6. What is gradual typing?**
- **Answer:** Mixing static and dynamic typing in one codebase (TypeScript, mypy).
- **Mistake:** Confusing with "weak typing."

**Q7. Why are dynamically typed languages usually slower?**
- **Answer:** Runtime type tags, boxing, dynamic dispatch, and per-operation type checks.
- **Mistake:** Blaming only "interpreted vs compiled."

**Q8. What is duck typing?**
- **Answer:** Suitability judged by available methods, not declared type.
- **Mistake:** Equating it with inheritance.

**Q9. Give a bug that static typing catches but dynamic misses until runtime.**
- **Answer:** Passing a string where an int is expected in a rarely-run branch.
- **Mistake:** Giving a logic error unrelated to types.

**Q10. Can a static language have `any`/dynamic escape hatches?**
- **Answer:** Yes - `Object`/`any`/`dynamic`/`void*` disable checking for a value.
- **Mistake:** Saying static means fully rigid.

## 7. Deep-Dive Questions

**D1. How do JIT compilers (V8, PyPy) speed up dynamic languages?**
They observe runtime types, assume "types stay stable" (via inline caches and type feedback), and generate specialized machine code with guards. If a guard fails (an unexpected type appears), they deoptimize back to the interpreter. This recovers much static-like speed for hot paths.

**D2. Is soundness guaranteed by static typing?**
Not always. TypeScript is intentionally *unsound* (e.g., `any`, unsafe covariance) for pragmatism. Rust and ML are sound. Soundness means "well-typed programs don't get type errors at runtime"; many mainstream static languages trade some soundness for usability.

**D3. What is the "billion-dollar mistake" and how does typing address it?**
Null references (Tony Hoare's term). Static type systems with nullable types (`T?` in Kotlin/Swift, `Option<T>` in Rust) force null handling at compile time, converting a common runtime crash into a compile error.

**D4. How does gradual typing handle the boundary between typed and untyped code?**
At the boundary, runtime checks (casts/contracts) verify that dynamically-typed values match their static expectations. Sound gradual typing inserts these checks; TypeScript instead erases types and does no runtime checking (unsound but fast).

**D5. Why might a startup choose Python (dynamic) and later migrate parts to Go/Rust (static)?**
Early on, dynamic typing maximizes iteration speed with uncertain requirements. As the system scales, static typing's reliability, performance, and refactor-safety matter more, so hot/critical services get rewritten in static languages.

## 8. Comparison Tables

**Static vs Dynamic Typing**

| Aspect | Static | Dynamic |
|--------|--------|---------|
| Type check time | Compile time | Runtime |
| Type belongs to | Variable | Value |
| Error detection | Early | Late |
| Performance | Faster | Slower |
| Flexibility | Lower | Higher |
| Tooling (autocomplete/refactor) | Excellent | Weaker |
| Boilerplate | More | Less |
| Examples | C, Java, Go, Rust | Python, JS, Ruby |

**Common language classification (two axes)**

| Language | Static/Dynamic | Strong/Weak |
|----------|----------------|-------------|
| C | Static | Weak |
| Java | Static | Strong |
| Python | Dynamic | Strong |
| JavaScript | Dynamic | Weak |
| Rust | Static | Strong |

## 9. Common Mistakes

- Saying "dynamic languages have no types" (they do - checked at runtime).
- Confusing static/dynamic (when) with strong/weak (how strict).
- Thinking type inference = dynamic typing.
- Believing dynamic is always "worse" - it's a trade-off.
- Assuming static typing catches all bugs (only *type* bugs).

## 10. Edge Cases / Special Cases

- **`any`/`dynamic`:** static languages can opt out of checking per value.
- **Reflection/`instanceof`:** static languages doing runtime type inspection.
- **Optional typing (Python hints):** ignored at runtime unless a checker like mypy runs.
- **Monomorphization vs boxing:** how generics interact with static typing performance.
- **Type erasure (Java generics):** static at compile time, erased at runtime, causing some runtime surprises.

## 11. How to Explain in Interview

> "The static vs dynamic distinction is about *when* types are checked. In static typing - C, Java, Rust - types are fixed and verified at compile time, so type errors are caught before the program runs, and the compiler can generate faster, specialized code. In dynamic typing - Python, JavaScript - types travel with values and are checked at runtime, giving flexibility and faster prototyping at the cost of catching errors later and running slower. It's orthogonal to strong vs weak typing, which is about how strictly conversions are enforced."

## 12. Quick Revision Notes

- **Static:** compile-time checks; type on the variable; C, Java, Go, Rust.
- **Dynamic:** runtime checks; type on the value; Python, JS, Ruby.
- **Independent axis:** strong vs weak (strictness of conversions).
- **Type inference ≠ dynamic** (still static).
- **Gradual typing:** TypeScript, mypy.
- **Trap:** dynamic has types too; static doesn't catch logic bugs.

## 13. Practice Tasks

1. In Python, reassign a variable across three different types and print `type(x)` each time.
2. In Java/C++, try assigning a string to an int variable and read the compile error.
3. Add TypeScript types to a small JS function and trigger a type error.
4. Benchmark a numeric loop in Python vs C for the same work; explain the gap.
5. Write a Python function that relies on duck typing (works for list and str) and one that would need generics in Java.

## 14. Final Cheat Sheet

- **Core definition:** Static = types checked at compile time; dynamic = at runtime.
- **Why it matters:** Trade-off of early safety/performance vs flexibility/speed of development.
- **Most asked:** advantages of each, Python's classification, does inference = dynamic.
- **Comparisons:** static/dynamic and (orthogonal) strong/weak.
- **One-liner:** "Static binds types to variables at compile time; dynamic binds types to values at runtime."

---
---

# 5. Type Conversion

## 1. Overview

**Definition:** Type conversion is changing a value from one data type to another - e.g., turning an `int` into a `float`, or a `string` into a `number`. It can be **explicit** (you request it, a.k.a. casting) or **implicit** (the compiler does it automatically, a.k.a. coercion).

**Why it matters:**
- Real programs constantly mix types (int and float in arithmetic, parsing strings from input).
- The compiler must decide how to represent a value in a different type without silently corrupting data.
- Incorrect conversions cause subtle bugs: precision loss, overflow, unexpected truncation.

**Where it is used in real systems:**
- Arithmetic on mixed numeric types (`3 + 4.5`).
- Parsing user input (`int(input())`, `Integer.parseInt`).
- Database column type casts (`CAST(price AS DECIMAL)`).
- Serialization/deserialization (JSON string ↔ typed object).

**Why interviewers ask:** It exposes understanding of how data is represented, where precision/overflow bugs come from, and the difference between explicit and implicit conversions.

## 2. Core Idea

**Intuition:** Different types have different in-memory representations (an `int` is a raw binary integer; a `float` uses IEEE-754 mantissa/exponent; a `string` is characters). Converting means producing a valid representation in the target type, which may involve reformatting the bits and possibly losing information.

**Real-world analogy:** Currency exchange. Converting dollars to euros (int→float) is fine. Converting euros back to dollars and rounding to whole dollars (float→int) loses the cents - that's *narrowing* with data loss.

**Small example:**
```c
int   i = 3;
float f = i;        // implicit widening: 3 → 3.0 (safe)
float g = 3.9;
int   j = (int) g;  // explicit narrowing cast: 3.9 → 3 (truncates!)
```

**Step-by-step:**
1. Identify source type and target type.
2. Determine if it's *widening* (safe, no loss) or *narrowing* (possible loss).
3. Generate conversion code (e.g., integer→float instruction, or truncation).
4. For explicit casts, trust the programmer; for implicit, apply language rules.

## 3. Important Subtopics

### a) Implicit vs Explicit Conversion
- **What:** Implicit = compiler inserts it automatically; explicit = programmer writes a cast.
- **Why:** Implicit is convenient but can hide bugs; explicit is clear but verbose.
- **Example:** `double d = 5;` (implicit) vs `int i = (int) 5.7;` (explicit).
- **Interview angle:** When is implicit conversion dangerous? (Narrowing, signed/unsigned mixes.)

### b) Widening vs Narrowing
- **What:** Widening = smaller→larger type (int→long, int→float), usually lossless. Narrowing = larger→smaller (float→int, long→int), may lose data.
- **Why:** Widening is safe and often implicit; narrowing usually requires an explicit cast.
- **Example:** `long L = anInt;` (widening, auto) vs `int i = (int) aLong;` (narrowing, explicit).
- **Interview angle:** Why does Java require a cast for narrowing but not widening?

### c) Numeric vs Reference Conversion
- **What:** Numeric conversions change representation; reference conversions (upcast/downcast) reinterpret an object pointer along an inheritance hierarchy.
- **Why:** They behave differently - numeric may change bits; reference casts don't change the object, only the static view.
- **Example:** `(int)3.5` (numeric) vs `(Animal) dog` / `(Dog) animal` (reference).
- **Interview angle:** Difference between upcast (always safe) and downcast (may throw `ClassCastException`).

### d) Conversion via Constructors/Functions
- **What:** Explicit conversions that call code - `int("42")`, `str(3)`, `float("3.14")`, C++ converting constructors.
- **Why:** Type changes that aren't pure bit reinterpretation (string↔number).
- **Example:** `int("123")` parses characters into an integer.
- **Interview angle:** Why can `int("abc")` fail at runtime? (Parsing error, not a compile-time bit copy.)

### e) Precision Loss & Overflow
- **What:** Narrowing can truncate (float→int) or overflow (long→int wraps around).
- **Why:** A leading source of silent bugs.
- **Example:** `(int) 3_000_000_000L` overflows a 32-bit int to a negative number.
- **Interview angle:** What happens when you cast a value out of the target's range?

## 4. Real-World Example

**Database (SQL):** A `users` table stores `age` as `VARCHAR` (bad schema). To compute average age you must convert: `SELECT AVG(CAST(age AS INTEGER)) FROM users;`. If any row has `age = 'unknown'`, the explicit cast fails at runtime - a real production pitfall of storing numbers as strings.

**Backend API:** An HTTP request delivers everything as strings. A server does `int quantity = Integer.parseInt(request.get("qty"));`. This explicit conversion is where input validation matters - a malicious/malformed `"abc"` throws, so robust servers wrap conversions in error handling.

## 5. Diagrams / Mental Models

**Widening (safe) vs Narrowing (lossy):**
```
byte → short → int → long → float → double     (widening →, generally safe)
  ◄──────────────────────────────────────
                    narrowing (needs cast, may lose data)
```

**Float → int truncation:**
```
  3.9  ──(int)──►  3       (fraction dropped, NOT rounded)
 -3.9  ──(int)──► -3
```

**Conversion decision table:**

| From → To | Kind | Implicit? | Risk |
|-----------|------|-----------|------|
| int → double | widening | yes | none |
| double → int | narrowing | no (cast) | truncation |
| int → long | widening | yes | none |
| long → int | narrowing | no (cast) | overflow |
| string → int | parse | no (function) | runtime error |

## 6. Common Interview Questions

**Q1. What is type conversion?**
- **Answer:** Changing a value from one type to another, explicitly or implicitly.
- **Mistake:** Confusing conversion (changes value/representation) with reinterpret-cast.

**Q2. Explicit vs implicit conversion?**
- **Answer:** Explicit = programmer writes a cast; implicit = compiler inserts it automatically.
- **Mistake:** Using "coercion" and "casting" interchangeably without clarifying (coercion = implicit).

**Q3. Widening vs narrowing conversion?**
- **Answer:** Widening = small→large (safe, often implicit); narrowing = large→small (lossy, needs cast).
- **Mistake:** Getting the direction backwards.

**Q4. What happens when you cast `float` to `int`?**
- **Answer:** The fractional part is truncated (toward zero), not rounded.
- **Mistake:** Saying it rounds.

**Q5. Why does narrowing require an explicit cast?**
- **Answer:** Potential data loss/overflow; the language forces you to acknowledge it.
- **Mistake:** Claiming it's about syntax only.

**Q6. Upcast vs downcast (objects)?**
- **Answer:** Upcast (child→parent) is always safe/implicit; downcast (parent→child) may fail (`ClassCastException`).
- **Mistake:** Thinking downcast changes the object.

**Q7. How is string→int conversion different from int→float?**
- **Answer:** String→int is parsing (runs code, can fail); int→float is a representation change done by a CPU instruction.
- **Mistake:** Treating both as simple casts.

**Q8. Give an example where implicit conversion causes a bug.**
- **Answer:** `int result = 5 / 2;` staying int (=2) then assigned to a double; or signed/unsigned comparison surprises in C.
- **Mistake:** Not knowing a concrete example.

**Q9. What is integer overflow during conversion?**
- **Answer:** Casting a value outside the target range wraps around (e.g., 3 billion into a 32-bit int → negative).
- **Mistake:** Assuming it clamps or errors.

**Q10. Does casting change the original variable?**
- **Answer:** No - it produces a new value of the target type; the original is unchanged.
- **Mistake:** Thinking a cast mutates the source.

## 7. Deep-Dive Questions

**D1. How does the compiler generate code for int→float conversion?**
It emits a dedicated CPU instruction (e.g., x86 `cvtsi2sd`) that converts the integer's binary form into IEEE-754 double representation. It's not a reinterpret of bits - the bit pattern changes entirely.

**D2. What is the difference between a value cast and a reinterpret/bit cast?**
A value cast (`(float)i`) produces the numerically-equivalent value in the new type. A reinterpret cast (`reinterpret_cast`, `*(float*)&i`, `std::bit_cast`) keeps the *same bits* but views them as another type - dangerous and used for low-level tricks.

**D3. Explain C's usual arithmetic conversions.**
When operands of `+`, `*`, etc. differ, C promotes them to a common type via a ranking (integer promotions, then converting to the higher-ranked type, with signed/unsigned rules). This is why `unsigned - signed` can produce a huge positive number.

**D4. Why can float→int→float round-trips lose data, but int→float→int sometimes also fails?**
Floats can't represent all large integers exactly (beyond 2^53 for double). So a large `long` converted to `double` and back may differ - the conversion loses low-order bits even though both are "numbers."

**D5. How do languages avoid conversion bugs at scale?**
Strong typing + explicit-only narrowing (Rust: `as` for lossy, `TryFrom` for checked), lint rules against implicit narrowing, and checked conversions that return an error/option instead of silently overflowing.

## 8. Comparison Tables

**Explicit vs Implicit Conversion**

| Aspect | Explicit (cast) | Implicit (coercion) |
|--------|-----------------|---------------------|
| Who does it | Programmer | Compiler |
| Visibility | Clear in code | Hidden |
| Typical use | Narrowing, downcast | Widening, mixed arithmetic |
| Risk | Programmer's responsibility | Silent bugs |

**Widening vs Narrowing**

| Aspect | Widening | Narrowing |
|--------|----------|-----------|
| Direction | Small → large | Large → small |
| Data loss | None (usually) | Possible |
| Needs cast? | No | Yes |
| Example | int → double | double → int |

**Value cast vs Reinterpret cast**

| Aspect | Value cast | Reinterpret cast |
|--------|-----------|------------------|
| Bits | Changed | Same |
| Meaning | Same value, new type | Same bits, new view |
| Safety | Safe | Dangerous |
| Example | `(float)5` → 5.0 | `bit_cast<float>(i)` |

## 9. Common Mistakes

- Thinking float→int rounds (it truncates toward zero).
- Confusing coercion (implicit) with casting (explicit).
- Believing a cast mutates the original variable.
- Assuming all conversions are lossless.
- Ignoring signed/unsigned conversion surprises in C/C++.

## 10. Edge Cases / Special Cases

- **Overflow on narrowing:** value wraps; may become negative.
- **NaN/Infinity → int:** undefined or platform-specific behavior.
- **Signed ↔ unsigned:** `-1` to `unsigned` becomes a huge number.
- **Large long → double:** loses precision beyond 2^53.
- **`char` ↔ int:** implicit in C (`'A'` → 65), a source of confusion.
- **Truncation direction:** toward zero, not floor (so `(int)-3.9 == -3`, not -4).

## 11. How to Explain in Interview

> "Type conversion changes a value from one type to another. It's explicit when I write a cast, like `(int)3.9`, and implicit - called coercion - when the compiler does it automatically, like promoting an int to a double in mixed arithmetic. Conversions are either widening, going to a larger type safely, or narrowing, going to a smaller type where I can lose data or overflow, which is why languages force an explicit cast for narrowing. The key gotcha is that float-to-int truncates toward zero rather than rounding, and narrowing large values can silently overflow."

## 12. Quick Revision Notes

- **Explicit = cast** (you write it); **implicit = coercion** (compiler inserts).
- **Widening:** safe, auto (int→double). **Narrowing:** lossy, needs cast (double→int).
- **float→int truncates** toward zero.
- **Upcast safe, downcast risky** (`ClassCastException`).
- **string↔number** = parsing (can fail at runtime).
- **Trap:** overflow on narrowing; signed/unsigned surprises; precision loss past 2^53.

## 13. Practice Tasks

1. In C/Java, print `(int)3.9`, `(int)-3.9`, and `(int)3_000_000_000L`; explain each.
2. In Python, run `int("42")`, `int("4.2")`, `int(4.9)`; note which fail and why.
3. Demonstrate signed/unsigned surprise in C: `if (-1 < 1u) ...` and explain the result.
4. Write a function that safely converts a string to int with error handling.
5. Show precision loss: `System.out.println((long)(double) 9007199254740993L);` in Java.

## 14. Final Cheat Sheet

- **Core definition:** Changing a value's type, explicitly (cast) or implicitly (coercion).
- **Why it matters:** Precision loss, overflow, and parse failures are common bugs.
- **Most asked:** widening vs narrowing, float→int behavior, upcast vs downcast.
- **Comparisons:** explicit/implicit, widening/narrowing, value/reinterpret cast.
- **One-liner:** "Reformat a value into another type - safe when widening, potentially lossy when narrowing."

---
---

# 6. Type Coercion

## 1. Overview

**Definition:** Type coercion is *implicit, automatic* type conversion performed by the language when an operation receives operands of mismatched-but-compatible types. It's a specific case of type conversion where **you don't write a cast - the language does it for you**.

**Why it matters:**
- Makes code concise (`3 + 4.5` "just works").
- But it's a notorious source of surprising bugs, especially in weakly-typed languages like JavaScript (`[] + {}`, `"5" - 1`).
- Understanding coercion rules is essential for reasoning about mixed-type expressions.

**Where it is used in real systems:**
- Mixed numeric arithmetic in almost every language.
- JavaScript's `==` operator and `+` operator.
- SQL comparing a number column with a string literal.
- Template/string interpolation (number auto-converted to string).

**Why interviewers ask:** Coercion questions (especially JS "wat" examples) test whether you truly understand implicit conversion rules rather than memorizing outputs, and they reveal appreciation of language safety trade-offs.

## 2. Core Idea

**Intuition:** When an operator sees two different types, instead of erroring, the language *coerces* one (or both) operands to a common type according to fixed rules, then performs the operation. Coercion is the "automatic," invisible sibling of explicit casting.

**Real-world analogy:** A bilingual mediator. Two people speak different languages (types); the mediator silently translates one to the other's language so they can talk. Convenient - but if the translation is wrong or surprising, the conversation goes sideways.

**Small example:**
```js
// JavaScript coercion
3 + 4.5      // 7.5     (int coerced to float)
"5" + 1      // "51"    (number coerced to string, + means concat)
"5" - 1      // 4       (string coerced to number, - is numeric)
true + 1     // 2       (true coerced to 1)
```
Notice `+` and `-` coerce differently - that's the trap.

**Step-by-step (how the language decides):**
1. Operator sees mismatched operand types.
2. Consult coercion rules for that operator (e.g., `+` prefers string if either side is string in JS).
3. Convert operand(s) to the chosen common type.
4. Perform the operation on the now-matching types.

## 3. Important Subtopics

### a) Numeric Coercion (Type Promotion)
- **What:** In mixed arithmetic, the "smaller" type is promoted to the "larger" (int→float, int→long).
- **Why:** Preserves precision; makes `3 + 4.5` meaningful.
- **Example:** `int + double → double`. C's "usual arithmetic conversions" formalize this.
- **Interview angle:** In `5 / 2` (both int) vs `5 / 2.0`, why do results differ? (No coercion in the first → integer division = 2.)

### b) String Coercion
- **What:** Converting non-strings to strings, common with `+` and interpolation.
- **Why:** Enables `"Age: " + 25`.
- **Example:** JS `1 + "2" → "12"`; Java `"x" + 5 → "x5"`.
- **Interview angle:** Why is `1 + 2 + "3"` = `"33"` but `"1" + 2 + 3` = `"123"`? (Left-to-right evaluation.)

### c) Boolean Coercion (Truthiness)
- **What:** Non-boolean values coerced to true/false in boolean contexts.
- **Why:** Enables `if (str)`, `if (list)`.
- **Example:** JS falsy values: `0, "", null, undefined, NaN, false`. Python falsy: `0, "", [], {}, None`.
- **Interview angle:** List the falsy values in JS/Python (very common quiz).

### d) Coercion in Comparisons (`==` vs `===`)
- **What:** Loose equality coerces operands before comparing; strict equality doesn't.
- **Why:** `==` causes classic bugs (`0 == ""`, `null == undefined`).
- **Example:** JS `0 == "0"` → true (coerced); `0 === "0"` → false (no coercion).
- **Interview angle:** Always recommend `===` in JS and explain why.

### e) Widening vs Coercion (relationship to conversion)
- **What:** Coercion is implicit conversion; when it goes to a wider type it's also called promotion.
- **Why:** Distinguish "the compiler did it" (coercion) from "I asked for it" (cast).
- **Example:** `long L = 5;` (implicit widening = coercion) vs `(int) 5L` (explicit cast).
- **Interview angle:** Is coercion always safe? (No - implicit narrowing coercion in C can lose data.)

## 4. Real-World Example

**Browser / JavaScript form handling:** A user types "5" in a number input; `input.value` is the string `"5"`. If a developer writes `total = input.value + tax` expecting math, coercion makes `+` concatenate: `"5" + 2 → "52"`. This real bug is why frontend devs explicitly `Number(input.value)` first. The `-`, `*`, `/` operators would instead coerce toward numbers, hiding the inconsistency.

**SQL query:** `SELECT * FROM orders WHERE id = '100'` - many databases coerce the string `'100'` to the numeric `id` column type. Convenient, but if `id` is indexed, coercion can prevent index use (a performance bug) or, in some engines, cause a full-table scan due to type mismatch.

## 5. Diagrams / Mental Models

**JS `+` operator coercion decision:**
```
        a + b
          │
   either is string? ──yes──► convert both to string, CONCATENATE
          │
          no
          │
   convert both to number, ADD
```

**Truthiness table (JavaScript):**

| Value | Boolean coercion |
|-------|------------------|
| `0`, `NaN` | false |
| `""` (empty) | false |
| `null`, `undefined` | false |
| `false` | false |
| everything else (`"0"`, `[]`, `{}`) | **true** |

**`==` coercion trap:**
```
0 == ""       → true      (both coerced to 0)
0 == "0"      → true
"" == "0"     → false     (both strings, no coercion, differ)
null == undefined → true  (special rule)
```

## 6. Common Interview Questions

**Q1. What is type coercion?**
- **Answer:** Implicit, automatic type conversion the language performs on mismatched operands.
- **Mistake:** Calling it the same as explicit casting.

**Q2. Coercion vs conversion vs casting?**
- **Answer:** Conversion is the umbrella; coercion = implicit conversion; casting = explicit conversion.
- **Mistake:** Using them interchangeably.

**Q3. Why is `"5" + 1` = `"51"` but `"5" - 1` = `4` in JS?**
- **Answer:** `+` coerces toward string when either side is a string (concat); `-` has no string meaning, so both coerce to number.
- **Mistake:** Not knowing operator-specific coercion.

**Q4. What are falsy values in JavaScript?**
- **Answer:** `false, 0, "", null, undefined, NaN`.
- **Mistake:** Including `"0"` or `[]` (they're truthy).

**Q5. `==` vs `===` in JS?**
- **Answer:** `==` coerces before comparing; `===` compares type and value with no coercion.
- **Mistake:** Saying `===` is just "faster."

**Q6. Is coercion good or bad?**
- **Answer:** Convenient for numeric promotion; risky for weak-typing surprises. Prefer explicit conversion for clarity.
- **Mistake:** A one-sided answer.

**Q7. What is integer promotion / usual arithmetic conversions in C?**
- **Answer:** Small integer types promoted to int; mixed types converted to the higher-ranked type before the operation.
- **Mistake:** Ignoring signed/unsigned rules.

**Q8. Why does `5 / 2` give 2 in Java/C but 2.5 in Python 3?**
- **Answer:** In Java/C both are ints → integer division (no coercion). Python 3's `/` always produces float.
- **Mistake:** Blaming coercion for the Java result (it's the *absence* of coercion).

**Q9. Give a dangerous implicit-coercion bug.**
- **Answer:** JS `if (userInput == 0)` matching empty string; or C signed/unsigned comparison.
- **Mistake:** No concrete example.

**Q10. How do strongly-typed languages limit coercion?**
- **Answer:** They forbid most implicit conversions (e.g., Python won't coerce `"1" + 1`), forcing explicit conversion.
- **Mistake:** Confusing strong typing with static typing.

## 7. Deep-Dive Questions

**D1. Walk through how JS evaluates `[] + {}` and `{} + []`.**
`[] + {}`: `[]`→`""`, `{}`→`"[object Object]"`, concat → `"[object Object]"`. `{} + []` at statement start: `{}` is parsed as an empty block, `+[]` coerces `[]`→`""`→`0`. This shows coercion depends on both operator rules *and* parsing context.

**D2. What is the abstract algorithm behind JS `==` (Abstract Equality)?**
The spec defines step-by-step coercion: same type → compare directly; null/undefined special-cased; number vs string → string→number; boolean → number; object vs primitive → object's `toPrimitive`. This complexity is exactly why `===` is recommended.

**D3. How does coercion interact with operator overloading (C++/Python)?**
User-defined implicit conversion operators/constructors let objects coerce automatically (C++ non-`explicit` constructors). This can cause ambiguous overload resolution and unexpected conversions, which is why `explicit` exists to disable implicit coercion.

**D4. Why can implicit coercion hurt database index performance?**
If a query compares an indexed column with a mismatched-type literal, the engine may coerce the *column* per row (function on a column), defeating the index and forcing a scan. Best practice: match literal types to column types.

**D5. How does Python avoid JS-style coercion chaos while still allowing `3 + 4.5`?**
Python coerces only within the numeric tower (int→float→complex) and forbids cross-category coercion (`"1" + 1` raises `TypeError`). It's strongly typed, so it permits safe numeric promotion but refuses surprising string/number mixes.

## 8. Comparison Tables

**Coercion vs Casting (Conversion)**

| Aspect | Coercion (implicit) | Casting (explicit) |
|--------|---------------------|--------------------|
| Trigger | Automatic by language | Programmer writes it |
| Visibility | Hidden | Explicit in code |
| Safety | Can surprise | Intentional |
| Example | `3 + 4.5` | `(int) 4.5` |

**`==` vs `===` (JavaScript)**

| Aspect | `==` (loose) | `===` (strict) |
|--------|--------------|----------------|
| Coercion | Yes | No |
| Compares | Value after coercion | Type + value |
| `0 == "0"` | true | false |
| Recommendation | Avoid | Prefer |

**Strong vs Weak coercion behavior**

| Expression | Weak (JS) | Strong (Python) |
|------------|-----------|-----------------|
| `"5" + 1` | `"51"` | TypeError |
| `"5" - 1` | `4` | TypeError |
| `3 + 4.5` | `7.5` | `7.5` |

## 9. Common Mistakes

- Confusing coercion (implicit) with casting (explicit).
- Thinking `[]` and `"0"` are falsy in JS (they're truthy).
- Assuming `+` always adds - it concatenates when a string is involved.
- Blaming coercion for integer division (`5/2=2` is *no* coercion).
- Believing all languages coerce like JavaScript.

## 10. Edge Cases / Special Cases

- **`NaN == NaN` → false** (and `NaN` is falsy).
- **`null == undefined` → true**, but `null === undefined` → false.
- **`+` on arrays/objects:** coerces via `toString`/`toPrimitive`, giving weird results.
- **Signed/unsigned coercion in C:** `-1 < 1u` is false.
- **Empty string vs zero:** `"" == 0` → true in JS.
- **Locale/precision in string↔number:** `"1e3"` coerces to `1000`.

## 11. How to Explain in Interview

> "Type coercion is implicit type conversion - the language automatically converts operands to a common type when they mismatch, without me writing a cast. It's the safe, useful kind in numeric promotion, like adding an int and a double. But in weakly-typed languages like JavaScript it causes surprises: `+` concatenates if either side is a string, while `-` forces numbers, so `'5' + 1` is `'51'` but `'5' - 1` is `4`. That's why I prefer explicit conversion and strict equality `===` to keep behavior predictable."

## 12. Quick Revision Notes

- **Coercion = implicit conversion** (language-driven).
- **`+` in JS concatenates** if a string is involved; other operators coerce to number.
- **JS falsy:** `false, 0, "", null, undefined, NaN`.
- **`==` coerces, `===` doesn't** - prefer `===`.
- **Python is strong:** refuses `"1" + 1`; only numeric-tower coercion.
- **Trap:** `5/2=2` is absence of coercion; `[]` and `"0"` are truthy.

## 13. Practice Tasks

1. Predict outputs (JS): `1 + "2"`, `"3" * 2`, `true + true`, `[] + []`, `[] + {}`.
2. List all falsy values in JS and in Python; test with `if`.
3. Show `0 == ""`, `0 == "0"`, `"" == "0"`, `null == undefined` and explain each.
4. In C, print `-1 < 1u` and explain the signed/unsigned coercion.
5. Rewrite a coercion-buggy JS snippet using `Number()` and `===` to make it robust.

## 14. Final Cheat Sheet

- **Core definition:** Automatic, implicit conversion of mismatched operands by the language.
- **Why it matters:** Convenient but a top source of subtle bugs (esp. JS).
- **Most asked:** `+` vs `-` in JS, falsy values, `==` vs `===`.
- **Comparisons:** coercion/casting, `==`/`===`, weak/strong behavior.
- **One-liner:** "Implicit conversion the language applies automatically to make an operation's operand types agree."

---
---

# 7. Syntax-Directed Definitions (SDD)

## 1. Overview

**Definition:** A Syntax-Directed Definition (SDD) is a formal way to attach **semantic rules** (computations) to the **production rules** of a context-free grammar. Each grammar symbol gets **attributes** (values), and each production has rules that compute those attributes. It's the theoretical framework used to specify semantic analysis and translation.

**Why it matters:**
- It's how compilers formally connect *parsing* to *meaning/translation* (type checking, evaluating expressions, generating code).
- Turns a grammar into a specification for computing things (types, values, intermediate code) as you parse.
- Foundation for tools like yacc/bison (semantic actions).

**Where it is used in real systems:**
- Compiler front-ends (evaluate expressions, build ASTs, compute types).
- Parser generators (yacc/bison `{ $$ = $1 + $3; }` actions are SDD rules).
- Calculators, spreadsheet formula engines, query compilers.
- Any tool that translates structured input to output.

**Why interviewers ask:** SDDs connect grammar (CS theory) to practical translation. They test whether you understand synthesized vs inherited attributes and how meaning is computed during parsing.

## 2. Core Idea

**Intuition:** A grammar tells you *how* to parse; an SDD tells you *what to compute* at each parse step. You decorate each production `A → B C` with rules like "`A.val = B.val + C.val`". As the parser builds the tree, these rules fire to compute attribute values, ultimately producing the translation (e.g., the result of an expression or generated code).

**Real-world analogy:** A recipe with annotations. The grammar is the recipe's step structure ("combine A and B, then bake"). The SDD adds computations: "the calories of the dish = calories of A + calories of B." As you follow the recipe (parse), you also tally the calories (attributes).

**Small example (evaluate arithmetic):**
```
Grammar with semantic rules:
  E → E1 + T   { E.val = E1.val + T.val }
  E → T        { E.val = T.val }
  T → T1 * F   { T.val = T1.val * F.val }
  T → F        { T.val = F.val }
  F → ( E )    { F.val = E.val }
  F → digit    { F.val = digit.lexval }

For input "3 + 4 * 5":
  F(3)=3, F(4)=4, F(5)=5
  T = 4*5 = 20
  E = 3 + 20 = 23
```

**Step-by-step:**
1. Define attributes for each grammar symbol (e.g., `.val`, `.type`, `.code`).
2. Attach a semantic rule to each production computing attributes.
3. Parse the input, building a parse tree.
4. Evaluate the rules over the tree (in dependency order) to get the final attribute values.

## 3. Important Subtopics

### a) Synthesized Attributes
- **What:** An attribute computed from the attributes of a node's **children** (info flows *up* the tree).
- **Why:** Natural for bottom-up evaluation; the most common kind.
- **Example:** `E.val = E1.val + T.val` - parent's value from children.
- **Interview angle:** "Which attributes can LR/bottom-up parsers compute easily?" Synthesized.

### b) Inherited Attributes
- **What:** An attribute computed from the **parent and/or siblings** (info flows *down* or *across*).
- **Why:** Needed to pass context downward (e.g., a declared type to a list of variables).
- **Example:** In `D → T L`, `L.type = T.type` passes the type down to the list `L`.
- **Interview angle:** Give a case that requires inherited attributes (type declarations, symbol table passing).

### c) S-Attributed Definitions
- **What:** SDDs that use **only synthesized** attributes.
- **Why:** Can be evaluated during a single bottom-up (LR) parse - very efficient.
- **Example:** The arithmetic evaluator above is S-attributed.
- **Interview angle:** Why are S-attributed SDDs ideal for yacc/bison? (Evaluate on reduce.)

### d) L-Attributed Definitions
- **What:** SDDs where each inherited attribute depends only on the parent and **left siblings** (attributes to its left).
- **Why:** Can be evaluated in one left-to-right (depth-first) pass, compatible with top-down (LL) parsing.
- **Example:** Type declaration flowing left-to-right through a variable list.
- **Interview angle:** Difference between S- and L-attributed and which parser suits each.

### e) Dependency Graphs & Evaluation Order
- **What:** A graph showing which attributes depend on which; determines a valid evaluation order (topological sort).
- **Why:** Attributes must be computed in dependency order; cycles = ill-defined SDD.
- **Example:** `E.val` depends on `E1.val` and `T.val`, so children before parent.
- **Interview angle:** What if the dependency graph has a cycle? (No valid evaluation order - invalid SDD.)

## 4. Real-World Example

**Parser generator (yacc/bison) building a calculator:** The classic bison grammar:
```
expr : expr '+' expr   { $$ = $1 + $3; }   // synthesized: $$ from $1, $3
     | expr '*' expr   { $$ = $1 * $3; }
     | NUMBER          { $$ = $1; }
     ;
```
Here `$$` is the synthesized attribute of the left-hand nonterminal and `$1`, `$3` are children's attributes. This *is* an S-attributed SDD, evaluated as the LR parser reduces - exactly how real calculators and many DSL interpreters are built.

**Compiler type-computation:** When compiling `int a, b, c;`, an SDD with an *inherited* attribute passes the type `int` down the declaration list so each of `a`, `b`, `c` gets registered in the symbol table with type int - a textbook use of inherited attributes.

## 5. Diagrams / Mental Models

**Synthesized (up) vs Inherited (down):**
```
Synthesized:            Inherited:
      A                     A (has type)
     ╱ ╲  val↑             ╱ ╲  type↓
    B   C                 T   L ← L.type = T.type
  values flow UP        type flows DOWN to L
```

**Annotated parse tree for "3 + 4 * 5" (synthesized .val):**
```
             E.val=23
            ╱   |   ╲
       E.val=3  +   T.val=20
          │         ╱  |  ╲
       T.val=3  T.val=4 * F.val=5
          │         │        │
       F.val=3   F.val=4   digit 5
          │         │
       digit 3   digit 4
```

## 6. Common Interview Questions

**Q1. What is a syntax-directed definition?**
- **Answer:** A grammar augmented with attributes and semantic rules that compute those attributes.
- **Mistake:** Confusing SDD (declarative rules) with SDT (translation scheme with embedded actions).

**Q2. Synthesized vs inherited attributes?**
- **Answer:** Synthesized = from children (up); inherited = from parent/siblings (down/across).
- **Mistake:** Getting the direction backwards.

**Q3. What is an S-attributed definition?**
- **Answer:** Uses only synthesized attributes; evaluable in a bottom-up (LR) parse.
- **Mistake:** Saying it allows inherited attributes.

**Q4. What is an L-attributed definition?**
- **Answer:** Inherited attributes depend only on parent and left siblings; single left-to-right pass; suits LL parsing.
- **Mistake:** Confusing with S-attributed.

**Q5. Give an example needing inherited attributes.**
- **Answer:** Passing a declared type down a variable list (`int a, b, c;`).
- **Mistake:** Only giving synthesized examples.

**Q6. How are SDDs evaluated?**
- **Answer:** Build a dependency graph over the parse tree; evaluate attributes in topological (dependency) order.
- **Mistake:** Saying "left to right always."

**Q7. Every S-attributed SDD is also L-attributed - true?**
- **Answer:** True (no inherited attributes means the L-constraint is trivially satisfied).
- **Mistake:** Saying they're disjoint.

**Q8. Difference between SDD and SDT?**
- **Answer:** SDD specifies *what* to compute (rules); SDT (syntax-directed translation) embeds *actions* at specific positions in productions specifying *when*.
- **Mistake:** Treating them as identical.

**Q9. What do parser generators use SDDs for?**
- **Answer:** Semantic actions to build ASTs, evaluate expressions, generate code during parsing.
- **Mistake:** Thinking they're purely theoretical.

**Q10. What makes an SDD invalid?**
- **Answer:** A cyclic dependency graph (no valid evaluation order).
- **Mistake:** Not knowing cycles are the problem.

## 7. Deep-Dive Questions

**D1. Why can't a pure bottom-up (LR) parser directly handle all inherited attributes?**
Inherited attributes need context from the parent/left siblings *before* a node's subtree is fully reduced, but LR parsing reduces children before knowing the parent. Workarounds: restrict to L-attributed and use marker nonterminals, or store attributes on the parse stack.

**D2. How do you convert an L-attributed SDD to work with a top-down parser?**
Inherited attributes become *arguments* to the recursive-descent function for that nonterminal, and synthesized attributes become *return values*. Because L-attributed inheritance uses only parent/left-sibling info available at call time, a single left-to-right descent suffices.

**D3. How does the dependency graph determine evaluation order, and when does it fail?**
Nodes = attribute instances, edges = "depends on." A topological sort gives a valid order. If the graph has a cycle, no order exists and the SDD is ill-defined - practical tools restrict to S- or L-attributed forms to guarantee acyclicity.

**D4. Give an SDD that computes both a value and generates code (multiple attributes).**
```
E → E1 + T  { E.val = E1.val + T.val;
              E.code = E1.code || T.code || "ADD" }
```
Here `.val` and `.code` are two synthesized attributes computed together - showing SDDs can carry several attributes (types, values, code) simultaneously.

**D5. How do SDDs relate to type checking specifically?**
Give each expression node a synthesized `.type` attribute; productions carry rules like `E → E1 + E2 { E.type = check(E1.type, E2.type) }`. The SDD framework is exactly how type checkers are formally specified and implemented over the parse tree/AST.

## 8. Comparison Tables

**Synthesized vs Inherited Attributes**

| Aspect | Synthesized | Inherited |
|--------|-------------|-----------|
| Computed from | Children | Parent + siblings |
| Info flow | Up the tree | Down/across |
| Parser fit | Bottom-up (LR) | Top-down (LL) |
| Example | `E.val=E1.val+T.val` | `L.type=T.type` |

**S-attributed vs L-attributed**

| Aspect | S-attributed | L-attributed |
|--------|--------------|--------------|
| Attributes | Synthesized only | Synthesized + restricted inherited |
| Inherited dependency | None | Parent + left siblings only |
| Evaluation | Bottom-up, one pass | Left-to-right depth-first, one pass |
| Parser | LR | LL and LR |
| Relationship | Subset of L-attributed | Superset of S-attributed |

**SDD vs SDT (Syntax-Directed Translation)**

| Aspect | SDD | SDT |
|--------|-----|-----|
| Specifies | What to compute (rules) | When to act (embedded actions) |
| Position | Rules attached to production | Actions placed among symbols |
| Style | Declarative | Procedural |

## 9. Common Mistakes

- Swapping the definitions of synthesized (up) and inherited (down).
- Thinking S-attributed can use inherited attributes.
- Believing every SDD is evaluable (cycles make some invalid).
- Confusing SDD (rules) with SDT (embedded actions).
- Assuming LR parsers handle all inherited attributes easily.

## 10. Edge Cases / Special Cases

- **Cyclic dependencies:** invalid SDD - no evaluation order.
- **Multiple attributes per symbol:** a symbol can carry `.val`, `.type`, `.code` together.
- **Empty productions (ε):** attribute rules still apply, can be subtle.
- **Side effects in rules** (symbol-table inserts): order matters, must respect L-attributed constraints.
- **Non-L-attributed inherited attributes:** need multiple passes or explicit tree building first.

## 11. How to Explain in Interview

> "A syntax-directed definition is a context-free grammar where each symbol carries attributes and each production has semantic rules that compute them. There are two attribute kinds: synthesized, computed from a node's children and flowing up the tree, and inherited, computed from the parent or left siblings and flowing down. If an SDD uses only synthesized attributes it's S-attributed and can be evaluated in a single bottom-up parse, which is exactly what yacc/bison semantic actions do. If inherited attributes depend only on parent and left siblings, it's L-attributed and works with top-down parsing. SDDs are how we formally specify type checking and translation during parsing."

## 12. Quick Revision Notes

- **SDD:** grammar + attributes + semantic rules.
- **Synthesized:** from children, flows up (LR-friendly).
- **Inherited:** from parent/left siblings, flows down (LL-friendly).
- **S-attributed:** synthesized only → bottom-up one pass.
- **L-attributed:** inherited depends on parent + left siblings → left-to-right one pass.
- **Every S-attributed is L-attributed.** Cycles = invalid.
- **Trap:** SDD (what) vs SDT (when/embedded actions).

## 13. Practice Tasks

1. Write an S-attributed SDD to evaluate arithmetic with `+, *, ( )` and trace it on `2*(3+4)`.
2. Write an SDD with an inherited attribute for `int a, b, c;` that inserts each into a symbol table with its type.
3. Draw the dependency graph and give an evaluation order for `E → E1 + T`.
4. Convert an L-attributed SDD into recursive-descent functions (inherited = args, synthesized = returns).
5. In bison, write semantic actions for a mini calculator and identify each `$$/$1/$3` as an attribute.

## 14. Final Cheat Sheet

- **Core definition:** Grammar productions augmented with attributes and semantic rules to compute meaning.
- **Why it matters:** Formal basis for type checking, expression evaluation, and translation during parsing.
- **Most asked:** synthesized vs inherited, S- vs L-attributed, SDD vs SDT.
- **Comparisons:** synthesized/inherited, S-attributed/L-attributed.
- **One-liner:** "Attach attribute-computing rules to grammar productions so parsing also produces meaning."

---
---

# 8. Attribute Grammars

## 1. Overview

**Definition:** An attribute grammar is a context-free grammar **extended with attributes and rules** to formally specify the semantics (meaning) of a language. It's essentially the formal, complete model behind syntax-directed definitions - Knuth (1968) introduced it to give a rigorous framework for computing values on parse trees.

**Why it matters:**
- Provides a **mathematically rigorous** way to specify semantic analysis (types, values, code) beyond what a grammar alone can express.
- Basis for automatic generation of semantic analyzers.
- Clarifies the theory (synthesized/inherited attributes, dependencies, evaluation).

**Where it is used in real systems:**
- Compiler construction (semantic phase specification).
- Language workbenches and attribute-grammar systems (e.g., Silver, JastAdd).
- IDE tooling that computes derived information (types, errors) over syntax trees.
- Formal language semantics and DSL frameworks.

**Why interviewers ask:** It's the theoretical umbrella over SDDs; questions test whether you understand attributes, dependency evaluation, and how semantics attach to grammar - a sign of deep compiler knowledge.

## 2. Core Idea

**Intuition:** A context-free grammar can only describe *structure*, not *meaning*. An attribute grammar attaches **attributes** (typed values) to grammar symbols and **semantic rules/equations** to productions, so each node in a parse tree gets computed values. The full set of attribute values over the tree captures the program's semantics.

**Real-world analogy:** A blueprint (grammar) shows a building's structure. An attribute grammar is the blueprint annotated with engineering calculations: each beam's load (synthesized from what it supports) and each room's assigned power circuit (inherited from the floor's plan). Structure + computed properties = full specification.

**Small example:**
```
Grammar:  N → N1 B | B
          B → 0 | 1
Attribute: .val (value of the binary number)
Rules:
  N → N1 B   { N.val = N1.val * 2 + B.val }
  N → B      { N.val = B.val }
  B → 0      { B.val = 0 }
  B → 1      { B.val = 1 }

Input "101" → N.val = 5
```

**Step-by-step:**
1. Choose attributes for each symbol (synthesized and/or inherited).
2. Write semantic equations for each production defining those attributes.
3. Parse input → parse tree.
4. Build the attribute dependency graph, then evaluate attributes in a valid order.

## 3. Important Subtopics

### a) Synthesized & Inherited Attributes (the two kinds)
- **What:** Same as in SDDs - synthesized flow up (from children), inherited flow down (from parent/siblings).
- **Why:** Together they let information move both directions across the tree.
- **Example:** `.val` synthesized upward; a declared `.type` inherited downward.
- **Interview angle:** Attribute grammars formalize *both*; SDDs are their practical incarnation.

### b) Semantic Rules / Equations
- **What:** Functional equations that define each attribute in terms of others (`A.a = f(B.b, C.c)`).
- **Why:** They must be side-effect-free (pure) in the pure theory, making evaluation well-defined.
- **Example:** `N.val = N1.val * 2 + B.val`.
- **Interview angle:** Why prefer pure equations over imperative actions? (Deterministic, order-independent given dependencies.)

### c) Dependency Graph & Well-Definedness
- **What:** A directed graph of attribute dependencies; the grammar is *well-defined* (non-circular) if no parse tree yields a cyclic dependency.
- **Why:** Only acyclic graphs have a valid evaluation order.
- **Example:** Checking circularity is decidable but expensive (exponential in the worst case - Knuth).
- **Interview angle:** What makes an attribute grammar non-circular / well-defined?

### c) Attribute Evaluation Strategies
- **What:** Ways to compute attributes: tree walks, topological order, or restricted classes (S/L-attributed) enabling single-pass evaluation.
- **Why:** Determines efficiency and parser compatibility.
- **Example:** L-attributed grammars → one left-to-right pass.
- **Interview angle:** How do S/L-attributed restrictions simplify evaluation?

### e) Non-Circularity & Classes
- **What:** Sub-classes: absolutely non-circular, ordered, L-attributed, S-attributed - each easier to evaluate.
- **Why:** Practical compilers restrict to easy classes to guarantee efficient single-pass evaluation.
- **Example:** yacc/bison effectively supports S-attributed grammars.
- **Interview angle:** Why do real tools restrict to L/S-attributed grammars?

## 4. Real-World Example

**Language workbench (JastAdd/Silver):** These tools let you *declaratively* specify a compiler's semantics as an attribute grammar. You write equations like `eq Add.type() = combine(getLeft().type(), getRight().type());` and the framework computes types, name bindings, and errors over the AST automatically, with demand-driven (lazy) attribute evaluation. Real compilers (e.g., the ExtendJ Java compiler) are built this way.

**IDE semantic highlighting:** An editor computes, for each identifier, an inherited attribute pointing to its declaration (name binding) and a synthesized attribute for its type. These attribute computations power "go to definition," type-on-hover, and error underlining - conceptually an attribute grammar evaluated incrementally as you type.

## 5. Diagrams / Mental Models

**Attribute flow on a production:**
```
        A  ⟵ inherited in, synthesized out
       ╱|╲
      B C D
  Rules define:
    synthesized A.s = f(B.*, C.*, D.*)
    inherited   B.i = g(A.*, ...), C.i = h(A.*, B.*)...
```

**Dependency graph (binary number "10"):**
```
   N.val ─┐
     ▲    │ = N1.val*2 + B.val
  N1.val  B.val
     ▲       ▲
  B.val=1  digit 0
(evaluate leaves → up; acyclic → valid order exists)
```

**Class hierarchy of attribute grammars:**
```
   All attribute grammars
        └─ Non-circular
             └─ L-attributed
                  └─ S-attributed  (easiest, LR one-pass)
```

## 6. Common Interview Questions

**Q1. What is an attribute grammar?**
- **Answer:** A CFG extended with attributes on symbols and semantic rules on productions to specify semantics.
- **Mistake:** Equating it exactly with a plain grammar.

**Q2. Who introduced attribute grammars and why?**
- **Answer:** Donald Knuth (1968), to formally specify the semantics of context-free languages.
- **Mistake:** Not knowing the origin.

**Q3. What are the two kinds of attributes?**
- **Answer:** Synthesized (from children) and inherited (from parent/siblings).
- **Mistake:** Only mentioning one.

**Q4. What makes an attribute grammar well-defined?**
- **Answer:** Its attribute dependency graph is acyclic (non-circular) for every possible parse tree.
- **Mistake:** Ignoring circularity.

**Q5. How are attributes evaluated?**
- **Answer:** Build the dependency graph, topologically sort, evaluate in that order (or use S/L-attributed single-pass strategies).
- **Mistake:** Assuming a fixed left-to-right order always works.

**Q6. Difference between attribute grammar and SDD?**
- **Answer:** Attribute grammar is the general formal theory; an SDD is essentially the same idea used in compiler construction. In practice the terms overlap; SDDs may allow side-effecting actions, pure attribute grammars use side-effect-free equations.
- **Mistake:** Saying they're totally unrelated.

**Q7. Why restrict to S- or L-attributed grammars?**
- **Answer:** They guarantee a single-pass evaluation compatible with standard parsers (LR/LL).
- **Mistake:** Not linking restriction to efficiency.

**Q8. Can attribute grammars express context-sensitive checks?**
- **Answer:** Yes - things like "variable declared before use" that a CFG alone cannot, via attributes carrying symbol-table info.
- **Mistake:** Thinking they're limited to context-free power.

**Q9. What is a circular attribute grammar?**
- **Answer:** One where some parse tree's dependency graph contains a cycle → no valid evaluation order (ill-defined), unless using special circular-AG fixpoint evaluation.
- **Mistake:** Saying cycles are always fine.

**Q10. Give an application of attribute grammars.**
- **Answer:** Specifying/generating semantic analyzers, type checkers, and IDE tooling (JastAdd, Silver).
- **Mistake:** Calling them purely academic.

## 7. Deep-Dive Questions

**D1. How expensive is it to test an attribute grammar for circularity?**
Knuth showed the general circularity test is intrinsically exponential (it must consider all combinations of dependency patterns across productions). Practical systems avoid this by restricting to ordered/L-attributed grammars whose non-circularity is guaranteed by construction.

**D2. How do demand-driven (lazy) attribute evaluators work (e.g., JastAdd)?**
Attributes are computed on first access and memoized. Evaluating a top-level attribute recursively triggers only the attributes it depends on, naturally following the dependency graph without precomputing an explicit topological order - great for IDEs where you need only some attributes.

**D3. What are reference attributes and higher-order attribute grammars?**
Reference attributes let an attribute be a *pointer to another tree node* (e.g., a name's declaration), directly modeling name binding. Higher-order AGs let attributes be *new subtrees* computed on the fly, enabling desugaring/macro expansion within the AG framework.

**D4. How do inherited attributes complicate LR parsing, and what's the fix?**
LR parsers reduce bottom-up, so a node's inherited attributes (needing parent context) aren't available at reduction time. Fixes: restrict to L-attributed grammars with marker nonterminals that force early inherited-attribute computation, or evaluate attributes in a separate pass over a built tree.

**D5. Compare attribute grammars to operational and denotational semantics.**
Attribute grammars are a *static, compile-time* semantics tied to syntax (great for translation/type checking). Operational semantics describes *execution steps*; denotational maps programs to mathematical objects. AGs excel at specifying analyses computable directly on the parse tree.

## 8. Comparison Tables

**Attribute Grammar vs Plain CFG**

| Aspect | CFG | Attribute Grammar |
|--------|-----|-------------------|
| Describes | Structure only | Structure + semantics |
| Power | Context-free | Can express context-sensitive checks |
| Output | Parse tree | Annotated (attributed) tree |
| Example use | Parsing | Type checking, translation |

**Synthesized vs Inherited (recap in AG context)**

| Aspect | Synthesized | Inherited |
|--------|-------------|-----------|
| Source | Children | Parent + siblings |
| Direction | Up | Down/across |
| Typical use | Values, types | Context (declared type, scope) |

**Attribute Grammar Classes**

| Class | Restriction | Evaluation |
|-------|-------------|-----------|
| S-attributed | Synthesized only | Bottom-up, 1 pass |
| L-attributed | Inherited from parent/left siblings | Left-to-right, 1 pass |
| Non-circular | Acyclic deps | Topological order |
| Circular | Cycles allowed | Fixpoint iteration (special) |

## 9. Common Mistakes

- Thinking attribute grammars are just fancier CFGs with no added power (they express context-sensitive constraints).
- Ignoring the circularity/well-definedness requirement.
- Confusing synthesized and inherited directions.
- Believing evaluation is always simple left-to-right.
- Treating attribute grammars as purely academic (they power real tools like JastAdd).

## 10. Edge Cases / Special Cases

- **Circular grammars:** need special fixpoint evaluation or are rejected.
- **Multiple passes:** non-L-attributed grammars may require several tree traversals.
- **Reference attributes:** attributes pointing to other nodes (name binding).
- **Higher-order attributes:** attributes that are themselves trees.
- **Side effects:** pure AGs forbid them; practical SDTs allow them but require careful ordering.

## 11. How to Explain in Interview

> "An attribute grammar, introduced by Knuth, extends a context-free grammar with attributes on grammar symbols and semantic equations on productions, so it can specify meaning, not just structure. Attributes come in two flavors - synthesized, computed from children and flowing up, and inherited, computed from the parent or siblings and flowing down. To evaluate them you build a dependency graph and, if it's acyclic, compute attributes in topological order. In practice we restrict to S- or L-attributed grammars so evaluation happens in a single parser pass. It's the formal framework behind type checking, name binding, and translation."

## 12. Quick Revision Notes

- **Attribute grammar:** CFG + attributes + semantic equations (Knuth, 1968).
- **Two attribute kinds:** synthesized (up), inherited (down).
- **Well-defined = acyclic** dependency graph.
- **Classes:** S-attributed ⊂ L-attributed ⊂ non-circular.
- **Can express context-sensitive checks** (declare-before-use).
- **Trap:** circularity test is exponential; real tools restrict classes.

## 13. Practice Tasks

1. Write an attribute grammar computing the decimal value of a binary string and evaluate "1101".
2. Add an inherited `.scale` attribute to handle fractional binary "101.11".
3. Draw the dependency graph for one production and check acyclicity.
4. Classify three sample grammars as S-attributed, L-attributed, or neither.
5. Sketch a reference attribute that links a variable use to its declaration (name binding).

## 14. Final Cheat Sheet

- **Core definition:** CFG extended with attributes and semantic rules to specify semantics.
- **Why it matters:** Rigorous foundation for semantic analysis and translation; powers real tools.
- **Most asked:** synthesized vs inherited, well-definedness/circularity, S/L-attributed classes.
- **Comparisons:** AG vs CFG; attribute classes.
- **One-liner:** "Knuth's formalism: attach attributes and equations to a grammar so parse trees carry computed meaning."

---
---

# 9. Type Inference Basics

## 1. Overview

**Definition:** Type inference is the compiler's ability to **automatically deduce the types** of expressions and variables *without* explicit type annotations, while keeping the program statically typed and safe.

**Why it matters:**
- Gives the safety and performance of static typing with the brevity of dynamic-looking code.
- Reduces boilerplate: you write `let x = 5` and the compiler knows `x : int`.
- Central to modern languages (Haskell, ML, Rust, Swift, Kotlin, TypeScript, C++ `auto`).

**Where it is used in real systems:**
- ML/Haskell (full Hindley-Milner inference).
- Rust, Swift, Kotlin, Scala (local + generic inference).
- C++ `auto`/templates, Java `var`, C# `var`.
- TypeScript (infers types across a large codebase).

**Why interviewers ask:** It shows understanding of type systems beyond checking - how a compiler *solves* for types using unification and constraints, a favorite for candidates claiming language/compiler depth.

## 2. Core Idea

**Intuition:** Even without annotations, the *usage* of a value constrains its type. If you write `x + 1` and `1` is an int, then `x` must be an int. Type inference gathers these constraints from how expressions are used and solves them to assign a consistent type to everything.

**Real-world analogy:** A detective (Sherlock) deducing facts from clues. You never state "the suspect is left-handed," but the evidence (the knife angle, the writing) forces that conclusion. The compiler similarly deduces types from evidence in the code.

**Small example:**
```rust
let x = 5;          // 5 is i32 → x : i32
let y = x + 1;      // int + int → y : i32
let s = "hi";       // string literal → s : &str
fn id(a) { a }      // (ML-style) a's type unknown → id : ∀T. T → T (polymorphic)
```

**Step-by-step (Hindley-Milner style):**
1. Assign a fresh type variable to each unknown (e.g., `x : α`, `y : β`).
2. Generate constraints from each expression (`x + 1` ⇒ `α = int`).
3. **Unify** the constraints (solve the equations) to bind type variables.
4. **Generalize** remaining free type variables into polymorphic types (∀).
5. If unification fails, report a type error.

## 3. Important Subtopics

### a) Unification
- **What:** The core algorithm: make two type expressions equal by finding substitutions for type variables.
- **Why:** It's how constraints get solved (`α → int` etc.).
- **Example:** Unify `α → bool` with `int → β` ⇒ `α = int`, `β = bool`.
- **Interview angle:** What happens if you try to unify `int` with `bool`? (Fail → type error.)

### b) Hindley-Milner (HM) Type System
- **What:** The classic type-inference algorithm (Algorithm W) giving *complete* inference for let-polymorphism without annotations.
- **Why:** Foundation of ML/Haskell; principal (most general) types.
- **Example:** `map`'s type inferred as `(a → b) → [a] → [b]`.
- **Interview angle:** What is a "principal type"? (The most general type from which all valid types are instances.)

### c) Local vs Global Inference
- **What:** Local infers within a small region (a statement, one function); global infers across the whole program.
- **Why:** Global (HM) is powerful but can give confusing errors; local (C++ `auto`, Java `var`) is simpler and predictable.
- **Example:** Java `var x = list.get(0);` infers from the RHS only.
- **Interview angle:** Why do C++/Java use local inference instead of full HM? (Simpler errors, overloading interaction, predictability.)

### d) Generalization & Let-Polymorphism
- **What:** After solving, free type variables are generalized so a definition can be used at multiple types.
- **Why:** Enables reusable polymorphic functions like `identity`.
- **Example:** `let id = fun x -> x` gets `∀a. a → a`; usable as `int→int` and `string→string`.
- **Interview angle:** Why does generalization happen at `let` but not for lambda parameters?

### e) Bidirectional Type Checking
- **What:** Combines *inference* (synthesize a type) with *checking* (verify against an expected type), passing type info both ways.
- **Why:** Handles features HM can't (subtyping, higher-rank types) with good error messages.
- **Example:** TypeScript, Rust, and Swift use bidirectional approaches.
- **Interview angle:** Difference between "synthesize" and "check" modes.

## 4. Real-World Example

**TypeScript in a web codebase:** You write `const nums = [1, 2, 3];` and TypeScript infers `nums : number[]`. Then `nums.map(n => n * 2)` infers `n : number` and the result `number[]` - all without a single annotation. If you later write `nums.push("four")`, inference has already fixed the element type to `number`, so the error is caught. This is inference providing safety with almost dynamic-looking syntax.

**Rust ownership + inference:** `let v = vec![1, 2, 3];` infers `Vec<i32>`. When you call `v.iter().sum()`, Rust infers the sum's type from context (e.g., the variable it's assigned to). Inference lets Rust stay explicit about ownership while omitting most type annotations.

## 5. Diagrams / Mental Models

**Constraint solving pipeline:**
```
code → assign type vars → collect constraints → UNIFY → generalize → types
 x=5     x:α                α = int              x:int    (∀ if free)
 y=x+1   y:β                β = int, α = int     y:int
```

**Unification as equation solving:**
```
   α → bool   =   int → β
   ────────       ────────
   α = int   ,   β = bool     ✓ (success)

   int        =   bool
   ───────────────────
   FAIL → type error
```

**Local vs Global inference:**
```
Local (Java var):   var x = f();   // type from RHS only, here
Global (HM):        analyzes whole program, propagates everywhere
```

## 6. Common Interview Questions

**Q1. What is type inference?**
- **Answer:** Automatic deduction of types without explicit annotations, keeping the program statically typed.
- **Mistake:** Confusing it with dynamic typing.

**Q2. Does type inference make a language dynamically typed?**
- **Answer:** No - types are still fixed and checked at compile time; only the annotation is omitted.
- **Mistake:** Thinking `auto`/`var` = dynamic.

**Q3. What is unification?**
- **Answer:** The algorithm that solves type constraints by making two type expressions equal via variable substitution.
- **Mistake:** Not knowing the core mechanism.

**Q4. What is the Hindley-Milner type system?**
- **Answer:** A complete inference system (Algorithm W) for let-polymorphism giving principal types; basis of ML/Haskell.
- **Mistake:** Not knowing it or confusing it with dynamic typing.

**Q5. What is a principal (most general) type?**
- **Answer:** The most general type of an expression, from which every other valid type is an instance.
- **Mistake:** Giving a specific type instead of the general one.

**Q6. Local vs global type inference?**
- **Answer:** Local infers within a small scope (Java `var`); global across the whole program (HM).
- **Mistake:** Conflating the two.

**Q7. What happens when inference fails?**
- **Answer:** Unification can't reconcile constraints → a compile-time type error.
- **Mistake:** Saying it falls back to dynamic typing.

**Q8. Why can't Java use full HM inference?**
- **Answer:** Overloading and subtyping interact badly with HM; local inference gives clearer errors and predictability.
- **Mistake:** Saying "it's just not implemented."

**Q9. What is let-polymorphism / generalization?**
- **Answer:** Generalizing free type variables at `let` so a definition is reusable at many types.
- **Mistake:** Ignoring where generalization happens.

**Q10. Give an example of an inferred polymorphic type.**
- **Answer:** `identity : ∀a. a → a`, or `map : (a→b) → [a] → [b]`.
- **Mistake:** Giving a monomorphic type.

## 7. Deep-Dive Questions

**D1. Walk through Algorithm W on `fun x -> x + 1`.**
Assign `x : α`. The body `x + 1`: `+` requires `int → int → int`, so `α = int`. No free variables remain, so the type is `int → int` (monomorphic here). If the body were just `x`, `α` stays free and generalizes to `∀α. α → α`.

**D2. What is the "occurs check" and why is it needed?**
During unification, before binding `α = τ`, verify `α` does not occur inside `τ`. Without it, unifying `α = α → β` would create an infinite type. The occurs check rejects such cases, keeping types finite (this is what catches many "cannot construct infinite type" Haskell errors).

**D3. Why is HM inference decidable and efficient, but adding certain features breaks it?**
HM is decidable (nearly linear in practice with union-find unification) because it restricts polymorphism to let-bindings (rank-1). Adding higher-rank polymorphism, subtyping, or dependent types makes inference undecidable, so those languages require some annotations.

**D4. How does bidirectional type checking improve on pure inference?**
It alternates between *synthesis* (compute a type from the term) and *checking* (verify a term against a known expected type). Checking mode pushes expected types inward, enabling inference for constructs HM can't handle and producing far better, localized error messages.

**D5. Why can type inference produce confusing "action at a distance" errors?**
In global HM, a type is determined by constraints scattered across the program. A wrong use far away can force a variable's type, and the error surfaces at a seemingly unrelated location. This is a known usability cost of powerful global inference, mitigated by annotations at boundaries.

## 8. Comparison Tables

**Type Inference vs Dynamic Typing**

| Aspect | Type Inference | Dynamic Typing |
|--------|----------------|----------------|
| Types fixed | At compile time | At runtime (per value) |
| Annotations | Omitted but exist | No static types |
| Errors | Compile time | Runtime |
| Example | Haskell, Rust, TS | Python, JS |

**Local vs Global Inference**

| Aspect | Local | Global (HM) |
|--------|-------|-------------|
| Scope | One expression/statement | Whole program |
| Power | Limited | High (polymorphism) |
| Errors | Clear, localized | Can be non-local |
| Examples | Java `var`, C++ `auto` | ML, Haskell |

**Inference vs Explicit Annotation**

| Aspect | Inference | Explicit |
|--------|-----------|----------|
| Boilerplate | Less | More |
| Readability | Concise (can hide types) | Self-documenting |
| Error clarity | Sometimes worse | Often better |

## 9. Common Mistakes

- Believing inference makes a language dynamically typed.
- Thinking `auto`/`var` defers type decisions to runtime.
- Forgetting the occurs check (infinite types).
- Assuming HM handles subtyping/overloading (it doesn't well).
- Expecting inference to always give crystal-clear error locations.

## 10. Edge Cases / Special Cases

- **Empty collections:** `let x = []` - element type ambiguous, may need annotation.
- **Numeric literal defaulting:** Haskell defaults ambiguous numeric types; Rust needs a suffix or context.
- **Recursive functions:** need a type variable for self before generalizing.
- **Value restriction (ML):** limits generalization of mutable/side-effecting expressions for soundness.
- **Overloaded literals/operators:** interact awkwardly with inference (why C++/Java stay local).

## 11. How to Explain in Interview

> "Type inference lets the compiler figure out types automatically while keeping the program statically typed - I write `let x = 5` and it deduces `x : int`. The classic approach is Hindley-Milner: assign fresh type variables to unknowns, collect constraints from how values are used, then unify those constraints to solve for concrete types, generalizing anything still free into a polymorphic type. Unification is the core step, and the occurs check prevents infinite types. Languages like Haskell and ML do full global inference, while Java's `var` and C++'s `auto` do simpler local inference for clearer errors. Crucially, it's still compile-time static typing - just without writing the annotations."

## 12. Quick Revision Notes

- **Definition:** Auto-deduce static types without annotations.
- **Core algorithm:** unification (solve type-equation constraints).
- **HM / Algorithm W:** complete inference, principal types, let-polymorphism.
- **Occurs check:** prevents infinite types.
- **Local (Java `var`) vs global (HM).**
- **Trap:** inference ≠ dynamic typing; global inference can give non-local errors.

## 13. Practice Tasks

1. By hand, infer the type of `fun f -> fun x -> f (f x)` (answer: `(a→a) → a → a`).
2. Unify `α → β` with `int → (bool → γ)`; give the substitution.
3. In Rust, write `let v = Vec::new();` and show why it needs a type hint until used.
4. In Haskell/ghci, use `:t map`, `:t (.)`, `:t foldr` and interpret the inferred types.
5. Trigger an "occurs check"/"infinite type" error (e.g., `let f x = x x`) and explain it.

## 14. Final Cheat Sheet

- **Core definition:** Compiler deduces static types automatically without annotations.
- **Why it matters:** Static safety + performance with dynamic-like brevity.
- **Most asked:** unification, Hindley-Milner, principal type, inference vs dynamic.
- **Comparisons:** inference/dynamic, local/global.
- **One-liner:** "Assign type variables, gather constraints, unify to solve - static typing without the annotations."

---
---

# 10. Overloading Resolution

## 1. Overview

**Definition:** Overloading lets multiple functions/operators share the same name but differ in their **parameter types or counts**. **Overloading resolution** is the semantic-analysis process that decides *which* specific overload a given call refers to, based on the argument types.

**Why it matters:**
- Enables intuitive APIs: one `print`, `+`, or `add` name for many types.
- The compiler must pick the *correct and unambiguous* overload, or report an error.
- Common source of subtle bugs and ambiguity errors in C++/Java.

**Where it is used in real systems:**
- Operator overloading (`+` for int, float, string, matrices).
- Method overloading (`System.out.println` has ~10 overloads).
- Constructor overloading.
- Standard libraries (`std::max`, `abs`, `open`).

**Why interviewers ask:** It tests understanding of static dispatch, how the compiler matches calls to signatures, conversions, and ambiguity - and how overloading differs from overriding (a classic confusion).

## 2. Core Idea

**Intuition:** When you call `add(2, 3)`, several functions named `add` might exist (`add(int,int)`, `add(double,double)`, `add(string,string)`). The compiler looks at the argument types and finds the overload whose parameters best match - possibly applying conversions - and if exactly one is clearly best, it binds the call to it. This decision is made at **compile time** (static dispatch).

**Real-world analogy:** Calling a company's "support" line where one number routes you based on what you say. You say "billing" (int args) → billing team; "tech" (string args) → tech team. The receptionist (compiler) routes your call to the right department by matching your request to available options.

**Small example (C++):**
```cpp
int    add(int a, int b)       { return a + b; }
double add(double a, double b)  { return a + b; }
string add(string a, string b)  { return a + b; }

add(2, 3);        // → add(int,int)
add(2.0, 3.0);    // → add(double,double)
add("a", "b");    // → add(string,string)  (with string args)
add(2, 3.0);      // ambiguous or converts int→double → add(double,double)
```

**Step-by-step (resolution):**
1. Gather all candidate functions with the given name (candidate set).
2. Keep those with a compatible number of parameters (viable candidates).
3. For each, determine if arguments match, exactly or via conversions.
4. Rank matches (exact > promotion > standard conversion > user-defined conversion).
5. Pick the single best match; if tie → ambiguity error; if none → no-match error.

## 3. Important Subtopics

### a) Signature-Based Selection
- **What:** Overloads distinguished by parameter types/count (the *signature*), not the return type.
- **Why:** Return type alone can't disambiguate a call (you may ignore the result).
- **Example:** `int f()` and `double f()` differing only in return type is illegal in C++/Java.
- **Interview angle:** "Can you overload on return type?" No (in C++/Java).

### b) Argument Matching & Conversion Ranking
- **What:** The compiler ranks candidates by how good the argument match is: exact match, promotion (int→long), standard conversion (int→double), user-defined conversion.
- **Why:** Determines which overload wins when no exact match exists.
- **Example:** `f(int)` vs `f(double)` called with `f('a')`: char promotes to int → `f(int)` preferred.
- **Interview angle:** Order of preference among conversion categories.

### c) Ambiguity
- **What:** When two or more overloads match equally well, the compiler errors.
- **Why:** The compiler won't guess; you must disambiguate (cast or add an overload).
- **Example:** `f(int,double)` and `f(double,int)` called with `f(1,1)` → ambiguous.
- **Interview angle:** How to resolve an ambiguity error? (Explicit cast or exact-match overload.)

### d) Overloading vs Overriding (Polymorphism)
- **What:** Overloading = same name, different signatures, resolved at **compile time** (static/early binding). Overriding = subclass redefines a base method with the *same* signature, resolved at **runtime** (dynamic/late binding).
- **Why:** Frequently confused; they're fundamentally different dispatch mechanisms.
- **Example:** Overload: `print(int)` vs `print(String)`. Override: `Animal.sound()` vs `Dog.sound()`.
- **Interview angle:** The #1 overloading interview question - explain the difference precisely.

### e) Operator Overloading
- **What:** Giving operators (`+`, `==`, `[]`) custom meaning for user types.
- **Why:** Makes user types feel built-in (`complex1 + complex2`).
- **Example:** C++ `Vector operator+(const Vector&, const Vector&)`.
- **Interview angle:** Which languages allow it? (C++, Python, C#, Kotlin - not Java.)

## 4. Real-World Example

**Java standard library - `println`:** `System.out.println` is overloaded for `int`, `double`, `char`, `String`, `Object`, `boolean`, etc. When you call `println(42)`, the compiler resolves to `println(int)`; `println("hi")` resolves to `println(String)`. This is why you can print anything with one method name - overloading resolution picks the right version at compile time based on the argument's static type.

**C++ `std::max` / operator `+`:** For a custom `Money` class, overloading `operator+` lets `salary + bonus` work naturally. The compiler resolves `+` to your `Money operator+(Money, Money)`. If you also define `Money operator+(Money, int)`, calling `salary + 100` resolves to that overload - a real design decision in financial libraries.

## 5. Diagrams / Mental Models

**Resolution funnel:**
```
   Call: add(2, 3.0)
        │
  [All candidates named add]  ← add(int,int), add(double,double), add(string,string)
        │  filter by arity/compatibility
  [Viable candidates]          ← add(int,int)?, add(double,double)?
        │  rank by conversion quality
  [Best match]                 ← add(double,double)  (int→double conversion)
        │
   exactly one? → BIND
   tie?         → AMBIGUITY error
   none?        → NO MATCH error
```

**Overloading vs Overriding:**
```
OVERLOADING (compile time, same class):
   print(int)   print(String)   print(double)   ← chosen by arg type

OVERRIDING (runtime, inheritance):
   Animal.sound()  ←overridden by→  Dog.sound()  ← chosen by actual object
```

## 6. Common Interview Questions

**Q1. What is function overloading?**
- **Answer:** Multiple functions with the same name but different parameter types/counts.
- **Mistake:** Saying "different return types."

**Q2. Overloading vs overriding?**
- **Answer:** Overloading = same name, different signature, compile-time (static). Overriding = same signature in subclass, runtime (dynamic).
- **Mistake:** Swapping compile-time/runtime.

**Q3. Can you overload based on return type alone?**
- **Answer:** No (in C++/Java) - the call site may ignore the return value, so it can't disambiguate.
- **Mistake:** Saying yes.

**Q4. How does the compiler resolve an overloaded call?**
- **Answer:** Build candidate set → viable candidates → rank by conversion quality → pick single best.
- **Mistake:** Saying "it picks the first one."

**Q5. What causes an ambiguity error?**
- **Answer:** Two or more overloads match equally well with no single best.
- **Mistake:** Blaming "too many overloads" generally.

**Q6. What is the order of conversion preference?**
- **Answer:** Exact match > promotion > standard conversion > user-defined conversion.
- **Mistake:** Not knowing the ranking.

**Q7. Is overloading static or dynamic binding?**
- **Answer:** Static (early) binding - resolved at compile time by static argument types.
- **Mistake:** Calling it dynamic.

**Q8. Does Java support operator overloading?**
- **Answer:** No (except built-in `+` for strings); C++, Python, C#, Kotlin do.
- **Mistake:** Saying Java supports it.

**Q9. Can overloaded methods have different access modifiers / exceptions?**
- **Answer:** Yes - overloads are independent methods; only the signature must differ.
- **Mistake:** Thinking they must match.

**Q10. What if no overload matches?**
- **Answer:** Compile error ("no matching function").
- **Mistake:** Assuming it defaults to one.

## 7. Deep-Dive Questions

**D1. Walk through C++ overload resolution's three phases.**
(1) *Name lookup* gathers all candidates. (2) *Viability* filters by argument count and whether each argument is convertible. (3) *Best-match ranking* compares viable candidates using implicit conversion sequences; if one is strictly better on all arguments and no worse on any, it wins; otherwise ambiguity.

**D2. How does overloading interact with templates in C++?**
Non-template exact matches are preferred over template instantiations; if a template gives a better match it wins. Partial ordering of function templates decides between competing templates. This "overload set" including templates is a common source of surprising selections.

**D3. Why does overriding need a vtable but overloading doesn't?**
Overloading is resolved at compile time from static types - the compiler emits a direct call. Overriding depends on the *runtime* object type, so the compiler emits an indirect call through a virtual table (vtable) that dispatches to the correct override at runtime.

**D4. How does Java handle overloading with autoboxing and varargs?**
Java resolves in phases: (1) without boxing/varargs, (2) allowing boxing/unboxing, (3) allowing varargs. Earlier phases win, so `f(int)` beats `f(Integer)` beats `f(int...)` for `f(1)`. This phased approach prevents ambiguity from new language features.

**D5. Can overloading and inheritance cause hiding surprises?**
Yes. In C++, an overload in a derived class *hides* all base-class overloads of that name (name hiding), so you may need `using Base::f;` to bring them back. In Java, overloads across a hierarchy all remain visible but resolution uses the static type, causing "which overload?" surprises.

## 8. Comparison Tables

**Overloading vs Overriding**

| Aspect | Overloading | Overriding |
|--------|-------------|------------|
| Signature | Different | Same |
| Where | Same class | Subclass vs base |
| Binding | Static (compile time) | Dynamic (runtime) |
| Based on | Argument types | Actual object type |
| Polymorphism | Compile-time (ad-hoc) | Runtime (subtype) |
| Return type | Must differ in params | Same/covariant |

**Overloading vs Generics/Templates**

| Aspect | Overloading | Generics |
|--------|-------------|----------|
| Mechanism | Multiple named functions | One parameterized definition |
| Code | Duplicated per type | Single reusable |
| Selection | By best match | By type parameter |

**Conversion ranking (best → worst)**

| Rank | Category | Example |
|------|----------|---------|
| 1 | Exact match | `int` → `int` |
| 2 | Promotion | `char`/`short` → `int` |
| 3 | Standard conversion | `int` → `double` |
| 4 | User-defined conversion | class → via constructor/operator |

## 9. Common Mistakes

- Confusing overloading (compile time, static) with overriding (runtime, dynamic).
- Believing you can overload on return type alone.
- Thinking the compiler "picks the first" overload (it ranks by best match).
- Assuming Java supports user-defined operator overloading.
- Ignoring implicit conversions that cause unexpected overload selection or ambiguity.

## 10. Edge Cases / Special Cases

- **Ambiguity from equal conversions:** `f(long)` vs `f(double)` called with an `int`.
- **`nullptr`/`null` arguments:** may match multiple pointer/reference overloads ambiguously.
- **Autoboxing vs widening (Java):** widening preferred over boxing (`f(long)` beats `f(Integer)` for `int`).
- **Varargs last resort:** chosen only if no fixed-arity overload matches.
- **Name hiding (C++):** derived-class overload hides base overloads.
- **Const/reference overloads:** `f(const T&)` vs `f(T&&)` selected by value category.

## 11. How to Explain in Interview

> "Overloading is having multiple functions with the same name but different parameter lists. Overloading resolution is how the compiler, at compile time, picks which one a call refers to: it collects all candidates with that name, keeps the ones whose parameter count and types are compatible, ranks them by how good the argument match is - exact match beats a promotion beats a standard conversion - and selects the single best. If two tie, it's an ambiguity error; if none fit, a no-match error. It's static, early binding based on the arguments' static types, which is the key difference from overriding, which is resolved dynamically at runtime by the actual object type."

## 12. Quick Revision Notes

- **Overloading:** same name, different signatures; resolved at compile time (static dispatch).
- **Cannot overload on return type alone.**
- **Resolution:** candidates → viable → rank by conversion → best match.
- **Conversion order:** exact > promotion > standard > user-defined.
- **Overloading vs overriding:** static/signature-differs vs dynamic/same-signature.
- **Trap:** ambiguity errors; Java has no user operator overloading; static-type-based selection.

## 13. Practice Tasks

1. In C++, define `f(int)`, `f(double)`, `f(char)`; call with `f('a')`, `f(2)`, `f(2.0)` and predict each.
2. Create an ambiguous call (`f(long)`/`f(double)` with an int arg) and read the error; fix with a cast.
3. In Java, test resolution order: `f(int)`, `f(Integer)`, `f(long)`, `f(int...)` called with `f(1)`.
4. Overload `operator+` for a `Complex` class in C++/Python and verify `a + b`.
5. Contrast: write one overloaded set and one overridden hierarchy; explain which binds when.

## 14. Final Cheat Sheet

- **Core definition:** Choosing which same-named function a call refers to, by argument types, at compile time.
- **Why it matters:** Enables clean APIs; ambiguity and static-dispatch subtleties cause real bugs.
- **Most asked:** overloading vs overriding, can't overload on return type, resolution steps.
- **Comparisons:** overloading/overriding, overloading/generics, conversion ranks.
- **One-liner:** "Compile-time selection of the best-matching same-named function based on argument types."

---
---

# 11. Name Binding

## 1. Overview

**Definition:** Name binding is the association between an **identifier (name)** and the **entity it refers to** (a variable, function, object, memory location, or value). It answers: "When I write `x`, *what* does `x` actually refer to?" Semantic analysis resolves these bindings.

**Why it matters:**
- Every use of a name must be connected to the right declaration/entity.
- Determines *when* the connection is fixed (compile time vs runtime) and *how long* it lasts.
- Underpins scope, closures, polymorphism, and how variables map to storage.

**Where it is used in real systems:**
- Compilers/interpreters resolving every identifier.
- Linkers binding symbol names to addresses.
- Dynamic linking (binding `printf` to libc at load/run time).
- Virtual method dispatch (binding a call to an implementation).
- DNS (binding a hostname to an IP - a real-world "name binding").

**Why interviewers ask:** It ties together scope, static vs dynamic dispatch, binding time, and storage - a conceptual glue topic that reveals depth across compiler and runtime systems.

## 2. Core Idea

**Intuition:** A name is just a label. Binding is drawing the arrow from that label to the actual thing (a memory cell, a function body, a value). Different aspects of binding get fixed at different *times*: some at compile time (a local variable's type/offset), some at link time (a global's address), some at runtime (which override a virtual call hits).

**Real-world analogy:** A phone contact. "Mom" (name) is *bound* to a phone number (entity). Static binding is like writing the number in permanent ink at setup. Dynamic binding is like the number being looked up fresh each time you call, so it can change. Rebinding "Mom" to a new number is *reassignment*.

**Small example:**
```python
x = 10          # bind name 'x' to the object 10
x = "hello"     # REBIND 'x' to a new object (string)
def f(): ...    # bind 'f' to a function object
g = f           # bind 'g' to the same function object
```

**Step-by-step (what binding decides):**
1. **What entity** the name refers to (via scope rules + symbol table).
2. **Binding time:** when the association is fixed (compile, link, load, or run time).
3. **Storage:** where the entity lives (register, stack, heap, static memory).
4. **Lifetime:** how long the binding/entity is valid.

## 3. Important Subtopics

### a) Binding Time
- **What:** *When* a name-to-entity association is established: language-design time, compile time, link time, load time, or runtime.
- **Why:** Earlier binding → more optimization/safety; later binding → more flexibility.
- **Example:** A local variable's offset is bound at compile time; a virtual call's target at runtime.
- **Interview angle:** "Explain binding times with examples" - list the spectrum from compile to runtime.

### b) Static (Early) vs Dynamic (Late) Binding
- **What:** Static = resolved at compile time (known target). Dynamic = resolved at runtime (target depends on runtime type/state).
- **Why:** Determines dispatch cost and polymorphism (overriding needs dynamic binding).
- **Example:** Overloaded call = static; virtual/overridden method = dynamic (vtable).
- **Interview angle:** Which OOP feature *requires* dynamic binding? (Runtime polymorphism/overriding.)

### c) Scope of a Binding
- **What:** The region of the program where a binding is active/visible (from scope checking).
- **Why:** The same name can have different bindings in different scopes.
- **Example:** Inner `x` binding shadows the outer one within its block.
- **Interview angle:** How do scope and binding relate? (Scope defines *where* a binding holds.)

### d) Lifetime / Extent of a Binding
- **What:** How long the bound entity (and its storage) exists: static (whole program), automatic (stack frame), dynamic (heap until freed).
- **Why:** Distinguishes scope (visibility) from lifetime (existence) - a common confusion.
- **Example:** A `static` local variable persists across calls (lifetime = program) but is visible only in its function (scope = local).
- **Interview angle:** Difference between scope and lifetime (visibility vs existence).

### e) Rebinding vs Mutation
- **What:** Rebinding changes *what a name points to*; mutation changes *the entity's contents*.
- **Why:** Crucial in languages like Python where names are references.
- **Example:** `lst = [1]; lst = [2]` (rebind) vs `lst.append(3)` (mutate the same object).
- **Interview angle:** Why does reassigning inside a function not affect the caller, but mutation does? (Rebinding is local; mutation shares the object.)

## 4. Real-World Example

**Dynamic linking in the OS:** When a program calls `printf`, the name `printf` isn't bound to an address at compile time. The dynamic linker binds it at **load/run time** to libc's implementation (via the PLT/GOT). This *late binding* lets many programs share one libc and lets libc be updated without recompiling every program - a direct, practical use of deferred name binding.

**Virtual method dispatch (backend framework):** In a Java service, `PaymentProcessor p = getProcessor(); p.charge();` - the name `charge` is bound *dynamically*. Which `charge()` runs (Stripe vs PayPal implementation) is decided at runtime via the vtable based on the actual object, enabling pluggable payment backends without changing call sites.

## 5. Diagrams / Mental Models

**Binding-time spectrum:**
```
Language design → Compile time → Link time → Load time → Run time
   (keyword 'if')  (local offset) (global addr)(shared lib) (virtual call)
   ── earlier: faster, safer ──►  ◄── later: more flexible ──
```

**Name → entity arrow (rebinding vs mutation):**
```
Rebind:   x ──► [10]      then   x ──► ["hi"]   (arrow moved)
Mutate:   x ──► [1,2,3]   then   x ──► [1,2,3,4] (same object changed)
```

**Static vs dynamic binding:**
```
Static:   call → known function at compile time → direct jump
Dynamic:  call → look up actual type at runtime → vtable → correct override
```

## 6. Common Interview Questions

**Q1. What is name binding?**
- **Answer:** Associating an identifier with the entity (variable/function/value) it refers to.
- **Mistake:** Reducing it to "just declaring a variable."

**Q2. Static vs dynamic binding?**
- **Answer:** Static = fixed at compile time (direct call); dynamic = resolved at runtime (via type/vtable).
- **Mistake:** Confusing with static/dynamic *typing*.

**Q3. What is binding time? Give examples across the spectrum.**
- **Answer:** When the name-entity link is fixed: compile (local offset), link (global address), load (shared lib), run (virtual call).
- **Mistake:** Only mentioning compile vs runtime.

**Q4. Difference between scope and lifetime?**
- **Answer:** Scope = *where* a name is visible; lifetime = *how long* the entity exists.
- **Mistake:** Treating them as the same.

**Q5. Which OOP feature requires dynamic binding?**
- **Answer:** Method overriding / runtime polymorphism (virtual functions).
- **Mistake:** Saying overloading (that's static).

**Q6. Rebinding vs mutation?**
- **Answer:** Rebinding repoints the name to a new entity; mutation changes the existing entity's contents.
- **Mistake:** Conflating them (key for Python argument-passing questions).

**Q7. How does a `static` local variable illustrate scope vs lifetime?**
- **Answer:** Scope is local (visible only in the function) but lifetime is the whole program (retains value across calls).
- **Mistake:** Saying static local is globally visible.

**Q8. How do linkers perform name binding?**
- **Answer:** Resolve symbol names (functions/globals) across object files to addresses.
- **Mistake:** Ignoring link-time binding.

**Q9. What is late/lazy binding and where is it used?**
- **Answer:** Binding deferred to runtime/first use; used in dynamic dispatch, dynamic linking, reflection.
- **Mistake:** Thinking all binding is compile-time.

**Q10. Does binding relate to static/dynamic typing?**
- **Answer:** Related but distinct - typing is about type checking time; binding is about resolving names to entities. Dynamic languages often use dynamic binding, but they're separate concepts.
- **Mistake:** Equating the two.

## 7. Deep-Dive Questions

**D1. Explain how earlier binding time enables optimization.**
When a name is bound early (compile time), the compiler knows the exact target and can inline, allocate registers, and skip runtime lookups. Late binding forces indirect calls/lookups and inhibits inlining, trading speed for flexibility (e.g., virtual calls vs direct calls).

**D2. How does dynamic binding work under the hood (vtables)?**
Each polymorphic class has a virtual table of function pointers. Each object holds a hidden pointer to its class's vtable. A virtual call indexes the vtable at a fixed slot and jumps to the stored pointer, so the *actual* object type determines the target at runtime - constant-time dynamic binding.

**D3. In Python, why does `def f(lst): lst = lst + [1]` not affect the caller, but `lst.append(1)` does?**
Parameters are bound to the *same objects* as arguments (call by object reference). `lst = lst + [1]` **rebinds** the local name to a new list (caller unaffected). `lst.append(1)` **mutates** the shared object (caller sees the change). This is the rebinding-vs-mutation distinction in action.

**D4. What is the difference between deep binding and shallow binding for passed functions?**
When a function is passed as an argument, deep binding uses the environment where the function was *defined* (lexical/closure-like); shallow binding uses the environment where it is *called*. Deep binding matches static scope; shallow binding matches dynamic scope semantics.

**D5. How does dynamic linking bind library symbols lazily (PLT/GOT)?**
On first call to a shared-library function, the Procedure Linkage Table jumps to the dynamic linker, which resolves the symbol's real address and patches the Global Offset Table. Subsequent calls jump directly - *lazy binding* that avoids resolving unused symbols at startup.

## 8. Comparison Tables

**Static vs Dynamic Binding**

| Aspect | Static (Early) | Dynamic (Late) |
|--------|----------------|----------------|
| Resolved at | Compile time | Runtime |
| Based on | Static type/name | Actual object/state |
| Speed | Faster (direct) | Slower (indirect) |
| Flexibility | Lower | Higher (polymorphism) |
| Example | Overloaded call | Overridden virtual call |

**Scope vs Lifetime**

| Aspect | Scope | Lifetime |
|--------|-------|----------|
| Question | Where is the name visible? | How long does the entity exist? |
| Kind | Lexical region | Time interval |
| Example | Local to a function | Whole program (static var) |

**Rebinding vs Mutation**

| Aspect | Rebinding | Mutation |
|--------|-----------|----------|
| Changes | What the name points to | The entity's contents |
| Affects other refs? | No | Yes (shared object) |
| Example | `x = new` | `x.append(...)` |

**Binding Times**

| Time | What's bound | Example |
|------|--------------|---------|
| Language design | Keywords, operators | `if`, `+` meaning |
| Compile | Local var type/offset | `int x` layout |
| Link | Global symbol address | function addresses |
| Load | Shared library symbols | dynamic linking |
| Run | Virtual call target, dynamic vars | vtable dispatch |

## 9. Common Mistakes

- Confusing name binding with static/dynamic *typing*.
- Treating scope and lifetime as the same thing.
- Confusing rebinding (repoint) with mutation (change contents).
- Thinking all binding happens at compile time (linking/runtime binding exist).
- Saying overloading uses dynamic binding (it's static).

## 10. Edge Cases / Special Cases

- **`static` local variables:** local scope but program lifetime.
- **Closures:** bind captured variables to an environment that outlives the enclosing call.
- **Forward references:** a name bound to an entity declared later.
- **Weak/late symbols in linking:** unresolved until load/run time.
- **Reflection / eval:** binding names to entities determined at runtime from strings.
- **Rebinding in loops/closures:** the classic "all closures see the last loop value" bug.

## 11. How to Explain in Interview

> "Name binding is the association between a name I write and the actual entity it refers to - a variable, a function, a memory location. Semantic analysis resolves it using scope rules and the symbol table. A key dimension is *binding time*: some bindings are fixed at compile time, like a local variable's offset; others at link time, like a global's address; and others at runtime, like which overridden method a virtual call hits. Static binding is faster and enables optimization; dynamic binding enables runtime polymorphism. I also distinguish scope - where a name is visible - from lifetime - how long the entity exists - and rebinding, which repoints a name, from mutation, which changes the entity itself."

## 12. Quick Revision Notes

- **Name binding:** name ↔ entity association.
- **Binding time spectrum:** design → compile → link → load → run.
- **Static/early binding** (compile, direct) vs **dynamic/late binding** (runtime, vtable).
- **Scope** = visibility; **lifetime** = existence (distinct!).
- **Rebinding** (repoint) vs **mutation** (change contents).
- **Trap:** overriding = dynamic binding; overloading = static; don't confuse with typing.

## 13. Practice Tasks

1. In Python, show rebinding vs mutation inside a function and its effect on the caller.
2. In C, use a `static` local variable to count calls; explain scope vs lifetime.
3. In Java/C++, demonstrate a virtual (dynamic-bound) call vs a non-virtual/overloaded (static-bound) call.
4. Reproduce the closure-in-loop late-binding bug and fix it.
5. Run `ldd ./a.out` and `nm -D` to see dynamically bound library symbols.

## 14. Final Cheat Sheet

- **Core definition:** Associating a name with the entity it denotes; resolved during semantic analysis.
- **Why it matters:** Governs dispatch, optimization, polymorphism, storage, and linking.
- **Most asked:** static vs dynamic binding, binding time, scope vs lifetime, rebinding vs mutation.
- **Comparisons:** static/dynamic binding, scope/lifetime, rebinding/mutation, binding times.
- **One-liner:** "Connecting a name to the entity it refers to, fixed anywhere from compile time to runtime."

---
---

# 12. Dependent Types Basics

## 1. Overview

**Definition:** Dependent types are types that **depend on values**. Instead of just `Array` or `int`, a dependent type can be `Vector 5` (a vector of *exactly 5* elements) or `Array n` where `n` is a runtime/compile-time value. The type *carries* a value, letting the type system express far richer properties.

**Why it matters:**
- Encodes correctness properties *in the type* (e.g., "this list is non-empty," "these two matrices have compatible dimensions").
- Enables **compile-time proofs**: the compiler can guarantee no out-of-bounds access, no division by a proven-nonzero denominator.
- Blurs the line between programming and mathematical proof (Curry-Howard correspondence).

**Where it is used in real systems:**
- Proof assistants / dependently-typed languages: Coq, Agda, Idris, Lean, F*.
- Formally verified software: the CompCert C compiler, seL4 microkernel, cryptographic libraries (via F*).
- Advanced type-level programming in Haskell/Scala (approximations).

**Why interviewers ask:** It's an advanced topic that signals deep type-theory understanding. Even "basics" show you grasp the power/cost frontier of type systems - great for senior/research-leaning roles.

## 2. Core Idea

**Intuition:** In ordinary type systems, types and values live in separate worlds - `5` is a value, `int` is a type. Dependent types let types *mention* values, so `Vec int 5` is the type of integer vectors of length 5. Now the length is part of the type, and the compiler can check operations respect it (e.g., you can't index position 7 into a length-5 vector).

**Real-world analogy:** A parking permit that encodes the *specific* car it's valid for (plate number), not just "a car." A normal type is "permit for a car"; a dependent type is "permit for car ABC-123." The checker (attendant) can verify the exact match, catching mismatches a generic permit couldn't.

**Small example (Idris-style):**
```idris
-- Vector whose LENGTH is part of its type
append : Vect n a -> Vect m a -> Vect (n + m) a
-- The result length is PROVABLY n + m, checked at compile time

head : Vect (S n) a -> a      -- only accepts NON-EMPTY vectors (length = successor)
head []   -- COMPILE ERROR: [] has type Vect 0, but head needs Vect (S n)
```
You literally *cannot* call `head` on an empty vector - the type system forbids it at compile time.

**Step-by-step:**
1. Types are allowed to take values as parameters (`Vect n a`).
2. Functions' types state relationships between input and output values (`append` sums lengths).
3. The type checker evaluates these value-level relationships during checking (requires evaluating expressions in types).
4. A program type-checks only if all value-level type constraints hold - effectively a proof.

## 3. Important Subtopics

### a) Types Depending on Values
- **What:** The defining feature - a type parameterized by a value (`Vect 5 Int`, `Matrix m n`).
- **Why:** Lets the type express exact sizes/properties.
- **Example:** `Fin n` = a natural number *strictly less than n* (a safe array index).
- **Interview angle:** Give an example type that depends on a value (length-indexed vector).

### b) Curry-Howard Correspondence (Propositions as Types)
- **What:** Types correspond to logical propositions, and programs (values) to proofs. A dependent type can be a *theorem*; a program of that type is its *proof*.
- **Why:** This is why dependent types enable formal verification.
- **Example:** A value of type `(n : Nat) -> Even n -> ...` is a proof about even numbers.
- **Interview angle:** "What is Curry-Howard?" Programs = proofs, types = propositions.

### c) Pi Types and Sigma Types
- **What:** **Pi (Π) type** = dependent function type: the return *type* depends on the argument *value* (`(n : Nat) -> Vect n Int`). **Sigma (Σ) type** = dependent pair: the second component's type depends on the first value.
- **Why:** They generalize ordinary function and product types to the dependent setting.
- **Example:** `Π(n:Nat). Vect n a` returns a vector whose type depends on `n`.
- **Interview angle:** Difference between a normal function type and a Pi type.

### d) Compile-Time Guarantees / Verification
- **What:** Because types encode properties, a well-typed program is *proven* to satisfy them (no out-of-bounds, dimensions match).
- **Why:** Eliminates whole bug classes at compile time - the goal of formal methods.
- **Example:** Type-safe `printf` (format string determines argument types), verified matrix multiply.
- **Interview angle:** What runtime errors can dependent types eliminate at compile time?

### e) Costs: Decidability and Complexity
- **What:** Type checking with dependent types can require evaluating arbitrary expressions, making full type inference **undecidable**; needs explicit proofs and is harder to use.
- **Why:** Explains why mainstream languages don't fully adopt them.
- **Example:** You often must *manually write proofs* to convince the checker.
- **Interview angle:** Why aren't dependent types mainstream? (Undecidable inference, proof burden, complexity.)

## 4. Real-World Example

**Verified compiler (CompCert):** CompCert is a C compiler *formally verified* in Coq (which uses dependent types). The dependent type system lets its authors prove a theorem: "the generated assembly behaves exactly like the source C program." This proof is machine-checked, so CompCert has essentially no miscompilation bugs - used in safety-critical avionics and nuclear systems where a compiler bug could be catastrophic.

**Cryptography (Project Everest / F*):** HACL* is a library of cryptographic primitives written in F* (dependently typed). The types encode memory-safety and functional-correctness properties, proven at compile time. The verified code is compiled to C and now ships in Firefox, the Linux kernel, and other systems - real production code whose correctness is guaranteed by dependent types.

## 5. Diagrams / Mental Models

**Type systems on a power ladder:**
```
Simple types      : int, bool                         (values only)
Parametric (generics): List<T>                        (types depend on TYPES)
Dependent types   : Vect n a                          (types depend on VALUES)
   ▲ more properties expressible, ▼ inference harder
```

**Length carried in the type:**
```
Ordinary:   [1,2,3] : List Int          (length lost)
Dependent:  [1,2,3] : Vect 3 Int        (length in the TYPE)
append: Vect 3 Int → Vect 2 Int → Vect 5 Int   (3+2 proven)
```

**Curry-Howard table:**

| Logic | Types |
|-------|-------|
| Proposition | Type |
| Proof | Program/value of that type |
| Implication A→B | Function type A→B |
| ∀x. P(x) | Pi type (n:T)→P n |
| ∃x. P(x) | Sigma type (dependent pair) |
| True / False | Unit type / Empty type |

## 6. Common Interview Questions

**Q1. What are dependent types?**
- **Answer:** Types that depend on values (e.g., `Vect n a` - a vector of length `n`).
- **Mistake:** Confusing with generics (types depending on *types*).

**Q2. Give an example of a dependent type.**
- **Answer:** A length-indexed vector `Vect 5 Int`, or `Fin n` (index < n).
- **Mistake:** Giving `List<T>` (that's parametric, not dependent).

**Q3. Dependent types vs generics/parametric polymorphism?**
- **Answer:** Generics parameterize types by *types* (`List<T>`); dependent types parameterize by *values* (`Vect n`).
- **Mistake:** Treating them as the same.

**Q4. What is the Curry-Howard correspondence?**
- **Answer:** Types = propositions, programs = proofs; a program of a type proves that proposition.
- **Mistake:** Not knowing this fundamental link.

**Q5. What bug classes can dependent types eliminate at compile time?**
- **Answer:** Array out-of-bounds, dimension mismatches, empty-list head, division by proven-nonzero, etc.
- **Mistake:** Vague "all bugs" (they eliminate *specified* properties).

**Q6. Name languages with dependent types.**
- **Answer:** Coq, Agda, Idris, Lean, F*.
- **Mistake:** Naming Haskell/Java as fully dependently typed.

**Q7. Why aren't dependent types mainstream?**
- **Answer:** Type inference is undecidable; heavy proof burden; steep learning curve; slower development.
- **Mistake:** Saying "no benefit."

**Q8. What is a Pi type?**
- **Answer:** A dependent function type whose return type depends on the argument value.
- **Mistake:** Confusing with a plain function type.

**Q9. What is a Sigma type?**
- **Answer:** A dependent pair where the second element's type depends on the first element's value.
- **Mistake:** Calling it a plain tuple.

**Q10. How do dependent types enable formal verification?**
- **Answer:** Encoding correctness properties as types means a well-typed program is a machine-checked proof of those properties.
- **Mistake:** Missing the "types-as-proofs" idea.

## 7. Deep-Dive Questions

**D1. Why is type inference undecidable with full dependent types?**
Because checking type equality may require evaluating arbitrary expressions embedded in types, and program evaluation is Turing-complete (halting problem). So the checker can't always decide whether two dependent types are equal, forcing programmers to supply explicit proofs/annotations.

**D2. How does a dependently-typed `head` prevent empty-list errors at compile time?**
Its type is `Vect (S n) a -> a` - the input's length must be a *successor* (≥ 1). `[]` has type `Vect 0 a`, which doesn't match `Vect (S n) a`, so the compiler rejects `head []`. The non-emptiness precondition is encoded in the type, not checked at runtime.

**D3. Explain "propositions as types" with a concrete proof.**
To prove "for all n, n + 0 = n," you write a function `plusZero : (n : Nat) -> (n + 0 = n)`. The equality `=` is itself a type; constructing a value of that type (often by induction/pattern matching on `n`) *is* the proof. The type checker validates the proof by type-checking the function.

**D4. How do languages like Haskell approximate dependent types without full support?**
Via GADTs, type families, and singletons - encoding value-level info at the type level (e.g., type-level naturals with `DataKinds`). It's more verbose and limited than true dependent types but captures many size/shape guarantees; Idris/Agda make this first-class.

**D5. What is the trade-off between expressiveness and usability in dependent type systems?**
More expressive types capture more properties but demand more proofs and make inference undecidable, slowing development and steepening the learning curve. Practical systems (Idris, F*) add automation (tactics, SMT solvers) to reduce the proof burden, seeking a sweet spot between guarantees and ergonomics.

## 8. Comparison Tables

**Dependent Types vs Generics vs Simple Types**

| Aspect | Simple Types | Generics (Parametric) | Dependent Types |
|--------|--------------|-----------------------|-----------------|
| Parameterized by | Nothing | Types | Values |
| Example | `int` | `List<T>` | `Vect n Int` |
| Expresses | Basic kinds | Type-generic reuse | Value-level properties |
| Inference | Easy | Decidable | Undecidable (needs proofs) |

**Pi Type vs Sigma Type**

| Aspect | Pi (Π) type | Sigma (Σ) type |
|--------|-------------|----------------|
| Generalizes | Function type | Product/pair type |
| Dependency | Return type on argument value | 2nd element's type on 1st value |
| Logic analog | ∀ (for all) | ∃ (there exists) |
| Example | `(n:Nat) -> Vect n a` | `(n:Nat ** Vect n a)` |

**Dependent Types vs Traditional Testing**

| Aspect | Dependent Types | Unit Tests |
|--------|-----------------|-----------|
| Coverage | All inputs (proof) | Sampled inputs |
| When | Compile time | Run time |
| Guarantee | Total (for the property) | Partial |
| Cost | Proof effort | Test writing |

## 9. Common Mistakes

- Confusing dependent types (depend on *values*) with generics (depend on *types*).
- Thinking they eliminate *all* bugs (only the properties you encode).
- Assuming type inference stays automatic (it becomes undecidable; proofs needed).
- Believing they're only academic (used in CompCert, seL4, HACL*).
- Ignoring the proof/usability cost that keeps them out of mainstream languages.

## 10. Edge Cases / Special Cases

- **Type-checking may not terminate** without restrictions (needs totality checking).
- **Proof obligations:** you sometimes must hand-write proofs the compiler can't infer.
- **Erasure:** value indices in types are often erased at runtime for performance.
- **Equality is subtle:** propositional vs definitional equality distinctions.
- **Interaction with side effects / non-termination:** pure total functions are usually required for soundness.
- **Approximations in mainstream languages** (Haskell GADTs) hit ergonomic walls quickly.

## 11. How to Explain in Interview

> "Dependent types are types that depend on values. Where generics let a type depend on another type - like `List<T>` - dependent types let a type depend on a value, like `Vect n Int`, a vector whose length `n` is part of its type. This lets the type system express and prove properties at compile time: you literally can't take the head of an empty vector or multiply dimension-mismatched matrices, because the types forbid it. It rests on the Curry-Howard correspondence - types are propositions and programs are proofs - which is why languages like Coq, Agda, Idris, and F* use them for formal verification, as in the CompCert verified C compiler. The catch is that full type inference becomes undecidable and you often must write explicit proofs, which is why they aren't mainstream yet."

## 12. Quick Revision Notes

- **Dependent type:** type that depends on a *value* (`Vect n a`).
- **vs Generics:** generics depend on types; dependent types on values.
- **Curry-Howard:** types = propositions, programs = proofs.
- **Pi type** = dependent function; **Sigma type** = dependent pair.
- **Eliminates:** out-of-bounds, dimension mismatch, empty-head - at compile time.
- **Languages:** Coq, Agda, Idris, Lean, F*. Used in CompCert, seL4, HACL*.
- **Trap:** inference undecidable; proof burden; not just academic.

## 13. Practice Tasks

1. Write (Idris/Agda pseudocode) the type of `append : Vect n a -> Vect m a -> Vect (n+m) a` and explain the length arithmetic.
2. Give a `head` type that rejects empty vectors and explain why `head []` fails to compile.
3. Map three logic statements (A→B, ∀, ∃) to their type-theory counterparts (Curry-Howard).
4. Contrast `List<Int>` (generic) with `Vect 3 Int` (dependent) - what does each guarantee?
5. Research and summarize one real verified system (CompCert, seL4, or HACL*) and what property its types guarantee.

## 14. Final Cheat Sheet

- **Core definition:** Types that depend on values (e.g., length-indexed vectors).
- **Why it matters:** Encode correctness in types; compile-time proofs eliminate bug classes.
- **Most asked:** dependent vs generic, Curry-Howard, why not mainstream.
- **Comparisons:** dependent/generic/simple types; Pi/Sigma types.
- **One-liner:** "Types parameterized by values, turning the type checker into a proof checker."

---
---

# Master Summary: Semantic Analysis at a Glance

## How the 12 topics fit together

```
                 SEMANTIC ANALYSIS
                        │
   ┌────────────────────┼────────────────────────┐
   │                    │                         │
 NAME resolution    TYPE reasoning         SPECIFICATION
   │                    │                    framework
 • Scope checking    • Type checking       • Syntax-directed defs
 • Symbol tables     • Static vs dynamic   • Attribute grammars
 • Name binding      • Type conversion
 • Overloading       • Type coercion
   resolution        • Type inference
                     • Dependent types
```

- **Symbol tables** are the shared database that **scope checking**, **type checking**, **name binding**, and **overloading resolution** all consult.
- **Type conversion** (explicit) and **type coercion** (implicit) are two sides of changing types.
- **Static vs dynamic typing** frames *when* type checking happens; **type inference** removes annotations; **dependent types** push types to depend on values.
- **Syntax-directed definitions** and **attribute grammars** are the formal machinery used to *specify and implement* all of the above.

## One-line answers for rapid recall

| Topic | One-liner |
|-------|-----------|
| Type checking | Verify every operation gets correctly-typed operands. |
| Scope checking | Ensure names are declared/visible; resolve them innermost-first. |
| Symbol tables | Compile-time dictionary of identifier attributes. |
| Static vs dynamic typing | Types checked at compile time vs runtime. |
| Type conversion | Change a value's type (explicit cast). |
| Type coercion | Implicit, automatic type conversion by the language. |
| Syntax-directed definitions | Grammar productions augmented with attribute-computing rules. |
| Attribute grammars | Knuth's formalism: attributes + equations over a grammar. |
| Type inference | Auto-deduce static types via unification. |
| Overloading resolution | Compile-time pick of best-matching same-named function. |
| Name binding | Associate a name with the entity it refers to. |
| Dependent types | Types that depend on values (compile-time proofs). |

## Top cross-cutting interview traps

1. **Static/dynamic typing ≠ strong/weak typing** (orthogonal axes).
2. **Type inference ≠ dynamic typing** (still compile-time static).
3. **Coercion (implicit) ≠ casting (explicit)**.
4. **Overloading (static, compile time) ≠ overriding (dynamic, runtime)**.
5. **Scope (visibility) ≠ lifetime (existence)**.
6. **Rebinding (repoint name) ≠ mutation (change entity)**.
7. **Synthesized (up) vs inherited (down)** attributes - don't swap.
8. **Dependent types (depend on values) ≠ generics (depend on types)**.
9. **Static binding ≠ static typing** - binding is about names→entities, typing is about type-check timing.
10. **float→int truncates** (toward zero), it does not round.
