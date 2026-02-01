# GAP regression test for rank-4 modular data

gap> START_TEST("FusionRings-modulardata-rank4");

gap> md := GetModularData(4, 1, 1);;

gap> v := ValidateModularData(md, 4);;

gap> v.ok;
true

gap> F := FusionRingFromModularData(md);;

gap> CheckFusionRingAxioms(F, 1);
true

gap> STOP_TEST("FusionRings-modulardata-rank4");
