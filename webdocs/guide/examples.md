# Worked Examples

## Example 1: Database entry to validated modular data

```gap
md := GetModularData(2, 1, 1);;
v := ValidateModularData(md, 7);;
Print(v.ok, "\n");
```

## Example 2: Build fusion ring from modular data

```gap
md := GetModularData(2, 1, 1);;
F := FusionRingFromModularData(md);;
CheckFusionRingAxioms(F, 1);
```

## Example 3: SU(2)_k (Phase 2)

```gap
md := VerlindeModularData("A", 1, 4);;
ValidateModularData(md, 4);
```

## Example 4: Run the new SU(2)_k test file

```gap
Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");
Test(
  "/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/tst/test_verlinde_su2.tst",
  rec(compareFunction := "uptowhitespace")
);
```
