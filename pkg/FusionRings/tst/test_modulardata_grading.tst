# GAP test for modular-data universal grading helpers

gap> START_TEST("FusionRings-modulardata-grading");

gap> md := GetModularData(2, 1, 1);;

gap> ug := UniversalGradingFromModularData(md);;

gap> IsRecord(ug) and IsBound(ug.components) and IsBound(ug.multiplication);
true

gap> chk := CheckUniversalGradingEqualsInvertibles(md);;

gap> chk.applicable;
true

gap> chk.ok;
true

gap> mdv := ModularDataFromST(SMatrix(md), TMatrix(md), [1,2], rec(inferN := false, completeData := true));;

gap> chk2 := CheckUniversalGradingEqualsInvertibles(mdv);;

gap> chk2.applicable;
false

gap> STOP_TEST("FusionRings-modulardata-grading");
