# FusionRings for GAP

<div class="hero-card">
FusionRings builds fusion rings and modular data with exact arithmetic in GAP.
Current Phase 2 progress includes an implemented SU(2)_k Verlinde constructor.
</div>

## Who this is for

This documentation is written for:

- mathematicians who want exact computations with fusion rings and modular data;
- GAP users who want practical constructors and validation workflows;
- researchers who want reproducible examples for papers (including module graphs).

## What is included

- Fusion ring constructors from rules, sparse tables, and matrices.
- ModularData objects from database entries or direct `(S, T)` input.
- Validation pipeline with levels 1 to 7.
- Rank `<= 12` modular data database loaders.
- Bridge from modular data to fusion rings.
- Phase 2 start: `VerlindeModularData("A", 1, k)` for SU(2)_k.

## Fast start (2 minutes)

```gap
LoadPackage("FusionRings");;

md := GetModularData(2, 1, 1);;
ValidateModularData(md, 4);
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

If both checks return `true`, your setup is working.

## Recommended reading order

1. [Getting Started](guide/getting-started.md)
2. [Full Tutorial](guide/full-tutorial.md)
3. [Fusion Rings and Modular Data](guide/fusion-rings-and-modular-data.md)
4. [Worked Examples](guide/examples.md)
5. [Quick API](api/quick-api.md)

## Maintainer and citation

- Maintainer: **Cesar Galindo**
- Position: Professor of Mathematics, Universidad de los Andes
- Repository: [github.com/cesarneyit-code/FusionRings](https://github.com/cesarneyit-code/FusionRings)
- Contact: **cn.galindo1116@uniandes.edu.co** (or open a GitHub issue)
- If this package is useful in your work, please cite it and acknowledge the
  FusionRings project in your paper/preprint.
- Citation details and BibTeX: [How to Cite](guide/how-to-cite.md)
