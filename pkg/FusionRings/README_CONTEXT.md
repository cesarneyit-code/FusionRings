FusionRings Project Context
===========================

Overview
--------
FusionRings is a GAP package implementing fusion rings with multiple internal
representations (rule-based, sparse, matrices), label-based APIs, axioms checks,
immutability, and caching. It includes several standard families (pointed,
Fibonacci, Ising, Tambara–Yamagami, near-group) and export/import utilities.

Location
--------
- Project root: /Users/cesargalindo/Documents/FusionRings
- Package: /Users/cesargalindo/Documents/FusionRings/pkg/FusionRings
- Manual sources: /Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/doc

How to load (direct)
--------------------
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

Common test commands
--------------------
Strict (recommended):
  Read("/Users/cesargalindo/Documents/FusionRings/run_tests_strict.g");

Tolerant (if newline quirks):
  Read("/Users/cesargalindo/Documents/FusionRings/run_tests.g");

Normalize tests for this GAP install (once):
  Read("/Users/cesargalindo/Documents/FusionRings/normalize_tests.g");

Local CI (tests + docs):
  Read("/Users/cesargalindo/Documents/FusionRings/run_ci.g");

Docs build
----------
Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/doc/build_manual.g");
HTML is produced in doc/chap0.html. PDF requires pdflatex.

Key APIs
--------
Constructors:
- FusionRing, FusionRingByRule, FusionRingBySparseConstants, FusionRingByFusionMatrices
- PointedFusionRing, CyclicPointedFusionRing
- FibonacciFusionRing, IsingFusionRing
- TambaraYamagamiFusionRing, NearGroupFusionRing

Operations:
- MultiplyBasis, FusionCoefficient, DualLabel, FusionMatrix, CheckFusionRingAxioms
- CheckFusionRingAxiomsSample (randomized checks)

Attributes/indexing:
- BasisLabels, OneLabel, DualData, RepresentationType
- LabelsList, DualTable, FusionMatrices
- PositionOfLabel, LabelOfPosition
- TYMLabel, NGRhoLabel

Export/import:
- FusionRingRecord, FusionRingFromRecord, SaveFusionRing, LoadFusionRing

Pretty printing:
- ViewObj, PrintObj, Display (for IsFusionRing)

Test suite contents
-------------------
- tst/test_pointed.tst: pointed rings
- tst/test_sparse.tst: sparse rep
- tst/test_matrices.tst: matrices rep
- tst/test_axioms2.tst: level-2 axioms (small)
- tst/test_families.tst: Fibonacci/Ising/TY/cyclic
- tst/test_neargroup.tst: near-group rules
- tst/test_export.tst: save/load sparse
- tst/test_export_matrices.tst: save/load matrices

Git
---
- Branch: main
- Commits:
  - 56111cd Add sampled checks and local CI helper
  - 422906d Fix GAPDoc paragraphs, display printing, and test runners
  - 079cc06 Ignore generated GAPDoc artifacts
  - 727c40f Add display output, export matrices test, and docs
  - f5e8a2e Initial stable FusionRings package

Notes about GAP manual
----------------------
If GAPDoc XML errors occur, check structure; use <P/> not <Para> inside <Section>.
Escapes: use &lt; and &gt; for < and > inside XML.

If future sessions need manual excerpts
---------------------------------------
Please provide:
- Relevant chapter/section from GAP manual (e.g., packages, GAPDoc, objects)
- Any error message line numbers for XML or GAPDoc parsing

Future Roadmap (user-defined)
-----------------------------
1) Modular data layer
   - Define ModularData object built on top of a FusionRing.
   - Load/import modular data from Rowell's paper (format to be specified).

2) Computations from fusion rings and modular data
   - Implement functions for invariants and constructions derived from FusionRing.
   - Extend to computations that use ModularData (S/T matrices, etc.).

3) Zestings
   - Describe and implement construction of zestings.
   - Load zestings from the Mora & Galindo paper (format to be specified).
