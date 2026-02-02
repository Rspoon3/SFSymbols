# SFSymbols
[![Build Status](https://travis-ci.org/Nirma/SFSymbol.svg?branch=master)](https://travis-ci.org/Nirma/SFSymbol)
![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)
![Version 3.0](https://img.shields.io/badge/version-3.0-blue.svg)
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

The library generates symbol data from two sources:

### System CoreGlyphs Bundle (Primary)
The system's CoreGlyphs bundle is the **primary** data source, providing:
- Symbol names and availability
- Deprecation aliases (renamed symbols)
- Category mappings
- Usage restrictions

```
/System/Library/CoreServices/CoreGlyphs.bundle/Contents/Resources/
```

**Why CoreGlyphs?** This bundle is always current with your OS version and contains the same data that `UIImage(systemName:)` uses at runtime. Using CoreGlyphs ensures:
- Symbol names match what the OS actually supports
- Deprecation warnings point to symbols that exist
- Generated code stays in sync with runtime behavior

### SF Symbols App Metadata (Supplementary)
The SF Symbols app provides supplementary data not available in CoreGlyphs:
- Layerset availability (hierarchical, multicolor rendering support)
- Category definitions (human-readable labels)

```
/Applications/SF Symbols.app/Contents/Resources/Metadata/
```

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

To update the SFSymbols files, follow these steps. The `UpdateScript.swift` will automatically handle updating all relevant files in place.

> **Important:** Run the update script on the latest macOS version. The deprecation data comes from the system's CoreGlyphs bundle, which is updated with each OS release. Using an older macOS may result in missing or outdated deprecation warnings.

1. **Navigate to the `SFSymbols` directory** in your terminal:

    ```bash
    cd path/to/SFSymbols
    ```

2. **Prepare the Draw category** (first time only):

   The "Draw" category is not included in Apple's `symbol_categories.plist`, so it must be captured manually:
   - Open the SF Symbols app
   - Select "Draw" from the sidebar
   - Select all symbols (Cmd+A)
   - Copy symbol names (Cmd+Shift+C)

   When you run the update script, it will prompt you to press Enter to read from your clipboard.

3. **Run the update script** with the path to your SF Symbols application:

    ```bash
    swift UpdateScript.swift /Applications/SF\ Symbols\ beta.app
    ```

4. **Update the `CHANGELOG.md`** with any relevant notes about the new symbols or changes.

> **Note:** The Draw category symbols are saved to `draw.txt` during the update and cleaned up automatically afterward. If you need to update the Draw category in subsequent runs, delete any existing `draw.txt` file first.

## Generating SwiftUI Wrapper Extensions

The project includes an automated script to generate SwiftUI initializer wrappers that accept `SFSymbol` instead of `String` for system image parameters.

### How It Works

The `ParseSwiftUIDoc.swift` script:
1. Parses SwiftUI documentation exported from Xcode
2. Extracts initializers with `systemImage` parameters
3. Generates extension files with wrapped initializers that accept `SFSymbol`
4. Preserves documentation, availability attributes, and generic constraints

### Running the Generator

1. **Export SwiftUI documentation** from Xcode:
   - Open the SwiftUI framework in Xcode
   - Export the interface to an RTF file
   - Save as `SwiftUIDocumenationFromXcode.rtf` in the project root

2. **Run the generation script**:
   ```bash
   swift ParseSwiftUIDoc.swift SwiftUIDocumenationFromXcode.rtf
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
