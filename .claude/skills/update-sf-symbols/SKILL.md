---
name: update-sf-symbols
description: Update the SFSymbols library for a new SF Symbols app / OS release — regenerate all symbol sources (new symbols, refreshed metadata, use-restrictions) via the sfsym-gen CLI. Use when bumping to a new SF Symbols version (e.g. "update for SF Symbols 8 / iOS 27") or refreshing symbol metadata.
---

# Update SF Symbols

Regenerates `Sources/SFSymbols/**` from the installed SF Symbols app using the
`sfsym-gen` maintainer CLI (backed by `Tools/Sources/SFSymbolsGenKit`). Run all
commands from the repository root.

## 0. Prerequisites
- Install the target **SF Symbols Beta app** at `/Applications/SF Symbols Beta.app`.
- Run on the **latest macOS** — deprecation/restriction data comes from the system
  CoreGlyphs bundle, which is tied to the OS version.
- Confirm the version you're targeting: `defaults read "/Applications/SF Symbols Beta.app/Contents/Info.plist" CFBundleShortVersionString` (and `CFBundleVersion`).

## 1. Capture the Draw category (manual — required)
Draw membership is **not** in any metadata file; it must be copied from the app.
Two ways:
- **Let the pipeline prompt:** in the app, select **Draw** → click a symbol → **⌘A** →
  **⌘⇧C**, then run step 2 — it reads the clipboard when `draw.txt` is absent.
- **Or pre-stage `draw.txt`:** write the copied names (one per line) to `draw.txt` in the
  repo root before step 2.

If you're refreshing an existing release without Draw changes, you can reconstruct the
prior Draw list from the committed source:
```bash
python3 - <<'PY'
import re, glob
draw=set()
for f in glob.glob("Sources/SFSymbols/SFSymbol+StaticVariables/*.swift"):
    for m in re.finditer(r'title:\s*"([^"]+)"\s*,\s*\n\s*categories:\s*(\[[^\]]*\]|nil)', open(f).read()):
        if '.draw' in [x.strip() for x in m.group(2).strip('[]').split(',')]: draw.add(m.group(1))
open("draw.txt","w").write("\n".join(sorted(draw)))
print("draw.txt", len(draw))
PY
```
(But brand-new draw symbols in the new release still require the manual capture above.)

## 2. Run the update
```bash
swift run --package-path Tools sfsym-gen update --app "/Applications/SF Symbols Beta.app"
```
This decrypts use-restrictions from the font, merges CoreGlyphs ∪ app metadata
(so symbols for an unreleased OS are included), applies Draw + restrictions, writes the
generated sources, and cleans up temp files. The decrypt step **soft-fails** to
CoreGlyphs-only restrictions if the private symbol is unavailable.

## 3. Verify
```bash
swift build
git status --short            # review which version files changed / were added
git diff --stat -- Sources
```
- A new OS adds `SFSymbol+StaticVariables<version>.swift` + `SFSymbol+All<version>.swift`,
  and the unified `SFSymbol+All.swift` gains an `#available` block.
- Spot-check counts, e.g. new-version symbols and restrictions:
  ```bash
  swift run --package-path Tools sfsym-gen --help   # (sanity) the CLI built
  grep -c "static let" Sources/SFSymbols/SFSymbol+StaticVariables/SFSymbol+StaticVariables<version>.swift
  ```

## 4. Version + changelog
- Bump the README version badge.
- Add a `CHANGELOG.md` entry. Align the package version with the **SF Symbols app
  release** (e.g. SF Symbols 8.0 → package `8.0`), not a single OS number.
- Note new symbol counts, metadata refreshes, and any Draw/restriction deltas.

## Notes
- The update is **idempotent**: re-running against the same app yields a zero `Sources`
  diff. A non-empty diff after a re-run signals a tooling problem.
- Do **not** commit `draw.txt`, `font_restrictions.tsv`, or `symbols.json` — they're
  temp inputs/intermediates the pipeline cleans up.
- See `Tools/Sources/SFSymbolsGenKit/README.md` for the architecture and the decryptor
  details.
