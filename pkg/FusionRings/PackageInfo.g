SetPackageInfo( rec(
  PackageName := "FusionRings",
  Subtitle := "Fusion rings as GAP objects",
  Version := "0.1.0",
  Date := "2026-02-01",
  License := "GPL-2.0-or-later",
  Status := "dev",
  ArchiveURL := "https://example.com/FusionRings/FusionRings",
  ArchiveFormats := ".tar.gz",
  README_URL := "https://example.com/FusionRings/README.md",
  PackageInfoURL := "https://example.com/FusionRings/PackageInfo.g",
  AbstractHTML := "FusionRings provides GAP objects for fusion rings with multiple representations and validation tools.",
  PackageWWWHome := "https://example.com/FusionRings",
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
