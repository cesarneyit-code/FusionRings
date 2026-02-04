# GAP test for commutative paper-style criteria helpers

gap> START_TEST("FusionRings-paper-criteria");

gap> M := [
>   [ [1,0,0,0],[0,1,0,0],[0,0,1,0],[0,0,0,1] ],
>   [ [0,1,0,0],[0,0,1,0],[1,0,0,0],[0,0,0,1] ],
>   [ [0,0,1,0],[1,0,0,0],[0,1,0,0],[0,0,0,1] ],
>   [ [0,0,0,1],[0,0,0,1],[0,0,0,1],[1,1,1,1] ]
> ];;

gap> F := FusionRingByFusionMatrices([1..4], 1, fail, M, rec(inferDual := true, check := 0));;

gap> dres := CheckDNumberCriterionCommutative(F);;

gap> dres.ok;
false

gap> PositionSublist(dres.failures[1], "fails d-number") <> fail;
true

gap> dr := CheckDrinfeldCriterionCommutative(F);;

gap> dr.applicable;
false

gap> cy := CheckExtendedCyclotomicCriterionCommutative(F);;

gap> cy.applicable;
false

gap> all := CheckPaperCriteriaCommutative(F);;

gap> IsRecord(all) and IsBound(all.dNumber) and IsBound(all.drinfeld) and IsBound(all.cyclotomic);
true

gap> STOP_TEST("FusionRings-paper-criteria");
