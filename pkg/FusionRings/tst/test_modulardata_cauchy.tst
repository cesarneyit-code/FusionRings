# GAP test for Cauchy primes condition (rank-2 example)

gap> START_TEST("FusionRings-modulardata-cauchy");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

# D^2 and ord(T)

gap> D2 := MDGlobalDimensionSquared(md);;

gap> N := MDOrderT(md);;

# For this test we expect D2 rational integer

gap> IsRat(D2);
true

gap> primesD := Set(FactorsInt(AbsInt(NumeratorRat(D2))));;

gap> primesN := Set(FactorsInt(N));;

# Cauchy condition: prime divisors coincide

gap> primesD = primesN;
true

gap> STOP_TEST("FusionRings-modulardata-cauchy");
