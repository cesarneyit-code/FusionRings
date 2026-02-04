SetPackageInfo( rec(
  PackageName := "FusionRings",
  Subtitle := "Fusion rings as GAP objects",
  Version := "0.2.0",
  Date := "2026-02-04",
  License := "GPL-2.0-or-later",
  Status := "dev",
  ArchiveURL := "https://github.com/cesarneyit-code/FusionRings/releases/download/v0.2.0/FusionRings-0.2.0",
  ArchiveFormats := ".tar.gz",
  README_URL := "https://github.com/cesarneyit-code/FusionRings/blob/main/README.md",
  PackageInfoURL := "https://raw.githubusercontent.com/cesarneyit-code/FusionRings/main/pkg/FusionRings/PackageInfo.g",
  AbstractHTML := "FusionRings provides GAP objects for fusion rings with multiple representations and validation tools.",
  PackageWWWHome := "https://cesarneyit-code.github.io/FusionRings/",
  Persons := [
    rec(
      LastName := "Galindo",
      FirstNames := "Cesar",
      IsAuthor := true,
      IsMaintainer := true,
      Email := "cn.galindo1116@uniandes.edu.co"
    )
  ],
  Dependencies := rec(
    GAP := "4.12",
    NeededOtherPackages := [ [ "GAPDoc", "1.6" ] ],
    SuggestedOtherPackages := [ ]
  ),
  PackageDoc := rec(
      BookName  := "FusionRings",
      LongTitle := "FusionRings: Fusion rings as GAP objects",
      SixFile   := "doc/manual.six",
      HTMLStart := "doc/chap0.html",
      PDFFile   := "doc/manual.pdf",
      ArchiveURLSubset := [ "doc" ]
  ),
  AvailabilityTest := ReturnTrue,
  TestFile := "tst/testall.g",
  Keywords := [ "fusion ring", "tensor category", "fusion" ]
) );
