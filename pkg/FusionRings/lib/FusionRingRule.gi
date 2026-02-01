InstallMethod(MultiplyBasis, [ IsFusionRingByRuleRep, IsObject, IsObject ],
function(F, i, j)
  local out;
  out := F!.mult(i, j);
  if out = fail then
    return [];
  fi;
  return NormalizeProductList(out, F);
end );

InstallMethod(DualLabel, [ IsFusionRingByRuleRep, IsObject ], function(F, i)
  local d;
  d := FRLookupInTable@(F!.dual, i, F);
  if d = fail then
    Error("DualLabel: cannot determine dual for label");
  fi;
  return d;
end );
