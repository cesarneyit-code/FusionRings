# Getting Started

## Local developer loader

Use direct loading while iterating locally:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
```

Or use the convenience entrypoint:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/start_modulardata.g");
```

## Core sanity check

```gap
md := GetModularData(2, 1, 1);;
ValidateModularData(md, 4);
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

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
