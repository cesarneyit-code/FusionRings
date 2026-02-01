FusionRings (GAP)
=================

FusionRings provides GAP objects for fusion rings with a stable public API,
multiple internal representations, and verification utilities.

Status
------
MVP core (construction, multiply, dual, and consistency checks) is implemented.
Documentation and extended features are planned.

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
- Helpers: `NormalizeProductList`
- Export/Import: `FusionRingRecord`, `FusionRingFromRecord`, `SaveFusionRing`, `LoadFusionRing`

Testing
-------
Recommended workflow:

```
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
FusionRings_RewriteTests();   # normalize outputs once per GAP install
FusionRings_TestAllStrict();  # strict verification
```

If your GAP installation has newline/output quirks, use:

```
FusionRings_TestAll();        # tolerant comparison (uptonl)
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
