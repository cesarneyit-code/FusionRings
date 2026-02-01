#Rank = 2
#Modular data (Nij_k,s,d) grouped as a list of Galois orbits
#NsdGOL[i] is the i^th Galois orbit
#NsdGOL[i][j] is the j^th modular data in i^th Galois orbit

#fusion coefficient Nij_k: N[i][j][k] = N^ij_k
#topological spin s: [s1,s2,...]
#quantum dimension df: [d1,d2,...] (floating)
#quantum dimension d: [d1,d2,...]

cs := function(cnd,i)
  return E(cnd)^i+E(cnd)^(-i);
end;

xi := function(cnd,i,j)
  return ( E(2*cnd)^i-E(2*cnd)^(-i) )/(E(2*cnd)^j-E(2*cnd)^(-j));
end;

NsdGOL := [];


# Galois orbit 1:
NsdGOL[1] := [];

NsdGOL[1][1] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 0 ]]
],
s := [ 0, 1/4 ],
df := [ 1., 1. ],
d := [ 1, 1 ] );

NsdGOL[1][2] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 0 ]]
],
s := [ 0, 3/4 ],
df := [ 1., 1. ],
d := [ 1, 1 ] );


# Galois orbit 2:
NsdGOL[2] := [];

NsdGOL[2][1] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 1 ]]
],
s := [ 0, 2/5 ],
df := [ 1., 1.6180339887498949 ],
d := [ 1, (1+Sqrt(5))/2  ] );

NsdGOL[2][2] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 1 ]]
],
s := [ 0, 3/5 ],
df := [ 1., 1.6180339887498949 ],
d := [ 1, (1+Sqrt(5))/2  ] );

NsdGOL[2][3] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 1 ]]
],
s := [ 0, 1/5 ],
df := [ 1., -0.61803398874989468 ],
d := [ 1, (1-Sqrt(5))/2  ] );

NsdGOL[2][4] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 1 ]]
],
s := [ 0, 4/5 ],
df := [ 1., -0.61803398874989468 ],
d := [ 1, (1-Sqrt(5))/2  ] );


# Galois orbit 3:
NsdGOL[3] := [];

NsdGOL[3][1] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 0 ]]
],
s := [ 0, 1/4 ],
df := [ 1., -1. ],
d := [ 1, -1 ] );

NsdGOL[3][2] := rec(
Nij_k := [
 #N[1][j][k]:
 [[ 1, 0 ],
  [ 0, 1 ]],
 #N[2][j][k]:
 [[ 0, 1 ],
  [ 1, 0 ]]
],
s := [ 0, 3/4 ],
df := [ 1., -1. ],
d := [ 1, -1 ] );

