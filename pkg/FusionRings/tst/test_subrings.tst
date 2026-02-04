# GAP test for invertibles, pointed rings, and fusion subrings

gap> START_TEST("FusionRings-subrings");

gap> Fi := IsingFusionRing();;

gap> IsInvertibleSimple(Fi, "1");
true

gap> IsInvertibleSimple(Fi, "psi");
true

gap> IsInvertibleSimple(Fi, "sigma");
false

gap> InvertibleSimples(Fi);
[ "1", "psi" ]

gap> IsPointedFusionRing(Fi);
false

gap> IsFusionSubring(Fi, [ "1", "psi" ]);
true

gap> IsFusionSubring(Fi, [ "1", "sigma" ]);
false

gap> PFi := CanonicalPointedSubring(Fi);;

gap> BasisLabels(PFi);
[ "1", "psi" ]

gap> IsPointedFusionRing(PFi);
true

gap> F4 := CyclicPointedFusionRing(4);;

gap> IsPointedFusionRing(F4);
true

gap> Length(InvertibleSimples(F4)) = Length(LabelsList(F4));
true

gap> A := CyclicGroup(3);;

gap> Fty := TambaraYamagamiFusionRing(A);;

gap> invTY := InvertibleSimples(Fty);;

gap> Length(invTY);
3

gap> IsFusionSubring(Fty, invTY);
true

gap> IsPointedFusionRing(CanonicalPointedSubring(Fty));
true

gap> STOP_TEST("FusionRings-subrings");
