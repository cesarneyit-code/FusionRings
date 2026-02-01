# GAP test for FusionRings export/import (matrices)

gap> d := DirectoryTemporary();; IsDirectory(d);
true
gap> f := Filename(d, "frm.g");; IsString(f);
true

gap> labels := [ "1", "x" ];;
gap> N1 := [ [ 1, 0 ], [ 0, 1 ] ];;
gap> Nx := [ [ 0, 1 ], [ 1, 0 ] ];;
gap> F := FusionRingByFusionMatrices(labels, "1", [ "1", "x" ], [ N1, Nx ], rec(check := 0));;
gap> SaveFusionRing(f, F);
true
gap> F2 := LoadFusionRing(f);;
gap> MultiplyBasis(F2, "x", "x");
[ [ "1", 1 ] ]
