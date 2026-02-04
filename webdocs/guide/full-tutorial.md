# Full Tutorial

This is a single narrative flow you can run top-to-bottom in GAP. It is meant
for new users who want to understand both the API and the expected behavior.

At the end of this tutorial you will have:
- created standard fusion-ring families;
- loaded and validated modular data from the database;
- bridged modular data to a fusion ring;
- run exact FP-dimension and criterion checks.

## Step 1: Load the package

```gap
LoadPackage("FusionRings");;
```

## Step 2: Rank-2 family sanity check

```gap
F0 := Rank2FusionRing(0);;
F1 := Rank2FusionRing(1);;
F5 := Rank2FusionRing(5);;

MultiplyBasis(F0, "tau", "tau");
MultiplyBasis(F1, "tau", "tau");
MultiplyBasis(F5, "tau", "tau");
```

Expected output:

```text
[ [ "1", 1 ] ]
[ [ "1", 1 ], [ "tau", 1 ] ]
[ [ "1", 1 ], [ "tau", 5 ] ]
```

## Step 3: Rank-3 family sanity check

```gap
F3 := Rank3FusionRing(0, 1, 0, 0);;
MultiplyBasis(F3, "X", "X");
MultiplyBasis(F3, "Y", "Y");
MultiplyBasis(F3, "X", "Y");
```

Expected output:

```text
[ [ "1", 1 ] ]
[ [ "1", 1 ], [ "X", 1 ] ]
[ [ "Y", 1 ] ]
```

## Step 4: Quick constructor sanity checks

```gap
Ffib := FibonacciFusionRing();;
Fis := IsingFusionRing();;
G3 := CyclicGroup(3);;
Fty := TambaraYamagamiFusionRing(G3);;

CheckFusionRingAxioms(Ffib, 1);
CheckFusionRingAxioms(Fis, 1);
CheckFusionRingAxioms(Fty, 1);
```

Expected output:

```text
true
true
true
```

## Step 5: Load modular data from the database

```gap
LoadNsdGOL(2);;
md := GetModularData(2, 1, 1);;
v := ValidateModularData(md, 7);;
v.ok;
```

Expected output:

```text
true
```

This means the selected entry passes high-level validation checks.

## Step 6: Bridge modular data into a fusion ring

```gap
Fmd := FusionRingFromModularData(md);;
CheckFusionRingAxioms(Fmd, 1);
```

Expected output:

```text
true
```

Now you have a ring object reconstructed from modular data and verified at level
1.

## Step 7: Understand invertibles and pointed subrings

```gap
InvertibleSimples(Fis);
P := CanonicalPointedSubring(Fis);;
LabelsList(P);
IsPointedFusionRing(P);
```

Expected output:

```text
[ "1", "psi" ]
[ "1", "psi" ]
true
```

Interpretation: Ising is not pointed, but it contains a canonical pointed part.

## Step 8: FP dimensions (exact and approximate views)

```gap
FPDimensionPolynomial(Ffib, "x");
FPDimensions(Ffib)[2];
FPDimensionApprox(Ffib, "x", 8);
GlobalFPDimension(Ffib);
```

Expected output:

```text
x_1^2-x_1-1
fp2
1.61803399
fp2+2
```

Use exact outputs (`fp2`) for algebraic computations; use decimal approximations
only for intuition and quick inspection.

## Step 9: Criterion-failure example (paper-style)

```gap
M := [
  [ [1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1] ],
  [ [0,1,0,0],[0,0,1,0],[1,0,0,0],[0,0,0,1] ],
  [ [0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1] ],
  [ [0,0,0,1],[0,0,0,1],[0,0,0,1],[1,1,1,1] ]
];;
Fbad := FusionRingByFusionMatrices([1..4], 1, fail, M, rec(inferDual := true, check := 0));;
dres := CheckDNumberCriterionCommutative(Fbad);;
dres.ok;
dres.failures[1];
```

Expected output:

```text
false
formal codegree polynomial #2 fails d-number divisibility test
```

This is useful as a known negative test case.

## Step 10: Run the full test suite

```gap
LoadPackage("FusionRings");;
FusionRings_TestAllStrict();
```

Success signal: final summary with `0 failures in ... files`.

Where to go next:
- [Worked Examples](examples.md) for more patterns;
- [Theorem to Computation](theorem-to-computation.md) for paper-oriented workflows;
- [Quick API](../api/quick-api.md) as a compact reference.
