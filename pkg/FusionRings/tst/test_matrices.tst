# GAP test for FusionRings matrices representation

gap> START_TEST("FusionRings-matrices");
gap> labels := [ "1", "x" ];;
gap> N1 := [ [ 1, 0 ], [ 0, 1 ] ];;
gap> Nx := [ [ 0, 1 ], [ 1, 0 ] ];;
gap> F := FusionRingByFusionMatrices(labels, "1", [ "1", "x" ], [ N1, Nx ], rec(check := 1));;
gap> MultiplyBasis(F, "x", "x");
[ [ "1", 1 ] ]
gap> FusionCoefficient(F, "x", "1", "x");
1
gap> CheckFusionRingAxioms(F, 1);
true
gap> STOP_TEST("FusionRings-matrices");
