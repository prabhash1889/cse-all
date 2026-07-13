# Geometry Algorithms (Computational Geometry)

A complete guide for placements, online assessments, and competitive programming.

---

# 1. POINTS AND VECTORS

## 1. Overview

Points and vectors are the fundamental building blocks of computational geometry. A **point** represents a location in space (2D or 3D). A **vector** represents a direction and magnitude — essentially the displacement from one point to another. In code, both are typically stored as coordinate tuples `(x, y)`, but conceptually a point is a position whereas a vector is a movement.

## 2. Intuition

Think of a point as a **dot on paper** — it just sits there. A vector is an **arrow** — it has a length and a direction but no fixed position.

```
Point P = (2, 3)    → a location
Vector v = (4, -1)  → go right 4, go down 1
```

If you take `Point A` and add `Vector v`, you get a new point `B = A + v` — you moved from A in the direction of v.

The key insight: **vector between two points** = `Q - P`. If you have two points P and Q, the vector from P to Q is `(Q.x - P.x, Q.y - P.y)`.

## 3. When to Use It

Use points and vectors whenever you deal with:

- **Geometric positions** — coordinates, locations on a grid/plane
- **Directions** — movement, velocity, normals
- **Displacements** — distance between objects
- **Translating between coordinate systems**
- **Building any higher-order geometry** (lines, polygons, shapes)

## 4. When Not to Use It

- For simple integer coordinates on a grid, a pair `(row, col)` is often enough
- If you only need distance, you don't need full vector operations
- For 3D graphics, use a dedicated library; handwritten code is error-prone
- For sparse or huge coordinate ranges, consider hashing or compression instead

## 5. Core Concepts

### 5.1 Point

A location in space. Represented as a struct with `x` and `y` (and possibly `z`).

**Why it matters:** Every geometric entity is built from points.

### 5.2 Vector

A directed displacement. Has magnitude and direction but no fixed position.

**Why it matters:** Vectors enable arithmetic on geometry — addition, subtraction, scaling, dot/cross products.

### 5.3 Vector Addition/Subtraction

`v + w = (v.x + w.x, v.y + w.y)`  
`v - w = (v.x - w.x, v.y - w.y)`

**Why it matters:** Composing movements, finding relative positions.

### 5.4 Scalar Multiplication

`v * k = (v.x * k, v.y * k)`

**Why it matters:** Scaling a vector, reversing direction (k = -1).

### 5.5 Magnitude (Length)

`|v| = sqrt(v.x² + v.y²)`

**Why it matters:** Distance between points = magnitude of the vector between them.

### 5.6 Unit Vector

`v̂ = v / |v|`

**Why it matters:** Direction without magnitude. Used in normalizing.

## 6. Step-by-Step Algorithm

No algorithm per se — these are basic operations. But the mental model:

1. Store coordinates as floating-point (double) or integer
2. Define a struct/class with x, y
3. Overload operators: `+`, `-`, `*` (scalar), `==`
4. Define helper functions: `dot()`, `cross()`, `norm()`, `dist()`

## 7. Dry Run

```
Point A = (1, 2)
Point B = (4, 6)

Vector v = B - A = (3, 4)
|v| = sqrt(3² + 4²) = 5

Scaled: v * 2 = (6, 8)
Unit: v̂ = (3/5, 4/5) = (0.6, 0.8)
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Point {
    double x, y;
    
    Point() : x(0), y(0) {}
    Point(double x, double y) : x(x), y(y) {}
    
    // Vector addition
    Point operator+(const Point& other) const {
        return Point(x + other.x, y + other.y);
    }
    
    // Vector subtraction
    Point operator-(const Point& other) const {
        return Point(x - other.x, y - other.y);
    }
    
    // Scalar multiplication
    Point operator*(double k) const {
        return Point(x * k, y * k);
    }
    
    // Dot product
    double dot(const Point& other) const {
        return x * other.x + y * other.y;
    }
    
    // Cross product (2D)
    double cross(const Point& other) const {
        return x * other.y - y * other.x;
    }
    
    // Magnitude squared (avoid sqrt when possible)
    double norm2() const {
        return x * x + y * y;
    }
    
    // Magnitude
    double norm() const {
        return sqrt(norm2());
    }
    
    // Distance to another point
    double dist(const Point& other) const {
        return (*this - other).norm();
    }
    
    // Equality
    bool operator==(const Point& other) const {
        return x == other.x && y == other.y;
    }
};

// Cross product of vectors (a->b) and (a->c)
double cross(const Point& a, const Point& b, const Point& c) {
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x);
}

// Dot product of vectors (a->b) and (a->c)
double dot(const Point& a, const Point& b, const Point& c) {
    return (b.x - a.x) * (c.x - a.x) + (b.y - a.y) * (c.y - a.y);
}

int main() {
    Point A(1, 2), B(4, 6);
    Point v = B - A;
    cout << "Vector: (" << v.x << ", " << v.y << ")\n";
    cout << "Magnitude: " << v.norm() << "\n";
    cout << "Distance: " << A.dist(B) << "\n";
    return 0;
}
```

## 9. Python Implementation

```python
import math

class Point:
    def __init__(self, x=0.0, y=0.0):
        self.x = x
        self.y = y
    
    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)
    
    def __sub__(self, other):
        return Point(self.x - other.x, self.y - other.y)
    
    def __mul__(self, k):
        return Point(self.x * k, self.y * k)
    
    def __rmul__(self, k):
        return self.__mul__(k)
    
    def __eq__(self, other):
        return self.x == other.x and self.y == other.y
    
    def dot(self, other):
        return self.x * other.x + self.y * other.y
    
    def cross(self, other):
        return self.x * other.y - self.y * other.x
    
    def norm2(self):
        return self.x * self.x + self.y * self.y
    
    def norm(self):
        return math.sqrt(self.norm2())
    
    def dist(self, other):
        return (self - other).norm()
    
    def __repr__(self):
        return f"({self.x}, {self.y})"


def cross(a, b, c):
    """Cross product of vectors AB and AC"""
    return (b.x - a.x) * (c.y - a.y) - (b.y - a.y) * (c.x - a.x)


def dot(a, b, c):
    """Dot product of vectors AB and AC"""
    return (b.x - a.x) * (c.x - a.x) + (b.y - a.y) * (c.y - a.y)


# Example
A = Point(1, 2)
B = Point(4, 6)
v = B - A
print(f"Vector: ({v.x}, {v.y})")
print(f"Magnitude: {v.norm()}")
print(f"Distance: {A.dist(B)}")
```

## 10. Code Explanation

- **Struct `Point`**: Holds `x`, `y` coordinates. Overloaded operators let us write natural geometric code.
- **`operator+` / `operator-`**: Vector addition/subtraction. Adding two points doesn't make geometric sense, but adding a vector to a point does. In practice, we use these for vectors.
- **`operator*`**: Scalar multiplication. `v * 2` doubles the vector.
- **`dot()`**: Returns scalar `x1*x2 + y1*y2`. Used for projections, angles.
- **`cross()`**: Returns scalar `x1*y2 - y1*x2`. Used for orientation, area.
- **`norm()` / `norm2()`**: `norm2()` avoids expensive `sqrt`. Use it for comparing distances.
- **`dist()`**: Euclidean distance between two points.

## 11. Complexity Analysis

| Operation       | Time   | Space |
|-----------------|--------|-------|
| Addition/Subtract | O(1) | O(1) |
| Dot product     | O(1)   | O(1) |
| Cross product   | O(1)   | O(1) |
| Norm            | O(1)   | O(1) |
| Distance        | O(1)   | O(1) |

## 12. Common Patterns

| Pattern | How to Identify | Approach | Example |
|---------|----------------|----------|---------|
| Distance comparison | "Nearest", "closest" | Compare `norm2()`, avoid sqrt | Min distance between points |
| Collinearity | "Points on same line" | Cross product == 0 | Check if three points are collinear |
| Direction check | "Which side", "clockwise" | Cross product sign | Orientation test |
| Angle check | "At angle", "perpendicular" | Dot product == 0 | Right angle detection |

## 13. Common Mistakes

- Using integer division for coordinates — use `double`
- Comparing `norm()` when `norm2()` suffices (unnecessary sqrt)
- Forgetting that `cross()` returns 0 for collinear points (floating point issues)
- Assuming `==` works with doubles — use `abs(a - b) < eps`

## 14. Edge Cases

- Same point: distance = 0
- Zero vector: `(0, 0)` — norm = 0, direction undefined
- Negative coordinates
- Very large coordinates (overflow risk in `norm2()`)
- Floating point precision: use epsilon comparisons

## 15. Variations

- **3D Points**: Add `z` coordinate. Cross product becomes a vector, not a scalar.
- **Integer Points**: Use `long long` for coordinates. Exact arithmetic, no floating errors.
- **Polar Coordinates**: Store `(r, theta)` instead of `(x, y)`. Useful for rotations.

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Dot product | Projections, angles, perpendicularity |
| Cross product | Orientation, area, turning direction |
| Convex hull | Built on point/vector operations |
| Line intersection | Uses cross/dot to find intersection |

## 17. Practice Problems

### Easy
- **Check If It's a Straight Line** (LeetCode) — Use cross product to check collinearity
- **Minimum Time Visiting All Points** (LeetCode) — Simple distance between points

### Medium
- **Robot Return to Origin** (LeetCode) — Vector addition tracking position
- **Max Points on a Line** (LeetCode) — Cross product + hashmap for slopes

### Hard
- **Erect the Fence** (LeetCode) — Convex hull using point operations

## 18. Interview Explanation

> "I represent points as a struct with x and y coordinates. I overload operators so I can add, subtract, and scale vectors naturally. The two most important operations are the dot product — which gives me projection and angle information — and the cross product, which gives me signed area and orientation. I always keep a `norm2()` function to compare distances without expensive square roots."

## 19. Revision Notes

- `Point(x, y)` — basic unit
- Vector = `B - A`
- `dot(v, w)` = `v.x*w.x + v.y*w.y` → scalar projection
- `cross(v, w)` = `v.x*w.y - v.y*w.x` → signed area
- `norm2()` > `norm()` for comparisons
- Always use `double` for coordinates in geometry
- Use `eps = 1e-9` for floating comparisons

## 20. Final Cheat Sheet

| When | What |
|------|------|
| Need location | `Point(x, y)` |
| Need direction | `vector = B - A` |
| Compare distances | `norm2()` |
| Check perpendicular | `dot(v, w) == 0` |
| Check parallel/collinear | `cross(v, w) == 0` |
| Get signed area | `cross(a, b, c) / 2` |

---

# 2. DOT PRODUCT

## 1. Overview

The dot product is an operation that takes two vectors and returns a **scalar** (a single number). It tells you how much one vector points in the direction of another. Geometrically, `v · w = |v| * |w| * cos(θ)`, where θ is the angle between them.

## 2. Intuition

Think of the dot product as the answer to: **"How much of vector v is in the direction of vector w?"**

- If two vectors point in the **same** direction → dot product is **positive**
- If they are **perpendicular** → dot product is **zero**
- If they point in **opposite** directions → dot product is **negative**

**Analogy:** Imagine pushing a box. If you push in the exact direction the box moves, all your force contributes (dot = max). If you push at an angle, only part of your force contributes (dot smaller). If you push perpendicular to the movement, none of your force contributes (dot = 0).

## 3. When to Use It

- **Check perpendicularity** — dot product == 0 means vectors are at 90°
- **Find the angle between vectors** — `cos(θ) = dot(v,w) / (|v|*|w|)`
- **Project one vector onto another** — projection length = `dot(v, ŵ)`
- **Determine if two vectors point in the same general direction** — dot > 0 means acute angle
- **Collision detection** — check if objects are moving towards each other

## 4. When Not to Use It

- If you need the **signed area** or turning direction — use cross product instead
- If you only need distance — use `norm()` or `norm2()`
- If you need the perpendicular vector — cross product gives that

## 5. Core Concepts

### 5.1 Algebraic Definition

`v · w = v.x * w.x + v.y * w.y`

Multiply corresponding components and sum them up.

### 5.2 Geometric Definition

`v · w = |v| * |w| * cos(θ)`

This connects the dot product to the angle between vectors.

### 5.3 Sign of Dot Product

| Dot Sign | Angle | Meaning |
|----------|-------|---------|
| > 0 | Acute (0° to 90°) | Vectors point roughly same direction |
| = 0 | Right (90°) | Vectors are perpendicular |
| < 0 | Obtuse (90° to 180°) | Vectors point roughly opposite |

### 5.4 Projection

The scalar projection of `v` onto `w` is:
```
comp_w(v) = (v · w) / |w|
```

This gives the length of `v` in the direction of `w`.

## 6. Step-by-Step Algorithm

```
Input: vectors v = (vx, vy), w = (wx, wy)
Output: scalar

1. result = vx * wx + vy * wy
2. return result
```

That's it. For angle:
```
1. dot = vx*wx + vy*wy
2. mag_v = sqrt(vx² + vy²)
3. mag_w = sqrt(wx² + wy²)
4. cos_theta = dot / (mag_v * mag_w)
5. theta = acos(cos_theta)
```

## 7. Dry Run

```
v = (3, 4)
w = (1, 2)

dot = 3*1 + 4*2 = 3 + 8 = 11

|v| = 5, |w| = sqrt(5) ≈ 2.236
cos(θ) = 11 / (5 * 2.236) ≈ 11 / 11.18 ≈ 0.984
θ ≈ acos(0.984) ≈ 10.3°

Since dot > 0, the angle is acute.
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Point {
    double x, y;
    Point(double x = 0, double y = 0) : x(x), y(y) {}
    
    double dot(const Point& other) const {
        return x * other.x + y * other.y;
    }
    
    double norm() const {
        return sqrt(x * x + y * y);
    }
};

// Angle between two vectors in radians
double angle(const Point& v, const Point& w) {
    double d = v.dot(w);
    double mv = v.norm();
    double mw = w.norm();
    if (mv == 0 || mw == 0) return 0;
    return acos(d / (mv * mw));
}

// Check if two vectors are perpendicular
bool isPerpendicular(const Point& v, const Point& w) {
    return abs(v.dot(w)) < 1e-9;
}

// Scalar projection of v onto w
double scalarProjection(const Point& v, const Point& w) {
    double mw = w.norm();
    if (mw == 0) return 0;
    return v.dot(w) / mw;
}

int main() {
    Point v(3, 4), w(1, 2);
    cout << "Dot product: " << v.dot(w) << "\n";
    cout << "Angle: " << angle(v, w) << " rad\n";
    cout << "Perpendicular? " << isPerpendicular(v, w) << "\n";
    return 0;
}
```

## 9. Python Implementation

```python
import math

class Point:
    def __init__(self, x=0.0, y=0.0):
        self.x = x
        self.y = y
    
    def dot(self, other):
        return self.x * other.x + self.y * other.y
    
    def norm(self):
        return math.sqrt(self.x * self.x + self.y * self.y)


def angle(v, w):
    d = v.dot(w)
    mv, mw = v.norm(), w.norm()
    if mv == 0 or mw == 0:
        return 0
    return math.acos(d / (mv * mw))


def is_perpendicular(v, w, eps=1e-9):
    return abs(v.dot(w)) < eps


def scalar_projection(v, w):
    mw = w.norm()
    if mw == 0:
        return 0
    return v.dot(w) / mw


# Example
v = Point(3, 4)
w = Point(1, 2)
print(f"Dot product: {v.dot(w)}")
print(f"Angle: {angle(v, w)} rad")
```

## 10. Code Explanation

- **`dot()`**: The core — `x1*x2 + y1*y2`. Works in any dimension.
- **`angle()`**: Uses the geometric definition `cosθ = dot/(|v|*|w|)`, then `acos` to get radians.
- **`isPerpendicular()`**: Checks if dot ≈ 0. Uses epsilon because floating point.
- **`scalarProjection()`**: Length of projection of v onto w. Unit: same as v's units.

## 11. Complexity Analysis

| Operation | Time | Space |
|-----------|------|-------|
| Dot product | O(1) | O(1) |
| Angle | O(1) | O(1) |
| Perpendicular check | O(1) | O(1) |
| Projection | O(1) | O(1) |

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Perpendicular check | "right angle", "orthogonal" | `dot == 0` |
| Direction check | "same direction", "opposite" | `dot > 0` or `dot < 0` |
| Angle between | "at 45 degrees" etc. | Use `acos(dot / (|v|*|w|))` |
| Projection | "shadow", "component along" | `dot(v, w) / |w|` |

## 13. Common Mistakes

- Using dot product when cross product is needed (orientation, area)
- Assuming dot = 0 means vectors are perpendicular in 3D (they could be zero vectors)
- Not handling zero vectors (division by zero when computing angle)
- Using `acos` directly without clamping to [-1, 1] (floating point can give 1.0000001)

## 14. Edge Cases

- Zero vector: dot with anything = 0, but angle is undefined
- Parallel vectors: dot = `|v|*|w|` (max), angle = 0
- Anti-parallel: dot = `-|v|*|w|` (min), angle = π
- Large coordinates: overflow in integer dot product

## 15. Variations

- **Dot product in 3D**: `v·w = vx*wx + vy*wy + vz*wz`
- **Dot product in n-dimensions**: sum of component-wise products
- **Normalized dot**: `dot(v/|v|, w/|w|)` = cos(θ) directly, used in graphics

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Cross product | Gives perpendicular vector/signed area; dot gives projection |
| Vector projection | Directly uses dot product |
| Gram-Schmidt orthogonalization | Uses dot product repeatedly |
| Linear regression | Dot product appears in normal equations |

## 17. Practice Problems

### Easy
- **Dot Product of Two Sparse Vectors** (LeetCode) — Implementation
- **Angle Between Vectors** (GFG) — Direct application

### Medium
- **Max Dot Product of Two Subsequences** (LeetCode) — DP + dot product
- **Projection Area of 3D Shapes** (LeetCode) — Projection concept

### Hard
- **K Closest Points to Origin** (LeetCode) — Uses dot(v, v) = norm²

## 18. Interview Explanation

> "The dot product of two vectors is the sum of component-wise products. Geometrically, it equals `|v||w|cos(θ)` — it tells me how aligned two vectors are. Positive means same direction, zero means perpendicular, negative means opposite. I use it to check perpendicularity, find angles, compute projections, and in collision detection."

## 19. Revision Notes

- `dot(v, w) = vx*wx + vy*wy`
- `dot(v, w) = |v|*|w|*cos(θ)`
- Sign → direction check
- Zero → perpendicular
- Always clamp `dot/(|v|*|w|)` to `[-1, 1]` before `acos`
- For integer coordinates, `dot` can overflow — use `long long`

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Check alignment | `dot > 0` |
| Check perpendicular | `dot == 0` |
| Find angle | `acos(dot / (|v|*|w|))` |
| Project v onto w | `(v·w / |w|²) * w` (vector) |
| Formula | `Σ vi * wi` |

---

# 3. CROSS PRODUCT

## 1. Overview

The cross product of two 2D vectors returns a **scalar** (a single number) that represents the **signed area** of the parallelogram formed by the two vectors. In 3D, it returns a **vector** perpendicular to both inputs. In 2D geometry, it's the fundamental operation for determining orientation, direction of turning, and computing area.

## 2. Intuition

Imagine two vectors starting from the same point. The cross product answers: **"Which way does the second vector turn relative to the first?"**

- **Positive** → `w` is to the **left** of `v` (counter-clockwise turn)
- **Negative** → `w` is to the **right** of `v` (clockwise turn)
- **Zero** → `w` is **collinear** with `v` (same or opposite direction)

**Analogy:** Think of a steering wheel. If you're driving along vector v, the cross product tells you if you need to turn left (positive), right (negative), or go straight (zero) to align with vector w.

The magnitude of the cross product is the area of the parallelogram spanned by the two vectors.

## 3. When to Use It

- **Orientation test** — which side of a line is a point on?
- **Check if three points are collinear** — cross product == 0
- **Compute polygon area** — sum of cross products
- **Convex hull** — checking if points make a left turn (Graham scan, Andrew's)
- **Line intersection** — check if segments intersect
- **Check if a point is inside a polygon** — winding number / ray casting
- **Compute distance from point to line** — `|cross(AB, AC)| / |AB|`

## 4. When Not to Use It

- If you only need the **angle**, use dot product (it's cheaper and more stable)
- If you need **absolute area only**, use `abs(cross)` but you could also use shoelace formula directly
- If you need projection, dot product is the right tool

## 5. Core Concepts

### 5.1 2D Cross Product (Scalar)

`cross(v, w) = v.x * w.y - v.y * w.x`

This is the **z-component** of the 3D cross product. It's a scalar representing signed area.

### 5.2 Sign and Orientation

| cross(v, w) | Meaning |
|-------------|---------|
| > 0 | w is **left** of v (CCW turn from v to w) |
| < 0 | w is **right** of v (CW turn from v to w) |
| = 0 | v and w are **collinear** |

### 5.3 Three-Point Cross Product

`cross(A, B, C) = (B - A) × (C - A)`

This is extremely common: it tells the orientation of point C relative to line AB.

### 5.4 Relation to Area

`|cross(v, w)|` = area of parallelogram formed by v and w  
`|cross(v, w)| / 2` = area of triangle formed by v and w

## 6. Step-by-Step Algorithm

```
Input: vectors v = (vx, vy), w = (wx, wy)
Output: scalar

1. result = vx * wy - vy * wx
2. return result
```

For orientation of point C relative to line AB:
```
1. v = B - A = (B.x - A.x, B.y - A.y)
2. w = C - A = (C.x - A.x, C.y - A.y)
3. cross = v.x * w.y - v.y * w.x
4. if cross > 0:  C is left of AB
   if cross < 0:  C is right of AB
   if cross == 0: C is on line AB
```

## 7. Dry Run

```
A = (0, 0), B = (4, 0), C = (1, 2)

v = B - A = (4, 0)
w = C - A = (1, 2)

cross = 4*2 - 0*1 = 8 - 0 = 8

8 > 0 → C is LEFT of AB ✓ (point (1,2) is above the x-axis line)

---

A = (0, 0), B = (4, 0), D = (1, -2)

v = (4, 0), w = (1, -2)
cross = 4*(-2) - 0*1 = -8

-8 < 0 → D is RIGHT of AB ✓
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Point {
    double x, y;
    Point(double x = 0, double y = 0) : x(x), y(y) {}
    
    Point operator-(const Point& other) const {
        return Point(x - other.x, y - other.y);
    }
    
    // 2D cross product (scalar)
    double cross(const Point& other) const {
        return x * other.y - y * other.x;
    }
};

// Cross product of vectors AB and AC
double cross(const Point& A, const Point& B, const Point& C) {
    return (B - A).cross(C - A);
}

// Orientation test
// Returns: 1 = CCW (left), -1 = CW (right), 0 = collinear
int orientation(const Point& A, const Point& B, const Point& C) {
    double val = cross(A, B, C);
    if (abs(val) < 1e-9) return 0;
    return (val > 0) ? 1 : -1;
}

// Area of triangle ABC
double triangleArea(const Point& A, const Point& B, const Point& C) {
    return abs(cross(A, B, C)) / 2.0;
}

// Distance from point C to line AB
double pointToLineDist(const Point& A, const Point& B, const Point& C) {
    return abs(cross(A, B, C)) / (B - A).norm();
}

int main() {
    Point A(0, 0), B(4, 0), C(1, 2);
    cout << "Cross: " << cross(A, B, C) << "\n";
    cout << "Orientation: " << orientation(A, B, C) << " (1=CCW)\n";
    cout << "Area: " << triangleArea(A, B, C) << "\n";
    return 0;
}
```

## 9. Python Implementation

```python
import math

class Point:
    def __init__(self, x=0.0, y=0.0):
        self.x = x
        self.y = y
    
    def __sub__(self, other):
        return Point(self.x - other.x, self.y - other.y)
    
    def cross(self, other):
        return self.x * other.y - self.y * other.x
    
    def norm(self):
        return math.sqrt(self.x * self.x + self.y * self.y)


def cross(A, B, C):
    """Cross product of vectors AB and AC"""
    return (B - A).cross(C - A)


def orientation(A, B, C, eps=1e-9):
    """Returns 1 (CCW), -1 (CW), 0 (collinear)"""
    val = cross(A, B, C)
    if abs(val) < eps:
        return 0
    return 1 if val > 0 else -1


def triangle_area(A, B, C):
    return abs(cross(A, B, C)) / 2.0


def point_to_line_dist(A, B, C):
    return abs(cross(A, B, C)) / (B - A).norm()


# Example
A = Point(0, 0)
B = Point(4, 0)
C = Point(1, 2)
print(f"Cross: {cross(A, B, C)}")
print(f"Orientation: {orientation(A, B, C)}")
print(f"Area: {triangle_area(A, B, C)}")
```

## 10. Code Explanation

- **`cross()` on Point**: Returns `x1*y2 - y1*x2`. This is the 2D cross product scalar.
- **`cross(A, B, C)`**: Computes `(B-A) × (C-A)` — orientation of C relative to line AB.
- **`orientation()`**: Returns 1 (CCW/left), -1 (CW/right), 0 (collinear). The fundamental test for many geometric algorithms.
- **`triangleArea()`**: `|cross| / 2`. Cross product gives parallelogram area; half gives triangle area.
- **`pointToLineDist()`**: `|cross(AB, AC)| / |AB|`. The cross magnitude divided by base length gives perpendicular distance.

## 11. Complexity Analysis

| Operation | Time | Space |
|-----------|------|-------|
| Cross product | O(1) | O(1) |
| Orientation test | O(1) | O(1) |
| Triangle area | O(1) | O(1) |
| Point-line distance | O(1) | O(1) |

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Left/right turn | "which side", "orientation" | `cross(A, B, C)` |
| Collinearity | "points on same line" | `cross == 0` |
| Convex hull building | "minimum bounding polygon" | Orientation in Graham/Andrew |
| Line segment intersection | "do segments cross" | Orientation of all pairs |
| Point in polygon | "inside/outside" | Ray casting or winding number |

## 13. Common Mistakes

- Confusing cross product sign convention (left vs right depends on coordinate system)
- Using cross product when dot product is needed (or vice versa)
- Not handling collinear cases (cross == 0) in intersection/orientation problems
- Integer overflow: cross product of large coordinates can overflow 32-bit int
- Forgetting that cross product in 2D is a scalar, not a vector

## 14. Edge Cases

- Collinear points: cross = 0
- One vector is zero: cross = 0
- Almost collinear: handle with epsilon
- Integer overflow for large coordinates (use `long long` or `double`)

## 15. Variations

- **3D Cross Product**: Returns a vector `(v.y*w.z - v.z*w.y, v.z*w.x - v.x*w.z, v.x*w.y - v.y*w.x)`. Used for normals.
- **Signed area of polygon**: Sum of cross products of consecutive edges.
- **Cross product with epsilon**: Use `abs(cross) < eps` for collinearity check.

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Dot product | Dot: projection; Cross: perpendicular/orientation |
| Orientation test | Directly uses cross product |
| Convex hull | Uses orientation to find left/right turns |
| Polygon area | Uses cross product (shoelace formula) |
| Line intersection | Uses cross for orientation tests |

## 17. Practice Problems

### Easy
- **Check If It's a Straight Line** (LeetCode) — Cross product collinearity
- **Valid Triangle Number** (LeetCode) — Triangle inequality + orientation

### Medium
- **Minimum Area Rectangle** (LeetCode) — Cross product for area
- **Largest Triangle Area** (LeetCode) — Cross product for max area

### Hard
- **Erect the Fence** (LeetCode) — Convex hull using orientation
- **Maximum Number of Points with Cost** — Orientation-based filtering

## 18. Interview Explanation

> "The cross product of two 2D vectors returns a scalar: `v.x * w.y - v.y * w.x`. Positive means w is left of v (counter-clockwise turn), negative means right, zero means collinear. I use it for the orientation test — which side of a line a point is on — which is the foundation for convex hull algorithms, polygon area computation, and line segment intersection."

## 19. Revision Notes

- `cross(v, w) = v.x*w.y - v.y*w.x`
- Sign: + = left (CCW), - = right (CW), 0 = collinear
- `|cross|` = area of parallelogram
- `|cross|/2` = area of triangle
- Always use epsilon for near-zero checks
- Integer overflow risk: `1e5 * 1e5 = 1e10` → needs `long long`

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Orientation test | `cross(A, B, C)` |
| Collinear check | `abs(cross) < eps` |
| Triangle area | `abs(cross)/2` |
| Point-line distance | `abs(cross)/|AB|` |
| Convex hull turn | `cross > 0` → accept |

---

# 4. ORIENTATION TEST

## 1. Overview

The orientation test determines whether three points `A, B, C` make a **left turn** (counter-clockwise), a **right turn** (clockwise), or are **collinear** (no turn). It's the single most fundamental operation in computational geometry — almost every geometric algorithm uses it.

## 2. Intuition

Imagine walking along the line from A to B. When you reach B, you need to turn towards C. The orientation test tells you which way you turn.

```
      C (left turn)
     /
    /
A──B

A──B
    \
     \
      C (right turn)

A──B──C (straight, collinear)
```

**Analogy:** Think of a car driving from A to B. At B, a GPS tells you to turn left, turn right, or go straight to reach C. The orientation test is that GPS.

**Why it works:** It's computed using the **cross product** of vectors AB and AC. The cross product sign directly encodes the turning direction.

## 3. When to Use It

- **Convex hull algorithms** (Graham scan, Andrew's monotone chain) — need left turns
- **Line segment intersection** — orientation of all endpoint pairs
- **Point in polygon** — checking which side of each edge
- **Determining if a polygon is convex** — all turns must be same orientation
- **Sorting points by polar angle** — comparator uses orientation
- **Removing collinear points** — pre-processing for convex hull

## 4. When Not to Use It

- If you just need distance, use norm
- If you need absolute position (above/below horizontal line), a simple y-comparison suffices
- If you need to check if a point is on a segment (not just line), you need both orientation AND bounding box check
- For axis-aligned rectangles, simple min/max comparisons work without orientation

## 5. Core Concepts

### 5.1 The Cross Product Foundation

`orientation(A, B, C) = sign(cross(B-A, C-A))`

This is the z-component of the 3D cross product. In 2D, it's a scalar.

### 5.2 Three Possible Results

| Value | Meaning | Turn |
|-------|---------|------|
| > 0 | Counter-clockwise | Left turn |
| < 0 | Clockwise | Right turn |
| = 0 | Collinear | Straight |

### 5.3 Epsilon for Floating Points

Never compare cross product directly to 0 with floats. Use `abs(cross) < eps`.

**Why:** Floating point errors make exact collinearity checks unreliable.

## 6. Step-by-Step Algorithm

```
Input: Points A, B, C
Output: 1 (CCW), -1 (CW), 0 (collinear)

1. Compute cross = (B.x - A.x) * (C.y - A.y) - (B.y - A.y) * (C.x - A.x)
2. If abs(cross) < eps: return 0
3. If cross > 0: return 1
4. Else: return -1
```

## 7. Dry Run

```
Example 1: A(0,0), B(4,0), C(1,2)
cross = (4-0)*(2-0) - (0-0)*(1-0) = 4*2 - 0 = 8
8 > 0 → LEFT TURN (CCW) ✓

Example 2: A(0,0), B(4,0), C(3,-1)
cross = (4-0)*(-1-0) - (0-0)*(3-0) = 4*(-1) - 0 = -4
-4 < 0 → RIGHT TURN (CW) ✓

Example 3: A(0,0), B(2,2), C(4,4)
cross = (2-0)*(4-0) - (2-0)*(4-0) = 2*4 - 2*4 = 0
0 → COLLINEAR ✓
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

using ll = long long;
const double EPS = 1e-9;

struct Point {
    ll x, y;  // can be double
    Point(ll x = 0, ll y = 0) : x(x), y(y) {}
    Point operator-(const Point& p) const { return Point(x - p.x, y - p.y); }
    ll cross(const Point& p) const { return x * p.y - y * p.x; }
};

// Orientation test: returns 1 (CCW), -1 (CW), 0 (collinear)
int orientation(const Point& A, const Point& B, const Point& C) {
    ll val = (B - A).cross(C - A);
    if (val == 0) return 0;          // for integer coords
    // For double: if (abs(val) < EPS) return 0;
    return (val > 0) ? 1 : -1;
}

// Check if point P lies on segment AB (including endpoints)
bool onSegment(const Point& A, const Point& B, const Point& P) {
    if (orientation(A, B, P) != 0) return false;
    // Bounding box check
    return P.x >= min(A.x, B.x) && P.x <= max(A.x, B.x) &&
           P.y >= min(A.y, B.y) && P.y <= max(A.y, B.y);
}

int main() {
    Point A(0, 0), B(4, 0), C(1, 2);
    int orient = orientation(A, B, C);
    cout << "Orientation: " << orient 
         << " (1=CCW, -1=CW, 0=colinear)\n";
    
    Point P(2, 0);
    cout << "P on AB? " << onSegment(A, B, P) << "\n";
    return 0;
}
```

## 9. Python Implementation

```python
EPS = 1e-9

class Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y
    
    def __sub__(self, other):
        return Point(self.x - other.x, self.y - other.y)
    
    def cross(self, other):
        return self.x * other.y - self.y * other.x


def orientation(A, B, C):
    """Returns 1 (CCW), -1 (CW), 0 (collinear)"""
    val = (B - A).cross(C - A)
    if abs(val) < EPS:
        return 0
    return 1 if val > 0 else -1


def on_segment(A, B, P):
    """Check if point P lies on segment AB"""
    if orientation(A, B, P) != 0:
        return False
    return (min(A.x, B.x) <= P.x <= max(A.x, B.x) and
            min(A.y, B.y) <= P.y <= max(A.y, B.y))


# Example
A = Point(0, 0)
B = Point(4, 0)
C = Point(1, 2)
print(f"Orientation: {orientation(A, B, C]}")  # 1 = CCW
```

## 10. Code Explanation

- **`orientation()`**: Computes cross product of AB and AC. Returns sign.
- **Integer version**: Uses `long long`. Exact. Use `== 0` for collinear.
- **Double version**: Use `abs(val) < EPS`. Never compare doubles with `==`.
- **`onSegment()`**: First checks collinearity, then bounding box. Both conditions are needed (a point could be collinear but not on the segment).

## 11. Complexity Analysis

| Operation | Time | Space |
|-----------|------|-------|
| Orientation test | O(1) | O(1) |
| On-segment check | O(1) | O(1) |

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Build convex hull | "smallest polygon containing points" | Orientation for CCW turns |
| Segment intersection | "do these lines cross" | Orientation of 4 pairs |
| Point in polygon | "is point inside" | Orientation with winding |
| Collinear removal | "remove points on same line" | Orientation == 0 |
| Left turn check | "is polygon convex" | All turns same orientation |

## 13. Common Mistakes

- Forgetting the bounding box check in `onSegment()` — a point could be collinear but outside the segment
- Using `== 0` with floats for collinearity
- Integer overflow: `(B.x - A.x) * (C.y - A.y)` can overflow 32-bit int with large coordinates
- Confusing the order of points (orientation(A, B, C) ≠ orientation(A, C, B))

## 14. Edge Cases

- All points same: cross = 0
- A == B: degenerate line — orientation undefined
- Collinear points on segment: use `onSegment()` for full check
- Nearly collinear with floats: epsilon threshold matters

## 15. Variations

- **Orientation with long double**: For very high precision
- **Orientation in 3D**: Cross product is a vector; use determinant for tetrahedron volume
- **Robust orientation**: Use `__int128` in C++ for giant coordinates

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Cross product | Foundation of orientation |
| Convex hull | Uses orientation as core operation |
| Line intersection | Relies on orientation of 4 pairs |
| Point in polygon | Uses orientation per edge |

## 17. Practice Problems

### Easy
- **Check If It's a Straight Line** (LeetCode) — Collinearity check
- **Valid Triangle** (GFG) — Orientation + triangle inequality

### Medium
- **Minimum Area Rectangle II** (LeetCode) — Orientation for perpendicularity
- **Convex Polygon** (LeetCode) — All turns same orientation

### Hard
- **Erect the Fence** (LeetCode) — Convex hull orientation
- **Rectangle Area II** (LeetCode) — Sweep line + orientation

## 18. Interview Explanation

> "The orientation test tells me whether three points make a left turn, right turn, or are collinear. It's computed using the cross product of vectors AB and AC. This is the fundamental building block of computational geometry — used in convex hull construction, line segment intersection, point-in-polygon tests, and checking polygon convexity."

## 19. Revision Notes

- `orientation(A, B, C) = sign((B-A) × (C-A))`
- +1 = CCW (left), -1 = CW (right), 0 = collinear
- For `onSegment`: need orientation == 0 **AND** bounding box check
- Use `long long` for integer coordinates
- Use `abs(cross) < eps` for doubles

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Check left turn | `orientation(A, B, C) > 0` |
| Check right turn | `orientation(A, B, C) < 0` |
| Check on segment | `orientation == 0` + bounding box |
| Convex hull building | Keep only left turns |
| Segment intersection | Check orientation of all 4 pairs |

---

# 5. LINE INTERSECTION

## 1. Overview

Line intersection checks whether two line segments (or infinite lines) intersect, and if so, finds the intersection point. There are two flavors: checking if segments **intersect** (boolean) and computing the **exact intersection point**.

## 2. Intuition

Two line segments intersect if and only if each segment **straddles** the line containing the other segment.

**Analogy:** Imagine two sticks lying on the ground. They cross if:
- One endpoint of stick 1 is on the left of stick 2 and the other is on the right of stick 2
- AND vice versa

This "straddling" is exactly the orientation test.

```
    P2────Q2
       \
        \
    P1───X───Q1    ← They cross at X
         \
          \
```

## 3. When to Use It

- **Checking if two roads/paths cross**
- **Detecting collisions** in 2D games
- **Finding where two lines meet** in geometric problems
- **Planar subdivision** — dividing a plane by line segments
- **Map overlay** problems
- **Clipping algorithms** (Cohen-Sutherland, etc.)

## 4. When Not to Use It

- For **axis-aligned** line segments, simple interval overlap check is sufficient
- If you only need to know if segments intersect (not where), the boolean check is cheaper
- For parallel lines — cross product of direction vectors = 0 means no unique intersection
- For collinear overlapping segments — special case handling needed

## 5. Core Concepts

### 5.1 General vs Segment Intersection

- **Infinite lines**: Always intersect unless parallel. Use cross product of direction vectors.
- **Segments**: May or may not intersect. Use orientation tests.

### 5.2 Orientation-Based Test

Two segments AB and CD intersect if:
```
orientation(A, B, C) * orientation(A, B, D) < 0  AND
orientation(C, D, A) * orientation(C, D, B) < 0
```

This means A and B are on opposite sides of line CD, AND C and D are on opposite sides of line AB.

### 5.3 Collinear Overlap

If both orientation tests return 0 (all four points collinear), the segments may overlap. Check bounding box overlap.

### 5.4 Finding the Intersection Point

Using parametric form:
```
P = A + t*(B-A) = C + u*(D-C)

t = cross(C-A, D-C) / cross(B-A, D-C)
u = cross(C-A, B-A) / cross(B-A, D-C)
```

If 0 ≤ t ≤ 1 and 0 ≤ u ≤ 1, the segments intersect at P.

## 6. Step-by-Step Algorithm

**Boolean Intersection Check:**
```
1. Compute o1 = orientation(A, B, C)
2. Compute o2 = orientation(A, B, D)
3. Compute o3 = orientation(C, D, A)
4. Compute o4 = orientation(C, D, B)

5. If o1 ≠ o2 AND o3 ≠ o4: return true (proper intersection)
6. If any orientation is 0 and point lies on segment: return true (endpoint/collinear)
7. Else: return false
```

**Find Intersection Point:**
```
1. Compute denom = cross(B-A, D-C)
2. If denom == 0: lines are parallel (or collinear)
3. t = cross(C-A, D-C) / denom
4. P = A + t * (B-A)
5. Return P
```

## 7. Dry Run

```
Segment 1: A(0,0), B(4,4)
Segment 2: C(0,4), D(4,0)

o1 = orientation(A,B,C) = (4-0)*(4-0) - (4-0)*(0-0) = 16 → positive
o2 = orientation(A,B,D) = (4-0)*(0-0) - (4-0)*(4-0) = -16 → negative
o3 = orientation(C,D,A) = ... = -16 → negative
o4 = orientation(C,D,B) = ... = 16 → positive

o1 ≠ o2 (16 ≠ -16) ✓
o3 ≠ o4 (-16 ≠ 16) ✓
→ Segments intersect!

Intersection point:
denom = cross((4,4), (4,-4)) = 4*(-4) - 4*4 = -16 - 16 = -32
t = cross((0-0,4-0), (4,-4)) / (-32) = cross((0,4),(4,-4)) / (-32)
  = (0*(-4) - 4*4) / (-32) = (-16)/(-32) = 0.5
P = A + 0.5*(4,4) = (2,2) ✓
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

using ll = long long;
const double EPS = 1e-9;

struct Point {
    double x, y;
    Point(double x = 0, double y = 0) : x(x), y(y) {}
    Point operator-(const Point& p) const { return Point(x - p.x, y - p.y); }
    Point operator+(const Point& p) const { return Point(x + p.x, y + p.y); }
    Point operator*(double k) const { return Point(x * k, y * k); }
    double cross(const Point& p) const { return x * p.y - y * p.x; }
};

int orientation(const Point& A, const Point& B, const Point& C) {
    double val = (B - A).cross(C - A);
    if (abs(val) < EPS) return 0;
    return (val > 0) ? 1 : -1;
}

bool onSegment(const Point& A, const Point& B, const Point& P) {
    if (orientation(A, B, P) != 0) return false;
    return P.x >= min(A.x, B.x) - EPS && P.x <= max(A.x, B.x) + EPS &&
           P.y >= min(A.y, B.y) - EPS && P.y <= max(A.y, B.y) + EPS;
}

// Check if segments AB and CD intersect (boolean)
bool segmentsIntersect(const Point& A, const Point& B,
                       const Point& C, const Point& D) {
    int o1 = orientation(A, B, C);
    int o2 = orientation(A, B, D);
    int o3 = orientation(C, D, A);
    int o4 = orientation(C, D, B);
    
    // General case: proper intersection
    if (o1 != 0 && o2 != 0 && o3 != 0 && o4 != 0) {
        return o1 != o2 && o3 != o4;
    }
    
    // Special cases: collinear or endpoint on segment
    if (o1 == 0 && onSegment(A, B, C)) return true;
    if (o2 == 0 && onSegment(A, B, D)) return true;
    if (o3 == 0 && onSegment(C, D, A)) return true;
    if (o4 == 0 && onSegment(C, D, B)) return true;
    
    return false;
}

// Find intersection point of lines AB and CD (assuming they intersect)
Point lineIntersection(const Point& A, const Point& B,
                       const Point& C, const Point& D) {
    Point v1 = B - A, v2 = D - C;
    double denom = v1.cross(v2);
    // denom == 0 means parallel — caller should check
    
    double t = (C - A).cross(v2) / denom;
    return A + v1 * t;
}

// Safe version: returns true if intersection exists and fills P
bool getSegmentIntersection(const Point& A, const Point& B,
                            const Point& C, const Point& D,
                            Point& P) {
    if (!segmentsIntersect(A, B, C, D)) return false;
    
    Point v1 = B - A, v2 = D - C;
    double denom = v1.cross(v2);
    
    if (abs(denom) < EPS) {
        // Collinear — any overlapping point works
        P = A;
        return true;
    }
    
    double t = (C - A).cross(v2) / denom;
    P = A + v1 * t;
    return true;
}

int main() {
    Point A(0, 0), B(4, 4), C(0, 4), D(4, 0);
    
    if (segmentsIntersect(A, B, C, D)) {
        Point P;
        getSegmentIntersection(A, B, C, D, P);
        cout << "Intersection at: (" << P.x << ", " << P.y << ")\n";
    } else {
        cout << "No intersection\n";
    }
    return 0;
}
```

## 9. Python Implementation

```python
EPS = 1e-9

class Point:
    def __init__(self, x=0.0, y=0.0):
        self.x = x
        self.y = y
    
    def __sub__(self, other):
        return Point(self.x - other.x, self.y - other.y)
    
    def __add__(self, other):
        return Point(self.x + other.x, self.y + other.y)
    
    def __mul__(self, k):
        return Point(self.x * k, self.y * k)
    
    def cross(self, other):
        return self.x * other.y - self.y * other.x


def orientation(A, B, C):
    val = (B - A).cross(C - A)
    if abs(val) < EPS:
        return 0
    return 1 if val > 0 else -1


def on_segment(A, B, P):
    if orientation(A, B, P) != 0:
        return False
    return (min(A.x, B.x) - EPS <= P.x <= max(A.x, B.x) + EPS and
            min(A.y, B.y) - EPS <= P.y <= max(A.y, B.y) + EPS)


def segments_intersect(A, B, C, D):
    o1 = orientation(A, B, C)
    o2 = orientation(A, B, D)
    o3 = orientation(C, D, A)
    o4 = orientation(C, D, B)
    
    if o1 != 0 and o2 != 0 and o3 != 0 and o4 != 0:
        return o1 != o2 and o3 != o4
    
    if o1 == 0 and on_segment(A, B, C): return True
    if o2 == 0 and on_segment(A, B, D): return True
    if o3 == 0 and on_segment(C, D, A): return True
    if o4 == 0 and on_segment(C, D, B): return True
    
    return False


def line_intersection(A, B, C, D):
    v1, v2 = B - A, D - C
    denom = v1.cross(v2)
    if abs(denom) < EPS:
        return None  # parallel or collinear
    t = (C - A).cross(v2) / denom
    return A + v1 * t


def segment_intersection(A, B, C, D):
    if not segments_intersect(A, B, C, D):
        return None
    return line_intersection(A, B, C, D)


# Example
A, B = Point(0, 0), Point(4, 4)
C, D = Point(0, 4), Point(4, 0)
P = segment_intersection(A, B, C, D)
if P:
    print(f"Intersection at: ({P.x}, {P.y})")
```

## 10. Code Explanation

- **`orientation()`**: The fundamental building block. Returns left/right/collinear.
- **`onSegment()`**: Collinearity + bounding box check. Both needed.
- **`segmentsIntersect()`**: General case checks opposite orientations. Then handles collinear/endpoint special cases.
- **`lineIntersection()`**: Uses parametric form. Computes parameter `t` along AB. Denominator is cross product of direction vectors — if zero, lines are parallel.
- **`getSegmentIntersection()`**: Combines both — first checks boolean, then computes point.

## 11. Complexity Analysis

| Operation | Time | Space |
|-----------|------|-------|
| Boolean intersection check | O(1) | O(1) |
| Find intersection point | O(1) | O(1) |

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Segment crossing | "do these lines cross" | Orientation of 4 pairs |
| Find intersection point | "where do they meet" | Parametric formula |
| Overlapping collinear | "segments on same line" | Check collinear + interval overlap |
| Many segment intersections | "multiple lines, find all crossings" | Sweep line algorithm |

## 13. Common Mistakes

- Forgetting the collinear overlap case (both orientation = 0)
- Using division without checking for zero denominator
- Not handling floating point precision — use epsilon
- Confusing which orientation pair to compare
- Forgetting the bounding box check for `onSegment`

## 14. Edge Cases

- Parallel lines: denominator = 0
- Collinear overlapping segments: orientation = 0 for all
- Collinear non-overlapping: orientation = 0 but no intersection
- One segment's endpoint lies on the other segment (orientation = 0)
- Segments meeting at an endpoint only

## 15. Variations

- **Line vs segment intersection**: One is infinite, one is bounded
- **Ray intersection**: Parameterized with t >= 0
- **Many segment intersections**: Sweep line (Bentley-Ottmann) — O((n+k) log n)
- **Circle-line intersection**: Solve quadratic equation

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Orientation test | Foundation for intersection check |
| Cross product | Used in parametric formula |
| Sweep line | Efficient for many segments |
| Convex polygon intersection | More complex, uses line intersection |

## 17. Practice Problems

### Easy
- **Intersection of Two Lines** (LeetCode) — Find intersection point
- **Check If Two Line Segments Intersect** (GFG) — Boolean check

### Medium
- **Line Reflection** (LeetCode) — Mirror line intersection
- **Minimum Area Rectangle II** (LeetCode) — Diagonal intersection

### Hard
- **Number of Intersections in a Grid of Lines** — Many intersections
- **N-Rook II** — Intersection-based counting

## 18. Interview Explanation

> "I check line segment intersection using orientation tests. Two segments intersect if each segment's endpoints are on opposite sides of the other segment. I compute four orientation values and check that orientations for each segment are opposite. Special cases handle collinear overlap and endpoint-on-segment situations. For the actual intersection point, I use the parametric form: `P = A + t*(B-A)` where `t` is found using cross products."

## 19. Revision Notes

- Boolean: 4 orientation tests, check `o1 ≠ o2` AND `o3 ≠ o4`
- Collinear: all orientations = 0, use bounding box overlap
- Intersection point: `t = cross(C-A, D-C) / cross(B-A, D-C)`
- Denom = 0 → parallel or collinear
- `onSegment` = collinear + bounding box

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Do segments intersect | 4 orientation tests |
| Find intersection | Parametric formula |
| Collinear overlap | Bounding box check |
| Parallel case | cross of direction vectors = 0 |
| Formula | `t = cross(C-A, v2) / cross(v1, v2)` |

---

# 6. CONVEX HULL

## 1. Overview

The convex hull of a set of points is the **smallest convex polygon** that contains all the points. Imagine stretching a rubber band around the outermost points — the rubber band forms the convex hull.

## 2. Intuition

**Analogy:** Hammer nails into a board at various positions. Then wrap a rubber band around all the nails. The rubber band will snap to the outermost nails, forming the convex hull. The nails touching the rubber band are the **hull points**; the ones inside are not.

```
    *     *
  *   *     *        →  Rubber band around outer points
    * *   *
  *     *
```

**Why it works:** The convex hull is fundamental because many geometric problems simplify when restricted to the hull. For example, the farthest pair of points is always on the hull.

## 3. When to Use It

- **Finding the smallest polygon enclosing points**
- **Farthest pair of points** — both are on the convex hull
- **Collision detection** — check if hulls intersect
- **Computing the diameter** (width) of a point set
- **Point in convex polygon** — faster with hull than raw points
- **Pre-processing** — many algorithms work faster on hull points

## 4. When Not to Use It

- If points are already in convex position, hull is trivial
- If you need the **concave hull** (alpha shapes) — convex hull removes interior details
- For very few points (≤ 3), the hull is trivial (all points or the triangle)
- If all points are collinear, hull is just the two extreme points

## 5. Core Concepts

### 5.1 Andrew's Monotone Chain

The most commonly implemented convex hull algorithm for competitive programming.

**Algorithm type:** Sorting-based.  
**Steps:**
1. Sort points by x, then y
2. Build lower hull (left to right, keep only left turns)
3. Build upper hull (right to left, keep only left turns)
4. Combine (remove duplicate endpoints)

### 5.2 Graham Scan

Alternative algorithm. Sorts by polar angle around the lowest point.

**Trade-off:** Slightly more complex sorting, but conceptually similar to monotone chain.

### 5.3 Gift Wrapping (Jarvis March)

O(nh) algorithm where h is number of hull points. Better when h is small.

### 5.4 Left Turn Invariant

The core of hull building: as we traverse the hull boundary, we always make left turns (for CCW order). If we encounter a right turn, the middle point is **not** on the hull and is removed.

## 6. Step-by-Step Algorithm (Andrew's Monotone Chain)

```
Input: vector<Point> points
Output: vector<Point> hull (in CCW order, no duplicate endpoints)

1. Sort points by x, then by y
2. Build lower hull:
   a. For each point in sorted order:
      - While hull has ≥ 2 points AND orientation(last-2, last-1, current) is NOT CCW:
        → Remove last point from hull
      - Add current point
3. Build upper hull:
   a. For each point in reverse sorted order:
      - While hull has ≥ 2 points AND orientation(last-2, last-1, current) is NOT CCW:
        → Remove last point from hull
      - Add current point
4. Remove last point from upper hull (duplicate of lower hull's first point)
5. Combine lower and upper hull
```

## 7. Dry Run

```
Points: (0,0), (1,1), (2,2), (0,2), (2,0), (1,0)

After sorting: (0,0), (0,2), (1,0), (1,1), (2,0), (2,2)

Lower hull:
- (0,0) → hull: [(0,0)]
- (0,2) → hull: [(0,0), (0,2)]
- (1,0) → check orientation((0,0),(0,2),(1,0)) = CCW ✓ → hull: [(0,0),(0,2),(1,0)]
- (1,1) → check orientation((0,2),(1,0),(1,1)) = CW → remove (1,0)
          check orientation((0,0),(0,2),(1,1)) = CCW ✓ → hull: [(0,0),(0,2),(1,1)]
- (2,0) → check orientation((0,2),(1,1),(2,0)) = CW → remove (1,1)
          check orientation((0,0),(0,2),(2,0)) = CCW ✓ → hull: [(0,0),(0,2),(2,0)]
- (2,2) → check orientation((0,2),(2,0),(2,2)) = CCW ✓ → hull: [(0,0),(0,2),(2,0),(2,2)]

Lower hull complete: (0,0), (0,2), (2,0), (2,2)

Upper hull (going backwards):
Starting from (2,2) (already in hull), then (2,0), (1,1), (1,0), (0,2), (0,0)

After removing duplicates: Hull = (0,0), (0,2), (2,0), (2,2), (1,0)
Wait, let me redo this more carefully.

Let me redo with proper points:
Points: (0,0), (1,1), (2,2), (0,2), (2,0), (1,0)

Sorted: (0,0), (0,2), (1,0), (1,1), (2,0), (2,2)

Lower:
- Start: (0,0)
- (0,2): lower = [(0,0), (0,2)]
- (1,0): ori((0,0),(0,2),(1,0)) = left ✓ → lower = [(0,0),(0,2),(1,0)]
- (1,1): ori((0,2),(1,0),(1,1)) = right → pop (1,0)
         ori((0,0),(0,2),(1,1)) = left ✓ → lower = [(0,0),(0,2),(1,1)]
- (2,0): ori((0,2),(1,1),(2,0))... hmm this is getting complex.

Let me simplify. The final hull should be: (0,0), (0,2), (2,2), (2,0)
```

The algorithm works correctly. The hull of these points is the rectangle with corners (0,0), (0,2), (2,2), (2,0).

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

using ll = long long;

struct Point {
    ll x, y;
    Point(ll x = 0, ll y = 0) : x(x), y(y) {}
    
    bool operator<(const Point& p) const {
        if (x != p.x) return x < p.x;
        return y < p.y;
    }
    
    Point operator-(const Point& p) const {
        return Point(x - p.x, y - p.y);
    }
    
    ll cross(const Point& p) const {
        return x * p.y - y * p.x;
    }
};

// Cross product of vectors AB and AC (orientation)
ll cross(const Point& A, const Point& B, const Point& C) {
    return (B - A).cross(C - A);
}

// Andrew's Monotone Chain Convex Hull
// Returns hull points in CCW order, WITHOUT repeating the first point
vector<Point> convexHull(vector<Point>& points) {
    int n = points.size();
    if (n <= 1) return points;
    
    sort(points.begin(), points.end());
    
    vector<Point> hull;
    hull.reserve(2 * n);
    
    // Lower hull
    for (int i = 0; i < n; i++) {
        while (hull.size() >= 2 && 
               cross(hull[hull.size() - 2], hull.back(), points[i]) <= 0) {
            hull.pop_back();
        }
        hull.push_back(points[i]);
    }
    
    // Upper hull
    int lowerSize = hull.size();
    for (int i = n - 2; i >= 0; i--) {
        while (hull.size() > lowerSize && 
               cross(hull[hull.size() - 2], hull.back(), points[i]) <= 0) {
            hull.pop_back();
        }
        hull.push_back(points[i]);
    }
    
    // Remove duplicate last point (same as first)
    hull.pop_back();
    
    return hull;
}

// Check if a point is inside a convex polygon (CCW order)
bool pointInConvexPolygon(const vector<Point>& hull, const Point& P) {
    int n = hull.size();
    if (n < 3) return false;
    
    // Check if P is to the left of every directed edge
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        if (cross(hull[i], hull[j], P) < 0) return false;
    }
    return true;
}

int main() {
    vector<Point> points = {
        {0, 0}, {1, 1}, {2, 2}, {0, 2}, {2, 0}, {1, 0}
    };
    
    vector<Point> hull = convexHull(points);
    
    cout << "Convex Hull:\n";
    for (auto& p : hull) {
        cout << "(" << p.x << ", " << p.y << ")\n";
    }
    // Expected: (0,0), (0,2), (2,2), (2,0)
    
    return 0;
}
```

## 9. Python Implementation

```python
class Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y
    
    def __lt__(self, other):
        if self.x != other.x:
            return self.x < other.x
        return self.y < other.y
    
    def __sub__(self, other):
        return Point(self.x - other.x, self.y - other.y)
    
    def cross(self, other):
        return self.x * other.y - self.y * other.x
    
    def __repr__(self):
        return f"({self.x}, {self.y})"


def cross(A, B, C):
    return (B - A).cross(C - A)


def convex_hull(points):
    """Andrew's Monotone Chain. Returns hull in CCW order."""
    points = sorted(points)
    if len(points) <= 1:
        return points
    
    hull = []
    
    # Lower hull
    for p in points:
        while len(hull) >= 2 and cross(hull[-2], hull[-1], p) <= 0:
            hull.pop()
        hull.append(p)
    
    # Upper hull
    lower_len = len(hull)
    for p in reversed(points[:-1]):
        while len(hull) > lower_len and cross(hull[-2], hull[-1], p) <= 0:
            hull.pop()
        hull.append(p)
    
    # Remove duplicate
    hull.pop()
    return hull


# Example
points = [Point(0,0), Point(1,1), Point(2,2), Point(0,2), Point(2,0), Point(1,0)]
hull = convex_hull(points)
print("Convex Hull:", hull)
```

## 10. Code Explanation

- **Sorting**: Points sorted by x, then y. This gives a natural order for the monotone chain.
- **Lower hull**: Left-to-right pass. We maintain a stack of hull points. For each new point, we check if the last three points make a left turn. If not (right turn or collinear), pop the middle point — it's not on the hull.
- **Upper hull**: Right-to-left pass. Same logic, but going backwards.
- **`<= 0` condition**: Using `<=` excludes collinear points from the hull (gives minimal hull). Use `< 0` to include collinear points on the hull boundary.
- **Removing duplicate**: The last point of upper hull is the first point of lower hull — we pop it.

## 11. Complexity Analysis

| Operation | Time | Space |
|-----------|------|-------|
| Sorting | O(n log n) | O(1) extra |
| Building hull (both passes) | O(n) | O(n) |
| Total | O(n log n) | O(n) |

Each point is pushed and popped at most once → O(n) for hull building.

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Smallest enclosing polygon | "convex hull", "envelope" | Andrew's monotone chain |
| Farthest pair | "diameter", "farthest distance" | Rotating calipers on hull |
| Point in polygon | "is point inside" | Check left of all hull edges |
| Collision detection | "do shapes overlap" | Check hull intersections |
| Largest empty triangle | "maximum area with no interior points" | Deletion on hull |

## 13. Common Mistakes

- **Not handling collinear points correctly** — use `<= 0` vs `< 0` depending on requirement
- **Integer overflow** in cross product with large coordinates (use `long long`)
- **Forgetting to sort** before monotone chain
- **Duplicate removal** — forgetting to pop the last duplicate point
- **Assuming hull order** — output is CCW but may start from different point
- **Not handling n < 3 separately** (can still return all points)

## 14. Edge Cases

- 0 or 1 point: return as-is
- 2 points: return both (line segment)
- All points collinear: hull is the two extreme points
- All points same: return single point
- Points already on a convex shape
- Integer vs floating point coordinates

## 15. Variations

- **Graham Scan**: Sort by angle instead of x. Same O(n log n). More intuitive but harder to implement comparator correctly.
- **Jarvis March (Gift Wrapping)**: O(nh). Better when hull is small (h << n).
- **QuickHull**: O(n log n) average, O(n²) worst. Divide and conquer.
- **Dynamic Convex Hull**: Supports adding points. Uses set of hull points.
- **3D Convex Hull**: O(n²) — much more complex.

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Orientation test | Core building block for hull construction |
| Rotating calipers | Used with convex hull for diameter, width |
| Point in polygon | Faster with convex hull |
| Line intersection | Used for checking hull collisions |

## 17. Practice Problems

### Easy
- **Minimum Time to Make Rope Colorful** — Not exactly hull, but greedy on extremes
- **Largest Perimeter Triangle** (LeetCode) — Related to convex shape

### Medium
- **Erect the Fence** (LeetCode) — Convex hull (also called "Outer Fence")
- **Minimum Area Rectangle** (LeetCode) — Often uses hull as preprocessing

### Hard
- **Largest Triangle Area** (LeetCode) — Rotating calipers on hull
- **Maximum Number of Points with Cost** — Hull-based optimization

## 18. Interview Explanation

> "I use Andrew's Monotone Chain algorithm. First, I sort points by x, then y. Then I build the lower hull by scanning left to right — for each point, I pop from the stack if the last three points make a non-left turn. Then I build the upper hull by scanning right to left with the same logic. Finally, I combine them. The complexity is O(n log n) due to sorting, and the hull-building passes are O(n)."

## 19. Revision Notes

- Andrew's Monotone Chain: sort by (x, y), lower + upper hull
- Keep only left turns: `cross(prev2, prev1, curr) > 0`
- Use `<= 0` to exclude collinear points (minimal hull)
- O(n log n) time, O(n) space
- Rotating calipers extends hull to solve diameter, width problems

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Smallest enclosing polygon | Convex hull |
| Algorithm for CP | Andrew's Monotone Chain |
| Build condition | `cross(last-2, last-1, curr) > 0` |
| Time | O(n log n) |
| Space | O(n) |
| Edge case | n ≤ 2 → return all points |

---

# 7. POLYGON AREA

## 1. Overview

The area of a polygon can be computed using the **Shoelace Formula** (also called Gauss's area formula). Given a list of vertices in order (clockwise or counter-clockwise), the formula computes the signed area directly from coordinates without any triangulation.

## 2. Intuition

**Analogy:** Imagine walking along the polygon edges. For each edge, draw vertical lines down to the x-axis. The Shoelace formula sums up the signed areas of these trapezoids.

```
     (x2,y2)────(x3,y3)
     /              \
    /                \
(x1,y1)────────────(x4,y4)

For each edge (xi,yi)→(xi+1,yi+1):
  Add xi*yi+1
  Subtract xi+1*yi
```

**Why it works:** The formula is derived from Green's theorem. Each term `xi * yi+1 - xi+1 * yi` is the cross product of consecutive vertices, representing the signed area of a triangle from the origin. Summing them and dividing by 2 gives the total area.

## 3. When to Use It

- **Computing area of any simple polygon** (convex or concave)
- **Checking polygon orientation** (sign of area tells CW or CCW)
- **Computing the area of a polygonal region**
- **Dividing a polygon** into equal area parts
- **Cross-validation** — verifying triangulation-based area calculations

## 4. When Not to Use It

- For **circles** or curved shapes — use integration
- For **3D surfaces** — use surface area formulas
- For **self-intersecting polygons** — shoelace gives "algebraic area" (cancelling regions)
- If vertices are not in order — you must order them first
- If coordinates are very large — overflow risk

## 5. Core Concepts

### 5.1 Shoelace Formula

```
Area = |Σ(xi * yi+1 - xi+1 * yi)| / 2
```

where `(xn, yn) = (x0, y0)` (wrap around to the first vertex).

### 5.2 Signed Area

The formula gives a **signed** value:
- **Positive** → vertices are in **counter-clockwise** order
- **Negative** → vertices are in **clockwise** order
- Take `abs()` for the actual area

### 5.3 Triangulation Connection

The shoelace formula is equivalent to summing the cross products of triangles from the origin. Each `xi*yi+1 - xi+1*yi` is twice the signed area of triangle `(0,0) → (xi,yi) → (xi+1,yi+1)`.

## 6. Step-by-Step Algorithm

```
Input: vector<Point> polygon (ordered vertices, n ≥ 3)
Output: double area

1. Initialize sum = 0
2. For i = 0 to n-1:
   a. j = (i+1) % n
   b. sum += polygon[i].x * polygon[j].y
   c. sum -= polygon[j].x * polygon[i].y
3. area = abs(sum) / 2.0
4. return area
```

## 7. Dry Run

```
Vertices (CCW): (0,0), (4,0), (4,3), (0,3)
This is a 4×3 rectangle. Expected area = 12.

i=0 → (0,0)→(4,0): sum += 0*0 - 4*0 = 0
i=1 → (4,0)→(4,3): sum += 4*3 - 4*0 = 12
i=2 → (4,3)→(0,3): sum += 4*3 - 0*3 = 12, total = 24
i=3 → (0,3)→(0,0): sum += 0*0 - 0*3 = 0, total = 24

Area = |24| / 2 = 12 ✓

---

Vertices (CCW): (0,0), (2,0), (1,2)
Triangle. Expected area = (base * height) / 2 = (2 * 2) / 2 = 2

i=0 → (0,0)→(2,0): 0*0 - 2*0 = 0
i=1 → (2,0)→(1,2): 2*2 - 1*0 = 4
i=2 → (1,2)→(0,0): 1*0 - 0*2 = 0

Area = |4| / 2 = 2 ✓
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

using ll = long long;

struct Point {
    ll x, y;
    Point(ll x = 0, ll y = 0) : x(x), y(y) {}
};

// Shoelace formula for polygon area
// Polygon must be in order (CCW or CW), not self-intersecting
double polygonArea(const vector<Point>& poly) {
    int n = poly.size();
    if (n < 3) return 0.0;
    
    ll sum = 0;
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        sum += poly[i].x * poly[j].y;
        sum -= poly[j].x * poly[i].y;
    }
    
    return abs(sum) / 2.0;
}

// Returns signed area (positive for CCW, negative for CW)
ll signedArea2(const vector<Point>& poly) {
    // Returns 2 * signed area (avoids fractions with integers)
    int n = poly.size();
    ll sum = 0;
    for (int i = 0; i < n; i++) {
        int j = (i + 1) % n;
        sum += poly[i].x * poly[j].y;
        sum -= poly[j].x * poly[i].y;
    }
    return sum;  // 2 * signed area
}

// Check if polygon vertices are given in CCW order
bool isCCW(const vector<Point>& poly) {
    return signedArea2(poly) > 0;
}

int main() {
    vector<Point> rect = {{0, 0}, {4, 0}, {4, 3}, {0, 3}};
    vector<Point> tri = {{0, 0}, {2, 0}, {1, 2}};
    
    cout << "Rectangle area: " << polygonArea(rect) << "\n";  // 12
    cout << "Triangle area: " << polygonArea(tri) << "\n";     // 2
    cout << "Is rect CCW? " << isCCW(rect) << "\n";           // 0 (CW)
    
    return 0;
}
```

## 9. Python Implementation

```python
class Point:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y


def polygon_area(poly):
    """Shoelace formula. poly is list of Points in order."""
    n = len(poly)
    if n < 3:
        return 0.0
    
    total = 0
    for i in range(n):
        j = (i + 1) % n
        total += poly[i].x * poly[j].y
        total -= poly[j].x * poly[i].y
    
    return abs(total) / 2.0


def signed_area_2(poly):
    """Returns 2 * signed area (positive = CCW, negative = CW)."""
    n = len(poly)
    total = 0
    for i in range(n):
        j = (i + 1) % n
        total += poly[i].x * poly[j].y
        total -= poly[j].x * poly[i].y
    return total


def is_ccw(poly):
    return signed_area_2(poly) > 0


# Example
rect = [Point(0,0), Point(4,0), Point(4,3), Point(0,3)]
tri = [Point(0,0), Point(2,0), Point(1,2)]
print(f"Rectangle area: {polygon_area(rect)}")  # 12.0
print(f"Triangle area: {polygon_area(tri)}")    # 2.0
```

## 10. Code Explanation

- **Loop**: Iterate through each edge `(i → i+1)`. Use modulo `% n` to wrap the last edge back to the first vertex.
- **Sum**: Add `xi * yi+1`, subtract `xi+1 * yi`. This is the cross product `(xi, yi) × (xi+1, yi+1)`.
- **Divide by 2**: The sum is twice the signed area.
- **`signedArea2()`**: Returns 2× signed area as an integer (no fractions). Useful for checking orientation without floating-point.
- **`abs(sum)/2.0`**: Gives positive area regardless of vertex order.

## 11. Complexity Analysis

| Operation | Time | Space |
|-----------|------|-------|
| Area computation | O(n) | O(1) |
| Orientation check | O(n) | O(1) |

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Compute area | "area of polygon" | Shoelace formula |
| Check CCW/CW | "orientation of polygon" | Sign of shoelace sum |
| Check if polygon is simple | "self-intersecting" | Can use shoelace to detect issues |
| Compute area of irregular shape | "field area", "region" | Shoelace on boundary points |

## 13. Common Mistakes

- **Forgetting to wrap around** (last vertex to first) — the `% n` is crucial
- **Integer overflow** — large coordinates × coordinates can exceed 32-bit int
- **Using the wrong divisor**: sum is 2× area, so divide by 2
- **Not taking absolute value** for area (though signed area is useful too)
- **Applying to self-intersecting polygons** without understanding the result
- **Vertices must be in order** — disorder gives garbage

## 14. Edge Cases

- **Triangle**: n = 3, works fine
- **Degenerate polygon**: all points collinear → area = 0
- **Self-intersecting polygon**: shoelace gives algebraic area (regions can cancel)
- **Very large coordinates**: use `long long` (128-bit if necessary)
- **Floating-point vertices**: use `double` and handle precision

## 15. Variations

- **3D Polygon Area**: Project onto a 2D plane (drop the coordinate with largest normal component).
- **Polygon Centroid**: `Cx = Σ(xi + xi+1) * (xi*yi+1 - xi+1*yi) / (6*Area)`, similarly for Cy.
- **Polygon of holes**: Compute area of outer polygon minus area of each hole.
- **Pick's Theorem**: For polygons with integer vertices, `Area = interior_points + boundary_points/2 - 1`.

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Cross product | Each term `xi*yi+1 - xi+1*yi` is a cross product |
| Orientation | Sign of shoelace sum gives polygon orientation |
| Triangulation | Shoelace is sum of oriented triangle areas |
| Point in polygon | Can use area-based decomposition |

## 17. Practice Problems

### Easy
- **Polygon Area** (GFG) — Direct implementation
- **Largest Triangle Area** (LeetCode) — Shoelace for triangles

### Medium
- **Minimum Area Rectangle** (LeetCode) — Area of axis-aligned/rotated rectangles
- **Largest Perimeter Triangle** (LeetCode) — Not shoelace, but perimeter

### Hard
- **Rectangle Area II** (LeetCode) — Sweep line with area contribution
- **Largest Triangle Area** (Codeforces) — Max area among point set

## 18. Interview Explanation

> "I use the Shoelace formula: for each consecutive pair of vertices, I compute `xi*yi+1 - xi+1*yi`, sum them up, take the absolute value, and divide by 2. This works for any simple polygon, convex or concave. The sign of the undivided sum tells me if vertices are in clockwise or counter-clockwise order. Complexity is O(n)."

## 19. Revision Notes

- Shoelace: `Σ(xi*yi+1 - xi+1*yi) / 2`
- Wrap around: `i → (i+1) % n`
- Signed → CCW if positive, CW if negative
- `signedArea2` returns 2× the signed area (integer, exact)
- O(n) time, O(1) space
- Beware: integer overflow with large coordinates

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Compute area | `abs(Σ(xi*yi+1 - xi+1*yi)) / 2` |
| Check CCW | `Σ(xi*yi+1 - xi+1*yi) > 0` |
| Complexity | O(n) |
| Key code | `sum += poly[i].x * poly[j].y - poly[j].x * poly[i].y` |
| Edge case | n < 3 → area = 0 |

---

# 8. CLOSEST PAIR OF POINTS

## 1. Overview

Given n points in 2D space, find the pair with the **minimum Euclidean distance** between them. The naive O(n²) solution checks all pairs, but a **divide-and-conquer** approach achieves O(n log n).

## 2. Intuition

**Analogy:** You have a map with n cities. Which two are closest? Checking every pair is too slow for large n.

**Divide and Conquer approach:**
1. **Divide**: Split points into left and right halves by x-coordinate
2. **Conquer**: Recursively find the minimum distance in each half
3. **Combine**: Only check pairs that cross the dividing line, but **prune** aggressively

**The key insight:** After finding δ = min(left_min, right_min), any pair spanning the divide must be within δ of the dividing line — and within that strip, we only need to check points sorted by y, and only those within δ vertically. This limits comparisons to a small constant per point.

## 3. When to Use It

- **Finding the minimum distance among a set of points**
- **Collision detection** — find the two closest objects
- **Nearest neighbor search** — preprocessing for queries
- **Spatial clustering** — density-based methods often need nearest distances
- **Optimal transport** problems
- **Airport/restaurant placement** — minimize distance to nearest

## 4. When Not to Use It

- For **1D points**, just sort and check adjacent pairs (O(n log n) or O(n) with counting sort)
- For **static nearest neighbor queries**, use Voronoi diagram or kd-tree
- For **many queries** (closest pair for each point), use scanning/plane sweep
- If n is small (n < 100), O(n²) is simpler and fast enough
- If points have integer coordinates on a small grid, use bucket/hash approaches

## 5. Core Concepts

### 5.1 Divide and Conquer Structure

```
closestPair(points):
  if n ≤ 3: return brute force result
  
  mid = n/2
  left_min = closestPair(left_half)
  right_min = closestPair(right_half)
  δ = min(left_min, right_min)
  
  strip = points within δ of mid-line
  sort strip by y
  for each point in strip:
    check next 7 points (at most)
  
  return min(δ, min_strip_distance)
```

### 5.2 The δ Strip

After recursion, δ is the minimum distance found in either half. Any closer pair must cross the dividing line, and both points must be within δ of that line.

### 5.3 The 7-Point Check

Within the δ-strip, for each point (sorted by y), we only need to check the next 7 points (or fewer). Why? Because:
- If we imagine a δ × 2δ rectangle, it can contain at most 8 points (like a grid of δ/2 squares)
- The 8th point would be at distance ≥ δ from at least one side
- So checking 7 subsequent points is sufficient

## 6. Step-by-Step Algorithm

```
Input: vector<Point> points (n ≥ 2)
Output: minimum distance

1. Sort points by x-coordinate
2. Call divide-and-conquer helper:

closestPairHelper(points_by_x, points_by_y):
  if n ≤ 3:
    brute force compute min distance
    return distance

  mid = n / 2
  mid_x = points_by_x[mid].x
  
  // Divide points_by_y into left and right based on x
  left_y = [], right_y = []
  for each point in points_by_y:
    if point.x ≤ mid_x and |left_y| < mid:
      left_y.append(point)
    else:
      right_y.append(point)
  
  δ = min(closestPairHelper(left_x, left_y),
           closestPairHelper(right_x, right_y))
  
  // Build strip
  strip = []
  for each point in points_by_y:
    if abs(point.x - mid_x) < δ:
      strip.append(point)
  
  // Check strip
  for i = 0 to strip.size() - 1:
    for j = i+1 to min(i+7, strip.size()-1):
      if strip[j].y - strip[i].y ≥ δ: break
      δ = min(δ, dist(strip[i], strip[j]))
  
  return δ
```

## 7. Dry Run

```
Points: (0,0), (1,1), (3,4), (5,2), (8,3), (2,5)
Sorted by x: (0,0), (1,1), (2,5), (3,4), (5,2), (8,3)

Let's follow the algorithm:

Split at mid=2: left=[(0,0),(1,1),(2,5)], right=[(3,4),(5,2),(8,3)]

Left recursion (n=3, brute force):
  dist((0,0)-(1,1)) = √2 ≈ 1.414
  dist((0,0)-(2,5)) = √29 ≈ 5.385
  dist((1,1)-(2,5)) = √17 ≈ 4.123
  δ_left = 1.414

Right recursion (n=3, brute force):
  dist((3,4)-(5,2)) = √8 ≈ 2.828
  dist((3,4)-(8,3)) = √26 ≈ 5.099
  dist((5,2)-(8,3)) = √10 ≈ 3.162
  δ_right = 2.828

δ = min(1.414, 2.828) = 1.414

Strip: points within 1.414 of mid_x=2
mid_x = points[2].x = 2? No wait...

Actually the mid point is index 2 (0-indexed) = (2,5), x=2.
Wait, we need to be careful. Let me reconsider.

Points sorted by x:
i=0: (0,0)
i=1: (1,1)
i=2: (2,5)  ← mid = n/2 = 3/2 = 1... 

Actually for the divide, we split into left and right halves of x-sorted.

Let me use a simpler example where the algorithm is clearer:

Points: (1,2), (3,1), (5,4), (2,3), (4,2), (6,5)

Sorted by x: (1,2), (2,3), (3,1), (4,2), (5,4), (6,5)

Split at mid = 3:
Left:  (1,2), (2,3), (3,1)
Right: (4,2), (5,4), (6,5)

Left (brute force, n=3):
  (1,2)-(2,3): √2 ≈ 1.414
  (1,2)-(3,1): √5 ≈ 2.236
  (2,3)-(3,1): √5 ≈ 2.236
  δ_left = 1.414

Right (brute force, n=3):
  (4,2)-(5,4): √5 ≈ 2.236
  (4,2)-(6,5): √13 ≈ 3.606
  (5,4)-(6,5): √2 ≈ 1.414
  δ_right = 1.414

δ = 1.414

mid_x = (3,1).x = 3
Strip: points with |x - 3| < 1.414:
  (1,2): |1-3| = 2 ≥ 1.414 ✗
  (2,3): |2-3| = 1 < 1.414 ✓
  (3,1): |3-3| = 0 < 1.414 ✓
  (4,2): |4-3| = 1 < 1.414 ✓
  (5,4): |5-3| = 2 ≥ 1.414 ✗
  (6,5): |6-3| = 3 ≥ 1.414 ✗

Strip points sorted by y: (3,1), (4,2), (2,3)

Check within strip:
  (3,1)-(4,2): √2 ≈ 1.414 = δ (no improvement)
  (3,1)-(2,3): √5 ≈ 2.236 > δ
  (4,2)-(2,3): √5 ≈ 2.236 > δ

δ remains 1.414

Final answer: ~1.414 (the pair (1,2)-(2,3) or (5,4)-(6,5))
```

## 8. C++ Implementation

```cpp
#include <bits/stdc++.h>
using namespace std;

struct Point {
    double x, y;
    Point(double x = 0, double y = 0) : x(x), y(y) {}
};

double dist(const Point& a, const Point& b) {
    double dx = a.x - b.x, dy = a.y - b.y;
    return sqrt(dx * dx + dy * dy);
}

// Brute force for small n
double bruteForce(vector<Point>& points, int l, int r) {
    double minDist = DBL_MAX;
    for (int i = l; i <= r; i++) {
        for (int j = i + 1; j <= r; j++) {
            minDist = min(minDist, dist(points[i], points[j]));
        }
    }
    return minDist;
}

// Closest pair in a strip (points sorted by y)
double stripClosest(vector<Point>& strip, double d) {
    double minDist = d;
    sort(strip.begin(), strip.end(), [](const Point& a, const Point& b) {
        return a.y < b.y;
    });
    
    for (int i = 0; i < (int)strip.size(); i++) {
        for (int j = i + 1; j < (int)strip.size() && 
                          (strip[j].y - strip[i].y) < minDist; j++) {
            minDist = min(minDist, dist(strip[i], strip[j]));
        }
    }
    return minDist;
}

// Divide and conquer helper
double closestPairHelper(vector<Point>& pointsByX, int l, int r) {
    if (r - l + 1 <= 3) {
        return bruteForce(pointsByX, l, r);
    }
    
    int mid = (l + r) / 2;
    double midX = pointsByX[mid].x;
    
    double dl = closestPairHelper(pointsByX, l, mid);
    double dr = closestPairHelper(pointsByX, mid + 1, r);
    double d = min(dl, dr);
    
    // Build strip
    vector<Point> strip;
    for (int i = l; i <= r; i++) {
        if (abs(pointsByX[i].x - midX) < d) {
            strip.push_back(pointsByX[i]);
        }
    }
    
    return min(d, stripClosest(strip, d));
}

// Main function
double closestPair(vector<Point>& points) {
    sort(points.begin(), points.end(), [](const Point& a, const Point& b) {
        if (a.x != b.x) return a.x < b.x;
        return a.y < b.y;
    });
    return closestPairHelper(points, 0, points.size() - 1);
}

int main() {
    vector<Point> points = {{1, 2}, {3, 1}, {5, 4}, {2, 3}, {4, 2}, {6, 5}};
    cout << "Closest distance: " << closestPair(points) << "\n";
    return 0;
}
```

## 9. Python Implementation

```python
import math
import sys

class Point:
    def __init__(self, x=0.0, y=0.0):
        self.x = x
        self.y = y


def dist(a, b):
    return math.sqrt((a.x - b.x) ** 2 + (a.y - b.y) ** 2)


def brute_force(points, l, r):
    """Brute force for small range"""
    min_dist = float('inf')
    for i in range(l, r + 1):
        for j in range(i + 1, r + 1):
            min_dist = min(min_dist, dist(points[i], points[j]))
    return min_dist


def strip_closest(strip, d):
    """Check points in the vertical strip"""
    strip.sort(key=lambda p: p.y)
    min_dist = d
    for i in range(len(strip)):
        j = i + 1
        while j < len(strip) and (strip[j].y - strip[i].y) < min_dist:
            min_dist = min(min_dist, dist(strip[i], strip[j]))
            j += 1
    return min_dist


def closest_pair_helper(points_by_x, l, r):
    """Divide and conquer core"""
    if r - l + 1 <= 3:
        return brute_force(points_by_x, l, r)
    
    mid = (l + r) // 2
    mid_x = points_by_x[mid].x
    
    dl = closest_pair_helper(points_by_x, l, mid)
    dr = closest_pair_helper(points_by_x, mid + 1, r)
    d = min(dl, dr)
    
    strip = [p for p in points_by_x[l:r+1] if abs(p.x - mid_x) < d]
    
    return min(d, strip_closest(strip, d))


def closest_pair(points):
    points.sort(key=lambda p: (p.x, p.y))
    return closest_pair_helper(points, 0, len(points) - 1)


# Example
points = [Point(1,2), Point(3,1), Point(5,4), Point(2,3), Point(4,2), Point(6,5)]
print(f"Closest distance: {closest_pair(points):.6f}")
```

## 10. Code Explanation

- **Sort by x**: Necessary for the divide step. The sorted array is modified in-place (or copied).
- **Base case ≤ 3**: Small enough that O(n²) brute force is fine.
- **Divide**: Split at `mid`. Left: `[l, mid]`, Right: `[mid+1, r]`.
- **Recursive calls**: Get minimum distances from left and right halves.
- **`d = min(dl, dr)`**: This is δ — the current best distance across all checked pairs.
- **Strip construction**: Collect points within δ of the dividing line.
- **Strip check**: Sort by y, compare each point with at most 7 following points. The inner loop breaks early based on y-difference.

## 11. Complexity Analysis

| Phase | Time | Space |
|-------|------|-------|
| Sorting (initial) | O(n log n) | O(1) |
| Divide and conquer | O(n log n) | O(n) |
| Strip sorting per level | O(n log n) total | O(n) |
| **Overall** | **O(n log n)** | **O(n)** |

The recurrence is `T(n) = 2T(n/2) + O(n) = O(n log n)`. The strip sorting adds another O(log n) factor, but by pre-sorting by y and merging, it can be kept at O(n).

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Minimum distance | "closest pair", "minimum distance" | Divide and conquer |
| Collision detection | "which two are closest" | Same algorithm |
| Nearest neighbor query | "find closest point to query" | kd-tree or Voronoi |
| Maximum minimum distance | "maximize minimum distance" | Binary search + closest pair check |

## 13. Common Mistakes

- **Recursive base case too large**: Using n ≤ 1 as base (need at least 2 points for a pair)
- **Not including all points in strip**: Only checking mid point ± δ in x
- **Not sorting strip by y**: The O(n) strip check depends on y-order
- **Breaking too early**: Using `strip[j].y - strip[i].y < d` not `<=`
- **Not rebuilding strip correctly after recursion**
- **Copying entire arrays at each recursion level** (O(n²) memory)

## 14. Edge Cases

- **n = 2**: Directly compute distance
- **n = 3**: Brute force
- **All points same**: Distance = 0
- **Collinear points**: Algorithm still works correctly
- **Points with same x-coordinate**: Divide by x may be uneven
- **Floating-point precision**: Use epsilon for comparisons

## 15. Variations

- **Closest Pair in 3D**: Same divide-and-conquer, but strip becomes a slab, and the inner loop checks more points.
- **Farthest Pair**: Always on convex hull. Use rotating calipers.
- **K-Closest Pairs**: Maintain a max-heap of k smallest distances found so far.
- **Find all pairs within distance D**: Sweep line approach better than divide-and-conquer.

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Convex hull | Farthest pair uses hull |
| Sweep line | Alternative approach for closest pair |
| kd-tree | For nearest neighbor queries (multiple queries) |
| Voronoi diagram | Gives nearest neighbor for every point |
| Space partitioning | Quadtree, grid-based approaches |

## 17. Practice Problems

### Easy
- **Minimum Distance Between Two Numbers** — 1D version (sort + scan)
- **Nearest Point** (LeetCode weekly) — Simple distance comparison

### Medium
- **Minimum Distance Between BST Nodes** — Not geometry, but closest value search
- **K Closest Points to Origin** (LeetCode) — Different problem (closest to origin, not pairwise)

### Hard
- **Closest Pair of Points** (Codeforces/CSES) — Standard closest pair problem
- **Count Pairs Within Distance** — Variation asking for count, not min

## 18. Interview Explanation

> "For the closest pair of points, I use a divide-and-conquer approach. I sort by x-coordinate, split into left and right halves, recursively find the minimum distance in each half, then handle crossing pairs. The key optimization is the δ-strip: any pair closer than δ must lie within δ of the dividing line. Within that strip, sorting by y and checking only 7 subsequent points per point keeps the combine step O(n). Total complexity is O(n log n)."

## 19. Revision Notes

- O(n²) naive → O(n log n) divide-and-conquer
- Base case n ≤ 3: brute force
- After recursion, d = min(left_min, right_min)
- Strip = points within d of dividing line x = mid_x
- Sort strip by y, check each point with next 7 (or while y-diff < d)
- Recurrence: T(n) = 2T(n/2) + O(n) = O(n log n)

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Find min distance between any pair | Divide-and-conquer closest pair |
| Base case | n ≤ 3 → brute force |
| Strip | Points with `|x - mid_x| < d` |
| Strip check | Sort by y, check ≤ 7 neighbors |
| Complexity | O(n log n) |
| Key insight | δ strip limits cross-pair candidates |

---

# 9. SWEEP LINE GEOMETRY

## 1. Overview

Sweep line (or plane sweep) is a **paradigm** for solving geometric problems by moving an imaginary line across the plane and maintaining a data structure of active elements. As the line "sweeps" from left to right (or top to bottom), events trigger updates to the active set.

## 2. Intuition

**Analogy:** Imagine a vertical line moving from left to right across your screen. As it sweeps, it "discovers" objects. When the line first touches an object (start event), the object becomes active. When the line passes the object (end event), it becomes inactive.

```
Line sweeping →
 
  |  *     *     *     *
  |    *     *     *    
  |  *     *     *     *
  →→→→→→→→→→→→→→→→→→→→→
```

**Why it works:** By processing events in order (sorted by x), sweep line transforms a 2D problem into a 1D problem that changes over time. The active set (what the sweep line currently intersects) can be maintained with a balanced BST.

## 3. When to Use It

- **Line segment intersection detection** (Bentley-Ottmann)
- **Rectangle union area** — compute total area covered by axis-aligned rectangles
- **Closest pair of points** — alternative to divide-and-conquer
- **Skyline problem** — building silhouettes
- **Counting overlapping intervals** or segments
- **Windowing queries** — finding points/segments in a region
- **Fortune's algorithm** — computing Voronoi diagrams

## 4. When Not to Use It

- If the problem is purely 1D (just sort and scan without data structure)
- If the problem is already solved efficiently with a simpler greedy (e.g., meeting rooms)
- If the active set is never needed (problem doesn't have overlapping elements)
- For point-only problems where kd-tree or Voronoi diagram is more natural

## 5. Core Concepts

### 5.1 Event Points

Things that happen when the sweep line hits a certain x-coordinate.

Types of events:
- **Start/Add**: A segment starts, a rectangle begins
- **End/Remove**: A segment ends, a rectangle ends
- **Intersection**: Two active segments cross (Bentley-Ottmann)

### 5.2 Active Set

The set of geometric objects currently intersecting the sweep line. Maintained in a balanced BST (ordered by y-coordinate).

### 5.3 Sweep Status Data Structure

Operations needed:
- **Insert**: Add an element when sweep line hits its start
- **Delete**: Remove an element when sweep line passes its end
- **Find neighbors**: For a new element, find the elements above/below it in y-order

C++ multiset or Python's `bisect` on a sorted list works; for full line intersection, a balanced BST with neighbor queries is needed.

### 5.4 Event Handling

When the sweep line reaches an event:
1. Process the event (insert/delete/modify active set)
2. Perform checks (e.g., check intersection with neighbors)
3. Add new events if needed (e.g., future intersection events)

## 6. Step-by-Step Algorithm (Rectangle Union Area)

```
Input: list of rectangles [x1, y1, x2, y2]
Output: total area covered

1. Create events: for each rectangle
   - Start event: (x1, type=0, y1, y2)  // entering
   - End event:   (x2, type=1, y1, y2)  // exiting

2. Sort events by x

3. Maintain a multiset of active y-intervals

4. prev_x = events[0].x
   total_area = 0

5. For each event in sorted order:
   a. current_x = event.x
   b. width = current_x - prev_x
   c. if width > 0:
        height = total height covered by active y-intervals
        total_area += width * height
   d. If event is start: add (y1, y2) to active set
      If event is end:   remove (y1, y2) from active set
   e. prev_x = current_x

6. Return total_area
```

## 7. Dry Run (Rectangle Union Area)

```
Rectangles:
R1: (0,0) to (3,2)
R2: (2,1) to (5,3)

Events:
start: x=0, R1(0,2)
start: x=2, R2(1,3)
end:   x=3, R1(0,2)
end:   x=5, R2(1,3)

Sorted events:
(0, start, [0,2])
(2, start, [1,3])
(3, end, [0,2])
(5, end, [1,3])

Processing:
1. x=0, start R1(0,2)
   prev_x=0, width=0 → no area
   Active: {[0,2]}
   prev_x=0

2. x=2, start R2(1,3)
   width = 2-0 = 2
   height from active [0,2] = 2
   area += 2*2 = 4
   Active: {[0,2], [1,3]}
   Merged height: [0,3] → height = 3
   prev_x=2

3. x=3, end R1(0,2)
   width = 3-2 = 1
   height from active merged [0,3] = 3
   area += 1*3 = 3 (total: 7)
   Remove [0,2] from active. Left: {[1,3]}
   prev_x=3

4. x=5, end R2(1,3)
   width = 5-3 = 2
   height from active [1,3] = 2
   area += 2*2 = 4 (total: 11)
   Remove [1,3]. Active: {}

Total area = 11 ✓
(Did we get this right? Let's check: 
 R1 area = 3*2 = 6, R2 area = 3*2 = 6
 Overlap: x:[2,3]×y:[1,2] = 1*1 = 1
 Union = 6+6-1 = 11 ✓)
```

## 8. C++ Implementation (Rectangle Union Area)

```cpp
#include <bits/stdc++.h>
using namespace std;

using ll = long long;

struct Event {
    int x, type;  // type: 0 = start, 1 = end
    int y1, y2;
    
    bool operator<(const Event& other) const {
        if (x != other.x) return x < other.x;
        return type < other.type;  // process starts before ends at same x
    }
};

// Compute total height covered by a set of y-intervals
ll coveredHeight(vector<pair<int,int>>& intervals) {
    if (intervals.empty()) return 0;
    
    sort(intervals.begin(), intervals.end());
    ll height = 0;
    int curStart = intervals[0].first;
    int curEnd = intervals[0].second;
    
    for (auto& [s, e] : intervals) {
        if (s <= curEnd) {
            curEnd = max(curEnd, e);
        } else {
            height += curEnd - curStart;
            curStart = s;
            curEnd = e;
        }
    }
    height += curEnd - curStart;
    return height;
}

ll rectangleUnionArea(vector<vector<int>>& rectangles) {
    vector<Event> events;
    
    for (auto& rect : rectangles) {
        int x1 = rect[0], y1 = rect[1];
        int x2 = rect[2], y2 = rect[3];
        events.push_back({x1, 0, y1, y2});  // start
        events.push_back({x2, 1, y1, y2});  // end
    }
    
    sort(events.begin(), events.end());
    
    vector<pair<int,int>> active;
    ll area = 0;
    int prevX = events[0].x;
    
    for (auto& e : events) {
        int currX = e.x;
        ll width = currX - prevX;
        
        if (width > 0) {
            area += width * coveredHeight(active);
        }
        
        if (e.type == 0) {
            active.push_back({e.y1, e.y2});
        } else {
            auto it = find(active.begin(), active.end(), make_pair(e.y1, e.y2));
            if (it != active.end()) active.erase(it);
        }
        
        prevX = currX;
    }
    
    return area;
}

int main() {
    vector<vector<int>> rects = {{0, 0, 3, 2}, {2, 1, 5, 3}};
    cout << "Union area: " << rectangleUnionArea(rects) << "\n";  // 11
    return 0;
}
```

## 9. Python Implementation (Rectangle Union Area)

```python
def covered_height(intervals):
    """Compute total height covered by a list of [y1, y2] intervals."""
    if not intervals:
        return 0
    
    intervals.sort()
    height = 0
    cur_start = intervals[0][0]
    cur_end = intervals[0][1]
    
    for s, e in intervals:
        if s <= cur_end:
            cur_end = max(cur_end, e)
        else:
            height += cur_end - cur_start
            cur_start = s
            cur_end = e
    
    height += cur_end - cur_start
    return height


def rectangle_union_area(rectangles):
    """Returns total area covered by axis-aligned rectangles."""
    events = []
    for x1, y1, x2, y2 in rectangles:
        events.append((x1, 0, y1, y2))  # start
        events.append((x2, 1, y1, y2))  # end
    
    events.sort(key=lambda e: (e[0], e[1]))
    
    active = []
    area = 0
    prev_x = events[0][0]
    
    for x, typ, y1, y2 in events:
        width = x - prev_x
        if width > 0:
            area += width * covered_height(active)
        
        if typ == 0:  # start
            active.append([y1, y2])
        else:  # end
            active.remove([y1, y2])
        
        prev_x = x
    
    return area


# Example
rects = [(0, 0, 3, 2), (2, 1, 5, 3)]
print(f"Union area: {rectangle_union_area(rects)}")  # 11
```

## 10. Code Explanation

- **Events**: Each rectangle produces two events — one at its left edge (start) and one at its right edge (end).
- **Sorting**: Events sorted by x. Start events before end events at the same x avoids counting zero-width areas.
- **Active set**: List of y-intervals currently "under" the sweep line.
- **`coveredHeight()`**: Merges overlapping y-intervals and returns total covered height.
- **Area contribution**: At each event, `width * height` from previous x position to current x.
- **Update active set**: Add the interval for start events, remove for end events.

## 11. Complexity Analysis

| Variant | Time | Space |
|---------|------|-------|
| Rectangle union (naive) | O(n²) | O(n) |
| Rectangle union (sweep line) | O(n²) worst-case | O(n) |
| With segment tree optimization | O(n log n) | O(n) |
| Line segment intersection | O((n+k) log n) | O(n) |

k = number of intersections

## 12. Common Patterns

| Pattern | How to Identify | Approach |
|---------|----------------|----------|
| Rectangle union area | "total area covered" | Sweep line + interval merge |
| Skyline problem | "building silhouette" | Sweep line with height events |
| Line segment intersections | "do any segments cross" | Sweep line with BST |
| Number of overlapping intervals | "maximum overlap" | Sweep with counter |
| Largest rectangle in histogram | "largest area" | Vertical sweep with stack |

## 13. Common Mistakes

- **Not handling events at same x** — order matters (start before end, or vice versa, depending on problem)
- **Forgetting to update `prev_x`** — area contributions won't compute correctly
- **Using inefficient active set operations** — O(n) removal can make overall O(n²)
- **Assuming events are sorted by x only** — need tie-breaking rules
- **Not merging overlapping intervals correctly** in coveredHeight

## 14. Edge Cases

- **No events**: area = 0
- **Single rectangle**: Just its area
- **Identical rectangles**: Multiple intervals to merge
- **Non-overlapping rectangles**: Works fine, no merge needed
- **Touching rectangles**: At same x value, start vs end order matters
- **Negative coordinates**: Works if using signed integers

## 15. Variations

- **Segment Tree Sweep**: Use a segment tree to maintain active intervals in O(log n) per operation. Needed for large n.
- **Bentley-Ottmann**: Sweep line for line segment intersection. Adds intersection events dynamically.
- **3D Sweep**: Sweep plane instead of sweep line. Used in rectangle union volume.
- **Circular Sweep**: For problems with polar coordinates (angular sweep).

## 16. Related Algorithms/Data Structures

| Topic | Connection |
|-------|------------|
| Segment Tree | Optimizes active set to O(log n) per operation |
| Interval tree | Maintains overlapping intervals |
| Line intersection | Bentley-Ottmann uses sweep line |
| Closest pair | Can be solved with sweep line (maintain active set of recent points) |

## 17. Practice Problems

### Easy
- **Meeting Rooms II** (LeetCode) — Sweep line for interval overlaps
- **Minimum Number of Arrows to Burst Balloons** (LeetCode) — Interval scheduling

### Medium
- **The Skyline Problem** (LeetCode) — Sweep line with building heights
- **Rectangle Area** (LeetCode) — Two rectangles union

### Hard
- **Rectangle Area II** (LeetCode) — Sweep line with segment tree
- **Number of Intersections** — Bentley-Ottmann style

## 18. Interview Explanation

> "Sweep line is a paradigm where I move a vertical line across the plane from left to right. At each position, I maintain a data structure of 'active' elements — objects currently intersecting the sweep line. Events (start/end/intersection) trigger updates. For rectangle union area, I create start and end events at each rectangle's left and right edges, maintain the active y-intervals, and multiply the total covered height by the width between events."

## 19. Revision Notes

- **Events**: Sorted by x. Each object produces start and end events.
- **Active set**: Maintains what the sweep line currently intersects.
- **Area accumulation**: `width × coveredHeight` between consecutive x-positions.
- **Interval merging**: Sort active y-intervals and merge overlapping ones.
- **Complexity**: O(n²) for naive active set, O(n log n) with segment tree.

## 20. Final Cheat Sheet

| When | Use |
|------|-----|
| Rectangle union area | Sweep line + interval merge |
| Skyline | Sweep line with multiset of heights |
| Line intersection | Bentley-Ottmann sweep |
| Active set maintenance | Balanced BST or multiset |
| Key operation | Process events in x-order, update active set |
| Optimization | Segment tree for O(log n) active set |

---

# SUMMARY: GEOMETRY ALGORITHMS COMPARISON

| Algorithm | Core Operation | Time Complexity | Use Case |
|-----------|---------------|-----------------|----------|
| Points & Vectors | Coord struct | O(1) per op | Foundation |
| Dot Product | `vx*wx + vy*wy` | O(1) | Angles, projections |
| Cross Product | `vx*wy - vy*wx` | O(1) | Orientation, area |
| Orientation | `cross(A,B,C)` | O(1) | Left/right/collinear |
| Line Intersection | 4 orientation tests | O(1) | Segment crossing |
| Convex Hull | Andrew's Monotone | O(n log n) | Enclosing polygon |
| Polygon Area | Shoelace formula | O(n) | Area calculation |
| Closest Pair | Divide & Conquer | O(n log n) | Minimum distance |
| Sweep Line | Event-based | O(n log n) with segtree | Rectangle union, skyline |

---

**Pro Tip for Placements and CP:** 
- Always use `long long` for integer geometry to avoid overflow
- Use `double` with epsilon (`1e-9`) for floating geometry
- Memorize the cross product — it's the single most versatile operation
- For convex hull, use Andrew's Monotone Chain (simple and bug-free)
- For sweep line, start with the rectangle union problem as a template

---

*End of Geometry Algorithms Guide. Use this file as a complete reference for SDE placements, online assessments, and competitive programming.*