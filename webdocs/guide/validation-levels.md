# Validation Levels

`ValidateModularData(md, level)` performs incremental checks.

## Levels

1. Shape checks, `S` symmetry/orthogonality, diagonal `T`.
2. Gauss sums, modular equation `(ST)^3`, root-of-unity ratio check.
3. Verlinde coefficients consistency/integrality.
4. Balancing equation.
5. FS indicator check (`nu2`).
6. Partial field and Galois checks (cyclotomic containment/permutation up to sign).
7. Cauchy prime-divisor check from `ord(T)` and `D^2` (or norm fallback).

## Typical usage

```gap
v := ValidateModularData(md, 4);
if not v.ok then
  Print(v.failures, "\n");
fi;
```
