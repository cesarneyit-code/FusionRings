# GAP test for ValidateModularData

gap> START_TEST("FusionRings-modulardata-validate");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

gap> v1 := ValidateModularData(md, 1);;

gap> v1.ok;
true

gap> v2 := ValidateModularData(md, 2);;

gap> v2.ok;
true

gap> v3 := ValidateModularData(md, 3);;

gap> v3.ok;
true

gap> STOP_TEST("FusionRings-modulardata-validate");
