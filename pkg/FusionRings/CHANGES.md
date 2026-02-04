Changelog
=========

0.2.0 (2026-02-04)
------------------
- Added exact FP helper APIs and formal codegrees workflow:
  `GlobalFPDimension`, `FPType`, `FPTypeApprox`, `FormalCodegrees`.
- Added commutative paper-criteria helpers:
  `CheckDNumberCriterionCommutative`, `CheckDrinfeldCriterionCommutative`,
  `CheckExtendedCyclotomicCriterionCommutative`, `CheckPaperCriteriaCommutative`.
- Added subring enhancements:
  `FusionSubringByGenerators`, `FusionSubringLatticeSmall`,
  `AdjointSubring`, universal grading APIs.
- Added based-module layer (Ostrik-style):
  `FusionModuleByActionMatrices`, submodule/irreducibility/equivalence APIs,
  canonical self-module and module graph helpers.
- Added SU(2)_k ADE/Ostrik module constructors and validators:
  `OstrikSU2Module`, `OstrikSU2Modules`, `IsOstrikSU2Module`,
  plus nimrep reporting and graph export helpers.
- Expanded test suite with module, grading, Ostrik, and tooling coverage.
- Expanded web documentation with full tutorials, API exactness, criteria
  examples, Ostrik/ADE narrative pages, and citation/contact information.

0.1.0 (2026-02-01)
------------------
- Initial MVP: core objects, constructors, normalization, checks, and three reps.
