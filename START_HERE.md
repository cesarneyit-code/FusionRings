START HERE (FusionRings)
========================

This file is your quick-start for a new session months later.

1) Load the package (direct)
----------------------------
In GAP:

    Read("/Users/cesargalindo/Documents/FusionRings/read_direct.g");

2) Run tests (strict)
---------------------
    Read("/Users/cesargalindo/Documents/FusionRings/run_tests_strict.g");

If strict fails due to newline quirks:

    Read("/Users/cesargalindo/Documents/FusionRings/normalize_tests.g");
    Read("/Users/cesargalindo/Documents/FusionRings/run_tests_strict.g");

3) Build docs
-------------
    Read("/Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/doc/build_manual.g");

HTML output:
    /Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/doc/chap0.html

PDF requires pdflatex.

4) Local CI (tests + docs)
--------------------------
    Read("/Users/cesargalindo/Documents/FusionRings/run_ci.g");

5) Where to look for context
----------------------------
- /Users/cesargalindo/Documents/FusionRings/CONTEXT.md
- /Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/README_CONTEXT.md

6) Next roadmap (your notes)
-----------------------------
- Modular data object + import from Rowell paper
- Functions/invariants from fusion rings + modular data
- Zestings (Mora–Galindo)

7) Git
------
Repo root: /Users/cesargalindo/Documents/FusionRings
Branch: main

