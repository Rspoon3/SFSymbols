//
//  File.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation

public extension SFSymbol{
    static var allSymbols: [SFSymbol]{
        if #available(iOS 14, *) {
            return SFSymbol.allSymbols13 + SFSymbol.allSymbols14
        } else {
            return SFSymbol.allSymbols13
        }
    }
}
