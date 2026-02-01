# GAP test for ModularData Frobenius–Schur indicators (n=2)

gap> START_TEST("FusionRings-modulardata-fs");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

gap> N := mdrec.Nij_k;;

gap> S := SMatrix(md);;

gap> T := TMatrix(md);;

gap> d := List([1..Length(S)], i -> S[1][i]);;

gap> D2 := Sum(d, x -> x^2);;

gap> r := Length(d);;

gap> theta := List([1..r], i -> T[i][i]);;

# build duals from N^{1}_{i, i*} = 1

gap> dual := List([1..r], i -> fail);;

gap> for i in [1..r] do
>   for j in [1..r] do
>     if N[i][j][1] = 1 then
>       dual[i] := j;
>       break;
>     fi;
>   od;
> od;

# FS indicator for n=2

gap> nu2 := function(k)
>   local i, j, sum;
>   sum := 0;
>   for i in [1..r] do
>     for j in [1..r] do
>       if N[i][j][k] <> 0 then
>         sum := sum + N[i][j][k] * d[i] * d[j] * (theta[i]/theta[j])^2;
>       fi;
>     od;
>   od;
>   return sum / D2;
> end;;

gap> ok := true;;

gap> for k in [1..r] do
>   if k <> dual[k] then
>     if nu2(k) <> 0 then ok := false; fi;
>   else
>     if not (nu2(k) = 1 or nu2(k) = -1) then ok := false; fi;
>   fi;
> od;

gap> ok;
true

gap> STOP_TEST("FusionRings-modulardata-fs");
