if not IsBound(MDModularDataFamily@) then
  BindGlobal("MDModularDataFamily@", NewFamily("ModularDataFamily", IsModularData));
  BindGlobal("MDModularDataType@", NewType(MDModularDataFamily@, IsModularDataRep));
fi;

BindGlobal("MDMakeDiagonalMat@", function(diag)
  local r, mat, i;
  if not IsList(diag) then
    Error("diag must be a list");
  fi;
  r := Length(diag);
  mat := NullMat(r, r);
  for i in [1..r] do
    mat[i][i] := diag[i];
  od;
  return mat;
end );

BindGlobal("MDOrderFromSpins@", function(s)
  local denoms, i;
  if not IsList(s) then
    Error("s must be a list");
  fi;
  denoms := [];
  for i in s do
    if IsRat(i) then
      Add(denoms, DenominatorRat(i));
    else
      Error("spin entries must be rational for order computation");
    fi;
  od;
  if Length(denoms) = 0 then
    return 1;
  fi;
  return Lcm(denoms);
end );

BindGlobal("MDThetaFromSpins@", function(s)
  local N, theta, i, exp;
  N := MDOrderFromSpins@(s);
  theta := [];
  for i in s do
    exp := N * i;
    if not IsInt(exp) then
      Error("spin denominators do not divide the computed order");
    fi;
    Add(theta, E(N)^exp);
  od;
  return rec(order := N, theta := theta);
end );

BindGlobal("MDSFromNsd@", function(N, d, theta)
  local r, S, i, j, k, sum;
  if not IsList(N) or not IsList(d) or not IsList(theta) then
    Error("N, d, theta must be lists");
  fi;
  r := Length(d);
  S := NullMat(r, r);
  for i in [1..r] do
    for j in [1..r] do
      sum := 0;
      for k in [1..r] do
        if N[i][j][k] <> 0 then
          sum := sum + N[i][j][k] * (theta[i] * theta[j] / theta[k]) * d[k];
        fi;
      od;
      S[i][j] := sum;
    od;
  od;
  return S;
end );

BindGlobal("MDVerlindeSU2@", function(level)
  local k, r, q, denom, S, T, a, b, exp, labels;
  if not IsInt(level) or level < 1 then
    Error("level must be a positive integer");
  fi;
  k := level;
  r := k + 1;
  q := E(2 * (k + 2)); # exp(pi i / (k+2))
  denom := q - q^-1;
  S := NullMat(r, r);
  for a in [0..k] do
    for b in [0..k] do
      exp := (a + 1) * (b + 1);
      S[a + 1][b + 1] := (q^exp - q^(-exp)) / denom;
    od;
  od;
  T := NullMat(r, r);
  for a in [0..k] do
    T[a + 1][a + 1] := E(4 * (k + 2))^(a * (a + 2));
  od;
  labels := [0..k];
  return ModularDataFromST(S, T, labels, rec(inferN := true, completeData := true));
end );

InstallMethod(SMatrix, [ IsModularData ], F -> F!.S );
InstallMethod(TMatrix, [ IsModularData ], F -> F!.T );
InstallMethod(MDLabels, [ IsModularData ], F -> F!.labels );
InstallMethod(MDTwists, [ IsModularData ], F -> F!.theta );
InstallMethod(MDSpins, [ IsModularData ], F -> F!.s );
InstallMethod(MDQuantumDimensions, [ IsModularData ], F -> F!.d );
InstallMethod(MDGlobalDimensionSquared, [ IsModularData ], F -> F!.D2 );
InstallMethod(MDFusionCoefficients, [ IsModularData ], F -> F!.N );
InstallMethod(MDOrderT, [ IsModularData ], F -> F!.ordT );

BindGlobal("MDInferNFromST@", function(S, T)
  local r, d, D2, i, j, k, a, sum, Ncalc, tmp;
  r := Length(S);
  d := List([1..r], i -> S[1][i]);
  D2 := Sum(d, x -> x^2);
  Ncalc := List([1..r], i -> List([1..r], j -> List([1..r], k -> 0)));
  for i in [1..r] do
    for j in [1..r] do
      for k in [1..r] do
        sum := 0;
        for a in [1..r] do
          sum := sum + S[i][a] * S[j][a] * S[k][a] / S[1][a];
        od;
        tmp := sum / D2;
        if not IsInt(tmp) or tmp < 0 then
          return fail;
        fi;
        Ncalc[i][j][k] := tmp;
      od;
    od;
  od;
  return Ncalc;
end );

BindGlobal("MDCompleteFromST@", function(F, inferN)
  local r, i, ord, Ncalc, th;
  r := Length(F!.S);
  F!.d := List([1..r], i -> F!.S[1][i]);
  F!.D2 := Sum(F!.d, x -> x^2);
  F!.theta := List([1..r], i -> F!.T[i][i]);
  ord := 1;
  for i in [1..r] do
    ord := Lcm(ord, Order(F!.theta[i]));
  od;
  F!.ordT := ord;
  if inferN then
    Ncalc := MDInferNFromST@(F!.S, F!.T);
    if Ncalc <> fail then
      F!.N := Ncalc;
    fi;
  fi;
  if F!.theta <> fail then
    th := List([1..r], i -> F!.theta[i]);
    F!.s := fail;
    if IsBoundGlobal("LogFFE") then
      # Leave spins unset by default; exact roots may not map cleanly to rationals.
      F!.s := fail;
    fi;
  fi;
end );

InstallGlobalFunction(ModularDataFromST, function(arg)
  local S, T, labels, opts, r, F, inferN;
  if Length(arg) < 2 or Length(arg) > 4 then
    Error("ModularDataFromST expects (S, T[, labels][, opts])");
  fi;
  S := arg[1];
  T := arg[2];
  labels := fail;
  opts := rec(inferN := false, completeData := true);
  if Length(arg) >= 3 then
    if IsRecord(arg[3]) then
      opts := ShallowCopy(opts);
      if IsBound(arg[3].inferN) then opts.inferN := arg[3].inferN; fi;
      if IsBound(arg[3].completeData) then opts.completeData := arg[3].completeData; fi;
    else
      labels := arg[3];
    fi;
  fi;
  if Length(arg) = 4 then
    if not IsRecord(arg[4]) then
      Error("fourth argument must be an options record");
    fi;
    opts := ShallowCopy(opts);
    if IsBound(arg[4].inferN) then opts.inferN := arg[4].inferN; fi;
    if IsBound(arg[4].completeData) then opts.completeData := arg[4].completeData; fi;
  fi;
  if not IsList(S) then
    Error("S must be a list (matrix)");
  fi;
  r := Length(S);
  if labels = fail or labels = [] then
    labels := [1..r];
  fi;
  F := Objectify(MDModularDataType@, rec(
    S := S,
    T := T,
    labels := labels,
    N := fail,
    d := fail,
    s := fail,
    theta := fail,
    D2 := fail,
    ordT := fail
  ));
  inferN := false;
  if IsBound(opts.inferN) and opts.inferN = true then
    inferN := true;
  fi;
  if not IsBound(opts.completeData) or opts.completeData = true then
    MDCompleteFromST@(F, inferN);
  fi;
  return F;
end );

InstallGlobalFunction(ModularDataFromNsdRecord, function(mdrec)
  local N, s, d, r, th, theta, S, T, D2, labels, F;
  if not IsRecord(mdrec) then
    Error("record expected");
  fi;
  if not IsBound(mdrec.Nij_k) or not IsBound(mdrec.s) or not IsBound(mdrec.d) then
    Error("record must contain Nij_k, s, d");
  fi;
  N := mdrec.Nij_k;
  s := mdrec.s;
  d := mdrec.d;
  r := Length(d);
  th := MDThetaFromSpins@(s);
  theta := th.theta;
  S := MDSFromNsd@(N, d, theta);
  T := MDMakeDiagonalMat@(theta);
  D2 := Sum(d, x -> x^2);
  labels := [1..r];
  F := Objectify(MDModularDataType@, rec(
    S := S,
    T := T,
    labels := labels,
    N := N,
    d := d,
    s := s,
    theta := theta,
    D2 := D2,
    ordT := th.order
  ));
  return F;
end );

InstallGlobalFunction(ModularData, function(arg)
  local r;
  if Length(arg) = 1 and IsRecord(arg[1]) then
    return ModularDataFromNsdRecord(arg[1]);
  fi;
  if Length(arg) = 2 then
    return ModularDataFromST(arg[1], arg[2], fail);
  fi;
  if Length(arg) = 3 then
    return ModularDataFromST(arg[1], arg[2], arg[3]);
  fi;
  Error("ModularData expects (record) or (S, T[, labels])");
end );

InstallGlobalFunction(ValidateModularData, function(arg)
  local md, level, out, S, T, r, d, D2, I, ok, pplus, pminus, i, j, k, a, sum, Ncalc, Ndata, tmp, Nuse, theta, expected, dual, nu2, Nord, x, col, cols, used, b, match, g, sig, cond, normD2, primesD, primesN, allCycS, allCycT, condS, condT, colsSigned, gm;
  if Length(arg) = 1 then
    md := arg[1];
    level := 3;
  elif Length(arg) = 2 then
    md := arg[1];
    level := arg[2];
  else
    Error("ValidateModularData expects (md[, level])");
  fi;
  if not IsInt(level) or level < 0 then
    Error("level must be a nonnegative integer");
  fi;
  out := rec(ok := true, failures := []);
  if not IsModularData(md) then
    out.ok := false;
    Add(out.failures, "object is not ModularData");
    return out;
  fi;
  if level = 0 then
    return out;
  fi;
  S := SMatrix(md);
  T := TMatrix(md);
  r := Length(S);
  if not IsList(S) or r = 0 or Length(S[1]) <> r then
    out.ok := false;
    Add(out.failures, "S is not square");
  fi;
  if not IsDiagonalMat(T) then
    out.ok := false;
    Add(out.failures, "T is not diagonal");
  fi;
  d := List([1..r], i -> S[1][i]);
  D2 := Sum(d, x -> x^2);
  I := IdentityMat(r);
  if S <> TransposedMat(S) then
    out.ok := false;
    Add(out.failures, "S is not symmetric");
  fi;
  if S * TransposedMat(S) <> D2 * I then
    out.ok := false;
    Add(out.failures, "S is not orthogonal up to D2");
  fi;
  if level < 2 then
    return out;
  fi;
  pplus := Sum([1..r], i -> d[i]^2 * T[i][i]);
  pminus := Sum([1..r], i -> d[i]^2 / T[i][i]);
  if pplus * pminus <> D2 then
    out.ok := false;
    Add(out.failures, "Gauss sum product mismatch");
  fi;
  if (S * T)^3 <> pplus * (S^2) then
    out.ok := false;
    Add(out.failures, "modular equation (ST)^3 mismatch");
  fi;
  if IsBoundGlobal("IsRootOfUnity") then
    if not ValueGlobal("IsRootOfUnity")(pplus / pminus) then
      out.ok := false;
      Add(out.failures, "pplus/pminus is not a root of unity");
    fi;
  fi;
  if level < 3 then
    return out;
  fi;
  Ndata := MDFusionCoefficients(md);
  Ncalc := List([1..r], i -> List([1..r], j -> List([1..r], k -> 0)));
  for i in [1..r] do
    for j in [1..r] do
      for k in [1..r] do
        sum := 0;
        for a in [1..r] do
          sum := sum + S[i][a] * S[j][a] * S[k][a] / S[1][a];
        od;
        Ncalc[i][j][k] := sum / D2;
      od;
    od;
  od;
  if Ndata <> fail then
    if Ncalc <> Ndata then
      out.ok := false;
      Add(out.failures, "Verlinde coefficients do not match stored N");
    fi;
  else
    for i in [1..r] do
      for j in [1..r] do
        for k in [1..r] do
          tmp := Ncalc[i][j][k];
          if not IsInt(tmp) or tmp < 0 then
            out.ok := false;
            Add(out.failures, "Verlinde coefficients not in N");
            i := r; j := r; k := r;
          fi;
        od;
      od;
    od;
  fi;
  if level < 4 then
    return out;
  fi;
  Nuse := Ndata;
  if Nuse = fail then
    Nuse := Ncalc;
  fi;
  theta := List([1..r], i -> T[i][i]);
  for i in [1..r] do
    for j in [1..r] do
      sum := 0;
      for k in [1..r] do
        if Nuse[i][j][k] <> 0 then
          sum := sum + Nuse[i][j][k] * (theta[i] * theta[j] / theta[k]) * d[k];
        fi;
      od;
      expected := sum;
      if expected <> S[i][j] then
        out.ok := false;
        Add(out.failures, "balancing equation mismatch");
        i := r; j := r;
      fi;
    od;
  od;
  if level < 5 then
    return out;
  fi;
  dual := List([1..r], i -> fail);
  for i in [1..r] do
    for j in [1..r] do
      if Nuse[i][j][1] = 1 then
        dual[i] := j;
        break;
      fi;
    od;
  od;
  nu2 := function(k)
    local i, j, s;
    s := 0;
    for i in [1..r] do
      for j in [1..r] do
        if Nuse[i][j][k] <> 0 then
          s := s + Nuse[i][j][k] * d[i] * d[j] * (theta[i]/theta[j])^2;
        fi;
      od;
    od;
    return s / D2;
  end;
  for k in [1..r] do
    if dual[k] = fail then
      out.ok := false;
      Add(out.failures, "dual undefined from N^{1}_{i,i*}=1");
      break;
    fi;
    if k <> dual[k] then
      if nu2(k) <> 0 then
        out.ok := false;
        Add(out.failures, "FS indicator nu2(k) != 0 for non-self-dual");
        break;
      fi;
    else
      if not (nu2(k) = 1 or nu2(k) = -1) then
        out.ok := false;
        Add(out.failures, "FS indicator nu2(k) not ±1 for self-dual");
        break;
      fi;
    fi;
  od;
  if level < 6 then
    return out;
  fi;
  Nord := MDOrderT(md);
  if IsBoundGlobal("Conductor") then
    allCycS := true;
    for i in [1..r] do
      for j in [1..r] do
        x := S[i][j];
        if not IsCyclotomic(x) then
          out.ok := false;
          Add(out.failures, "S has non-cyclotomic entry");
          allCycS := false;
          i := r; j := r;
          break;
        fi;
        cond := ValueGlobal("Conductor")(x);
        if cond <> 0 and (Nord mod cond) <> 0 then
          out.ok := false;
          Add(out.failures, "S entry not in Q_N");
          i := r; j := r;
          break;
        fi;
      od;
    od;
    if allCycS then
      condS := ValueGlobal("Conductor")(Flat(S));
      if condS <> 0 and (Nord mod condS) <> 0 then
        out.ok := false;
        Add(out.failures, "S entries not contained in Q_N (aggregate check)");
      fi;
    fi;
    allCycT := true;
    for i in [1..r] do
      x := T[i][i];
      if not IsCyclotomic(x) then
        out.ok := false;
        Add(out.failures, "T has non-cyclotomic entry");
        allCycT := false;
        break;
      fi;
      cond := ValueGlobal("Conductor")(x);
      if cond <> 0 and (Nord mod cond) <> 0 then
        out.ok := false;
        Add(out.failures, "T entry not in Q_N");
        break;
      fi;
    od;
    if allCycT then
      condT := ValueGlobal("Conductor")(List([1..r], i -> T[i][i]));
      if condT <> 0 and (Nord mod condT) <> 0 then
        out.ok := false;
        Add(out.failures, "T entries not contained in Q_N (aggregate check)");
      fi;
    fi;
  fi;
  cols := List([1..r], a -> List([1..r], i -> S[i][a]));
  colsSigned := Concatenation(cols, List(cols, c -> List(c, x -> -x)));
  if IsBoundGlobal("GaloisMat") then
    gm := ValueGlobal("GaloisMat")(TransposedMat(S));
    for a in [1..Length(gm.mat)] do
      if Position(colsSigned, gm.mat[a]) = fail then
        out.ok := false;
        Add(out.failures, "Galois action does not permute columns (up to sign)");
        break;
      fi;
    od;
  elif IsBoundGlobal("GaloisCyc") then
    for g in [1..Nord] do
      if GcdInt(g, Nord) <> 1 then
        continue;
      fi;
      used := List([1..r], i -> false);
      for a in [1..r] do
        col := List([1..r], i -> ValueGlobal("GaloisCyc")(S[i][a], g));
        match := false;
        for b in [1..r] do
          if used[b] then
            continue;
          fi;
          if col = cols[b] or col = List(cols[b], x -> -x) then
            used[b] := true;
            match := true;
            break;
          fi;
        od;
        if not match then
          out.ok := false;
          Add(out.failures, "Galois action does not permute columns (up to sign)");
          a := r;
          break;
        fi;
      od;
      if not out.ok then
        break;
      fi;
    od;
  fi;
  if level < 7 then
    return out;
  fi;
  primesN := Set(FactorsInt(Nord));
  if IsRat(D2) then
    primesD := Set(FactorsInt(AbsInt(NumeratorRat(D2))));
    if primesD <> primesN then
      out.ok := false;
      Add(out.failures, "Cauchy primes mismatch (rational D2)");
    fi;
    return out;
  fi;
  if IsBoundGlobal("Norm") then
    normD2 := ValueGlobal("Norm")(D2);
    if not IsRat(normD2) then
      out.ok := false;
      Add(out.failures, "Cauchy check failed: norm(D2) not rational");
      return out;
    fi;
    primesD := Set(FactorsInt(AbsInt(NumeratorRat(normD2))));
    if primesD <> primesN then
      out.ok := false;
      Add(out.failures, "Cauchy primes mismatch (cyclotomic D2)");
    fi;
    return out;
  fi;
  out.ok := false;
  Add(out.failures, "Cauchy check unavailable: Norm not bound");
  return out;
end );

InstallMethod(MDGaussSums, [ IsModularData ], function(md)
  local S, T, r, d, pplus, pminus;
  S := SMatrix(md);
  T := TMatrix(md);
  r := Length(S);
  d := List([1..r], i -> S[1][i]);
  pplus := Sum([1..r], i -> d[i]^2 * T[i][i]);
  pminus := Sum([1..r], i -> d[i]^2 / T[i][i]);
  return rec(pplus := pplus, pminus := pminus);
end );

InstallMethod(MDCentralCharge, [ IsModularData ], function(md)
  local gs;
  gs := MDGaussSums(md);
  if gs.pminus = 0 then
    Error("pminus is 0; cannot form central charge");
  fi;
  return gs.pplus / gs.pminus;
end );

InstallGlobalFunction(LoadNsdGOL, function(rank)
  local path, fname;
  if not IsInt(rank) or rank < 1 then
    Error("rank must be a positive integer");
  fi;
  fname := Concatenation("NsdGOL", String(rank), ".g");
  path := Filename(DirectoriesPackageLibrary("FusionRings", "data/modular_data"), fname);
  if path = fail then
    Error("cannot locate ", fname, " in data/modular_data");
  fi;
  Read(path);
  return true;
end );

InstallGlobalFunction(GetModularData, function(rank, iGO, iMD)
  local ok, nsd;
  if not IsInt(iGO) or not IsInt(iMD) then
    Error("iGO and iMD must be integers");
  fi;
  ok := LoadNsdGOL(rank);
  if not IsBoundGlobal("NsdGOL") then
    Error("NsdGOL not bound after loading rank file");
  fi;
  nsd := ValueGlobal("NsdGOL");
  if iGO < 1 or iGO > Length(nsd) then
    Error("iGO out of range");
  fi;
  if iMD < 1 or iMD > Length(nsd[iGO]) then
    Error("iMD out of range");
  fi;
  return ModularDataFromNsdRecord(nsd[iGO][iMD]);
end );

InstallGlobalFunction(FusionRingFromModularData, function(md)
  local N, r, labels, prodTable, i, j, k, terms;
  if not IsModularData(md) then
    Error("FusionRingFromModularData expects a ModularData object");
  fi;
  N := MDFusionCoefficients(md);
  if N = fail then
    Error("FusionRingFromModularData requires fusion coefficients (N)");
  fi;
  r := Length(N);
  labels := [1..r];
  prodTable := [];
  for i in [1..r] do
    for j in [1..r] do
      terms := [];
      for k in [1..r] do
        if N[i][j][k] <> 0 then
          Add(terms, [ labels[k], N[i][j][k] ]);
        fi;
      od;
      Add(prodTable, [ labels[i], labels[j], terms ]);
    od;
  od;
  return FusionRingBySparseConstants(labels, 1, fail, prodTable, rec(check := 0, inferDual := true));
end );

InstallGlobalFunction(UniversalGradingFromModularData, function(md)
  local F;
  if not IsModularData(md) then
    Error("UniversalGradingFromModularData expects a ModularData object");
  fi;
  if MDFusionCoefficients(md) = fail then
    Error("UniversalGradingFromModularData requires fusion coefficients (N)");
  fi;
  F := FusionRingFromModularData(md);
  return UniversalGradingData(F);
end );

InstallGlobalFunction(CheckUniversalGradingEqualsInvertibles, function(md)
  local F, U, inv, out;
  if not IsModularData(md) then
    Error("CheckUniversalGradingEqualsInvertibles expects a ModularData object");
  fi;
  if MDFusionCoefficients(md) = fail then
    return rec(
      ok := false,
      applicable := false,
      reason := "requires fusion coefficients (N)"
    );
  fi;
  F := FusionRingFromModularData(md);
  U := UniversalGradingData(F);
  inv := InvertibleSimples(F);
  out := rec(
    ok := Length(U.components) = Length(inv),
    applicable := true,
    universalGradingOrder := Length(U.components),
    invertibleCount := Length(inv),
    invertibles := inv
  );
  if not out.ok then
    out.reason := "orders do not match";
  fi;
  return out;
end );

# Roadmap stubs: Lie/root-system Verlinde modular data constructors
InstallGlobalFunction(VerlindeModularData, function(type, rank, level)
  local t;
  if not IsString(type) then
    Error("type must be a string (e.g. \"A\")");
  fi;
  if not IsInt(rank) or rank < 1 then
    Error("rank must be a positive integer");
  fi;
  t := UppercaseString(type);
  if t = "A" and rank = 1 then
    return MDVerlindeSU2@(level);
  fi;
  Error("VerlindeModularData not implemented yet for type ", t, " rank ", rank,
        ". See doc/modular_data.md (planned API).");
end );

InstallGlobalFunction(VerlindeModularDataByLieAlgebra, function(L, level)
  Error("VerlindeModularDataByLieAlgebra not implemented yet. See doc/modular_data.md (planned API).");
end );

InstallGlobalFunction(VerlindeModularDataByRootSystem, function(R, level)
  Error("VerlindeModularDataByRootSystem not implemented yet. See doc/modular_data.md (planned API).");
end );
