//
//  SFSymbol+Category.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation

public extension SFSymbol{
    enum Category: String, CaseIterable, Hashable{
        case all             = "All"
        case whatsNew        = "What's New"
        case multiColor      = "Multicolor"
        case communication   = "Communication"
        case weather         = "Weather"
        case objectsAndTools = "Objects & Tools"
        case devices         = "Devices"
        case gaming          = "Gaming"
        case connectivity    = "Connectivity"
        case transportation  = "Transportation"
        case human           = "Human"
        case nature          = "Nature"
        case editing         = "Editing"
        case textFormatting  = "Text Formatting"
        case media           = "Media"
        case keyboard        = "Keyboard"
        case commerce        = "Commerce"
        case time            = "Time"
        case health          = "Health"
        case shapes          = "Shapes"
        case arrows          = "Arrows"
        case indices         = "Indices"
        case math            = "Math"
        
        public var symbols: [SFSymbol]{
            return SFSymbol.allSymbols.filter({$0.categories.contains(self)})
        }
    }
}
