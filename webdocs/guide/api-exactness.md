# API Exactness (Exact vs Heuristic)

This table summarizes which outputs are exact algebraic data and which are
numeric helpers meant for inspection.

| API | Status | Notes |
|---|---|---|
| `FPDimensions(F)` | exact | Algebraic values (or rational) per simple object. |
| `FPDimensionPolynomial(F,i)` | exact | Polynomial associated to FP dimension of `i`. |
| `FPDimensionPolynomials(F)` | exact | Per-simple polynomial list. |
| `GlobalFPDimension(F)` | exact | Sum of squares of exact FP dimensions. |
| `FPType(F)` | exact | Exact FP dimensions sorted by approximate size. |
| `FormalCodegrees(F)` | exact/partial | Exact value + polynomial + multiplicity; ordering uses approximate values. |
| `FPDimensionApprox(F,i[,digits])` | heuristic view | Decimal display helper. |
| `FPDimensionsApprox(F[,digits])` | heuristic view | Decimal display helper. |
| `FPTypeApprox(F[,digits])` | heuristic view | Decimal display helper. |
| `IsIntegralFusionRing(F)` | exact criterion | Checks all FP dimensions are integers. |
| `IsWeaklyIntegralFusionRing(F)` | numeric check | Uses decimal tolerance on global FP dimension. |
| `IsInvertibleSimple(F,i)` | exact combinatorial | Checks fusion matrix is a permutation matrix. |
| `IsFusionSubring(F,S)` | exact combinatorial | Closure under unit, dual, multiplication support. |

## Quick recommendations

- Use exact APIs for all symbolic/math pipelines.
- Use `*Approx` APIs only for readability in logs/notes.
- For weak integrality, treat current result as practical; if you need a strict
  proof-level check, add an exact arithmetic variant.
