# Change Log
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
