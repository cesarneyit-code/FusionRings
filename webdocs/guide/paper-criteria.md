# Paper Criteria Examples

This page shows how to prototype criteria from `classification_fusion_rings.tex`
using currently available FusionRings APIs.

## 1) Formal codegrees (Drinfeld/d-number workflows)

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

F := CyclicPointedFusionRing(4);;
fc := FormalCodegrees(F);;
fc;
```

Each entry contains:
- `value` (exact when available),
- `polynomial`,
- `multiplicity`,
- `approx` (numeric helper).

## 2) Integrality style checks

```gap
Fi := IsingFusionRing();;
IsIntegralFusionRing(Fi);        # false
IsWeaklyIntegralFusionRing(Fi);  # true

F4 := CyclicPointedFusionRing(4);;
IsIntegralFusionRing(F4);        # true
IsWeaklyIntegralFusionRing(F4);  # true
```

## 3) Pointed / invertible / subring structure

```gap
Fi := IsingFusionRing();;
InvertibleSimples(Fi);            # [ "1", "psi" ]
P := CanonicalPointedSubring(Fi);;
IsPointedFusionRing(P);           # true
```

## 4) Modular-data validation as criterion pipeline

```gap
md := GetModularData(2, 1, 1);;
for l in [1..7] do
  v := ValidateModularData(md, l);;
  Print("level ", l, " -> ", v.ok, "\n");
od;
```

## 5) Reproducing paper-style computations

Today, the package already supports core ingredients used in the paper:
- fusion matrices,
- exact FP dimensions and type,
- formal codegrees,
- layered modular-data validation.

Next natural additions are dedicated APIs for Schur/Drinfeld/d-number/cyclotomic
criteria directly as one-call checks.
