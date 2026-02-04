# Worked Examples

This page is a guided tour: run a command, see what GAP prints, and understand
why that output matters. Start each session with:

```gap
LoadPackage("FusionRings");;
```

## 1) Pointed ring in 20 seconds

Start with a very small pointed ring (`CyclicPointedFusionRing(4)`), then check
the basic product logic.

```gap
Fc4 := CyclicPointedFusionRing(4);;
LabelsList(Fc4);
MultiplyBasis(Fc4, 2, 2);
CheckFusionRingAxioms(Fc4, 1);
```

Expected output:

```text
[ <identity> of ..., f1, f2, f1*f2 ]
[ [ 4, 1 ] ]
true
```

Interpretation:
- the second simple times itself lands in simple #4 with coefficient 1;
- level-1 axioms pass.

## 2) Fibonacci, Ising, and Tambara-Yamagami

This is a quick family smoke test that mixes pointed/non-pointed behavior.

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

Interpretation: all three constructors produce internally consistent fusion
rules at level 1.

## 3) From modular-data database to fusion ring

This is the core pipeline many users want:
database -> validated `ModularData` -> `FusionRing`.

```gap
LoadNsdGOL(2);;
md := GetModularData(2, 1, 1);;
v := ValidateModularData(md, 7);;
v.ok;

Fmd := FusionRingFromModularData(md);;
CheckFusionRingAxioms(Fmd, 1);
```

Expected output:

```text
true
true
```

Interpretation:
- the modular datum passes validation level 7;
- the reconstructed fusion ring also passes ring-axiom checks.

## 4) Invertibles and canonical pointed subring

Now inspect structure inside a non-pointed ring (`IsingFusionRing`).

```gap
Fi := IsingFusionRing();;
InvertibleSimples(Fi);
P := CanonicalPointedSubring(Fi);;
LabelsList(P);
IsPointedFusionRing(P);
```

Expected output:

```text
[ "1", "psi" ]
[ "1", "psi" ]
true
```

Interpretation: Ising has exactly two invertibles, and they generate the
canonical pointed subring.

## 5) FP dimensions: exact and approximate

Use exact values for algebraic work and decimal approximations for quick
intuition.

```gap
Ffib := FibonacciFusionRing();;
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

Interpretation:
- the FP dimension of `x` is the positive root of `x^2 - x - 1`;
- exact values stay algebraic (`fp2`), while approximations are optional.

## 6) Paper-style criterion example that fails

This rank-4 commutative example is useful because it fails a criterion in a
controlled way.

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

Interpretation: this is a concrete "criterion fails" case you can use while
developing filters/classifiers.

## 7) Full test run (when you want confidence)

```gap
FusionRings_TestAllStrict();
```

This runs the package test suite and is the right command before a commit.

## 8) Based modules over a fusion ring

The package now supports based modules (Ostrik's based modules over a based
ring, i.e. modules over a fusion ring with nonnegative integral action
matrices).

```gap
F2 := CyclicPointedFusionRing(2);;
A1 := [ [1,0],[0,1] ];;
Aswap := [ [0,1],[1,0] ];;

M := FusionModuleByActionMatrices(F2, [ "a", "b" ], [ A1, Aswap ]);;
ActionOnBasis(M, LabelOfPosition(F2, 2), "a");
IsIrreducibleFusionModule(M);
IsIndecomposableFusionModule(M);
```

Expected output:

```text
[ [ "b", 1 ] ]
true
true
```

And a reducible/decomposable example:

```gap
Afix := [ [1,0],[0,1] ];;
D := FusionModuleByActionMatrices(F2, [ "m1", "m2" ], [ A1, Afix ]);;
FusionModuleComponents(D);
SD := FusionSubmoduleByGenerators(D, [ "m1" ]);;
ModuleBasisLabels(SD);
```

Expected output:

```text
[ [ "m1" ], [ "m2" ] ]
[ "m1" ]
```

Module-graph view:

```gap
Gact := FusionModuleGraph(M, LabelOfPosition(F2, 2));;
Gact.mode;
Gact.edges;

Gcomb := FusionModuleGraph(D);;
Gcomb.mode;
Gcomb.edges;
```

Expected output:

```text
"action-directed"
[ [ "a", "b", 1 ], [ "b", "a", 1 ] ]
"combined-undirected"
[ [ "m1", "m1", 2 ], [ "m2", "m2", 2 ] ]
```

Canonical module of a fusion ring and cyclic submodule from one object:

```gap
Fi := IsingFusionRing();;
CM := CanonicalFusionModule(Fi);;
ModuleBasisLabels(CM) = LabelsList(Fi);
ActionOnBasis(CM, "sigma", "sigma");

Sobj := FusionSubmoduleByObject(Fi, "sigma");;
ModuleBasisLabels(Sobj);
```

Expected output:

```text
true
[ [ "1", 1 ], [ "psi", 1 ] ]
[ "1", "psi", "sigma" ]
```

Ostrik classification modules for `SU(2)_k` (ADE):

```gap
mods4 := OstrikSU2Modules(4);;
List(mods4, x -> x.type);
IsOstrikSU2Module(mods4[1].module, 4, "A");
IsOstrikSU2Module(mods4[2].module, 4, "D");

mods10 := OstrikSU2Modules(10);;
List(mods10, x -> x.type);
```

Expected output:

```text
[ "A", "D" ]
true
true
[ "A", "D", "E6" ]
```
