#############################################################################
# read_direct.g  (robusto)
#############################################################################

FUSIONRINGS_ROOT := Directory("/Users/cesargalindo/Documents/FusionRings");
FUSIONRINGS_CHDIR := true;

FusionRings_Read := function(relpath)
    local f;
    f := Filename(FUSIONRINGS_ROOT, relpath);
    if f = fail or not IsReadableFile(f) then
        Error(Concatenation("No puedo leer: ", relpath, "\nRuta: ", String(f),
                            "\nSystem error: ", LastSystemError().message));
    fi;
    Reread(f);
end;

# 1) Carga directa del paquete (no requiere LoadPackage)
#    Leemos los archivos .gd/.gi directamente para evitar ReadPackage.
FusionRings_Load := function()
    FusionRings_Read("pkg/FusionRings/lib/FusionRing.gd");
    FusionRings_Read("pkg/FusionRings/lib/ModularData.gd");
    FusionRings_Read("pkg/FusionRings/lib/TestHelpers.gd");
    FusionRings_Read("pkg/FusionRings/lib/FusionRing.gi");
    FusionRings_Read("pkg/FusionRings/lib/FusionRingRule.gi");
    FusionRings_Read("pkg/FusionRings/lib/FusionRingSparse.gi");
    FusionRings_Read("pkg/FusionRings/lib/FusionRingMatrices.gi");
    FusionRings_Read("pkg/FusionRings/lib/ModularData.gi");
    FusionRings_Read("pkg/FusionRings/lib/TestHelpers.gi");
end;

FusionRings_Setup := function()
    FusionRings_Load();
    if FUSIONRINGS_CHDIR then
        ChangeDirectoryCurrent("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings");
    fi;
end;

FusionRings_Setup();
