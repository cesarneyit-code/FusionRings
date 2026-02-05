if LoadPackage("FusionRings") <> true then
  Error("FusionRings package not found on GAP package path");
fi;
FusionRings_TestAllStrict();
ReadPackage("FusionRings", "doc/build_manual.g");
