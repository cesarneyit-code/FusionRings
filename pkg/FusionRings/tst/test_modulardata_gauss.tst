# GAP test for ModularData Gauss sums and modular equation

gap> START_TEST("FusionRings-modulardata-gauss");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

# extract data

gap> S := SMatrix(md);;

gap> T := TMatrix(md);;

# compute d and D^2 from S

gap> d := List([1..Length(S)], i -> S[1][i]);;

gap> D2 := Sum(d, x -> x^2);;

# Gauss sums

gap> pplus := Sum([1..Length(d)], i -> d[i]^2 * T[i][i]);;

gap> pminus := Sum([1..Length(d)], i -> d[i]^2 / T[i][i]);;

# modular equation (ST)^3 = p_+ S^2

gap> lhs := (S * T)^3;;

gap> rhs := pplus * (S^2);;

# checks

gap> pplus * pminus = D2;
true

gap> lhs = rhs;
true

gap> STOP_TEST("FusionRings-modulardata-gauss");
