# Constructors Reference

## `VerlindeModularData(type, rank, level)`

Current support:

- type `"A"`, rank `1`, level `k >= 1`.

Behavior:

- returns a `ModularData` object from exact cyclotomic S/T formulas for SU(2)_k.
- labels are `[0..k]`.

Errors:

- non-positive level.
- unsupported type/rank pair.

## `VerlindeModularDataByLieAlgebra(L, level)`

- declared and reserved for Phase 2 expansion.
- currently raises `not implemented yet`.

## `VerlindeModularDataByRootSystem(R, level)`

- declared and reserved for Phase 2 expansion.
- currently raises `not implemented yet`.
