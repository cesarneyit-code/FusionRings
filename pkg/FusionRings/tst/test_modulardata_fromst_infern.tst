# GAP test for ModularDataFromST completion and N inference

gap> START_TEST("FusionRings-modulardata-fromst-infern");

gap> md0 := GetModularData(2, 1, 1);;

gap> S := SMatrix(md0);;

gap> T := TMatrix(md0);;

gap> md := ModularDataFromST(S, T, [1,2], rec(inferN := true, completeData := true));;

gap> MDFusionCoefficients(md) = fail;
false

gap> MDQuantumDimensions(md);
[ 1, 1 ]

gap> MDOrderT(md);
4

gap> ValidateModularData(md, 3).ok;
true

gap> F := FusionRingFromModularData(md);;

gap> CheckFusionRingAxioms(F, 1);
true

gap> STOP_TEST("FusionRings-modulardata-fromst-infern");
