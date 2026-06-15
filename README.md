# SFSymbols
[![Build Status](https://travis-ci.org/Nirma/SFSymbol.svg?branch=master)](https://travis-ci.org/Nirma/SFSymbol)
![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Version 8.0](https://img.shields.io/badge/version-8.0-blue.svg)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-purple.svg)](https://github.com/apple/swift-package-manager)
![Platforms](https://img.shields.io/badge/Platforms-iOS%20|iPadOS%20|%20tvOS%20|%20watchOS%20|%20macOS-FF69B4.svg)
[![License](http://img.shields.io/:license-mit-blue.svg)](http://doge.mit-license.org)

All the SFSymbols at your fingertips.

## Usage 
`SFSymbol` are `static variables` that contain the identifier strings of all of apple's `SFSymbols` as well as which category they belong to and their availability.

You can iterate through all version compatible symbols by using the 'allSymbols' static variable.

```swift
for symbol in SFSymbol.allSymbols {
	print(symbol.title)
}
```


If you want symbols only in a certain `SFCategory` you can do so like this.

```swift
for symbol in SFCategory.weather.symbols {
	print(symbol.title)
}
```


There are even common, human understandable names for symbols. Feel free extend SFSymbols in your own project for more common names.

```swift
public extension SFSymbol{
    static let share   = squareAndArrowUp
    static let refresh = arrowClockwise
    static let copy    = docOnDoc
    static let writing = squareAndPencil
}

@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0, *)
public extension SFSymbol{
    static let edit    = rectangleAndPencilAndEllipsis
    static let filter  = lineHorizontal2DecreaseCircle
    static let sort    = arrowUpArrowDownCircle
}
```

Additionally, there are extensions multiple extension including `UIImage`, `Image`, `Button`, `Label`, and `UIAction` that enable easy use of any `SFSymbol`.


### UIKit

```swift
UIImage(symbol: .playCircle)
```


### SwiftUI

```swift
Image(symbol: .playCircle)
```


```swift
VStack {
    Label("Sunset", symbol: .sunset)
    Label("Sunset", symbol: .sunset)
        .foregroundStyle(.red)
    Label("Sunset", symbol: .sunset, textColor: .orange)
        .foregroundStyle(.yellow)
}
```


```swift
VStack {
    Button(symbol: .sunset){}
        .foregroundStyle(.red)
    Button("Sunset", symbol: .sunset){}
        .foregroundStyle(.yellow)
    Button("Sunset", symbol: .sunset, textColor : .orange){}
        .foregroundStyle(.yellow)
}
```
                    
## About
[SFSymbols](https://developer.apple.com/sf-symbols/) are a real treat from Apple. The one downfall however, it is a pain in the neck to look up exact symbol names. Take for example: `"square.and.line.vertical.and.square.fill"`. That is a long string to remember and digging through the catalog of SF Symbols over and over gets tiresome.

Wouldn't it be easier if you could just use code completion?

![](https://media.giphy.com/media/jQ7lTLsv2poo2qLkUA/giphy.gif)

Thats what this micro library aims to do. Additionally, this library includes relevant information on each symbol such as  release info, category, and relevant search terms.

## Data Sources

The library generates symbol data from the system CoreGlyphs bundle and the SF Symbols
app (its metadata **and** its font):

### System CoreGlyphs Bundle (Primary — OS-tied)
The system's CoreGlyphs bundle is the **primary** data source, providing:
- Symbol names and availability
- Deprecation aliases (renamed symbols)
- Category mappings

```
/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources/
```

**Why CoreGlyphs?** It's always current with your OS version and contains the same data
`UIImage(systemName:)` uses at runtime, so names match what the OS supports and
deprecation warnings point to symbols that exist. Because it's **tied to the installed
OS**, run the update on the latest macOS for current deprecation/availability data — see
[Updating The Symbols](#updating-the-symbols).

### SF Symbols App (Supplementary — OS-independent)
The app ships its own metadata and font, read directly from the app bundle. Because this
travels with the app, it stays correct **even on an older macOS**:
- **App `Metadata/`** — symbols for an unreleased OS not yet in CoreGlyphs, layerset
  availability (hierarchical/multicolor), category labels, search terms.
- **App font (`symp` table, decrypted)** — authoritative **use-restrictions** and
  **Unicode code points**, including for new-OS symbols CoreGlyphs doesn't yet know.
- **Draw category** — computed by driving the app's own `hasDrawInfo` logic under lldb;
  it isn't stored in any metadata file (see [Updating The Symbols](#updating-the-symbols)).

```
/Applications/SF Symbols.app/Contents/Resources/Metadata/
```

## Build Performance

SFSymbols is a large, fully generated library: **77 source files / ~104,000 lines**, of
which the `SFSymbol+StaticVariables*.swift` files account for **~94,000 lines (≈90%)** —
one `static var` per symbol. That bulk is what drives compile time, so it's worth knowing
what to expect.

### Results

Measured with `swift build -c debug`, 5 runs each, averaged. Machine: Apple M4 Pro
(14 cores), macOS 26.5.1, Swift 6.3.2.

| Scenario | What it measures | Avg | Individual runs (s) |
|---|---|---:|---|
| **Clean build** | `rm -rf .build` before each run — compiles everything from scratch | **9.61 s** | 9.97 / 9.51 / 9.35 / 9.86 / 9.36 |
| **Incremental build** | Touch one source file, rebuild | **5.80 s** | 5.81 / 5.73 / 5.82 / 5.78 / 5.88 |
| **Warm no-op build** | Nothing changed | **0.50 s** | 0.51 / 0.49 / 0.49 / 0.50 / 0.50 |

### Takeaways

- The cost is concentrated in the generated static-variable files; the five largest alone
  total ~68,000 lines.
- Because every symbol lives in the **same module**, even a one-file edit forces the module
  to be re-emitted — hence incremental builds (~5.8 s) cost more than half of a clean
  build. There is no per-symbol tree-shaking at the source level.
- **This only hits when SFSymbols itself is (re)compiled.** In a consumer app the
  compiled module is cached, so it's paid once on a clean build / fresh CI checkout and is
  ~0 on subsequent warm and incremental app builds.

### Reproducing this test

From the repository root:

```bash
# 1. Clean build (compiles everything from scratch)
rm -rf .build && time swift build -c debug

# 2. Warm no-op build (run immediately after a successful build)
time swift build -c debug

# 3. Incremental build (single-file edit)
touch Sources/SFSymbols/Models/SFCategory.swift
time swift build -c debug
```

For an averaged run (5 iterations of each), use the helper below:

```bash
avg() { local s=0; for v in "$@"; do s=$((s+v)); done; echo "scale=3; $s/$#/1000" | bc; }

clean=(); for i in $(seq 5); do rm -rf .build; s=$(date +%s%N); \
  swift build -c debug >/dev/null 2>&1; clean+=($(( ($(date +%s%N)-s)/1000000 ))); done
echo "Clean avg: $(avg ${clean[@]})s — runs: ${clean[*]}"

swift build -c debug >/dev/null 2>&1   # warm
noop=(); for i in $(seq 5); do s=$(date +%s%N); \
  swift build -c debug >/dev/null 2>&1; noop+=($(( ($(date +%s%N)-s)/1000000 ))); done
echo "No-op avg: $(avg ${noop[@]})s — runs: ${noop[*]}"

inc=(); for i in $(seq 5); do touch Sources/SFSymbols/Models/SFCategory.swift; s=$(date +%s%N); \
  swift build -c debug >/dev/null 2>&1; inc+=($(( ($(date +%s%N)-s)/1000000 ))); done
echo "Incremental avg: $(avg ${inc[@]})s — runs: ${inc[*]}"
```

> Absolute numbers depend on your hardware and toolchain; the **relative** cost
> (clean ≫ incremental ≫ no-op) is what's meaningful.

## Installation

### Swift Package Manager
Since Xcode integrated swift package manager natively into the IDE you can add SFSymbol simply by:

**`File`-> `Swift Packages` -> `Add Package Dependency...`**

when prompted to enter a package URL paste: 

`https://github.com/Rspoon3/SFSymbols` 


and click next & finish to automagically install SFSymbol through Xcode & SPM!

### Manual 
Don't want that additional third party dependency? Then just simply copy over the files into your project's appropriate folder!

## Acknowledgments

Thanks to [Nirma](https://github.com/Nirma) for the idea. This project was highly influence and based off of his [SFSymbol](https://github.com/Nirma/SFSymbol) package. I found that few things I would do differently and before I knew it, I had an offshoot of what he had already done that went in a different direction. I also would like thank [Steven Sorial](https://github.com/StevenSorial) for creating the inspirational and highly popular [SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols).

## Contributing

If you have any suggestions or ideas for improving the project, please feel free to propose them. You can either create a pull request or open an issue for this project.

## Updating The Symbols

To update the SFSymbols files, follow these steps. The `sfsym-gen update` command will automatically handle updating all relevant files in place.

> **Important:** Run the update on the latest macOS. The system **CoreGlyphs bundle** is tied to your OS and supplies deprecation aliases, base availability, and category mappings, so an older macOS may yield missing or outdated deprecation data. This is now the *only* reason to be current — use-restrictions and Unicode code points come authoritatively from the app's font, and the Draw category is computed from the app itself, all OS-independent.

1. **Navigate to the `SFSymbols` directory** in your terminal:

    ```bash
    cd path/to/SFSymbols
    ```

2. **Draw category (automatic):**

   The "Draw" category isn't in any metadata file — the app computes it at render time
   from glyph geometry. The update extracts it automatically by driving the app's own
   `hasDrawInfo` logic under lldb (it clones and ad-hoc re-signs the app, so **Xcode
   command-line tools** must be installed). No manual step is required; it falls back to
   a clipboard prompt only if extraction fails. See the `update-sf-symbols` skill for
   details and the `--draw-func` override.

3. **Run the update command** with the path to your SF Symbols application:

    ```bash
    swift run --package-path Tools sfsym-gen update --app "/Applications/SF Symbols Beta.app"
    ```

4. **Update the `CHANGELOG.md`** with any relevant notes about the new symbols or changes.

> **Note:** The Draw category is written to a temporary `draw.txt` during the update and cleaned up automatically afterward. Pre-stage your own `draw.txt` in the repo root to skip auto-extraction.

> **Use-restrictions:** The update command automatically decrypts the SF Symbols app's font `symp` metadata table in-process, reusing the app's own routine to extract authoritative use-restriction text (written to a temporary `font_restrictions.tsv`). This covers symbols for an unreleased OS that the system CoreGlyphs bundle doesn't yet know about. It resolves a private framework symbol at runtime (via `dlopen` of the app's CoreGlyphsLib) and is used only for local code generation — never shipped. If it ever fails (e.g. Apple renames the symbol), the command logs a warning and falls back to CoreGlyphs restrictions.

## Generating SwiftUI Wrapper Extensions

The project includes an automated script to generate SwiftUI initializer wrappers that accept `SFSymbol` instead of `String` for system image parameters.

### How It Works

The `sfsym-gen wrappers` subcommand:
1. Parses SwiftUI (or UIKit) documentation exported from Xcode
2. Extracts initializers with `systemImage` (or UIKit `image`) parameters
3. Generates extension files with wrapped initializers that accept `SFSymbol`
4. Preserves documentation, availability attributes, and generic constraints

### Running the Generator

1. **Export SwiftUI documentation** from Xcode:
   - Open the SwiftUI framework in Xcode
   - Export the interface to an RTF file
   - Save as `SwiftUIDocumenationFromXcode.rtf` in the project root

2. **Run the generation command** (from the repository root):
   ```bash
   swift run --package-path Tools sfsym-gen wrappers swiftui --rtf SwiftUIDocumenationFromXcode.rtf
   ```

   To generate the UIKit wrappers instead, export the UIKit documentation and run:
   ```bash
   swift run --package-path Tools sfsym-gen wrappers uikit --rtf UIKitDocumentation.rtf
   ```

3. **Verify the output**:
   ```bash
   swift build
   ```

The script generates extension files in `Sources/SFSymbols/Extensions/` for SwiftUI types including:
- Button, ContentUnavailableView, ControlGroup, Label
- Menu, MenuBarExtra, Picker, Tab, Toggle

### Example Generated Code

Input (from SwiftUI documentation):
```swift
@available(iOS 14.0, *)
extension Button where Label == Label<Text, Image> {
    public init(_ titleKey: LocalizedStringKey, systemImage: String, action: @escaping () -> Void)
}
```

Output (generated wrapper):
```swift
@available(iOS 14.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button that generates its label from a localized string key and symbol.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, action: @escaping () -> Void) {
        self.init(titleKey, systemImage: symbol.title, action: action)
    }
}
```

## License

SFSymbols is released under the MIT license. [See LICENSE](https://github.com/Rspoon3/SFSymbols/blob/main/LICENSE) for details.
