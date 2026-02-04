# Getting Started

This page is the practical "first 10 minutes" path for FusionRings development.
The goal is to load the package code directly, run one modular-data pipeline,
and then confirm a few representative fusion-ring families.

## Local developer loader

Use direct loading while iterating locally:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
```

Or use the convenience entrypoint:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/start_modulardata.g");
```

`read_direct.g` is better for rapid local iteration because it rereads source
files directly from this repository and exposes helper test functions.

## Core sanity check

This verifies the end-to-end path:
database entry -> `ModularData` -> validation -> `FusionRing`.

```gap
md := GetModularData(2, 1, 1);;
ValidateModularData(md, 4);
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

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

## Run tests

Strict:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
FusionRings_TestAllStrict();
```

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
