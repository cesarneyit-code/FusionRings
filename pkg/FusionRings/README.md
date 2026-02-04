FusionRings (GAP Package)
=========================

FusionRings is a GAP package for computations with fusion rings, modular data,
and based modules (in the sense of based rings/modules). It includes exact
Frobenius-Perron tools, modular-data validation, ADE/Ostrik workflows for
`SU(2)_k`, and graph export helpers.

Project links
-------------
- Repository: https://github.com/cesarneyit-code/FusionRings
- Documentation website: https://cesarneyit-code.github.io/FusionRings/
- Citation guide: https://cesarneyit-code.github.io/FusionRings/guide/how-to-cite/
- Changelog: `CHANGES.md`

Loading
-------

```gap
LoadPackage("FusionRings");;
```

Quick start
-----------

```gap
md := GetModularData(2, 1, 1);;
ValidateModularData(md, 4).ok;

F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

Documentation
-------------

Build package manual (GAPDoc):

```gap
ReadPackage("FusionRings", "doc/build_manual.g");
```

Web docs (MkDocs Material, from repository root):

```bash
python3 -m pip install -r requirements-docs.txt
mkdocs serve
```

Core API areas
--------------

- Fusion-ring constructors and families:
  `FusionRing`, `FusionRingByRule`, `FusionRingBySparseConstants`,
  `FusionRingByFusionMatrices`, `PointedFusionRing`, `CyclicPointedFusionRing`,
  `FibonacciFusionRing`, `IsingFusionRing`, `TambaraYamagamiFusionRing`,
  `NearGroupFusionRing`
- Modular data:
  `ModularData`, `ModularDataFromNsdRecord`, `ModularDataFromST`,
  `ValidateModularData`, `LoadNsdGOL`, `GetModularData`,
  `FusionRingFromModularData`, `UniversalGradingFromModularData`,
  `CheckUniversalGradingEqualsInvertibles`, `VerlindeModularData`
- FP/arithmetic helpers:
  `FPDimensions`, `FPDimensionPolynomial`, `GlobalFPDimension`, `FPType`,
  `FormalCodegrees`, `IsIntegralFusionRing`, `IsWeaklyIntegralFusionRing`
- Subrings and grading:
  `CanonicalPointedSubring`, `AdjointSubring`, `UniversalGradingData`,
  `UniversalGradingComponent`, `UniversalGradingOrder`
- Based modules and ADE workflows:
  `FusionModuleByActionMatrices`, `FusionSubmoduleByGenerators`,
  `FusionModuleComponents`, `IsIrreducibleFusionModule`,
  `AreEquivalentFusionModules`, `FusionModuleGraph`, `OstrikSU2Module`,
  `OstrikSU2Modules`, `IsOstrikSU2Module`, `OstrikReport`
- Graph export:
  `FusionModuleGraphDOT`, `SaveFusionModuleGraphDOT`,
  `SaveFusionModuleGraphSVG`

Testing
-------

From GAP:

```gap
FusionRings_TestAllStrict();
```

Installed-package smoke test (from repository root):

```bash
./bin/fr-smoke-installed
```

Useful local scripts (repository root):

```bash
./bin/fr-test
./bin/fr-test-strict
./bin/fr-smoke-installed
./bin/fr-ci
./bin/fr-doc
./bin/fr-webdocs
```

License
-------

GPL-2.0-or-later. See `LICENSE`.
