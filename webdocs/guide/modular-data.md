# Modular Data

`ModularData` stores:

- `S`, `T`
- labels
- optional fusion coefficients `N`
- quantum dimensions `d`
- spins `s`
- twists `theta`
- global dimension squared `D2`
- order of `T` (`ordT`)

Conceptually, a `ModularData` object is the package's canonical container for
the modular pair `(S, T)` and its derived invariants. Once this object exists,
all validation, database workflows, and fusion-ring conversion become uniform.

## Constructors

```gap
ModularData(rec);
ModularDataFromNsdRecord(rec);
ModularDataFromST(S, T[, labels]);
```

`ModularDataFromST` also accepts an options record as the last argument:

```gap
md := ModularDataFromST(S, T, labels, rec(inferN := true, completeData := true));;
```

- `inferN := true` attempts to infer fusion coefficients via Verlinde.
- `completeData := true` fills derived fields (`d`, `D2`, `theta`, `ordT`).

## Database-backed flow

```gap
LoadNsdGOL(rank);
md := GetModularData(rank, iGO, iMD);
```

This loads an entry from `pkg/FusionRings/data/modular_data/NsdGOL*.g`, reconstructs
`S` from `(N, s, d)`, and builds a typed `ModularData` object.

In other words: the database is compact (`N, s, d`), and `S` is reconstructed
deterministically through the balancing equation.

## Database files and indexing

- Files are split by rank: `NsdGOL2.g`, `NsdGOL3.g`, ..., `NsdGOL12.g`.
- Each file defines global `NsdGOL`.
- `NsdGOL[iGO]` is one Galois orbit.
- `NsdGOL[iGO][iMD]` is one modular data entry in that orbit.

Quick inspection:

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

rank := 3;;
LoadNsdGOL(rank);;
nsd := ValueGlobal("NsdGOL");;
Print("orbits: ", Length(nsd), "\n");
Print("entries in first orbit: ", Length(nsd[1]), "\n");
```

This tells you how many Galois orbits are available at that rank, and how many
entries are in a specific orbit.

## End-to-end: database -> validation -> fusion ring

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

md := GetModularData(2, 1, 1);;
v := ValidateModularData(md, 4);;
if not v.ok then
  Error(String(v.failures));
fi;

F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

If `ValidateModularData` fails, inspect `v.failures` before converting to a
fusion ring. That keeps debugging localized to the modular-data layer.

## Bridge condition: when conversion to FusionRing is possible

`FusionRingFromModularData(md)` requires fusion coefficients `N`.

- Database entries loaded with `GetModularData` include `N`.
- Some direct `(S, T)` constructors may not include `N` yet.

Quick check:

```gap
mdDB := GetModularData(2, 1, 1);;
MDFusionCoefficients(mdDB) = fail;   # false

mdV := VerlindeModularData("A", 1, 3);;
MDFusionCoefficients(mdV) = fail;    # true (current implementation state)
```
