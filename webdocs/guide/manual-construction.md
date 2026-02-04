# Manual Construction

This page shows direct constructors for FusionRing and ModularData objects.

## 1) Fusion ring from sparse product table

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

labels := [ "1", "x" ];;
prodTable := [
  [ "1", "1", [ [ "1", 1 ] ] ],
  [ "1", "x", [ [ "x", 1 ] ] ],
  [ "x", "1", [ [ "x", 1 ] ] ],
  [ "x", "x", [ [ "1", 1 ], [ "x", 1 ] ] ]
];;

F := FusionRingBySparseConstants(labels, "1", ["1","x"], prodTable, rec(check := 2));;
CheckFusionRingAxioms(F, 2);
```

## 2) Fusion ring from fusion matrices

```gap
M := [
  [ [1,0],[0,1] ],
  [ [0,1],[1,1] ]
];;
F := FusionRingByFusionMatrices(["1","x"], "1", ["1","x"], M, rec(check := 2));;
```

## 3) Modular data from `(S, T)`

```gap
md0 := GetModularData(2, 1, 1);;
S := SMatrix(md0);;
T := TMatrix(md0);;

md := ModularDataFromST(S, T, [1,2], rec(inferN := true, completeData := true));;
ValidateModularData(md, 3).ok;
```

## 4) Bridge to fusion ring

```gap
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

## 5) Build subrings by generators

```gap
Fi := IsingFusionRing();;
P := FusionSubringByGenerators(Fi, ["psi"]);;
LabelsList(P);   # [ "1", "psi" ]
```
