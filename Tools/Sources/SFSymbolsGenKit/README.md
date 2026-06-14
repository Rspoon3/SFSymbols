# SFSymbolsGenKit

The code-generation engine behind the **`sfsym-gen`** maintainer CLI. It regenerates
the `SFSymbols` library's Swift sources from Apple's SF Symbols app and the system's
symbol metadata.

This is the in-process port of what used to be five standalone repo-root scripts
(`UpdateScript.swift`, `GenerateSymbolsJSON.swift`, `DecryptFontMetadata.swift`,
`ParseSwiftUIDoc.swift`, `ParseUIKitDoc.swift`). It lives in the nested `Tools`
package, so it never touches anyone who only depends on the `SFSymbols` library.

> **Audience:** library maintainers. Nothing here ships to consumers.

---

## Public API

| Symbol | Purpose |
|---|---|
| `runUpdate(appPath:repoRoot:)` | Full symbol update: decrypt → merge metadata → write all generated sources. |
| `generateSwiftUIWrappers(rtfPath:repoRoot:)` | Generate SwiftUI initializer wrappers from an exported doc RTF. |
| `generateUIKitWrappers(rtfPath:repoRoot:)` | Same, for UIKit. |
| `SymbolsApp.locate()` | First installed SF Symbols app (`…Beta.app`, then `…app`). |
| `GenError` | Errors thrown by the above. |

The `sfsym-gen` executable is a thin ArgumentParser wrapper over these.

---

## The `update` pipeline (`runUpdate`)

```
            ┌─► [1] Draw category   (DrawExtraction.swift)  drive app's hasDrawInfo under lldb → draw.txt
SF Symbols ─┤
   app      ├─► [2] Decrypt          (Decrypt.swift)        font `symp` table → font_restrictions.tsv
            │
CoreGlyphs ─┼─► [3] Generate         (GenerateSymbolsJSON)  merge → symbols.json (temp)
   bundle   │
            └─► [4] Write sources     (UpdatePipeline.swift) symbols.json → Sources/SFSymbols/**
```

Step 1 auto-extracts the Draw category by driving the app's own `hasDrawInfo` logic
(clone + ad-hoc re-sign the app, then call its draw-check function for every glyph
under lldb — see `DrawExtraction.swift`). It soft-fails
to a manual clipboard prompt. Use `sfsym-gen draw` to run just this step, or
`--draw-func 0x…` to override the auto-detected function address after an app update.

Steps 1–3 communicate through small files in a temp working directory (`draw.txt`,
`font_restrictions.tsv`, `symbols.json`) — the same boundaries the original scripts
used, which is why the output is byte-for-byte identical to the old pipeline.

**Generated outputs (step 4):**
- `Sources/SFSymbols/SFSymbol+StaticVariables/SFSymbol+StaticVariables<version>.swift`
- `Sources/SFSymbols/SFSymbol+All/SFSymbol+All<version>.swift` + the unified `SFSymbol+All.swift`
- `Sources/SFSymbols/Models/SFCategory.swift`

---

## Data sources

| Source | Role | Provides |
|---|---|---|
| System CoreGlyphs bundle (`/System/Library/CoreServices/CoreGlyphs.bundle`) | **primary** | names, availability, deprecation aliases, category mappings, restrictions |
| SF Symbols app `Metadata/` | **union/supplement** | symbols for an unreleased OS not yet in CoreGlyphs, layersets, category labels, search terms |
| SF Symbols font `symp` table (decrypted) | **authoritative restrictions** | use-restriction text for every symbol, incl. unreleased-OS symbols CoreGlyphs lacks |
| App's own `hasDrawInfo` (driven under lldb) | **Draw category** | the Draw category membership (computed at render time; not present in any metadata file) |

Because CoreGlyphs is tied to the installed OS, run the pipeline on the **latest
macOS** so deprecation/restriction data is current. The app-metadata union is what
lets a beta app contribute symbols for an OS the host doesn't run yet.

---

## The decryptor — note the fragility

`Decrypt.swift` reuses Apple's **private** routine
`CoreGlyphsLib.Crypton.decryptObfuscatedFontTable(tableTag:from:)` to read the font's
obfuscated `symp` metadata table (a CSV with a `Use Restrictions` column).

- It binds the symbol via `@_silgen_name` (as a `static` method on a shim, so a valid
  metatype is passed in the self register) and `dlopen`s the app's `CoreGlyphsLib` at
  runtime.
- The `sfsym-gen` target is linked with `-undefined dynamic_lookup` so that symbol can
  stay undefined at link time and resolve after `dlopen`.
- **Soft-fails:** any problem (symbol renamed, framework missing, app absent) logs a
  warning and the pipeline falls back to CoreGlyphs-only restrictions.

This depends on a private, undocumented Apple symbol — expect to update the mangled
name (`nm … | swift demangle | grep decryptObfuscated`) if a future app build changes it.

---

## File map

| File | Responsibility |
|---|---|
| `SFSymbolsGenKit.swift` | `SymbolsApp` (app discovery), `GenError`. |
| `Decrypt.swift` | `symp`-table decryptor → `font_restrictions.tsv`. |
| `GenerateSymbolsJSON.swift` | Merge CoreGlyphs ∪ app metadata, apply draw + restrictions → `symbols.json`. |
| `UpdatePipeline.swift` | `runUpdate`; Draw handling, orchestration, and all generated-source writers. |
| `WrappersSwiftUI.swift` / `WrappersUIKit.swift` | RTF → SwiftUI/UIKit `SFSymbol` initializer wrappers. |

---

## Running

```bash
# Full symbol update (from the repo root):
swift run --package-path Tools sfsym-gen update --app "/Applications/SF Symbols Beta.app"

# Regenerate wrappers from an Xcode-exported documentation RTF:
swift run --package-path Tools sfsym-gen wrappers swiftui --rtf SwiftUIDocumenationFromXcode.rtf
swift run --package-path Tools sfsym-gen wrappers uikit   --rtf UIKitDocumentationFromXcode.rtf
```

See the repo `README.md` ("Updating The Symbols") for the end-to-end maintainer flow.
The Draw category is now extracted automatically (see `DrawExtraction.swift` and the
`update-sf-symbols` skill).

---

## Requirements & guarantees

- **macOS** (uses CoreText/AppKit), the **SF Symbols Beta app** installed, and `swiftc`.
- **Idempotent:** re-running `update` against the same app produces a **zero git diff** —
  this is the acceptance test for any change in here.
- **Models are intentionally duplicated** across files: each ported file keeps its own
  `fileprivate` model types. This was a deliberate faithful-port choice (correctness over
  DRY); consolidating them into one shared model layer is a possible future cleanup.
