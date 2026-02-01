# FusionRings (GAP) — Documento completo de especificación (matemática + diseño + API + decisiones)

Este documento es una **especificación completa** para implementar en GAP un paquete que maneje
**fusion rings** (anillos de fusión) como objetos GAP con buenas prácticas: labels arbitrarios,
múltiples representaciones, interfaz estable, verificación por niveles, inmutabilidad y caches
por atributos. Está escrito para ser entregado directamente a Codex.

---

## 0) Objetivo y alcance

### Objetivo
Implementar en GAP un objeto `FusionRing` que represente formalmente un **fusion ring** y que sea la
base para cálculos posteriores (por ejemplo, datos modulares, matrices S/T, etc.).

### Alcance (en este documento)
- Definición matemática formal (fusion ring).
- Decisiones de diseño (labels como conjunto/domino, dual como parte del objeto, eficiencia).
- Arquitectura GAP: category + 3 representations (rule-based, sparse, matrices).
- API concreta GAP: `DeclareCategory`, `DeclareRepresentation`, `DeclareOperation`, `DeclareAttribute`.
- Constructores (genérico y especializados), formato estándar de salida, y métodos a instalar por representación.
- Política de inmutabilidad y caches.
- Verificación de axiomas por niveles + consistencia interna.
- Estructura de archivos y roadmap de implementación.

Este documento NO implementa todavía datos modulares; solo deja preparado el núcleo.

---

## 1) Decisiones finales (NO cambiar salvo necesidad)

Estas son decisiones de ingeniería y matemáticas ya acordadas; el código debe reflejarlas.

1) **Labels arbitrarios**:
   - El conjunto de índices `I` puede ser un **dominio finito** (p.ej. grupo `G`) o una lista estrictamente ordenada.
   - La interfaz pública siempre usa labels (elementos de `I`), no índices `1..r`.

2) **Dualidad `*` es parte del objeto**:
   - El objeto debe exponer `DualLabel(F,i)` siempre.
   - Aunque a veces se pueda inferir desde `N`, el objeto final debe tener `dual` guardado (tabla o función).
   - Si se infiere, se guarda (y queda disponible como atributo `DualTable(F)`).

3) **Producto en formato disperso estándar**:
   - `MultiplyBasis(F,i,j)` devuelve una lista `[[k1,n1],[k2,n2],...]` con coeficientes enteros positivos.
   - Sin ceros, sin repetidos (o normalizados), opcionalmente ordenado.

4) **Múltiples representaciones internas**:
   - Rule-based (por reglas/funciones), Sparse (constantes dispersas), Matrices (matrices de fusión).
   - Todos implementan la misma interfaz pública.

5) **Indexación interna opcional**:
   - Se permite materializar `labels = AsSortedList(I)` y un mapa `pos` label→índice si conviene.
   - Si no hay `pos`, se usa `Position(labels, x)` como fallback.

6) **Inmutabilidad y caches**:
   - El objeto debe ser inmutable matemáticamente tras construirlo.
   - Derivados/caches (dualTable materializada, matrices, enumeración, etc.) deben ser **atributos** (memoización),
     no mutación de campos esenciales post-construcción.
   - Se instala `IsInternallyConsistent` para debug.

7) **Verificación por niveles**:
   - `CheckFusionRingAxioms(F, level)` con level 0/1/2 para balancear costo vs certeza.

---

## 2) Definición matemática formal (Fusion Ring)

Un **fusion ring** es un cuádruple

\[
\mathcal F = (I,\; 1,\; * ,\; N)
\]

donde:

- `I` es un conjunto finito de labels (simples).
- `1 ∈ I` es la unidad.
- `*: I → I` es una involución (dualidad) con `(i^*)^* = i` y `1^* = 1`.
- `N_{ij}^k ∈ ℤ_{\ge 0}` son constantes de estructura que definen el producto en `ℤI`:
  \[
  i\cdot j = \sum_{k\in I} N_{ij}^k\,k.
  \]

### Axiomas

**(A1) Unidad**
\[
N_{1i}^k = \delta_{i,k}, \quad N_{i1}^k = \delta_{i,k}.
\]

**(A2) Asociatividad**
\[
\sum_{k} N_{ij}^k N_{k\ell}^m \;=\; \sum_{k} N_{j\ell}^k N_{ik}^m
\quad \forall i,j,\ell,m\in I.
\]

**(A3) Dualidad (criterio característico)**
\[
N_{i\,k}^{1} = \delta_{i^*,k} \quad \forall i,k\in I.
\]
Consecuencia: si existe un `*` que satisface esta propiedad, entonces `*` es **única**.
Por diseño, el objeto siempre guarda `dual` aunque se pueda inferir.

**(A4) Reciprocidad de Frobenius**
\[
N_{ij}^k = N_{i^*\,k}^{j} = N_{k\,j^*}^{i}.
\]

### Forma matricial (para referencia)
Para cada `i`, define la matriz de fusión `N_i` por:
\[
(N_i)_{j,k} = N_{ij}^k.
\]
No es obligatorio guardarlas siempre; pueden materializarse bajo demanda.

---

## 3) Convenciones de datos (formato de salida y normalización)

### 3.1 Producto en formato disperso (estándar)
Representación de `i*j` como lista de pares:
- `[[k1,n1],[k2,n2],...]` con `nt ∈ ℤ_{>0}`
- `kt ∈ I`
- sin términos repetidos (o se normaliza)
- sin coeficientes cero

### 3.2 Normalización obligatoria
Se define un helper `NormalizeProductList(list[, F])` que:
- combina términos repetidos,
- elimina ceros,
- verifica que coeficientes sean enteros ≥ 0 (y opcionalmente exige >0),
- opcionalmente ordena los términos por `LabelsList(F)` si está disponible.

**Decisión**: todos los métodos de `MultiplyBasis` deben devolver salida normalizada.

---

## 4) Diseño GAP: Category + Representations + API

### 4.1 Category
Se define una categoría:
- `IsFusionRing`

y se implementa como objeto GAP (preferiblemente component object) con representaciones distintas.

### 4.2 Representations (tres modos)

1) **Rule-based**:
   - producto `mult(i,j)` es una función (o record con función)
   - dual `dual(i)` es función o tabla
   - NO se guarda `N_{ij}^k` completo.

2) **Sparse constants**:
   - `prodTable[(i,j)] = [[k,n],...]` (tabla dispersa)
   - dual tabla o función.

3) **Fusion matrices**:
   - `fusionMatrices[i] = N_i` (por label o por índice interno)
   - dual tabla o función.

Todas comparten la misma interfaz pública.

---

## 5) API GAP concreta (Declaraciones)

### 5.1 Archivos recomendados
- `gap/FusionRing.gd` : declaraciones (category, representations, ops/attrs, constructores)
- `gap/FusionRing.gi` : métodos genéricos y utilidades
- `gap/FusionRingRule.gi` : métodos específicos rule-based
- `gap/FusionRingSparse.gi` : métodos específicos sparse
- `gap/FusionRingMatrices.gi` : métodos específicos matrices
- `tst/` : tests

### 5.2 Declaraciones GAP (FusionRing.gd)

#### Category y representations
```gap
DeclareCategory("IsFusionRing", IsObject);

# Representación 1: por regla/funciones
DeclareRepresentation("IsFusionRingByRuleRep", IsFusionRing,
    [ "I", "one", "dual", "mult" ]);

# Representación 2: constantes dispersas
DeclareRepresentation("IsFusionRingBySparseRep", IsFusionRing,
    [ "I", "one", "dual", "prodTable" ]);

# Representación 3: matrices de fusión
DeclareRepresentation("IsFusionRingByMatricesRep", IsFusionRing,
    [ "I", "one", "dual", "fusionMatrices" ]);
Atributos básicos
DeclareAttribute("BasisLabels", IsFusionRing);        # devuelve I
DeclareAttribute("OneLabel", IsFusionRing);           # devuelve unidad
DeclareAttribute("DualData", IsFusionRing);           # dual tal como se dio (func/table/record)
DeclareAttribute("RepresentationType", IsFusionRing); # string: "rule"/"sparse"/"matrices"
Indexación (atributos/operaciones auxiliares)
DeclareAttribute("LabelsList", IsFusionRing);         # enumeración fija (si existe)
DeclareOperation("PositionOfLabel", [ IsFusionRing, IsObject ]); # pos(label) o fail
DeclareOperation("LabelOfPosition", [ IsFusionRing, IsInt ]);    # labels[pos] o fail
Dualidad
DeclareOperation("DualLabel", [ IsFusionRing, IsObject ]); # i -> i*
DeclareAttribute("DualTable", IsFusionRing);              # materializa tabla si procede
Producto y coeficientes
DeclareOperation("MultiplyBasis", [ IsFusionRing, IsObject, IsObject ]);
DeclareOperation("FusionCoefficient", [ IsFusionRing, IsObject, IsObject, IsObject ]);
DeclareGlobalFunction("NormalizeProductList");  # helper global
Matrices de fusión (materialización bajo demanda)
DeclareOperation("FusionMatrix", [ IsFusionRing, IsObject ]); # devuelve N_i
DeclareAttribute("FusionMatrices", IsFusionRing);             # colección completa si aplica
Verificación y consistencia
DeclareOperation("CheckFusionRingAxioms", [ IsFusionRing, IsInt ]);  # level 0/1/2
# GAP ya declara IsInternallyConsistent(obj) como operación; instalaremos métodos:
# DeclareOperation("IsInternallyConsistent", [ IsObject ]);  # NO redeclarar; solo InstallMethod
Constructores
DeclareGlobalFunction("FusionRing");                   # constructor genérico
DeclareGlobalFunction("FusionRingByRule");             # constructor rule-based
DeclareGlobalFunction("FusionRingBySparseConstants");  # constructor sparse
DeclareGlobalFunction("FusionRingByFusionMatrices");   # constructor matrices
DeclareGlobalFunction("PointedFusionRing");            # caso canónico: grupo
6) Constructores: contratos exactos
6.1 Constructor genérico FusionRing(...)
Firma recomendada (flexible):

FusionRing(I, one, dual, multOrData[, opts])

Donde:

I: dominio finito o lista strictly sorted

one: label en I

dual: función i->i*, o tabla (p.ej. record/map/lista), o fail (solo si opts.inferDual=true y se puede inferir)

multOrData: puede ser

función mult(i,j) (rule-based),

tabla dispersa prodTable (sparse),

colección de matrices fusionMatrices (matrices).

opts (record) con opciones:

storeRepresentation := "rule"|"sparse"|"matrices"|fail (si fail, inferir por el tipo)

check := 0|1|2 (default 0 o 1)

inferDual := true/false (default false salvo sparse/matrices si dual no se da)

buildIndex := true/false (default true si I es enumerable razonable)

makeImmutable := true/false (default true)

Contrato:

Construir objeto en la representación elegida.

Guardar I, one, dual, mult/data.

Si buildIndex=true, preparar LabelsList como atributo (no campo mutado).

Si makeImmutable=true, hacer el objeto inmutable al final (cuando sea seguro).

Si check>0, ejecutar CheckFusionRingAxioms(F, check).

6.2 Constructor FusionRingByRule(I, one, dual, mult[, opts])
dual y mult se asumen funciones o records con función.

No materializa matrices ni tabla de constantes.

Puede implementar FusionMatrix bajo demanda construyendo desde MultiplyBasis.

6.3 Constructor FusionRingBySparseConstants(I, one, dual, prodTable[, opts])
prodTable da el producto disperso para pares (i,j) (los ausentes se interpretan como 0).

dual puede ser tabla o función.

Si dual=fail y opts.inferDual=true, se intenta inferir dual desde coeficientes de la unidad (si accesible).

6.4 Constructor FusionRingByFusionMatrices(labels, one, dual, fusionMatrices[, opts])
labels es lista strictly sorted; define I como esa lista (o dominio asociado si se desea).

fusionMatrices provee N_i para cada label i.

MultiplyBasis se implementa desde matrices (rápido).

dual tabla o función; se verifica compatibilidad si check>0.

6.5 Caso canónico PointedFusionRing(G)
Entrada: dominio grupo G.
Define:

I := G

one := One(G)

dual(g) := g^-1

mult(g,h) := [[g*h, 1]]

No materializa N ni matrices salvo petición explícita.

7) Métodos a instalar (por representación y genéricos)
7.1 Métodos genéricos (para IsFusionRing)
Instalar métodos (en FusionRing.gi) que funcionen para cualquier rep, delegando si es necesario:

Atributos básicos
BasisLabels(F) → F!.I (o acceso al componente según representation)

OneLabel(F) → F!.one

DualData(F) → F!.dual

RepresentationType(F) → string fijo por rep

Dualidad
DualLabel(F, i):

si dual es función: dual(i)

si dual es tabla: lookup

validar que salida pertenece a I si check o IsInternallyConsistent

DualTable(F) (atributo):

si ya es tabla: retornar (o copia inmutable)

si es función: requiere LabelsList(F); materializa un mapa/record/lista i -> dual(i)

Producto y coeficientes
MultiplyBasis(F, i, j):

se delega a métodos específicos por rep (rule/sparse/matrices)

FusionCoefficient(F, i, j, k):

implementación genérica: busca k dentro de MultiplyBasis(F,i,j) (O(#términos))

si matrices o pos existen, se puede instalar método más rápido.

Indexación
LabelsList(F) (atributo):

si I es dominio finito y enumerable: AsSortedList(I)

si I es lista: verificar strict sorting o normalizar

retornar lista inmutable si procede

PositionOfLabel(F, i):

si existe un mapa interno/atributo PosMap(F): usarlo (opcional)

fallback: Position(LabelsList(F), i)

LabelOfPosition(F, p):

retornar LabelsList(F)[p] con checks

Matrices
FusionMatrix(F, i):

por defecto: materializa usando LabelsList y MultiplyBasis

para rep matrices: método especializado que devuelve directamente

FusionMatrices(F):

materializa todas si FusionMatrix está disponible y LabelsList existe

Debug
IsInternallyConsistent(F):

checks de invariantes estructurales (ver sección 8)

7.2 Métodos específicos: Rule-based (IsFusionRingByRuleRep)
En FusionRingRule.gi instalar:

MultiplyBasis(F, i, j):

out := F!.mult(i,j)

return NormalizeProductList(out, F) (si se pasa F para ordenar)

DualLabel(F, i):

si F!.dual es func: F!.dual(i); si tabla: lookup

FusionMatrix(F, i) (opcional pero recomendado):

requiere labels := LabelsList(F)

construir matriz N_i:

para cada j en labels: expandir MultiplyBasis(F,i,j) y llenar columna/fila correspondiente

devolver matriz (preferiblemente inmutable)

LabelsList(F):

método común ya lo hace; rule-based solo necesita que exista cuando se pida matrices.

7.3 Métodos específicos: Sparse (IsFusionRingBySparseRep)
En FusionRingSparse.gi instalar:

MultiplyBasis(F, i, j):

out := LookupProdTable(F!.prodTable, i, j); si falta, []

normalizar y retornar

FusionCoefficient(F, i, j, k):

opción 1: genérico por MultiplyBasis

opción 2 (optimización): lookup directo si prodTable indexa también por k

FusionMatrix(F, i):

materializa usando prodTable y labels evitando recomputar por reglas

(Opcional) InferDualFromSparse(F):

si dual faltaba y opts.inferDual=true:

para cada i, buscar único k con coeficiente de one en MultiplyBasis(i,k) igual a 1

construir tabla dualTable

7.4 Métodos específicos: Matrices (IsFusionRingByMatricesRep)
En FusionRingMatrices.gi instalar:

FusionMatrix(F, i):

devolver F!.fusionMatrices[i] (o por posición)

MultiplyBasis(F, i, j):

usar indices:

pi := PositionOfLabel(F,i)

pj := PositionOfLabel(F,j)

leer fila/columna desde N_i

construir lista dispersa [[k,n],...] usando LabelOfPosition

FusionCoefficient(F, i, j, k):

acceso O(1) si hay indices:

N_i[pj, pk] según convención matriz

8) Consistencia interna y verificación de axiomas
8.1 IsInternallyConsistent(F) (rápido, sin asociatividad global)
Debe verificar:

I existe y es dominio o lista.

one pertenece a I.

DualLabel(F, one) = one.

Para una muestra (o todo si pequeño):

DualLabel(F,i) pertenece a I.

MultiplyBasis(F,i,j) devuelve lista bien formada: pares, coeficientes enteros ≥0, labels en I.

Si existe LabelsList(F), que sea estrictamente ordenada y consistente con I (cuando tenga sentido).

Retornar true o lanzar error/retornar false según convención del paquete.

8.2 CheckFusionRingAxioms(F, level) con niveles
level = 0 (ultrarrápido)
Llama IsInternallyConsistent(F).

No prueba asociatividad completa.

level = 1 (razonable)
Todo level 0, más:

Unidad completa:

para todo i en LabelsList(F):

MultiplyBasis(F, one, i) debe ser [[i,1]]

MultiplyBasis(F, i, one) debe ser [[i,1]]

Involución completa:

para todo i: DualLabel(F, DualLabel(F,i)) = i

Dualidad A3 (si es verificable desde MultiplyBasis):

para todo i:

FusionCoefficient(F, i, DualLabel(F,i), one) = 1

y para k != i^*, FusionCoefficient(F,i,k,one)=0 (si se desea chequeo completo)

Reciprocidad de Frobenius A4:

para todo i,j,k (si r pequeño) o una muestra (si r grande):

N_{ij}^k = N_{i^* k}^j y N_{ij}^k = N_{k j^*}^i.

level = 2 (completo)
Asociatividad global A2:

para todo i,j,l en LabelsList(F):

comparar MultiplyBasis(F, MultiplyBasis(F,i,j), l) con MultiplyBasis(F, i, MultiplyBasis(F,j,l))

Implementar producto extendido:

si x = sum a_i i (disperso), y y basis label: expandir distributivamente.

Reciprocidad Frobenius completa.

Si hay matrices disponibles, permitir atajo:

construir N_i y verificar identidades matriciales equivalentes para rapidez.

9) Política de inmutabilidad y copias
Durante construcción:

se pueden usar records/listas mutables.

Al finalizar, si opts.makeImmutable=true:

usar MakeImmutable(F) SOLO si todo fue recién creado (incluyendo tablas internas).

si se recibe una tabla del usuario y no se sabe si está compartida:

usar Immutable(table) para copia inmutable segura.

No depender de mutar campos post-construcción.

Usar atributos para caches:

LabelsList, DualTable, FusionMatrix, etc.

10) Helper obligatorio: NormalizeProductList
Se debe implementar como función global:

NormalizeProductList(list[, F])

Especificación:

entrada: lista de pares [[k,n],...] donde k es label, n entero.

combinar repetidos: si aparece el mismo k varias veces, sumar coeficientes.

eliminar n=0.

si algún n<0 o no entero: error.

si F se proporciona y LabelsList(F) existe: ordenar por ese orden.

salida: lista normalizada.

11) Ejemplos de uso (contratos)
11.1 Pointed fusion ring de un grupo
F := PointedFusionRing(G);

MultiplyBasis(F,g,h) = [[g*h,1]]

DualLabel(F,g) = g^-1

CheckFusionRingAxioms(F,1) debe pasar para grupos pequeños (y para grandes con checks razonables).

11.2 Importación sparse
F := FusionRingBySparseConstants(I, one, dualTable, prodTable : check:=1);

MultiplyBasis hace lookup en prodTable.

11.3 Matrices
F := FusionRingByFusionMatrices(labels, one, dualTable, fusionMatrices : check:=1);

FusionMatrix(F,i) es O(1), MultiplyBasis se reconstruye de la matriz.

12) Estructura de archivos del paquete (recomendación)
PackageInfo.g y estructura estándar de paquete GAP.

gap/FusionRing.gd declaraciones

gap/FusionRing.gi métodos genéricos + helpers

gap/FusionRingRule.gi métodos rule

gap/FusionRingSparse.gi métodos sparse

gap/FusionRingMatrices.gi métodos matrices

tst/test_pointed.tst

tst/test_sparse.tst

tst/test_matrices.tst

13) Roadmap de implementación (por etapas)
Etapa 1 (MVP funcional)
category + representations + constructores FusionRingByRule, FusionRingBySparseConstants, PointedFusionRing

operaciones/atributos:

BasisLabels, OneLabel, DualLabel, MultiplyBasis, FusionCoefficient

NormalizeProductList

LabelsList (si posible)

IsInternallyConsistent

CheckFusionRingAxioms(level 0/1)

Etapa 2 (materialización y checks completos)
FusionMatrix genérico + específicos

CheckFusionRingAxioms(level 2) (asociatividad global)

representación matrices completa y eficiente

Etapa 3 (derivados)
IsCommutativeFusionRing, dimensiones FP (atributos)

import/export, serialización, printing mejorado

14) Resumen final (lo que Codex debe implementar exactamente)
Un objeto GAP FusionRing en categoría IsFusionRing con 3 representations.

Una interfaz pública estable basada en labels:

BasisLabels, OneLabel, DualLabel, MultiplyBasis, FusionCoefficient,

opcionalmente FusionMatrix, LabelsList.

dual siempre es parte del objeto (tabla o función); DualTable como atributo.

Producto en salida dispersa estandarizada + NormalizeProductList.

Constructores claros (genérico + especializados) incluyendo PointedFusionRing(G).

Verificación: IsInternallyConsistent y CheckFusionRingAxioms(level 0/1/2).

Inmutabilidad: construir mutable y hacer inmutable al final; caches en atributos.

Fin del documento.