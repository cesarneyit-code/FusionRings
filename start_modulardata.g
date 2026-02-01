# Convenience loader for ModularData development
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

Print("FusionRings ModularData loaded.\n");
Print("Available stubs for Lie/root-system constructors:\n");
Print("  VerlindeModularData(\"A\", 2, k);\n");
Print("  VerlindeModularDataByLieAlgebra(L, k);\n");
Print("  VerlindeModularDataByRootSystem(R, k);\n");

Print("Quick example:\n");
Print("  md := GetModularData(2, 1, 1);\n");
Print("  ValidateModularData(md, 4);\n");
Print("  F := FusionRingFromModularData(md);\n");
