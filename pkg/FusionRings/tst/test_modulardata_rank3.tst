# GAP regression test for rank-3 modular data

gap> START_TEST("FusionRings-modulardata-rank3");

gap> md := GetModularData(3, 2, 1);;

gap> v := ValidateModularData(md, 4);;

gap> v.ok;
true

gap> F := FusionRingFromModularData(md);;

gap> CheckFusionRingAxioms(F, 1);
true

gap> STOP_TEST("FusionRings-modulardata-rank3");
