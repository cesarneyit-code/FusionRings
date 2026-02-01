# GAP test for ModularData basic construction from NsdGOL

gap> START_TEST("FusionRings-modulardata-basic");

# Load rank-2 database file

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

# Pick first entry of first Galois orbit

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

gap> Length(MDQuantumDimensions(md));
2

# S is symmetric and normalized

gap> S := SMatrix(md);;

gap> S = TransposedMat(S);
true

gap> D2 := MDGlobalDimensionSquared(md);;

gap> S * TransposedMat(S) = D2 * IdentityMat(Length(S));
true

# T is diagonal with expected order

gap> T := TMatrix(md);;

gap> IsDiagonalMat(T);
true

gap> MDOrderT(md);
4

gap> STOP_TEST("FusionRings-modulardata-basic");
