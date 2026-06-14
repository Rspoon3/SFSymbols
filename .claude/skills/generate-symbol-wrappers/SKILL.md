---
name: generate-symbol-wrappers
description: Regenerate the SwiftUI/UIKit SFSymbol initializer wrapper extensions from an exported Xcode documentation RTF, via the sfsym-gen CLI. Use when refreshing the type-safe `symbol:` initializers for SwiftUI (Button, Label, Menu, etc.) or UIKit (UIAction, UIMenu, etc.).
---

# Generate SFSymbol Wrapper Extensions

Generates the wrapper initializers that accept `SFSymbol` instead of `String` for
system-image parameters, writing into `Sources/SFSymbols/Extensions/`. Backed by
`generateSwiftUIWrappers` / `generateUIKitWrappers` in `Tools/Sources/SFSymbolsGenKit`.
Run from the repository root.

## 1. Export the documentation RTF from Xcode
The generator's **input** is an RTF export of the framework interface (this is not
committed — `*.rtf` is gitignored):
- Open the **SwiftUI** (or **UIKit**) framework interface in Xcode.
- Export/save the interface to RTF, e.g. `SwiftUIDocumenationFromXcode.rtf` in the repo
  root.

## 2. Generate
```bash
# SwiftUI:
swift run --package-path Tools sfsym-gen wrappers swiftui --rtf SwiftUIDocumenationFromXcode.rtf

# UIKit:
swift run --package-path Tools sfsym-gen wrappers uikit --rtf UIKitDocumentationFromXcode.rtf
```
This parses initializers with `systemImage:` / `image:` parameters and emits extension
files that wrap them with a type-safe `symbol: SFSymbol` parameter, preserving
documentation, availability attributes, and generic constraints.

## 3. Verify
```bash
swift build
git diff --stat -- Sources/SFSymbols/Extensions
```
Review the regenerated extensions. There is no input RTF in the repo, so there is no
automated zero-diff check for this step — review the diff manually.

## Notes
- Output goes to `Sources/SFSymbols/Extensions/` (Button, ContentUnavailableView,
  ControlGroup, Label, Menu, MenuBarExtra, Picker, Tab, Toggle for SwiftUI; UIAction,
  UICommand, UIKeyCommand, UIMenu, UIWindowScene.ActivationAction for UIKit).
- Delete stale `.rtf` exports after running — they should not be committed.
- See `Tools/Sources/SFSymbolsGenKit/README.md` for details.
