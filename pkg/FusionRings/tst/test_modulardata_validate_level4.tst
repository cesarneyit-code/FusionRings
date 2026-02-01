# GAP test for ValidateModularData level 4 (balancing)

gap> START_TEST("FusionRings-modulardata-validate-level4");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

# Level 4 includes balancing equation

gap> v4 := ValidateModularData(md, 4);;

gap> v4.ok;
true

gap> STOP_TEST("FusionRings-modulardata-validate-level4");
