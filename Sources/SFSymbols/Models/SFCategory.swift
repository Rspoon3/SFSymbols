//
//  SFCategory.swift
//  
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation


public struct SFCategory: Identifiable, Codable, Equatable, Hashable{
    public let icon: String
    public let title: String
    
    enum CodingKeys: String, CodingKey {
        case icon
        case title = "key"
    }
    
    
    public var id: String{
        title
    }
    
    @available(iOS 15.1, *)
    public var symbols: [SFSymbol]{
        switch self{
        case .all:
            return SFSymbol.allSymbols()
        default:
            return SFSymbol.allSymbols().filter({$0.categories?.contains(self) ?? false})
        }
    }
    
    public var originalTitle: String{
        switch self{
        case .all:
            return "all"
        case .whatsnew:
            return "whatsnew"
        case .multicolor:
            return "multicolor"
        case .communication:
            return "communication"
        case .weather:
            return "weather"
        case .objectsandtools:
            return "objectsandtools"
        case .devices:
            return "devices"
        case .gaming:
            return "gaming"
        case .connectivity:
            return "connectivity"
        case .transportation:
            return "transportation"
        case .human:
            return "human"
        case .nature:
            return "nature"
        case .editing:
            return "editing"
        case .textformatting:
            return "textformatting"
        case .media:
            return "media"
        case .keyboard:
            return "keyboard"
        case .commerce:
            return "commerce"
        case .time:
            return "time"
        case .health:
            return "health"
        case .shapes:
            return "shapes"
        case .arrows:
            return "arrows"
        case .indices:
            return "indices"
        case .math:
            return "math"
        default:
            return "questionmark"
        }
    }
    
    
    //MARK: Static Data
    public static let all             = SFCategory(icon: "square.grid.2x2", title: "All")
    public static let whatsnew        = SFCategory(icon: "sparkles", title: "What's New")
    public static let multicolor      = SFCategory(icon: "eyedropper", title: "Multicolor")
    public static let communication   = SFCategory(icon: "message", title: "Communication")
    public static let weather         = SFCategory(icon: "cloud.sun", title: "Weather")
    public static let objectsandtools = SFCategory(icon: "folder", title: "Objects & Tools")
    public static let devices         = SFCategory(icon: "desktopcomputer", title: "Devices")
    public static let gaming          = SFCategory(icon: "gamecontroller", title: "Gaming")
    public static let connectivity    = SFCategory(icon: "antenna.radiowaves.left.and.right", title: "Connectivity")
    public static let transportation  = SFCategory(icon: "car.fill", title: "Transportation")
    public static let human           = SFCategory(icon: "person.crop.circle", title: "Human")
    public static let nature          = SFCategory(icon: "flame", title: "Nature")
    public static let editing         = SFCategory(icon: "slider.horizontal.3", title: "Editing")
    public static let textformatting  = SFCategory(icon: "textformat.size.smaller", title: "Text Formatting")
    public static let media           = SFCategory(icon: "playpause", title: "Media")
    public static let keyboard        = SFCategory(icon: "command", title: "Keyboard")
    public static let commerce        = SFCategory(icon: "cart", title: "Commerce")
    public static let time            = SFCategory(icon: "timer", title: "Time")
    public static let health          = SFCategory(icon: "staroflife", title: "Health")
    public static let shapes          = SFCategory(icon: "square.on.circle", title: "Shapes")
    public static let arrows          = SFCategory(icon: "arrow.right", title: "Arrows")
    public static let indices         = SFCategory(icon: "a.circle", title: "Indices")
    public static let math            = SFCategory(icon: "x.squareroot", title: "Math")
    
    
    public static func allCategories() -> [SFCategory]{
        return [
            .all,
            .whatsnew,
            .multicolor,
            .communication,
            .weather,
            .objectsandtools,
            .devices,
            .gaming,
            .connectivity,
            .transportation,
            .human,
            .nature,
            .editing,
            .textformatting,
            .media,
            .keyboard,
            .commerce,
            .time,
            .health,
            .shapes,
            .arrows,
            .indices,
            .math,
        ]
    }
}

