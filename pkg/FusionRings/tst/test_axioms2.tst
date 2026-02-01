# GAP test for FusionRings level-2 axioms on small examples

gap> START_TEST("FusionRings-axioms2");
gap> G := Group((1,2));;
gap> F := PointedFusionRing(G);;
gap> CheckFusionRingAxioms(F, 2);
true
gap> labels := [ "1", "x" ];;
gap> N1 := [ [ 1, 0 ], [ 0, 1 ] ];;
gap> Nx := [ [ 0, 1 ], [ 1, 0 ] ];;
gap> F2 := FusionRingByFusionMatrices(labels, "1", [ "1", "x" ], [ N1, Nx ], rec(check := 0));;
gap> CheckFusionRingAxioms(F2, 2);
true
gap> STOP_TEST("FusionRings-axioms2");
