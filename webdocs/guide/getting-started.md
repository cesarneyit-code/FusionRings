# Getting Started

This is the practical "first 10 minutes" path. You will:
1) load the package,
2) run one full modular-data -> fusion-ring pipeline,
3) check a few standard families.

Before starting, make sure `LoadPackage("FusionRings")` returns `true`.
If GAP cannot find the package, install/symlink it in your GAP `pkg/` directory.

## Load the package

```gap
LoadPackage("FusionRings");;
```

## Quick rank-2 check (tau*tau = 1 + n*tau)

This is the fastest sanity check because it is fully explicit and parameterized.

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

## Core sanity check

This verifies the end-to-end path:
database entry -> `ModularData` -> validation -> `FusionRing`.

```gap
md := GetModularData(2, 1, 1);;
v := ValidateModularData(md, 4);;
v.ok;
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

Expected output:

```text
true
true
```

If both are `true`, the core pipeline is healthy.

What this means mathematically:
- the selected modular datum is internally consistent (up to validation level 4);
- its fusion coefficients define a valid fusion ring object.

## Fusion ring family smoke test

```gap
Ffib := FibonacciFusionRing();;
Fis := IsingFusionRing();;
G := CyclicGroup(3);;
Fty := TambaraYamagamiFusionRing(G);;
Fng := NearGroupFusionRing(G, 1);;

CheckFusionRingAxioms(Ffib, 1);
CheckFusionRingAxioms(Fis, 1);
CheckFusionRingAxioms(Fty, 1);
CheckFusionRingAxioms(Fng, 1);
```

Why these four?
- Fibonacci and Ising are standard small benchmark categories.
- Tambara-Yamagami and near-group cover non-pointed family constructors.

Expected output:

```text
true
true
true
true
```

For pointed examples and the bridge to modular data, see
`Fusion Rings and Modular Data`.

## Run tests

Strict:

```gap
LoadPackage("FusionRings");;
FusionRings_TestAllStrict();
```

Expected final line (success case): `0 failures in ... files`

Tolerant:

```gap
LoadPackage("FusionRings");;
FusionRings_TestAll();
```

CI helper (tests + docs):

```gap
LoadPackage("FusionRings");;
FusionRings_CI();
```

Recommended before pushing changes:
- run `FusionRings_TestAllStrict();`
- then run your local examples once more to confirm expected output.
