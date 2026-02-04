BindGlobal("FRParseOpts@", function(opts)
  local o;
  o := rec(
    storeRepresentation := fail,
    check := 0,
    inferDual := false,
    buildIndex := true,
    makeImmutable := true
  );
  if opts <> fail then
    if IsRecord(opts) then
      if IsBound(opts.storeRepresentation) then o.storeRepresentation := opts.storeRepresentation; fi;
      if IsBound(opts.check) then o.check := opts.check; fi;
      if IsBound(opts.inferDual) then o.inferDual := opts.inferDual; fi;
      if IsBound(opts.buildIndex) then o.buildIndex := opts.buildIndex; fi;
      if IsBound(opts.makeImmutable) then o.makeImmutable := opts.makeImmutable; fi;
    else
      Error("opts must be a record or fail");
    fi;
  fi;
  return o;
end );

if not IsBound(FRFusionRingFamily@) then
  BindGlobal("FRFusionRingFamily@", NewFamily("FusionRingsFamily", IsFusionRing));
  BindGlobal("FRFusionRingRuleType@", NewType(FRFusionRingFamily@, IsFusionRingByRuleRep));
  BindGlobal("FRFusionRingSparseType@", NewType(FRFusionRingFamily@, IsFusionRingBySparseRep));
  BindGlobal("FRFusionRingMatricesType@", NewType(FRFusionRingFamily@, IsFusionRingByMatricesRep));
fi;

if not IsBound(FRFusionModuleFamily@) then
  BindGlobal("FRFusionModuleFamily@", NewFamily("FusionModulesFamily", IsFusionModule));
  BindGlobal("FRFusionModuleMatricesType@", NewType(FRFusionModuleFamily@, IsFusionModuleByMatricesRep));
fi;

BindGlobal("FRLabelsListFromI@", function(I)
  local labels;
  if IsList(I) then
    if IsSSortedList(I) then
      labels := I;
    else
      labels := ShallowCopy(I);
      Sort(labels);
      if not IsSSortedList(labels) then
        Error("Labels list must be strictly sorted and without duplicates");
      fi;
    fi;
  elif IsDomain(I) then
    if not IsFinite(I) then
      Error("I must be finite");
    fi;
    labels := AsSortedList(I);
  else
    Error("I must be a list or a finite domain");
  fi;
  return labels;
end );

BindGlobal("FRLookupInTable@", function(tbl, key, F)
  local pos, s;
  if IsFunction(tbl) then
    return tbl(key);
  fi;
  if IsList(tbl) then
    if Length(tbl) = 0 then
      return fail;
    fi;
    if IsList(tbl[1]) and Length(tbl[1]) = 2 then
      pos := PositionProperty(tbl, x -> x[1] = key);
      if pos = fail then return fail; fi;
      return tbl[pos][2];
    fi;
    if F = fail then return fail; fi;
    pos := PositionOfLabel(F, key);
    if pos = fail or pos > Length(tbl) then return fail; fi;
    return tbl[pos];
  fi;
  if IsRecord(tbl) then
    if IsString(key) and IsBound(tbl.(key)) then
      return tbl.(key);
    fi;
    s := String(key);
    if IsBound(tbl.(s)) then
      return tbl.(s);
    fi;
  fi;
  return fail;
end );

BindGlobal("FRLookupProdTable@", function(prodTable, i, j)
  local key, pos, s, r;
  if IsFunction(prodTable) then
    return prodTable(i, j);
  fi;
  if IsRecord(prodTable) then
    s := String(i);
    if IsBound(prodTable.(s)) then
      r := prodTable.(s);
      if IsRecord(r) then
        if IsBound(r.(String(j))) then
          return r.(String(j));
        fi;
      fi;
    fi;
    key := Concatenation(String(i), "|", String(j));
    if IsBound(prodTable.(key)) then
      return prodTable.(key);
    fi;
  fi;
  if IsList(prodTable) then
    if Length(prodTable) = 0 then return []; fi;
    if IsList(prodTable[1]) then
      if Length(prodTable[1]) = 3 then
        pos := PositionProperty(prodTable, x -> x[1] = i and x[2] = j);
        if pos = fail then return []; fi;
        return prodTable[pos][3];
      fi;
      if Length(prodTable[1]) = 2 and IsList(prodTable[1][1]) and Length(prodTable[1][1]) = 2 then
        pos := PositionProperty(prodTable, x -> x[1][1] = i and x[1][2] = j);
        if pos = fail then return []; fi;
        return prodTable[pos][2];
      fi;
    fi;
  fi;
  return [];
end );

InstallMethod(BasisLabels, [ IsFusionRing ], F -> F!.I );
InstallMethod(OneLabel, [ IsFusionRing ], F -> F!.one );
InstallMethod(DualData, [ IsFusionRing ], F -> F!.dual );

InstallMethod(RepresentationType, [ IsFusionRingByRuleRep ], F -> "rule" );
InstallMethod(RepresentationType, [ IsFusionRingBySparseRep ], F -> "sparse" );
InstallMethod(RepresentationType, [ IsFusionRingByMatricesRep ], F -> "matrices" );

# Pretty printing
InstallMethod(ViewObj, [ IsFusionRing ], function(F)
  local rep, labels, r;
  rep := RepresentationType(F);
  labels := LabelsList(F);
  r := Length(labels);
  Print("<FusionRing rep=", rep, ", rank=", r, ", one=", OneLabel(F), ">");
end );

InstallMethod(PrintObj, [ IsFusionRing ], function(F)
  local rep, labels, r, show, i;
  rep := RepresentationType(F);
  labels := LabelsList(F);
  r := Length(labels);
  Print("FusionRing( rep := ", rep, ", rank := ", r, ", one := ", OneLabel(F), ", labels := [");
  show := Minimum(r, 6);
  for i in [1..show] do
    Print(labels[i]);
    if i < show then
      Print(", ");
    fi;
  od;
  if r > show then
    Print(", ...");
  fi;
  Print("] )");
end );

InstallMethod(Display, [ IsFusionRing ], function(F)
  local rep, labels, r, one;
  rep := RepresentationType(F);
  labels := LabelsList(F);
  r := Length(labels);
  one := OneLabel(F);
  Print("FusionRing\n");
  Print("  rep: ", rep, "\n");
  Print("  rank: ", r, "\n");
  Print("  one: ", one, "\n");
  Print("  labels: ");
  if r <= 12 then
    Print(labels, "\n");
  else
    Print(labels{[1..10]}, " ...\n");
  fi;
end );

BindGlobal("FRParseModuleOpts@", function(opts)
  local o;
  o := rec(
    check := 1,
    makeImmutable := true
  );
  if opts <> fail then
    if not IsRecord(opts) then
      Error("opts must be a record or fail");
    fi;
    if IsBound(opts.check) then o.check := opts.check; fi;
    if IsBound(opts.makeImmutable) then o.makeImmutable := opts.makeImmutable; fi;
  fi;
  return o;
end );

BindGlobal("FRZeroSquareMatrix@", function(n)
  return List([1..n], i -> List([1..n], j -> 0));
end );

BindGlobal("FRIdentityMatrix@", function(n)
  local M, i;
  M := FRZeroSquareMatrix@(n);
  for i in [1..n] do
    M[i][i] := 1;
  od;
  return M;
end );

BindGlobal("FRRestrictSquareMatrix@", function(A, pos)
  return List(pos, r -> List(pos, c -> A[r][c]));
end );

InstallMethod(ViewObj, [ IsFusionModule ], function(M)
  Print("<FusionModule rank=", ModuleRank(M), " over rank-", Length(LabelsList(UnderlyingFusionRing(M))), " FusionRing>");
end );

InstallMethod(PrintObj, [ IsFusionModule ], function(M)
  Print("FusionModule( rank := ", ModuleRank(M), ", basis := ", ModuleBasisLabels(M), " )");
end );

InstallMethod(Display, [ IsFusionModule ], function(M)
  Print("FusionModule\n");
  Print("  module rank: ", ModuleRank(M), "\n");
  Print("  fusion ring rank: ", Length(LabelsList(UnderlyingFusionRing(M))), "\n");
  Print("  basis: ", ModuleBasisLabels(M), "\n");
end );

InstallMethod(UnderlyingFusionRing, [ IsFusionModule ], M -> M!.F );
InstallMethod(ModuleBasisLabels, [ IsFusionModule ], M -> M!.M );
InstallMethod(ModuleRank, [ IsFusionModule ], M -> Length(M!.M) );
InstallMethod(ActionMatrices, [ IsFusionModule ], M -> Immutable(M!.actions) );

InstallMethod(ActionMatrix, [ IsFusionModule, IsObject ], function(M, i)
  local F, pos;
  F := UnderlyingFusionRing(M);
  pos := PositionOfLabel(F, i);
  if pos = fail then
    Error("ActionMatrix: unknown fusion-ring label");
  fi;
  return M!.actions[pos];
end );

InstallMethod(ActionOnBasis, [ IsFusionModule, IsObject, IsObject ], function(M, i, m)
  local A, basis, c, p, out, r;
  basis := ModuleBasisLabels(M);
  p := Position(basis, m);
  if p = fail then
    Error("ActionOnBasis: module basis label not found");
  fi;
  A := ActionMatrix(M, i);
  out := [];
  for r in [1..Length(basis)] do
    c := A[r][p];
    if c <> 0 then
      Add(out, [ basis[r], c ]);
    fi;
  od;
  return out;
end );

InstallGlobalFunction(FusionModuleByActionMatrices, function(arg)
  local F, basis, actions, opts, o, ringLabels, r, m, i, j, t, onePos, lhs, rhs, prod, term, A, M;
  if Length(arg) = 3 then
    F := arg[1]; basis := arg[2]; actions := arg[3]; opts := fail;
  elif Length(arg) = 4 then
    F := arg[1]; basis := arg[2]; actions := arg[3]; opts := arg[4];
  else
    Error("FusionModuleByActionMatrices expects 3 or 4 arguments");
  fi;
  if not IsFusionRing(F) then
    Error("first argument must be a fusion ring");
  fi;
  if not IsList(basis) then
    Error("module basis must be a list");
  fi;
  if Length(Set(basis)) <> Length(basis) then
    Error("module basis labels must be unique");
  fi;
  if not IsList(actions) then
    Error("action matrices must be a list");
  fi;

  o := FRParseModuleOpts@(opts);
  ringLabels := LabelsList(F);
  r := Length(ringLabels);
  m := Length(basis);
  if Length(actions) <> r then
    Error("action matrices length must match fusion ring rank");
  fi;

  A := ShallowCopy(actions);
  for i in [1..r] do
    if not IsList(A[i]) or Length(A[i]) <> m then
      Error("each action matrix must be square with size module rank");
    fi;
    for j in [1..m] do
      if not IsList(A[i][j]) or Length(A[i][j]) <> m then
        Error("each action matrix must be square with size module rank");
      fi;
      for t in [1..m] do
        if not IsInt(A[i][j][t]) or A[i][j][t] < 0 then
          Error("action matrices must have nonnegative integer entries");
        fi;
      od;
    od;
  od;

  if o.check >= 1 then
    onePos := PositionOfLabel(F, OneLabel(F));
    if onePos = fail then
      Error("fusion ring has no valid one label");
    fi;
    if A[onePos] <> FRIdentityMatrix@(m) then
      Error("identity simple must act by identity matrix");
    fi;
    for i in [1..r] do
      for j in [1..r] do
        lhs := A[i] * A[j];
        rhs := FRZeroSquareMatrix@(m);
        prod := MultiplyBasis(F, ringLabels[i], ringLabels[j]);
        for term in prod do
          rhs := rhs + term[2] * A[PositionOfLabel(F, term[1])];
        od;
        if lhs <> rhs then
          Error("module associativity failed for labels ", ringLabels[i], " and ", ringLabels[j]);
        fi;
      od;
    od;
  fi;

  if o.makeImmutable then
    basis := Immutable(ShallowCopy(basis));
    A := Immutable(List(A, x -> Immutable(x)));
  fi;
  M := Objectify(FRFusionModuleMatricesType@, rec(F := F, M := basis, actions := A));
  return M;
end );

InstallMethod(IsFusionSubmodule, [ IsFusionModule, IsList ], function(M, subset)
  local basis, pos, idx, inSub, acts, i, c, r;
  basis := ModuleBasisLabels(M);
  if Length(Set(subset)) <> Length(subset) then
    return false;
  fi;
  pos := List(subset, x -> Position(basis, x));
  if fail in pos then
    return false;
  fi;
  inSub := List([1..Length(basis)], k -> false);
  for idx in pos do
    inSub[idx] := true;
  od;
  acts := ActionMatrices(M);
  for i in [1..Length(acts)] do
    for c in pos do
      for r in [1..Length(basis)] do
        if acts[i][r][c] <> 0 and not inSub[r] then
          return false;
        fi;
      od;
    od;
  od;
  return true;
end );

InstallMethod(FusionSubmodule, [ IsFusionModule, IsList ], function(M, subset)
  local basis, pos, F, acts, subActs, subBasis;
  if not IsFusionSubmodule(M, subset) then
    Error("subset is not closed under fusion-ring action");
  fi;
  basis := ModuleBasisLabels(M);
  pos := Filtered([1..Length(basis)], i -> basis[i] in subset);
  subBasis := basis{pos};
  F := UnderlyingFusionRing(M);
  acts := ActionMatrices(M);
  subActs := List(acts, A -> FRRestrictSquareMatrix@(A, pos));
  return FusionModuleByActionMatrices(F, subBasis, subActs, rec(check := 0));
end );

InstallGlobalFunction(FusionSubmoduleByGenerators, function(M, gens)
  local basis, pos, inSub, acts, changed, c, r, i, subset;
  if not IsFusionModule(M) then
    Error("FusionSubmoduleByGenerators expects a fusion module");
  fi;
  basis := ModuleBasisLabels(M);
  pos := List(gens, g -> Position(basis, g));
  if fail in pos then
    Error("generator not found in module basis");
  fi;
  inSub := List([1..Length(basis)], i -> false);
  for i in pos do
    inSub[i] := true;
  od;
  acts := ActionMatrices(M);
  changed := true;
  while changed do
    changed := false;
    for i in [1..Length(acts)] do
      for c in [1..Length(basis)] do
        if inSub[c] then
          for r in [1..Length(basis)] do
            if acts[i][r][c] <> 0 and not inSub[r] then
              inSub[r] := true;
              changed := true;
            fi;
          od;
        fi;
      od;
    od;
  od;
  subset := Filtered([1..Length(basis)], i -> inSub[i]);
  return FusionSubmodule(M, basis{subset});
end );

InstallMethod(FusionModuleComponents, [ IsFusionModule ], function(M)
  local m, acts, adj, i, c, r, seen, q, head, comp, comps, v, basis;
  m := ModuleRank(M);
  if m = 0 then
    return [];
  fi;
  acts := ActionMatrices(M);
  adj := List([1..m], x -> []);
  for i in [1..Length(acts)] do
    for c in [1..m] do
      for r in [1..m] do
        if acts[i][r][c] <> 0 then
          if not r in adj[c] then Add(adj[c], r); fi;
          if not c in adj[r] then Add(adj[r], c); fi;
        fi;
      od;
    od;
  od;
  seen := List([1..m], x -> false);
  comps := [];
  for v in [1..m] do
    if not seen[v] then
      q := [ v ];
      seen[v] := true;
      comp := [];
      head := 1;
      while head <= Length(q) do
        c := q[head];
        head := head + 1;
        Add(comp, c);
        for r in adj[c] do
          if not seen[r] then
            seen[r] := true;
            Add(q, r);
          fi;
        od;
      od;
      Sort(comp);
      Add(comps, comp);
    fi;
  od;
  basis := ModuleBasisLabels(M);
  return Immutable(List(comps, C -> basis{C}));
end );

InstallMethod(IsIndecomposableFusionModule, [ IsFusionModule ], function(M)
  return Length(FusionModuleComponents(M)) <= 1;
end );

InstallMethod(IsIrreducibleFusionModule, [ IsFusionModule ], function(M)
  local m, acts, adj, start, seen, q, head, c, r;
  m := ModuleRank(M);
  if m <= 1 then
    return true;
  fi;
  acts := ActionMatrices(M);
  adj := List([1..m], x -> []);
  for c in [1..m] do
    for r in [1..m] do
      for start in [1..Length(acts)] do
        if acts[start][r][c] <> 0 then
          if not r in adj[c] then
            Add(adj[c], r);
          fi;
          break;
        fi;
      od;
    od;
  od;
  for start in [1..m] do
    seen := List([1..m], x -> false);
    q := [ start ];
    seen[start] := true;
    head := 1;
    while head <= Length(q) do
      c := q[head];
      head := head + 1;
      for r in adj[c] do
        if not seen[r] then
          seen[r] := true;
          Add(q, r);
        fi;
      od;
    od;
    if false in seen then
      return false;
    fi;
  od;
  return true;
end );

BindGlobal("FRModuleInvariantVector@", function(acts, v)
  local inv, A;
  inv := [];
  for A in acts do
    Add(inv, Sum([1..Length(A)], r -> A[r][v]));
    Add(inv, Sum([1..Length(A)], c -> A[v][c]));
    Add(inv, A[v][v]);
  od;
  return inv;
end );

InstallMethod(AreEquivalentFusionModules, [ IsFusionModule, IsFusionModule ], function(M1, M2)
  local F1, F2, b1, b2, acts1, acts2, n, i, j, inv1, inv2, cand, used, p, Search, Consistent;
  F1 := UnderlyingFusionRing(M1);
  F2 := UnderlyingFusionRing(M2);
  if LabelsList(F1) <> LabelsList(F2) or FusionMatrices(F1) <> FusionMatrices(F2) then
    return false;
  fi;
  b1 := ModuleBasisLabels(M1);
  b2 := ModuleBasisLabels(M2);
  if Length(b1) <> Length(b2) then
    return false;
  fi;
  n := Length(b1);
  acts1 := ActionMatrices(M1);
  acts2 := ActionMatrices(M2);
  if n = 0 then
    return true;
  fi;
  inv1 := List([1..n], v -> FRModuleInvariantVector@(acts1, v));
  inv2 := List([1..n], v -> FRModuleInvariantVector@(acts2, v));
  cand := List([1..n], a -> Filtered([1..n], b -> inv1[a] = inv2[b]));
  if ForAny(cand, C -> Length(C) = 0) then
    return false;
  fi;

  p := List([1..n], x -> 0);
  used := List([1..n], x -> false);
  Consistent := function(k)
    local a, t;
    for a in [1..k] do
      if p[a] = 0 then
        continue;
      fi;
      for t in [1..Length(acts1)] do
        if acts1[t][k][a] <> acts2[t][p[k]][p[a]] then
          return false;
        fi;
        if acts1[t][a][k] <> acts2[t][p[a]][p[k]] then
          return false;
        fi;
      od;
    od;
    return true;
  end;

  Search := function(k)
    local b;
    if k > n then
      return true;
    fi;
    for b in cand[k] do
      if not used[b] then
        p[k] := b;
        used[b] := true;
        if Consistent(k) and Search(k + 1) then
          return true;
        fi;
        used[b] := false;
        p[k] := 0;
      fi;
    od;
    return false;
  end;

  return Search(1);
end );

InstallGlobalFunction(FusionModuleGraph, function(arg)
  local M, lbl, basis, n, A, acts, i, r, c, adj, edges, mode;
  if Length(arg) = 1 then
    M := arg[1];
    lbl := fail;
  elif Length(arg) = 2 then
    M := arg[1];
    lbl := arg[2];
  else
    Error("FusionModuleGraph expects 1 or 2 arguments");
  fi;
  if not IsFusionModule(M) then
    Error("FusionModuleGraph expects a fusion module");
  fi;
  basis := ModuleBasisLabels(M);
  n := Length(basis);
  adj := List([1..n], x -> List([1..n], y -> 0));

  if lbl = fail then
    mode := "combined-undirected";
    acts := ActionMatrices(M);
    for i in [1..Length(acts)] do
      A := acts[i];
      for r in [1..n] do
        for c in [1..n] do
          if A[r][c] <> 0 then
            adj[r][c] := adj[r][c] + A[r][c];
            if r <> c then
              adj[c][r] := adj[c][r] + A[r][c];
            fi;
          fi;
        od;
      od;
    od;
  else
    mode := "action-directed";
    A := ActionMatrix(M, lbl);
    for r in [1..n] do
      for c in [1..n] do
        if A[r][c] <> 0 then
          adj[r][c] := A[r][c];
        fi;
      od;
    od;
  fi;

  edges := [];
  for c in [1..n] do
    for r in [1..n] do
      if adj[r][c] <> 0 then
        Add(edges, [ basis[c], basis[r], adj[r][c] ]);
      fi;
    od;
  od;
  return rec(
    mode := mode,
    vertices := basis,
    edges := edges,
    adjacency := Immutable(adj)
  );
end );

InstallMethod(CanonicalFusionModule, [ IsFusionRing ], function(F)
  return FusionModuleByActionMatrices(F, LabelsList(F), FusionMatrices(F), rec(check := 1));
end );

InstallMethod(FusionSubmoduleByObject, [ IsFusionRing, IsObject ], function(F, i)
  if PositionOfLabel(F, i) = fail then
    Error("FusionSubmoduleByObject: object label not found in fusion ring");
  fi;
  return FusionSubmoduleByGenerators(CanonicalFusionModule(F), [ i ]);
end );

InstallGlobalFunction(DynkinGraphAdjacency, function(arg)
  local typ, n, A, i;
  if Length(arg) = 1 then
    typ := arg[1];
    n := fail;
  elif Length(arg) = 2 then
    typ := arg[1];
    n := arg[2];
  else
    Error("DynkinGraphAdjacency expects 1 or 2 arguments");
  fi;
  if not IsString(typ) then
    Error("type must be a string (A, D, E6, E7, E8)");
  fi;
  typ := UppercaseString(typ);
  if typ = "E6" then
    n := 6;
  elif typ = "E7" then
    n := 7;
  elif typ = "E8" then
    n := 8;
  elif typ = "A" or typ = "D" then
    if n = fail or not IsInt(n) or n < 2 then
      Error("types A and D require integer rank n >= 2");
    fi;
  else
    Error("unknown Dynkin type; use A, D, E6, E7, E8");
  fi;

  A := List([1..n], r -> List([1..n], c -> 0));
  if typ = "A" then
    for i in [1..n-1] do
      A[i][i+1] := 1;
      A[i+1][i] := 1;
    od;
  elif typ = "D" then
    if n < 4 then
      Error("D_n requires n >= 4");
    fi;
    for i in [1..n-3] do
      A[i][i+1] := 1;
      A[i+1][i] := 1;
    od;
    A[n-2][n-1] := 1;
    A[n-1][n-2] := 1;
    A[n-2][n] := 1;
    A[n][n-2] := 1;
  elif typ = "E6" then
    # 1-2-3-4-5 and 3-6
    A[1][2] := 1; A[2][1] := 1;
    A[2][3] := 1; A[3][2] := 1;
    A[3][4] := 1; A[4][3] := 1;
    A[4][5] := 1; A[5][4] := 1;
    A[3][6] := 1; A[6][3] := 1;
  elif typ = "E7" then
    # 1-2-3-4-5-6 and 3-7
    A[1][2] := 1; A[2][1] := 1;
    A[2][3] := 1; A[3][2] := 1;
    A[3][4] := 1; A[4][3] := 1;
    A[4][5] := 1; A[5][4] := 1;
    A[5][6] := 1; A[6][5] := 1;
    A[3][7] := 1; A[7][3] := 1;
  else
    # E8: 1-2-3-4-5-6-7 and 3-8
    A[1][2] := 1; A[2][1] := 1;
    A[2][3] := 1; A[3][2] := 1;
    A[3][4] := 1; A[4][3] := 1;
    A[4][5] := 1; A[5][4] := 1;
    A[5][6] := 1; A[6][5] := 1;
    A[6][7] := 1; A[7][6] := 1;
    A[3][8] := 1; A[8][3] := 1;
  fi;
  return A;
end );

BindGlobal("FROstrikADEAllowedK@", function(typ, n)
  if typ = "A" then
    return n - 1;
  fi;
  if typ = "D" then
    return 2 * n - 4;
  fi;
  if typ = "E6" then
    return 10;
  fi;
  if typ = "E7" then
    return 16;
  fi;
  if typ = "E8" then
    return 28;
  fi;
  Error("unsupported ADE type");
end );

BindGlobal("FROstrikBuildSU2Actions@", function(k, A)
  local mats, r, j;
  r := k + 1;
  mats := [];
  Add(mats, FRIdentityMatrix@(Length(A)));
  if r = 1 then
    return mats;
  fi;
  Add(mats, A);
  for j in [2..r-1] do
    Add(mats, A * mats[j] - mats[j-1]);
  od;
  return mats;
end );

InstallGlobalFunction(OstrikSU2Module, function(arg)
  local k, typ, n, opts, gAdj, kExpected, md, F, labels, acts, m, i, j;
  if Length(arg) = 2 then
    k := arg[1]; typ := arg[2]; n := fail; opts := fail;
  elif Length(arg) = 3 then
    k := arg[1]; typ := arg[2];
    if IsRecord(arg[3]) then
      n := fail; opts := arg[3];
    else
      n := arg[3]; opts := fail;
    fi;
  elif Length(arg) = 4 then
    k := arg[1]; typ := arg[2]; n := arg[3]; opts := arg[4];
  else
    Error("OstrikSU2Module expects (k, type[, n][, opts])");
  fi;
  if not IsInt(k) or k < 1 then
    Error("k must be a positive integer");
  fi;
  if not IsString(typ) then
    Error("type must be a string");
  fi;
  typ := UppercaseString(typ);
  if typ = "A" or typ = "D" then
    if n = fail then
      if typ = "A" then
        n := k + 1;
      else
        if k mod 2 <> 0 then
          Error("D-type appears only for even k in SU(2)_k");
        fi;
        n := k / 2 + 2;
      fi;
    fi;
    gAdj := DynkinGraphAdjacency(typ, n);
  elif typ = "E6" or typ = "E7" or typ = "E8" then
    gAdj := DynkinGraphAdjacency(typ);
    n := Length(gAdj);
  else
    Error("type must be A, D, E6, E7, or E8");
  fi;

  kExpected := FROstrikADEAllowedK@(typ, n);
  if k <> kExpected then
    Error("incompatible (k, ADE): expected k=", String(kExpected), " for ", typ, "_", String(n));
  fi;

  md := VerlindeModularData("A", 1, k);
  F := FusionRingFromModularData(md);
  labels := List([1..Length(gAdj)], i -> Concatenation("v", String(i)));
  acts := FROstrikBuildSU2Actions@(k, gAdj);
  m := Length(gAdj);
  for i in [1..Length(acts)] do
    for j in [1..m] do
      if ForAny(acts[i][j], x -> not IsInt(x) or x < 0) then
        Error("constructed action has negative/nonintegral entries; invalid nimrep");
      fi;
    od;
  od;
  return FusionModuleByActionMatrices(F, labels, acts, opts);
end );

InstallGlobalFunction(IsOstrikSU2Module, function(arg)
  local M, k, typ, n, gAdj, one, acts, expect, j;
  if Length(arg) < 2 or Length(arg) > 4 then
    Error("IsOstrikSU2Module expects (M, k[, type[, n]])");
  fi;
  M := arg[1];
  k := arg[2];
  typ := "A";
  n := fail;
  if Length(arg) >= 3 then typ := UppercaseString(arg[3]); fi;
  if Length(arg) = 4 then n := arg[4]; fi;
  if not IsFusionModule(M) then
    return false;
  fi;
  if not IsInt(k) or k < 1 then
    return false;
  fi;
  one := ActionMatrices(M)[1];
  if one <> FRIdentityMatrix@(Length(one)) then
    return false;
  fi;
  if typ = "A" or typ = "D" then
    if n = fail then
      if typ = "A" then n := k + 1; else n := k / 2 + 2; fi;
    fi;
    gAdj := DynkinGraphAdjacency(typ, n);
  elif typ = "E6" or typ = "E7" or typ = "E8" then
    gAdj := DynkinGraphAdjacency(typ);
  else
    return false;
  fi;
  acts := ActionMatrices(M);
  expect := FROstrikBuildSU2Actions@(k, gAdj);
  if Length(acts) <> Length(expect) then
    return false;
  fi;
  for j in [1..Length(acts)] do
    if acts[j] <> expect[j] then
      return false;
    fi;
  od;
  return true;
end );

InstallGlobalFunction(OstrikSU2Modules, function(k)
  local out;
  if not IsInt(k) or k < 1 then
    Error("k must be a positive integer");
  fi;
  out := [ rec(type := "A", module := OstrikSU2Module(k, "A")) ];
  if k mod 2 = 0 and k >= 4 then
    Add(out, rec(type := "D", n := k / 2 + 2, module := OstrikSU2Module(k, "D")));
  fi;
  if k = 10 then Add(out, rec(type := "E6", module := OstrikSU2Module(k, "E6"))); fi;
  if k = 16 then Add(out, rec(type := "E7", module := OstrikSU2Module(k, "E7"))); fi;
  if k = 28 then Add(out, rec(type := "E8", module := OstrikSU2Module(k, "E8"))); fi;
  return Immutable(out);
end );


InstallMethod(PositionOfLabel, [ IsFusionRing, IsObject ], function(F, i)
  local labels, pos;
  labels := LabelsList(F);
  pos := Position(labels, i);
  return pos;
end );

InstallMethod(LabelOfPosition, [ IsFusionRing, IsInt ], function(F, p)
  local labels;
  labels := LabelsList(F);
  if p < 1 or p > Length(labels) then
    return fail;
  fi;
  return labels[p];
end );

InstallMethod(DualLabel, [ IsFusionRing, IsObject ], function(F, i)
  local d;
  d := FRLookupInTable@(F!.dual, i, F);
  if d = fail then
    Error("DualLabel: cannot determine dual for label");
  fi;
  return d;
end );

InstallMethod(DualTable, [ IsFusionRing ], function(F)
  local dual, labels, out, i;
  dual := F!.dual;
  if not IsFunction(dual) then
    if IsCopyable(dual) then
      return Immutable(dual);
    fi;
    return dual;
  fi;
  labels := LabelsList(F);
  out := List([1..Length(labels)], i -> dual(labels[i]));
  return Immutable(out);
end );

InstallMethod(FusionCoefficient, [ IsFusionRing, IsObject, IsObject, IsObject ],
function(F, i, j, k)
  local prod, pos;
  prod := MultiplyBasis(F, i, j);
  pos := PositionProperty(prod, x -> x[1] = k);
  if pos = fail then
    return 0;
  fi;
  return prod[pos][2];
end );

InstallGlobalFunction(NormalizeProductList, function(arg)
  local list, F, labels, acc, out, i, k, n, pos;
  if Length(arg) = 1 then
    list := arg[1];
    F := fail;
  elif Length(arg) = 2 then
    list := arg[1];
    F := arg[2];
  else
    Error("NormalizeProductList expects 1 or 2 arguments");
  fi;
  if list = fail or list = [] then
    return [];
  fi;
  if F <> fail and HasLabelsList(F) then
    labels := LabelsList(F);
    acc := List([1..Length(labels)], i -> 0);
    for i in list do
      k := i[1];
      n := i[2];
      if not IsInt(n) then Error("coefficient must be integer"); fi;
      if n < 0 then Error("coefficient must be nonnegative"); fi;
      if n = 0 then
        continue;
      fi;
      pos := Position(labels, k);
      if pos = fail then Error("label not in fusion ring"); fi;
      acc[pos] := acc[pos] + n;
    od;
    out := [];
    for i in [1..Length(labels)] do
      if acc[i] <> 0 then
        Add(out, [ labels[i], acc[i] ]);
      fi;
    od;
    return out;
  fi;
  out := [];
  for i in list do
    k := i[1];
    n := i[2];
    if not IsInt(n) then Error("coefficient must be integer"); fi;
    if n < 0 then Error("coefficient must be nonnegative"); fi;
    if n = 0 then
      continue;
    fi;
    pos := PositionProperty(out, x -> x[1] = k);
    if pos = fail then
      Add(out, [ k, n ]);
    else
      out[pos][2] := out[pos][2] + n;
      if out[pos][2] = 0 then
        Remove(out, pos);
      fi;
    fi;
  od;
  return out;
end );

BindGlobal("FRMultiplyComboByLabel@", function(F, combo, l)
  local labels, acc, i, term, prod, k, n, pos;
  labels := LabelsList(F);
  acc := List([1..Length(labels)], i -> 0);
  for term in combo do
    prod := MultiplyBasis(F, term[1], l);
    for i in prod do
      k := i[1];
      n := i[2] * term[2];
      pos := Position(labels, k);
      if pos = fail then Error("label not in fusion ring"); fi;
      acc[pos] := acc[pos] + n;
    od;
  od;
  return NormalizeProductList(List([1..Length(labels)], i -> [ labels[i], acc[i] ]), F);
end );

BindGlobal("FRMultiplyLabelByCombo@", function(F, l, combo)
  local labels, acc, i, term, prod, k, n, pos;
  labels := LabelsList(F);
  acc := List([1..Length(labels)], i -> 0);
  for term in combo do
    prod := MultiplyBasis(F, l, term[1]);
    for i in prod do
      k := i[1];
      n := i[2] * term[2];
      pos := Position(labels, k);
      if pos = fail then Error("label not in fusion ring"); fi;
      acc[pos] := acc[pos] + n;
    od;
  od;
  return NormalizeProductList(List([1..Length(labels)], i -> [ labels[i], acc[i] ]), F);
end );

InstallMethod(FusionMatrix, [ IsFusionRing, IsObject ], function(F, i)
  local labels, r, mat, j, prod, term, pk;
  labels := LabelsList(F);
  r := Length(labels);
  mat := NullMat(r, r);
  for j in [1..r] do
    prod := MultiplyBasis(F, i, labels[j]);
    for term in prod do
      pk := Position(labels, term[1]);
      if pk = fail then Error("label not in fusion ring"); fi;
      mat[j][pk] := term[2];
    od;
  od;
  return Immutable(mat);
end );

InstallMethod(FusionMatrices, [ IsFusionRing ], function(F)
  local labels, mats;
  labels := LabelsList(F);
  mats := List(labels, x -> FusionMatrix(F, x));
  return Immutable(mats);
end );

BindGlobal("FRIsPermutationMatrix@", function(mat)
  local r, i, j, rowsum, colsum;
  if not IsList(mat) then
    return false;
  fi;
  r := Length(mat);
  if r = 0 then
    return false;
  fi;
  for i in [1..r] do
    if not IsList(mat[i]) or Length(mat[i]) <> r then
      return false;
    fi;
  od;
  for i in [1..r] do
    rowsum := 0;
    for j in [1..r] do
      if not IsInt(mat[i][j]) or not (mat[i][j] = 0 or mat[i][j] = 1) then
        return false;
      fi;
      rowsum := rowsum + mat[i][j];
    od;
    if rowsum <> 1 then
      return false;
    fi;
  od;
  for j in [1..r] do
    colsum := 0;
    for i in [1..r] do
      colsum := colsum + mat[i][j];
    od;
    if colsum <> 1 then
      return false;
    fi;
  od;
  return true;
end );

InstallMethod(IsInvertibleSimple, [ IsFusionRing, IsObject ], function(F, label)
  if PositionOfLabel(F, label) = fail then
    Error("label not in fusion ring");
  fi;
  return FRIsPermutationMatrix@(FusionMatrix(F, label));
end );

InstallMethod(InvertibleSimples, [ IsFusionRing ], function(F)
  local labels;
  labels := LabelsList(F);
  return Immutable(Filtered(labels, x -> IsInvertibleSimple(F, x)));
end );

InstallMethod(IsPointedFusionRing, [ IsFusionRing ], function(F)
  return Length(InvertibleSimples(F)) = Length(LabelsList(F));
end );

InstallMethod(IsFusionSubring, [ IsFusionRing, IsList ], function(F, subset)
  local labels, one, i, j, prod, term;
  if subset = [] then
    return false;
  fi;
  labels := FRLabelsListFromI@(subset);
  one := OneLabel(F);
  if Position(labels, one) = fail then
    return false;
  fi;
  for i in labels do
    if PositionOfLabel(F, i) = fail then
      return false;
    fi;
    if Position(labels, DualLabel(F, i)) = fail then
      return false;
    fi;
  od;
  for i in labels do
    for j in labels do
      prod := MultiplyBasis(F, i, j);
      for term in prod do
        if Position(labels, term[1]) = fail then
          return false;
        fi;
      od;
    od;
  od;
  return true;
end );

BindGlobal("FRSubringClosureLabels@", function(F, seed)
  local cur, changed, one, i, j, d, term;
  one := OneLabel(F);
  cur := ShallowCopy(seed);
  if Position(cur, one) = fail then
    Add(cur, one);
  fi;
  cur := FRLabelsListFromI@(cur);
  changed := true;
  while changed do
    changed := false;
    for i in ShallowCopy(cur) do
      d := DualLabel(F, i);
      if Position(cur, d) = fail then
        Add(cur, d);
        changed := true;
      fi;
    od;
    for i in ShallowCopy(cur) do
      for j in ShallowCopy(cur) do
        for term in MultiplyBasis(F, i, j) do
          if Position(cur, term[1]) = fail then
            Add(cur, term[1]);
            changed := true;
          fi;
        od;
      od;
    od;
    if changed then
      cur := FRLabelsListFromI@(cur);
    fi;
  od;
  return cur;
end );

InstallMethod(FusionSubring, [ IsFusionRing, IsList ], function(F, subset)
  local labels, one, dual, prodTable, i, j, prod;
  labels := FRLabelsListFromI@(subset);
  if not IsFusionSubring(F, labels) then
    Error("subset is not a fusion subring");
  fi;
  one := OneLabel(F);
  dual := List(labels, i -> DualLabel(F, i));
  prodTable := [];
  for i in labels do
    for j in labels do
      prod := MultiplyBasis(F, i, j);
      Add(prodTable, [ i, j, prod ]);
    od;
  od;
  return FusionRingBySparseConstants(labels, one, dual, prodTable, rec(check := 2));
end );

InstallGlobalFunction(FusionSubringByGenerators, function(F, gens)
  local labels;
  if not IsFusionRing(F) then
    Error("FusionSubringByGenerators expects a fusion ring as first argument");
  fi;
  if not IsList(gens) then
    Error("generators must be a list of labels");
  fi;
  labels := FRSubringClosureLabels@(F, gens);
  return FusionSubring(F, labels);
end );

InstallGlobalFunction(FusionSubringLatticeSmall, function(arg)
  local F, maxRank, labels, one, others, out, comb, subset, i, candidates;
  if Length(arg) = 1 then
    F := arg[1];
    maxRank := 10;
  elif Length(arg) = 2 then
    F := arg[1];
    maxRank := arg[2];
    if not IsInt(maxRank) or maxRank < 1 then
      Error("maxRank must be a positive integer");
    fi;
  else
    Error("FusionSubringLatticeSmall expects (F[, maxRank])");
  fi;
  if not IsFusionRing(F) then
    Error("first argument must be a fusion ring");
  fi;
  labels := LabelsList(F);
  if Length(labels) > maxRank then
    Error("rank too large for exhaustive small-lattice search");
  fi;
  one := OneLabel(F);
  others := Filtered(labels, x -> x <> one);
  out := [];
  for i in [0..Length(others)] do
    for comb in Combinations(others, i) do
      subset := Concatenation([one], comb);
      if IsFusionSubring(F, subset) then
        Add(out, FRLabelsListFromI@(subset));
      fi;
    od;
  od;
  candidates := Set(out);
  SortBy(candidates, x -> Length(x));
  return Immutable(candidates);
end );

InstallMethod(CanonicalPointedSubring, [ IsFusionRing ], function(F)
  return FusionSubring(F, InvertibleSimples(F));
end );

InstallMethod(AdjointSubring, [ IsFusionRing ], function(F)
  local labels, cur, i, term, d;
  labels := LabelsList(F);
  cur := [ OneLabel(F) ];
  for i in labels do
    d := DualLabel(F, i);
    for term in MultiplyBasis(F, i, d) do
      if Position(cur, term[1]) = fail then
        Add(cur, term[1]);
      fi;
    od;
  od;
  cur := FRSubringClosureLabels@(F, cur);
  return FusionSubring(F, cur);
end );

BindGlobal("FRPolyEvalFloat@", function(poly, x)
  local coeffs, i, y;
  coeffs := CoefficientsOfUnivariatePolynomial(poly);
  y := 0.0;
  for i in Reversed([1..Length(coeffs)]) do
    y := y * x + Float(coeffs[i]);
  od;
  return y;
end );

BindGlobal("FRPFApproxFromMatrix@", function(mat)
  local r, v, w, i, j, k, sumw, lam, prev, maxIter, tol;
  r := Length(mat);
  if r = 0 then
    return 0.0;
  fi;
  if r = 1 then
    return Float(mat[1][1]);
  fi;
  v := List([1..r], i -> 1.0);
  v := List(v, x -> x / Float(r));
  prev := 0.0;
  tol := 1.0e-12;
  maxIter := 400;
  for i in [1..maxIter] do
    w := List([1..r], j -> 0.0);
    for j in [1..r] do
      for k in [1..r] do
        w[j] := w[j] + Float(mat[j][k]) * v[k];
      od;
      # Power iteration on A + I improves convergence for periodic nonnegative matrices.
      w[j] := w[j] + v[j];
    od;
    sumw := Sum(w);
    if sumw = 0.0 then
      return 0.0;
    fi;
    v := List(w, x -> x / sumw);
    lam := sumw - 1.0;
    if i > 1 and AbsoluteValue(lam - prev) < tol then
      return lam;
    fi;
    prev := lam;
  od;
  return prev;
end );

BindGlobal("FRRoundFloatDigits@", function(x, digits)
  local s, m;
  if digits < 0 then
    Error("digits must be nonnegative");
  fi;
  s := 10.0^digits;
  if x >= 0.0 then
    m := Int(x * s + 0.5);
  else
    m := -Int(-x * s + 0.5);
  fi;
  return m / s;
end );

InstallMethod(FPDimensionData, [ IsFusionRing ], function(F)
  local labels, out, idx, mat, charpoly, factors, approx, best, bestAbs, f, val, entry, deg, K, root;
  labels := LabelsList(F);
  out := [];
  for idx in [1..Length(labels)] do
    mat := FusionMatrix(F, labels[idx]);
    charpoly := CharacteristicPolynomial(mat);
    factors := Factors(charpoly);
    if factors = [] then
      factors := [ charpoly ];
    fi;
    approx := FRPFApproxFromMatrix@(mat);
    best := factors[1];
    bestAbs := AbsoluteValue(FRPolyEvalFloat@(best, approx));
    for f in factors do
      val := AbsoluteValue(FRPolyEvalFloat@(f, approx));
      if val < bestAbs then
        best := f;
        bestAbs := val;
      fi;
    od;
    deg := DegreeOfLaurentPolynomial(best);
    if deg = 1 then
      root := -CoefficientsOfUnivariatePolynomial(best)[1];
    else
      K := AlgebraicExtension(Rationals, best, Concatenation("fp", String(idx)));
      root := RootOfDefiningPolynomial(K);
    fi;
    entry := rec(
      label := labels[idx],
      root := root,
      polynomial := best,
      charpoly := charpoly,
      approx := approx
    );
    Add(out, entry);
  od;
  return Immutable(out);
end );

InstallMethod(FPDimensions, [ IsFusionRing ], function(F)
  return Immutable(List(FPDimensionData(F), x -> x.root));
end );

InstallMethod(FPDimensionPolynomials, [ IsFusionRing ], function(F)
  return Immutable(List(FPDimensionData(F), x -> x.polynomial));
end );

InstallMethod(FPDimensionPolynomial, [ IsFusionRing, IsObject ], function(F, label)
  local p, data;
  p := PositionOfLabel(F, label);
  if p = fail then
    Error("label not in fusion ring");
  fi;
  data := FPDimensionData(F);
  return data[p].polynomial;
end );

InstallMethod(FPDimensionApprox, [ IsFusionRing, IsObject ], function(F, label)
  local p, data;
  p := PositionOfLabel(F, label);
  if p = fail then
    Error("label not in fusion ring");
  fi;
  data := FPDimensionData(F);
  return data[p].approx;
end );

InstallMethod(FPDimensionApprox, [ IsFusionRing, IsObject, IsInt ], function(F, label, digits)
  return FRRoundFloatDigits@(FPDimensionApprox(F, label), digits);
end );

InstallGlobalFunction(FPDimensionsApprox, function(arg)
  local F, digits, vals;
  if Length(arg) = 1 then
    F := arg[1];
    digits := fail;
  elif Length(arg) = 2 then
    F := arg[1];
    digits := arg[2];
    if not IsInt(digits) or digits < 0 then
      Error("digits must be a nonnegative integer");
    fi;
  else
    Error("FPDimensionsApprox expects (F[, digits])");
  fi;
  vals := List(FPDimensionData(F), x -> x.approx);
  if digits = fail then
    return vals;
  fi;
  return List(vals, x -> FRRoundFloatDigits@(x, digits));
end );

InstallMethod(FPRank, [ IsFusionRing ], F -> Length(LabelsList(F)));
InstallOtherMethod(Rank, [ IsFusionRing ], F -> FPRank(F));

InstallMethod(GlobalFPDimension, [ IsFusionRing ], function(F)
  return Sum(FPDimensions(F), d -> d^2);
end );

InstallMethod(FPType, [ IsFusionRing ], function(F)
  local data, pairs;
  data := FPDimensionData(F);
  pairs := List([1..Length(data)], i -> [ data[i].approx, data[i].root ]);
  SortBy(pairs, p -> p[1]);
  return Immutable(List(pairs, p -> p[2]));
end );

InstallGlobalFunction(FPTypeApprox, function(arg)
  local F, digits, data, pairs, vals;
  if Length(arg) = 1 then
    F := arg[1];
    digits := fail;
  elif Length(arg) = 2 then
    F := arg[1];
    digits := arg[2];
    if not IsInt(digits) or digits < 0 then
      Error("digits must be a nonnegative integer");
    fi;
  else
    Error("FPTypeApprox expects (F[, digits])");
  fi;
  data := FPDimensionData(F);
  pairs := List([1..Length(data)], i -> [ data[i].approx, data[i].approx ]);
  SortBy(pairs, p -> p[1]);
  vals := List(pairs, p -> p[2]);
  if digits = fail then
    return vals;
  fi;
  return List(vals, x -> FRRoundFloatDigits@(x, digits));
end );

InstallMethod(IsIntegralFusionRing, [ IsFusionRing ], function(F)
  local p, coeffs;
  for p in FPDimensionPolynomials(F) do
    if DegreeOfLaurentPolynomial(p) <> 1 then
      return false;
    fi;
    coeffs := CoefficientsOfUnivariatePolynomial(p);
    if Length(coeffs) <> 2 or coeffs[2] <> 1 or not IsInt(-coeffs[1]) then
      return false;
    fi;
  od;
  return true;
end );

InstallMethod(IsWeaklyIntegralFusionRing, [ IsFusionRing ], function(F)
  local s, n;
  s := Sum(FPDimensionData(F), x -> x.approx^2);
  n := Int(s + 0.5);
  return AbsoluteValue(s - n) < 1.0e-8;
end );

InstallMethod(FormalCodegrees, [ IsFusionRing ], function(F)
  local mats, A, i, p, fac, out, f, exp, deg, coeffs, root, K;
  mats := FusionMatrices(F);
  A := NullMat(Length(mats), Length(mats));
  for i in [1..Length(mats)] do
    A := A + mats[i] * TransposedMat(mats[i]);
  od;
  p := CharacteristicPolynomial(A);
  fac := Collected(Factors(p));
  out := [];
  for i in [1..Length(fac)] do
    f := fac[i][1];
    exp := fac[i][2];
    deg := DegreeOfLaurentPolynomial(f);
    if deg = 1 then
      coeffs := CoefficientsOfUnivariatePolynomial(f);
      root := -coeffs[1];
    else
      K := AlgebraicExtension(Rationals, f, Concatenation("fc", String(i)));
      root := RootOfDefiningPolynomial(K);
    fi;
    if IsRat(root) then
      Add(out, rec(value := root, polynomial := f, multiplicity := exp, approx := Float(root)));
    else
      Add(out, rec(value := root, polynomial := f, multiplicity := exp, approx := 0.0));
    fi;
  od;
  SortBy(out, x -> -x.approx);
  return Immutable(out);
end );

BindGlobal("FRIsCommutativeFusionRing@", function(F)
  local labels, i, j;
  labels := LabelsList(F);
  for i in labels do
    for j in labels do
      if MultiplyBasis(F, i, j) <> MultiplyBasis(F, j, i) then
        return false;
      fi;
    od;
  od;
  return true;
end );

BindGlobal("FRIsDNumberPolynomial@", function(p)
  local n, coeffs, b0, i, bi;
  if not IsUnivariatePolynomial(p) then
    return false;
  fi;
  coeffs := CoefficientsOfUnivariatePolynomial(p);
  n := DegreeOfLaurentPolynomial(p);
  if n < 0 then
    return false;
  fi;
  if coeffs[n + 1] <> 1 then
    return false;
  fi;
  if not ForAll(coeffs, IsInt) then
    return false;
  fi;
  b0 := coeffs[1];
  if b0 = 0 then
    return false;
  fi;
  for i in [1..n] do
    bi := coeffs[n - i + 1];
    if (bi^n) mod (b0^i) <> 0 then
      return false;
    fi;
  od;
  return true;
end );

InstallGlobalFunction(CheckDNumberCriterionCommutative, function(F)
  local out, fc, i;
  out := rec(applicable := true, ok := true, failures := [], details := []);
  if not IsFusionRing(F) then
    Error("CheckDNumberCriterionCommutative expects a fusion ring");
  fi;
  if not FRIsCommutativeFusionRing@(F) then
    out.applicable := false;
    out.ok := false;
    Add(out.failures, "ring is non-commutative");
    return out;
  fi;
  fc := FormalCodegrees(F);
  for i in [1..Length(fc)] do
    Add(out.details, rec(index := i, polynomial := fc[i].polynomial,
                         isDNumber := FRIsDNumberPolynomial@(fc[i].polynomial)));
    if not out.details[Length(out.details)].isDNumber then
      out.ok := false;
      Add(out.failures, Concatenation("formal codegree polynomial #", String(i),
          " fails d-number divisibility test"));
    fi;
  od;
  return out;
end );

InstallGlobalFunction(CheckDrinfeldCriterionCommutative, function(F)
  local out, fc, c1, i, ratio;
  out := rec(applicable := true, ok := true, failures := [], mode := "exact-rational");
  if not IsFusionRing(F) then
    Error("CheckDrinfeldCriterionCommutative expects a fusion ring");
  fi;
  if not FRIsCommutativeFusionRing@(F) then
    out.applicable := false;
    out.ok := false;
    Add(out.failures, "ring is non-commutative");
    return out;
  fi;
  fc := FormalCodegrees(F);
  if Length(fc) = 0 then
    out.ok := false;
    Add(out.failures, "no formal codegrees available");
    return out;
  fi;
  c1 := fc[1].value;
  if not IsRat(c1) then
    out.mode := "unknown-nonrational";
    out.applicable := false;
    out.ok := false;
    Add(out.failures, "top codegree is non-rational; exact ratio test not implemented");
    return out;
  fi;
  for i in [1..Length(fc)] do
    if not IsRat(fc[i].value) then
      out.mode := "unknown-nonrational";
      out.applicable := false;
      out.ok := false;
      Add(out.failures, Concatenation("codegree #", String(i),
          " is non-rational; exact ratio test not implemented"));
      return out;
    fi;
    ratio := c1 / fc[i].value;
    if not IsInt(ratio) then
      out.ok := false;
      Add(out.failures, Concatenation("c1/c", String(i), " is not an integer"));
    fi;
  od;
  return out;
end );

InstallGlobalFunction(CheckExtendedCyclotomicCriterionCommutative, function(F)
  local out, mats, i, p;
  out := rec(applicable := true, ok := true, failures := [], mode := "conservative");
  if not IsFusionRing(F) then
    Error("CheckExtendedCyclotomicCriterionCommutative expects a fusion ring");
  fi;
  if not FRIsCommutativeFusionRing@(F) then
    out.applicable := false;
    out.ok := false;
    Add(out.failures, "ring is non-commutative");
    return out;
  fi;
  mats := FusionMatrices(F);
  for i in [1..Length(mats)] do
    p := MinimalPolynomial(Rationals, mats[i], 1);
    if not IsUnivariatePolynomial(p) then
      out.ok := false;
      Add(out.failures, Concatenation("minimal polynomial unavailable for matrix #", String(i)));
      return out;
    fi;
    # Conservative implementation: degree-1 and degree-2 factors are treated as cyclotomic-compatible.
    # Higher degrees are marked unknown unless dedicated number-field checks are added.
    if DegreeOfLaurentPolynomial(p) > 2 then
      out.mode := "unknown-high-degree";
      out.applicable := false;
      out.ok := false;
      Add(out.failures, Concatenation("matrix #", String(i),
          " has degree > 2 minimal polynomial; exact abelian splitting-field check not yet implemented"));
      return out;
    fi;
  od;
  return out;
end );

InstallGlobalFunction(CheckPaperCriteriaCommutative, function(F)
  return rec(
    dNumber := CheckDNumberCriterionCommutative(F),
    drinfeld := CheckDrinfeldCriterionCommutative(F),
    cyclotomic := CheckExtendedCyclotomicCriterionCommutative(F)
  );
end );

InstallMethod(IsInternallyConsistent, [ IsFusionRing ], function(F)
  local one, labels, i, sample, prod, term;
  one := OneLabel(F);
  labels := LabelsList(F);
  if Position(labels, one) = fail then
    return false;
  fi;
  if DualLabel(F, one) <> one then
    return false;
  fi;
  sample := labels;
  if Length(sample) > 10 then
    sample := sample{[1..10]};
  fi;
  for i in sample do
    if Position(labels, DualLabel(F, i)) = fail then
      return false;
    fi;
    prod := MultiplyBasis(F, i, one);
    for term in prod do
      if Position(labels, term[1]) = fail then
        return false;
      fi;
      if not IsInt(term[2]) or term[2] < 0 then
        return false;
      fi;
    od;
  od;
  return true;
end );

InstallMethod(CheckFusionRingAxioms, [ IsFusionRing, IsInt ], function(F, level)
  local labels, one, i, j, k, l, left, right, prod, term, r, di, mats, mi, mj, lhs, rhs;
  if level <= 0 then
    return IsInternallyConsistent(F);
  fi;
  labels := LabelsList(F);
  one := OneLabel(F);
  if not IsInternallyConsistent(F) then
    return false;
  fi;
  r := Length(labels);
  for i in labels do
    if MultiplyBasis(F, one, i) <> [ [ i, 1 ] ] then
      return false;
    fi;
    if MultiplyBasis(F, i, one) <> [ [ i, 1 ] ] then
      return false;
    fi;
    di := DualLabel(F, i);
    if DualLabel(F, di) <> i then
      return false;
    fi;
    if FusionCoefficient(F, i, di, one) <> 1 then
      return false;
    fi;
    if r <= 50 then
      for k in labels do
        if k = di then
          if FusionCoefficient(F, i, k, one) <> 1 then
            return false;
          fi;
        else
          if FusionCoefficient(F, i, k, one) <> 0 then
            return false;
          fi;
        fi;
      od;
    fi;
  od;
  for i in labels do
    for j in labels do
      if r <= 50 then
        for k in labels do
          if FusionCoefficient(F, i, j, k) <> FusionCoefficient(F, DualLabel(F, i), k, j) then
            return false;
          fi;
          if FusionCoefficient(F, i, j, k) <> FusionCoefficient(F, k, DualLabel(F, j), i) then
            return false;
          fi;
        od;
      else
        prod := MultiplyBasis(F, i, j);
        for term in prod do
          k := term[1];
          if term[2] <> FusionCoefficient(F, DualLabel(F, i), k, j)
            or term[2] <> FusionCoefficient(F, k, DualLabel(F, j), i) then
            return false;
          fi;
        od;
      fi;
    od;
  od;
  if level < 2 then
    return true;
  fi;
  if HasFusionMatrices(F) then
    mats := FusionMatrices(F);
    for i in [1..r] do
      mi := mats[i];
      for j in [1..r] do
        mj := mats[j];
        lhs := mi * mj;
        rhs := NullMat(r, r);
        prod := MultiplyBasis(F, labels[i], labels[j]);
        for term in prod do
          k := Position(labels, term[1]);
          rhs := rhs + term[2] * mats[k];
        od;
        if lhs <> rhs then
          return false;
        fi;
      od;
    od;
  else
    for i in labels do
      for j in labels do
        for l in labels do
          left := FRMultiplyComboByLabel@(F, MultiplyBasis(F, i, j), l);
          right := FRMultiplyLabelByCombo@(F, i, MultiplyBasis(F, j, l));
          if left <> right then
            return false;
          fi;
        od;
      od;
    od;
  fi;
  return true;
end );

InstallGlobalFunction(CheckFusionRingAxiomsSample, function(F, level, samples)
  local labels, r, pick, one, i, j, k, l, left, right, term, prod, di, s;
  if not IsInt(samples) or samples <= 0 then
    Error("samples must be a positive integer");
  fi;
  labels := LabelsList(F);
  r := Length(labels);
  pick := function()
    return labels[Random([1..r])];
  end;
  one := OneLabel(F);
  if level <= 0 then
    return IsInternallyConsistent(F);
  fi;
  # Level 1 sampled checks
  for s in [1..samples] do
    i := pick();
    j := pick();
    k := pick();
    di := DualLabel(F, i);
    if MultiplyBasis(F, one, i) <> [ [ i, 1 ] ] then return false; fi;
    if MultiplyBasis(F, i, one) <> [ [ i, 1 ] ] then return false; fi;
    if DualLabel(F, di) <> i then return false; fi;
    if FusionCoefficient(F, i, di, one) <> 1 then return false; fi;
    # Frobenius reciprocity samples
    if FusionCoefficient(F, i, j, k) <> FusionCoefficient(F, DualLabel(F, i), k, j) then
      return false;
    fi;
    if FusionCoefficient(F, i, j, k) <> FusionCoefficient(F, k, DualLabel(F, j), i) then
      return false;
    fi;
  od;
  if level < 2 then
    return true;
  fi;
  # Level 2 associativity samples
  for s in [1..samples] do
    i := pick();
    j := pick();
    l := pick();
    left := FRMultiplyComboByLabel@(F, MultiplyBasis(F, i, j), l);
    right := FRMultiplyLabelByCombo@(F, i, MultiplyBasis(F, j, l));
    if left <> right then
      return false;
    fi;
  od;
  return true;
end );

BindGlobal("FRInferDual@", function(labels, one, mult)
  local dual, i, k, prod, c, found, term;
  dual := [];
  for i in labels do
    found := fail;
    for k in labels do
      prod := mult(i, k);
      c := 0;
      if prod <> fail then
        c := 0;
        for term in prod do
          if term[1] = one then
            c := term[2];
            break;
          fi;
        od;
      fi;
      if c = 1 then
        found := k;
        break;
      fi;
    od;
    if found = fail then
      return fail;
    fi;
    Add(dual, found);
  od;
  return dual;
end );

BindGlobal("FRBuildType@", function(rep)
  if rep = "rule" then
    return IsFusionRingByRuleRep;
  elif rep = "sparse" then
    return IsFusionRingBySparseRep;
  elif rep = "matrices" then
    return IsFusionRingByMatricesRep;
  fi;
  Error("unknown representation");
end );

BindGlobal("FRMaybeImmutable@", function(x, makeImmutable)
  if makeImmutable and IsCopyable(x) then
    return Immutable(x);
  fi;
  return x;
end );

InstallGlobalFunction(FusionRingByRule, function(I, one, dual, mult, opts)
  local o, labels, F, d, multf;
  o := FRParseOpts@(opts);
  labels := fail;
  if o.inferDual or o.buildIndex then
    labels := FRLabelsListFromI@(I);
  fi;
  multf := mult;
  if dual = fail and o.inferDual then
    d := FRInferDual@(labels, one, multf);
    if d = fail then Error("cannot infer dual"); fi;
    dual := d;
  fi;
  I := FRMaybeImmutable@(I, o.makeImmutable);
  dual := FRMaybeImmutable@(dual, o.makeImmutable);
  F := Objectify(FRFusionRingRuleType@, rec(I := I, one := one, dual := dual, mult := multf));
  if o.buildIndex then
    F!.labels := Immutable(labels);
    if IsBound(SetLabelsList) then
      SetLabelsList(F, F!.labels);
    fi;
  fi;
  if o.makeImmutable then
    MakeImmutable(F);
  fi;
  if o.check > 0 then
    if not CheckFusionRingAxioms(F, o.check) then
      Error("fusion ring axioms failed");
    fi;
  fi;
  return F;
end );

InstallGlobalFunction(FusionRingBySparseConstants, function(I, one, dual, prodTable, opts)
  local o, labels, F, d;
  o := FRParseOpts@(opts);
  labels := fail;
  if o.inferDual or o.buildIndex then
    labels := FRLabelsListFromI@(I);
  fi;
  if dual = fail and o.inferDual then
    d := FRInferDual@(labels, one, function(i, j)
      local out;
      out := FRLookupProdTable@(prodTable, i, j);
      if out = fail then return []; fi;
      return out;
    end );
    if d = fail then Error("cannot infer dual"); fi;
    dual := d;
  fi;
  I := FRMaybeImmutable@(I, o.makeImmutable);
  dual := FRMaybeImmutable@(dual, o.makeImmutable);
  prodTable := FRMaybeImmutable@(prodTable, o.makeImmutable);
  F := Objectify(FRFusionRingSparseType@, rec(I := I, one := one, dual := dual, prodTable := prodTable));
  if o.buildIndex then
    F!.labels := Immutable(labels);
    if IsBound(SetLabelsList) then
      SetLabelsList(F, F!.labels);
    fi;
  fi;
  if o.makeImmutable then
    MakeImmutable(F);
  fi;
  if o.check > 0 then
    if not CheckFusionRingAxioms(F, o.check) then
      Error("fusion ring axioms failed");
    fi;
  fi;
  return F;
end );

InstallGlobalFunction(FusionRingByFusionMatrices, function(labels, one, dual, fusionMatrices, opts)
  local o, F, d;
  o := FRParseOpts@(opts);
  if not IsList(labels) then
    Error("labels must be a list");
  fi;
  if not IsSSortedList(labels) then
    Error("labels must be strictly sorted");
  fi;
  if dual = fail and o.inferDual then
    d := FRInferDual@(labels, one, function(i, j)
      local pi, pj, mat, k, out, n;
      pi := Position(labels, i);
      pj := Position(labels, j);
      if pi = fail or pj = fail then return []; fi;
      mat := fusionMatrices[pi];
      out := [];
      for k in [1..Length(labels)] do
        n := mat[pj][k];
        if n <> 0 then
          Add(out, [ labels[k], n ]);
        fi;
      od;
      return out;
    end );
    if d = fail then Error("cannot infer dual"); fi;
    dual := d;
  fi;
  labels := Immutable(labels);
  fusionMatrices := FRMaybeImmutable@(fusionMatrices, o.makeImmutable);
  dual := FRMaybeImmutable@(dual, o.makeImmutable);
  F := Objectify(FRFusionRingMatricesType@, rec(I := labels, one := one, dual := dual, fusionMatrices := fusionMatrices));
  if o.buildIndex then
    F!.labels := labels;
    if IsBound(SetLabelsList) then
      SetLabelsList(F, F!.labels);
    fi;
  fi;
  if o.makeImmutable then
    MakeImmutable(F);
  fi;
  if o.check > 0 then
    if not CheckFusionRingAxioms(F, o.check) then
      Error("fusion ring axioms failed");
    fi;
  fi;
  return F;
end );

InstallGlobalFunction(FusionRing, function(I, one, dual, multOrData, opts)
  local o, rep;
  o := FRParseOpts@(opts);
  rep := o.storeRepresentation;
  if rep = fail then
    if IsFunction(multOrData) then
      rep := "rule";
    elif IsList(multOrData) and Length(multOrData) > 0 and ForAll(multOrData, IsMatrix) then
      rep := "matrices";
    else
      rep := "sparse";
    fi;
  fi;
  if rep = "rule" then
    return FusionRingByRule(I, one, dual, multOrData, o);
  elif rep = "sparse" then
    return FusionRingBySparseConstants(I, one, dual, multOrData, o);
  elif rep = "matrices" then
    return FusionRingByFusionMatrices(I, one, dual, multOrData, o);
  fi;
  Error("unknown representation");
end );

InstallGlobalFunction(PointedFusionRing, function(G)
  local I, one, dual, mult;
  I := G;
  one := One(G);
  dual := function(g) return g^-1; end;
  mult := function(g, h) return [ [ g*h, 1 ] ]; end;
  return FusionRingByRule(I, one, dual, mult, rec(check := 0));
end );

InstallGlobalFunction(CyclicPointedFusionRing, function(n)
  if not IsInt(n) or n <= 0 then
    Error("n must be a positive integer");
  fi;
  return PointedFusionRing(CyclicGroup(n));
end );

InstallGlobalFunction(FibonacciFusionRing, function()
  local labels, prodTable, dual, F;
  labels := [ "1", "x" ];
  prodTable := [
    [ "1", "1", [ [ "1", 1 ] ] ],
    [ "1", "x", [ [ "x", 1 ] ] ],
    [ "x", "1", [ [ "x", 1 ] ] ],
    [ "x", "x", [ [ "1", 1 ], [ "x", 1 ] ] ]
  ];
  dual := [ "1", "x" ];
  F := FusionRingBySparseConstants(labels, "1", dual, prodTable, rec(check := 1));
  return F;
end );

InstallGlobalFunction(IsingFusionRing, function()
  local labels, prodTable, dual, F;
  labels := [ "1", "psi", "sigma" ];
  prodTable := [
    [ "1", "1", [ [ "1", 1 ] ] ],
    [ "1", "psi", [ [ "psi", 1 ] ] ],
    [ "psi", "1", [ [ "psi", 1 ] ] ],
    [ "1", "sigma", [ [ "sigma", 1 ] ] ],
    [ "sigma", "1", [ [ "sigma", 1 ] ] ],
    [ "psi", "psi", [ [ "1", 1 ] ] ],
    [ "psi", "sigma", [ [ "sigma", 1 ] ] ],
    [ "sigma", "psi", [ [ "sigma", 1 ] ] ],
    [ "sigma", "sigma", [ [ "1", 1 ], [ "psi", 1 ] ] ]
  ];
  dual := [ "1", "psi", "sigma" ];
  F := FusionRingBySparseConstants(labels, "1", dual, prodTable, rec(check := 1));
  return F;
end );

InstallGlobalFunction(TambaraYamagamiFusionRing, function(A)
  local one, m, mult, dual, labels, F, opts, alist, I;
  if not IsDomain(A) or not IsFinite(A) then
    Error("A must be a finite group/domain");
  fi;
  one := One(A);
  m := rec(name := "m");
  MakeImmutable(m);
  alist := AsSortedList(A);
  mult := function(x, y)
    if IsIdenticalObj(x, m) and IsIdenticalObj(y, m) then
      return List(alist, a -> [ a, 1 ]);
    fi;
    if IsIdenticalObj(x, m) then
      return [ [ m, 1 ] ];
    fi;
    if IsIdenticalObj(y, m) then
      return [ [ m, 1 ] ];
    fi;
    return [ [ x*y, 1 ] ];
  end;
  dual := function(x)
    if IsIdenticalObj(x, m) then
      return m;
    fi;
    return x^-1;
  end;
  opts := rec(check := 0, buildIndex := false);
  I := Concatenation(alist, [ m ]);
  F := FusionRingByRule(I, one, dual, mult, opts);
  labels := Concatenation(alist, [ m ]);
  F!.labels := Immutable(labels);
  if IsBound(SetLabelsList) then
    SetLabelsList(F, F!.labels);
  fi;
  F!.tym := m;
  if IsBound(SetTYMLabel) then
    SetTYMLabel(F, m);
  fi;
  return F;
end );


InstallGlobalFunction(NearGroupFusionRing, function(G, k)
  local one, rho, mult, dual, labels, F, opts, glist, I;
  if not IsDomain(G) or not IsFinite(G) then
    Error("G must be a finite group/domain");
  fi;
  if not IsInt(k) or k < 0 then
    Error("k must be a nonnegative integer");
  fi;
  one := One(G);
  rho := rec(name := "rho");
  MakeImmutable(rho);
  glist := AsSortedList(G);
  mult := function(x, y)
    if IsIdenticalObj(x, rho) and IsIdenticalObj(y, rho) then
      return Concatenation(List(glist, g -> [ g, 1 ]), [ [ rho, k ] ]);
    fi;
    if IsIdenticalObj(x, rho) then
      return [ [ rho, 1 ] ];
    fi;
    if IsIdenticalObj(y, rho) then
      return [ [ rho, 1 ] ];
    fi;
    return [ [ x*y, 1 ] ];
  end;
  dual := function(x)
    if IsIdenticalObj(x, rho) then
      return rho;
    fi;
    return x^-1;
  end;
  opts := rec(check := 0, buildIndex := false);
  I := Concatenation(glist, [ rho ]);
  F := FusionRingByRule(I, one, dual, mult, opts);
  labels := Concatenation(glist, [ rho ]);
  F!.labels := Immutable(labels);
  if IsBound(SetLabelsList) then
    SetLabelsList(F, F!.labels);
  fi;
  F!.ngrho := rho;
  if IsBound(SetNGRhoLabel) then
    SetNGRhoLabel(F, rho);
  fi;
  return F;
end );

# Export / import
InstallGlobalFunction(FusionRingRecord, function(F)
  local rep, labels, one, dual, recdata;
  rep := RepresentationType(F);
  labels := LabelsList(F);
  one := OneLabel(F);
  dual := DualTable(F);
  if rep = "rule" then
    Error("FusionRingRecord: rule-based representation is not serializable");
  elif rep = "sparse" then
    recdata := rec(
      rep := rep,
      labels := labels,
      one := one,
      dual := dual,
      prodTable := F!.prodTable
    );
  elif rep = "matrices" then
    recdata := rec(
      rep := rep,
      labels := labels,
      one := one,
      dual := dual,
      fusionMatrices := F!.fusionMatrices
    );
  else
    Error("FusionRingRecord: unknown representation");
  fi;
  return recdata;
end );

InstallGlobalFunction(FusionRingFromRecord, function(r)
  if not IsRecord(r) or not IsBound(r.rep) then
    Error("FusionRingFromRecord: invalid record");
  fi;
  if r.rep = "sparse" then
    return FusionRingBySparseConstants(r.labels, r.one, r.dual, r.prodTable, rec(check := 0));
  elif r.rep = "matrices" then
    return FusionRingByFusionMatrices(r.labels, r.one, r.dual, r.fusionMatrices, rec(check := 0));
  fi;
  Error("FusionRingFromRecord: unsupported rep");
end );

InstallGlobalFunction(SaveFusionRing, function(filename, F)
  local r;
  r := FusionRingRecord(F);
  PrintTo(filename, "return ", r, ";\n");
  return true;
end );

InstallGlobalFunction(LoadFusionRing, function(filename)
  local f;
  f := ReadAsFunction(filename);
  return FusionRingFromRecord(f());
end );

# Fallback methods for direct-loading (attribute getters may be unavailable)
InstallMethod(LabelsList, [ IsFusionRing ], function(F)
  if IsBound(F!.labels) then
    return F!.labels;
  fi;
  return FRLabelsListFromI@(F!.I);
end );

InstallMethod(TYMLabel, [ IsFusionRing ], function(F)
  if IsBound(F!.tym) then
    return F!.tym;
  fi;
  return fail;
end );

InstallMethod(NGRhoLabel, [ IsFusionRing ], function(F)
  if IsBound(F!.ngrho) then
    return F!.ngrho;
  fi;
  return fail;
end );
