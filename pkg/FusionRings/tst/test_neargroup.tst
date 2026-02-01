# GAP test for FusionRings near-group rings

gap> G := CyclicGroup(2);;
gap> F := NearGroupFusionRing(G, 0);;
gap> rho := NGRhoLabel(F);;
gap> glist := AsSortedList(G);;
gap> ForAny(glist, g -> FusionCoefficient(F, rho, rho, g) <> 1);
false
gap> FusionCoefficient(F, (1,2), rho, rho) = 1;
true
gap> G := CyclicGroup(3);;
gap> F := NearGroupFusionRing(G, 1);;
gap> rho := NGRhoLabel(F);;
gap> glist := AsSortedList(G);;
gap> ForAny(glist, g -> FusionCoefficient(F, rho, rho, g) <> 1);
false
gap> FusionCoefficient(F, rho, rho, rho) = 1;
true
gap> DualLabel(F, rho) = rho;
true
gap> CheckFusionRingAxioms(F, 1);
true
