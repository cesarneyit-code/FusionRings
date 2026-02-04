# Quick API

## Constructors

- `ModularData(rec | S, T[, labels])`
- `ModularDataFromNsdRecord(rec)`
- `ModularDataFromST(S, T[, labels])`

## Validation and loaders

- `ValidateModularData(md[, level])`
- `LoadNsdGOL(rank)`
- `GetModularData(rank, iGO, iMD)`

## Bridges and Verlinde

- `FusionRingFromModularData(md)`
- `VerlindeModularData(type, rank, level)`
- `VerlindeModularDataByLieAlgebra(L, level)`
- `VerlindeModularDataByRootSystem(R, level)`

## Invertibles and subrings

- `IsInvertibleSimple(F, i)`
- `InvertibleSimples(F)`
- `IsPointedFusionRing(F)`
- `IsFusionSubring(F, subset)`
- `FusionSubring(F, subset)`
- `FusionSubringByGenerators(F, generators)`
- `FusionSubringLatticeSmall(F[, maxRank])`
- `CanonicalPointedSubring(F)`
- `AdjointSubring(F)`
- `IsIntegralFusionRing(F)`
- `IsWeaklyIntegralFusionRing(F)`

## FP dimensions

- `FPDimensionData(F)`
- `FPRank(F)` (and `Rank(F)` helper)
- `GlobalFPDimension(F)`
- `FPType(F)`
- `FPDimensions(F)` (exact algebraic values)
- `FPDimensionPolynomials(F)`
- `FormalCodegrees(F)`
- `FPDimensionPolynomial(F, i)`
- `FPDimensionApprox(F, i[, digits])`
- `FPDimensionsApprox(F[, digits])`
- `FPTypeApprox(F[, digits])`

## Paper criteria helpers (commutative case)

- `CheckDNumberCriterionCommutative(F)`
- `CheckDrinfeldCriterionCommutative(F)`
- `CheckExtendedCyclotomicCriterionCommutative(F)`
- `CheckPaperCriteriaCommutative(F)`

## Based modules over fusion rings

- `FusionModuleByActionMatrices(F, basisLabels, actionMatrices[, opts])`
- `UnderlyingFusionRing(M)`, `ModuleBasisLabels(M)`, `ModuleRank(M)`
- `ActionMatrices(M)`, `ActionMatrix(M, i)`, `ActionOnBasis(M, i, m)`
- `IsFusionSubmodule(M, subset)`, `FusionSubmodule(M, subset)`
- `FusionSubmoduleByGenerators(M, generators)`
- `FusionModuleComponents(M)`
- `IsIndecomposableFusionModule(M)`, `IsIrreducibleFusionModule(M)`
- `AreEquivalentFusionModules(M1, M2)`
- `FusionModuleGraph(M[, i])`

## Attributes

- `SMatrix(md)`, `TMatrix(md)`, `MDLabels(md)`
- `MDSpins(md)`, `MDTwists(md)`, `MDQuantumDimensions(md)`
- `MDGlobalDimensionSquared(md)`, `MDFusionCoefficients(md)`, `MDOrderT(md)`
