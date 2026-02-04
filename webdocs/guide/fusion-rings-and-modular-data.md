# Fusion Rings and Modular Data

This page explains three things together:

- how to construct common FusionRing families (pointed, Tambara-Yamagami, etc.),
- how to load modular data from the database,
- and how the bridge between both layers works in practice.

## 1) Load the package code

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
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
MDFusionCoefficients(mdv) = fail;
```

So at this stage, the bridge is one-way only when fusion coefficients are
available in the `ModularData` object.
