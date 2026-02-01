InstallMethod(FusionMatrix, [ IsFusionRingByMatricesRep, IsObject ],
function(F, i)
  local pos;
  pos := PositionOfLabel(F, i);
  if pos = fail then
    Error("FusionMatrix: label not in fusion ring");
  fi;
  return F!.fusionMatrices[pos];
end );

InstallMethod(MultiplyBasis, [ IsFusionRingByMatricesRep, IsObject, IsObject ],
function(F, i, j)
  local posi, posj, mat, k, row, out;
  posi := PositionOfLabel(F, i);
  posj := PositionOfLabel(F, j);
  if posi = fail or posj = fail then
    Error("MultiplyBasis: label not in fusion ring");
  fi;
  mat := F!.fusionMatrices[posi];
  row := mat[posj];
  out := [];
  for k in [1..Length(row)] do
    if row[k] <> 0 then
      Add(out, [ LabelOfPosition(F, k), row[k] ]);
    fi;
  od;
  return out;
end );

InstallMethod(FusionCoefficient, [ IsFusionRingByMatricesRep, IsObject, IsObject, IsObject ],
function(F, i, j, k)
  local posi, posj, posk, mat;
  posi := PositionOfLabel(F, i);
  posj := PositionOfLabel(F, j);
  posk := PositionOfLabel(F, k);
  if posi = fail or posj = fail or posk = fail then
    return 0;
  fi;
  mat := F!.fusionMatrices[posi];
  return mat[posj][posk];
end );
