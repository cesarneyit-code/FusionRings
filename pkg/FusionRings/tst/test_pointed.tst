# GAP test for FusionRings pointed fusion ring

gap> START_TEST("FusionRings-pointed");
gap> G := Group((1,2,3));;
gap> F := PointedFusionRing(G);;
gap> MultiplyBasis(F, (1,2,3), (1,2,3));
[ [ (1,3,2), 1 ] ]
gap> DualLabel(F, (1,2,3));
(1,3,2)
gap> CheckFusionRingAxioms(F, 1);
true
gap> STOP_TEST("FusionRings-pointed");
