# Intermediate Code Generation (Compiler Design) - Complete Interview Guide

> **Phase of the compiler:** Intermediate code generation comes after syntax analysis and semantic analysis. The compiler converts the checked program into an internal form called an **intermediate representation (IR)**. This IR is easier to optimize, analyze, and translate into machine code than raw source code.
>
> This guide covers the most important intermediate-code-generation topics for SDE placements, online assessments, university viva questions, and technical interviews.

---

## Table of Contents

1. [Intermediate Representation](#1-intermediate-representation)
2. [Abstract Syntax Tree](#2-abstract-syntax-tree)
3. [Three-Address Code](#3-three-address-code)
4. [Quadruples](#4-quadruples)
5. [Triples](#5-triples)
6. [Control-Flow Graph](#6-control-flow-graph)
7. [Basic Blocks](#7-basic-blocks)
8. [Static Single Assignment Form Basics](#8-static-single-assignment-form-basics)
9. [DAG Representation of Expressions](#9-dag-representation-of-expressions)
10. [Phi Functions](#10-phi-functions)
11. [Lowering High-Level Constructs](#11-lowering-high-level-constructs)

---

## Big Picture: Where Intermediate Code Generation Fits

```text
Source Program
   |
   v
Lexical Analysis        -> tokens
   |
   v
Syntax Analysis         -> parse tree / AST
   |
   v
Semantic Analysis       -> typed / annotated AST
   |
   v
Intermediate Code Gen   -> IR, TAC, CFG, SSA
   |
   v
Optimization            -> improved IR
   |
   v
Code Generation         -> assembly / machine code / bytecode
```

**One-line interview answer:** Intermediate code generation converts a semantically valid program into a machine-independent internal form so the compiler can optimize it and later generate target-specific code.

---

# 1. Intermediate Representation

## 1. Overview

**Definition:** An **intermediate representation (IR)** is an internal form of a program used by a compiler between the source language and the final target code.

Instead of directly translating C, Java, Python, or Rust source code into machine code, most compilers translate source code into IR first. The IR is then analyzed, optimized, and converted into assembly, bytecode, or machine code.

**Why it matters:**
- It separates the compiler front end from the back end.
- It makes optimization easier.
- It allows one compiler infrastructure to support many languages and many processors.
- It gives the compiler a simpler representation than source code but a more flexible representation than machine code.

**Where it is used in real systems:**
- LLVM uses LLVM IR.
- GCC uses GIMPLE and RTL.
- Java compilers emit JVM bytecode.
- .NET compilers emit CIL.
- JavaScript engines use multiple internal IRs for JIT optimization.
- Databases use query plans, which behave like IR for SQL.

**Why interviewers ask about it:** IR is the center of modern compiler design. If you understand IR, you can explain optimization, code generation, SSA, CFGs, register allocation, and JIT compilation more clearly.

## 2. Core Idea

The main idea is to convert a complex source program into a simpler internal program.

**Intuition:** Source code is written for humans. Machine code is written for processors. IR is written for the compiler.

**Real-world analogy:** Think of IR like an architectural blueprint. A customer may describe a house in natural language, and workers eventually build it using concrete and bricks. The blueprint sits in the middle: precise enough for engineers, but not tied to one worker's tool.

**Small example:**

```c
x = a + b * c;
```

Possible three-address IR:

```text
t1 = b * c
t2 = a + t1
x  = t2
```

The IR breaks a complex expression into small operations that are easier to optimize and translate.

**Step-by-step:**
1. Parser builds a syntax structure for `x = a + b * c`.
2. Semantic analysis verifies declarations and types.
3. Intermediate code generation emits simple operations.
4. Optimizer may simplify or reorder operations.
5. Back end maps operations to target instructions.

## 3. Important Subtopics

| Subtopic | Meaning | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| High-level IR | Close to source language | Keeps loops, objects, and function calls easy to analyze | AST, typed AST | "Why not generate machine code directly?" |
| Low-level IR | Close to machine operations | Easier for instruction selection and register allocation | LLVM IR, RTL | "How is IR different from assembly?" |
| Linear IR | Sequence of instructions | Simple to emit and scan | TAC instructions | "Convert expression to TAC." |
| Graph IR | Nodes and edges represent data/control dependencies | Good for optimization | CFG, DAG, SSA graph | "Why use a CFG?" |
| Typed IR | IR values carry types | Prevents invalid transformations | `add i32 %a, %b` | "Why keep type info after semantic analysis?" |
| Machine-independent IR | Avoids target-specific assumptions | Enables portability | Same IR to x86 and ARM | "How do compilers support many architectures?" |

**High-level IR:** Keeps source-level concepts like loops, arrays, exceptions, or method calls. It is useful for early analysis.

**Low-level IR:** Uses simpler instructions closer to machine operations. It is useful for late optimization and code generation.

**Linear IR:** Stores instructions in a list. It is easy to generate and execute in order.

**Graph IR:** Stores relationships explicitly. It is powerful for global optimization.

## 4. Real-World Example

**Browser JavaScript engine:** A browser parses JavaScript into an AST, lowers it into bytecode or IR, profiles hot functions, then JIT-compiles selected code into optimized machine code. The IR lets the engine reason about operations like property access, numeric arithmetic, branches, and function calls before producing CPU instructions.

**Backend server:** A Java backend compiles `.java` files into JVM bytecode. The JVM later interprets or JIT-compiles that bytecode. JVM bytecode acts as an intermediate representation between Java source and machine code.

## 5. Diagrams / Mental Models

```text
Many languages                  One optimizer                 Many targets

 C       Java       Rust             IR                 x86
  \        |         /                |                  ARM
   \       |        /                 v                  RISC-V
    Front ends  --------->  Optimizer passes  -------->  Back ends
```

**Mental model:** IR is the compiler's "common currency." Different source languages are converted into the same kind of internal money, then spent by different machine-code generators.

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is an intermediate representation? | An internal program form used between source code and target code. | Machine independent, optimizable, compiler internal | Calling it only "assembly code" |
| Why do compilers use IR? | To decouple front end and back end and make optimization easier. | Retargetability, reuse, simpler analysis | Saying "only for speed" |
| Is bytecode an IR? | Yes, bytecode can be considered an intermediate representation, especially in VM-based languages. | JVM bytecode, CIL, portability | Thinking IR must be invisible to users |
| How is IR different from source code? | IR is compiler-oriented, simpler, explicit, and often normalized. | Temporaries, simple operations, explicit control flow | Saying source and IR are same syntax |
| How is IR different from machine code? | IR is usually machine independent; machine code is target-specific binary instructions. | Portability, abstraction level | Saying IR always runs directly on CPU |
| What are common IR forms? | AST, TAC, bytecode, CFG, SSA, DAGs. | Multiple levels of IR | Naming only TAC |
| Why not generate machine code directly from AST? | It couples source language details to target hardware and makes optimization harder. | Separation of concerns, reuse | Ignoring optimization |
| What is a good IR property? | It should be easy to generate, analyze, optimize, and translate. | Simplicity plus expressiveness | Saying "as detailed as source" |
| Can one compiler have multiple IRs? | Yes. Modern compilers often lower through several IR levels. | High-level to low-level pipeline | Assuming exactly one IR |
| Where does IR generation happen? | After parsing and semantic analysis, before optimization and code generation. | Compiler middle end | Placing it before syntax analysis |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why do modern compilers use multiple IR levels? | Different optimizations need different abstraction levels. High-level IR is good for language-level optimizations, while low-level IR is good for register allocation and instruction selection. |
| What does "lowering" mean in an IR pipeline? | Lowering converts a high-level representation into a simpler, lower-level representation. For example, a `for` loop may become labels and conditional jumps. |
| How does IR help retargetability? | If every source language front end emits the same IR, every target back end only needs to consume that IR. This avoids writing one complete compiler for every language-target pair. |
| What is the trade-off in IR design? | A high-level IR is easier to relate to source code, while a low-level IR is easier to map to hardware. Good compilers often use both. |
| Why is type information useful in IR? | It prevents invalid transformations and helps optimizations. For example, integer addition and floating-point addition have different rules. |

## 8. Comparison Tables

### Source Code vs IR vs Machine Code

| Feature | Source Code | Intermediate Representation | Machine Code |
|---|---|---|---|
| Main audience | Human programmers | Compiler | CPU |
| Portability | High | Usually high | Low |
| Optimization-friendly | Medium | High | Low to medium |
| Readability | High | Medium | Very low |
| Hardware-specific | No | Usually no | Yes |
| Example | `x = a + b` | `t1 = a + b` | Binary instructions |

### High-Level IR vs Low-Level IR

| Feature | High-Level IR | Low-Level IR |
|---|---|---|
| Close to | Source language | Machine operations |
| Keeps loops/objects? | Often yes | Usually lowered |
| Best for | Early analysis | Late code generation |
| Example | AST, typed AST | LLVM-like operations, RTL |
| Interview trap | Thinking high-level IR is useless | Thinking low-level IR is machine code |

## 9. Common Mistakes

- Thinking IR is always three-address code.
- Saying IR is the final output of a compiler.
- Confusing IR with parse tree.
- Forgetting that compilers can have multiple IRs.
- Assuming IR must be human-readable.
- Ignoring the role of IR in optimization.
- Saying IR is always machine-independent; some late IRs are target-aware.

## 10. Edge Cases / Special Cases

- Some simple compilers directly generate code from the AST.
- JIT compilers may generate IR at runtime.
- Bytecode can be stored on disk and executed by a VM.
- Debug information must connect optimized IR back to source lines.
- Optimizations can make IR very different from the original source.

## 11. How to Explain in Interview

"An intermediate representation is the compiler's internal version of the program. After parsing and semantic checks, the compiler converts source code into IR because IR is easier to analyze, optimize, and translate into different target machines. Examples include AST, three-address code, bytecode, CFGs, and SSA."

## 12. Quick Revision Notes

- IR sits between source code and target code.
- Main benefits: optimization, portability, modular compiler design.
- Examples: AST, TAC, bytecode, LLVM IR, SSA.
- High-level IR is close to source; low-level IR is close to machine code.
- Interview trap: do not call every IR "assembly."

## 13. Practice Tasks

1. Convert `x = (a + b) * (c - d)` into a simple IR.
2. Explain why a compiler for 3 languages and 4 CPUs benefits from a common IR.
3. Compare JVM bytecode and LLVM IR.
4. Draw a compiler pipeline showing where IR appears.
5. Identify whether AST, TAC, CFG, and SSA are linear or graph-like representations.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Internal program representation between source and target code |
| Why it matters | Enables optimization, portability, and clean compiler architecture |
| Most asked questions | What is IR? Why use IR? IR vs machine code? |
| Common comparisons | Source vs IR vs machine code, high-level vs low-level IR |
| One-line answer | IR is the compiler-friendly form of a program used for analysis, optimization, and code generation. |

---

# 2. Abstract Syntax Tree

## 1. Overview

**Definition:** An **Abstract Syntax Tree (AST)** is a tree representation of the meaningful syntactic structure of a program.

It is "abstract" because it removes unnecessary grammar details such as punctuation nodes, parentheses used only for grouping, and intermediate grammar productions.

**Why it matters:**
- It is the main output of parsing in many compilers.
- It captures program structure in a form easier to analyze than raw tokens.
- Semantic analysis, type checking, code generation, formatting tools, linters, and refactoring tools commonly operate on ASTs.

**Where it is used in real systems:**
- Compilers parse source files into ASTs.
- IDEs use ASTs for autocomplete, rename refactoring, and error highlighting.
- Linters like ESLint inspect JavaScript ASTs.
- Transpilers like Babel transform ASTs.
- Static analyzers inspect ASTs to find bugs or security issues.

**Why interviewers ask about it:** AST is one of the first practical data structures in compiler design. Interviewers use it to check whether you understand parsing output and how source code becomes a structured object.

## 2. Core Idea

The AST keeps only the structure needed to understand the program.

**Intuition:** Tokens are a flat list. An AST adds hierarchy.

**Real-world analogy:** A sentence diagram in grammar class shows how words relate. An AST does the same for code.

**Small example:**

```c
x = a + b * c;
```

AST:

```text
        Assign
       /      \
      x        +
              / \
             a   *
                / \
               b   c
```

**Step-by-step:**
1. Lexer produces tokens: `id(x)`, `=`, `id(a)`, `+`, `id(b)`, `*`, `id(c)`, `;`.
2. Parser applies grammar rules.
3. AST removes unnecessary punctuation.
4. Operator precedence is reflected in the tree: `b * c` is deeper than `a + ...`.
5. Later phases traverse the tree.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Parse tree vs AST | Parse tree includes all grammar symbols; AST keeps essential structure | AST is smaller and more useful | Parentheses may disappear | "Difference between parse tree and AST?" |
| Expression nodes | Nodes for operators and operands | Represents computation | `+`, `*`, variable nodes | "Draw AST for expression." |
| Statement nodes | Nodes for assignments, loops, conditionals | Represents program actions | `If`, `While`, `Return` | "How is control flow represented?" |
| Declaration nodes | Nodes for variables, functions, classes | Used in symbol-table construction | `FunctionDecl`, `VarDecl` | "Where are declarations stored?" |
| Annotated AST | AST plus semantic info | Useful for type checking and IR generation | node type = `int` | "What happens after parsing?" |
| AST traversal | Walking the tree recursively or iteratively | Used by visitors, analyzers, compilers | pre-order traversal | "How would you generate code from AST?" |

**Parse tree vs AST example:**

Expression:

```text
(a + b)
```

Parse tree may include nonterminals like `Expr`, `Term`, `Factor`, and punctuation. AST usually keeps only:

```text
   +
  / \
 a   b
```

## 4. Real-World Example

**IDE rename refactoring:** When you rename a variable in an IDE, the tool should not blindly replace every matching string. It parses the code into an AST, resolves symbols, and renames only the correct variable references.

Example:

```c
int count = 0;
printf("count");
```

The string `"count"` should not be renamed as a variable. AST plus semantic info prevents that mistake.

## 5. Diagrams / Mental Models

```text
Raw source
   |
   v
Tokens: flat sequence
   |
   v
Parse tree: full grammar structure
   |
   v
AST: essential program structure
```

### AST Node Table

| Source Construct | Possible AST Node |
|---|---|
| `x = y + 1` | `Assign(name=x, value=BinaryOp(+))` |
| `if (x > 0)` | `If(condition=Compare(>))` |
| `while (i < n)` | `While(condition=Compare(<))` |
| `return x` | `Return(value=x)` |
| `int f(int a)` | `FunctionDecl(name=f, params=[a])` |

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is an AST? | A tree showing the meaningful structure of source code. | Abstract, syntactic hierarchy | Calling it token list |
| Why is it called abstract? | It omits unnecessary grammar and punctuation details. | Removes concrete syntax noise | Saying it is vague or incomplete |
| AST vs parse tree? | Parse tree follows grammar fully; AST is simplified. | Concrete vs abstract | Saying they are identical |
| Draw AST for `a + b * c`. | Root is `+`; right child is `*`. | Precedence captured | Making `+` and `*` same level |
| What compiler phase creates AST? | Syntax analysis/parsing usually creates it. | After lexical analysis | Saying semantic analysis creates tokens |
| What uses AST? | Semantic analyzer, optimizer, code generator, IDE tools. | Traversal, annotations | Saying only parser uses it |
| Can AST store types? | Yes, after semantic analysis it may become annotated AST. | Type info, symbol links | Saying AST can only store syntax |
| How are parentheses represented? | Often not represented unless semantically needed. | Structure captures grouping | Always adding parentheses nodes |
| How do you traverse an AST? | Commonly with recursive traversal or visitor pattern. | Pre-order/post-order depending task | Traversing tokens instead |
| Is AST machine independent? | Yes, AST represents source structure, not target CPU details. | High-level IR | Calling it assembly-level |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why may AST be unsuitable for low-level optimization? | AST is high-level and tree-shaped. It does not naturally represent shared subexpressions, control-flow joins, or low-level instruction constraints. |
| How does AST help type checking? | Each expression node can be visited, child types can be computed, and the parent node can be validated and annotated with its resulting type. |
| What is an AST visitor? | A design pattern where separate visitor functions handle different node types. It keeps traversal logic organized for tasks like type checking or code generation. |
| Can two different source programs have the same AST? | Yes, if differences are only concrete syntax, such as redundant parentheses or whitespace. |
| Why do refactoring tools need ASTs? | They need structural understanding. Text search cannot distinguish variables, comments, strings, and different scopes. |

## 8. Comparison Tables

### Parse Tree vs AST

| Feature | Parse Tree | AST |
|---|---|---|
| Also called | Concrete syntax tree | Abstract syntax tree |
| Contains grammar nonterminals | Yes | Usually no |
| Contains punctuation | Often yes | Usually no |
| Size | Larger | Smaller |
| Best for | Proving grammar derivation | Semantic analysis and translation |
| Example nodes | Expr, Term, Factor | Assign, BinaryOp, Return |

### Tokens vs AST

| Feature | Tokens | AST |
|---|---|---|
| Structure | Flat list | Hierarchical tree |
| Produced by | Lexer | Parser |
| Knows precedence | No | Yes |
| Good for | Lexical analysis | Program understanding |

## 9. Common Mistakes

- Confusing AST with parse tree.
- Drawing expression trees without respecting precedence.
- Thinking AST must include every semicolon and parenthesis.
- Forgetting AST can be annotated with semantic information.
- Saying AST directly represents control-flow edges like a CFG.
- Assuming AST is the final IR used for all optimizations.

## 10. Edge Cases / Special Cases

- Parentheses may affect AST structure but may not appear as nodes.
- Some languages preserve comments and formatting in a concrete syntax tree for tooling.
- Macros can change what AST gets generated.
- Error-tolerant parsers may build partial ASTs for IDEs.
- Desugared ASTs may replace high-level syntax with simpler forms.

## 11. How to Explain in Interview

"An AST is a simplified tree representation of source code. It keeps meaningful constructs like operators, assignments, loops, and function declarations, while removing grammar details such as punctuation. Compilers use ASTs for semantic analysis and as a starting point for IR generation."

## 12. Quick Revision Notes

- AST = meaningful syntax tree.
- Parser usually builds it.
- Smaller than parse tree.
- Captures precedence and nesting.
- Used by compilers, IDEs, linters, and transpilers.
- Interview trap: parse tree and AST are not the same.

## 13. Practice Tasks

1. Draw AST for `x = (a + b) * (c - d)`.
2. Compare parse tree and AST for `id + id * id`.
3. Write a recursive traversal that prints expression nodes in postorder.
4. Identify which AST nodes are needed for `if`, `while`, `return`, and function calls.
5. Explain why text replacement is unsafe for rename refactoring.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Tree of meaningful source-code structure |
| Why it matters | Enables semantic analysis, tooling, and IR generation |
| Most asked questions | AST vs parse tree, draw AST, where used |
| Common comparisons | Tokens vs AST, parse tree vs AST |
| One-line answer | AST is the compiler-friendly tree form of source code after parsing. |

---

# 3. Three-Address Code

## 1. Overview

**Definition:** **Three-address code (TAC)** is an intermediate representation where each instruction has at most three addresses: usually two operands and one result.

Typical form:

```text
x = y op z
```

Here `x`, `y`, and `z` are addresses. They may be variable names, constants, or temporaries.

**Why it matters:**
- It breaks complex expressions into simple steps.
- It is easy to optimize.
- It maps naturally to many machine instructions.
- It is a common exam and interview topic because expression translation becomes mechanical.

**Where it is used in real systems:**
- Educational compilers use TAC heavily.
- Production compilers use TAC-like IRs.
- Optimizers use similar simple operations internally.
- Virtual machines and JIT compilers often operate on linear IR close to TAC.

**Why interviewers ask about it:** TAC is easy to test in interviews. They can ask you to convert expressions, loops, conditionals, array access, and function calls into intermediate code.

## 2. Core Idea

TAC converts one complex operation into a sequence of simple operations.

**Intuition:** A CPU usually cannot execute `x = a + b * c - d / e` as one instruction. TAC makes every intermediate result explicit.

**Real-world analogy:** Solving a math expression on paper. You do multiplication first, store the result, do division, store the result, then combine them.

**Small example:**

```c
x = a + b * c;
```

TAC:

```text
t1 = b * c
t2 = a + t1
x  = t2
```

**Step-by-step:**
1. Identify highest-precedence operation: `b * c`.
2. Store it in temporary `t1`.
3. Add `a + t1`.
4. Store in temporary `t2`.
5. Assign `t2` to `x`.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Temporaries | Compiler-created variables | Store intermediate results | `t1 = b * c` | "How many temporaries are needed?" |
| Assignment | Copy one value to another | Basic operation | `x = t1` | "Translate assignment statement." |
| Binary operations | Two operands and result | Core of TAC | `t1 = a + b` | "Convert expression to TAC." |
| Unary operations | One operand and result | Needed for negation, not | `t1 = -a` | "Handle unary minus." |
| Conditional jumps | Branch based on condition | Represents `if` and loops | `if x < y goto L1` | "Translate if-else." |
| Unconditional jumps | Direct control transfer | Represents loop back edges | `goto L2` | "Translate while." |
| Labels | Named instruction positions | Jump targets | `L1:` | "Where do labels go?" |
| Function calls | Parameter passing and call result | Represents procedures | `param x`, `t1 = call f, 1` | "Translate function call." |
| Array access | Address calculation | Important for memory layout | `t1 = i * width` | "Translate `a[i]`." |

## 4. Real-World Example

**Backend server code compiled by a JIT:** Suppose a Java method computes a price:

```java
total = base + tax * quantity;
```

A JIT compiler may lower it into simple IR operations similar to TAC, optimize common subexpressions, remove redundant loads, and emit machine instructions.

## 5. Diagrams / Mental Models

```text
Expression tree                    TAC sequence

      +                            t1 = b * c
     / \                           t2 = a + t1
    a   *                          x  = t2
       / \
      b   c
```

### Common TAC Forms

| Form | Meaning |
|---|---|
| `x = y op z` | Binary operation |
| `x = op y` | Unary operation |
| `x = y` | Assignment |
| `goto L` | Unconditional jump |
| `if x relop y goto L` | Conditional branch |
| `param x` | Pass argument |
| `x = call f, n` | Function call returning value |
| `return x` | Return from function |

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is TAC? | IR where each instruction has at most three addresses. | Result, operand1, operand2 | Saying exactly three always |
| Convert `x=a+b*c`. | `t1=b*c; t2=a+t1; x=t2`. | Precedence, temporaries | Doing addition first |
| Why use temporaries? | To hold intermediate results explicitly. | Simplifies optimization/codegen | Reusing source variables incorrectly |
| What are addresses in TAC? | Names, constants, temporaries, memory locations. | Not only memory addresses | Thinking address means pointer only |
| How are conditionals represented? | With conditional jumps and labels. | `if cond goto`, `goto` | Keeping high-level `if` unchanged |
| How are loops represented? | Labels, condition checks, body, back jump. | Loop header and exit label | Missing back edge |
| Is TAC machine code? | No, it is intermediate and usually machine independent. | IR not final binary | Calling it assembly |
| How are function calls represented? | Using `param`, `call`, and return value temporaries. | Calling convention abstracted | Ignoring argument count/order |
| How is array indexing handled? | Compute offset then load/store. | Element width, base address | Forgetting element size |
| What are common TAC representations? | Quadruples, triples, indirect triples. | Storage formats | Confusing TAC with quadruple only |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why does TAC make optimization easier? | Each instruction has a small, explicit effect. Optimizations like constant folding, common subexpression elimination, copy propagation, and dead-code elimination become easier to implement. |
| How would you generate TAC from an AST? | Do a postorder traversal. Generate code for children first, store their results in temporaries, then emit the parent operation. |
| How does TAC represent short-circuit boolean expressions? | It usually uses conditional jumps so evaluation can skip the right side when the answer is already known. |
| What is the difference between TAC and SSA? | TAC allows variables to be assigned multiple times. SSA is usually TAC-like but each variable version is assigned exactly once. |
| Can TAC be optimized before machine code generation? | Yes. Many machine-independent optimizations are performed on TAC or TAC-like IR. |

## 8. Comparison Tables

### TAC vs AST

| Feature | AST | TAC |
|---|---|---|
| Shape | Tree | Linear instruction sequence |
| Level | Higher-level | Lower-level |
| Temporaries | Usually implicit | Explicit |
| Good for | Semantic analysis | Optimization and code generation |
| Control flow | Nested constructs | Labels and jumps |

### TAC vs Assembly

| Feature | TAC | Assembly |
|---|---|---|
| Machine dependent | Usually no | Yes |
| Registers | Abstract temporaries | Real or virtual registers |
| Instruction format | Simple 3-address style | Target-specific |
| Used by | Compiler middle end | Assembler/CPU path |

## 9. Common Mistakes

- Thinking TAC instructions must always contain exactly three addresses.
- Ignoring operator precedence during conversion.
- Forgetting labels for control-flow constructs.
- Treating temporaries as real source variables.
- Forgetting array element width in address calculation.
- Confusing TAC form with its storage representation.

## 10. Edge Cases / Special Cases

- Unary operations use fewer than three addresses.
- Function calls may require multiple `param` instructions.
- Boolean expressions may be translated using numeric values or control flow.
- Array access differs for row-major and column-major layout.
- Object field access may require offset lookup in class layout.

## 11. How to Explain in Interview

"Three-address code is an intermediate code form where each instruction performs one simple operation using at most two operands and one result. It converts complex expressions into temporary-based steps, which makes optimization and target-code generation easier."

## 12. Quick Revision Notes

- TAC form: `x = y op z`.
- Uses temporaries like `t1`, `t2`.
- Control flow uses labels and jumps.
- Function calls use `param` and `call`.
- Interview trap: "three-address" means at most three addresses, not exactly three.

## 13. Practice Tasks

1. Generate TAC for `x = (a + b) * (c - d)`.
2. Generate TAC for `if (a < b) x = 1; else x = 2;`.
3. Generate TAC for `while (i < n) i = i + 1;`.
4. Generate TAC for `a[i] = b[j] + 1`.
5. Apply constant folding to TAC for `x = 2 * 3 + y`.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | IR with at most two operands and one result per instruction |
| Why it matters | Simple, optimizable, close to machine operations |
| Most asked questions | Convert expression, translate if/while, array access |
| Common comparisons | TAC vs AST, TAC vs assembly |
| One-line answer | TAC breaks complex source constructs into simple temporary-based instructions. |

---

# 4. Quadruples

## 1. Overview

**Definition:** A **quadruple** is a way to represent three-address code using four fields:

```text
(operator, argument1, argument2, result)
```

For example:

```text
t1 = b * c
```

can be stored as:

```text
(*, b, c, t1)
```

**Why it matters:**
- It gives TAC a structured table format.
- It is easy for compiler algorithms to process.
- It makes results explicit.
- It supports optimization passes that rewrite operands and results.

**Where it is used in real systems:**
- Educational compilers use quadruple tables.
- Optimizer passes often store IR instructions in records similar to quadruples.
- Static analyzers store operations in structured forms.

**Why interviewers ask about it:** It is a standard representation question after TAC. Interviewers often ask you to produce quadruples for an expression and compare them with triples.

## 2. Core Idea

Quadruples store every TAC instruction as a row in a table.

**Intuition:** TAC is the sentence; quadruple is the spreadsheet row.

**Real-world analogy:** A bank transaction can be written as text, but databases store it in columns like operation, source account, destination account, amount. Quadruples do that for compiler instructions.

**Small example:**

```c
x = a + b * c;
```

TAC:

```text
t1 = b * c
t2 = a + t1
x  = t2
```

Quadruples:

| No. | op | arg1 | arg2 | result |
|---:|---|---|---|---|
| 0 | `*` | `b` | `c` | `t1` |
| 1 | `+` | `a` | `t1` | `t2` |
| 2 | `=` | `t2` | `-` | `x` |

**Step-by-step:**
1. Create a row for each TAC instruction.
2. Put the operation in `op`.
3. Put operands in `arg1` and `arg2`.
4. Put the destination in `result`.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Operator field | Operation being performed | Tells compiler action | `+`, `*`, `goto` | "What goes in op?" |
| Argument fields | Input operands | Data dependencies | `a`, `b`, `t1` | "How represent unary op?" |
| Result field | Destination | Makes definitions explicit | `t2` | "Why quadruples are easy to optimize?" |
| Temporaries | Named intermediate results | Referenced by later rows | `t1` | "Quadruples vs triples." |
| Jump quadruples | Branch representation | Handles control flow | `(if<, a, b, L1)` | "Represent if statement." |
| Call quadruples | Function-call rows | Handles procedures | `(param, x, -, -)` | "Represent function call." |

## 4. Real-World Example

**Compiler optimization pass:** Suppose an optimizer sees:

| op | arg1 | arg2 | result |
|---|---|---|---|
| `+` | `2` | `3` | `t1` |

It can replace this row with:

| op | arg1 | arg2 | result |
|---|---|---|---|
| `=` | `5` | `-` | `t1` |

This is constant folding. Quadruples make the rewrite straightforward because fields are explicit.

## 5. Diagrams / Mental Models

```text
TAC instruction:   t1 = a + b

Quadruple row:

+------+-------+-------+--------+
| op   | arg1  | arg2  | result |
+------+-------+-------+--------+
| +    | a     | b     | t1     |
+------+-------+-------+--------+
```

### Control-Flow Quadruple Examples

| Source | Quadruple |
|---|---|
| `goto L1` | `(goto, -, -, L1)` |
| `if a < b goto L1` | `(if<, a, b, L1)` |
| `x = y` | `(=, y, -, x)` |
| `return x` | `(return, x, -, -)` |

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is a quadruple? | A 4-field representation of TAC: op, arg1, arg2, result. | Structured TAC | Saying it has four operands |
| Convert `x=a+b*c` to quadruples. | Rows for `*`, `+`, and assignment. | Temporaries explicit | Skipping assignment row |
| Why are quadruples useful? | They make operands and result explicit for optimization. | Easy rewriting | Saying only memory saving |
| What is the result field? | Destination of the operation. | Defines variable/temp | Confusing with arg2 |
| How represent unary minus? | `(-, a, -, t1)` or `(uminus, a, -, t1)`. | arg2 empty | Forcing two operands |
| How represent assignment? | `(=, source, -, destination)`. | Copy operation | Putting destination in arg1 |
| Quadruples vs triples? | Quadruples name temporary results; triples refer to instruction positions. | Explicit result vs positional result | Saying both are identical |
| Are labels stored in quadruples? | Yes, jump targets can be labels or instruction numbers. | Control flow | Ignoring branches |
| Do quadruples require temporaries? | Usually yes for intermediate values. | `t1`, `t2` | Thinking no temporaries exist |
| Can quadruples represent calls? | Yes, using rows like `param`, `call`, and assignment. | Procedure representation | Treating calls as source syntax only |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why are quadruples easier to rearrange than triples? | Because later instructions refer to named temporaries, not instruction positions. Reordering does not automatically break references. |
| What is the memory cost of quadruples? | They store an explicit result field, so they may use more space than triples. The advantage is simpler optimization and code motion. |
| How can conditional jumps be stored as quadruples? | The relational operator and operands are stored with the target label as result, for example `(if<, a, b, L1)`. |
| How do quadruples help common subexpression elimination? | The compiler can compare `op`, `arg1`, and `arg2` fields to detect repeated computations and reuse an existing result. |
| Can quadruples represent SSA? | Yes, an SSA-style IR can use quadruple-like instruction records where each result name is assigned only once. |

## 8. Comparison Tables

### Quadruples vs TAC Text

| Feature | TAC Text | Quadruple |
|---|---|---|
| Format | Human-readable instruction | Table/record |
| Example | `t1 = a + b` | `(+, a, b, t1)` |
| Easier for humans | Yes | Medium |
| Easier for algorithms | Medium | Yes |

### Quadruples vs Triples

| Feature | Quadruples | Triples |
|---|---|---|
| Fields | op, arg1, arg2, result | op, arg1, arg2 |
| Temporary names | Explicit | Often omitted |
| References | By temp name | By instruction number |
| Code movement | Easier | Harder unless indirect triples used |
| Space | More | Less |

## 9. Common Mistakes

- Saying quadruples have four operands.
- Mixing up `arg2` and `result`.
- Forgetting that unary operations leave one argument field empty.
- Not using temporaries for intermediate results.
- Confusing quadruple representation with the TAC concept itself.

## 10. Edge Cases / Special Cases

- For `x = y`, `arg2` is unused.
- For `goto L`, both argument fields may be unused.
- Function calls may require several rows, not one row.
- Some compilers store instruction numbers instead of symbolic labels.
- Operators may be normalized, such as `if<` instead of separate `if` and `<`.

## 11. How to Explain in Interview

"A quadruple is a table representation of three-address code with four fields: operator, first argument, second argument, and result. It is easy for compiler passes to process because every instruction's inputs and output are explicit."

## 12. Quick Revision Notes

- Format: `(op, arg1, arg2, result)`.
- Best feature: explicit result.
- Easier than triples for code movement.
- Uses temporaries for intermediate values.
- Interview trap: quadruple means four fields, not four operands.

## 13. Practice Tasks

1. Write quadruples for `x = (a + b) * (c - d)`.
2. Write quadruples for `if a < b then x = 1 else x = 2`.
3. Represent unary minus `x = -a + b`.
4. Compare quadruple and triple representation for the same expression.
5. Identify constant-folding opportunities in a quadruple table.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Four-field storage format for TAC |
| Why it matters | Explicit operands and result simplify optimization |
| Most asked questions | Convert expression, compare with triples |
| Common comparisons | Quadruples vs triples, quadruples vs TAC text |
| One-line answer | Quadruples store each TAC instruction as `(op, arg1, arg2, result)`. |

---

# 5. Triples

## 1. Overview

**Definition:** A **triple** is a representation of three-address code using three fields:

```text
(operator, argument1, argument2)
```

Unlike quadruples, triples do not store an explicit result field. The result of an instruction is referred to by the instruction's position number.

**Why it matters:**
- It reduces the need for temporary variable names.
- It shows how intermediate results can be referenced indirectly.
- It is a common comparison topic with quadruples.

**Where it is used in real systems:**
- Teaching compilers and compiler textbooks use triples to explain IR storage choices.
- Some internal IRs use instruction references instead of explicit temporary names.
- Dataflow systems often refer to operation results by node or instruction identity.

**Why interviewers ask about it:** Triples test whether you understand that TAC is the idea, while quadruples and triples are storage representations.

## 2. Core Idea

In triples, the result of each instruction is implicit. If instruction 0 computes `b * c`, later instructions refer to `(0)`.

**Intuition:** Instead of naming every intermediate result `t1`, `t2`, use the row number as the name.

**Real-world analogy:** In a spreadsheet, a formula may refer to cell `A1` instead of giving that value a separate name. Triples refer to instruction positions similarly.

**Small example:**

```c
x = a + b * c;
```

Triples:

| No. | op | arg1 | arg2 |
|---:|---|---|---|
| 0 | `*` | `b` | `c` |
| 1 | `+` | `a` | `(0)` |
| 2 | `=` | `(1)` | `x` |

Instruction 1 uses the result of instruction 0.

**Step-by-step:**
1. Compute `b * c` at row 0.
2. Use `(0)` as an operand in row 1.
3. Assign result `(1)` to `x`.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Instruction position | Row number identifies result | Removes temp names | `(0)` | "How are results referenced?" |
| Positional reference | Operand can refer to previous row | Encodes dependencies | `arg2 = (0)` | "What does `(i)` mean?" |
| Code motion problem | Reordering rows changes positions | Makes optimization harder | Moving row 0 | "Why triples are harder to optimize?" |
| Indirect triples | Separate pointer table to triples | Allows reordering without changing references | pointer list | "How to fix code motion issue?" |
| Assignment in triples | Store source and destination in fields | No explicit result column | `(=, (1), x)` | "How represent assignment?" |

## 4. Real-World Example

**Expression optimizer:** A compiler can represent expression computations as triples and refer to previous computations by instruction number. But if it wants to move an instruction out of a loop, positional references can become inconvenient. This motivates indirect triples or named temporaries.

## 5. Diagrams / Mental Models

```text
Quadruple style:
t1 = b * c
t2 = a + t1
x  = t2

Triple style:
(0) * b c
(1) + a (0)
(2) = (1) x
```

### Indirect Triple Mental Model

```text
Pointer table:     Triple table:
P0 -> T0           T0: (*, b, c)
P1 -> T1           T1: (+, a, (0))
P2 -> T2           T2: (=, (1), x)
```

To reorder execution, change the pointer table instead of moving triple rows.

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is a triple? | A TAC representation with op, arg1, arg2; result is instruction position. | Three fields, implicit result | Saying it has no result at all |
| How is result referenced? | By instruction number, like `(0)`. | Positional reference | Inventing temporaries unnecessarily |
| Convert `x=a+b*c` to triples. | `(*,b,c)`, `(+,a,(0))`, `(=,(1),x)`. | Correct dependencies | Wrong row references |
| Triples vs quadruples? | Quadruples have explicit result; triples use instruction position. | Space vs code motion | Saying triples are always better |
| Why are triples compact? | They avoid storing temporary result names. | Fewer fields | Ignoring reference overhead |
| What is a disadvantage of triples? | Code reordering is harder because references depend on positions. | Optimization issue | Saying no disadvantage |
| What are indirect triples? | Triples accessed through a pointer list to allow reordering. | Solves movement issue | Confusing with pointers in C |
| Can triples represent unary ops? | Yes, second argument may be empty. | Same as TAC | Forcing arg2 |
| Can triples represent control flow? | Yes, jumps can be stored as triple operations. | Labels or instruction refs | Thinking only expressions |
| Are triples machine code? | No, they are an IR storage representation. | Compiler middle end | Calling them CPU instructions |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why does code motion become difficult with triples? | If an instruction is moved, its position number changes. Any operand referring to that position may need updating. |
| How do indirect triples solve code motion? | They keep triples in a stable table and reorder a separate list of pointers. References can remain stable while execution order changes. |
| Are triples better than quadruples? | Not always. Triples save space but make optimization and reordering less convenient. Quadruples are often simpler to manipulate. |
| How are dependencies represented in triples? | A dependency is represented when an argument refers to a previous instruction number. |
| Why might modern compilers prefer named SSA values over textbook triples? | Named SSA values make data dependencies explicit and make transformations easier while still avoiding multiple assignments to the same variable. |

## 8. Comparison Tables

### Triples vs Indirect Triples

| Feature | Triples | Indirect Triples |
|---|---|---|
| Result reference | Instruction position | Stable triple reference through pointer table |
| Code movement | Harder | Easier |
| Extra table | No | Yes |
| Space | Lower | Slightly higher |
| Best for | Simple representation | Optimizing compilers |

### Triples vs Quadruples

| Feature | Triples | Quadruples |
|---|---|---|
| Fields | 3 | 4 |
| Result | Implicit | Explicit |
| Temporaries | Reduced | Common |
| Reordering | Harder | Easier |
| Readability | Lower | Higher |

## 9. Common Mistakes

- Thinking triples cannot represent intermediate results.
- Forgetting that the row number acts as the result.
- Reordering triples without updating references.
- Confusing `(0)` with a constant zero.
- Saying triples are the same as syntax trees.

## 10. Edge Cases / Special Cases

- Forward references are usually avoided in expression triples.
- Labels may still be symbolic rather than numeric.
- Indirect triples introduce a pointer table.
- Some operations need only one argument.
- Assignment triples may look unusual because destination is stored as an argument.

## 11. How to Explain in Interview

"A triple represents a TAC instruction using only operator and operands. The result is not stored in a separate field; it is identified by the instruction number. This saves temporary names but makes code movement harder."

## 12. Quick Revision Notes

- Format: `(op, arg1, arg2)`.
- Result is instruction index.
- `(0)` means result of instruction 0.
- Main disadvantage: hard to reorder.
- Indirect triples use pointer tables.

## 13. Practice Tasks

1. Generate triples for `x = (a + b) * (c - d)`.
2. Convert a quadruple table into triples.
3. Show how moving one triple can break references.
4. Draw an indirect triple table for a three-instruction expression.
5. Compare space and optimization convenience of triples and quadruples.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Three-field TAC representation with implicit result |
| Why it matters | Saves temp names and teaches IR storage trade-offs |
| Most asked questions | Triples vs quadruples, result references |
| Common comparisons | Triples vs quadruples, triples vs indirect triples |
| One-line answer | A triple stores `(op, arg1, arg2)` and uses the instruction number as the result. |

---

# 6. Control-Flow Graph

## 1. Overview

**Definition:** A **control-flow graph (CFG)** is a directed graph that represents all possible execution paths through a program or function.

In a CFG:
- Nodes are usually **basic blocks**.
- Edges represent possible flow of control from one block to another.

**Why it matters:**
- It is essential for analyzing branches, loops, reachability, and optimization.
- Many compiler optimizations are performed over CFGs.
- It is used in static analysis, security analysis, testing, and performance tuning.

**Where it is used in real systems:**
- Compilers use CFGs for dataflow analysis and optimization.
- Static analyzers use CFGs to detect unreachable code and possible null dereferences.
- Test coverage tools reason about branches and paths.
- Security tools use CFGs to analyze suspicious control transfers.

**Why interviewers ask about it:** CFGs connect compiler design with graph algorithms. They test whether you can reason about execution paths instead of just syntax.

## 2. Core Idea

A CFG shows where execution can go next.

**Intuition:** An AST shows nesting. A CFG shows movement.

**Real-world analogy:** A road map. Intersections are basic blocks, roads are possible transitions. A loop is a road that leads back to an earlier intersection.

**Small example:**

```c
if (x > 0)
    y = 1;
else
    y = 2;
z = y + 3;
```

CFG:

```text
        [B1: test x > 0]
          /            \
       true            false
        v                v
 [B2: y = 1]       [B3: y = 2]
        \              /
         v            v
       [B4: z = y + 3]
```

**Step-by-step:**
1. Create a block for the condition.
2. Add one edge for true and one for false.
3. Add blocks for then and else bodies.
4. Join both branches at the following statement.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Nodes | Basic blocks | Units of sequential execution | `B1`, `B2` | "What does a CFG node represent?" |
| Edges | Possible control transfers | Represent branches and loops | true/false edge | "What do CFG edges mean?" |
| Entry block | Function starting point | Analysis starts here | first block | "What is entry node?" |
| Exit block | Function return/end | Analysis may collect results here | return block | "Multiple returns?" |
| Dominators | A node dominates another if every path to it passes through the dominator | Used in SSA and optimization | entry dominates all | "What is a dominator?" |
| Back edges | Edges that point to earlier/dominating block | Identify loops | loop body to header | "How detect loops?" |
| Reachability | Whether a block can execute | Remove dead code | block after `return` | "Find unreachable code." |
| Dataflow analysis | Facts propagated over CFG | Powers optimizations | live variables | "Why CFG needed?" |

## 4. Real-World Example

**Static analyzer detecting missing return:** In a function with several `if` branches, a CFG can show whether every path reaches a `return`. If one path reaches the end without returning a value, the compiler or analyzer can report an error.

## 5. Diagrams / Mental Models

### While Loop CFG

```text
        v
 [B1: i < n ?] ----false----> [B4: exit]
      |
     true
      v
 [B2: body]
      |
      v
 [B3: i = i + 1]
      |
      +---------back edge------> B1
```

### CFG vs AST Mental Model

| Program View | Best Question Answered |
|---|---|
| AST | "What is nested inside what?" |
| CFG | "What can execute after this?" |
| Dataflow graph | "Which value depends on which value?" |

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is a CFG? | A directed graph of possible execution paths. | Nodes as basic blocks, edges as control flow | Saying it is expression tree |
| What are CFG nodes? | Usually basic blocks. | Straight-line code blocks | Saying every token |
| What are CFG edges? | Possible transfers of control. | Branches, fall-through, loop back edges | Forgetting false edge |
| Why is CFG needed? | To analyze branches, loops, reachability, and dataflow. | Optimizations depend on it | Saying only for diagrams |
| Draw CFG for if-else. | Condition node splits into true/false blocks and rejoins. | Join block | Missing join |
| Draw CFG for while loop. | Header condition, body, back edge, exit edge. | Back edge | Drawing no exit |
| What is unreachable code? | Code with no path from entry. | Can be removed/warned | Confusing with dead assignment |
| What is a back edge? | Edge from a block to a loop header/earlier dominator. | Loop detection | Any backward arrow |
| What is an entry block? | First block where function execution begins. | Analysis start | Multiple arbitrary starts |
| How does CFG help optimization? | Dataflow analyses run over CFG to find constants, liveness, dead code. | Global reasoning | Only local expression optimization |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| What is a dominator? | Block A dominates block B if every path from the entry block to B must pass through A. Dominators are used in loop analysis and SSA construction. |
| How are loops identified in CFGs? | Back edges often indicate natural loops, especially when the target dominates the source. |
| Why are basic blocks used as CFG nodes instead of individual instructions? | Basic blocks reduce graph size because all instructions inside a block execute sequentially without internal branching. |
| How does CFG support liveness analysis? | Liveness facts propagate backward along CFG edges to determine whether variable values may be used in the future. |
| How can exceptions affect CFGs? | A statement that may throw can have exceptional edges to handler blocks, making the CFG more complex. |

## 8. Comparison Tables

### AST vs CFG

| Feature | AST | CFG |
|---|---|---|
| Structure | Tree | Directed graph |
| Represents | Syntax nesting | Execution paths |
| Loop representation | Loop node | Back edge |
| Branch representation | If node | Multiple outgoing edges |
| Best for | Semantic analysis, syntax transforms | Dataflow, optimization |

### CFG vs Dataflow Graph

| Feature | CFG | Dataflow Graph |
|---|---|---|
| Edges mean | Control can move | Value depends on another value |
| Focus | Execution order | Data dependencies |
| Nodes | Basic blocks/instructions | Operations/values |
| Used for | Reachability, liveness | Scheduling, expression optimization |

## 9. Common Mistakes

- Drawing CFG as a tree and forgetting joins.
- Missing the false edge from a condition.
- Missing loop back edges.
- Confusing dead code with unreachable code.
- Thinking CFG only exists after machine code generation.
- Ignoring fall-through edges.

## 10. Edge Cases / Special Cases

- `break` and `continue` create edges to loop exit or loop header.
- `return` blocks usually go to function exit.
- Exceptions add hidden edges.
- `switch` can create multiple outgoing edges.
- Short-circuit boolean expressions create control-flow edges.
- Infinite loops may not have an exit edge.

## 11. How to Explain in Interview

"A control-flow graph is a directed graph showing all possible execution paths in a function. Its nodes are usually basic blocks and its edges represent jumps, branches, fall-throughs, and loop back edges. Compilers use CFGs for dataflow analysis and optimization."

## 12. Quick Revision Notes

- CFG = execution-path graph.
- Nodes = basic blocks.
- Edges = possible control transfers.
- Loops create back edges.
- Branches split; joins merge.
- Interview trap: AST shows structure, CFG shows execution flow.

## 13. Practice Tasks

1. Draw CFG for an if-else program.
2. Draw CFG for a while loop with `break`.
3. Identify unreachable blocks in a TAC sequence.
4. Mark back edges in a loop CFG.
5. Run liveness analysis manually on a four-block CFG.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Directed graph of possible execution paths |
| Why it matters | Enables dataflow analysis, optimization, reachability |
| Most asked questions | Draw CFG, CFG vs AST, loops, back edges |
| Common comparisons | AST vs CFG, CFG vs dataflow graph |
| One-line answer | A CFG shows how control can move between basic blocks during execution. |

---

# 7. Basic Blocks

## 1. Overview

**Definition:** A **basic block** is a maximal sequence of consecutive instructions with:

1. One entry point, at the first instruction.
2. One exit point, at the last instruction.
3. No internal jumps into or out of the middle.

If the first instruction executes, every instruction in the block executes in order.

**Why it matters:**
- Basic blocks are the building units of CFGs.
- Many optimizations are first applied within basic blocks.
- They simplify reasoning about control flow.
- They are essential for code generation and instruction scheduling.

**Where it is used in real systems:**
- Compilers group IR instructions into basic blocks.
- CPU branch prediction and instruction scheduling often reason about blocks.
- Static analyzers use blocks to reduce graph complexity.
- Profilers report hot blocks or hot paths.

**Why interviewers ask about it:** Basic block construction is a classic compiler-design problem. Interviewers may give TAC and ask you to identify leaders and blocks.

## 2. Core Idea

A basic block is a straight-line region of code.

**Intuition:** Once you enter a basic block, there are no choices until the end.

**Real-world analogy:** A hallway with one entrance and one exit. Once inside, you walk straight through; decisions happen only at intersections between hallways.

**Small example:**

```text
1: t1 = a + b
2: t2 = t1 * c
3: if t2 < d goto 6
4: x = t2
5: goto 7
6: x = d
7: return x
```

Leaders:
- 1: first instruction
- 4: instruction after conditional jump
- 6: jump target
- 7: jump target and instruction after goto

Basic blocks:

```text
B1: 1,2,3
B2: 4,5
B3: 6
B4: 7
```

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Leaders | First instruction of a basic block | Used to partition TAC | first instruction, jump target | "Find leaders." |
| Maximal sequence | Include as many instructions as possible | Avoid unnecessary blocks | straight-line instructions | "Can this be same block?" |
| Fall-through | Control naturally moves to next block | Adds CFG edge | after condition false | "Add edges." |
| Jump target | Instruction reached by branch/goto | Starts new block | label `L1` | "Why target is leader?" |
| Local optimization | Optimization within one block | Simpler than global | constant folding | "Local vs global optimization." |
| Basic block DAG | DAG built for one block | Finds common subexpressions | `a+b` reused | "DAG representation." |

## 4. Real-World Example

**Compiler removes redundant computation inside a block:**

```text
t1 = a + b
t2 = a + b
x  = t1 + t2
```

Inside a basic block, the compiler can see `a + b` is computed twice without changes to `a` or `b`, so it can reuse `t1`.

## 5. Diagrams / Mental Models

### Leader Rules

| Rule | Why |
|---|---|
| First instruction is a leader | Program starts there |
| Target of any jump is a leader | Control can enter there |
| Instruction after a jump is a leader | Control may continue there after branch or from elsewhere |

### Basic Blocks to CFG

```text
Basic blocks:

B1: condition
B2: then part
B3: else part
B4: join

CFG:

      B1
     /  \
    B2  B3
     \  /
      B4
```

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is a basic block? | A maximal straight-line sequence with one entry and one exit. | No internal jumps | Saying any group of statements |
| What is a leader? | First instruction of a basic block. | First instruction, jump target, after jump | Missing instruction after jump |
| How to form basic blocks? | Find leaders, then each leader starts a block until before next leader. | Standard algorithm | Splitting every line |
| Why use basic blocks? | Reduce CFG size and enable local optimization. | Sequential execution | Saying only for readability |
| Can a basic block contain a branch? | Yes, but only as the last instruction. | Exit at end | Branch in middle |
| Can control enter middle of a block? | No. If it can, that instruction must start a new block. | One entry | Ignoring jump target |
| What is local optimization? | Optimization within a single basic block. | No cross-block facts | Calling all optimization local |
| Basic block vs CFG? | Basic blocks are nodes; CFG connects them with edges. | Building blocks | Saying same thing |
| Why maximal? | To avoid unnecessary fragmentation. | Include all straight-line instructions | Creating tiny blocks |
| What ends a block? | A jump, conditional branch, return, or instruction before next leader. | Control transfer | Ending after every assignment |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why is local optimization easier than global optimization? | Inside a basic block, execution is sequential and guaranteed after entry, so the compiler does not need to reason about multiple paths. |
| How do basic blocks help instruction scheduling? | Instructions inside a block can often be reordered if dependencies are preserved, without changing control flow. |
| How are basic blocks affected by labels? | A labeled instruction is usually a leader because control can jump to it. |
| Can a basic block have multiple successors? | Yes. A block ending in a conditional branch usually has two successors. |
| Can a basic block have multiple predecessors? | Yes. A join block after an if-else may have multiple incoming edges. |

## 8. Comparison Tables

### Basic Block vs Statement

| Feature | Statement | Basic Block |
|---|---|---|
| Unit type | Source-level construct | IR/control-flow unit |
| Size | Usually one source action | Multiple instructions |
| Entry | Source order | One control-flow entry |
| Exit | Source order | One final transfer |

### Local vs Global Optimization

| Feature | Local Optimization | Global Optimization |
|---|---|---|
| Scope | One basic block | Across CFG |
| Complexity | Lower | Higher |
| Needs CFG? | Not always | Yes |
| Example | Common subexpression in one block | Loop-invariant code motion |

## 9. Common Mistakes

- Forgetting that the first instruction is a leader.
- Missing jump targets.
- Missing the instruction after a jump.
- Ending a block too early.
- Allowing a jump into the middle of a block.
- Confusing block boundaries with source-line boundaries.

## 10. Edge Cases / Special Cases

- `return` ends a block.
- Unconditional `goto` ends a block; the next instruction may still be a leader.
- Conditional branch has two successors.
- A label in the middle of straight-line code starts a new block.
- Exception-throwing instructions may end or split blocks in advanced CFGs.

## 11. How to Explain in Interview

"A basic block is a maximal straight-line sequence of IR instructions with one entry and one exit. Once control enters the block, all instructions execute in order. CFG nodes are usually basic blocks."

## 12. Quick Revision Notes

- Basic block = straight-line code.
- Leaders: first instruction, jump targets, instructions after jumps.
- Branches appear only at block ends.
- Used as CFG nodes.
- Local optimization happens inside blocks.

## 13. Practice Tasks

1. Given TAC with labels and gotos, find leaders.
2. Divide a TAC sequence into basic blocks.
3. Draw CFG from basic blocks.
4. Find local common subexpressions in a block.
5. Identify whether a proposed block violates one-entry/one-exit rules.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Maximal straight-line instruction sequence |
| Why it matters | Forms CFG nodes and enables local optimization |
| Most asked questions | Find leaders, form blocks, draw CFG |
| Common comparisons | Basic block vs statement, local vs global optimization |
| One-line answer | A basic block is code that executes sequentially from one entry to one exit. |

---

# 8. Static Single Assignment Form Basics

## 1. Overview

**Definition:** **Static Single Assignment (SSA) form** is an intermediate representation where each variable is assigned exactly once.

If a source variable is assigned multiple times, SSA creates different versions:

```text
x1 = 10
x2 = x1 + 1
x3 = x2 * 2
```

**Why it matters:**
- It makes data dependencies explicit.
- It simplifies many optimizations.
- It helps compilers reason about values instead of mutable variables.
- It is widely used in modern compilers.

**Where it is used in real systems:**
- LLVM IR is in SSA form for register-like values.
- GCC uses SSA in its GIMPLE optimization pipeline.
- JavaScript JITs use SSA-like forms.
- Static analyzers use SSA-style representations for precise value tracking.

**Why interviewers ask about it:** SSA is a modern compiler concept that connects IR, CFG, dataflow, phi functions, and optimization.

## 2. Core Idea

SSA turns variable updates into new variable versions.

**Intuition:** Instead of asking "what is the current value of x?", SSA asks "which definition of x reaches this use?"

**Real-world analogy:** Version control for variables. Every assignment creates a new commit/version. You never overwrite an old version.

**Small example:**

Original:

```c
x = 1;
x = x + 2;
y = x * 3;
```

SSA:

```text
x1 = 1
x2 = x1 + 2
y1 = x2 * 3
```

**Step-by-step:**
1. Rename each assigned variable.
2. Replace later uses with the correct latest version.
3. At control-flow joins, use phi functions to choose between versions.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Single assignment | Each SSA name assigned once | Simplifies reasoning | `x1`, `x2` | "What does SSA mean?" |
| Variable versioning | Multiple source assignments become versions | Preserves updates | `i1`, `i2`, `i3` | "Convert to SSA." |
| Def-use chain | Links definition to uses | Optimization-friendly | `x2` used by `y1` | "Why SSA helps optimization?" |
| Phi function | Merges values at CFG joins | Handles branches | `x3 = phi(x1, x2)` | "Why phi needed?" |
| Dominance | Definitions must dominate uses | Valid SSA construction | def before all uses | "Role of dominators?" |
| SSA destruction | Convert SSA back to normal form | Needed for machine code | copies inserted | "How lower phi?" |

## 4. Real-World Example

**Dead code elimination in compiler:** In SSA:

```text
x1 = expensive()
y1 = 5
return y1
```

If `x1` has no uses and `expensive()` has no side effects, the compiler can remove it. SSA makes unused definitions easy to find.

## 5. Diagrams / Mental Models

### Variable Versions

```text
Normal variable:
x changes over time:  x -> x -> x

SSA variables:
x1 = first value
x2 = second value
x3 = third value
```

### SSA at Branch Join

```text
        if cond
        /     \
   x1 = 1   x2 = 2
        \     /
       x3 = phi(x1, x2)
       y1 = x3 + 1
```

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is SSA? | IR form where each variable version is assigned once. | Single assignment, versions | Saying source variable only once |
| Why use SSA? | Makes data dependencies explicit and optimizations simpler. | Def-use chains | Saying only saves memory |
| Convert simple assignments to SSA. | Rename each assignment and update uses. | Correct versions | Using old variable names |
| What happens at branches? | Phi functions merge possible incoming values. | CFG joins | Ignoring branch joins |
| What is a phi function? | A pseudo-operation selecting value based on predecessor block. | Control-flow dependent | Treating it as runtime function call |
| Is SSA source code? | No, it is compiler IR. | Internal representation | Writing SSA manually in normal code |
| Does SSA mean variable is immutable? | SSA names are immutable, but source variables may be mutable. | Versions simulate mutation | Saying language becomes functional |
| How does SSA help constant propagation? | Constants are attached to specific definitions and propagated along uses. | Def-use clarity | Missing control-flow merges |
| How is SSA removed? | Phi functions are lowered into copies and names mapped to registers/stack. | SSA destruction | Leaving phi in machine code |
| Which compilers use SSA? | LLVM, GCC, JIT compilers. | Modern compiler pipelines | Saying only academic compilers |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why is dominance important in SSA? | A definition should dominate its uses so every path to the use has seen the definition. Phi nodes handle cases where different definitions reach a join. |
| How does SSA help common subexpression elimination? | Since each value name has one definition, it is easier to know whether operands have changed between two expressions. |
| What is SSA destruction? | It is the process of converting SSA back to a form with normal assignments by replacing phi nodes with copies in predecessor blocks. |
| Does memory also become SSA? | Register-like values commonly use SSA. Memory SSA is more complex because loads/stores can alias. |
| Why do phi nodes appear at dominance frontiers? | Dominance frontiers are places where different control-flow paths meet, so multiple definitions may reach the same use. |

## 8. Comparison Tables

### Normal TAC vs SSA TAC

| Feature | Normal TAC | SSA Form |
|---|---|---|
| Assignment count | Variable can be assigned many times | Each version assigned once |
| Variable names | `x` reused | `x1`, `x2`, `x3` |
| Data dependencies | Less explicit | Very explicit |
| Branch merge | Same variable name reused | Phi function |
| Optimization | Harder | Easier |

### SSA vs Functional Programming

| Feature | SSA | Functional Programming |
|---|---|---|
| Purpose | Compiler IR | Programming paradigm |
| Mutation in source | Allowed | Usually avoided |
| Names | Compiler-generated versions | Programmer-level values |
| Phi nodes | Yes | No direct equivalent in source |

## 9. Common Mistakes

- Thinking SSA means the original program cannot assign `x` twice.
- Forgetting phi functions at merge points.
- Treating phi as a normal runtime function.
- Using a variable version before it is defined.
- Assuming all memory operations are automatically simple in SSA.
- Forgetting SSA must eventually be lowered before final machine code.

## 10. Edge Cases / Special Cases

- Loops need phi functions for variables updated inside the loop.
- Branches that assign a variable on only one path may need a phi with an old value.
- Memory aliasing makes SSA more complex.
- Phi nodes conceptually execute at block entry.
- Critical edges may need splitting during SSA destruction.

## 11. How to Explain in Interview

"SSA is an IR form where every variable version is assigned exactly once. Reassignments become new names like `x1`, `x2`, and values from different branches are merged using phi functions. This makes data dependencies explicit and simplifies optimizations."

## 12. Quick Revision Notes

- SSA = Static Single Assignment.
- Each SSA name has one definition.
- Reassignments become new versions.
- Phi functions merge versions at CFG joins.
- Used by LLVM, GCC, JITs.
- Interview trap: phi is not an ordinary source-level function call.

## 13. Practice Tasks

1. Convert straight-line assignments into SSA.
2. Convert an if-else assignment into SSA using phi.
3. Convert a loop counter update into SSA.
4. Identify dead SSA definitions.
5. Explain how SSA helps constant propagation.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | IR where each variable version is assigned once |
| Why it matters | Simplifies dataflow and optimization |
| Most asked questions | Convert to SSA, explain phi, SSA vs TAC |
| Common comparisons | Normal TAC vs SSA, SSA vs functional style |
| One-line answer | SSA turns variable updates into distinct versions so value flow is explicit. |

---

# 9. DAG Representation of Expressions

## 1. Overview

**Definition:** A **DAG representation of expressions** is a directed acyclic graph used to represent computations in an expression or basic block, where common subexpressions can be shared.

DAG stands for **Directed Acyclic Graph**:
- Directed: edges have direction.
- Acyclic: no cycles.
- Graph: nodes can be shared, unlike a tree.

**Why it matters:**
- It detects common subexpressions.
- It avoids redundant computation.
- It helps local optimization inside basic blocks.
- It provides a bridge between expression trees and optimized code.

**Where it is used in real systems:**
- Compiler optimizers detect repeated expressions.
- Query optimizers reuse repeated computations.
- Spreadsheet engines build dependency graphs.
- Build systems use DAGs for task dependencies.

**Why interviewers ask about it:** DAGs test whether you understand expression optimization beyond simply generating TAC.

## 2. Core Idea

An expression tree duplicates repeated computations. A DAG shares them.

**Intuition:** If two parts of code compute `a + b` and neither `a` nor `b` changed, compute it once and reuse it.

**Real-world analogy:** If two recipes need chopped onions, chop them once and use the result in both recipes.

**Small example:**

```c
x = (a + b) * (a + b);
```

Expression tree duplicates `a + b`:

```text
        *
      /   \
     +     +
    / \   / \
   a   b a   b
```

DAG shares `a + b`:

```text
     *
    / \
   v   v
   +
  / \
 a   b
```

Optimized TAC:

```text
t1 = a + b
x  = t1 * t1
```

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Leaf nodes | Variables/constants | Inputs to expression | `a`, `5` | "What are leaves?" |
| Interior nodes | Operators | Computations | `+`, `*` | "Draw DAG." |
| Common subexpression | Same operation on same unchanged operands | Can reuse result | `a + b` repeated | "Optimize expression." |
| Value numbering | Assign numbers to equivalent values | Detects duplicates | same value number | "How compiler finds CSE?" |
| Local DAG | DAG for one basic block | Easier and safe locally | block-level optimization | "Why basic block?" |
| Killed variables | Assignment changes variable value | Invalidates old expressions | `a = ...` | "When can reuse fail?" |

## 4. Real-World Example

**Database query execution:** A SQL query may compute the same expression in `SELECT`, `WHERE`, and `ORDER BY`. A query optimizer can represent computations as a graph and avoid repeating expensive expressions when safe.

## 5. Diagrams / Mental Models

### Tree vs DAG

| Feature | Expression Tree | Expression DAG |
|---|---|---|
| Repeated expression | Duplicated | Shared |
| Shape | Tree | Directed acyclic graph |
| Optimization | Less explicit | More explicit |
| Node sharing | No | Yes |

### Basic Block DAG Example

```text
t1 = a + b
t2 = a + b
t3 = t1 * t2

DAG:
       *
      / \
     v   v
     +
    / \
   a   b
```

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is a DAG? | Directed acyclic graph. | Directed, no cycles | Saying it is always a tree |
| Why use DAG for expressions? | To share common subexpressions and avoid recomputation. | Local optimization | Only saying visualization |
| DAG vs expression tree? | DAG can share nodes; tree cannot. | Common subexpression | Drawing duplicates |
| What are leaves? | Variables or constants. | Inputs | Making operators leaves |
| What are interior nodes? | Operators/computations. | Computed values | Missing operands |
| What is common subexpression elimination? | Reusing a previously computed same expression. | Same operands unchanged | Reusing after variable assignment |
| Why is DAG acyclic? | Expression dependencies flow from operands to results without circular dependency. | No cycles in expression eval | Confusing with CFG loops |
| Can DAG optimize across blocks? | Basic block DAG is local; global CSE needs CFG/dataflow. | Scope matters | Assuming local DAG handles all |
| What kills an expression? | Assignment to one of its operands. | Value changes | Ignoring mutation |
| How generate TAC from DAG? | Emit code in dependency order, computing shared nodes once. | Topological order | Emitting before operands |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| How does a compiler detect equivalent DAG nodes? | It can use value numbering or a table keyed by operator and operand nodes. If the same key appears again and operands are unchanged, reuse the node. |
| Why is DAG optimization usually local in textbooks? | Within a basic block, control flow is straight-line, so it is easier to know all instructions execute in order. |
| What happens when `a` is reassigned? | Expressions depending on the old value of `a` cannot be reused for later computations using the new `a`. |
| Can algebraic identities be applied using DAGs? | Yes, but carefully. For example, `x + 0 = x`; however floating-point and overflow rules may restrict transformations. |
| How is a DAG different from a CFG? | A DAG represents data dependencies in expressions; a CFG represents possible control-flow paths and may contain cycles. |

## 8. Comparison Tables

### DAG vs CFG

| Feature | DAG | CFG |
|---|---|---|
| Represents | Data/expression dependencies | Control-flow paths |
| Cycles | No | Yes, loops create cycles |
| Nodes | Values/operators | Basic blocks |
| Edges | Operand dependencies | Execution transfer |
| Main use | Local expression optimization | Global program analysis |

### Common Subexpression Elimination vs Constant Folding

| Feature | CSE | Constant Folding |
|---|---|---|
| Removes | Repeated computations | Computations with constant operands |
| Example | reuse `a+b` | replace `2*3` with `6` |
| Needs unchanged variables | Yes | Not usually |
| DAG helps? | Strongly | Sometimes |

## 9. Common Mistakes

- Drawing a tree when a DAG should share nodes.
- Reusing an expression after one operand changes.
- Confusing CFG cycles with expression DAGs.
- Forgetting that local DAG optimization is limited to a basic block.
- Applying algebraic laws unsafely with floating-point arithmetic.

## 10. Edge Cases / Special Cases

- `a + b` and `b + a` may be equivalent for integer addition, but compiler must know operation properties.
- Floating-point arithmetic is not always safely associative.
- Function calls may have side effects, so repeated calls may not be reusable.
- Pointer writes can invalidate memory loads.
- Volatile variables should not be optimized away casually.

## 11. How to Explain in Interview

"A DAG representation shares repeated expression nodes. Unlike an expression tree, it does not duplicate common subexpressions. This lets the compiler compute expressions like `a+b` once and reuse the value when operands have not changed."

## 12. Quick Revision Notes

- DAG = directed acyclic graph.
- Used for expression/basic-block optimization.
- Shares common subexpressions.
- Leaves = variables/constants.
- Interior nodes = operators.
- Interview trap: do not reuse expressions after operand mutation.

## 13. Practice Tasks

1. Draw DAG for `(a+b)*(a+b)`.
2. Draw DAG for `a*b + a*b + c`.
3. Convert a DAG into optimized TAC.
4. Identify killed expressions after assignment.
5. Compare DAG and CFG for a loop program.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Directed acyclic graph representing expression dependencies |
| Why it matters | Detects and eliminates redundant computation |
| Most asked questions | DAG vs tree, CSE, generate TAC |
| Common comparisons | DAG vs CFG, CSE vs constant folding |
| One-line answer | A DAG shares equivalent expression nodes so the compiler can compute them once. |

---

# 10. Phi Functions

## 1. Overview

**Definition:** A **phi function** is a special SSA operation used at a control-flow join to select the correct variable version depending on which predecessor block executed.

Example:

```text
x3 = phi(x1, x2)
```

This means: if control came from one predecessor, use `x1`; if it came from another, use `x2`.

**Why it matters:**
- It makes SSA work with branches and loops.
- It represents merged values without losing single-assignment property.
- It is essential for SSA-based optimizations.

**Where it is used in real systems:**
- LLVM IR uses `phi` instructions.
- GCC SSA uses phi nodes.
- JIT compilers use phi-like merge nodes.
- Static analyzers use similar merge concepts for dataflow facts.

**Why interviewers ask about it:** Phi functions are the part of SSA students often memorize but do not understand. Interviewers use them to test real control-flow reasoning.

## 2. Core Idea

Phi functions merge different incoming versions of the same source variable.

**Intuition:** At a join point, the compiler needs one name for "the value of x after the if-else."

**Real-world analogy:** Two roads merge into one road. A sign at the merge says, "Cars from road A came from city 1; cars from road B came from city 2." Phi records which value came from which road.

**Small example:**

```c
if (cond)
    x = 1;
else
    x = 2;
y = x + 3;
```

SSA:

```text
if cond goto B1 else B2

B1:
  x1 = 1
  goto B3

B2:
  x2 = 2
  goto B3

B3:
  x3 = phi(x1 from B1, x2 from B2)
  y1 = x3 + 3
```

**Step-by-step:**
1. Each branch assigns a different SSA version.
2. Control paths join at `B3`.
3. Phi creates a new version representing the value after the join.
4. Later uses read the phi result.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Join point | Block with multiple predecessors | Place where values merge | after if-else | "Where put phi?" |
| Incoming value | Value from a predecessor block | Phi depends on control path | `x1 from B1` | "How phi chooses?" |
| Phi result | New SSA version | Maintains single assignment | `x3` | "Why new name?" |
| Loop phi | Merges initial and updated loop value | Represents loop-carried dependency | `i2 = phi(i0, i1)` | "SSA for loops." |
| Phi lowering | Replace phi with copies | Required before machine code | copies in predecessors | "Does CPU execute phi?" |
| Parallel copy | Phi assignments happen conceptually together | Avoids ordering bugs | swap values | "Why phi lowering is tricky?" |

## 4. Real-World Example

**JIT compiler optimizing a branch:** If one branch sets `type = int` and another sets `type = float`, the JIT needs a merged representation after the branch. Phi-like nodes help the optimizer reason about the possible value and type after control flow joins.

## 5. Diagrams / Mental Models

```text
        B0
      if cond
      /     \
     v       v
 B1: x1=1  B2: x2=2
     \       /
      v     v
        B3
   x3 = phi(B1:x1, B2:x2)
```

### Loop Phi

```text
i0 = 0
goto Header

Header:
  i1 = phi(i0 from Entry, i2 from Body)
  if i1 < n goto Body else Exit

Body:
  i2 = i1 + 1
  goto Header
```

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is a phi function? | SSA merge operation at CFG joins. | Selects by predecessor | Calling it normal function |
| Why is phi needed? | To merge multiple reaching definitions while preserving single assignment. | Branch joins | Reusing same `x` |
| Where are phi nodes placed? | At blocks where different definitions can reach from different predecessors. | Join points/dominance frontier | Putting after every assignment |
| Does phi execute at runtime? | Not as a normal function; it is a compiler IR construct. | Lowered later | Saying CPU calls phi |
| What does `x3=phi(x1,x2)` mean? | `x3` is `x1` or `x2` depending on incoming control edge. | Edge-specific values | Saying it picks randomly |
| Why phi in loops? | To merge initial value and updated value from previous iteration. | Loop-carried value | Forgetting initial value |
| How lower phi? | Insert copies in predecessor blocks, then remove phi. | SSA destruction | Leaving phi in assembly |
| Can phi have more than two inputs? | Yes, one per predecessor edge. | Multi-way joins | Assuming only if-else |
| Is phi same as ternary operator? | No. Ternary is source expression; phi is IR merge based on predecessor block. | Control-flow merge | Treating as `cond ? a : b` always |
| What if variable assigned only one branch? | Phi may merge new value with old incoming value. | Partial assignment | Ignoring old value |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why are phi operands associated with predecessor edges? | The selected value depends on the block from which control arrived, not on evaluating a runtime condition inside the phi itself. |
| Why are phi nodes placed at block beginning? | They define values available to all instructions in the joined block and conceptually happen before normal instructions in that block. |
| What problem happens when lowering multiple phi nodes? | Phi nodes act like parallel copies. Naively ordering copies can overwrite values too early, especially in swaps. |
| How do phi nodes help sparse dataflow analysis? | SSA def-use chains allow analyses to follow value uses directly instead of scanning all assignments to a variable. |
| Are phi functions needed without branches? | Usually no. Straight-line code can be converted to SSA by simple renaming. Phi is needed when control-flow paths merge. |

## 8. Comparison Tables

### Phi Function vs Normal Assignment

| Feature | Phi Function | Normal Assignment |
|---|---|---|
| Appears in | SSA IR | Source/IR |
| Meaning | Merge incoming values | Compute/copy value |
| Depends on | Predecessor edge | Operand evaluation |
| Runtime function? | No | Yes, assignment action exists |
| Lowered before machine code | Yes | Usually directly mapped |

### Phi vs Ternary Operator

| Feature | Phi | Ternary |
|---|---|---|
| Level | Compiler IR | Source expression |
| Selection basis | Incoming CFG edge | Boolean condition |
| Location | Basic block entry | Expression position |
| Used for | SSA merging | Programmer expression |

## 9. Common Mistakes

- Saying phi is a real function call.
- Forgetting one phi input per predecessor.
- Placing phi in non-join blocks unnecessarily.
- Ignoring loop phi nodes.
- Thinking phi evaluates all alternatives like normal expressions.
- Lowering phi with copies in the wrong block.

## 10. Edge Cases / Special Cases

- A block with three predecessors may need a phi with three inputs.
- Loops require phi for induction variables.
- If a variable is not assigned on one branch, phi must use the old version for that branch.
- Critical edges may need splitting before phi lowering.
- Multiple phi nodes in one block conceptually execute in parallel.

## 11. How to Explain in Interview

"A phi function is an SSA merge operation placed at a CFG join. It creates a new variable version by selecting the value that came from the actually executed predecessor block. It keeps SSA valid when branches or loops merge different definitions."

## 12. Quick Revision Notes

- Phi appears at CFG joins.
- One input per predecessor.
- Used in SSA.
- Not a runtime function call.
- Loops need phi for variables updated each iteration.
- Interview trap: phi selection is based on control-flow edge.

## 13. Practice Tasks

1. Add phi nodes to an if-else SSA example.
2. Add phi nodes to a while-loop counter.
3. Lower a simple phi into predecessor copies.
4. Explain why phi is not the same as ternary.
5. Identify missing phi nodes in a CFG.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | SSA operation that merges values at control-flow joins |
| Why it matters | Makes SSA possible for branches and loops |
| Most asked questions | What is phi, where placed, how lowered |
| Common comparisons | Phi vs assignment, phi vs ternary |
| One-line answer | Phi picks the correct SSA value based on which CFG edge entered the block. |

---

# 11. Lowering High-Level Constructs

## 1. Overview

**Definition:** **Lowering** is the process of transforming high-level language constructs into simpler, lower-level IR constructs.

Examples:
- `for` loops become labels, condition checks, and jumps.
- `switch` statements become jump tables or chains of branches.
- Object method calls become function calls with explicit receiver arguments.
- Array access becomes address arithmetic plus load/store.

**Why it matters:**
- Machine code does not directly understand high-level constructs.
- Optimizers often work better on simpler IR.
- Lowering creates a bridge from source language features to target operations.
- It reveals the real runtime cost of high-level syntax.

**Where it is used in real systems:**
- C compilers lower loops, arrays, structs, and function calls.
- Java compilers lower enhanced `for` loops and lambdas.
- JavaScript engines lower dynamic operations into simpler IR with checks.
- Database engines lower SQL into relational algebra and physical plans.
- Backend frameworks lower high-level queries into SQL or execution plans.

**Why interviewers ask about it:** Lowering tests whether you understand what high-level constructs mean operationally. It is also useful for OA-style tracing and systems interviews.

## 2. Core Idea

Lowering removes syntactic convenience and exposes primitive operations.

**Intuition:** High-level code is nice for programmers; low-level IR is nice for compilers.

**Real-world analogy:** A restaurant order says "make a sandwich." The kitchen checklist lowers it into slice bread, add filling, toast, pack, serve.

**Small example:**

High-level:

```c
for (i = 0; i < n; i++) {
    sum += a[i];
}
```

Lowered TAC-like IR:

```text
i = 0
L1:
if i >= n goto L2
t1 = i * 4
t2 = a[t1]
sum = sum + t2
i = i + 1
goto L1
L2:
```

**Step-by-step:**
1. Initialization happens once.
2. Loop header checks condition.
3. False condition exits.
4. Body executes.
5. Update runs.
6. Jump returns to condition.

## 3. Important Subtopics

| Subtopic | What It Means | Why It Matters | Example | Common Interview Angle |
|---|---|---|---|---|
| Loop lowering | Convert loops to labels and jumps | Exposes control flow | `while`, `for` | "Translate loop to TAC." |
| If lowering | Convert conditionals to branches | Builds CFG | true/false labels | "Translate if-else." |
| Short-circuit lowering | Preserve lazy boolean evaluation | Avoid wrong side effects/errors | `a && b` | "Does RHS always evaluate?" |
| Array lowering | Convert index to address arithmetic | Shows memory layout | `base + i * width` | "Translate `a[i]`." |
| Switch lowering | Branch chain or jump table | Performance trade-off | dense cases | "How switch compiled?" |
| Function-call lowering | Make call protocol explicit | Arguments, return value | `param`, `call` | "Translate call." |
| Object lowering | Convert methods/fields to offsets/calls | Runtime layout | `obj.m()` | "How OOP maps lower?" |
| Exception lowering | Add exceptional control paths | Accurate CFG | throw/catch edges | "Why exceptions complicate CFG?" |

## 4. Real-World Example

**Enhanced for loop in Java:**

```java
for (String s : list) {
    print(s);
}
```

is lowered roughly into iterator operations:

```java
Iterator<String> it = list.iterator();
while (it.hasNext()) {
    String s = it.next();
    print(s);
}
```

The programmer sees a clean loop, but the compiler/runtime uses method calls and a normal loop structure.

## 5. Diagrams / Mental Models

### If-Else Lowering

```text
if (cond) S1 else S2

Lowered:

if cond goto Ltrue
goto Lfalse
Ltrue:
  code for S1
  goto Lend
Lfalse:
  code for S2
Lend:
```

### For Loop Lowering

```text
for (init; cond; update) body

Lowered:

init
Lcheck:
  if not cond goto Lend
  body
  update
  goto Lcheck
Lend:
```

### Array Access Lowering

```text
a[i] for int array, width = 4

offset = i * 4
address = base(a) + offset
value = *address
```

## 6. Common Interview Questions

| Question | Clear Answer | Expected Key Points | Common Mistakes |
|---|---|---|---|
| What is lowering? | Transforming high-level constructs into simpler lower-level IR. | Desugaring, explicit control/data ops | Saying it is optimization only |
| Lower a for loop. | Init, condition label, body, update, back jump, exit. | Correct order | Putting update before body |
| Lower an if-else. | Conditional jump to true/false labels, join label. | Branch and join | Missing end jump |
| Why lower constructs? | Target machines and lower IR do not directly support high-level syntax. | Simpler codegen/optimization | Saying only makes code longer |
| How lower array access? | Compute offset using index and element width, then load/store. | Base + index * width | Forgetting element size |
| How lower short-circuit AND? | If left is false, skip right. | Preserve semantics | Evaluating both sides always |
| How lower switch? | Chain of comparisons or jump table depending case density. | Trade-off | Assuming always if-else chain |
| How lower function calls? | Evaluate args, pass params, call function, handle return. | Order and convention | Ignoring side effects in args |
| Does lowering change meaning? | It should preserve semantics while changing representation. | Semantic equivalence | Saying compiler may change behavior |
| Is lowering same as optimization? | No. Lowering simplifies representation; optimization improves performance/size. | Different goals | Mixing terms |

## 7. Deep-Dive Questions

| Question | Answer |
|---|---|
| Why must short-circuit lowering preserve evaluation order? | Because the right side may have side effects or may be unsafe to evaluate, such as `p != NULL && p->x > 0`. |
| How can switch lowering choose between branch chain and jump table? | Dense integer cases are good for jump tables. Sparse cases may be better as comparison chains or binary search. |
| How are objects lowered? | Field access becomes offset-based memory access, and method calls may become function calls with an explicit receiver pointer and virtual dispatch if needed. |
| Why can lowering too early hurt optimization? | Some high-level information may be lost. For example, array bounds, object structure, or loop intent may help early optimizations. |
| How do exceptions affect lowering? | Operations that can throw need edges to handler blocks, so simple straight-line code may gain hidden control-flow paths. |

## 8. Comparison Tables

### Desugaring vs Lowering vs Optimization

| Feature | Desugaring | Lowering | Optimization |
|---|---|---|---|
| Main goal | Replace syntax sugar | Move to simpler IR level | Improve performance/size |
| Meaning preserved | Yes | Yes | Yes, under language rules |
| Example | enhanced for to iterator loop | loop to labels/gotos | remove redundant computation |
| Level | Source/high-level IR | IR pipeline | Any IR level |

### Branch Chain vs Jump Table for Switch

| Feature | Branch Chain | Jump Table |
|---|---|---|
| Best for | Sparse cases | Dense integer cases |
| Time | O(number of cases) | O(1) dispatch after bounds check |
| Space | Low | Higher |
| Example | cases 1, 100, 10000 | cases 1, 2, 3, 4 |

## 9. Common Mistakes

- Treating lowering as optional decoration.
- Forgetting to preserve side-effect order.
- Evaluating both sides of short-circuit expressions.
- Forgetting loop update position.
- Forgetting array element width.
- Thinking `switch` is always lowered one way.
- Confusing lowering with optimization.

## 10. Edge Cases / Special Cases

- `continue` in a `for` loop jumps to update, not directly to condition.
- `break` jumps to loop/switch exit.
- Short-circuit boolean lowering must avoid evaluating skipped expressions.
- Function argument evaluation order depends on language rules.
- Multidimensional array lowering depends on row-major vs column-major layout.
- Virtual method calls may require vtable lookup.
- Exceptions add non-obvious control-flow edges.

## 11. How to Explain in Interview

"Lowering converts high-level constructs into simpler IR while preserving meaning. For example, a `for` loop becomes initialization, a condition label, conditional jump, body, update, and back jump. This makes optimization and machine-code generation easier."

## 12. Quick Revision Notes

- Lowering = high-level construct to lower-level IR.
- It preserves semantics.
- Loops become labels and jumps.
- Arrays become address arithmetic.
- Short-circuit logic becomes branches.
- Switch may become branch chain or jump table.
- Interview trap: lowering is not the same as optimization.

## 13. Practice Tasks

1. Lower a `for` loop into TAC.
2. Lower `if (a && b)` preserving short-circuit behavior.
3. Lower `a[i][j]` for row-major layout.
4. Lower a `switch` with dense cases into a jump table idea.
5. Explain how a method call `obj.f(x)` can become a lower-level function call.

## 14. Final Cheat Sheet

| Item | Notes |
|---|---|
| Core definition | Converting high-level constructs into simpler lower-level IR |
| Why it matters | Makes control flow, memory access, and calls explicit |
| Most asked questions | Lower for/while/if/switch/array access |
| Common comparisons | Desugaring vs lowering vs optimization, branch chain vs jump table |
| One-line answer | Lowering rewrites programmer-friendly constructs into compiler-friendly primitive operations. |

---

# Final Compact Cheat Sheet: Intermediate Code Generation

| Topic | Core Definition | Must-Remember Interview Point |
|---|---|---|
| Intermediate Representation | Compiler internal program form | Enables optimization and target independence |
| Abstract Syntax Tree | Simplified tree of source structure | AST is not the same as parse tree |
| Three-Address Code | Simple IR with at most two operands and one result | Complex expressions become temporaries |
| Quadruples | TAC stored as `(op, arg1, arg2, result)` | Explicit result makes code movement easier |
| Triples | TAC stored as `(op, arg1, arg2)` | Result is instruction position |
| Control-Flow Graph | Graph of possible execution paths | Nodes are usually basic blocks |
| Basic Blocks | Maximal straight-line code sequences | Leaders define block boundaries |
| SSA | Each variable version assigned once | Phi functions merge versions |
| DAG Expressions | Shared graph for expression dependencies | Helps common subexpression elimination |
| Phi Functions | SSA merge at CFG joins | Selects value based on predecessor edge |
| Lowering | Converts high-level constructs to simpler IR | Must preserve semantics and evaluation order |

## Most Asked Interview Tasks

1. Convert an arithmetic expression into TAC.
2. Represent TAC as quadruples and triples.
3. Identify leaders and form basic blocks.
4. Draw a CFG for if-else and loops.
5. Convert simple code into SSA form.
6. Add phi functions at branch joins.
7. Draw a DAG for repeated expressions.
8. Lower `for`, `while`, `if`, `switch`, and array access.
9. Compare AST, TAC, CFG, DAG, and SSA.
10. Explain why IR is needed instead of direct machine-code generation.

## One-Line Master Interview Answer

"Intermediate code generation converts a semantically checked program into compiler-friendly IR such as AST, TAC, CFG, SSA, or DAG forms so the compiler can analyze, optimize, and finally generate efficient target code."
