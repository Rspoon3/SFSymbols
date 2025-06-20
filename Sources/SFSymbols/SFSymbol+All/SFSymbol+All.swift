//
//  SFSymbol+All.swift
//
//  Generated Automatically on 6/10/25
//

import Foundation

public extension SFSymbol {
    static var allSymbols: [SFSymbol] {
        var symbols = SFSymbol.allSymbols13

        if #available(iOS 13.1, macOS 10.15, tvOS 13.0, watchOS 6.1, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols13P1)
        }

        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols14)
        }

        if #available(iOS 14.2, macOS 11.0, tvOS 14.2, watchOS 7.1, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols14P2)
        }

        if #available(iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols14P5)
        }

        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols15)
        }

        if #available(iOS 15.1, macOS 12.0, tvOS 15.1, watchOS 8.1, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols15P1)
        }

        if #available(iOS 15.2, macOS 12.1, tvOS 15.2, watchOS 8.3, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols15P2)
        }

        if #available(iOS 15.4, macOS 12.3, tvOS 15.4, watchOS 8.5, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols15P4)
        }

        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols16)
        }

        if #available(iOS 16.1, macOS 13.0, tvOS 16.1, watchOS 9.1, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols16P1)
        }

        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols16P4)
        }

        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols17)
        }

        if #available(iOS 17.1, macOS 14.1, tvOS 17.1, watchOS 10.1, visionOS 1.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols17P1)
        }

        if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols17P2)
        }

        if #available(iOS 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, visionOS 1.1, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols17P4)
        }

        if #available(iOS 17.6, macOS 14.6, tvOS 17.6, watchOS 10.6, visionOS 1.3, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols17P6)
        }

        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols18)
        }

        if #available(iOS 18.1, macOS 15.1, tvOS 18.1, watchOS 11.1, visionOS 2.1, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols18P1)
        }

        if #available(iOS 18.2, macOS 15.2, tvOS 18.2, watchOS 11.2, visionOS 2.2, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols18P2)
        }

        if #available(iOS 18.4, macOS 15.4, tvOS 18.4, watchOS 11.4, visionOS 2.4, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols18P4)
        }

        if #available(iOS 18.5, macOS 15.5, tvOS 18.5, watchOS 11.5, visionOS 2.5, *) {
            symbols.append(contentsOf: SFSymbol.allSymbols18P5)
        }

        return symbols
    }
}
