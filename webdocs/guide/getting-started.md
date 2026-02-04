# Getting Started

This is the practical "first 10 minutes" path. You will:
1) load local code,
2) run one full modular-data -> fusion-ring pipeline,
3) check a few standard families.

## Local developer loader

Use direct loading while iterating locally:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
```

Or use the convenience entrypoint:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/start_modulardata.g");
```

`read_direct.g` is the default for local development: it rereads source files
from this repo and exposes helper test functions.

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
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
FusionRings_TestAllStrict();
```

Expected final line (success case): `0 failures in ... files`

Tolerant:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
FusionRings_TestAll();
```

CI helper (tests + docs):

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
FusionRings_CI();
```
