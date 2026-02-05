InstallGlobalFunction(FusionRings_TestAll, function()
  local dirs;
  dirs := DirectoriesPackageLibrary("FusionRings", "tst");
  return TestDirectory(
    dirs,
    rec(exitGAP := false, testOptions := rec(compareFunction := "uptowhitespace"))
  );
end );

InstallGlobalFunction(FusionRings_TestAllStrict, function()
  local dirs;
  dirs := DirectoriesPackageLibrary("FusionRings", "tst");
  return TestDirectory(
    dirs,
    rec(exitGAP := false, testOptions := rec(compareFunction := "uptonl"))
  );
end );

InstallGlobalFunction(FusionRings_RewriteTests, function()
  local dirs;
  dirs := DirectoriesPackageLibrary("FusionRings", "tst");
  return TestDirectory(
    dirs,
    rec(exitGAP := false, rewriteToFile := true)
  );
end );

InstallGlobalFunction(FusionRings_CI, function()
  FusionRings_TestAllStrict();
  ReadPackage("FusionRings", "doc/build_manual.g");
end );
