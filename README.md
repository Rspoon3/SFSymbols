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
        .foregroundColor(.red)
    Label("Sunset", symbol: .sunset, textColor: .orange)
        .foregroundColor(.yellow)
}
```


```swift
VStack {
    Button(symbol: .sunset){}
        .foregroundColor(.red)
    Button("Sunset", symbol: .sunset){}
        .foregroundColor(.yellow)
    Button("Sunset", symbol: .sunset, textColor : .orange){}
        .foregroundColor(.yellow)
}
```
                    
## About 
[SFSymbols](https://developer.apple.com/sf-symbols/) are a real treat from Apple. The one downfall however, it is a pain in the neck to look up exact symbol names. Take for example: `"square.and.line.vertical.and.square.fill"`. That is a long string to remember and digging through the catalog of SF Symbols over and over gets tiresome.

Wouldn't it be easier if you could just use code completion?

![](https://media.giphy.com/media/jQ7lTLsv2poo2qLkUA/giphy.gif)

Thats what this micro library aims to do. Additionally, this library includes relevant information on each symbol such as  release info, category, and relevant search terms.

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

Thanks to [Nirma](https://github.com/Nirma) for the idea. This project was highly influence and based off of his [SFSymbol](https://github.com/Nirma/SFSymbol) package. I found that few things I would do differently and before I knew it, I had an offshoot of what he had already done that went in a different direction. I also would like thank [Steven Sorial](https://github.com/StevenSorial) for creating the inspirational and highly popular [SFSafeSymbols](https://github.com/SFSafeSymbols/SFSafeSymbols?tab=readme-ov-file).

## Contributing

If you have any suggestions or ideas for improving the project, please feel free to propose them. You can either create a pull request or open an issue for this project.

## Updating The Symbols
In order to update the symbols please follow the steps below

1. Navigate to /Applications/SF\ Symbols.app/Contents/Resources/Metadata
2. Copy the symbol_categories, symbol_search, name_availability, and categories plist files into the demo projects “SFSymbol App Plist Files”
3. Run the demo project (preferably on a mac)
4. Locate the output files (Check the console logs for the output directory)
5. Use SFCategory.swift to update the corresponding file in the package source files
6. Replace all files in the package SFSymbol+All.swift with the new files generated by the demo project except for SFSymbol+All itself. This file in particular needs to be updated by hand.
7. Replace all files in the package SFSymbol+StaticVariables.swift with the new files generated by the demo project
8. Update the CHANGELOG

## License

SFSymbols is released under the MIT license. [See LICENSE](https://github.com/Rspoon3/SFSymbols/blob/main/LICENSE) for details.

---
Annotations: 0,5392 SHA-256 55be66c90a5ac65d9302fcf8767952c9  
&Writing Tools: 4245,116  
@: 4412 4416,20 4786,50 4854,6  
...
