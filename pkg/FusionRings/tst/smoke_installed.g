if LoadPackage("FusionRings") = fail then
  Error("Failed to load FusionRings in installed-package mode");
fi;

F := FibonacciFusionRing();;
if not CheckFusionRingAxioms(F, 1) then
  Error("Fusion-ring smoke check failed");
fi;

md := GetModularData(2, 1, 1);;
if not ValidateModularData(md, 3).ok then
  Error("ModularData smoke check failed");
fi;

Fm := FusionRingFromModularData(md);;
if not CheckFusionRingAxioms(Fm, 1) then
  Error("Fusion ring bridge smoke check failed");
fi;

mods := OstrikSU2Modules(4);;
if Length(mods) < 2 then
  Error("Ostrik module smoke check failed");
fi;

Print("FusionRings installed-mode smoke: OK\n");
