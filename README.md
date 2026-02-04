# FusionRings for GAP

FusionRings is a GAP package for computations with fusion rings and modular data.
It provides exact algebraic arithmetic, constructors for standard families, validation tools,
and module-graph workflows inspired by the ADE/Ostrik perspective.

## Project links

- Documentation website: https://cesarneyit-code.github.io/FusionRings/
- Source repository: https://github.com/cesarneyit-code/FusionRings
- Package directory in this repository: `pkg/FusionRings`

## Main capabilities

- Fusion ring constructors:
  - rule/sparse/matrix constructors
  - pointed, cyclic pointed, Fibonacci, Ising, Tambara-Yamagami, near-group families
- Modular data:
  - database loading (`NsdGOL` files)
  - validation levels 1-7
  - constructors from `(S, T)` and Verlinde `SU(2)_k`
- Bridges:
  - `FusionRingFromModularData`
- FP tools:
  - exact FP dimensions, global FP dimension, FP type, formal codegrees
- Based modules over fusion rings:
  - construction, submodules, irreducibility/indecomposability, equivalence
  - graph extraction (`FusionModuleGraph`, DOT export)
- Ostrik/ADE helpers for `SU(2)_k`:
  - `OstrikSU2Module`, `OstrikSU2Modules`, compatibility/report helpers

## Installation and loading

If FusionRings is installed as a GAP package, load with:

```gap
LoadPackage("FusionRings");;
```

## Quick start

```gap
LoadPackage("FusionRings");;

md := GetModularData(2, 1, 1);;
ValidateModularData(md, 4).ok;

F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

## Development notes

- Web docs source: `webdocs/`
- MkDocs config: `mkdocs.yml`
- Package source: `pkg/FusionRings/lib/`
- Tests: `pkg/FusionRings/tst/`

## Citation and contact

Maintainer: **Cesar Galindo**  
Professor of Mathematics, Universidad de los Andes  
Email: **cn.galindo1116@uniandes.edu.co**

If FusionRings is useful in your work, please cite the project and acknowledge it in papers/preprints.

Suggested BibTeX:

```bibtex
@software{FusionRingsGAP2026,
  author       = {Cesar Galindo},
  title        = {FusionRings for GAP},
  year         = {2026},
  version      = {0.2.1},
  url          = {https://github.com/cesarneyit-code/FusionRings},
  note         = {GAP package for fusion rings, modular data, and based-module computations}
}
```
