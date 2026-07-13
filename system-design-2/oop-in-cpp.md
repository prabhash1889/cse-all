# OOP in C++ — Constructors, Destructors, Copy/Move Semantics, Virtual Functions, vtable/vptr

---

# Constructors

## 1. Overview

A **constructor** is a special member function automatically called when an object is created. It initializes the object's data members and acquires any resources the object needs.

- **Definition**: A class member function with the same name as the class, no return type, called automatically on object creation.
- **Why it matters**: Without constructors, every object would contain garbage data until explicitly initialized. Constructors guarantee that objects start in a valid, consistent state.
- **Where used**: Every C++ class. Streams (`std::ifstream` opens a file in its constructor), containers (`std::vector` allocates memory), smart pointers (`std::unique_ptr` takes ownership), GUI widgets, database connections — any resource that needs setup.
- **Why interviewers ask**: Constructors test understanding of object lifecycle, initialization order, memory management, and C++'s philosophy of "resource acquisition is initialization" (RAII).

## 2. Core Idea

**Intuition**: A constructor is like a birth certificate — it runs the moment an object is "born" and ensures everything is ready before the object is used.

**Real-world analogy**: Walking into a hotel room. The room is already cleaned, beds made, towels placed. The hotel doesn't say "here's an empty room — go set it up yourself." The constructor is the housekeeping staff that prepares the room before you check in.

**Small example**:

```cpp
class BankAccount {
private:
    std::string owner;
    double balance;
public:
    // Constructor — runs automatically when object is created
    BankAccount(const std::string& name, double initialDeposit)
        : owner(name), balance(initialDeposit) {
        if (balance < 0) {
            throw std::invalid_argument("Cannot open account with negative balance");
        }
    }
    
    double getBalance() const { return balance; }
};
```

**Step-by-step**:
1. You write `BankAccount acc("Alice", 1000.0);`
2. Compiler finds the matching constructor `BankAccount(const std::string&, double)`
3. Member initializer list runs: `owner` is initialized with `name`, `balance` with `initialDeposit`
4. Constructor body executes: validates that balance isn't negative
5. Object `acc` is now fully usable

## 3. Important Subtopics

### Default Constructor

| Aspect | Detail |
|--------|--------|
| **What it means** | A constructor that takes no arguments (or all arguments have default values). If you write no constructor at all, the compiler synthesizes one that default-initializes members. |
| **Why it matters** | Needed for creating arrays of objects, using STL containers (`std::vector<T>` requires `T` to be default-constructible for some operations), and deserialization patterns. |
| **Example** | `class Point { int x, y; public: Point() : x(0), y(0) {} };` |
| **Interview angle** | "When does the compiler generate a default constructor?" — Only if the class has no user-defined constructors AND all members are default-constructible. Tricky: if you define ANY constructor, the compiler-supplied default is NOT generated. |

### Parameterized Constructor

| Aspect | Detail |
|--------|--------|
| **What it means** | Constructor that takes arguments to initialize the object with specific values. |
| **Why it matters** | Allows creating objects in different states, not just default-initialized. Enables RAII — pass resources at construction time. |
| **Example** | `std::vector<int> v(10, 5);` — creates a vector of 10 elements, each initialized to 5. |
| **Interview angle** | Distinguish between `MyClass obj(5);` (direct initialization) and `MyClass obj = 5;` (copy initialization, may involve a temporary). Use `explicit` to prevent implicit conversions. |

### Constructor Overloading

Multiple constructors with different parameter lists, like function overloading. Compiler picks the best match.

### Member Initializer List

```cpp
class Widget {
    const int id;        // const — must be initialized
    int& ref;            // reference — must be initialized
    std::string name;    // expensive to default-construct then assign
public:
    // RIGHT: member initializer list
    Widget(int i, int& r, const std::string& n) : id(i), ref(r), name(n) {}
    
    // WRONG: assignment inside body (won't even compile for const/ref)
    // Widget(int i, int& r, const std::string& n) { id = i; ref = r; name = n; }
};
```

- **Must-use**: `const` members, reference members, base classes, members without default constructors.
- **Performance**: Initializes directly instead of default-constructing then assigning.
- **Order**: Members are initialized in **declaration order** in the class, NOT the order in the initializer list.

### `explicit` Constructor

| Without `explicit` | With `explicit` |
|---|---|
| `MyClass obj = 42;` compiles (implicit conversion) | `MyClass obj = 42;` — compilation error |
| `void f(MyClass m); f(42);` compiles | `f(42);` — compilation error |
| Can cause silent, surprising conversions | Prevents accidental implicit conversions |

**Interview rule of thumb**: Mark single-argument constructors as `explicit` unless you specifically want implicit conversion (rare).

## 4. Real-World Example

**Database Connection Pool** — constructor establishes connections:

```cpp
class ConnectionPool {
    std::vector<sql::Connection*> connections;
    std::string host;
    int port;
public:
    // Constructor connects to DB and creates a pool
    ConnectionPool(const std::string& dbHost, int dbPort, int poolSize)
        : host(dbHost), port(dbPort) {
        for (int i = 0; i < poolSize; ++i) {
            auto* conn = new sql::Connection(host, port);
            conn->authenticate("user", "password");
            connections.push_back(conn);
        }
        if (connections.empty()) {
            throw std::runtime_error("Failed to create connection pool");
        }
    }
    // ... acquire(), release() methods
};
```

## 5. Diagrams / Mental Models

```
Object lifecycle timeline:

    Memory allocated ──> Constructor runs ──> Object ready for use
          │                     │
          │  (stack/heap)       │  (initialization + body)
          ▼                     ▼
    [garbage data]         [valid state]
```

```
Constructor selection (overload resolution):

    BankAccount a("Alice", 100);   ──> calls BankAccount(string, double)
    BankAccount b;                  ──> calls BankAccount()  [if defined]
    BankAccount c = a;              ──> calls COPY constructor
    BankAccount d(std::move(a));    ──> calls MOVE constructor
```

## 6. Common Interview Questions

**Q1: What is a constructor? Can it be virtual?**

**Answer**: A constructor is a special member function that initializes objects. No, constructors cannot be virtual. The vtable doesn't exist until the constructor completes, so virtual dispatch during construction doesn't work (it dispatches to the currently-constructing class, not the most-derived class).

- **Key point**: Virtual mechanism requires a valid vptr, which is set up during construction.
- **Common mistake**: Saying "yes, you can make a constructor virtual" — you cannot. `virtual` keyword on constructor causes compilation error.

---

**Q2: Can a constructor be private?**

**Answer**: Yes. Private constructors are used to prevent direct instantiation. Used in:
- Singleton pattern
- Factory methods
- Named constructor idiom

```cpp
class Singleton {
    Singleton() {}  // private
public:
    static Singleton& getInstance() {
        static Singleton instance;
        return instance;
    }
};
```

- **Key point**: Private constructors don't prevent creation of static/global objects within the class.
- **Common mistake**: Thinking objects with private constructors can never be created — they can, but only by friends or member functions.

---

**Q3: What is the member initializer list? Why use it?**

**Answer**: The member initializer list is the `: member1(val1), member2(val2)` syntax after the constructor parameter list. Use it because:
1. **Required** for `const`, reference members, and members without default constructors
2. **More efficient** — direct initialization vs. default-construct then assign
3. **More explicit** — shows exactly how each member is initialized

- **Key point**: Initialization order follows **declaration order**, not initializer list order.
- **Common mistake**: Putting initializers in a different order than declarations, causing subtle bugs with interdependent members.

---

**Q4: What happens if you don't define any constructor?**

**Answer**: The compiler generates a default constructor — but only if the class has no user-declared constructors of any kind. The compiler-generated constructor:
- Default-initializes members with their own default constructors
- Leaves built-in types (int, char*, etc.) uninitialized (garbage)
- Does nothing (empty body)

```cpp
class A { int x; std::string s; };
// Compiler generates: A() : s() {}   // x is UNINITIALIZED
```

- **Key point**: Built-in types are NOT zero-initialized unless the object has static/thread-local storage duration.
- **Common mistake**: Assuming compiler-generated default constructor zero-initializes everything.

---

**Q5: What is an `explicit` constructor? When would you use it?**

**Answer**: Prevents the compiler from using that constructor for implicit conversions. Use it for any single-argument constructor (or multi-arg with all-but-one defaulted) unless implicit conversion is desired.

```cpp
class String {
public:
    explicit String(int n); // allocates n bytes — should NOT convert int->String implicitly
};

String s = 5;   // ERROR with explicit
String s(5);    // OK — explicit call
```

- **Key point**: `explicit` prevents surprising conversions in function calls, operator overloads.
- **Common mistake**: Forgetting `explicit` leads to bugs like `if (str == 5)` compiling when you meant `if (str == "5")`.

---

**Q6: Explain the difference between `MyClass obj(10);` and `MyClass obj = 10;`**

**Answer**: 
- `MyClass obj(10);` — **direct initialization**. Calls the constructor `MyClass(int)` directly.
- `MyClass obj = 10;` — **copy initialization**. If the constructor is not `explicit`, creates a temporary `MyClass(10)` then copy-constructs `obj` from it. In practice, copy elision (RVO) typically eliminates the temporary, but semantics differ: copy initialization requires an accessible copy/move constructor.

- **Key point**: Copy initialization doesn't work with `explicit` constructors. Direct initialization does.
- **Common mistake**: Believing they are identical — they are not in all cases (e.g., with `explicit`, with move-only types).

---

**Q7: What is a delegating constructor? (C++11)**

**Answer**: A constructor that calls another constructor in the same class to avoid code duplication.

```cpp
class Employee {
    std::string name;
    int id;
public:
    Employee() : Employee("Unknown", 0) {}     // delegates
    Employee(const std::string& n, int i) : name(n), id(i) {}
};
```

- **Key point**: Delegation reduces duplication. The delegated-to constructor runs first, then the delegating constructor's body.
- **Common mistake**: Circular delegation (A delegates to B, B delegates to A) — compile error.

---

**Q8: What are conversion constructors?**

**Answer**: A non-`explicit` single-argument constructor that allows implicit type conversion.

```cpp
class Number {
    int value;
public:
    Number(int v) : value(v) {}  // conversion constructor: int -> Number
};

void print(Number n);
print(42);  // works — implicitly converts 42 to Number
```

- **Key point**: Conversion constructors are useful for wrapper types but dangerous if unintentional.
- **Common mistake**: Overlooking implicit conversions that lead to ambiguous overload resolution or silent bugs.

---

**Q9: What is initialization order in a constructor?**

**Answer**: Initialization proceeds in this order:
1. Virtual base classes (depth-first, left-to-right)
2. Non-virtual base classes (declaration order)
3. Member objects (declaration order in the class)
4. Constructor body executes

Order in the member initializer list is **irrelevant** — declaration order always wins.

- **Key point**: Because declaration order rules, initializing `y` with `x` where `x` is declared after `y` causes use-before-initialization.
- **Common mistake**: "My initializer list has `x(y), y(x)` so both get the right values" — false, order follows declaration.

---

**Q10: Can a constructor throw an exception? What happens to the object?**

**Answer**: Yes. If a constructor throws:
- The object is considered not constructed
- The destructor is **NOT called** (object never fully existed)
- Any fully-constructed subobjects/base classes ARE destroyed (stack unwinding of members)
- Memory is deallocated

```cpp
class A {
    std::string s;
    int* p;
public:
    A() : s("hello"), p(new int[100]) {
        throw std::runtime_error("oops");  // p leaks unless s throws first
    }
};
// If s is initialized before p, p leaks when constructor throws
```

- **Key point**: This is why RAII is critical — if members manage their own resources, constructor exceptions don't leak.
- **Common mistake**: Thinking the destructor runs — it doesn't, because the object was never fully constructed.

## 7. Deep-Dive Questions

**Q1: How does the compiler decide which constructor to call when there are multiple viable candidates?**

**Answer**: The compiler performs **overload resolution**:
1. **Candidate functions**: All constructors with the right number of parameters (accounting for defaults)
2. **Viable functions**: Those where implicit conversion sequences exist for each argument
3. **Best match**: Ranked by implicit conversion sequences (exact match > promotion > conversion > user-defined conversion)
4. **Ambiguity**: If two constructors tie, compilation fails

```cpp
class Foo {
    Foo(int);       // #1
    Foo(double);    // #2
    Foo(short);     // #3
};
Foo f(42);  // Calls #1 (int) — exact match beats promotion (short) or conversion (double)
```

**Key insight**: This gets complex with templates (`std::vector`'s `size_type` vs `int`), and with `std::initializer_list` which takes priority in some contexts.

---

**Q2: What is the "most vexing parse" in C++?**

**Answer**: A situation where the compiler interprets what looks like object construction as a function declaration.

```cpp
Widget w(10);  // OK — constructs a Widget
Widget w();    // OOPS — declares a function named w returning Widget
Widget w(int(10));  // OOPS — function taking int parameter

// Fix using brace initialization (C++11):
Widget w{};       // OK — default constructs
Widget w{10};     // OK — calls Widget(int)
```

**Key insight**: "Anything that can be parsed as a function declaration will be." Use uniform initialization `{}` to avoid it.

---

**Q3: How does `std::optional` or `std::variant` handle construction from multiple types without ambiguity?**

**Answer**: These types use careful SFINAE/`enable_if` constraints to disqualify bad overloads. `std::optional` uses `std::is_constructible`, `std::is_convertible`, and explicit tags like `std::in_place_t` to disambiguate.

```cpp
std::optional<int> o1(42);      // OK
std::optional<int> o2 = 42;     // OK
std::optional<int> o3(std::nullopt);  // constructs empty optional
// Without constraints, `std::optional<int> o('x');` correctly rejects
```

**Key insight**: This is an advanced template metaprogramming pattern — controlling which constructors participate in overload resolution via SFINAE.

---

**Q4: What is the interaction between inheritance and constructors? How is the base class constructor called?**

**Answer**: Derived class constructors must call a base class constructor (implicitly the default, or explicitly). Initialization order: base class constructor runs first, then derived member initializers, then derived constructor body.

```cpp
class Base {
public:
    Base(int x) { cout << "Base(" << x << ")\n"; }
};

class Derived : public Base {
public:
    // MUST call Base constructor explicitly since Base has no default
    Derived(int a, int b) : Base(a), something(b) {}
    int something;
};

// C++11: Inheriting constructors
class Derived2 : public Base {
    using Base::Base;  // inherits Base(int)
};
```

**Key insight**: Base class constructors are NOT inherited by default unless you use `using Base::Base;`. Inherited constructors have the same signature but can have additional derived-class defaults.

---

**Q5: How do constructors behave with virtual inheritance? How many times is the virtual base constructed?**

**Answer**: In virtual inheritance, the most-derived class is responsible for constructing the virtual base. The virtual base is constructed **only once**, before any other bases, even if multiple intermediate classes would otherwise call its constructor.

```cpp
struct Animal { Animal(const char*); };
struct Mammal : virtual Animal { Mammal() : Animal("Mammal-default") {} };
struct Bird : virtual Animal { Bird() : Animal("Bird-default") {} };
struct Bat : Mammal, Bird {
    Bat() : Animal("Bat-constructs-it"), Mammal(), Bird() {}
    // Animal constructed ONCE with "Bat-constructs-it"
    // Mammal and Bird's Animal() calls are ignored
};
```

**Key insight**: The intermediate class initializers for the virtual base are **suppressed** when the most-derived class takes over. This is a common interview trap — "how many times is the virtual base constructed?"

## 8. Comparison Tables

### Default vs Parameterized vs Copy vs Move Constructor

| Feature | Default | Parameterized | Copy | Move |
|---------|---------|---------------|------|------|
| Signature | `T()` | `T(args...)` | `T(const T&)` | `T(T&&)` |
| Auto-generated? | Yes (if no other ctors) | No | Yes (if no move ctor/assign) | Yes (if no copy/assign/dtor) |
| Used when | `T obj;` | `T obj(args);` | `T obj = other;` | `T obj = std::move(other);` |
| Deep copy? | N/A | N/A | Yes | No (steals resources) |
| Can be `explicit`? | Yes | Yes | No (usually) | No (usually) |

### Direct Initialization vs Copy Initialization

| Aspect | Direct Initialization | Copy Initialization |
|--------|----------------------|---------------------|
| Syntax | `T obj(arg);` | `T obj = arg;` |
| Use with `explicit` | Yes | No |
| May create temporary | No | Yes (potentially) |
| Elision possible | N/A | Yes (RVO) |
| Copy/move ctor needed | No | Yes (accessibility) |

## 9. Common Mistakes

1. **Not initializing built-in types**: `class A { int x; }; A a;` — `a.x` is garbage, not 0.
2. **Forgetting `explicit`**: Causes accidental implicit conversions — `str == 42` compiles if `std::string` has a non-explicit `string(int)` constructor.
3. **Assuming initializer list order matters**: Members initialize in declaration order, not list order.
4. **Calling virtual functions in constructors**: They don't dispatch to derived class overrides — the derived part doesn't exist yet.
5. **Forgetting to initialize reference/const members**: Must use initializer list; can't assign in body.
6. **Constructor ambiguity**: Having both `T(int)` and `T(short)` can cause surprising overload resolution.
7. **Using `explicit` on multi-arg constructors**: Redundant (though C++20 makes it useful for aggregate init).
8. **Circular constructor delegation**: `A() : A(0) {} A(int) : A() {}` — compiler error.
9. **Ignoring the member-destruction order**: Members destroyed in reverse declaration order (which is correct if init was in declaration order).
10. **Assuming `T obj();` creates an object**: It declares a function — use `T obj{};` to be safe.

## 10. Edge Cases / Special Cases

- **Aggregate initialization**: Classes with no user-declared constructors can be initialized with braces: `Point p = {1, 2};` (C-style). C++20 adds designated initializers: `Point p = {.x = 1, .y = 2};`
- **Zero-initialization**: Static and thread-local objects are zero-initialized before constructor runs: `static int x;` — `x` is 0.
- **Value-initialization**: `T()` or `T{}` — if `T` has a default constructor, calls it; otherwise zero-initializes.
- **`= default` vs `= delete`**: `MyClass() = default;` — use compiler version; `MyClass() = delete;` — prevent usage.
- **GCC `-Weffc++`**: Warns if member pointers aren't initialized — signals potential UB on dereference.
- **Throwing from initializer list**: Exceptions during member initialization/construction follow destruction of fully-constructed subobjects.
- **User-defined types as members**: Each member's constructor is called before the enclosing class's constructor body.

## 11. How to Explain in Interview

> "A constructor is a special member function that initializes an object when it's created. It guarantees the object starts in a valid state. Constructors share the class name, have no return type, and are automatically invoked.
>
> The key design choice is whether to use the member initializer list — which I always prefer because it's required for `const` and reference members, and avoids the performance hit of default-construct-then-assign. I also mark single-argument constructors as `explicit` to prevent surprising implicit conversions — this is a common source of bugs, especially in operator overloads.
>
> One important detail: if you define any constructor, the compiler stops generating the default constructor. So if you need both, you must explicitly write or `= default` the default one. Also, virtual function calls in constructors don't work as expected — they dispatch to the currently-constructing class, not the most-derived one, because the vtable for the derived part hasn't been set up yet."

## 12. Quick Revision Notes

| Concept | Key Point |
|---------|-----------|
| Constructor purpose | Initialize object to valid state |
| Default ctor auto-gen | Only if no user-declared constructors |
| Initializer list | Always prefer; required for const/ref |
| Init order | Declaration order in class |
| `explicit` | Prevent implicit conversion; use for single-arg ctors |
| Virtual in ctor | Doesn't work — derived overrides not reached |
| Private ctor | Singleton, factory pattern |
| Throwing ctor | Destructor NOT called |
| `= delete` | Prevent construction |
| `= default` | Explicitly request compiler version |

## 13. Practice Tasks

1. Write a `SmartArray` class with a constructor that allocates memory on the heap. Ensure proper initialization.
2. Create a class with a `const` member and a reference member — verify compilation fails without initializer list.
3. Write a class hierarchy where the base constructor calls a virtual function. Observe the behavior.
4. Create a class that tracks how many objects are alive. Use a static counter incremented in constructors.
5. Write a class with both `explicit` and non-`explicit` single-argument constructors. Test implicit conversion scenarios.
6. Implement a `Logger` class where the constructor opens a file. What happens if the file can't be opened?
7. Create two constructors that are ambiguous with certain arguments. Diagnose the error message.
8. Write a delegating constructor chain of depth 3. Verify all base initializations complete before the outermost body runs.
9. Implement a `NamedParameter` class that uses the named constructor idiom (private constructor + static factory method).
10. Create a `SafePointer` that only allows construction through a static `create()` function.

## 14. Final Cheat Sheet

```
CONSTRUCTOR — Special member, same name as class, no return type, auto-called on creation.

Why:  Object initialization guarantee, RAII foundation.
Key:  Always use initializer list. Mark single-arg ctors explicit.
Init order: Base classes → members (declaration order) → body.
Gotchas: Built-in types NOT zero-init. Virtual funcs don't dispatch to derived.
         Defining ANY ctor suppresses default ctor.
         If constructor throws, destructor is NOT called.

Most asked:
  Q: Can constructors be virtual?       → No (vtable not ready).
  Q: Default ctor generated when?       → If no user-declared ctors.
  Q: Why use initializer list?          → Required for const/ref, more efficient.
  Q: explicit keyword?                  → Prevents implicit conversions.
  Q: Initialization order?              → Declaration order, NOT list order.
```

---

# Destructors

## 1. Overview

A **destructor** is a special member function automatically called when an object is destroyed. It releases the resources the object acquired during its lifetime.

- **Definition**: A class member function with the class name prefixed by `~`, no return type, no parameters, cannot be overloaded (only one destructor per class).
- **Why it matters**: Destructors implement the "D" in RAII (Resource Acquisition Is Initialization) — resources acquired in the constructor are released in the destructor without manual cleanup calls. This makes code exception-safe.
- **Where used**: Every C++ class that manages resources. `std::vector` deallocates memory, `std::fstream` closes files, `std::unique_ptr` calls `delete`, `std::mutex` unlocks, database connections close sockets.
- **Why interviewers ask**: Destructors test understanding of resource management, exception safety, virtual destructor discipline, RAII philosophy, and the relationship between object lifetime and memory management.

## 2. Core Idea

**Intuition**: A destructor is like a hotel checkout — when you leave, the room is cleaned, towels collected, keys returned. You don't want to leave trash behind.

**Real-world analogy**: Borrowing a library book. When you return it (destructor runs), the librarian checks it in, clears your record, and puts it back on the shelf. If you just threw the book away (forgot to call destructor), the library's tracking system is corrupted.

**Small example**:

```cpp
class FileHandler {
    FILE* file;
public:
    FileHandler(const char* filename) : file(fopen(filename, "r")) {
        if (!file) throw std::runtime_error("Failed to open file");
    }
    
    ~FileHandler() {
        if (file) {
            fclose(file);     // ← Destructor ensures resource is released
            file = nullptr;
        }
    }
    
    // ... read methods
};
```

**Step-by-step**:
1. Object goes out of scope / `delete` is called / exception unwinds through scope
2. Compiler emits destructor call
3. Destructor body executes: closes file, frees memory, etc.
4. Member objects' destructors run in reverse declaration order
5. Base class destructor runs
6. Memory is deallocated

## 3. Important Subtopics

### Virtual Destructor

| Aspect | Detail |
|--------|--------|
| **What it means** | A destructor declared `virtual` in a base class. Ensures derived class destructor is called when deleting through a base pointer. |
| **Why it matters** | Without a virtual destructor, `Base* p = new Derived(); delete p;` invokes **undefined behavior** — only `~Base()` runs, resources in `Derived` leak. |
| **Example** | `class Base { public: virtual ~Base() {} }; class Derived : public Base { int* arr; public: ~Derived() { delete[] arr; } };` |
| **Interview angle** | "Always make destructors virtual in base classes" — Jeff Meyers (Effective C++). Any class with virtual functions should have a virtual destructor. |

### Pure Virtual Destructor

```cpp
class AbstractBase {
public:
    virtual ~AbstractBase() = 0;  // pure virtual destructor
};

AbstractBase::~AbstractBase() {}  // MUST provide a body
```

- Despite being pure virtual, must have a **body** because derived destructors call it during unwinding.
- Makes the class abstract (can't instantiate) while still providing common cleanup.

### Compiler-Generated Destructor

- If you don't write one, the compiler generates a trivial destructor that calls member destructors.
- If the class manages raw resources (new/delete, fopen/fclose, malloc/free), **you must write your own** or use RAII wrappers.

### Destructor and Exception Handling

- Destructors should **never throw**. If a destructor throws during stack unwinding (due to another exception), `std::terminate()` is called.
- If cleanup might throw, catch and swallow or log.

```cpp
~DatabaseConnection() {
    try {
        disconnect();  // might throw
    } catch (...) {
        // Log error, but don't rethrow
    }
}
```

### Destructor Order

**Reverse construction order**:
1. Destructor body of most-derived class
2. Member destructors in reverse declaration order
3. Base class destructor (most-derived base last)

## 4. Real-World Example

**Database Connection Manager** — destructor ensures cleanup even on error:

```cpp
class DatabaseManager {
    sql::Connection* conn;
    std::vector<sql::Statement*> statements;
public:
    DatabaseManager(const std::string& connStr) 
        : conn(new sql::Connection(connStr)) {}
    
    ~DatabaseManager() {
        // Clean up in reverse order: statements first, then connection
        for (auto* stmt : statements) {
            try { delete stmt; } catch (...) { /* log */ }
        }
        statements.clear();
        
        try { 
            if (conn) {
                conn->disconnect();
                delete conn;
            }
        } catch (...) { /* log — never throw from destructor */ }
    }
    
    sql::Statement* execute(const std::string& query) {
        auto* stmt = conn->prepareStatement(query);
        statements.push_back(stmt);
        return stmt;
    }
};
```

## 5. Diagrams / Mental Models

```
Destruction order (mirror of construction):

    ┌─────────────────────────────────────┐
    │  ~Derived() body  (most-derived)    │  ← runs first
    ├─────────────────────────────────────┤
    │  ~memberN()  ~member2()  ~member1() │  ← reverse declaration order
    ├─────────────────────────────────────┤
    │  ~Base() body                       │  ← runs last
    └─────────────────────────────────────┘
```

```
Stack unwinding with destructors:

    void f() {
        FileHandler f1("a.txt");        // ← constructed first
        FileHandler f2("b.txt");        // ← constructed second  
        throw std::runtime_error("!");  // ← exception!
        // f2 destructor runs           // ← destroyed second
        // f1 destructor runs           // ← destroyed first (stack order)
    }
```

## 6. Common Interview Questions

**Q1: Why must base class destructors be virtual?**

**Answer**: To ensure correct cleanup when deleting a derived object through a base pointer.

```cpp
Base* p = new Derived(1000);  // allocates Derived
delete p;  // Without virtual ~Base(): only ~Base() runs → 1000 ints leak!
           // With virtual ~Base(): ~Derived() runs → ~Base() runs → no leak
```

- **Key point**: Without virtual, the destructor is resolved statically (at compile time) based on the pointer type, not the actual object type.
- **Common mistake**: Thinking it only matters when you write `delete` — it also matters for `std::unique_ptr<Base>` with a custom deleter, or any polymorphic deletion.

---

**Q2: Can a destructor be virtual? Can it be pure virtual?**

**Answer**: Yes and yes. Virtual destructors enable polymorphic deletion. Pure virtual destructors make a class abstract while still providing cleanup — but you **must** define a body for them.

```cpp
class Abstract {
public:
    virtual ~Abstract() = 0;  // class is abstract
};
Abstract::~Abstract() {}      // but body is required
```

- **Key point**: Even pure virtual destructors need a body because derived destructors call that base destructor.
- **Common mistake**: Declaring `virtual ~Foo() = 0;` without defining the body — linker error.

---

**Q3: What happens when a destructor throws an exception?**

**Answer**: If the destructor throws during stack unwinding (while another exception is active), `std::terminate()` is called — the program aborts.

```cpp
class Bad {
public:
    ~Bad() noexcept(false) { throw std::runtime_error("!"); }
};

void f() {
    Bad b;
    throw std::exception();  // stack unwinding starts, ~Bad() runs, throws → terminate!
}
```

- **Key point**: Destructors are `noexcept` by default in C++11+. Throwing from them is always dangerous.
- **Common mistake**: Letting a destructor throw thinking "I'll catch it elsewhere" — it may already be in an exception context.

---

**Q4: When is a destructor called? List all scenarios.**

**Answer**: 
1. **Scope exit** — local variable goes out of scope (including function return)
2. **`delete`** — for dynamically allocated objects
3. **`delete[]`** — for dynamically allocated arrays
4. **Exception unwinding** — during stack unwinding
5. **Program exit** — for static/global objects (reverse order of construction)
6. **`std::exit()`** — destructors for static objects run
7. **`std::atexit` / `std::at_quick_exit`** — registered handlers run

- **Key point**: Destructors are NOT called for `std::abort()` or `std::terminate()`.
- **Common mistake**: Assuming destructors always run on program exit — not if `_exit()` or `abort()` is called.

---

**Q5: What is the destructor order for inheritance and composition?**

**Answer**: Exactly reverse of construction:
- Most-derived class destructor body
- Member destructors (reverse declaration order)
- Base class destructor

```cpp
class A { public: ~A() { cout << "~A "; } };
class B { public: ~B() { cout << "~B "; } };
class C : public A { B b; public: ~C() { cout << "~C "; } };

// Destruction: "~C ~B ~A"
```

- **Key point**: Members destroyed before base — you can still safely use base in member destructors.
- **Common mistake**: Thinking members are destroyed after the base.

---

**Q6: Can a destructor be deleted (`= delete`)? Why would you?**

**Answer**: Yes. Deleting a destructor prevents the object from being destroyed — it can't be created on the stack (can't go out of scope), and `delete` won't compile. Used for:
- Objects that should only be allocated in a specific way
- Objects managed by a custom allocator (deallocation handled separately)

```cpp
class StackOnly {
public:
    void* operator new(size_t) = delete;   // can't allocate on heap
    ~StackOnly() = default;                 // OK — stack objects
};

class HeapOnly {
public:
    ~HeapOnly() = delete;                   // can't destroy manually
    void destroy() { this->~HeapOnly(); }   // must use custom destroy
};
```

- **Key point**: A class with a deleted destructor cannot be used as a local/static/thread-local variable — only dynamically allocated (and even then, `delete` won't work).
- **Common mistake**: Deleting destructor on a base class without providing an alternative cleanup path.

---

**Q7: What is the "rule of five" and how does the destructor fit in?**

**Answer**: If you need to define any of: destructor, copy constructor, copy assignment, move constructor, move assignment — you likely need to define all five (rule of five). Previously "rule of three" (before C++11). The destructor is the most fundamental: if you write one, you're managing a resource, and the compiler-generated copy/move will almost certainly be wrong.

```cpp
class Buffer {
    int* data;
public:
    ~Buffer() { delete[] data; }            // Need destructor
    Buffer(const Buffer&);                   // Need copy ctor
    Buffer& operator=(const Buffer&);        // Need copy assign
    Buffer(Buffer&&) noexcept;               // Need move ctor
    Buffer& operator=(Buffer&&) noexcept;    // Need move assign
};
```

- **Key point**: Rule of 0 is preferable — use RAII smart pointers instead of writing your own destructor.
- **Common mistake**: Writing only a destructor and forgetting copy/move — leads to double-free.

---

**Q8: Can you call a destructor explicitly?**

**Answer**: Yes, but rarely needed. Explicit destructor call: `obj.~T();`

Uses:
1. **Placement new** — manually destroy before deallocating memory
2. **Union members** — manually manage lifetime of active member
3. **Custom memory pools** — destroy object without freeing memory

```cpp
alignas(std::string) char buf[sizeof(std::string)];
auto* s = new (buf) std::string("hello");   // placement new
s->~basic_string();                          // explicit destructor call
// Memory is NOT freed — buf is on stack
```

- **Key point**: After explicit destructor call, the object's lifetime ends but memory remains. Don't use the object after calling its destructor.
- **Common mistake**: Calling destructor explicitly and then letting the same object go out of scope — double destruction (UB).

---

**Q9: What is the relationship between constructor and destructor exception behavior?**

**Answer**: Symmetric but opposite:
- **Constructor throws**: Object never fully constructed → destructor NOT called. Members/base fully constructed by that point ARE destroyed.
- **Destructor throws**: If another exception is active → `terminate()`. If not → exception propagates, but other destructors in the same unwinding sequence may still run (C++11 says `noexcept` destructors by default prevent this).

- **Key point**: Constructor exceptions are safe if you follow RAII. Destructor exceptions are always dangerous.
- **Common mistake**: Assuming both behave the same way.

---

**Q10: How does `std::unique_ptr` work with custom destructors? What about `std::shared_ptr`?**

**Answer**: `std::unique_ptr<T, Deleter>` stores a deleter functor called in its destructor. Default deleter calls `delete`. `std::shared_ptr` stores its deleter type-erased (in the control block).

```cpp
auto fileDeleter = [](FILE* f) { fclose(f); };

// unique_ptr with custom deleter
std::unique_ptr<FILE, decltype(fileDeleter)> ptr(fopen("a.txt", "r"), fileDeleter);

// shared_ptr with custom deleter
std::shared_ptr<FILE> ptr(fopen("a.txt", "r"), fclose);
```

- **Key point**: `unique_ptr` deleter is part of the type; `shared_ptr` deleter is type-erased. Both ensure the destructor cleanup pattern is correct.
- **Common mistake**: Passing a non-copyable deleter to `shared_ptr` (shared_ptr's deleter must be copyable for the control block).

## 7. Deep-Dive Questions

**Q1: What happens during stack unwinding when an exception is thrown from a constructor? Walk through the exact destruction order.**

**Answer**: 
```cpp
struct A { A() { cout << "A"; } ~A() { cout << "~A"; } };
struct B { B() { throw 0; } ~B() { cout << "~B"; } };
struct C { C() : a(), b() { cout << "C"; } ~C() { cout << "~C"; }
           A a; B b; };

try {
    C c;  // 1. c.a constructed (prints "A")
          // 2. c.b constructed — throws!
          //    → c.b lifetime never began (no ~B)
          //    → c.a is destroyed (~A)
          //    → c itself never existed (no ~C)
} catch (...) {
    // Only "A~A" printed
}
```

**Key insight**: Only fully-constructed subobjects are destroyed. The constructor of `C` never completed, so its body and the complete object's destructor never run.

---

**Q2: How does the "rule of zero" interact with move semantics and destructors?**

**Answer**: The rule of zero: prefer classes that don't manage any resources directly (use RAII wrappers like `std::string`, `std::vector`, `std::unique_ptr`). Such classes get correct destructor, copy, and move operations automatically.

```cpp
class Person {
    std::string name;        // RAII — handles its own memory
    std::unique_ptr<Address> addr;  // RAII — handles its own memory
public:
    // No destructor needed — defaults do the right thing
    // No copy/move needed — defaults do the right thing
};

// Compiler-generated ~Person() calls ~string() and ~unique_ptr() automatically
```

**Key insight**: The presence of a user-declared destructor deprecates (in C++11) or prevents (in older compilers) implicit generation of copy/move operations. So writing a destructor at all changes the class's copy/move semantics.

---

**Q3: What happens with `std::thread` and destructors? Why is `std::thread::~thread()` problematic?**

**Answer**: If `std::thread` is joinable at destruction, `std::terminate()` is called. This is by design — the committee decided that silently detaching or joining is worse than crashing.

```cpp
void worker() { /* ... */ }

void f() {
    std::thread t(worker);
    // t goes out of scope, is still joinable → terminate!
}

// Fix: explicitly join or detach
void g() {
    std::thread t(worker);
    t.join();   // wait for thread
}
```

**Key insight**: This is one of the few cases where C++ intentionally terminates. It forces the programmer to think about thread lifetime. The destructor checks `joinable()` and calls `terminate()`.

---

**Q4: What is the destructor behavior for arrays? How is it different from single objects?**

**Answer**: For `delete[] ptr`, the runtime tracks the number of elements (usually stored just before the array in memory). It calls destructors in reverse order for each element. For `delete ptr` on an array — undefined behavior.

```cpp
struct A { ~A() { cout << "~A "; } };

A* arr = new A[3];   // allocates space + element count
delete[] arr;         // calls ~A() three times (reverse): "~A ~A ~A"
// delete arr;        // UB! Wrong deallocation function, only ~A() for first element
```

**Key insight**: Mixing `new` / `delete` and `new[]` / `delete[]` is UB. Always use containers (`std::vector`) to avoid this entirely.

---

**Q5: Explain how `std::optional` handles destruction. What happens when the optional is empty?**

**Answer**: `std::optional<T>` uses placement new to construct `T` in a buffer and tracks whether the value exists. Its destructor calls `T`'s destructor only if the optional is engaged. If empty, it does nothing (just destroys the tracking flag).

```cpp
template<typename T>
class optional {
    alignas(T) unsigned char storage[sizeof(T)];
    bool has_value;
public:
    ~optional() {
        if (has_value) {
            reinterpret_cast<T*>(&storage)->~T();  // only if engaged
        }
    }
};
```

**Key insight**: This is a manual lifetime management pattern — destructor must be conditional. `std::variant` works similarly but with union-like semantics.

---

## 8. Comparison Tables

### Constructor vs Destructor

| Aspect | Constructor | Destructor |
|--------|-------------|------------|
| Syntax | Same name as class | `~` + class name |
| Return type | None | None |
| Parameters | Can have any | None |
| Overloadable | Yes | No (only one) |
| Virtual allowed? | No | Yes |
| Auto-generated? | Yes (default, if no ctors) | Yes (if not user-declared) |
| Exception safety | Can throw (safe with RAII) | Should never throw |
| Called when | Object creation | Object destruction |
| Order (inheritance) | Base → members → derived body | Derived body → members → base |

### Trivial vs Non-Trivial Destructor

| Property | Trivial Destructor | Non-Trivial Destructor |
|----------|-------------------|----------------------|
| Definition | Compiler-generated, does nothing | User-defined or needs member cleanup |
| Lifetime of object | Ends immediately | Active after body runs |
| Union member? | Can be active | Can't be in union (C++11) |
| `std::is_trivially_destructible` | `true` | `false` |
| Optimization | Can be elided | Must be called |

## 9. Common Mistakes

1. **Not making destructors virtual in base classes** — leads to UB on polymorphic deletion.
2. **Throwing from destructors** — causes `terminate()` during stack unwinding.
3. **Writing a destructor but not copy/move** — violates rule of five; double-free or shallow copy bugs.
4. **Using `delete` on an array** — UB; must use `delete[]`.
5. **Relying on destructors for non-deterministic cleanup** — file handles, mutex locks, network sockets in GUIs.
6. **Calling virtual functions in destructors** — derived part is already destroyed; static dispatch to base version.
7. **Explicitly calling destructor then letting object go out of scope** — double destruction.
8. **Assuming static object destructors run on `_exit()`/`abort()`** — they don't.
9. **Forgetting that `std::thread` destructor calls `terminate()` if joinable**.
10. **Not making destructors `noexcept` (pre-C++11)** — implicitly `noexcept` in C++11+ but could be an issue in older codebases.

## 10. Edge Cases / Special Cases

- **Static objects**: Destructors run at program exit in reverse order of construction. Order across translation units is undefined (static initialization order fiasco).
- **Thread-local objects**: Destructors run when the thread exits.
- **`std::atexit` / `std::at_quick_exit`**: Registered functions run after static destructors.
- **Placement new + explicit destructor**: The destructor is responsible for cleanup, but deallocation is separate.
- **Union members with non-trivial destructors**: C++11 allows this but you must manually call the destructor when changing the active member.
- **Destructor marked `= delete`**: Object can only be dynamically allocated and never deleted (or managed through a special function).
- **CRTP (Curiously Recurring Template Pattern)**: Destructors can be used for compile-time polymorphism pattern — base destructor calls `static_cast<Derived*>(this)->cleanup()`.
- **Destructor of `std::any`**: Type-erased destruction — stores a function pointer to the contained type's destructor.

## 11. How to Explain in Interview

> "A destructor is the cleanup counterpart of a constructor. It releases resources when an object is destroyed — whether by going out of scope, being deleted, or during exception stack unwinding.
>
> The most critical rule is: **make base class destructors virtual** if the class has any virtual functions or is intended for polymorphic use. Without this, deleting a derived object through a base pointer causes undefined behavior.
>
> Destructors should never throw exceptions — especially during stack unwinding, where a second exception immediately calls `terminate()`. If cleanup code might throw (like `fclose` or socket shutdown), wrap it in a try-catch.
>
> The destructor completes the RAII contract: acquire in constructor, release in destructor. When you write a destructor, you're managing a resource directly — and you almost certainly need to follow the Rule of Five. Ideally, use the Rule of Zero with smart pointers and containers so the compiler generates the right destructors automatically."

## 12. Quick Revision Notes

| Concept | Key Point |
|---------|-----------|
| Destructor purpose | Release resources, cleanup |
| Single destructor only | No overloading, no parameters |
| Virtual destructor | Required for polymorphic deletion |
| Pure virtual destructor | Makes class abstract; MUST define body |
| Never throw | Causes `terminate()` during unwinding |
| Destruction order | Reverse of construction |
| `= default` | Use compiler-generated version |
| `= delete` | Prevent destruction |
| Rule of Five | If you need one, you need all five |
| Rule of Zero | Prefer RAII wrappers, no manual destructor |

## 13. Practice Tasks

1. Write a base class `Shape` with a virtual destructor. Derive `Circle`, `Rectangle`. Delete derived objects through base pointers.
2. Create a class that counts its alive instances (increment in ctor, decrement in dtor). Verify correctness with multiple objects and `std::vector`.
3. Write a class whose destructor throws an exception. Call it inside another exception handler. Observe `std::terminate()`.
4. Implement a simple `unique_ptr`-like class with proper destructor, copy deletion, and move operations.
5. Create an inheritance chain 3 levels deep. Print trace in each destructor. Verify destruction order.
6. Write a class with a deleted destructor. Try to create it on the stack, on the heap, and in a container.
7. Use placement `new` and explicit destructor call to manage object lifetime in a raw buffer.
8. Write a `Logger` class where destructor ensures the file stream is flushed and closed.
9. Create a class that uses `std::thread` and properly joins in the destructor (study `std::jthread`).
10. Benchmark: compare a vector of `std::unique_ptr<BigObject>` vs raw pointers with manual destructor calls.

## 14. Final Cheat Sheet

```
DESTRUCTOR — ~ClassName(), no params, no overload, auto-called on destruction.

Why:  Resource cleanup, RAII completion.
Key:  Virtual for base classes. Never throw. Reverse construction order.
Rule: If you write one → Rule of Five. Better → Rule of Zero.

Still can leak in constructor exception? → No, if using RAII members.
Terminate in destructor? → Yes, if another exception active.
Virtual + pure virtual? → Yes (pure needs body).
Deleted destructor? → Can't destroy — heap-only objects.

Most asked:
  Q: Why virtual destructor in base?       → Polymorphic deletion safety.
  Q: Can destructor throw?                  → Can, but don't — terminate risk.
  Q: Destruction order?                     → Derived body → members → base.
  Q: Pure virtual destructor?              → Makes class abstract; needs body.
```

---

# Copy Constructor

## 1. Overview

A **copy constructor** is a constructor that creates a new object as a copy of an existing object. It defines what "copying" means for a class.

- **Definition**: `T(const T& other)` — creates a new object initialized with the contents of another object of the same type.
- **Why it matters**: Defines copy semantics. Without it, copying performs a shallow bitwise copy (dangerous with pointers/resources). Custom copy constructors enable deep copying, reference counting, or prohibiting copy entirely.
- **Where used**: Pass-by-value function parameters, return-by-value, STL containers, assignment-like initialization (`T b = a;`), throwing/catching exceptions.
- **Why interviewers ask**: Copy constructor tests understanding of shallow vs deep copy, resource management, compiler-generated special members, and the Rule of Three/Five.

## 2. Core Idea

**Intuition**: A copy constructor is like a photocopier. You put in an original, you get an identical copy. But if the original holds a key to a safe, do you copy the key (shallow) or open the safe and copy its contents (deep)?

**Real-world analogy**: Renting a car. You can either:
- **Shallow copy**: Give the rental the same key fob as the original — both people have the same car (shared resource, double-free problem).
- **Deep copy**: Give the rental a completely new, identical car — each person has their own.

**Small example**:

```cpp
class StringBuffer {
    char* data;
    size_t size;
public:
    // Constructor
    StringBuffer(const char* str) : size(strlen(str)), data(new char[size + 1]) {
        memcpy(data, str, size + 1);
    }
    
    // Copy constructor — DEEP copy
    StringBuffer(const StringBuffer& other) 
        : size(other.size), data(new char[other.size + 1]) {
        memcpy(data, other.data, size + 1);
        std::cout << "Deep copy: " << data << "\n";
    }
    
    ~StringBuffer() { delete[] data; }
};

StringBuffer b1("hello");
StringBuffer b2 = b1;  // copy constructor — both have their own "hello"
```

**Step-by-step**:
1. `StringBuffer b2 = b1;` — sees `StringBuffer(const StringBuffer&)` signature
2. Allocates memory for `b2`
3. Copy constructor runs: `size` copied from `b1.size`, new allocation for `data`, contents copied
4. `b2` is now a fully independent copy. Modifying `b2` doesn't affect `b1`.

## 3. Important Subtopics

### Deep Copy vs Shallow Copy

| Aspect | Shallow Copy | Deep Copy |
|--------|-------------|-----------|
| What it copies | Member values (bitwise) | Allocated resources |
| Default behavior | Compiler-generated copy ctor | Must be hand-written |
| Pointer members | Copies address (shared resource) | Allocates new memory, copies content |
| Double-free risk | Yes (both destructors free same memory) | No |
| When to use | Classes without raw pointers/resources | Classes owning heap resources |

### Compiler-Generated Copy Constructor

```cpp
class Point {
    int x, y;  // built-in types — shallow copy is fine
};
// Compiler generates: Point(const Point&) = default;  // copies x, y bitwise

class Widget {
    std::string name;  // string has its own copy constructor
};
// Compiler generates: Widget(const Widget&) = default;  // calls string's copy ctor
```

- **When generated**: If no user-defined copy constructor, move constructor, or move assignment operator.
- **What it does**: Memberwise copy — calls each member's copy constructor (or bitwise copy for built-ins).
- **Deprecated**: In C++11+, if a user-defined destructor exists, implicit copy generation is deprecated.

### Deleted Copy Constructor

```cpp
class UniqueResource {
public:
    UniqueResource(const UniqueResource&) = delete;  // Can't copy
    UniqueResource& operator=(const UniqueResource&) = delete;
};

UniqueResource u1;
UniqueResource u2 = u1;  // ERROR — copy deleted
```

Used for: `std::unique_ptr`, `std::thread`, `std::fstream`, any class owning a unique resource.

### Copy Elision (RVO/NRVO)

```cpp
std::string createString() {
    return "hello world";  // Return Value Optimization (RVO)
}

std::string s = createString();  // Copy constructor may be elided
```

- C++17 guarantees copy elision in certain contexts (returning prvalues).
- Even when elided, the copy constructor must be accessible (not deleted).

## 4. Real-World Example

**HTTP Response Cache** — copying cached responses:

```cpp
class HttpResponse {
    std::string body;
    std::unordered_map<std::string, std::string> headers;
    int statusCode;
    mutable int cacheHitCount;  // mutable — can modify in "const" copy
    
public:
    HttpResponse(int code, const std::string& b)
        : statusCode(code), body(b), cacheHitCount(0) {}
    
    // Deep copy — each cached copy has its own body and headers
    HttpResponse(const HttpResponse& other)
        : statusCode(other.statusCode)
        , body(other.body)                  // string copies itself
        , headers(other.headers)            // map copies itself
        , cacheHitCount(other.cacheHitCount)
    {
        std::cout << "Cache: Response copied for parallel processing\n";
    }
    
    const std::string& getBody() const { return body; }
};
```

## 5. Diagrams / Mental Models

```
Copy construction flow:

    Original (source)          Copy (destination)
    ┌─────────────┐           ┌─────────────┐
    │ data ───────┼───0x100───┼─► data      │  ← Shallow: same address
    │ size = 5    │           │ size = 5    │     (DANGEROUS)
    └─────────────┘           └─────────────┘

    ┌─────────────┐           ┌─────────────┐
    │ data ───►0x100          │ data ───►0x200  ← Deep: different address
    │ "hello"    │           │ "hello"        │     (SAFE)
    └─────────────┘           └─────────────┘
```

```
When copy constructor is called:

    T a;                  // default constructor
    T b(a);               // copy constructor (explicit)
    T c = a;              // copy constructor (implicit)
    T d = T(a);           // copy constructor
    void f(T p); f(a);    // copy constructor (pass by value)
    T g() { return a; }   // copy constructor (return by value, may be elided)
```

## 6. Common Interview Questions

**Q1: What is the difference between copy constructor and copy assignment operator?**

**Answer**: Copy constructor creates a **new** object from an existing one. Copy assignment assigns to an **already-existing** object.

```cpp
StringBuffer b2 = b1;   // COPY CONSTRUCTOR — b2 doesn't exist yet
b2 = b1;                 // COPY ASSIGNMENT — b2 already exists
```

- **Key point**: Copy constructor initializes, copy assignment replaces contents. Both need deep copy for pointer members.
- **Common mistake**: Forgetting to handle self-assignment in copy assignment (not relevant for copy constructor).

---

**Q2: When is the compiler-generated copy constructor used? When is it not generated?**

**Answer**: Generated when all of:
1. No user-declared copy constructor
2. No user-declared move constructor
3. No user-declared move assignment operator

The generated version memberwise-copies each member (calls each member's copy constructor).

**NOT generated** if any of:
- Move constructor/assignment declared
- Copy assignment declared

- **Key point**: A user-declared destructor does NOT suppress copy constructor (but deprecates it in C++11+).
- **Common mistake**: Thinking "if I write a destructor, I must write copy ctor" — you should, but it's not suppressed automatically.

---

**Q3: What is shallow copy? Why is it dangerous?**

**Answer**: Shallow copy copies the pointer value, not what it points to. Both objects point to the **same memory**.

```cpp
class Shallow {
    int* data;
public:
    Shallow(int v) : data(new int(v)) {}
    // Using compiler-generated copy ctor → shallow copy
};

Shallow a(42);
Shallow b = a;   // both a.data and b.data point to the SAME int
// When destructors run: double-free!
```

- **Key point**: Double-free, use-after-free, and corruption risks.
- **Common mistake**: Thinking "it works for simple classes" — any raw pointer member means shallow copy is wrong.

---

**Q4: What is copy elision? When is it guaranteed?**

**Answer**: Compiler optimization that eliminates the copy/move constructor call. C++17 guarantees it in:

```cpp
// Guaranteed copy elision (C++17):
T f() { return T(42); }    // RVO: no copy ctor called
T x = T(42);               // prvalue — no temporary

// Named RVO (NRVO) — not guaranteed but common:
T g() { T local; return local; }  // may be elided
```

- **Key point**: Even when elided, the copy constructor must be accessible. C++17 mandates elision for prvalues.
- **Common mistake**: Relying on copy elision for correctness — always ensure copy semantics are correct.

---

**Q5: Why would you declare a copy constructor private? (Pre-C++11)**

**Answer**: To prevent copying. Before `= delete` existed, making copy constructor private (and not defining it) prevented copying.

```cpp
class NonCopyable {
private:
    NonCopyable(const NonCopyable&);  // not defined
    NonCopyable& operator=(const NonCopyable&);
public:
    NonCopyable() = default;
};
```

Modern C++: Use `= delete` or inherit from `boost::noncopyable` / C++11 `= delete`.

- **Key point**: Private + undefined = compile-time + link-time error prevention for copies.
- **Common mistake**: Only making it private but defining it — then friends/members can copy (and double-free).

---

**Q6: What is the difference between `T obj = other;` and `T obj(other);`?**

**Answer**: Both call the copy constructor (or move constructor, depending on overload resolution). The difference:

```cpp
T obj(other);       // Direct initialization — always calls constructor
T obj = other;     // Copy initialization — calls copy ctor (elision possible)
```

`T obj = other;` requires an accessible, non-`explicit` copy constructor. `T obj(other);` uses direct init and can use `explicit` constructors.

- **Key point**: `T obj = std::move(other);` — the `=` syntax is copy initialization, `std::move` targets move ctor. Not about copy vs move.
- **Common mistake**: Thinking `=` always means assignment.

---

**Q7: What happens if a class has a reference member? How does the copy constructor behave?**

**Answer**: Reference members are just aliases — they can't be reseated. The compiler-generated copy constructor copies the reference itself (binds to the same object), not the referred-to value.

```cpp
class RefHolder {
    int& ref;
public:
    RefHolder(int& r) : ref(r) {}
    // Compiler-generated: RefHolder(const RefHolder& other) : ref(other.ref) {}
    // This means ref binds to the SAME int that other.ref binds to
};
```

- **Key point**: Copying an object with reference members doesn't create a new independent reference — it aliases the same target.
- **Common mistake**: Thinking `ref` gets copied to a new value — references aren't objects, they're aliases.

---

**Q8: Can the copy constructor be templated? Is it still a copy constructor?**

**Answer**: A templated constructor like `template<typename U> T(const U&);` is never a copy constructor. The copy constructor has a specific signature: `T(const T&)` or `T(T&)`.

```cpp
class Widget {
public:
    Widget(const Widget&);               // This IS a copy constructor
    template<typename U>
    Widget(const U&);                     // This is NOT a copy constructor
};
```

- **Key point**: The compiler still generates a default copy constructor even if a templated constructor matching `Widget(const U&)` exists when `U = Widget` is a possibility.
- **Common mistake**: Thinking a templated constructor replaces the copy constructor.

---

**Q9: How does the copy constructor interact with inheritance?**

**Answer**: The derived class copy constructor must call the base class copy constructor. If not explicitly called, the base default constructor is used (which may not exist or may not copy correctly).

```cpp
class Base {
    int x;
public:
    Base(const Base& other) : x(other.x) {}
};

class Derived : public Base {
    int y;
public:
    // RIGHT: explicitly call base copy constructor
    Derived(const Derived& other) : Base(other), y(other.y) {}
    
    // WRONG: doesn't call Base(const Base&), calls Base() instead
    // Derived(const Derived& other) : y(other.y) {}
};
```

- **Key point**: In the explicit call, `Base(other)` works because `Derived` is-a `Base` (slicing is safe in ctor context).
- **Common mistake**: Forgetting to call base copy constructor — base members don't get copied.

---

**Q10: What is the "copy and swap" idiom?**

**Answer**: A technique for implementing copy assignment that's exception-safe and handles self-assignment correctly:

```cpp
class StringBuffer {
    char* data;
    size_t size;
    
    void swap(StringBuffer& other) noexcept {
        std::swap(data, other.data);
        std::swap(size, other.size);
    }
    
public:
    // Copy assignment using copy-and-swap
    StringBuffer& operator=(StringBuffer other) {  // Note: pass by value (triggers copy)
        swap(other);                                 // swap with the copy
        return *this;                                // old data destroyed when 'other' goes out of scope
    }
};
```

- **Key point**: Exception-safe, self-assignment-safe, and reuses the copy constructor. The parameter is taken by value, which triggers the copy constructor.
- **Common mistake**: Confusing it with the copy constructor itself. Copy-and-swap is for **assignment**.

## 7. Deep-Dive Questions

**Q1: What happens with the copy constructor and `std::any` or type-erased types?**

**Answer**: `std::any` stores a copy of any type. Its copy constructor uses type erasure to call the stored type's copy constructor through a function pointer:

```cpp
class any {
    struct Base { virtual ~Base() = default; virtual Base* clone() const = 0; };
    template<typename T>
    struct Derived : Base {
        T value;
        Derived(const T& v) : value(v) {}
        Base* clone() const override { return new Derived(value); }  // calls T's copy ctor
    };
    Base* ptr;
public:
    any(const any& other) : ptr(other.ptr ? other.ptr->clone() : nullptr) {}
};
```

**Key insight**: This is polymorphic copying — the copy constructor of the concrete type is called through a virtual `clone()` function.

---

**Q2: How do you make a class movable but not copyable?**

**Answer**: 
```cpp
class MovableOnly {
public:
    MovableOnly(MovableOnly&&) = default;           // Move constructor
    MovableOnly& operator=(MovableOnly&&) = default; // Move assignment
    MovableOnly(const MovableOnly&) = delete;        // No copy
    MovableOnly& operator=(const MovableOnly&) = delete;
};
```

Same as `std::unique_ptr`. This is a common pattern for unique resource owners.

**Key insight**: Declaring a move constructor suppresses the copy constructor. You must explicitly `=default` the move and `=delete` the copy.

---

**Q3: How does `std::atomic` affect copy constructor generation?**

**Answer**: `std::atomic` types have deleted copy constructors (atomic operations aren't meaningful on copies — the copy would be a separate atomic variable). If a class has an atomic member, its copy constructor is also deleted:

```cpp
struct Counter {
    std::atomic<int> value;  // atomic has deleted copy ctor
    // Counter(const Counter&) = delete;  // implicitly deleted
};
```

**Key insight**: This prevents accidental copying of types that shouldn't be copied.

---

**Q4: Explain the relationship between copy constructor and slicing.**

**Answer**: Slicing happens when you pass a derived object by value to a function expecting a base:

```cpp
struct Base { int x; };
struct Derived : Base { int y; };

void process(Base b) { /* b.y doesn't exist — sliced! */ }

Derived d;
process(d);  // copy constructor Base(const Base&) called with d
             // only d.x is copied; d.y is sliced away
```

**Key insight**: The base class copy constructor doesn't know about derived members. To prevent slicing: pass by reference/pointer, use virtual `clone()`, or delete base copy constructor.

---

**Q5: How do you implement a polymorphic copy (virtual copy constructor)?**

**Answer**: Use a virtual `clone()` method:

```cpp
class Base {
public:
    virtual ~Base() = default;
    virtual Base* clone() const = 0;  // "virtual copy constructor"
};

class Derived : public Base {
    int* data;
public:
    Derived(const Derived& other) : data(new int(*other.data)) {}
    Base* clone() const override { return new Derived(*this); }  // calls copy ctor
};

void use(Base& b) {
    Base* copy = b.clone();  // polymorphic copy — correct type
}
```

**Key insight**: C++ doesn't support virtual constructors natively. `clone()` is the standard workaround.

---

## 8. Comparison Tables

### Copy Constructor vs Copy Assignment

| Aspect | Copy Constructor | Copy Assignment |
|--------|------------------|-----------------|
| When called | Creating new object | Assigning to existing object |
| Syntax | `T a = b;` or `T a(b);` | `a = b;` |
| Object `a` pre-exists? | No | Yes |
| Self-assignment check | N/A | `if (this != &other)` |
| Old resource cleanup | N/A (nothing to clean) | Must release old resources |
| Can be virtual? | No | Yes (but rare) |
| Exception safety | Usually safe | May need copy-and-swap |

### Shallow vs Deep Copy

| Aspect | Shallow | Deep |
|--------|---------|------|
| Copy pointer value? | Yes | No |
| Allocate new memory? | No | Yes |
| Independent objects? | No (shared state) | Yes |
| Destructor safe? | No (double-free) | Yes |
| Performance | Fast | Slower (allocation + copy) |

## 9. Common Mistakes

1. **Relying on shallow copy** — any class with raw pointers needs deep copy.
2. **Forgetting the Rule of Five** — writing copy ctor but forgetting copy assignment, move ctor, move assignment.
3. **Not handling self-assignment** — relevant for copy assignment, not copy ctor.
4. **Passing by value unnecessarily** — copies the object for no reason.
5. **Not calling base copy constructor in derived class** — base members aren't copied.
6. **Thinking `= delete` is same as private** — `= delete` gives better error messages and applies everywhere.
7. **Ignoring copy elision** — assuming copy constructor always runs.
8. **Making copy constructor `explicit`** — breaks `T b = a;` syntax and STL usage.
9. **Copying `std::unique_ptr`** — it's deleted; use `std::move` or return by value.
10. **Not marking copy constructors correctly for const-correctness** — `T(const T&)` vs `T(T&)` — the first allows copying const objects.



## 11. How to Explain in Interview

> "The copy constructor creates a new object as a copy of an existing one. It defines what copying means for a class. The compiler generates one automatically that does a memberwise copy — but if the class manages resources directly (raw pointers, file handles), that shallow copy causes double-free or resource leaks.
>
> The key decision is when to write a custom copy constructor: whenever the class owns a resource. I follow the Rule of Five: if I need a destructor, I need the copy constructor, copy assignment, move constructor, and move assignment too. Ideally, I use the Rule of Zero — use RAII wrappers like std::string, std::vector, std::unique_ptr so the compiler generates correct copy operations automatically.
>
> A common interview point is copy elision — the compiler is allowed to skip the copy constructor call in certain contexts (return value optimization). C++17 guarantees elision for prvalues, but the copy constructor must still be accessible.
>
> For polymorphic copying, I implement a virtual clone() method since C++ doesn't have virtual constructors."

## 12. Quick Revision Notes

| Concept | Key Point |
|---------|-----------|
| Copy constructor | T(const T&) — creates new object from existing |
| Deep copy | Allocate new memory, copy contents |
| Shallow copy | Copy pointer values only — dangerous |
| Compiler-generated | Memberwise copy; suppressed by move ctor/assign |
| Copy elision | Compiler may skip copy ctor call |
| Rule of Five | If you need one, you need all five |
| = delete | Prevent copying |
| Slicing | Pass by value to base = loss of derived data |

## 13. Practice Tasks

1. Write a DynamicArray class with a deep copy constructor. Verify that modifying the copy doesn't affect the original.
2. Create a class with a raw pointer member. Use the compiler-generated copy constructor and cause a double-free crash.
3. Implement the "copy and swap" idiom for a StringBuffer class.
4. Write a class that tracks how many times it's been copied (static counter).
5. Create a polymorphic hierarchy with a virtual clone() method. Demonstrate type-correct copying.
6. Write a class where copy constructor is deleted. Try to use it in a std::vector.
7. Observe copy elision with -fno-elide-constructors flag in GCC/Clang.
8. Write a class that has a reference member. Verify that copying it aliases the same reference target.
9. Create a class hierarchy where the derived copy constructor forgets to call the base copy constructor. Diagnose the bug.
10. Implement a SharedPtr-like class with reference counting: copy constructor increments the reference count.

## 14. Final Cheat Sheet

```
COPY CONSTRUCTOR — T(const T&), creates new object as copy of existing.

Why:  Defines copy semantics. Deep copy for resource-owning classes.
Key:  Shallow copy = double-free. Deep copy = new allocation + copy.
      Compiler generates memberwise copy if no move ctor/assign.
      Rule of Five: if you need destructor, you need copy ctor too.

Elision: RVO/NRVO may skip copy ctor call (C++17 guarantees prvalue elision).
Polymorphic copy: Use virtual Base* clone() const = 0;

Most asked:
  Q: Shallow vs deep copy?                      → Shallow copies pointer; deep allocates new.
  Q: When is compiler copy ctor generated?     → If no move ctor/assign declared.
  Q: How to prevent copying?                    → =delete or private+undefined.
  Q: Copy vs assignment?                        → Ctor creates new; assign replaces existing.
  Q: What is slicing?                           → Derived passed by value to base = lost members.
```

---

# Copy Assignment Operator (operator=)

## 1. Overview

The **copy assignment operator** is a special member function that copies the contents of one existing object into another existing object of the same type.

- **Definition**: T& operator=(const T& other) — assigns the state of other to *this, returning a reference to *this (for chaining).
- **Why it matters**: Assignment is one of the most common operations. A correct copy assignment ensures proper resource management, prevents leaks, and handles self-assignment safely.
- **Where used**: Anywhere obj1 = obj2 appears. Containers use it during resizing, algorithm implementations, and general value semantics.
- **Why interviewers ask**: Tests understanding of resource management, self-assignment, exception safety, and the difference between initialization and assignment.

## 2. Core Idea

**Intuition**: Copy assignment is like renovating a house to match a neighbor's. You already have a house (existing object), but you want to replace everything inside to match the other house. You must first clear out your old furniture (release old resources), then bring in new furniture (allocate and copy).

**Small example**:

```cpp
class StringBuffer {
    char* data;
    size_t size;
public:
    StringBuffer& operator=(const StringBuffer& other) {
        if (this != &other) {
            delete[] data;
            size = other.size;
            data = new char[size + 1];
            memcpy(data, other.data, size + 1);
        }
        return *this;
    }
};
```

**Step-by-step**:
1. StringBuffer a("hello"), b("world"); b = a;
2. operator= called on b with a as argument
3. Self-assignment check: this != &other (b != a) -> true
4. Delete old data ("world")
5. Copy size from a
6. Allocate new memory for b.data
7. Copy contents from a.data to b.data
8. Return *this to allow c = b = a;

## 3. Important Subtopics

### Self-Assignment Check

```cpp
// Without self-assignment check:
MyClass& operator=(const MyClass& other) {
    delete[] data;                // Deletes THIS object's data
    data = new char[other.size];  // other.data was just deleted!
    memcpy(data, other.data, ...);  // READING FREED MEMORY -> UB
}
```

**Copy-and-swap idiom** avoids the need for explicit check:

```cpp
MyClass& operator=(MyClass other) {  // pass by value, copy ctor called
    swap(other);                      // swap with the copy
    return *this;                     // old data destroyed when other goes out of scope
}
```

### Return *this

Allows chaining: a = b = c; -> a.operator=(b.operator=(c));

### Compiler-Generated Copy Assignment

Generated when: no user-declared copy assignment, move constructor, or move assignment. Does memberwise assignment.

## 4. Real-World Example

**Database Connection Pool** — assigning a new configuration.

## 5. Common Interview Questions

**Q1: Difference between copy constructor and copy assignment?**
**Answer**: Copy ctor creates a NEW object. Copy assignment replaces an EXISTING object. Copy ctor doesn't free old resources; assignment does.

**Q2: Why is self-assignment check important?**
**Answer**: Without it, a = a would delete this->data, then read other.data (same freed memory) — UB.

**Q3: What is copy-and-swap idiom?**
**Answer**: Pass by value (calls copy ctor), then swap. Exception-safe, self-assignment safe, reuses copy ctor.

**Q4: Return type of operator=?**
**Answer**: T& for chaining a = b = c;.

**Q5: When is copy assignment deleted?**
**Answer**: If move ctor/assign declared, member is const/reference, or member/base has deleted copy assignment.

**Q6: Inheritance and copy assignment?**
**Answer**: Must call Base::operator=(other); explicitly in derived.

**Q7: Strong exception guarantee?**
**Answer**: If assignment throws, object is unchanged. Copy-and-swap provides this naturally.

**Q8: Can operator= be virtual?**
**Answer**: Yes, but not useful — different signatures hide, not override. Leads to slicing.

**Q9: T& operator=(T) vs T& operator=(const T&)?**
**Answer**: First is copy-and-swap (pass by value). Second is traditional (reference).

**Q10: Copy assignment and std::move?**
**Answer**: std::move targets move assignment; falls back to copy if unavailable.

## 6. Comparison Tables

| Aspect | Copy Constructor | Copy Assignment |
|--------|------------------|-----------------|
| Creates new object? | Yes | No |
| Frees old resources? | N/A | Yes |
| Self-assignment check? | N/A | Yes |
| Return type | None | T& |
| Signature | T(const T&) | T& operator=(const T&) |

## 7. Edge Cases / Special Cases

- Self-assignment through aliasing: *p = *q; where p == q
- const/reference member classes: Copy assignment is deleted
- Union members: Deleted if any member has non-trivial assignment

## 8. Final Cheat Sheet

```
COPY ASSIGNMENT — T& operator=(const T&), replaces existing object.

Why:  Value semantics, resource management.
Key:  Self-assignment check. Return *this. Strong exception guarantee.
      Copy-and-swap: pass by value, swap, done.

Most asked:
  Q: Why self-assignment check?              → Prevent reading freed memory.
  Q: Copy-and-swap idiom?                    → Pass by value + swap = safe + simple.
  Q: Difference from copy constructor?       → Ctor creates new; assign replaces existing.
  Q: When is copy assignment deleted?        → const/ref members, move-only members.
```

---

# Move Constructor

## 1. Overview

The **move constructor** transfers resources from a temporary (rvalue) object to a newly created object, avoiding expensive deep copies.

- **Definition**: T(T&& other) noexcept — constructs a new object by stealing resources from other, leaving it in a valid but unspecified state.
- **Why it matters**: Move semantics eliminate costly deep copies for temporaries, enabling efficient containers and making std::unique_ptr usable.
- **Where used**: Return values, STL container resizing, std::move(), temporaries, factory functions.
- **Why interviewers ask**: Tests understanding of rvalue references, move semantics, perfect forwarding, and modern C++ resource management.

## 2. Core Idea

**Intuition**: A move constructor steals resources instead of copying them. Like moving furniture from an old house to a new one instead of buying new furniture.

**Small example**:

```cpp
class StringBuffer {
    char* data;
    size_t size;
public:
    StringBuffer(const char* str) : size(strlen(str)), data(new char[size + 1]) {
        memcpy(data, str, size + 1);
    }

    // Move constructor — steal resources, don't copy
    StringBuffer(StringBuffer&& other) noexcept
        : data(other.data), size(other.size) {
        other.data = nullptr;
        other.size = 0;
    }

    ~StringBuffer() { delete[] data; }
};

StringBuffer createBuffer() {
    StringBuffer temp("temporary");
    return temp;  // Move constructor (or NRVO) — no deep copy!
}
```

**Step-by-step**:
1. StringBuffer temp("temporary"); — normal construction
2. return temp; — compiler identifies temp as xvalue (eXpiring value)
3. Move constructor called: steals temp.data pointer
4. temp.data = nullptr (safe to destroy)
5. sb has the data, no deep copy happened

## 3. Important Subtopics

### Rvalue References (&&)

T&& binds to rvalues (temporaries, std::move results) but not lvalues (named variables). Enables overloading: move ctor takes T&&, copy ctor takes const T&.

### noexcept on Move Constructor

Always mark move constructors noexcept. std::vector uses this to decide: if move is noexcept, it moves elements during reallocation; otherwise, it copies (to preserve strong exception guarantee).

### Compiler-Generated Move Constructor

Generated when: no user-declared copy constructor, copy assignment, move assignment, or destructor. Does memberwise move.

## 4. Real-World Example

**Server Connection** — moving a connection avoids copying socket descriptors.

```cpp
class TcpConnection {
    int socketFd;
    std::vector<char> buffer;
    std::string remoteAddress;
public:
    TcpConnection(TcpConnection&& other) noexcept
        : socketFd(other.socketFd)
        , buffer(std::move(other.buffer))
        , remoteAddress(std::move(other.remoteAddress)) {
        other.socketFd = -1;
    }
};
```

## 5. Common Interview Questions

**Q1: Move vs copy constructor?**
**Answer**: Copy duplicates resources. Move steals them (source left valid but empty). Move is O(1) for pointer-based resources; copy is O(n).

**Q2: When is move constructor called?**
**Answer**: Return by value, std::move() cast, passing temporaries, STL container operations, make_unique.

**Q3: Why is noexcept important?**
**Answer**: std::vector copies instead of moves if move constructor is not noexcept (to preserve strong exception guarantee during reallocation).

**Q4: What state should a moved-from object be in?**
**Answer**: Valid but unspecified — must be destructible and assignable, but value is unspecified. Not necessarily empty.

**Q5: When is move constructor deleted/suppressed?**
**Answer**: If destructor, copy ctor, or copy assignment is user-declared. Also if member is const or has deleted move ctor.

**Q6: What is std::move?**
**Answer**: Just a cast (static_cast<T&&>(x)). It doesn't move anything — the move constructor/assignment does the actual moving.

**Q7: Inheritance and move constructor?**
**Answer**: Must call Base(std::move(other)) explicitly. Base must have a move constructor (or copy as fallback).

**Q8: Relationship between move and copy constructors?**
**Answer**: Declaring move suppresses copy. Declaring copy suppresses move. They are mutually exclusive for implicit generation.

**Q9: What is perfect forwarding?**
**Answer**: std::forward preserves value category through templates. Use std::forward<T>(arg) in forwarding functions, not std::move.

**Q10: Move semantics with std::array?**
**Answer**: std::array move is element-wise O(N), not O(1) like std::vector. No pointer swap possible with stack storage.

## 6. Comparison Tables

| Aspect | Copy Constructor | Move Constructor |
|--------|------------------|------------------|
| Signature | T(const T&) | T(T&&) noexcept |
| Resource allocation | Yes (deep copy) | No (steal) |
| Source modified? | No | Yes (valid but empty) |
| noexcept | Optional | Strongly recommended |
| Complexity | O(n) | O(1) typically |
| Vector reallocation | Copies (strong guarantee) | Moves only if noexcept |

## 7. Final Cheat Sheet

```
MOVE CONSTRUCTOR — T(T&& other) noexcept, steals resources from rvalue.

Why:  Avoid deep copies for temporaries, enable efficient containers.
Key:  Steal pointers, nullify source. noexcept for vector reallocation.
      std::move is just a cast. Moved-from = valid but unspecified.

Always noexcept?    → Yes, or vector will copy instead of move.
Auto-generated?     → No, if destructor/copy ctor/copy assign declared.

Most asked:
  Q: Move vs copy constructor?       → Move steals; copy duplicates.
  Q: Why noexcept?                   → Vector reallocation safety.
  Q: What is std::move?              → Cast to rvalue reference.
  Q: Moved-from object state?        → Valid but unspecified.
  Q: When is move ctor suppressed?   → If copy/dtor/assign declared.
```

---

# Virtual Functions

## 1. Overview

A **virtual function** enables runtime polymorphism — the correct function is called based on the actual object type, not the pointer/reference type.

- **Definition**: Declared with virtual keyword, allowing derived classes to provide their own implementation. Calls resolved at runtime via vtable.
- **Why it matters**: Enables the Open/Closed Principle — add new types without modifying existing code.
- **Where used**: GUI frameworks, game engines, plugin systems, design patterns (Strategy, Template Method).
- **Why interviewers ask**: Tests understanding of polymorphism, dynamic dispatch, vtable mechanism, and performance implications.

## 2. Core Idea

**Intuition**: Same interface (function name), different behavior depending on the actual object type.

**Small example**:

```cpp
class Shape {
public:
    virtual void draw() const { cout << "Shape\n"; }
    virtual ~Shape() = default;
};

class Circle : public Shape {
public:
    void draw() const override { cout << "Circle\n"; }
};

void render(const Shape& s) { s.draw(); }  // Runtime dispatch
Circle c;
render(c);  // "Circle"
```

**Step-by-step**:
1. Shape has virtual draw(). Compiler creates vtable for Shape
2. Circle overrides draw(). Compiler creates vtable with Circle::draw()
3. s.draw() — compiler doesn't know type at compile time
4. At runtime: vptr -> vtable -> Circle::draw()

## 3. Important Subtopics

### override Specifier (C++11)

void draw() const override; — compiler checks that base has a virtual function with matching signature.

### final Specifier (C++11)

virtual void draw() const final; — prevents further overriding. Enables devirtualization optimization.

### Virtual Destructor

Always make destructors virtual in base classes used polymorphically. Without it, deleting derived through base pointer is UB.

## 4. Common Interview Questions

**Q1: How does virtual dispatch work?**
**Answer**: Through vtable/vptr mechanism. Each object has a vptr pointing to its class's vtable. Compiler emits: load vptr -> index vtable -> call function pointer.

**Q2: Virtual vs non-virtual?**
**Answer**: Virtual = runtime dispatch (dynamic). Non-virtual = compile-time dispatch (static). Virtual has vtable overhead.

**Q3: What is override keyword?**
**Answer**: Compiler-checked contract that a function overrides a base virtual. Catches signature mismatches at compile time.

**Q4: Can virtual functions be inlined?**
**Answer**: Yes, if the compiler can determine the exact type (devirtualization). Stack objects and final classes enable this.

**Q5: Virtual in constructor/destructor?**
**Answer**: Resolves to the class currently being constructed/destroyed, not the most-derived. The vtable for derived part isn't set up yet.

**Q6: Overriding vs hiding?**
**Answer**: Overriding = same signature + virtual in base. Hiding = same name but different signature (or non-virtual base function).

**Q7: Can a virtual function be static?**
**Answer**: No. Static functions are class-level, no this pointer, no vptr.

**Q8: Can a virtual function have default arguments?**
**Answer**: Yes, but default arguments are NOT virtual — resolved at compile time based on static type.

**Q9: Cost of virtual function call?**
**Answer**: ~2-3 extra instructions (vptr load + vtable index + indirect call), potential cache miss. ~8 bytes vptr per object.

**Q10: Multiple inheritance and virtual functions?**
**Answer**: Multiple vptrs (one per base with virtuals). Compiler generates thunks to adjust this pointer.

## 5. Comparison Tables

| Aspect | Virtual | Non-Virtual |
|--------|---------|-------------|
| Dispatch | Runtime (dynamic) | Compile-time (static) |
| Resolution | Based on dynamic type | Based on static type |
| Override | Yes | No (hides) |
| vtable entry | Yes | No |
| Inlining | Rarely | Yes |
| Performance cost | ~2-3 instructions | 0 |

## 6. Final Cheat Sheet

```
VIRTUAL FUNCTION — Declared with 'virtual', dispatched at runtime via vtable.

Why:  Runtime polymorphism, Open/Closed Principle.
How:  vptr -> vtable -> function pointer. ~2 extra instructions.
Key:  Always use 'override' in derived. Virtual destructor in base.
      Don't call virtual in ctor/dtor. Default args are static not virtual.

Cost: ~8 bytes vptr per object. 1 cache line per vtable class.

Most asked:
  Q: How does virtual dispatch work?      → vptr + vtable lookup.
  Q: Can virtual be inlined?              → Yes, if devirtualized.
  Q: Virtual in constructor?              → Only base version runs.
  Q: Virtual vs non-virtual difference?   → Dynamic vs static dispatch.
```

---

# Pure Virtual Functions & Abstract Classes

## 1. Overview

A **pure virtual function** (declared with = 0) makes a class **abstract** — it cannot be instantiated. Derived classes must override it.

- **Definition**: virtual ReturnType func(params) = 0;
- **Why it matters**: Defines interface contracts. Enforces that derived classes implement certain functionality.
- **Where used**: Design patterns, plugin architectures, GUI frameworks, API designs.

## 2. Core Idea

**Intuition**: A job description that says "this task must be done" without doing it yourself. The contract requires implementation.

**Small example**:

```cpp
class Vehicle {
public:
    virtual void startEngine() = 0;  // pure virtual
    virtual void drive() = 0;        // pure virtual
    virtual ~Vehicle() = default;
};

class Car : public Vehicle {
public:
    void startEngine() override { cout << "Vroom!\n"; }
    void drive() override { cout << "Driving\n"; }
};

// Vehicle v;  // ERROR: cannot instantiate abstract class
Car c;           // OK — all pure virtuals overridden
```

## 3. Important Subtopics

### Pure Virtual Function with a Body

```cpp
class Shape {
public:
    virtual void draw() const = 0;
};
void Shape::draw() const { /* body exists — can be called by derived */ }
// = 0 means "must override", not "no body"
```

### Abstract Class vs Interface

C++ has no interface keyword. Convention: interface = all pure virtuals + no data members. Abstract class = some pure virtuals + may have data/concrete methods.

### Pure Virtual Destructor

virtual ~AbstractBase() = 0; — MUST have a body. Makes class abstract without other pure virtuals.

## 4. Common Interview Questions

**Q1: What is a pure virtual function?**
**Answer**: = 0 syntax. Makes class abstract. Derived classes must override.

**Q2: Abstract vs concrete class?**
**Answer**: Abstract has at least one pure virtual. Concrete has none.

**Q3: Can a pure virtual function have a body?**
**Answer**: Yes. = 0 means "must override," not "no body." Bodies can be called explicitly by derived.

**Q4: Purpose of pure virtual destructor?**
**Answer**: Makes class abstract. MUST have body (derived destructors call base destructor during unwinding).

**Q5: Abstract class vs interface in C++?**
**Answer**: Interface = all pure virtual + no data. Abstract class = some pure virtual + may have data/concrete methods.

**Q6: What if derived doesn't override all pure virtuals?**
**Answer**: Derived is also abstract. Cannot instantiate.

**Q7: Can a class be abstract without pure virtual?**
**Answer**: No. Protected constructor prevents instantiation but is not the same as abstract class.

**Q8: override on pure virtual?**
**Answer**: Same as regular virtual — compiler checks signature match with base.

**Q9: Can you create array of abstract objects?**
**Answer**: No (compile error). But array of pointers/references to abstract type is fine.

**Q10: Factory pattern and pure virtual?**
**Answer**: Factory method is typically a pure virtual that subclasses override.

## 5. Comparison Tables

| Aspect | Pure Virtual | Virtual |
|--------|--------------|---------|
| Declaration | = 0 | No = 0 |
| Must be overridden? | Yes | No |
| Class becomes abstract? | Yes | No |
| Can have body? | Yes (optional) | Yes |

## 6. Final Cheat Sheet

```
PURE VIRTUAL — virtual void f() = 0; makes class abstract.

Why:  Define interface contracts. Force derived to implement.
Key:  Abstract class = at least one =0. Can't instantiate.
      Pure virtual CAN have a body (but must still be overridden).
      Pure virtual destructor MUST have body.

Interface = all pure virtual + no data members.

Most asked:
  Q: What is a pure virtual function?        → = 0, makes class abstract.
  Q: Can pure virtual have a body?           → Yes, but must still override.
  Q: Abstract vs concrete class?             → Has =0 vs no =0.
  Q: Pure virtual destructor?                → Makes class abstract, MUST have body.
```

---

# vtable & vptr

## 1. Overview

**vtable** (virtual table) and **vptr** (virtual pointer) are C++'s internal implementation mechanism for virtual function dispatch (runtime polymorphism).

- **Definition**: vtable = per-class table of function pointers. vptr = per-object pointer to its class's vtable.
- **Why it matters**: Understanding vtables explains virtual function performance, object layout, memory overhead, and why virtual calls in constructors behave unexpectedly.
- **Where used**: Every object of a class with virtual functions has a vptr. Vtables created by compiler for each class with virtual functions.
- **Why interviewers ask**: Tests deep understanding of how polymorphism works under the hood, memory layout, and the C++ object model.

## 2. Core Idea

**Intuition**: A vtable is like a restaurant menu (each class has its own listing of dishes). The vptr is like each customer's pointer to the menu.

**Small example**:

```
Animal object:    [ vptr -> Animal_vtable ]
Dog object:       [ vptr -> Dog_vtable ]

Animal_vtable: { Animal::speak, Animal::move }
Dog_vtable:    { Dog::speak, Dog::move }

Animal* a = new Dog();
a->speak();  // vptr -> Dog_vtable -> Dog::speak()
```

**Step-by-step**:
1. Compiler creates vtable for each class with virtual functions at compile time
2. Each object gets a vptr (typically first 8 bytes) set by the constructor
3. a->speak(): load vptr from object -> index to speak slot in vtable -> call function pointer

## 3. Important Subtopics

### Vtable Layout (Itanium C++ ABI)

```
┌──────────────────────┐
│ offset_to_top        │  (this pointer adjustment)
│ typeinfo ptr         │  (for dynamic_cast, typeid)
│ virtual func #0      │──► implementation
│ virtual func #1      │──► implementation
│ ...                  │
│ virtual func #N      │
└──────────────────────┘
```

### Vptr During Construction

vptr changes as each constructor runs: Base_vtable -> Derived_vtable. This is why virtual calls in constructors use the base version — the vtable for derived part hasn't been set up yet.

### Multiple Inheritance

Multiple vptrs (one per base with virtual functions). Compiler generates thunks to adjust this pointer when calling derived overrides through non-primary bases.

## 4. Common Interview Questions

**Q1: What is a vtable?**
**Answer**: Per-class table of function pointers. One per class, shared by all objects of that class. Created at compile time by the compiler.

**Q2: What is a vptr?**
**Answer**: Per-object pointer to its class's vtable. Typically the first 8 bytes of the object in memory.

**Q3: How does the compiler resolve a virtual call?**
**Answer**: load vptr from object -> index by function offset (known at compile time) -> call function pointer. O(1), two loads + one indirect call.

**Q4: How does vptr change during construction?**
**Answer**: Set to base vtable before base constructor body. Updated to derived vtable before derived constructor body. Virtual calls in base ctor use base vtable.

**Q5: Memory overhead of vtables?**
**Answer**: 8 bytes per object (vptr on 64-bit) + vtable per class (N x 8 bytes for N virtual functions + metadata).

**Q6: Multiple inheritance vtable?**
**Answer**: Multiple vptrs, one per base with virtuals. Thunks adjust this pointer for non-primary bases.

**Q7: static_cast vs dynamic_cast and vtable?**
**Answer**: static_cast = compile-time pointer adjustment. dynamic_cast = runtime check using vtable's typeinfo pointer.

**Q8: Can you access vtable directly?**
**Answer**: Not in standard C++. It's an implementation detail. Non-portable UB hacks exist but never use in production.

**Q9: Virtual inheritance and vtable?**
**Answer**: Vtable stores virtual base offsets (runtime-determined base locations). Adds more entries to the vtable.

**Q10: noexcept on virtual function effect on vtable?**
**Answer**: noexcept is part of function type contract. Doesn't affect vtable entry itself (still a function pointer).

## 5. Comparison Tables

| Aspect | vtable | vptr |
|--------|--------|------|
| What | Table of function pointers | Pointer to vtable |
| Scope | Per class | Per object |
| Storage | Code/data segment | Object's memory |
| Size | N x 8 bytes (N = virtual funcs) | 8 bytes (64-bit) |
| Created by | Compiler (compile time) | Constructor (runtime) |
| Shared? | Yes — all objects of class share | No — each object has its own |

## 6. Final Cheat Sheet

```
VTABLE/VPTR — Implementation of virtual function dispatch.

vtable:  Per-class table of function pointers. Created by compiler.
vptr:    Per-object pointer to vtable. First 8 bytes of object.

Dispatch: load vptr -> index vtable -> call function pointer. O(1).
Overhead: 8 bytes per object + vtable (N x 8 bytes) per class.

Key facts:
  - vptr changes during construction (base -> derived)
  - Multiple inheritance = multiple vptrs + thunks
  - final enables devirtualization (direct call, no vtable)
  - vtable is ABI — adding virtual functions breaks binary compatibility

Most asked:
  Q: What is vtable?                          → Per-class function pointer table.
  Q: What is vptr?                            → Per-object pointer to vtable.
  Q: How does virtual dispatch work?          → vptr -> vtable -> function.
  Q: Why does vptr change during ctor?        → Only base vtable is ready.
  Q: Multiple inheritance vtable?             → Multiple vptrs, thunks.
```

---

# Overall C++ OOP Quick Reference

## Key Relationships

| Concept | Purpose | Key Keyword | When Generated |
|---------|---------|-------------|----------------|
| Constructor | Initialize object | Class name | On object creation |
| Destructor | Cleanup resources | ~Class | On object destruction |
| Copy Constructor | Copy object | T(const T&) | Copy init (suppressed by move) |
| Copy Assignment | Assign existing | operator= | Copy assign (suppressed by move) |
| Move Constructor | Steal resources | T(T&&) | Move init (suppressed by dtor/copy) |
| Move Assignment | Steal and assign | operator=(T&&) | Move assign (suppressed by dtor/copy) |
| Virtual Function | Runtime dispatch | virtual | Explicit declaration |
| Pure Virtual | Interface contract | = 0 | Explicit declaration |
| vtable | Dispatch table | (Compiler) | Per class with virtuals |
| vptr | Dispatch pointer | (Compiler) | Per object with virtuals |

## Rule of Five Cheat Sheet

```
If you write any of these, you almost certainly need all five:

1. Destructor         ~T()
2. Copy Constructor   T(const T&)
3. Copy Assignment    T& operator=(const T&)
4. Move Constructor   T(T&&) noexcept
5. Move Assignment    T& operator=(T&&) noexcept

RULE OF ZERO (preferred): Don't write any of them.
Use RAII wrappers (std::string, std::vector, std::unique_ptr).
```

## Interview Quick-Fire Answers

| Question | One-Line Answer |
|----------|----------------|
| What is a constructor? | Special function that initializes objects, called on creation. |
| Why explicit constructors? | Prevent implicit conversions that cause subtle bugs. |
| What is a destructor? | Special function that releases resources, called on destruction. |
| Why virtual destructor? | Ensures correct cleanup when deleting derived through base pointer. |
| Shallow vs deep copy? | Shallow copies pointer; deep allocates new memory and copies content. |
| Copy vs move constructor? | Copy duplicates; move steals resources (source left valid but empty). |
| Why noexcept on move? | So std::vector moves during reallocation instead of copying. |
| What is a virtual function? | Function resolved at runtime based on actual object type. |
| What is a pure virtual function? | = 0 makes class abstract, forces derived classes to override. |
| What is a vtable? | Per-class table of function pointers implementing virtual dispatch. |
| What is a vptr? | Per-object pointer to its class's vtable, typically first 8 bytes. |
| Virtual in constructor? | Resolves to currently-constructing class, not most-derived. |
| Rule of Five? | If you need one of dtor/copy/move, you need all five. |
| Rule of Zero? | Prefer RAII wrappers so compiler generates correct special members. |

---

*Created for SDE placement preparation. Practice each concept by writing code, not just reading theory.*
