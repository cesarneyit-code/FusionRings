DeclareCategory("IsFusionRing", IsObject);

DeclareRepresentation("IsFusionRingByRuleRep",
  IsFusionRing and IsComponentObjectRep,
  [ "I", "one", "dual", "mult" ]);

DeclareRepresentation("IsFusionRingBySparseRep",
  IsFusionRing and IsComponentObjectRep,
  [ "I", "one", "dual", "prodTable" ]);

DeclareRepresentation("IsFusionRingByMatricesRep",
  IsFusionRing and IsComponentObjectRep,
  [ "I", "one", "dual", "fusionMatrices" ]);

DeclareInfoClass("InfoFusionRings");

DeclareAttribute("BasisLabels", IsFusionRing);
DeclareAttribute("OneLabel", IsFusionRing);
DeclareAttribute("DualData", IsFusionRing);
DeclareAttribute("RepresentationType", IsFusionRing);

DeclareAttribute("LabelsList", IsFusionRing);
DeclareOperation("PositionOfLabel", [ IsFusionRing, IsObject ]);
DeclareOperation("LabelOfPosition", [ IsFusionRing, IsInt ]);

DeclareOperation("DualLabel", [ IsFusionRing, IsObject ]);
DeclareAttribute("DualTable", IsFusionRing);

DeclareOperation("MultiplyBasis", [ IsFusionRing, IsObject, IsObject ]);
DeclareOperation("FusionCoefficient", [ IsFusionRing, IsObject, IsObject, IsObject ]);
DeclareGlobalFunction("NormalizeProductList");

DeclareOperation("FusionMatrix", [ IsFusionRing, IsObject ]);
DeclareAttribute("FusionMatrices", IsFusionRing);

DeclareOperation("CheckFusionRingAxioms", [ IsFusionRing, IsInt ]);

DeclareGlobalFunction("FusionRing");
DeclareGlobalFunction("FusionRingByRule");
DeclareGlobalFunction("FusionRingBySparseConstants");
DeclareGlobalFunction("FusionRingByFusionMatrices");
DeclareGlobalFunction("PointedFusionRing");
DeclareGlobalFunction("CyclicPointedFusionRing");
DeclareGlobalFunction("FibonacciFusionRing");
DeclareGlobalFunction("IsingFusionRing");
DeclareGlobalFunction("TambaraYamagamiFusionRing");
DeclareGlobalFunction("NearGroupFusionRing");
DeclareAttribute("TYMLabel", IsFusionRing);
DeclareAttribute("NGRhoLabel", IsFusionRing);
DeclareGlobalFunction("FusionRingRecord");
DeclareGlobalFunction("FusionRingFromRecord");
DeclareGlobalFunction("SaveFusionRing");
DeclareGlobalFunction("LoadFusionRing");
