# GAP test for FusionRings families

gap> F := FibonacciFusionRing();;
gap> MultiplyBasis(F, "x", "x") = [ [ "1", 1 ], [ "x", 1 ] ];
true
gap> F := Rank2FusionRing(1);;
gap> MultiplyBasis(F, "tau", "tau") = [ [ "1", 1 ], [ "tau", 1 ] ];
true
gap> F := Rank2FusionRing(0);;
gap> CheckFusionRingAxioms(F, 1);
true
gap> F := Rank3FusionRing(0, 1, 0, 0);;
gap> MultiplyBasis(F, "X", "X") = [ [ "1", 1 ] ];
true
gap> MultiplyBasis(F, "Y", "Y") = [ [ "1", 1 ], [ "X", 1 ] ];
true
gap> MultiplyBasis(F, "X", "Y") = [ [ "Y", 1 ] ];
true
gap> CheckFusionRingAxioms(F, 1);
true
gap> F := IsingFusionRing();;
gap> MultiplyBasis(F, "sigma", "sigma") = [ [ "1", 1 ], [ "psi", 1 ] ];
true
gap> F := CyclicPointedFusionRing(4);;
gap> CheckFusionRingAxioms(F, 1);
true
gap> A := CyclicGroup(3);;
gap> F := TambaraYamagamiFusionRing(A);;
gap> m := TYMLabel(F);; m <> fail;
true
gap> Length(MultiplyBasis(F, m, m)) = 3;
true
gap> CheckFusionRingAxioms(F, 1);
true
