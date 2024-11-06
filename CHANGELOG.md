# Change Log
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
