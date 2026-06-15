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
- Run on the **latest macOS** — only the system CoreGlyphs bundle is OS-tied (it
  supplies deprecation aliases, availability, and category mappings). Restrictions,
  Unicode points, and the Draw category come from the app itself (OS-independent), so
  this is purely about keeping CoreGlyphs' deprecation/availability data current.
- **Xcode command-line tools** (`lldb`, `codesign`, `otool`) — required for automatic
  Draw-category extraction (step 1). Verify with `xcode-select -p`.
- Confirm the version you're targeting: `defaults read "/Applications/SF Symbols Beta.app/Contents/Info.plist" CFBundleShortVersionString` (and `CFBundleVersion`).

## 1. Draw category (automatic)
Draw membership is in **no** metadata file — the app computes it at render time from
glyph geometry. The pipeline extracts it automatically (step 2 runs it; or run it
standalone):
```bash
swift run --package-path Tools sfsym-gen draw --app "/Applications/SF Symbols Beta.app" --output draw.txt
```
How it works (`Tools/Sources/SFSymbolsGenKit/DrawExtraction.swift`): it clones the app,
ad-hoc re-signs the copy with `get-task-allow`, then drives the app's own
`UnifiedSymbolAnnotation.hasDrawInfo` under lldb — calling its draw-check function for
every glyph. Takes ~2 min with a progress bar. The throwaway app copy **freezes while
lldb drives it — that's expected**; it's killed when done. It **soft-fails** to a manual
clipboard prompt (select **Draw** → ⌘A → ⌘⇧C) if anything goes wrong.

**If auto-extraction can't locate the draw-check function** (it moves every app build),
find it by hand and pass `--draw-func`:
```bash
SF="/Applications/SF Symbols Beta.app/Contents/Frameworks/SFSymbolsShared.framework/Versions/A/SFSymbolsShared"
APP="/Applications/SF Symbols Beta.app/Contents/MacOS/SF Symbols Beta"
nm "$SF" | grep -i hasDrawInfo | swift demangle          # confirm the getter still exists
otool -arch arm64 -tV "$APP" | grep -n hasDrawInfoSbvg    # its SOLE caller (the `bl`)
# → scroll up to the nearest function prologue after a `ret`/`brk`; pass that as:
#   sfsym-gen update --draw-func 0x…
```
If the `hasDrawInfo` getter is renamed/removed entirely, the method needs revisiting
(it's the anchor for both auto-detection and the disassembly).

## 2. Run the update
```bash
swift run --package-path Tools sfsym-gen update --app "/Applications/SF Symbols Beta.app"
```
This auto-extracts the Draw category (step 1, unless `draw.txt` is already staged),
decrypts use-restrictions from the font, merges CoreGlyphs ∪ app metadata (so symbols
for an unreleased OS are included), applies Draw + restrictions, writes the generated
sources, and cleans up temp files. The decrypt step **soft-fails** to CoreGlyphs-only
restrictions if the private symbol is unavailable; Draw soft-fails to a manual prompt.
Pass `--draw-func 0x…` here too if Draw auto-detection needs an override (see step 1).

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
