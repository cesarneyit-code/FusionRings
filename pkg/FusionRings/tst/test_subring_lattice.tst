# GAP test for subring generators and small lattice enumeration

gap> START_TEST("FusionRings-subring-lattice");

gap> Fi := IsingFusionRing();;

gap> G := FusionSubringByGenerators(Fi, [ "sigma" ]);;

gap> LabelsList(G);
[ "1", "psi", "sigma" ]

gap> P := FusionSubringByGenerators(Fi, [ "psi" ]);;

gap> LabelsList(P);
[ "1", "psi" ]

gap> lat := FusionSubringLatticeSmall(Fi, 6);;

gap> Length(lat);
3

gap> lat[1];
[ "1" ]

gap> lat[2];
[ "1", "psi" ]

gap> lat[3];
[ "1", "psi", "sigma" ]

gap> STOP_TEST("FusionRings-subring-lattice");
