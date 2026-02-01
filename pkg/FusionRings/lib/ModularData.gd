DeclareCategory("IsModularData", IsObject);

DeclareRepresentation("IsModularDataRep",
  IsModularData and IsComponentObjectRep,
  [ "S", "T", "labels", "N", "d", "s", "theta", "D2", "ordT" ]);

DeclareAttribute("SMatrix", IsModularData);
DeclareAttribute("TMatrix", IsModularData);
DeclareAttribute("MDLabels", IsModularData);
DeclareAttribute("MDTwists", IsModularData);
DeclareAttribute("MDSpins", IsModularData);
DeclareAttribute("MDQuantumDimensions", IsModularData);
DeclareAttribute("MDGlobalDimensionSquared", IsModularData);
DeclareAttribute("MDFusionCoefficients", IsModularData);
DeclareAttribute("MDOrderT", IsModularData);

DeclareGlobalFunction("ModularData");
DeclareGlobalFunction("ModularDataFromST");
DeclareGlobalFunction("ModularDataFromNsdRecord");
DeclareGlobalFunction("ValidateModularData");
DeclareGlobalFunction("LoadNsdGOL");
DeclareGlobalFunction("GetModularData");
DeclareGlobalFunction("FusionRingFromModularData");
DeclareGlobalFunction("VerlindeModularData");
DeclareGlobalFunction("VerlindeModularDataByLieAlgebra");
DeclareGlobalFunction("VerlindeModularDataByRootSystem");
