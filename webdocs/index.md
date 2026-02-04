# FusionRings for GAP

<div class="hero-card">
FusionRings builds fusion rings and modular data with exact arithmetic in GAP.
Current Phase 2 progress includes an implemented SU(2)_k Verlinde constructor.
</div>

## What is included

- Fusion ring constructors from rules, sparse tables, and matrices.
- ModularData objects from database entries or direct `(S, T)` input.
- Validation pipeline with levels 1 to 7.
- Rank `<= 12` modular data database loaders.
- Bridge from modular data to fusion rings.
- Phase 2 start: `VerlindeModularData("A", 1, k)` for SU(2)_k.

## Fast start

```gap
LoadPackage("FusionRings");;

md := GetModularData(2, 1, 1);;
ValidateModularData(md, 4);
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

See [Getting Started](guide/getting-started.md) for package usage and test commands.

## Maintainer and citation

- Maintainer: **Cesar Galindo**
- Repository: [github.com/cesarneyit-code/FusionRings](https://github.com/cesarneyit-code/FusionRings)
- Contact: please open an issue in the GitHub repository for questions/collaboration.
- If this package is useful in your work, please cite it and acknowledge the
  FusionRings project in your paper/preprint.
