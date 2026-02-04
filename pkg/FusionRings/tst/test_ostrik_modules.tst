# GAP test for SU(2)_k Ostrik ADE module constructors

gap> START_TEST("FusionRings-ostrik-modules");

gap> MA4 := OstrikSU2Module(4, "A");;

gap> IsOstrikSU2Module(MA4, 4, "A");
true

gap> md4 := VerlindeModularData("A", 1, 4);;

gap> F4 := FusionRingFromModularData(md4);;

gap> LabelsList(UnderlyingFusionRing(MA4)) = LabelsList(F4);
true

gap> MD4 := OstrikSU2Module(4, "D");;

gap> IsOstrikSU2Module(MD4, 4, "D");
true

gap> mods4 := OstrikSU2Modules(4);;

gap> List(mods4, x -> x.type);
[ "A", "D" ]

gap> Length(ModuleBasisLabels(mods4[1].module));
5

gap> Length(ModuleBasisLabels(mods4[2].module));
4

gap> mods10 := OstrikSU2Modules(10);;

gap> List(mods10, x -> x.type);
[ "A", "D", "E6" ]

gap> IsOstrikSU2Module(mods10[3].module, 10, "E6");
true

gap> STOP_TEST("FusionRings-ostrik-modules");
