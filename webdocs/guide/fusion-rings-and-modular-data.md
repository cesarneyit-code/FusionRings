# Fusion Rings and Modular Data

This page explains three things together:

- how to construct common FusionRing families (pointed, Tambara-Yamagami, etc.),
- how to load modular data from the database,
- and how the bridge between both layers works in practice.

## 1) Load the package code

```gap
LoadPackage("FusionRings");;
```

## 2) FusionRing family constructors

### Pointed families

```gap
G := Group((1,2,3));;
Fpt := PointedFusionRing(G);;
CheckFusionRingAxioms(Fpt, 1);

Fc4 := CyclicPointedFusionRing(4);;
CheckFusionRingAxioms(Fc4, 1);
```

### Tambara-Yamagami and near-group

```gap
A := CyclicGroup(3);;
Fty := TambaraYamagamiFusionRing(A);;
Fng := NearGroupFusionRing(A, 1);;

CheckFusionRingAxioms(Fty, 1);
CheckFusionRingAxioms(Fng, 1);
```

These are useful benchmarks because they cover both pointed and non-pointed
construction patterns.

## 3) Modular-data database workflow

```gap
LoadNsdGOL(2);;                  # loads NsdGOL2.g
md := GetModularData(2, 1, 1);;
v := ValidateModularData(md, 4);;
v.ok;
```

The database stores compact records (`N, s, d`) and reconstructs `(S, T)` from
that data.

## 4) Relationship between both layers

### Database modular data -> FusionRing

```gap
md := GetModularData(2, 1, 1);;
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

This works because database-built `ModularData` includes fusion coefficients
`N`.

### Important caveat for direct `(S, T)` constructors

`FusionRingFromModularData(md)` needs `N`. If a modular-data object is built
from raw `(S, T)` only, `N` may be `fail`.

```gap
mdv := VerlindeModularData("A", 1, 3);;
MDFusionCoefficients(mdv) = fail;   # currently false for SU(2)_k: N is populated
```

Current status:
- SU(2)\_k via `VerlindeModularData("A", 1, k)` now includes `N`, so
  `FusionRingFromModularData` works on that path.
- Generic direct `(S, T)` wrappers can still have `N = fail` unless
  coefficients are provided or reconstructed.

## 5) Invertibles, pointedness, and canonical subrings

An object is invertible exactly when its fusion matrix is a permutation matrix.
This gives a canonical way to extract invertibles and build a pointed subring.

```gap
Fi := IsingFusionRing();;
IsInvertibleSimple(Fi, "1");      # true
IsInvertibleSimple(Fi, "psi");    # true
IsInvertibleSimple(Fi, "sigma");  # false

inv := InvertibleSimples(Fi);;
inv;                               # [ "1", "psi" ]
IsPointedFusionRing(Fi);           # false

P := CanonicalPointedSubring(Fi);;
BasisLabels(P);                    # [ "1", "psi" ]
IsPointedFusionRing(P);            # true
```

You can also test arbitrary subsets:

```gap
IsFusionSubring(Fi, [ "1", "psi" ]);    # true
IsFusionSubring(Fi, [ "1", "sigma" ]);  # false
```

## 6) Exact FP dimensions and associated polynomials

FP dimensions are stored exactly (algebraic numbers), with optional decimal
views for inspection.

```gap
F := FibonacciFusionRing();;
FPDimensions(F);                         # exact
FPDimensionPolynomial(F, "x");           # x^2 - x - 1
FPDimensionApprox(F, "x", 6);            # 1.618034
FPDimensionsApprox(F, 3);                # [ 1., 1.618 ]
```

Other useful FP helpers:

```gap
FPRank(F);
GlobalFPDimension(F);
FPType(F);                               # exact values (sorted by size)
FPTypeApprox(F, 3);                      # decimal view
FormalCodegrees(F);                      # list of records: value/polynomial/multiplicity
```

Integrality checks:

```gap
IsIntegralFusionRing(F);                 # all FPdims are integers
IsWeaklyIntegralFusionRing(F);           # global FP dimension is an integer
```

Canonical adjoint subring:

```gap
Fi := IsingFusionRing();;
A := AdjointSubring(Fi);;
BasisLabels(A);                          # [ "1", "psi" ]
```
