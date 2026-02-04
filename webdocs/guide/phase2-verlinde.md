# Phase 2: Verlinde / Root-System Layer

## Current status

Implemented now:

- `VerlindeModularData("A", 1, k)` for SU(2)_k (`k >= 1`).

Still pending:

- `VerlindeModularData` for other types/ranks.
- `VerlindeModularDataByLieAlgebra(L, level)`.
- `VerlindeModularDataByRootSystem(R, level)`.

## SU(2)_k formulas

For labels `a,b in {0,..,k}` and `q = exp(pi i / (k+2))`:

```text
S_ab = (q^((a+1)(b+1)) - q^-((a+1)(b+1))) / (q - q^-1)
T_aa = exp(pi i * a(a+2) / (2(k+2)))
```

In GAP cyclotomic notation:

```gap
q := E(2*(k+2));
S_ab := (q^((a+1)*(b+1)) - q^-((a+1)*(b+1))) / (q - q^-1);
T_aa := E(4*(k+2))^(a*(a+2));
```

## Validation example

```gap
for k in [1..5] do
  md := VerlindeModularData("A", 1, k);;
  v4 := ValidateModularData(md, 4);;
  if not v4.ok then
    Error(Concatenation("SU(2) level ", String(k), " failed"));
  fi;
od;
```
