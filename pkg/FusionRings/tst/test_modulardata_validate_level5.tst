# GAP test for ValidateModularData level 5 (FS indicators)

gap> START_TEST("FusionRings-modulardata-validate-level5");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

# Level 5 includes FS indicator checks

gap> v5 := ValidateModularData(md, 5);;

gap> v5.ok;
true

gap> STOP_TEST("FusionRings-modulardata-validate-level5");
