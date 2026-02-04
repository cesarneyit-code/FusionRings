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
