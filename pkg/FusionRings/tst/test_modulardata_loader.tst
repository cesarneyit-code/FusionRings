# GAP test for NsdGOL loader helpers

gap> START_TEST("FusionRings-modulardata-loader");

gap> LoadNsdGOL(2);
true

gap> md := GetModularData(2, 1, 1);;

gap> Length(MDQuantumDimensions(md));
2

gap> STOP_TEST("FusionRings-modulardata-loader");
