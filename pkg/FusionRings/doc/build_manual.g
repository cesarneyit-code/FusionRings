# Robust manual build script (package load)
if LoadPackage("FusionRings") <> true then
  Error("FusionRings package not found on GAP package path");
fi;
pkginfo := PackageInfo("FusionRings");
if pkginfo = fail or Length(pkginfo) = 0 then
  Error("FusionRings package info not found");
fi;
ChangeDirectoryCurrent(pkginfo[1].InstallationPath);
ReadPackage("FusionRings", "doc/makedocrel.g");
