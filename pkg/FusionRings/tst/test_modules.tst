# GAP test for based-module (fusion-module) APIs

gap> START_TEST("FusionRings-modules");

gap> F2 := CyclicPointedFusionRing(2);;

gap> A1 := [ [1,0],[0,1] ];;

gap> Aswap := [ [0,1],[1,0] ];;

gap> Afix := [ [1,0],[0,1] ];;

gap> M := FusionModuleByActionMatrices(F2, [ "a", "b" ], [ A1, Aswap ]);;

gap> ModuleRank(M);
2

gap> ActionOnBasis(M, LabelOfPosition(F2, 2), "a");
[ [ "b", 1 ] ]

gap> IsIrreducibleFusionModule(M);
true

gap> IsIndecomposableFusionModule(M);
true

gap> N := FusionModuleByActionMatrices(F2, [ "u", "v" ], [ A1, Aswap ]);;

gap> AreEquivalentFusionModules(M, N);
true

gap> D := FusionModuleByActionMatrices(F2, [ "m1", "m2" ], [ A1, Afix ]);;

gap> IsIrreducibleFusionModule(D);
false

gap> IsIndecomposableFusionModule(D);
false

gap> FusionModuleComponents(D);
[ [ "m1" ], [ "m2" ] ]

gap> IsFusionSubmodule(D, [ "m1" ]);
true

gap> SD := FusionSubmoduleByGenerators(D, [ "m1" ]);;

gap> ModuleBasisLabels(SD);
[ "m1" ]

gap> STOP_TEST("FusionRings-modules");
