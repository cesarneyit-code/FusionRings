# GAP test for FusionRingFromModularData

gap> START_TEST("FusionRings-modulardata-fusionring");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

gap> F := FusionRingFromModularData(md);;

gap> CheckFusionRingAxioms(F, 1);
true

gap> STOP_TEST("FusionRings-modulardata-fusionring");
