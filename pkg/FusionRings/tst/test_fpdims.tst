# GAP test for Perron-Frobenius dimensions and polynomials

gap> START_TEST("FusionRings-fpdims");

gap> F := FibonacciFusionRing();;

gap> p := FPDimensionPolynomial(F, "x");;

gap> CoefficientsOfUnivariatePolynomial(p);
[ -1, -1, 1 ]

gap> a := FPDimensionApprox(F, "x");;

gap> a > 1.61 and a < 1.62;
true

gap> FPDimensionsApprox(F, 3);
[ 1., 1.618 ]

gap> Fc3 := CyclicPointedFusionRing(3);;

gap> ForAll(FPDimensionPolynomials(Fc3), q -> DegreeOfLaurentPolynomial(q) = 1);
true

gap> ForAll(FPDimensions(Fc3), d -> d = 1);
true

gap> Fi := IsingFusionRing();;

gap> CoefficientsOfUnivariatePolynomial(FPDimensionPolynomial(Fi, "sigma"));
[ -2, 0, 1 ]

gap> FPDimensionApprox(Fi, "sigma", 3);
1.414

gap> STOP_TEST("FusionRings-fpdims");
