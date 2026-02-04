# Fusion Rings and Modular Data

This page explains three things together:

- how to construct common FusionRing families (pointed, Tambara-Yamagami, etc.),
- how to load modular data from the database,
- and how the bridge between both layers works in practice.

If you are new: run each code block in order. This page is written as a guided
script, not only as a reference.

## 1) Load the package code

```gap
LoadPackage("FusionRings");;
```

## 2) FusionRing family constructors

### Rank-2 family (tau*tau = 1 + n*tau)

```gap
F0 := Rank2FusionRing(0);;
F1 := Rank2FusionRing(1);;
F5 := Rank2FusionRing(5);;

MultiplyBasis(F0, "tau", "tau");
MultiplyBasis(F1, "tau", "tau");
MultiplyBasis(F5, "tau", "tau");
```

### Rank-3 family (K(k, l, m, n))

```gap
F3 := Rank3FusionRing(0, 1, 0, 0);;
MultiplyBasis(F3, "X", "X");
MultiplyBasis(F3, "Y", "Y");
MultiplyBasis(F3, "X", "Y");
```

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

`FusionRingFromModularData(md)` needs fusion coefficients `N`.
When you build `md` from raw `(S, T)`, you must check whether `N` was included
or inferred.

```gap
mdDB := GetModularData(2, 1, 1);;
MDFusionCoefficients(mdDB) = fail;   # expected: false

mdV := VerlindeModularData("A", 1, 3);;
MDFusionCoefficients(mdV) = fail;    # check current implementation state

md0 := GetModularData(2, 1, 1);;
S := SMatrix(md0);; T := TMatrix(md0);;
mdST := ModularDataFromST(S, T, [1,2]);;
MDFusionCoefficients(mdST) = fail;   # expected: true (no inferN option)

mdSTi := ModularDataFromST(S, T, [1,2], rec(inferN := true, completeData := true));;
MDFusionCoefficients(mdSTi) = fail;  # expected: false
```

Practical rule:
- if `MDFusionCoefficients(md) = fail`, do not call `FusionRingFromModularData(md)`;
- either use database-backed data, a constructor that already provides `N`, or
  `ModularDataFromST(..., rec(inferN := true, ...))` when appropriate.

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

## 7) Universal grading on fusion rings (worked examples)

Ising example:

```gap
Fi := IsingFusionRing();;
UGi := UniversalGradingData(Fi);;
UniversalGradingOrder(Fi);
UniversalGradingComponent(Fi, "1");
UniversalGradingComponent(Fi, "sigma");
UGi.multiplication;
```

Expected output:

```text
2
1
2
[ [ 1, 2 ], [ 2, 1 ] ]
```

Pointed example (`C4`):

```gap
F4 := CyclicPointedFusionRing(4);;
UG4 := UniversalGradingData(F4);;
UniversalGradingOrder(F4);
UG4.one;
UG4.isGroup;
```

Expected output:

```text
4
1
true
```

Interpretation:
- In Ising, the universal grading has two components, with `sigma` in the
  nontrivial one.
- In a pointed ring like `C4`, each simple gives a grading component and the
  grading is a genuine finite group.

If you want a compact summary of exact vs approximate APIs, continue with
[API Exactness](api-exactness.md).
