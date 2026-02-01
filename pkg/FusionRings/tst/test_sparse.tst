# GAP test for FusionRings sparse representation

gap> START_TEST("FusionRings-sparse");
gap> labels := [ "1", "x" ];;
gap> prodTable := [
>   [ "1", "1", [ [ "1", 1 ] ] ],
>   [ "1", "x", [ [ "x", 1 ] ] ],
>   [ "x", "1", [ [ "x", 1 ] ] ],
>   [ "x", "x", [ [ "1", 1 ] ] ]
> ];;
gap> F := FusionRingBySparseConstants(labels, "1", [ "1", "x" ], prodTable, rec(check := 1));;
gap> MultiplyBasis(F, "x", "x");
[ [ "1", 1 ] ]
gap> DualLabel(F, "x");
"x"
gap> CheckFusionRingAxioms(F, 1);
true
gap> STOP_TEST("FusionRings-sparse");
