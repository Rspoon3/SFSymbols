# Change Log

## Version 3.0 (12-8-2025)
### Additions
- Added 392 new symbols for iOS 26.0 (SF Symbols 7) and equivalent versions on other platforms
- Added `layersets` property to SFSymbol indicating supported rendering modes (monochrome, hierarchical, multicolor)
- Added `localizations` property with available language-specific variants and their availability info
- Added `categories` property showing which SF Symbol categories a symbol belongs to
- Added `restriction` property with Apple's usage restriction notes
- Added `deprecatedNewName` property for renamed symbols with proper `@available` deprecation annotations
- Added Draw category support (manually captured since Apple excludes it from metadata)
- Added `GenerateSymbolsJSON.swift` for comprehensive symbol metadata extraction
- Added `Layerset` and `Localization` model types

### Changed
- Deprecation data now sourced from system CoreGlyphs bundle instead of SF Symbols app for accurate runtime-matching warnings
- Updated README with Data Sources documentation explaining where symbol data comes from
- Updated README with instructions for the Draw category clipboard capture process
- Smart handling of RTL variants - phantom `.slash.rtl` symbols are now properly skipped

### Fixed
- Fixed phantom symbols like `square.3.layers.3d.down.forward.slash` that don't actually exist (only their `.rtl` variant exists)

-----
## Version 2.8.1 (6-15-2025)
### Fixed
- Mac compilation fixes

-----
## Version 2.8 (6-15-2025)
### Additions
- Added release automation via GitHub Actions (release on tag)
- Added additional SwiftUI and UIKit convenience extensions
- Updated StandardNames with more common symbol aliases

### Changed
- Explicit Swift 6 language mode

### Removed
- Removed unused NameAvailabilityResults file

-----
## Version 2.7 (6-9-2025)
### Additions
- Added symbols for iOS 18.0, 18.1, 18.2, 18.4, 18.5 and their equivalent version on other platforms
- Added symbols from [SFSymbols Version 7.0 (109)](https://developer.apple.com/sf-symbols/) for iOS 26.0 and their equivalent version on other platforms

-----
## Version 2.6.1 (11-6-2024)
### Fixed
- watchOS compilation fixes

-----
## Version 2.6 (11-6-2024)
### Additions
- Added symbols for iOS 17.4, 17.6, 18.0 and their equivalent version on other platforms.
- Numbers are now prefixed with an underscore to be more inline with other similar libraries such as [SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols)
- Now excluding the demo project from the package
- Added Swift 6 support
- Better handling of symbols that have the same title as Swift keywords
- Added instructions in the README for how to update the symbols

-----
## Version 2.5 (2-7-2024)
### Additions
- Added symbols for iOS 16.4, 17.0, 17.1, 17.2 and their equivalent version on other platforms.
- Updated SFCategories
- Explicit tvOS support

### Fixed
- Fixed missing version 2.4 CHANGELOG entry
- Fixed SFCategory including a plist title
- Fixed Swift Build badge in the README

-----
## Version 2.4 (2-7-2024)
### Additions
- Enabled compilation on Linux
- visionOS support

-----
## Version 2.3 (3-22-2023)
### Additions
- Updated for SF Symbols 4.0
- Additional documentation
- Additional unit tests

### Removals
- ```plistTitle``` from ```SFCategory```

### Fixes
- Mac unit tests

### Notes
- Refactored & renamed demo app

-----
## Version 2.2 (4-22-2022)
### Additions
- Updated for SF Symbols 3.3
- Added additional UIKit extensions
- Added UIBarButtonItem extension

### Fixes
- Added missing StaticVariables13P1 file

-----
## Version 2.1 (3-20-2022)
### Additions
- Added UIAction extension
- Created a Mac app for the preview application
- Added better search support for preview app
- Small README updates

### Fixes
- Removed iOS 15 limitation for filter common name
- Now separating static vars into multiple files so Xcode doesn't crash from one giant file.

### Notes
- Simplified package updating process

-----
## Version 2.0.0 (1-14-2022)
### Additions
- Updated for SFSymbols App Version 3.2
- Added button role extension
- Added a label initializer from a regular string
- Added preview application

### Fixes
- Removed iOS 15.1 limitation for allSymbols

### Notes
- New way to update this package
- Updated README

-----
## Version 1.0.3 (4-22-2021)
### Additions
- Category now has human readable raw values
- Category conforms to Hashable
- Added a symbol for each Category.

### Fixes
- Filter should be 3 lines instead of 2. See apple mail for an example.

-----
## Version 1.0.2 (4-22-2021)
### Additions
- Added more common names
- New test case to test all symbols are unique
- SFSymbol now conforms to Hashable

### Fixes
- Fixed having iOS 13 symbols in allSymbols14

-----
## Version 1.0.1 (4-22-2021)
### Additions
-  Updated README

-----
## Version 1.0.0 (4-22-2021)
Initial Release
