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

4) Web docs (MkDocs site)
-------------------------
First time only (Python deps):

    cd /Users/cesargalindo/Documents/FusionRings
    python3 -m pip install --user -r requirements-docs.txt

Run local web docs server:

    cd /Users/cesargalindo/Documents/FusionRings
    mkdocs serve

Open in browser:

    http://127.0.0.1:8000/FusionRings/

If `mkdocs` is not on PATH:

    python3 -m mkdocs serve

5) Local CI (tests + docs)
--------------------------
    Read("/Users/cesargalindo/Documents/FusionRings/run_ci.g");

6) Where to look for context
----------------------------
- /Users/cesargalindo/Documents/FusionRings/CONTEXT.md
- /Users/cesargalindo/Documents/FusionRings/pkg/FusionRings/README_CONTEXT.md

7) Next roadmap (your notes)
-----------------------------
- Modular data object + import from Rowell paper
- Functions/invariants from fusion rings + modular data
- Zestings (Mora–Galindo)

8) Git
------
Repo root: /Users/cesargalindo/Documents/FusionRings
Branch: main
