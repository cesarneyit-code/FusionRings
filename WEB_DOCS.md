# Web Docs Guide

This repo includes a static docs site powered by MkDocs Material.

## Local preview

```bash
cd /Users/cesargalindo/Documents/FusionRings
python3 -m pip install -r requirements-docs.txt
mkdocs serve
```

Open `http://127.0.0.1:8000/FusionRings/`.

If `mkdocs` is not on PATH:

```bash
python3 -m mkdocs serve
```

## Build static site

```bash
cd /Users/cesargalindo/Documents/FusionRings
mkdocs build
```

Generated files are written to `site/`.

## Deploy to GitHub Pages

```bash
cd /Users/cesargalindo/Documents/FusionRings
mkdocs gh-deploy
```

## Main content files

- `mkdocs.yml`
- `webdocs/index.md`
- `webdocs/guide/*.md`
- `webdocs/api/*.md`
- `webdocs/assets/custom.css`
