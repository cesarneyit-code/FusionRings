# GAP test for ModularData Verlinde consistency

gap> START_TEST("FusionRings-modulardata-verlinde");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

gap> S := SMatrix(md);;

gap> D2 := MDGlobalDimensionSquared(md);;

gap> r := Length(S);;

gap> N := mdrec.Nij_k;;

gap> verlinde := function(i,j,k)
>   local a, sum;
>   sum := 0;
>   for a in [1..r] do
>     sum := sum + S[i][a] * S[j][a] * S[k][a] / S[1][a];
>   od;
>   return sum / D2;
> end;;

gap> ok := true;;

gap> for i in [1..r] do
>   for j in [1..r] do
>     for k in [1..r] do
>       if verlinde(i,j,k) <> N[i][j][k] then
>         ok := false;
>       fi;
>     od;
>   od;
> od;

gap> ok;
true

gap> STOP_TEST("FusionRings-modulardata-verlinde");
