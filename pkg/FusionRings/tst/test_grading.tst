# GAP test for universal grading APIs

gap> START_TEST("FusionRings-grading");

gap> Ffib := FibonacciFusionRing();;

gap> UniversalGradingOrder(Ffib);
1

gap> UniversalGradingData(Ffib).isGroup;
true

gap> Fi := IsingFusionRing();;

gap> UniversalGradingOrder(Fi);
2

gap> UniversalGradingComponent(Fi, "1");
1

gap> UniversalGradingComponent(Fi, "psi");
1

gap> UniversalGradingComponent(Fi, "sigma");
2

gap> dataI := UniversalGradingData(Fi);;

gap> dataI.multiplication;
[ [ 1, 2 ], [ 2, 1 ] ]

gap> F4 := CyclicPointedFusionRing(4);;

gap> UniversalGradingOrder(F4);
4

gap> data4 := UniversalGradingData(F4);;

gap> data4.one;
1

gap> data4.isGroup;
true

gap> STOP_TEST("FusionRings-grading");
