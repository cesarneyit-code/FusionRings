# Rank-5 Classification (LowrankIMRN)

This section summarizes the rank-5 classification result from
`LowrankIMRN.tex` and shows how to compute the corresponding fusion rules and
modular data in GAP.

## Definitions (brief)

- **Rank**: the number of isomorphism classes of simple objects.
- **Modular data**: the pair `(S, T)` of matrices satisfying the modular
  relations; it determines fusion rules via the Verlinde formula.
- **Grothendieck equivalence**: two modular categories have the same fusion
  rules (i.e., isomorphic Grothendieck rings), even if they are not equivalent
  as braided categories.

## The rank-5 classification (paper statement)

The paper proves that any rank-5 modular category is Grothendieck equivalent to
one of the following four families:

1. `SU(2)_4`
2. `SU(2)_9 / Z2`
3. `SU(5)_1`
4. `SU(3)_4 / Z3`

This is a complete list of **possible fusion rules** for rank-5 modular
categories.

## How to compute these in FusionRings

### 1) `SU(2)_4` (direct Verlinde)

```gap
LoadPackage("FusionRings");;

md := VerlindeModularData("A", 1, 4);;
ValidateModularData(md, 4).ok;
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

Gauss sums and central charge:

```gap
gs := MDGaussSums(md);;
gs.pplus;
gs.pminus;
MDCentralCharge(md);
```

### 2) `SU(5)_1` (pointed)

The fusion rules are pointed with group `Z5`:

```gap
F := CyclicPointedFusionRing(5);;
IsPointedFusionRing(F);
```

### 3) The two quotient families `SU(2)_9/Z2` and `SU(3)_4/Z3`

These are not yet produced by a direct Verlinde constructor in this package,
but they **do appear** in the rank-5 modular-data database (`NsdGOL5`).

```gap
LoadNsdGOL(5);;
md := GetModularData(5, iGO, iMD);;   # choose an orbit/entry
ValidateModularData(md, 7).ok;
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

## Application: scanning all rank-5 entries

This script iterates every rank-5 modular datum and prints a few invariants
useful for matching the four families.

```gap
LoadPackage("FusionRings");;
LoadNsdGOL(5);;
nsd := ValueGlobal("NsdGOL");;

for iGO in [1..Length(nsd)] do
  for iMD in [1..Length(nsd[iGO])] do
    md := GetModularData(5, iGO, iMD);;
    F := FusionRingFromModularData(md);;
    inv := Length(InvertibleSimples(F));
    dims := FPDimensions(F);;
    Print("orbit=", iGO, " entry=", iMD,
          " invertibles=", inv,
          " dims=", dims, "\n");
  od;
od;
```

Typical patterns:

- **Pointed (SU(5)\_1)**: all FP dimensions are `1`, invertibles = 5.
- **SU(2)\_4**: appears as a non-pointed entry with one dimension `2` and
  a characteristic rank-5 SU(2) fusion structure.
- **SU(2)\_9/Z2** and **SU(3)\_4/Z3**: non-pointed, non-isomorphic fusion rules;
  both are present as distinct Galois orbits in `NsdGOL5`.

## Practical takeaway

Use:
- `VerlindeModularData("A",1,4)` for `SU(2)_4`.
- `CyclicPointedFusionRing(5)` for `SU(5)_1`.
- `GetModularData(5, iGO, iMD)` for **all** rank-5 modular data, including the
  quotient families.
