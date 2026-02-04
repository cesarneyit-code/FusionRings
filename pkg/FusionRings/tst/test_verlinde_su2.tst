# GAP test for Verlinde SU(2)_k modular data

gap> START_TEST("FusionRings-verlinde-su2");

gap> for k in [1..5] do
>   md := VerlindeModularData("A", 1, k);;
>   v4 := ValidateModularData(md, 4);;
>   if not v4.ok then
>     Error(Concatenation("SU(2) level ", String(k), " failed: ", String(v4.failures)));
>   fi;
>   F := FusionRingFromModularData(md);;
>   if not CheckFusionRingAxioms(F, 1) then
>     Error(Concatenation("SU(2) level ", String(k), " fusion ring bridge failed"));
>   fi;
> od;

gap> STOP_TEST("FusionRings-verlinde-su2");
