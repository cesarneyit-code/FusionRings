# Roadmap

## Done

- ModularData object and reconstruction from database records.
- Validation levels 1 to 7.
- Rank <= 12 database loader and getter helpers.
- Fusion ring bridge from modular data.
- Phase 2 kickoff: SU(2)_k via `VerlindeModularData("A", 1, k)`.
- New automated test: `pkg/FusionRings/tst/test_verlinde_su2.tst`.

## Next targets

1. Type A rank > 1 (SU(n+1)_k) via Weyl-group formulas.
2. `VerlindeModularDataByLieAlgebra` and `...ByRootSystem` implementations.
3. Extra tests for SU(3)_k and broader level sweeps.
4. Optional zesting layer after original data constructors are stable.
