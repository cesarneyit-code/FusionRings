FusionRings (GAP)
=================

FusionRings provides GAP objects for fusion rings with a stable public API,
multiple internal representations, and verification utilities.

Status
------
MVP core (construction, multiply, dual, and consistency checks) is implemented.
Documentation and extended features are planned.

Modular Data (new)
------------------
FusionRings now includes a **ModularData** module with:
- Admissible modular data specification (levels 1–7 validation)
- Direct reconstruction of `S` from `(N, s, d)` via the balancing equation
- Database access to the rank ≤ 12 catalog (`NsdGOL`)
- Helpers to build a `FusionRing` from modular data

Roadmap:
- Root‑system/Verlinde constructors (original data from Lie theory)
- Zesting layer on top of original modular data

Current constructor status:
```
VerlindeModularData("A", 1, k);   # implemented (SU(2)_k)
VerlindeModularData("A", 2, k);   # planned
VerlindeModularDataByLieAlgebra(L, k);
VerlindeModularDataByRootSystem(R, k);
```

Single source of truth:
```
pkg/FusionRings/doc/modular_data.md
```

Installation (development)
--------------------------
1) Copy or symlink this directory into a GAP package directory, e.g.
   ~/.gap/pkg/FusionRings
2) Start GAP and run: LoadPackage("FusionRings");

Contents
--------
- lib/FusionRing.gd: declarations
- lib/FusionRing.gi: generic methods + helpers
- lib/FusionRingRule.gi: rule-based representation
- lib/FusionRingSparse.gi: sparse constants representation
- lib/FusionRingMatrices.gi: matrices representation
- tst/: tests

Documentation
-------------
Build the manual (GAPDoc required):

```
Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/doc/build_manual.g");
```

Web documentation (TensorKit-style site with MkDocs Material):

```
cd /Users/cesargalindo/Documents/FusionRings
python3 -m pip install -r requirements-docs.txt
mkdocs serve
```

Source lives in:

```
mkdocs.yml
webdocs/
```

Examples
--------
```
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
F := FibonacciFusionRing();;
F := IsingFusionRing();;
F := CyclicPointedFusionRing(4);;
G := CyclicGroup(3);;
F := TambaraYamagamiFusionRing(G);;
F := NearGroupFusionRing(G, 1);;
Display(F);
```

ModularData quick start:
```
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
md := GetModularData(2, 1, 1);;
S := SMatrix(md);;
T := TMatrix(md);;
ValidateModularData(md, 4);
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

Example `Display(F)` output:
```
FusionRing
  rep: rule
  rank: 3
  one: ()
  labels: [ (), (1,2,3), (1,3,2) ]
```

API (core)
----------
- Constructors: `FusionRing`, `FusionRingByRule`, `FusionRingBySparseConstants`, `FusionRingByFusionMatrices`
- Families: `PointedFusionRing`, `CyclicPointedFusionRing`, `FibonacciFusionRing`, `IsingFusionRing`,
  `TambaraYamagamiFusionRing`, `NearGroupFusionRing`
- Operations: `MultiplyBasis`, `FusionCoefficient`, `DualLabel`, `FusionMatrix`, `CheckFusionRingAxioms`
- Attributes/Indexing: `BasisLabels`, `OneLabel`, `LabelsList`, `DualTable`, `FusionMatrices`,
  `PositionOfLabel`, `LabelOfPosition`
- FP dimensions: `FPDimensions`, `FPDimensionData`, `FPDimensionPolynomials`,
  `FPDimensionPolynomial`, `FPDimensionApprox`, `FPDimensionsApprox`,
  `GlobalFPDimension`, `FPType`, `FPTypeApprox`, `FormalCodegrees`
- Paper criteria helpers (commutative): `CheckDNumberCriterionCommutative`,
  `CheckDrinfeldCriterionCommutative`, `CheckExtendedCyclotomicCriterionCommutative`,
  `CheckPaperCriteriaCommutative`
- Subrings/invertibles: `IsInvertibleSimple`, `InvertibleSimples`,
  `IsPointedFusionRing`, `IsFusionSubring`, `FusionSubring`,
  `FusionSubringByGenerators`, `FusionSubringLatticeSmall`,
  `CanonicalPointedSubring`, `AdjointSubring`,
  `IsIntegralFusionRing`, `IsWeaklyIntegralFusionRing`
- Based modules: `FusionModuleByActionMatrices`, `ActionMatrix`, `ActionOnBasis`,
  `IsFusionSubmodule`, `FusionSubmodule`, `FusionSubmoduleByGenerators`,
  `FusionModuleComponents`, `IsIndecomposableFusionModule`,
  `IsIrreducibleFusionModule`, `AreEquivalentFusionModules`, `FusionModuleGraph`,
  `CanonicalFusionModule`, `FusionSubmoduleByObject`, `DynkinGraphAdjacency`,
  `OstrikSU2Module`, `OstrikSU2Modules`, `IsOstrikSU2Module`,
  `NimrepFromModule`, `GraphSpectrumApprox`, `CoxeterNumberFromAdjacencyApprox`,
  `IsADELevelCompatible`, `CheckOstrikADEData`,
  `FusionModuleGraphDOT`, `SaveFusionModuleGraphDOT`, `OstrikReport`
- Helpers: `NormalizeProductList`
- Export/Import: `FusionRingRecord`, `FusionRingFromRecord`, `SaveFusionRing`, `LoadFusionRing`

Testing
-------
Recommended workflow:

```
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
FusionRings_RewriteTests();   # normalize outputs once per GAP install
FusionRings_TestAllStrict();  # strict (ignores newline-only diffs)
```

If your GAP installation has newline/output quirks, use:

```
FusionRings_TestAll();        # tolerant comparison (uptowhitespace)
```

Shortcuts
---------
From GAP you can simply:

```
Read("/Users/cesargalindo/Documents/FusionRings/run_tests.g");
```

Strict run:

```
Read("/Users/cesargalindo/Documents/FusionRings/run_tests_strict.g");
```

Normalize (once per GAP install):

```
Read("/Users/cesargalindo/Documents/FusionRings/normalize_tests.g");
```

ModularData tests are included in the same test suite.

CI (local)
----------
Run tests + build docs in one step:

```
Read("/Users/cesargalindo/Documents/FusionRings/run_ci.g");
```

Shell shortcuts (recommended)
-----------------------------
From the repo root you can run:

```
./bin/fr-test
./bin/fr-test-strict
./bin/fr-ci
./bin/fr-doc
./bin/fr-webdocs
```

If you want them available globally, add the repo's `bin/` to your PATH.

Test Suite Contents
-------------------
- `tst/test_pointed.tst`: pointed fusion ring (group-based) basics
- `tst/test_sparse.tst`: sparse representation (Z/2 example)
- `tst/test_matrices.tst`: matrices representation (Z/2 example)
- `tst/test_axioms2.tst`: level-2 axioms on small cases
- `tst/test_families.tst`: Fibonacci/Ising/TY/cyclic family constructors
- `tst/test_neargroup.tst`: near-group (G+k) constructor and rules
- `tst/test_export.tst`: save/load roundtrip for sparse rings
- `tst/test_export_matrices.tst`: save/load roundtrip for matrices

License
-------
GPL-2.0-or-later. See LICENSE.
