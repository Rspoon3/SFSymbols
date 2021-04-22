//
//  SFSymbol+Category.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation

public extension SFSymbol{
    enum Category: String, CaseIterable {
        case all
        case whatsNew
        case multiColor
        case communication
        case weather
        case objectsAndTools
        case devices
        case gaming
        case connectivity
        case transportation
        case human
        case nature
        case editing
        case textFormatting
        case media
        case keyboard
        case commerce
        case time
        case health
        case shapes
        case arrows
        case indices
        case math
        
        public var symbols: [SFSymbol]{
            return SFSymbol.allSymbols.filter({$0.categories.contains(self)})
        }
    }
}
