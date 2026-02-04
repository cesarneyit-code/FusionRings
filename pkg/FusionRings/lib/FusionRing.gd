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
DeclareOperation("IsInvertibleSimple", [ IsFusionRing, IsObject ]);
DeclareAttribute("InvertibleSimples", IsFusionRing);
DeclareProperty("IsPointedFusionRing", IsFusionRing);
DeclareOperation("IsFusionSubring", [ IsFusionRing, IsList ]);
DeclareOperation("FusionSubring", [ IsFusionRing, IsList ]);
DeclareAttribute("CanonicalPointedSubring", IsFusionRing);
DeclareAttribute("AdjointSubring", IsFusionRing);
DeclareAttribute("FPRank", IsFusionRing);
DeclareAttribute("GlobalFPDimension", IsFusionRing);
DeclareAttribute("FPType", IsFusionRing);
DeclareGlobalFunction("FPTypeApprox");
DeclareProperty("IsIntegralFusionRing", IsFusionRing);
DeclareProperty("IsWeaklyIntegralFusionRing", IsFusionRing);
DeclareAttribute("FormalCodegrees", IsFusionRing);
DeclareAttribute("FPDimensionData", IsFusionRing);
DeclareAttribute("FPDimensions", IsFusionRing);
DeclareAttribute("FPDimensionPolynomials", IsFusionRing);
DeclareOperation("FPDimensionPolynomial", [ IsFusionRing, IsObject ]);
DeclareOperation("FPDimensionApprox", [ IsFusionRing, IsObject ]);
DeclareOperation("FPDimensionApprox", [ IsFusionRing, IsObject, IsInt ]);
DeclareGlobalFunction("FPDimensionsApprox");

DeclareOperation("CheckFusionRingAxioms", [ IsFusionRing, IsInt ]);
DeclareGlobalFunction("CheckFusionRingAxiomsSample");

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
