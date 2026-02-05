if LoadPackage("FusionRings") <> true then
  Error("FusionRings package not found on GAP package path");
fi;
FusionRings_TestAllStrict();
