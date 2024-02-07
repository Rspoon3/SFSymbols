//
//  SFSymbol+All.swift
//
//
//  Created by Richard Witherspoon on 11/16/21.
//

import Foundation


public extension SFSymbol {
    static var allSymbols: [SFSymbol] {
        var symbols = SFSymbol.allSymbols13
        
        if #available(iOS 13.1, macOS 10.15, tvOS 13.0, watchOS 6.1, visionOS 1.0, *){
            symbols.append(contentsOf: allSymbols13P1)
        }
        
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols14)
        }
        
        
        if #available(iOS 14.2, macOS 11.0, tvOS 14.2, watchOS 7.1, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols14P2)
        }
        
        if #available(iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols14P5)
        }
        
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols15)
        }
        
        if #available(iOS 15.1, macOS 12.0, tvOS 15.1, watchOS 8.1, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols15P1)
        }
        
        if #available(iOS 15.2, macOS 12.1, tvOS 15.2, watchOS 8.3, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols15P2)
        }
        
        if #available(iOS 15.4, macOS 12.3, tvOS 15.4, watchOS 8.5, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols15P4)
        }
        
        if #available(iOS 16, macOS 13, tvOS 16, watchOS 9, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols16)
        }
        
        if #available(iOS 16.1, macOS 13, tvOS 16.1, watchOS 9.1, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols16P1)
        }
        
        if #available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols16P4)
        }
        
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols17)
        }
        
        if #available(iOS 17.1, macOS 14.1, tvOS 17.1, watchOS 10.1, visionOS 1.0, *){
            symbols.append(contentsOf: SFSymbol.allSymbols17P1)
        }
        
        if #available(iOS 17.2, macOS 14.2, tvOS 17.2, watchOS 10.2, visionOS 1.1, *){
            symbols.append(contentsOf: SFSymbol.allSymbols17P2)
        }
        
        return symbols
    }
}
