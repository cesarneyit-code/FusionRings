InstallMethod(MultiplyBasis, [ IsFusionRingBySparseRep, IsObject, IsObject ],
function(F, i, j)
  local out;
  out := FRLookupProdTable@(F!.prodTable, i, j);
  if out = fail then
    return [];
  fi;
  return NormalizeProductList(out, F);
end );

InstallMethod(FusionCoefficient, [ IsFusionRingBySparseRep, IsObject, IsObject, IsObject ],
function(F, i, j, k)
  local prod, pos;
  prod := FRLookupProdTable@(F!.prodTable, i, j);
  if prod = fail then
    return 0;
  fi;
  pos := PositionProperty(prod, x -> x[1] = k);
  if pos = fail then
    return 0;
  fi;
  return prod[pos][2];
end );
