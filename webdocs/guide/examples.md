# Worked Examples

All snippets here are designed to be copy-paste runnable in GAP after loading
`read_direct.g`. They escalate from constructor smoke tests to database
navigation and then Phase 2 Verlinde checks.

## Example 1: Pointed family constructors

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

G := Group((1,2,3));;
Fpt := PointedFusionRing(G);;
CheckFusionRingAxioms(Fpt, 1);
MultiplyBasis(Fpt, (1,2,3), (1,2,3));

Fc4 := CyclicPointedFusionRing(4);;
CheckFusionRingAxioms(Fc4, 1);
```

## Example 2: Family constructors (Fibonacci, Ising, Tambara-Yamagami, near-group)

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

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

Expected result: all checks return `true`.

## Example 3: Load modular data from the NsdGOL database

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

LoadNsdGOL(2);;      # loads pkg/FusionRings/data/modular_data/NsdGOL2.g
md := GetModularData(2, 1, 1);;
v := ValidateModularData(md, 7);;
v.ok;
```

This is the shortest "database to validated modular data" workflow.

## Example 4: Scan a rank file and find a level-4 valid entry

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

rank := 3;;
LoadNsdGOL(rank);;
nsd := ValueGlobal("NsdGOL");;
found := false;;
for i in [1..Length(nsd)] do
  for j in [1..Length(nsd[i])] do
    md := GetModularData(rank, i, j);;
    if ValidateModularData(md, 4).ok then
      Print("first valid entry at iGO=", i, ", iMD=", j, "\n");
      found := true;
      break;
    fi;
  od;
  if found then break; fi;
od;
```

This pattern is useful when exploring a rank file without assuming the first
entry satisfies the validation level you want.

## Example 5: Build a fusion ring from modular data

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

md := GetModularData(2, 1, 1);;
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

This confirms the reconstructed fusion coefficients are compatible with the
core ring axioms.

## Example 6: Phase 2 constructor SU(2)_k

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

for k in [1..5] do
  md := VerlindeModularData("A", 1, k);;
  if not ValidateModularData(md, 4).ok then
    Error(Concatenation("failed at level ", String(k)));
  fi;
od;
```

This is the currently implemented Verlinde path: type A, rank 1.

## Example 7: Check whether modular data has fusion coefficients

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

mdDB := GetModularData(2, 1, 1);;
MDFusionCoefficients(mdDB) = fail;      # expected: false

mdV := VerlindeModularData("A", 1, 3);;
MDFusionCoefficients(mdV) = fail;       # expected: true (current Phase 2 state)
```

Use this check before calling `FusionRingFromModularData(md)`.

## Example 8: Canonical pointed subring from invertibles

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

Fi := IsingFusionRing();;
InvertibleSimples(Fi);                    # [ "1", "psi" ]
P := CanonicalPointedSubring(Fi);;
IsPointedFusionRing(P);
```

## Example 9: Exact FP dimensions and polynomials

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

F := FibonacciFusionRing();;
FPDimensionPolynomial(F, "x");
FPDimensions(F);                          # exact algebraic values
FPDimensionApprox(F, "x", 6);             # decimal helper
```

## Example 10: FP type, integrality, and formal codegrees

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

Fi := IsingFusionRing();;
FPTypeApprox(Fi, 3);                      # [ 1., 1., 1.414 ]
IsIntegralFusionRing(Fi);                 # false
IsWeaklyIntegralFusionRing(Fi);           # true

F4 := CyclicPointedFusionRing(4);;
FormalCodegrees(F4);
```

## Example 11: Run the SU(2)_k test file

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
Test("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/tst/test_verlinde_su2.tst",
     rec(compareFunction := "uptowhitespace"));
```

Use this when you want test-harness output (timings/diffs) instead of ad-hoc checks.
