# GAP test for FusionRings export/import

gap> d := DirectoryTemporary();; IsDirectory(d);
true
gap> f := Filename(d, "fr.g");; IsString(f);
true
gap> labels := [ "1", "x" ];;
gap> prodTable := [
>   [ "1", "1", [ [ "1", 1 ] ] ],
>   [ "1", "x", [ [ "x", 1 ] ] ],
>   [ "x", "1", [ [ "x", 1 ] ] ],
>   [ "x", "x", [ [ "1", 1 ] ] ]
> ];;
gap> F := FusionRingBySparseConstants(labels, "1", [ "1", "x" ], prodTable, rec(check := 0));;
gap> SaveFusionRing(f, F);
true
gap> F2 := LoadFusionRing(f);;
gap> MultiplyBasis(F2, "x", "x");
[ [ "1", 1 ] ]
