# GAP test for ValidateModularData level 6 (partial Galois/field checks)

gap> START_TEST("FusionRings-modulardata-validate-level6");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

# Level 6 includes partial field/Galois checks

gap> v6 := ValidateModularData(md, 6);;

gap> v6.ok;
true

gap> STOP_TEST("FusionRings-modulardata-validate-level6");
