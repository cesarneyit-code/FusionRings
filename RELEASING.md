# Release Checklist

This checklist keeps releases reproducible and consistent.

1) Update metadata
   - `pkg/FusionRings/PackageInfo.g`: bump `Version` and `Date`.
   - Update any changelog file if you keep one (optional).

2) Run tests
   - `./bin/fr-test-strict`

3) Build docs (if applicable)
   - `./bin/fr-doc`

4) Commit
   - `git status`
   - `git add -A`
   - `git commit -m "Release vX.Y.Z"`

5) Tag
   - `git tag -a vX.Y.Z -m "FusionRings vX.Y.Z"`
   - `git push --follow-tags`
