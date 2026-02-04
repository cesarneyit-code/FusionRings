# Validation Levels

`ValidateModularData(md, level)` performs incremental checks.

Validation is cumulative: level `n` includes checks from levels `1..n`.

Think of levels as "how strict should I be right now?":
- Levels `1-3`: fast structural screening.
- Level `4`: strong consistency checkpoint (good default in practice).
- Levels `5-7`: deeper arithmetic/Galois-style filters.

## Level-by-level details

1. **Shape and basic matrix constraints**
   - `S` is square and symmetric.
   - `S * S^t = D^2 I`.
   - `T` is diagonal.
2. **Modular/Gauss relations**
   - Gauss sums `p_+`, `p_-` satisfy `p_+ p_- = D^2`.
   - `(ST)^3 = p_+ S^2`.
   - `p_+/p_-` root-of-unity check (when available).
3. **Verlinde coefficients**
   - If stored `N` exists: checks exact match with Verlinde formula.
   - If `N` is absent: checks computed coefficients are nonnegative integers.
4. **Balancing equation**
   - Verifies `S_{ij}` reconstruction from `N`, twists, and dimensions.
5. **Frobenius-Schur indicators**
   - Checks `nu_2` constraints on self-dual / non-self-dual simples.
6. **Field and Galois structure (partial implementation)**
   - Cyclotomic containment checks for entries of `S`, `T`.
   - Column permutation under Galois action (up to sign), when available.
7. **Cauchy prime check**
   - Compares primes dividing `ord(T)` and `D^2` (or `Norm(D^2)` fallback).

## Typical usage

```gap
v := ValidateModularData(md, 4);
if not v.ok then
  Print(v.failures, "\n");
fi;
```

Suggested defaults:
- during exploration: level `4`;
- before claims/paper tables: level `7`.

## Full walkthrough on rank-2 and rank-3 database entries

```gap
LoadPackage("FusionRings");;

# Rank 2 example
md2 := GetModularData(2, 1, 1);;
for l in [1..7] do
  v := ValidateModularData(md2, l);;
  Print("rank2 level ", l, ": ok=", v.ok, ", failures=", Length(v.failures), "\n");
od;

# Rank 3 example (first level-4-valid entry found in the database)
md3 := GetModularData(3, 2, 1);;
for l in [1..7] do
  v := ValidateModularData(md3, l);;
  Print("rank3 (2,1) level ", l, ": ok=", v.ok, ", failures=", Length(v.failures), "\n");
od;
```

Expected behavior for these examples: all levels return `ok=true`.

Reading the output:
- `ok=true, failures=0` means the entry passed all checks up to that level;
- if a level fails, inspect `v.failures` and stop before bridge/construction steps.

## Reproducible test command (entire package)

To verify that all validation-related tests pass together with the rest of the package:

```gap
LoadPackage("FusionRings");;
FusionRings_TestAllStrict();
```

Recent run status on this repository:
- `0 failures in 27 files`
- `No errors detected while testing`
