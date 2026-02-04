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

## Constructors

```gap
ModularData(rec);
ModularDataFromNsdRecord(rec);
ModularDataFromST(S, T[, labels]);
```

## Database-backed flow

```gap
LoadNsdGOL(rank);
md := GetModularData(rank, iGO, iMD);
```

This loads an entry from `pkg/FusionRings/data/modular_data/NsdGOL*.g`, reconstructs
`S` from `(N, s, d)`, and builds a typed `ModularData` object.
