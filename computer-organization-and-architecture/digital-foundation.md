# Binary, Octal, and Hexadecimal Number Systems

## 1. Overview

Binary, octal, and hexadecimal are positional number systems used to represent numeric data in computers.

| System | Base | Digits | Common Use |
|---|---:|---|---|
| Binary | 2 | 0, 1 | Actual machine-level representation |
| Octal | 8 | 0-7 | Compact grouping of binary bits in 3s |
| Hexadecimal | 16 | 0-9, A-F | Compact grouping of binary bits in 4s |

They matter because every instruction, address, character, image, packet, and program eventually becomes bits. Interviewers ask this topic to check whether you understand how high-level data becomes low-level representation.

Real systems use hexadecimal for memory addresses, color values, machine code, debugging dumps, bitmasks, Unicode code points, and network packet inspection. Binary is used by hardware circuits directly. Octal appears less often today, but is still seen in Unix permissions such as `chmod 755`.

## 2. Core Idea

A positional number system gives each digit a weight based on its position.

In decimal:

```text
345 = 3 * 10^2 + 4 * 10^1 + 5 * 10^0
```

In binary:

```text
1011₂ = 1 * 2^3 + 0 * 2^2 + 1 * 2^1 + 1 * 2^0
       = 8 + 0 + 2 + 1
       = 11₁₀
```

Analogy: imagine boxes where each box is worth more than the previous one. In decimal each box is 10 times bigger. In binary each box is 2 times bigger. In hex each box is 16 times bigger.

Step-by-step binary to decimal:

```text
Binary: 1 0 1 1 0
Weight:16 8 4 2 1
Value: 16 + 0 + 4 + 2 + 0 = 22
```

Hex is useful because 4 binary bits map exactly to 1 hex digit:

```text
1111₂ = F₁₆
1010₂ = A₁₆
0011₂ = 3₁₆
```

## 3. Important Subtopics

### Positional Notation

Each digit has a place value. In base `b`, the rightmost digit has weight `b^0`, then `b^1`, `b^2`, and so on.

Why it matters: conversion questions become easy if you understand weights.

Example:

```text
203₈ = 2 * 8^2 + 0 * 8^1 + 3 * 8^0 = 131₁₀
```

Common interview angle: convert a number and explain the calculation.

### Decimal to Binary Conversion

Repeatedly divide by 2 and collect remainders from bottom to top.

Example:

```text
13 / 2 = 6 remainder 1
6 / 2  = 3 remainder 0
3 / 2  = 1 remainder 1
1 / 2  = 0 remainder 1

13₁₀ = 1101₂
```

Common interview angle: write code to convert without using library functions.

### Binary to Octal

Group bits in sets of 3 from the right.

```text
101101₂ = 101 101 = 5 5 = 55₈
```

Common interview angle: why octal groups use 3 bits. Because `2^3 = 8`.

### Binary to Hexadecimal

Group bits in sets of 4 from the right.

```text
11010110₂ = 1101 0110 = D6₁₆
```

Common interview angle: why hex is preferred in debugging. It is compact and aligns cleanly with bytes.

### Hexadecimal Digits

Hex uses A-F for decimal values 10-15.

| Hex | Decimal | Binary |
|---|---:|---|
| A | 10 | 1010 |
| B | 11 | 1011 |
| C | 12 | 1100 |
| D | 13 | 1101 |
| E | 14 | 1110 |
| F | 15 | 1111 |

Common interview angle: convert memory addresses or bitmasks.

## 4. Real-World Example

In an operating system debugger, memory might be shown as:

```text
0x7FFE12A0: 48 8B 05 F1 23 00 00
```

The address is hexadecimal. Each byte is shown as two hex digits because one byte is 8 bits and one hex digit is 4 bits. This helps engineers inspect binary machine code without reading long binary strings.

## 5. Diagrams / Mental Models

```text
1 hex digit = 4 bits
2 hex digits = 8 bits = 1 byte

Byte:      1011 0110
Hex:         B    6
```

Base conversion mental model:

```text
Decimal value
   |
   | repeated division
   v
Target base digits

Target base digits
   |
   | sum digit * base^position
   v
Decimal value
```

## 6. Common Interview Questions

### 1. What is binary number system?

Binary is a base-2 number system using only `0` and `1`.

Key points: computers use binary because digital circuits naturally represent two stable voltage levels.

Common mistake: saying binary is only for integers. Binary can represent integers, fractions, text, images, instructions, and more.

### 2. Convert `101101₂` to decimal.

`101101₂ = 32 + 0 + 8 + 4 + 0 + 1 = 45₁₀`.

Key points: use powers of 2 from right to left.

Common mistake: reading it as decimal one hundred one thousand.

### 3. Convert `45₁₀` to binary.

Divide by 2 repeatedly:

```text
45 -> 22 r1
22 -> 11 r0
11 -> 5  r1
5  -> 2  r1
2  -> 1  r0
1  -> 0  r1
```

Answer: `101101₂`.

Key points: read remainders bottom to top.

Common mistake: reading remainders top to bottom.

### 4. Why is hexadecimal used in computer systems?

Hexadecimal is compact and maps exactly to binary in groups of 4 bits.

Key points: used for memory addresses, byte dumps, colors, opcodes, bitmasks.

Common mistake: saying hex is faster for the computer. It is mainly easier for humans.

### 5. Convert `AF₁₆` to decimal.

`A = 10`, `F = 15`.

```text
AF₁₆ = 10 * 16 + 15 = 175₁₀
```

Key points: hex digits A-F represent 10-15.

Common mistake: treating A as alphabetic text.

### 6. Convert `11110010₂` to hexadecimal.

Group into 4 bits:

```text
1111 0010 = F2₁₆
```

Key points: each 4-bit group maps to one hex digit.

Common mistake: grouping from the left without padding correctly.

### 7. Convert `745₈` to binary.

Each octal digit maps to 3 bits:

```text
7 4 5
111 100 101

745₈ = 111100101₂
```

Key points: octal digit range is 0-7.

Common mistake: allowing digit 8 or 9 in octal.

### 8. Why does one byte need two hex digits?

One byte is 8 bits. One hex digit represents 4 bits. So 2 hex digits represent 8 bits.

Key points: `0x00` to `0xFF` covers 0 to 255.

Common mistake: assuming one hex digit is one byte.

### 9. What is the difference between base and radix?

They mean the same thing: the number of unique digits used in a positional system.

Key points: binary base 2, decimal base 10, hex base 16.

Common mistake: thinking radix applies only to decimal.

### 10. What does the prefix `0x` mean?

`0x` usually indicates that the following number is hexadecimal.

Key points: language conventions may also include `0b` for binary and leading `0` or `0o` for octal.

Common mistake: including `0x` as part of the numeric value.

## 7. Deep-Dive Questions

### 1. Why is hex better than decimal for bitmasks?

Because each hex digit maps to exactly 4 bits, so bit positions are easier to see.

Example: `0xF0 = 11110000₂`.

### 2. How do you convert a fractional decimal number to binary?

Repeatedly multiply the fractional part by 2 and record the integer parts.

Example:

```text
0.625 * 2 = 1.25 -> 1
0.25  * 2 = 0.5  -> 0
0.5   * 2 = 1.0  -> 1

0.625₁₀ = 0.101₂
```

### 3. Can every decimal fraction be represented exactly in binary?

No. Fractions like `0.1₁₀` repeat infinitely in binary, just like `1/3` repeats in decimal.

### 4. Why do memory dumps prefer hex over binary?

Hex is 4 times shorter than binary and still preserves exact bit structure.

### 5. What is endianness, and is it the same as number base?

Endianness is byte order in memory. Number base is representation format. They are different. `0x12345678` may be stored as `78 56 34 12` on little-endian machines.

## 8. Comparison Tables

| Feature | Binary | Octal | Hexadecimal |
|---|---|---|---|
| Base | 2 | 8 | 16 |
| Digits | 0, 1 | 0-7 | 0-9, A-F |
| Bit grouping | 1 bit | 3 bits | 4 bits |
| Compactness | Low | Medium | High |
| Common use | Hardware | Unix permissions | Debugging, memory, machine code |

| Conversion | Method |
|---|---|
| Decimal to binary | Repeated division by 2 |
| Binary to decimal | Sum powers of 2 |
| Binary to octal | Group bits by 3 |
| Binary to hex | Group bits by 4 |
| Hex to binary | Replace each hex digit with 4 bits |

## 9. Common Mistakes

* Forgetting to read division remainders from bottom to top.
* Treating `10₂` as decimal 10 instead of decimal 2.
* Using digits 8 and 9 in octal.
* Forgetting that hex `A` means decimal 10.
* Grouping binary bits from the wrong side during octal or hex conversion.
* Confusing byte order with number base.

## 10. Edge Cases / Special Cases

* Leading zeros do not change numeric value, but they may matter for fixed-width storage.
* `0xFF` is 255 unsigned, but it can mean `-1` in 8-bit two's complement.
* Binary fractions may be repeating.
* Some programming languages treat leading-zero integer literals differently.
* Hex letters are case-insensitive: `0xAF` and `0xaf` usually mean the same value.

## 11. How to Explain in Interview

"Binary, octal, and hexadecimal are positional number systems. Binary is what hardware uses internally. Octal and hexadecimal are compact human-friendly ways to write binary, with octal grouping 3 bits and hex grouping 4 bits. Hex is especially common because two hex digits exactly represent one byte."

## 12. Quick Revision Notes

* Binary base: 2.
* Octal base: 8.
* Hex base: 16.
* 1 octal digit = 3 bits.
* 1 hex digit = 4 bits.
* 2 hex digits = 1 byte.
* Convert decimal to binary using repeated division.
* Convert binary to decimal using powers of 2.
* Interview trap: fixed-width interpretation changes meaning.

## 13. Practice Tasks

* Convert `10101101₂` to decimal, octal, and hexadecimal.
* Convert `255₁₀` to binary and hex.
* Write a C++ or Python function to convert decimal to binary.
* Convert `0x3F` to binary and decimal.
* Explain why `0.1` cannot be represented exactly in binary floating point.
* Decode Unix permission `755` into binary permission bits.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Positional systems with bases 2, 8, and 16 |
| Why it matters | Computers store and process everything as bits |
| Most asked questions | Convert between decimal, binary, octal, hex |
| Common comparison | Binary is machine-friendly; hex is human-friendly |
| One-line interview answer | "Hex and octal are compact ways to write binary; hex maps 4 bits per digit and is used heavily in memory and debugging." |

# Signed and Unsigned Representation

## 1. Overview

Unsigned representation stores only non-negative integers. Signed representation stores both positive and negative integers.

For `n` bits:

| Representation | Range |
|---|---|
| Unsigned | `0` to `2^n - 1` |
| Signed two's complement | `-2^(n-1)` to `2^(n-1) - 1` |

This matters because the same bit pattern can mean different values depending on interpretation.

Example:

```text
11111111
Unsigned 8-bit: 255
Signed 8-bit two's complement: -1
```

Interviewers ask this because bugs in low-level code, C/C++, network protocols, binary files, and security often come from signed/unsigned confusion.

## 2. Core Idea

Bits do not inherently know whether they are signed or unsigned. The type or instruction tells the system how to interpret them.

Analogy: the same text `10` could mean ten dollars, ten kilograms, or jersey number ten. The symbols are the same, but the context gives meaning.

Small example with 4 bits:

| Bits | Unsigned | Signed Two's Complement |
|---|---:|---:|
| 0000 | 0 | 0 |
| 0001 | 1 | 1 |
| 0111 | 7 | 7 |
| 1000 | 8 | -8 |
| 1111 | 15 | -1 |

The most significant bit is often called the sign bit in signed representation. In two's complement, `0` means non-negative and `1` means negative.

## 3. Important Subtopics

### Unsigned Integers

Unsigned integers use all bits for magnitude.

Example: 8-bit unsigned range is `0` to `255`.

Why it matters: unsigned is useful for sizes, memory addresses, bitmasks, and raw bytes.

Common interview angle: calculate maximum representable value.

### Signed Integers

Signed integers reserve interpretation space for negative numbers.

Example: 8-bit signed two's complement range is `-128` to `127`.

Why it matters: normal arithmetic needs negative values.

Common interview angle: explain why positive max is one less than absolute negative min.

### Sign Bit

The leftmost bit indicates sign in many signed formats.

Example in 8-bit two's complement:

```text
01111111 = +127
10000000 = -128
```

Common interview angle: identify whether a number is negative from its bit pattern.

### Type Interpretation

The CPU register just stores bits. The operation decides signed or unsigned behavior.

Example: signed comparison and unsigned comparison produce different results for the same bits.

Common interview angle: why `-1` can become a huge positive number when cast to unsigned.

## 4. Real-World Example

In C/C++, if a signed `int` is compared with an unsigned `size_t`, the signed value may be converted to unsigned.

```cpp
int i = -1;
size_t n = 10;
// i may be converted to a very large unsigned value
```

This can cause loops, bounds checks, and security checks to behave incorrectly.

## 5. Diagrams / Mental Models

8-bit unsigned number line:

```text
00000000 ---------------------------- 11111111
    0                                      255
```

8-bit signed two's complement number line:

```text
10000000 ... 11111111 00000000 ... 01111111
  -128          -1        0           +127
```

The two's complement number line wraps like a clock.

## 6. Common Interview Questions

### 1. What is unsigned representation?

Unsigned representation stores only non-negative integers using all bits for magnitude.

Key points: range for `n` bits is `0` to `2^n - 1`.

Common mistake: saying unsigned has a sign bit.

### 2. What is signed representation?

Signed representation stores positive, zero, and negative values.

Key points: modern systems usually use two's complement.

Common mistake: assuming sign-magnitude is used by normal integer hardware.

### 3. What is the range of 8-bit unsigned integer?

`0` to `255`.

Key points: `2^8 = 256` possible values.

Common mistake: saying `0` to `256`.

### 4. What is the range of 8-bit signed two's complement integer?

`-128` to `127`.

Key points: range is `-2^7` to `2^7 - 1`.

Common mistake: saying `-127` to `127`.

### 5. Why is the signed range asymmetric?

Because zero is included in the non-negative side, leaving one extra negative value.

Key points: two's complement has one representation for zero.

Common mistake: thinking a positive `+128` exists in 8-bit signed.

### 6. What does `11111111` mean?

It depends on interpretation. Unsigned 8-bit: `255`. Signed 8-bit two's complement: `-1`.

Key points: bit pattern and type both matter.

Common mistake: giving only one answer without context.

### 7. What is sign extension?

Sign extension preserves the value when increasing width by copying the sign bit.

Example:

```text
8-bit -1:  11111111
16-bit -1: 11111111 11111111
```

Key points: used for signed widening.

Common mistake: zero-extending negative numbers.

### 8. What is zero extension?

Zero extension pads with zeros when widening unsigned values.

Example:

```text
8-bit 255:  11111111
16-bit 255: 00000000 11111111
```

Key points: used for unsigned widening.

Common mistake: sign-extending unsigned values.

### 9. Why can signed/unsigned comparison be dangerous?

Because a negative signed value may convert to a large unsigned value.

Key points: common in C/C++ bugs.

Common mistake: assuming comparison happens mathematically instead of by language conversion rules.

### 10. Is a memory address signed or unsigned?

Addresses are normally treated as unsigned numeric values.

Key points: addresses identify locations, not negative quantities.

Common mistake: using signed integer types for pointer arithmetic or sizes.

## 7. Deep-Dive Questions

### 1. How does signed comparison differ from unsigned comparison at CPU level?

The same subtraction may set flags, but signed comparison interprets overflow and sign flags, while unsigned comparison uses carry and zero flags.

### 2. Why are unsigned integers useful for bit manipulation?

Because shifts, masks, and raw byte interpretation are clearer when bits are treated as pure patterns.

### 3. Can signed overflow be undefined?

In C and C++, signed integer overflow is undefined behavior, while unsigned overflow wraps modulo `2^n`.

### 4. Why is `size_t` unsigned?

It represents object sizes and counts, which cannot be negative. But mixing it with signed values requires care.

### 5. What happens when `-1` is cast to 32-bit unsigned?

It becomes `2^32 - 1`, usually `4294967295`, because the bit pattern is interpreted as unsigned.

## 8. Comparison Tables

| Feature | Unsigned | Signed Two's Complement |
|---|---|---|
| Values | Non-negative only | Negative, zero, positive |
| 8-bit range | 0 to 255 | -128 to 127 |
| MSB meaning | Magnitude bit | Sign/weight bit |
| Widening | Zero extension | Sign extension |
| Overflow | Wraps in many languages | May be undefined in C/C++ |

| 8-bit Bits | Unsigned | Signed |
|---|---:|---:|
| 00000000 | 0 | 0 |
| 00000001 | 1 | 1 |
| 01111111 | 127 | 127 |
| 10000000 | 128 | -128 |
| 11111111 | 255 | -1 |

## 9. Common Mistakes

* Thinking the bit pattern itself is signed or unsigned.
* Forgetting range formulas.
* Assuming signed range is symmetric.
* Using unsigned values to avoid negative bugs, then causing underflow bugs.
* Comparing signed and unsigned values carelessly.

## 10. Edge Cases / Special Cases

* `INT_MIN` cannot be negated in same-width two's complement.
* `-1` often becomes maximum unsigned value.
* Right shift of signed negative values can be language-dependent.
* Network and file formats usually specify exact unsigned widths.
* Integer promotions can change expression behavior.

## 11. How to Explain in Interview

"Unsigned integers use all bits for non-negative values. Signed integers interpret the same bits as positive or negative, usually using two's complement. So a bit pattern like `11111111` can be 255 unsigned or -1 signed, depending on the type and operation."

## 12. Quick Revision Notes

* Unsigned `n`-bit range: `0` to `2^n - 1`.
* Signed two's complement range: `-2^(n-1)` to `2^(n-1)-1`.
* Same bits can have different meanings.
* Sign extension copies MSB.
* Zero extension pads zeros.
* Interview trap: signed/unsigned comparisons.

## 13. Practice Tasks

* List all 4-bit unsigned and signed two's complement values.
* Convert `11101010` to unsigned and signed decimal.
* Show sign extension from 8-bit to 16-bit for `-5`.
* Write a C/C++ snippet where signed/unsigned comparison surprises you.
* Explain why 8-bit signed max is 127, not 128.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Signedness tells how a bit pattern is interpreted |
| Why it matters | Prevents range, cast, overflow, and comparison bugs |
| Most asked questions | Ranges, sign extension, `11111111`, signed/unsigned comparison |
| Common comparison | Unsigned uses all bits for magnitude; signed uses two's complement |
| One-line interview answer | "The same bits can mean different values; signedness is an interpretation supplied by the type or instruction." |

# One's and Two's Complement

## 1. Overview

One's complement and two's complement are methods for representing negative binary numbers.

One's complement forms a negative number by flipping every bit. Two's complement forms it by flipping every bit and adding 1.

Modern computers use two's complement for signed integers because it gives one zero, simple arithmetic, and easy hardware implementation.

Interviewers ask this because it is the foundation of signed integer arithmetic and overflow detection.

## 2. Core Idea

Think of fixed-width binary numbers as a circular clock. With 4 bits, there are 16 patterns. Two's complement assigns half to non-negative values and half to negative values.

Example: represent `-5` in 8-bit two's complement.

```text
+5        = 00000101
Flip bits = 11111010
Add 1     = 11111011

-5 = 11111011
```

To check:

```text
00000101
+11111011
=1 00000000
```

Discard the carry beyond 8 bits, result is zero.

## 3. Important Subtopics

### One's Complement

Negative number is obtained by bitwise inversion.

Example:

```text
+5 = 00000101
-5 = 11111010
```

Why it matters: historically important and useful for understanding checksum arithmetic.

Common interview angle: identify the problem of two zeros.

### Two's Complement

Negative number is obtained by one's complement plus 1.

Example:

```text
+5 = 00000101
-5 = 11111011
```

Why it matters: used in modern signed integer representation.

Common interview angle: convert negative numbers and explain range.

### Negative Weights

In two's complement, the MSB has negative weight.

For 4-bit:

```text
Bits:    b3 b2 b1 b0
Weights: -8 4  2  1
```

Example:

```text
1011 = -8 + 0 + 2 + 1 = -5
```

Common interview angle: directly evaluate a two's complement number.

### Addition in Two's Complement

The same binary adder works for signed and unsigned addition. Extra carry is discarded.

Why it matters: hardware becomes simpler.

Common interview angle: add positive and negative numbers using binary.

## 4. Real-World Example

CPU arithmetic logic units use two's complement addition for signed integers. When a program calculates:

```cpp
int x = 7;
int y = -3;
int z = x + y;
```

The hardware can use the same adder used for unsigned addition. The interpretation of flags decides whether signed overflow occurred.

## 5. Diagrams / Mental Models

4-bit two's complement circle:

```text
0000  0
0001  1
0010  2
...
0111  7
1000 -8
1001 -7
...
1111 -1
```

Two's complement recipe:

```text
Positive binary -> flip bits -> add 1 -> negative binary
```

## 6. Common Interview Questions

### 1. What is one's complement?

One's complement represents a negative number by flipping all bits of the positive number.

Key points: it has both `+0` and `-0`.

Common mistake: forgetting the duplicate zero problem.

### 2. What is two's complement?

Two's complement represents a negative number by taking one's complement and adding 1.

Key points: modern computers use it for signed integers.

Common mistake: flipping bits but forgetting to add 1.

### 3. Represent `-6` in 8-bit two's complement.

```text
+6        = 00000110
Flip      = 11111001
Add 1     = 11111010
```

Answer: `11111010`.

Key points: fixed width matters.

Common mistake: not padding to 8 bits first.

### 4. Why is two's complement preferred over one's complement?

It has one zero and allows normal binary addition/subtraction without special handling.

Key points: simpler hardware.

Common mistake: saying it only increases range.

### 5. What is the 8-bit two's complement range?

`-128` to `127`.

Key points: `-2^7` to `2^7 - 1`.

Common mistake: saying `-127` to `127`.

### 6. Decode `11110100` as 8-bit two's complement.

MSB is 1, so negative. Find magnitude:

```text
11110100
Flip: 00001011
Add 1: 00001100 = 12
```

Answer: `-12`.

Key points: use fixed width.

Common mistake: converting it as unsigned 244.

### 7. What is the problem with sign-magnitude representation?

It has two zeros and arithmetic needs extra sign handling.

Key points: `00000000` and `10000000` can both represent zero in 8-bit sign-magnitude.

Common mistake: confusing it with two's complement.

### 8. How do you subtract using two's complement?

To compute `A - B`, add `A + two's_complement(B)`.

Key points: subtraction becomes addition.

Common mistake: subtracting bit by bit manually when complement addition is expected.

### 9. What is `10000000` in 8-bit two's complement?

`-128`.

Key points: it is the minimum value.

Common mistake: saying `-0` or `128`.

### 10. What is `11111111` in 8-bit two's complement?

`-1`.

Key points: all ones represent `-1`.

Common mistake: saying 255 without signed context.

## 7. Deep-Dive Questions

### 1. Why does two's complement addition work?

Because arithmetic is done modulo `2^n`. Negative `x` is represented as `2^n - x`, so adding it naturally subtracts `x` modulo the fixed width.

### 2. Why can `INT_MIN` not be represented as positive in same width?

For 8-bit, `-128` exists but `+128` does not. Negating it overflows because the positive range stops at 127.

### 3. How is overflow detected in two's complement addition?

Overflow occurs when adding two numbers with the same sign produces a result with the opposite sign.

### 4. Is carry-out the same as signed overflow?

No. Carry-out matters for unsigned overflow. Signed overflow depends on sign changes.

### 5. Why does two's complement have one extra negative number?

Because zero occupies one non-negative pattern, leaving one fewer positive value.

## 8. Comparison Tables

| Feature | One's Complement | Two's Complement |
|---|---|---|
| Negative formation | Flip bits | Flip bits and add 1 |
| Zero representations | Two | One |
| Arithmetic | Needs end-around carry | Simple binary addition |
| Modern integer use | Rare | Standard |
| 8-bit range | -127 to +127 | -128 to +127 |

| Representation | +5 | -5 |
|---|---|---|
| Sign-magnitude | 00000101 | 10000101 |
| One's complement | 00000101 | 11111010 |
| Two's complement | 00000101 | 11111011 |

## 9. Common Mistakes

* Forgetting to add 1 in two's complement.
* Not fixing the bit width before conversion.
* Treating carry-out as signed overflow.
* Assuming `10000000` means `-0`.
* Forgetting that two's complement has one zero.

## 10. Edge Cases / Special Cases

* Minimum negative value cannot be negated in same width.
* Carry-out is discarded in fixed-width two's complement arithmetic.
* One's complement has `+0` and `-0`.
* All ones means `-1` in two's complement.
* Sign extension must copy the sign bit.

## 11. How to Explain in Interview

"Two's complement represents negative numbers by flipping all bits of the positive value and adding one. It is used because the same binary adder can handle signed addition and subtraction, and it avoids the two-zero problem of one's complement."

## 12. Quick Revision Notes

* One's complement: invert bits.
* Two's complement: invert bits and add 1.
* 8-bit two's complement: `-128` to `127`.
* Same adder works for signed addition.
* Signed overflow: same signs in, different sign out.
* Trap: carry-out is not signed overflow.

## 13. Practice Tasks

* Represent `-13` in 8-bit two's complement.
* Decode `10110110` as signed two's complement.
* Add `7 + (-3)` using 4-bit two's complement.
* Show overflow for `0111 + 0001` in 4-bit signed arithmetic.
* Compare sign-magnitude, one's complement, and two's complement for `-9`.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Methods to encode negative binary numbers |
| Why it matters | Enables signed arithmetic in hardware |
| Most asked questions | Convert negative numbers, detect overflow, explain range |
| Common comparison | One's complement has two zeros; two's complement has one |
| One-line interview answer | "Two's complement is flip bits plus one, and it lets hardware use ordinary binary addition for signed arithmetic." |

# Integer Overflow and Underflow

## 1. Overview

Integer overflow happens when a calculation produces a value greater than the maximum representable value. Underflow happens when it goes below the minimum representable value.

For 8-bit unsigned:

```text
255 + 1 -> 0
0 - 1   -> 255
```

This matters because fixed-width integers are common in CPUs, languages, file formats, databases, and network protocols. Interviewers ask this topic because overflow bugs cause security vulnerabilities, infinite loops, corrupted counters, and incorrect business logic.

## 2. Core Idea

Fixed-width integers behave like a limited odometer.

Analogy: a 3-digit odometer after `999` rolls over to `000`. It did not become 1000 because there is no room to store 4 digits.

For `n` bits, arithmetic often happens modulo `2^n`.

Example with 4-bit unsigned:

```text
Maximum = 1111₂ = 15
15 + 1  = 10000₂
Keep 4 bits -> 0000₂ = 0
```

## 3. Important Subtopics

### Unsigned Overflow

Unsigned overflow wraps modulo `2^n` in languages like C/C++.

Example:

```text
8-bit: 250 + 10 = 260
260 mod 256 = 4
```

Common interview angle: explain wraparound.

### Signed Overflow

Signed overflow occurs when the mathematical result is outside signed range.

Example in 8-bit signed:

```text
127 + 1 -> overflow
01111111 + 00000001 = 10000000
```

The bit pattern `10000000` represents `-128`, not `128`.

Common interview angle: detect from signs.

### Underflow

Underflow means going below minimum representable value.

Example unsigned:

```text
0 - 1 -> 255 in 8-bit unsigned
```

Common interview angle: loop bugs with unsigned counters.

### Overflow Detection

For signed addition, overflow occurs when:

```text
positive + positive = negative
negative + negative = positive
```

For unsigned addition, overflow occurs when there is a carry out or result is smaller than an operand.

## 4. Real-World Example

In a backend server, suppose a request says:

```text
count = 4,000,000,000
item_size = 8
```

If `count * item_size` is stored in a 32-bit integer, it may overflow and allocate a much smaller buffer than required. Writing data into that buffer can cause memory corruption.

## 5. Diagrams / Mental Models

8-bit unsigned wrap:

```text
... 252 -> 253 -> 254 -> 255 -> 0 -> 1 -> 2 ...
```

8-bit signed wrap if hardware wraps:

```text
... 125 -> 126 -> 127 -> -128 -> -127 ...
```

Signed overflow rule:

```text
same sign operands + opposite sign result = overflow
```

## 6. Common Interview Questions

### 1. What is integer overflow?

Integer overflow occurs when a result exceeds the maximum value representable in the fixed number of bits.

Key points: fixed width, range limit, incorrect wrap or undefined behavior.

Common mistake: saying overflow only happens in addition.

### 2. What is integer underflow?

Integer underflow occurs when a result goes below the minimum representable value.

Key points: common with unsigned subtraction.

Common mistake: confusing integer underflow with floating-point underflow.

### 3. What happens when 8-bit unsigned `255 + 1` is computed?

It wraps to `0` under modulo 256 arithmetic.

Key points: `2^8 = 256`.

Common mistake: saying it stores 256.

### 4. What happens when 8-bit signed `127 + 1` is computed?

Mathematically it overflows. In raw two's complement bits, the result is `10000000`, interpreted as `-128`.

Key points: in C/C++, signed overflow is undefined behavior.

Common mistake: assuming all languages define wraparound for signed overflow.

### 5. How do you detect signed overflow in addition?

If both operands have the same sign and the result has a different sign, signed overflow occurred.

Key points: sign-based rule.

Common mistake: using carry-out alone.

### 6. How do you detect unsigned overflow in addition?

If result is smaller than either operand, or if carry-out occurs.

Key points: modulo wrap.

Common mistake: applying signed sign-bit logic.

### 7. Why is overflow dangerous in memory allocation?

Size calculations can wrap to a smaller value, causing undersized allocation and buffer overflow.

Key points: security vulnerability.

Common mistake: treating it as only a numeric correctness issue.

### 8. Give an example of unsigned underflow bug.

```cpp
for (size_t i = n - 1; i >= 0; --i) {}
```

When `i` reaches 0, decrementing wraps to a huge value.

Key points: unsigned values never become negative.

Common mistake: writing `i >= 0` for unsigned loops.

### 9. What is saturation arithmetic?

Saturation arithmetic clamps overflow results to min or max instead of wrapping.

Example: 8-bit saturated `255 + 1 = 255`.

Key points: used in DSP, graphics, image processing.

Common mistake: assuming CPUs always saturate.

### 10. Is overflow always an error?

No. It is intentional in hashing, checksums, cryptography, and modulo arithmetic.

Key points: context matters.

Common mistake: saying wraparound is always bad.

## 7. Deep-Dive Questions

### 1. Why is signed overflow undefined in C/C++?

The language allows compilers to assume signed overflow does not happen, enabling optimizations. This makes overflow bugs especially dangerous.

### 2. How can you avoid overflow in multiplication?

Check before multiplying: `a <= MAX / b` for positive integers. Or use a wider type / checked arithmetic API.

### 3. What is the difference between wraparound and saturation?

Wraparound returns modulo result. Saturation clamps to the nearest representable boundary.

### 4. Why does `mid = (low + high) / 2` risk overflow?

`low + high` can overflow. Safer form: `low + (high - low) / 2`.

### 5. How do modern languages handle overflow?

It varies. Java integer arithmetic wraps. Rust panics in debug for normal integer overflow and wraps in release unless using explicit checked/wrapping APIs. Python integers grow arbitrarily large.

## 8. Comparison Tables

| Feature | Overflow | Underflow |
|---|---|---|
| Meaning | Above maximum | Below minimum |
| Example unsigned 8-bit | `255 + 1 -> 0` | `0 - 1 -> 255` |
| Common cause | Addition, multiplication | Subtraction, decrement |
| Risk | Wrong value, security bug | Infinite loop, wrong index |

| Arithmetic Type | Behavior |
|---|---|
| Unsigned integer | Usually modulo wrap |
| Signed integer in C/C++ | Undefined on overflow |
| Saturating arithmetic | Clamps to min/max |
| Arbitrary precision integer | Grows as needed |

## 9. Common Mistakes

* Forgetting integers have fixed width.
* Assuming signed overflow always wraps.
* Using unsigned loop counters incorrectly.
* Ignoring overflow in multiplication.
* Confusing carry-out with signed overflow.
* Forgetting `INT_MIN * -1` overflows in fixed width.

## 10. Edge Cases / Special Cases

* `INT_MIN` negation overflows.
* `abs(INT_MIN)` cannot be represented in same signed type.
* Binary search midpoint can overflow.
* Size calculations for allocation are high-risk.
* Intentional overflow is common in hashing and cryptography.

## 11. How to Explain in Interview

"Integer overflow or underflow occurs when a fixed-width integer calculation goes outside its representable range. Unsigned arithmetic often wraps modulo `2^n`, while signed overflow may be undefined in languages like C/C++. It matters because it can break loops, bounds checks, and memory allocation."

## 12. Quick Revision Notes

* Overflow: result above max.
* Underflow: result below min.
* Unsigned 8-bit: `255 + 1 = 0`.
* Signed overflow: same sign operands, different sign result.
* Unsigned overflow: carry-out or result smaller.
* Trap: `size_t` loop underflow.

## 13. Practice Tasks

* Show 4-bit unsigned wraparound for `15 + 3`.
* Show 8-bit signed overflow for `100 + 50`.
* Write safe binary search midpoint formula.
* Write a checked multiplication condition.
* Find the bug in a reverse loop using `size_t`.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Fixed-width arithmetic goes outside representable range |
| Why it matters | Causes security, loop, allocation, and correctness bugs |
| Most asked questions | `255+1`, `127+1`, overflow detection |
| Common comparison | Unsigned wraps; signed may be undefined |
| One-line interview answer | "Overflow is not just a math issue; it is a fixed-width representation issue." |

# Fixed-Point and Floating-Point Representation

## 1. Overview

Fixed-point and floating-point are ways to represent real numbers using binary bits.

Fixed-point places the binary point at a fixed location. Floating-point stores numbers using a sign, exponent, and significand, so the point can move.

They matter because real programs handle prices, sensor readings, graphics, physics, ML values, timestamps, and measurements. Interviewers ask this topic to test whether you know why floating-point is approximate and when fixed-point is safer.

## 2. Core Idea

Fixed-point is like deciding that every amount has exactly two decimal places. For money, `12345` could mean `123.45`.

Floating-point is like scientific notation:

```text
6.02 * 10^23
```

Binary floating-point uses:

```text
sign * significand * 2^exponent
```

Fixed-point gives predictable precision over a fixed range. Floating-point gives a huge range but uneven precision.

## 3. Important Subtopics

### Fixed-Point Representation

The binary point is fixed by convention.

Example Q4.4 format:

```text
0110.1000₂ = 6.5₁₀
```

Why it matters: useful in embedded systems, finance-like scaled integers, DSP, and systems without floating-point hardware.

Common interview angle: explain scaled integer representation.

### Floating-Point Representation

Floating-point stores sign, exponent, and fraction.

Example:

```text
1.101₂ * 2^3
```

Why it matters: represents very large and very small values.

Common interview angle: why `0.1 + 0.2` may not equal `0.3`.

### Precision vs Range

Fixed-point has uniform spacing. Floating-point has wider spacing as magnitude grows.

Common interview angle: compare financial calculations and scientific calculations.

### Rounding Error

Many decimal fractions cannot be represented exactly in binary.

Example: `0.1₁₀` repeats in binary.

Common interview angle: floating-point comparison should use tolerance.

## 4. Real-World Example

Payment systems often store money as integer cents:

```text
$19.99 -> 1999 cents
```

This is fixed-point style. It avoids binary floating-point surprises. A physics simulation, however, would likely use floating-point because values may range from tiny velocities to huge distances.

## 5. Diagrams / Mental Models

Fixed-point:

```text
bits:  01101000
split: 0110 . 1000
       integer fractional
```

Floating-point:

```text
+/-     significand        exponent
 |          |                  |
 v          v                  v
sign * 1.xxxxxxx * 2^(exponent)
```

## 6. Common Interview Questions

### 1. What is fixed-point representation?

Fixed-point represents numbers with the radix point at a fixed position.

Key points: often implemented as scaled integers.

Common mistake: thinking fixed-point means integer only.

### 2. What is floating-point representation?

Floating-point represents numbers using sign, exponent, and significand.

Key points: similar to scientific notation.

Common mistake: saying it stores all decimal values exactly.

### 3. Why is floating-point approximate?

Because finite binary bits cannot exactly represent many decimal fractions.

Key points: `0.1` is repeating in binary.

Common mistake: blaming only programming language bugs.

### 4. Why is fixed-point used for money?

It provides predictable decimal scaling when stored as integers, avoiding binary floating-point rounding surprises.

Key points: store cents or smallest currency unit.

Common mistake: using `float` for exact money.

### 5. What is the main advantage of floating-point?

It can represent a very large range of magnitudes.

Key points: exponent moves the binary point.

Common mistake: saying it is always more accurate.

### 6. What is the main disadvantage of fixed-point?

Limited range and fixed precision.

Key points: scaling choice determines trade-off.

Common mistake: forgetting overflow can happen in scaled integers.

### 7. What does Q4.4 mean?

It means 4 integer bits and 4 fractional bits.

Key points: exact convention may include sign depending on context.

Common mistake: not clarifying signed vs unsigned.

### 8. Why should floating-point values not usually be compared with `==`?

Small rounding errors can make mathematically equal values differ by tiny amounts.

Key points: use epsilon tolerance.

Common mistake: using exact equality after arithmetic.

### 9. Is fixed-point faster than floating-point?

Sometimes, especially on hardware without a floating-point unit. On modern CPUs, floating-point may be very fast.

Key points: depends on hardware and workload.

Common mistake: making a universal claim.

### 10. What is quantization?

Quantization maps continuous values to discrete representable values.

Key points: both fixed and floating representations have finite precision.

Common mistake: thinking only analog-to-digital conversion has quantization.

## 7. Deep-Dive Questions

### 1. Why does floating-point precision decrease for large numbers?

Because the number of significand bits is fixed. As exponent grows, spacing between adjacent representable values grows.

### 2. How can fixed-point multiplication be handled?

Multiply the scaled integers, then adjust by the scaling factor. For scale `S`, `(a*S * b*S) / S` gives scaled result.

### 3. What is catastrophic cancellation?

It occurs when subtracting nearly equal floating-point numbers, causing significant digits to be lost.

### 4. When is floating-point better than fixed-point?

When values vary across large magnitudes, such as scientific computing, graphics, ML, or simulations.

### 5. When is decimal floating-point useful?

When decimal fractions need exact representation, such as financial calculations, though many systems still use scaled integers.

## 8. Comparison Tables

| Feature | Fixed-Point | Floating-Point |
|---|---|---|
| Point position | Fixed | Moves using exponent |
| Range | Smaller | Much larger |
| Precision spacing | Uniform | Non-uniform |
| Hardware complexity | Lower | Higher |
| Good for | Money, embedded, DSP | Science, graphics, ML |
| Main risk | Overflow/scaling errors | Rounding/precision errors |

| Use Case | Better Choice | Reason |
|---|---|---|
| Currency cents | Fixed-point | Exact integer arithmetic |
| 3D graphics | Floating-point | Wide dynamic range |
| Microcontroller sensor scaling | Fixed-point | Simple and predictable |
| Physics simulation | Floating-point | Handles tiny and huge values |

## 9. Common Mistakes

* Using floating-point for exact currency.
* Assuming `0.1` is exact in binary.
* Forgetting fixed-point can overflow.
* Comparing floats with exact equality.
* Thinking more range means more precision everywhere.

## 10. Edge Cases / Special Cases

* Very small floating-point values may become subnormal.
* Very large values may become infinity.
* `NaN` is not equal to itself.
* Fixed-point scaling must be agreed across modules.
* Rounding mode affects results.

## 11. How to Explain in Interview

"Fixed-point uses a fixed location for the radix point, often by storing scaled integers. Floating-point uses sign, exponent, and significand, like scientific notation, giving a much larger range but approximate precision. Fixed-point is preferred for exact scaled values like money; floating-point is preferred for scientific and graphics-style ranges."

## 12. Quick Revision Notes

* Fixed-point: fixed binary point.
* Floating-point: sign, exponent, significand.
* Fixed-point precision is uniform.
* Floating-point range is large.
* `0.1` is not exact in binary floating-point.
* Use epsilon for float comparisons.

## 13. Practice Tasks

* Represent `6.5` in unsigned Q4.4.
* Store `$123.45` as cents.
* Show why `0.1 + 0.2` can fail exact comparison.
* Write a tolerance-based float comparison function.
* Explain fixed-point multiplication with scale 100.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Real-number representation using fixed scale or movable exponent |
| Why it matters | Affects accuracy, range, and correctness |
| Most asked questions | `0.1+0.2`, fixed vs float, money representation |
| Common comparison | Fixed has predictable scale; float has huge range |
| One-line interview answer | "Fixed-point is scaled integer arithmetic; floating-point is binary scientific notation with rounding." |

# IEEE 754 Floating-Point Format

## 1. Overview

IEEE 754 is the standard format used by most computers to represent floating-point numbers.

It defines formats such as single precision and double precision, along with special values like `+0`, `-0`, infinity, and NaN.

It matters because almost every mainstream CPU, GPU, programming language, database engine, browser, and ML framework uses IEEE 754-style floating-point behavior. Interviewers ask this to check whether you understand precision, rounding, exponent bias, and special values.

## 2. Core Idea

IEEE 754 stores a number as:

```text
(-1)^sign * significand * 2^(exponent - bias)
```

For 32-bit single precision:

```text
1 sign bit | 8 exponent bits | 23 fraction bits
```

The leading `1` in normalized binary numbers is implicit, so the stored fraction gets one extra bit of effective precision.

Analogy: it is like scientific notation, but in base 2 and with a fixed number of digits.

## 3. Important Subtopics

### Single Precision

32 bits total:

| Field | Bits |
|---|---:|
| Sign | 1 |
| Exponent | 8 |
| Fraction | 23 |

Why it matters: used in graphics, ML tensors, and memory-sensitive workloads.

Common interview angle: field sizes and bias.

### Double Precision

64 bits total:

| Field | Bits |
|---|---:|
| Sign | 1 |
| Exponent | 11 |
| Fraction | 52 |

Why it matters: default `double` in many languages and scientific calculations.

Common interview angle: why double is more precise than float.

### Exponent Bias

The exponent is stored with a bias to avoid a separate exponent sign.

For single precision, bias is 127.

```text
actual exponent = stored exponent - 127
```

Common interview angle: decode a floating-point number.

### Normalized Numbers

Normalized binary floating-point numbers have an implicit leading 1:

```text
1.fraction * 2^exponent
```

Common interview angle: explain hidden bit.

### Special Values

Exponent all ones indicates infinity or NaN.

| Exponent | Fraction | Meaning |
|---|---|---|
| all 0 | 0 | zero |
| all 0 | nonzero | subnormal |
| all 1 | 0 | infinity |
| all 1 | nonzero | NaN |

Common interview angle: what is NaN and why `NaN != NaN`.

## 4. Real-World Example

JavaScript numbers are mostly IEEE 754 double precision. That is why:

```js
0.1 + 0.2 === 0.3 // false
```

The decimal fractions are approximated in binary, and the final rounded result is slightly different from exact `0.3`.

## 5. Diagrams / Mental Models

32-bit float layout:

```text
31        30              23 22                         0
+----------+----------------+----------------------------+
| sign (1) | exponent (8)   | fraction (23)              |
+----------+----------------+----------------------------+
```

Value formula:

```text
sign bit -> positive or negative
exponent -> scale
fraction -> precision digits
```

## 6. Common Interview Questions

### 1. What is IEEE 754?

IEEE 754 is a standard for floating-point arithmetic and representation.

Key points: defines formats, rounding, special values, exceptions.

Common mistake: saying it is only a 32-bit format.

### 2. What are the fields in a 32-bit float?

1 sign bit, 8 exponent bits, and 23 fraction bits.

Key points: exponent bias is 127.

Common mistake: forgetting the sign bit.

### 3. What are the fields in a 64-bit double?

1 sign bit, 11 exponent bits, and 52 fraction bits.

Key points: exponent bias is 1023.

Common mistake: saying double is just two floats joined together.

### 4. What is exponent bias?

Bias stores negative and positive exponents as unsigned values.

Key points: single bias 127, double bias 1023.

Common mistake: subtracting bias from the final value instead of exponent.

### 5. What is the hidden bit?

For normalized numbers, the leading `1` before the binary point is not stored.

Key points: gives one extra bit of precision.

Common mistake: applying hidden bit to subnormal numbers.

### 6. What is NaN?

NaN means Not a Number, representing invalid or undefined results like `0/0`.

Key points: NaN is not equal to itself.

Common mistake: treating NaN as infinity.

### 7. What is infinity in IEEE 754?

Infinity has all exponent bits set and zero fraction.

Key points: sign bit distinguishes `+infinity` and `-infinity`.

Common mistake: thinking overflow always wraps.

### 8. What are subnormal numbers?

Subnormal numbers represent values very close to zero with reduced precision.

Key points: exponent bits all zero and fraction nonzero.

Common mistake: using implicit leading 1 for subnormals.

### 9. Why does `0.1 + 0.2` not equal `0.3` exactly?

Because `0.1` and `0.2` are repeating binary fractions and are rounded.

Key points: binary representation issue.

Common mistake: saying JavaScript arithmetic is broken.

### 10. How should floats be compared?

Use an acceptable tolerance, such as `abs(a - b) < epsilon`, depending on scale.

Key points: choose epsilon carefully.

Common mistake: using one fixed epsilon for all magnitudes.

## 7. Deep-Dive Questions

### 1. Why does IEEE 754 support signed zero?

Signed zero preserves direction of underflow and helps with functions where approaching zero from positive or negative side matters.

### 2. What is rounding to nearest even?

It rounds to the nearest representable value; ties go to the value with an even least significant bit. This reduces statistical bias.

### 3. What is machine epsilon?

Machine epsilon is the gap between 1 and the next representable floating-point number for a given format.

### 4. Why is floating-point addition not associative?

Rounding after each operation means `(a + b) + c` may differ from `a + (b + c)`.

### 5. What is the difference between quiet NaN and signaling NaN?

Quiet NaN propagates through operations. Signaling NaN is intended to raise an exception when used.

## 8. Comparison Tables

| Feature | Float / Single | Double |
|---|---:|---:|
| Total bits | 32 | 64 |
| Sign bits | 1 | 1 |
| Exponent bits | 8 | 11 |
| Fraction bits | 23 | 52 |
| Bias | 127 | 1023 |
| Typical use | Graphics, ML, compact storage | General scientific/default real arithmetic |

| Exponent Bits | Fraction Bits | Meaning |
|---|---|---|
| all 0 | 0 | zero |
| all 0 | nonzero | subnormal |
| normal range | any | normalized number |
| all 1 | 0 | infinity |
| all 1 | nonzero | NaN |

## 9. Common Mistakes

* Forgetting exponent bias.
* Applying hidden bit to subnormals.
* Comparing floats with exact equality.
* Assuming decimal fractions are exact in binary.
* Treating NaN like an ordinary value.
* Believing floating-point addition is associative.

## 10. Edge Cases / Special Cases

* `+0` and `-0` compare equal but can behave differently in division.
* `NaN != NaN`.
* Overflow can produce infinity.
* Underflow can produce subnormal numbers or zero.
* Different rounding modes can change results.

## 11. How to Explain in Interview

"IEEE 754 represents floating-point numbers using a sign bit, biased exponent, and fraction. Normal values use an implicit leading 1. It also defines special values like zero, subnormal numbers, infinity, and NaN. The key interview point is that binary floating-point is approximate, so rounding and comparison need care."

## 12. Quick Revision Notes

* Float: 1 sign, 8 exponent, 23 fraction.
* Double: 1 sign, 11 exponent, 52 fraction.
* Single bias: 127.
* Double bias: 1023.
* Exponent all ones: infinity or NaN.
* Exponent all zeros: zero or subnormal.
* Trap: NaN is not equal to itself.

## 13. Practice Tasks

* Decode a simple 32-bit float with sign 0, exponent 128, fraction 0.
* Explain why `1e20 + 1 == 1e20` may be true.
* Write a float comparison helper using relative tolerance.
* Identify NaN and infinity from exponent/fraction fields.
* Show an example where floating-point addition is not associative.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Standard binary floating-point representation |
| Why it matters | Used by CPUs, GPUs, languages, browsers, ML frameworks |
| Most asked questions | Field sizes, bias, NaN, infinity, `0.1+0.2` |
| Common comparison | Float has fewer bits; double has more precision and range |
| One-line interview answer | "IEEE 754 stores sign, biased exponent, and fraction, giving wide range with finite precision and special values." |

# Boolean Algebra

## 1. Overview

Boolean algebra is the mathematics of true/false values. In computer organization, it describes how binary variables combine using operations like AND, OR, and NOT.

It matters because digital circuits are built from Boolean logic. Every CPU instruction, memory control signal, arithmetic unit, and condition check is eventually implemented using Boolean expressions.

Interviewers ask this to test whether you can simplify logic, build truth tables, and reason about digital hardware.

## 2. Core Idea

Boolean variables have only two values:

```text
0 = false
1 = true
```

Boolean operations combine these values.

Analogy: access control.

```text
Can enter = has_ticket AND passed_security
```

Both conditions must be true. This is exactly an AND operation.

Example:

```text
F = A AND (NOT B)
```

If `A = 1` and `B = 0`, then:

```text
F = 1 AND 1 = 1
```

## 3. Important Subtopics

### Boolean Variables

Variables can only be `0` or `1`.

Why it matters: hardware signals are binary.

Example: `A`, `B`, `C` as input signals.

Common interview angle: create truth table.

### Boolean Operators

Main operators are AND, OR, NOT, XOR, NAND, and NOR.

Why it matters: all digital logic is composed from these.

Example: `A + B` often means OR; `A.B` means AND.

Common interview angle: operator precedence and truth tables.

### Boolean Laws

Boolean laws simplify expressions.

Example:

```text
A + A.B = A
```

Why it matters: simpler circuits use fewer gates.

Common interview angle: simplify logic expression.

### De Morgan's Laws

```text
NOT(A AND B) = NOT A OR NOT B
NOT(A OR B)  = NOT A AND NOT B
```

Why it matters: converts between NAND/NOR implementations.

Common interview angle: apply De Morgan during simplification.

## 4. Real-World Example

In a CPU control unit:

```text
write_register = instruction_is_add OR instruction_is_load
```

The register file write-enable signal is a Boolean function of decoded instruction bits. If the Boolean expression is wrong, the CPU writes at the wrong time and corrupts program state.

## 5. Diagrams / Mental Models

Truth table for AND:

| A | B | A AND B |
|---:|---:|---:|
| 0 | 0 | 0 |
| 0 | 1 | 0 |
| 1 | 0 | 0 |
| 1 | 1 | 1 |

Boolean simplification mental model:

```text
Expression -> truth table -> simplified expression -> fewer gates
```

## 6. Common Interview Questions

### 1. What is Boolean algebra?

Boolean algebra is algebra over binary values, usually 0 and 1, with logical operations.

Key points: foundation of digital logic.

Common mistake: treating it like normal arithmetic.

### 2. What are basic Boolean operations?

AND, OR, and NOT are basic operations. XOR, NAND, and NOR are also common.

Key points: NAND and NOR are universal gates.

Common mistake: forgetting NOT is unary.

### 3. State De Morgan's laws.

```text
(A.B)' = A' + B'
(A+B)' = A'.B'
```

Key points: complement distributes by changing operator.

Common mistake: forgetting to invert both variables and operator.

### 4. What is the identity law?

```text
A + 0 = A
A . 1 = A
```

Key points: OR with 0 and AND with 1 preserve value.

Common mistake: mixing identity with domination.

### 5. What is the domination law?

```text
A + 1 = 1
A . 0 = 0
```

Key points: one input dominates result.

Common mistake: saying `A + 1 = A`.

### 6. Simplify `A + A.B`.

`A + A.B = A`.

Key points: absorption law.

Common mistake: factoring incorrectly.

### 7. What is XOR?

XOR is true when inputs are different.

Key points: used in adders and parity.

Common mistake: saying XOR is same as OR.

### 8. Why are NAND and NOR called universal gates?

Any Boolean function can be implemented using only NAND gates or only NOR gates.

Key points: NOT, AND, OR can be built from NAND/NOR.

Common mistake: saying XOR alone is universal.

### 9. What is a truth table?

A truth table lists output for every possible input combination.

Key points: `n` inputs produce `2^n` rows.

Common mistake: missing input combinations.

### 10. Why simplify Boolean expressions?

Simplification reduces gate count, delay, cost, power, and complexity.

Key points: practical hardware optimization.

Common mistake: thinking simplification is only mathematical.

## 7. Deep-Dive Questions

### 1. What is canonical SOP?

Canonical sum of products expresses a function as OR of minterms, where each minterm includes every variable.

### 2. What is canonical POS?

Canonical product of sums expresses a function as AND of maxterms, where each maxterm includes every variable.

### 3. How does a Karnaugh map help?

It visually groups adjacent truth table ones or zeros to simplify Boolean expressions.

### 4. Why is Boolean algebra enough to describe circuits?

Because digital circuits use binary signals and gates implement Boolean functions.

### 5. What is functional completeness?

A set of gates is functionally complete if every Boolean function can be built from that set.

## 8. Comparison Tables

| Operation | Symbol | Meaning | Output 1 When |
|---|---|---|---|
| AND | `A.B` | Logical multiplication | Both inputs are 1 |
| OR | `A+B` | Logical addition | At least one input is 1 |
| NOT | `A'` | Complement | Input is 0 |
| XOR | `A xor B` | Exclusive OR | Inputs differ |
| NAND | `(A.B)'` | NOT AND | Not both are 1 |
| NOR | `(A+B)'` | NOT OR | Both are 0 |

| Law | Expression |
|---|---|
| Identity | `A + 0 = A`, `A.1 = A` |
| Domination | `A + 1 = 1`, `A.0 = 0` |
| Idempotent | `A + A = A`, `A.A = A` |
| Complement | `A + A' = 1`, `A.A' = 0` |
| Absorption | `A + A.B = A` |

## 9. Common Mistakes

* Treating Boolean `+` as decimal addition.
* Forgetting all truth table rows.
* Applying De Morgan's laws halfway.
* Confusing OR and XOR.
* Assuming simplified expression must look shorter in symbols, not in gates.

## 10. Edge Cases / Special Cases

* `1 + 1 = 1` in Boolean OR, not 2.
* NAND and NOR can build all logic.
* XOR is useful but not the same as OR.
* Different simplified forms may be equivalent.
* Gate delay matters, not just gate count.

## 11. How to Explain in Interview

"Boolean algebra is the algebra of binary values. It uses operations like AND, OR, NOT, and XOR to describe digital logic. It matters because every combinational circuit implements a Boolean function, and simplifying the expression can reduce hardware cost and delay."

## 12. Quick Revision Notes

* Boolean values: 0 and 1.
* AND true only when all inputs true.
* OR true when at least one input true.
* XOR true when inputs differ.
* De Morgan flips operator and complements terms.
* NAND and NOR are universal.

## 13. Practice Tasks

* Build truth table for `A.B + C`.
* Simplify `A + A'.B`.
* Prove De Morgan's law using a truth table.
* Implement NOT, AND, and OR using only NAND.
* Convert a truth table into SOP form.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Algebra of binary true/false values |
| Why it matters | Directly maps to digital circuits |
| Most asked questions | Laws, truth tables, simplification, De Morgan |
| Common comparison | OR is inclusive; XOR is exclusive |
| One-line interview answer | "Boolean algebra is the math used to describe and simplify digital logic circuits." |

# Logic Gates

## 1. Overview

Logic gates are electronic circuits that implement Boolean operations. They take binary inputs and produce a binary output.

Common gates include AND, OR, NOT, NAND, NOR, XOR, and XNOR.

They matter because gates are the building blocks of CPUs, memory, controllers, ALUs, and all digital hardware. Interviewers ask about gates to check whether you can connect Boolean algebra to actual circuits.

## 2. Core Idea

A logic gate is a physical version of a Boolean operation.

Analogy: a gatekeeper with rules.

* AND gate: allow only if all conditions are true.
* OR gate: allow if at least one condition is true.
* NOT gate: invert the condition.

Example:

```text
Alarm = DoorOpen AND SystemArmed
```

The alarm output becomes 1 only when both inputs are 1.

## 3. Important Subtopics

### AND Gate

Outputs 1 only when all inputs are 1.

Why it matters: used for enable signals and condition checks.

Example: `write = enable AND clock_edge`.

Common interview angle: truth table.

### OR Gate

Outputs 1 when at least one input is 1.

Why it matters: combines multiple possible causes.

Example: `interrupt = keyboard OR timer OR network`.

Common interview angle: OR vs XOR.

### NOT Gate

Outputs the complement of input.

Why it matters: creates inverted control signals.

Example: `not_ready = NOT ready`.

Common interview angle: use NOT with De Morgan's laws.

### NAND and NOR Gates

NAND is NOT-AND. NOR is NOT-OR. Both are universal gates.

Why it matters: hardware can be built using only NAND or only NOR.

Common interview angle: implement all gates using NAND.

### XOR and XNOR Gates

XOR outputs 1 when inputs differ. XNOR outputs 1 when inputs are same.

Why it matters: adders, parity, equality checks.

Common interview angle: half-adder sum uses XOR.

## 4. Real-World Example

In an ALU, a full adder uses XOR, AND, and OR gates:

```text
sum   = A xor B xor Cin
carry = A.B + Cin.(A xor B)
```

This gate-level logic is repeated for every bit in a processor's adder.

## 5. Diagrams / Mental Models

Gate summary:

```text
AND:  output 1 only if all inputs are 1
OR:   output 1 if any input is 1
NOT:  output opposite input
XOR:  output 1 if inputs differ
NAND: output opposite of AND
NOR:  output opposite of OR
```

Truth table:

| A | B | AND | OR | XOR | NAND | NOR | XNOR |
|---:|---:|---:|---:|---:|---:|---:|---:|
| 0 | 0 | 0 | 0 | 0 | 1 | 1 | 1 |
| 0 | 1 | 0 | 1 | 1 | 1 | 0 | 0 |
| 1 | 0 | 0 | 1 | 1 | 1 | 0 | 0 |
| 1 | 1 | 1 | 1 | 0 | 0 | 0 | 1 |

## 6. Common Interview Questions

### 1. What is a logic gate?

A logic gate is a circuit that performs a Boolean operation on binary inputs.

Key points: physical implementation of Boolean algebra.

Common mistake: describing only software logic.

### 2. What does an AND gate do?

It outputs 1 only when all inputs are 1.

Key points: used for enabling.

Common mistake: confusing AND with OR.

### 3. What does an OR gate do?

It outputs 1 if at least one input is 1.

Key points: inclusive OR.

Common mistake: saying OR excludes both inputs being true.

### 4. What does XOR do?

XOR outputs 1 when inputs are different.

Key points: sum bit in half adder.

Common mistake: treating XOR as normal OR.

### 5. Why is NAND universal?

Because NOT, AND, and OR can be constructed from NAND gates, and those can implement any Boolean function.

Key points: functional completeness.

Common mistake: saying universal means physically fastest.

### 6. Why is NOR universal?

Because NOT, OR, and AND can be constructed from NOR gates.

Key points: also functionally complete.

Common mistake: remembering only NAND.

### 7. How do you make NOT using NAND?

Connect both NAND inputs to the same signal:

```text
A NAND A = A'
```

Key points: input tying.

Common mistake: using extra gates unnecessarily.

### 8. How do you make AND using NAND?

NAND the inputs, then invert the result using another NAND.

```text
A AND B = (A NAND B) NAND (A NAND B)
```

Key points: NAND plus inversion.

Common mistake: returning NAND output directly.

### 9. Which gate is used for equality checking?

XNOR outputs 1 when inputs are equal. Multiple XNOR results can be ANDed for multi-bit equality.

Key points: XNOR is equality for one bit.

Common mistake: saying XOR means equal.

### 10. What is propagation delay?

Propagation delay is the time between an input change and the output becoming valid.

Key points: affects circuit speed.

Common mistake: assuming gates are instantaneous.

## 7. Deep-Dive Questions

### 1. What is fan-in?

Fan-in is the number of inputs a gate can accept.

### 2. What is fan-out?

Fan-out is the number of gate inputs one output can drive reliably.

### 3. Why do we care about gate delay?

The longest delay path limits maximum clock frequency in synchronous circuits.

### 4. What is a universal gate?

A gate type that can implement all Boolean functions by itself, such as NAND or NOR.

### 5. How does CMOS implement logic gates?

CMOS uses complementary pull-up and pull-down transistor networks to produce logic levels.

## 8. Comparison Tables

| Gate | Output 1 Condition | Common Use |
|---|---|---|
| AND | All inputs 1 | Enable, masking |
| OR | Any input 1 | Combine conditions |
| NOT | Input 0 | Inversion |
| XOR | Inputs differ | Sum, parity |
| XNOR | Inputs same | Equality |
| NAND | Not all inputs 1 | Universal implementation |
| NOR | No input is 1 | Universal implementation |

| Feature | NAND | NOR |
|---|---|---|
| Universal | Yes | Yes |
| Built-in inversion | Yes | Yes |
| Basic meaning | NOT AND | NOT OR |
| Common teaching use | NAND-only circuits | NOR-only circuits |

## 9. Common Mistakes

* Confusing OR and XOR.
* Forgetting NAND and NOR are inverted outputs.
* Thinking gates have zero delay.
* Ignoring fan-in and fan-out.
* Forgetting XNOR is equality for one bit.

## 10. Edge Cases / Special Cases

* Multi-input XOR outputs 1 for odd parity, not simply "one input is true."
* Gate symbols may use bubbles to show inversion.
* Physical voltage levels are not perfect mathematical 0 and 1.
* Propagation delays can cause glitches.
* NAND-only and NOR-only designs may use more gates than mixed-gate designs.

## 11. How to Explain in Interview

"Logic gates are hardware circuits that implement Boolean operations. AND, OR, NOT, XOR, NAND, NOR, and XNOR are basic gates. NAND and NOR are universal, so any digital circuit can theoretically be built using only one of them."

## 12. Quick Revision Notes

* AND: all true.
* OR: any true.
* XOR: different.
* XNOR: same.
* NAND = NOT AND.
* NOR = NOT OR.
* NAND and NOR are universal.
* Propagation delay affects speed.

## 13. Practice Tasks

* Draw truth tables for all basic gates.
* Implement OR using only NAND.
* Implement AND using only NOR.
* Build a 1-bit equality checker using XNOR.
* Derive full-adder sum and carry logic from gates.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Physical circuits implementing Boolean operations |
| Why it matters | Gates build all digital hardware |
| Most asked questions | Truth tables, NAND/NOR universality, XOR use |
| Common comparison | XOR means different; OR means at least one |
| One-line interview answer | "A logic gate is Boolean algebra implemented in hardware." |

# Combinational and Sequential Circuits

## 1. Overview

Combinational circuits produce outputs based only on current inputs. Sequential circuits produce outputs based on current inputs and stored past state.

This distinction matters because computers need both decision logic and memory. Adders, multiplexers, decoders, and comparators are combinational. Flip-flops, registers, counters, and finite state machines are sequential.

Interviewers ask this to check whether you understand the difference between logic without memory and logic with memory.

## 2. Core Idea

Combinational circuit:

```text
Output = function(current inputs)
```

Sequential circuit:

```text
Output = function(current inputs, stored state)
Next state = function(current inputs, stored state)
```

Analogy:

* Combinational: a calculator button result depends on the current expression.
* Sequential: an elevator controller depends on current button input and current floor/direction state.

## 3. Important Subtopics

### Combinational Logic

No memory. Same input always gives same output.

Examples: adder, subtractor, mux, decoder, encoder, comparator.

Common interview angle: design a circuit from truth table.

### Sequential Logic

Has memory using latches or flip-flops.

Examples: registers, counters, state machines.

Common interview angle: explain clock and state.

### Clock Signal

A clock coordinates when sequential circuits update state.

Why it matters: synchronous systems avoid uncontrolled state changes.

Common interview angle: edge-triggered flip-flops.

### State

State is stored information from the past.

Example: a counter stores current count.

Common interview angle: design a finite state machine.

## 4. Real-World Example

A CPU instruction datapath uses both:

* Combinational: ALU computes arithmetic result.
* Sequential: program counter stores address of next instruction.

During each clock cycle, combinational logic computes values, and registers capture new values at clock edges.

## 5. Diagrams / Mental Models

Combinational:

```text
Inputs -> logic gates -> outputs
```

Sequential:

```text
          +-------------+
Inputs -> | logic gates | -> outputs
          +-------------+
                ^
                |
             state
                |
          +-------------+
          | flip-flops  |
          +-------------+
```

Clocked flow:

```text
Register -> combinational logic -> Register
   ^                                |
   +------------- clock ------------+
```

## 6. Common Interview Questions

### 1. What is a combinational circuit?

A circuit whose output depends only on current inputs.

Key points: no memory.

Common mistake: saying all gate circuits are sequential.

### 2. What is a sequential circuit?

A circuit whose output depends on current inputs and previous state.

Key points: uses memory elements.

Common mistake: forgetting state.

### 3. Give examples of combinational circuits.

Adders, subtractors, multiplexers, encoders, decoders, and comparators.

Key points: output is immediate function of input.

Common mistake: including counters.

### 4. Give examples of sequential circuits.

Flip-flops, registers, counters, shift registers, and finite state machines.

Key points: memory and clock are common.

Common mistake: including simple AND gate.

### 5. What is the role of a clock?

The clock synchronizes when state elements update.

Key points: state changes usually at clock edge.

Common mistake: saying clock is required for every combinational circuit.

### 6. What is propagation delay?

Time for input changes to affect output through gates.

Key points: limits clock speed.

Common mistake: ignoring timing in circuit design.

### 7. What is setup time?

Minimum time input must be stable before a clock edge for reliable capture.

Key points: flip-flop timing constraint.

Common mistake: mixing with hold time.

### 8. What is hold time?

Minimum time input must remain stable after a clock edge.

Key points: prevents incorrect capture.

Common mistake: saying it happens before clock edge.

### 9. What is a finite state machine?

A sequential circuit with a finite number of states and transitions.

Key points: next state depends on input and current state.

Common mistake: describing only software state machines.

### 10. Why separate combinational and sequential logic?

It makes timing and behavior predictable: logic computes between clock edges and registers capture at edges.

Key points: synchronous design discipline.

Common mistake: thinking separation is only for diagrams.

## 7. Deep-Dive Questions

### 1. What is the critical path?

The longest combinational delay between two state elements. It determines the minimum clock period.

### 2. What is metastability?

Metastability is an unstable flip-flop state caused by violating timing constraints, often with asynchronous inputs.

### 3. What is the difference between Mealy and Moore machines?

Moore outputs depend only on state. Mealy outputs depend on state and current inputs.

### 4. Why are asynchronous inputs dangerous?

They may change near clock edges and cause metastability unless synchronized.

### 5. What is pipelining?

Pipelining inserts registers between combinational stages to increase throughput and clock frequency.

## 8. Comparison Tables

| Feature | Combinational | Sequential |
|---|---|---|
| Depends on | Current inputs | Current inputs + previous state |
| Memory | No | Yes |
| Clock | Not required | Usually required |
| Examples | Adder, mux, decoder | Flip-flop, register, counter |
| Main concern | Logic correctness, delay | State, timing, synchronization |

| Machine Type | Output Depends On | Typical Trade-Off |
|---|---|---|
| Moore | State only | More stable outputs |
| Mealy | State and input | Faster response, more input-sensitive |

## 9. Common Mistakes

* Calling every circuit with gates combinational.
* Forgetting sequential circuits store state.
* Ignoring setup and hold time.
* Thinking clock changes combinational output directly.
* Mixing up Moore and Mealy machines.

## 10. Edge Cases / Special Cases

* Latches are level-sensitive; flip-flops are edge-triggered.
* Asynchronous resets affect state outside normal clock updates.
* Combinational loops are usually invalid unless intentionally designed.
* Glitches can occur in combinational logic.
* Clock domain crossings need synchronization.

## 11. How to Explain in Interview

"Combinational circuits depend only on current inputs, like adders and muxes. Sequential circuits also depend on stored state, like registers and counters. In a CPU, combinational logic computes between clock edges, and sequential elements capture the results at clock edges."

## 12. Quick Revision Notes

* Combinational: no memory.
* Sequential: memory/state.
* Clock updates state.
* Critical path limits clock speed.
* Setup time: before edge.
* Hold time: after edge.
* FSM: state plus transitions.

## 13. Practice Tasks

* Classify adder, decoder, register, counter, mux, and flip-flop.
* Draw a simple FSM for a turnstile.
* Calculate minimum clock period from register delay and combinational delay.
* Design a 2-bit counter state table.
* Explain CPU fetch using PC register and combinational address logic.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Combinational has no memory; sequential has state |
| Why it matters | CPUs need both computation and storage |
| Most asked questions | Examples, clock, setup/hold, FSM |
| Common comparison | Combinational output = input function; sequential output = input + state |
| One-line interview answer | "Combinational circuits compute; sequential circuits remember." |

# Adders, Subtractors, and Multiplexers

## 1. Overview

Adders perform binary addition. Subtractors perform binary subtraction. Multiplexers select one of many inputs and forward it to the output.

These are core combinational circuits used in ALUs, datapaths, buses, memory selection, instruction execution, and control logic.

Interviewers ask this topic because it combines Boolean logic with actual computer architecture building blocks.

## 2. Core Idea

An adder works like decimal addition, but with base 2.

```text
1 + 1 = 10₂
```

So each bit position may generate a carry.

A subtractor can be built using two's complement:

```text
A - B = A + two's_complement(B)
```

A multiplexer is like a railway switch: select lines decide which input gets connected to the output.

## 3. Important Subtopics

### Half Adder

Adds two 1-bit inputs.

```text
Sum = A xor B
Carry = A.B
```

Common interview angle: truth table and gate expression.

### Full Adder

Adds two bits plus carry-in.

```text
Sum = A xor B xor Cin
Carry = A.B + Cin.(A xor B)
```

Common interview angle: build n-bit adder from full adders.

### Ripple Carry Adder

Connects full adders in sequence. Carry ripples from lower bit to higher bit.

Why it matters: simple but slower for large bit widths.

Common interview angle: delay grows linearly with bit count.

### Subtractor

Can be built using borrow logic or by adding two's complement.

Why it matters: ALUs usually reuse adder hardware.

Common interview angle: explain why XOR with control bit helps add/subtract.

### Multiplexer

A mux selects one input based on select lines.

For `2^n` inputs, it needs `n` select lines.

Common interview angle: implement Boolean function using mux.

## 4. Real-World Example

In a CPU datapath, a mux may choose the second ALU operand:

```text
ALU input B = register value OR immediate constant
```

For an `ADD R1, R2, R3`, the mux selects register data. For `ADDI R1, R2, 5`, it selects the immediate value.

## 5. Diagrams / Mental Models

Half adder:

```text
A ----+---- XOR ---- Sum
      |
B ----+

A ----+---- AND ---- Carry
B ----+
```

2:1 mux:

```text
Y = S'.I0 + S.I1

S=0 -> Y=I0
S=1 -> Y=I1
```

Ripple carry adder:

```text
[FA0] -> carry -> [FA1] -> carry -> [FA2] -> carry -> [FA3]
```

## 6. Common Interview Questions

### 1. What is a half adder?

A half adder adds two one-bit inputs and produces sum and carry.

Key points: `Sum = A xor B`, `Carry = A.B`.

Common mistake: including carry-in.

### 2. What is a full adder?

A full adder adds `A`, `B`, and carry-in, producing sum and carry-out.

Key points: used to build multi-bit adders.

Common mistake: forgetting carry-in.

### 3. What is the sum expression of a full adder?

`Sum = A xor B xor Cin`.

Key points: XOR captures odd parity.

Common mistake: using OR instead of XOR.

### 4. What is the carry expression of a full adder?

`Cout = A.B + Cin.(A xor B)`.

Key points: carry generated or propagated.

Common mistake: missing the carry propagation term.

### 5. What is a ripple carry adder?

A multi-bit adder where carry-out of one full adder goes to carry-in of the next.

Key points: simple but delay accumulates.

Common mistake: saying all bits compute fully independently.

### 6. How is subtraction done using an adder?

Invert `B`, add 1, then add to `A`.

```text
A - B = A + (~B + 1)
```

Key points: two's complement.

Common mistake: forgetting the `+1`.

### 7. What is a multiplexer?

A multiplexer selects one of several inputs and forwards it to output.

Key points: controlled by select lines.

Common mistake: confusing mux with decoder.

### 8. How many select lines are needed for 8 inputs?

`log2(8) = 3` select lines.

Key points: `2^n` inputs need `n` select lines.

Common mistake: saying 8 select lines.

### 9. Give the expression for a 2:1 mux.

`Y = S'.I0 + S.I1`.

Key points: select controls path.

Common mistake: reversing select meaning without saying so.

### 10. Why are muxes important in CPUs?

They select data paths, operands, register inputs, memory sources, and control choices.

Key points: datapath steering.

Common mistake: treating mux as only a communication device.

## 7. Deep-Dive Questions

### 1. What is carry-lookahead addition?

It speeds addition by computing carry signals in parallel using generate and propagate logic.

### 2. What are generate and propagate?

For bit `i`, generate means the bit definitely creates carry: `Gi = Ai.Bi`. Propagate means it passes carry: `Pi = Ai xor Bi` or sometimes `Ai + Bi`.

### 3. Why is ripple carry slow?

Each stage must wait for previous carry, so worst-case delay grows with number of bits.

### 4. How can a mux implement any Boolean function?

Use variables as select lines and wire data inputs to constants or remaining variables based on truth table rows.

### 5. How does an ALU use one adder for both addition and subtraction?

It XORs `B` with a subtract control signal and uses that signal as carry-in, producing `A + ~B + 1` for subtraction.

## 8. Comparison Tables

| Feature | Half Adder | Full Adder |
|---|---|---|
| Inputs | A, B | A, B, Cin |
| Outputs | Sum, Carry | Sum, Cout |
| Sum | `A xor B` | `A xor B xor Cin` |
| Multi-bit use | First simple stage | Standard repeated block |

| Circuit | Purpose | Key Limitation |
|---|---|---|
| Ripple carry adder | Simple multi-bit addition | Carry delay |
| Carry-lookahead adder | Faster addition | More hardware |
| Subtractor | Binary subtraction | Borrow/overflow handling |
| Multiplexer | Select input | Select line decoding |

## 9. Common Mistakes

* Confusing half adder and full adder.
* Using OR instead of XOR for sum.
* Forgetting carry propagation.
* Saying mux has one select line regardless of input count.
* Confusing mux and decoder.

## 10. Edge Cases / Special Cases

* Adding two positive signed numbers can overflow.
* Carry-out is not the same as signed overflow.
* A 1:2 demux is the reverse idea of a 2:1 mux.
* Ripple carry delay matters in wide adders.
* Mux select inputs must be valid binary combinations.

## 11. How to Explain in Interview

"A half adder adds two bits, while a full adder also includes carry-in. Multi-bit adders are built by chaining full adders, though ripple carry is slow. Subtraction is usually implemented by adding the two's complement. A mux selects one of many inputs and is used heavily to steer data inside a CPU."

## 12. Quick Revision Notes

* Half adder: sum XOR, carry AND.
* Full adder: adds carry-in.
* Ripple carry: simple but slow.
* Subtraction: `A + ~B + 1`.
* Mux: `2^n` inputs need `n` select lines.
* 2:1 mux: `S'I0 + SI1`.

## 13. Practice Tasks

* Draw half adder and full adder truth tables.
* Build a 4-bit ripple carry adder.
* Design a 4-bit add/subtract circuit.
* Implement a 4:1 mux using 2:1 muxes.
* Use a mux to implement a 3-variable Boolean function.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Arithmetic and selection combinational circuits |
| Why it matters | Core of ALU and datapath design |
| Most asked questions | Half/full adder, mux select lines, subtraction using complement |
| Common comparison | Half adder lacks carry-in; full adder includes carry-in |
| One-line interview answer | "Adders compute binary sums, subtractors reuse complement addition, and muxes choose which data path flows forward." |

# Encoders, Decoders, and Comparators

## 1. Overview

Encoders, decoders, and comparators are combinational circuits used to translate and compare binary information.

* Encoder: many input lines to fewer output lines.
* Decoder: fewer input lines to many output lines.
* Comparator: compares two binary values.

They matter in CPUs, memory addressing, instruction decoding, I/O devices, priority systems, and digital controllers. Interviewers ask this because these circuits are practical and easy to test with truth tables.

## 2. Core Idea

An encoder compresses position information into binary code. A decoder expands binary code into one active output. A comparator answers relationship questions: equal, greater, or less.

Analogy:

* Encoder: floor button panel converts one pressed button into a binary floor number.
* Decoder: binary floor number activates one floor indicator.
* Comparator: checks whether requested floor is above, below, or equal to current floor.

## 3. Important Subtopics

### Encoder

An encoder converts active input line into binary output.

Example: 8-to-3 encoder.

Why it matters: reduces many signals into compact code.

Common interview angle: priority encoder.

### Priority Encoder

If multiple inputs are active, it outputs the code for the highest-priority input.

Why it matters: interrupt controllers and arbitration.

Common interview angle: handle multiple active inputs.

### Decoder

A decoder activates one output based on binary input.

Example: 3-to-8 decoder.

Why it matters: memory chip select, instruction decoding.

Common interview angle: output count is `2^n`.

### Comparator

Compares binary values and outputs equality or ordering.

Why it matters: branch instructions, sorting hardware, address checks.

Common interview angle: design 1-bit or n-bit comparator.

## 4. Real-World Example

In a CPU, instruction bits are decoded into control signals.

```text
opcode bits -> instruction decoder -> ALUOp, RegWrite, MemRead, MemWrite
```

Without a decoder, the CPU would not know which operation an instruction requests.

## 5. Diagrams / Mental Models

Decoder:

```text
2 input bits -> 4 output lines

00 -> Y0
01 -> Y1
10 -> Y2
11 -> Y3
```

Encoder:

```text
Y0 active -> 00
Y1 active -> 01
Y2 active -> 10
Y3 active -> 11
```

Comparator:

```text
A ? B -> A<B, A=B, A>B
```

## 6. Common Interview Questions

### 1. What is an encoder?

An encoder converts one active input among many into a binary output code.

Key points: `2^n` inputs to `n` outputs.

Common mistake: confusing it with decoder.

### 2. What is a decoder?

A decoder converts `n` input bits into up to `2^n` output lines.

Key points: one output active for each input combination.

Common mistake: saying decoder compresses data.

### 3. What is a priority encoder?

A priority encoder outputs the code of the highest-priority active input.

Key points: handles multiple active inputs.

Common mistake: assuming normal encoder handles multiple active inputs cleanly.

### 4. How many outputs does a 3-to-8 decoder have?

8 outputs.

Key points: `2^3 = 8`.

Common mistake: saying 3 outputs.

### 5. How many output bits does an 8-to-3 encoder have?

3 output bits.

Key points: `log2(8) = 3`.

Common mistake: saying 8 output bits.

### 6. What is a comparator?

A comparator checks whether two binary numbers are equal, greater, or less.

Key points: outputs may be `A=B`, `A>B`, `A<B`.

Common mistake: thinking comparator only checks equality.

### 7. How is equality checked for multiple bits?

Use XNOR for each bit pair and AND all results.

Key points: each bit must match.

Common mistake: using XOR directly for equality.

### 8. Where are decoders used in memory?

Address decoders select one memory row, chip, or register based on address bits.

Key points: binary address to selected line.

Common mistake: saying memory searches all addresses sequentially.

### 9. What is enable input in a decoder?

An enable controls whether the decoder outputs are active.

Key points: useful for cascading and chip selection.

Common mistake: ignoring disabled output state.

### 10. What happens if multiple inputs are active in a normal encoder?

Output may be invalid or ambiguous unless it is a priority encoder.

Key points: normal encoder assumes one active input.

Common mistake: assuming all encoders prioritize.

## 7. Deep-Dive Questions

### 1. How do you build a larger decoder from smaller decoders?

Use higher-order bits to enable one of several smaller decoders, and lower-order bits as inputs to those decoders.

### 2. How does a magnitude comparator work?

Compare from most significant bit downward. The first differing bit determines which number is larger.

### 3. How can a decoder implement Boolean functions?

Each output represents a minterm. OR the required minterms to implement the function.

### 4. Why do interrupt controllers use priority encoders?

Multiple interrupts may arrive at once, and hardware must choose the highest-priority request.

### 5. What is a one-hot representation?

Only one bit in a group is active. Decoder outputs are often one-hot.

## 8. Comparison Tables

| Feature | Encoder | Decoder |
|---|---|---|
| Direction | Many lines to binary code | Binary code to many lines |
| Input count | Usually `2^n` | `n` |
| Output count | `n` | Up to `2^n` |
| Common use | Interrupts, keypads | Memory select, instruction decode |
| Ambiguity | Multiple active inputs | Usually one active output |

| Comparator Type | Output |
|---|---|
| Equality comparator | `A = B` |
| Magnitude comparator | `A < B`, `A = B`, `A > B` |
| 1-bit comparator | Compares single bit |
| n-bit comparator | Compares full binary numbers |

## 9. Common Mistakes

* Reversing encoder and decoder definitions.
* Forgetting priority encoder handles multiple active inputs.
* Thinking a decoder always has exactly one active output even when disabled.
* Using XOR instead of XNOR for equality.
* Comparing binary numbers from LSB first for magnitude.

## 10. Edge Cases / Special Cases

* Encoder input validity may need a valid-output signal.
* Active-low outputs invert expected logic.
* Priority order must be specified.
* Signed comparison differs from unsigned comparison.
* Cascaded decoders need enable control.

## 11. How to Explain in Interview

"An encoder converts an active input line into a binary code, while a decoder converts binary input into one selected output line. A comparator compares binary numbers for equality or ordering. These are combinational blocks used in instruction decoding, memory selection, interrupts, and branch logic."

## 12. Quick Revision Notes

* Encoder: `2^n` to `n`.
* Decoder: `n` to `2^n`.
* Priority encoder resolves multiple active inputs.
* Equality: XNOR each bit, then AND.
* Magnitude: compare from MSB.
* Decoder outputs are often one-hot.

## 13. Practice Tasks

* Draw a 2-to-4 decoder truth table.
* Draw a 4-to-2 encoder truth table.
* Design a priority encoder for 4 inputs.
* Build a 2-bit comparator truth table.
* Use a decoder to implement `F(A,B,C)=Σm(1,3,5,7)`.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Circuits for coding, selecting, and comparing binary data |
| Why it matters | Used in CPU control, memory, interrupts, and branches |
| Most asked questions | Encoder vs decoder, priority encoder, comparator design |
| Common comparison | Encoder compresses; decoder expands |
| One-line interview answer | "Encoders code active inputs, decoders select outputs, and comparators decide equality or order." |

# Flip-Flops, Registers, and Counters

## 1. Overview

Flip-flops, registers, and counters are sequential circuits that store and update binary state.

* Flip-flop: stores one bit.
* Register: stores multiple bits.
* Counter: stores and updates a numeric sequence.

They matter because CPUs need memory at every level: program counters, instruction registers, pipeline registers, status flags, and control state. Interviewers ask this topic to check whether you understand clocked storage and state transitions.

## 2. Core Idea

A flip-flop is a tiny 1-bit memory cell. A register is a group of flip-flops. A counter is a register plus logic that changes its value predictably.

Analogy:

* Flip-flop: one light switch that remembers on/off.
* Register: a row of switches storing a binary number.
* Counter: a row of switches that automatically advances each clock tick.

Clocked behavior:

```text
Before clock edge: input may change
At clock edge: flip-flop captures input
After clock edge: output holds captured value
```

## 3. Important Subtopics

### SR Flip-Flop

Set-reset storage element.

Why it matters: basic memory concept.

Common interview angle: invalid state when both set and reset are active.

### D Flip-Flop

Captures input `D` on clock edge and outputs it as `Q`.

Why it matters: most common building block for registers.

Common interview angle: explain edge triggering.

### JK Flip-Flop

Improves SR by defining toggle behavior when both inputs are 1.

Why it matters: useful for counters.

Common interview angle: compare SR and JK.

### T Flip-Flop

Toggles output when `T=1`.

Why it matters: simple counter construction.

Common interview angle: frequency division.

### Registers

Multiple flip-flops store multi-bit data.

Example: 32-bit register uses 32 flip-flops.

Common interview angle: CPU register file.

### Counters

Counters change state in a sequence on clock pulses.

Types: up counter, down counter, up/down counter, ring counter, Johnson counter.

Common interview angle: synchronous vs asynchronous counters.

## 4. Real-World Example

The program counter in a CPU is a register that stores the address of the next instruction.

On each instruction cycle:

```text
PC -> instruction memory address
PC + 4 -> next PC
clock edge -> PC register updates
```

This is sequential logic because the next instruction depends on stored PC state.

## 5. Diagrams / Mental Models

D flip-flop:

```text
        +------+
D ----> | D FF | ----> Q
CLK --> |      |
        +------+
```

Register:

```text
D0 -> [FF] -> Q0
D1 -> [FF] -> Q1
D2 -> [FF] -> Q2
D3 -> [FF] -> Q3
        ^
        |
       CLK shared
```

Counter:

```text
current count -> increment logic -> next count
       ^                              |
       |________ clocked register ____|
```

## 6. Common Interview Questions

### 1. What is a flip-flop?

A flip-flop is a sequential circuit that stores one bit.

Key points: usually clocked and edge-triggered.

Common mistake: confusing it with a combinational gate.

### 2. What is a D flip-flop?

A D flip-flop captures the value of `D` on the active clock edge and holds it at `Q`.

Key points: common register element.

Common mistake: saying output continuously follows input.

### 3. What is a register?

A register is a group of flip-flops storing a multi-bit value.

Key points: `n`-bit register needs `n` flip-flops.

Common mistake: confusing register with main memory.

### 4. What is a counter?

A counter is a sequential circuit that moves through a sequence of states, usually on clock pulses.

Key points: built using flip-flops and logic.

Common mistake: saying it is purely combinational.

### 5. Difference between latch and flip-flop?

A latch is level-sensitive. A flip-flop is edge-triggered.

Key points: flip-flops update at clock edge.

Common mistake: using both terms interchangeably.

### 6. What is an SR flip-flop invalid state?

In basic SR designs, both set and reset active together can be invalid or forbidden.

Key points: depends on NAND/NOR implementation.

Common mistake: not specifying active-high or active-low.

### 7. What is a JK flip-flop?

A JK flip-flop is like SR but when both inputs are 1, it toggles.

Key points: removes invalid SR condition.

Common mistake: saying it stores two bits.

### 8. What is a T flip-flop?

A T flip-flop toggles output when `T=1` and holds when `T=0`.

Key points: useful for counters and divide-by-2 circuits.

Common mistake: thinking it always toggles regardless of T.

### 9. What is a synchronous counter?

All flip-flops are driven by the same clock and update together.

Key points: faster and more predictable than ripple counters.

Common mistake: saying only first flip-flop gets clock.

### 10. What is an asynchronous counter?

An asynchronous, or ripple, counter clocks each stage from the previous stage output.

Key points: simpler but accumulates delay.

Common mistake: ignoring ripple delay.

## 7. Deep-Dive Questions

### 1. What are setup and hold time?

Setup time is how long input must be stable before the clock edge. Hold time is how long it must remain stable after the edge.

### 2. What is metastability?

Metastability is an uncertain temporary state when a flip-flop samples an input changing near the clock edge.

### 3. How does a shift register work?

It moves stored bits left or right on each clock pulse, often used for serial/parallel conversion.

### 4. How does a ring counter work?

A ring counter circulates a single active bit through a shift register.

### 5. Why are synchronous counters faster?

Because all flip-flops update in parallel from the same clock, avoiding accumulated ripple delay.

## 8. Comparison Tables

| Feature | Latch | Flip-Flop |
|---|---|---|
| Triggering | Level-sensitive | Edge-triggered |
| Control | Enable level | Clock edge |
| Transparency | Can be transparent while enabled | Captures at edge |
| Common use | Simple storage, timing designs | Registers, counters, pipelines |

| Flip-Flop | Main Behavior | Common Use |
|---|---|---|
| SR | Set/reset | Basic memory concept |
| D | Capture data | Registers |
| JK | Hold/set/reset/toggle | Counters |
| T | Toggle/hold | Frequency division, counters |

| Counter Type | Clocking | Advantage | Limitation |
|---|---|---|---|
| Asynchronous | Ripple clock | Simple | Slower, accumulated delay |
| Synchronous | Shared clock | Faster, predictable | More logic |
| Ring | Shifted one-hot bit | Simple decoding | Uses more flip-flops |
| Johnson | Twisted ring | More states than ring | Sequence-specific |

## 9. Common Mistakes

* Confusing latch and flip-flop.
* Thinking a register is combinational.
* Forgetting one flip-flop stores one bit.
* Ignoring setup and hold constraints.
* Confusing synchronous and asynchronous counters.
* Assuming output follows input continuously in edge-triggered flip-flop.

## 10. Edge Cases / Special Cases

* Asynchronous reset can change state without clock.
* Clock skew can break timing assumptions.
* Ripple counters have temporary invalid intermediate states.
* Metastability cannot be fully eliminated, only made very unlikely.
* Initial state may be unknown unless reset is provided.

## 11. How to Explain in Interview

"A flip-flop stores one bit, usually capturing input on a clock edge. A register is a group of flip-flops storing a multi-bit value. A counter is a register with next-state logic that advances through a sequence on clock pulses."

## 12. Quick Revision Notes

* Flip-flop stores 1 bit.
* Register stores n bits using n flip-flops.
* Counter changes state each clock.
* Latch is level-sensitive.
* Flip-flop is edge-triggered.
* Synchronous counter uses common clock.
* Asynchronous counter ripples clock through stages.

## 13. Practice Tasks

* Draw truth table for SR, JK, D, and T flip-flops.
* Design a 4-bit register using D flip-flops.
* Trace a 3-bit asynchronous up counter.
* Design a synchronous 2-bit counter state table.
* Explain how program counter updates during instruction fetch.

## 14. Final Cheat Sheet

| Item | Answer |
|---|---|
| Core definition | Sequential storage blocks for bits, words, and counting state |
| Why it matters | CPU state, registers, PC, flags, counters, pipelines |
| Most asked questions | Latch vs flip-flop, D FF, counters, setup/hold |
| Common comparison | Register stores data; counter updates data in sequence |
| One-line interview answer | "Flip-flops remember one bit, registers remember words, and counters remember and advance numeric state." |
