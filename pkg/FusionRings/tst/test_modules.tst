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

gap> Gact := FusionModuleGraph(M, LabelOfPosition(F2, 2));;

gap> Gact.mode;
"action-directed"

gap> Gact.edges;
[ [ "a", "b", 1 ], [ "b", "a", 1 ] ]

gap> Gcomb := FusionModuleGraph(D);;

gap> Gcomb.mode;
"combined-undirected"

gap> Gcomb.edges;
[ [ "m1", "m1", 2 ], [ "m2", "m2", 2 ] ]

gap> Fi := IsingFusionRing();;

gap> CM := CanonicalFusionModule(Fi);;

gap> ModuleBasisLabels(CM) = LabelsList(Fi);
true

gap> ActionOnBasis(CM, "sigma", "sigma");
[ [ "1", 1 ], [ "psi", 1 ] ]

gap> Sobj := FusionSubmoduleByObject(Fi, "sigma");;

gap> ModuleBasisLabels(Sobj);
[ "1", "psi", "sigma" ]

gap> STOP_TEST("FusionRings-modules");
