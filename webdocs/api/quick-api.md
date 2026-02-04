# Quick API

## Constructors

- `ModularData(rec | S, T[, labels])`
- `ModularDataFromNsdRecord(rec)`
- `ModularDataFromST(S, T[, labels])`

## Validation and loaders

- `ValidateModularData(md[, level])`
- `LoadNsdGOL(rank)`
- `GetModularData(rank, iGO, iMD)`

## Bridges and Verlinde

- `FusionRingFromModularData(md)`
- `VerlindeModularData(type, rank, level)`
- `VerlindeModularDataByLieAlgebra(L, level)`
- `VerlindeModularDataByRootSystem(R, level)`

## Attributes

- `SMatrix(md)`, `TMatrix(md)`, `MDLabels(md)`
- `MDSpins(md)`, `MDTwists(md)`, `MDQuantumDimensions(md)`
- `MDGlobalDimensionSquared(md)`, `MDFusionCoefficients(md)`, `MDOrderT(md)`
