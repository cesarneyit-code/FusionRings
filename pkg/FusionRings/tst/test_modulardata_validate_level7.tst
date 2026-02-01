# GAP test for ValidateModularData level 7 (Cauchy primes)

gap> START_TEST("FusionRings-modulardata-validate-level7");

gap> Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/data/modular_data/NsdGOL2.g");

gap> mdrec := NsdGOL[1][1];;

gap> md := ModularDataFromNsdRecord(mdrec);;

# Level 7 includes Cauchy primes

gap> v7 := ValidateModularData(md, 7);;

gap> v7.ok;
true

gap> STOP_TEST("FusionRings-modulardata-validate-level7");
