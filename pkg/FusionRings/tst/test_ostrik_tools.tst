# GAP test for Ostrik ADE helper/report utilities

gap> START_TEST("FusionRings-ostrik-tools");

gap> mods4 := OstrikSU2Modules(4);;

gap> MA := mods4[1].module;;

gap> nim := NimrepFromModule(MA);;

gap> Length(nim.adjacency);
5

gap> cox := CoxeterNumberFromAdjacencyApprox(nim.adjacency);;

gap> cox.ok;
true

gap> cox.hApprox;
6

gap> IsADELevelCompatible(10, "E6");
true

gap> IsADELevelCompatible(11, "E6");
false

gap> chk := CheckOstrikADEData(4, "D", 4);;

gap> chk.ok;
true

gap> dot := FusionModuleGraphDOT(MA, LabelOfPosition(UnderlyingFusionRing(MA), 2));;

gap> PositionSublist(dot, "digraph Nimrep") <> fail;
true

gap> rep := OstrikReport(10);;

gap> List(rep.modules, x -> x.type);
[ "A", "D", "E6" ]

gap> ForAll(rep.modules, x -> x.coxeter.ok);
true

gap> STOP_TEST("FusionRings-ostrik-tools");
