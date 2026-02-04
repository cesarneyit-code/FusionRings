# GAP test for FP helpers, weak/integral checks, adjoint subring, and formal codegrees

gap> START_TEST("FusionRings-fphelpers");

gap> Ff := FibonacciFusionRing();;

gap> FPRank(Ff);
2

gap> Rank(Ff);
2

gap> gf := GlobalFPDimension(Ff);;

gap> sf := Sum(FPDimensionData(Ff), x -> x.approx^2);;

gap> sf > 3.618 and sf < 3.619;
true

gap> IsIntegralFusionRing(Ff);
false

gap> IsWeaklyIntegralFusionRing(Ff);
false

gap> FPTypeApprox(Ff, 3);
[ 1., 1.618 ]

gap> Fi := IsingFusionRing();;

gap> gi := GlobalFPDimension(Fi);;

gap> IsIntegralFusionRing(Fi);
false

gap> IsWeaklyIntegralFusionRing(Fi);
true

gap> si := Sum(FPDimensionData(Fi), x -> x.approx^2);;

gap> si > 3.999 and si < 4.001;
true

gap> Ai := AdjointSubring(Fi);;

gap> BasisLabels(Ai);
[ "1", "psi" ]

gap> IsPointedFusionRing(Ai);
true

gap> F4 := CyclicPointedFusionRing(4);;

gap> IsIntegralFusionRing(F4);
true

gap> IsWeaklyIntegralFusionRing(F4);
true

gap> fc := FormalCodegrees(F4);;

gap> Length(fc);
1

gap> ForAll(fc, x -> IsRecord(x) and IsBound(x.value) and IsBound(x.polynomial) and IsBound(x.multiplicity));
true

gap> Sum(fc, x -> DegreeOfLaurentPolynomial(x.polynomial) * x.multiplicity) = FPRank(F4);
true

gap> STOP_TEST("FusionRings-fphelpers");
