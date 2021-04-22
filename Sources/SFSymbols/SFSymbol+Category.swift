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
        
        public var symbol: SFSymbol{
            switch self {
            case .all:
                return .squareGrid2X2
            case .whatsNew:
                return .sparkles
            case .multiColor:
                if #available(iOS 14, *) {
                    return .paintpalette
                } else{
                    return .eyedropper
                }
            case .communication:
                return .message
            case .weather:
                return .cloudSun
            case .objectsAndTools:
                return .folder
            case .devices:
                return .desktopcomputer
            case .gaming:
                return .gamecontroller
            case .connectivity:
                return .antennaRadiowavesLeftAndRight
            case .transportation:
                return .carFill
            case .human:
                return .personCropCircle
            case .nature:
                if #available(iOS 14, *) {
                    return .leaf
                } else{
                    return .flame
                }
            case .editing:
                return .sliderHorizontal3
            case .textFormatting:
                return .textformat
            case .media:
                return .playpause
            case .keyboard:
                return .command
            case .commerce:
                return .cart
            case .time:
                return .timer
            case .health:
                return .staroflife
            case .shapes:
                return .squareOnCircle
            case .arrows:
                if #available(iOS 14, *) {
                    return .arrowForward
                } else{
                    return .arrowUturnLeft
                }
            case .indices:
                return .aCircle
            case .math:
                return .xSquareroot
            }
        }
    }
}
