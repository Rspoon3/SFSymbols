//
//  SFCategory.swift
//  
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation


public struct SFCategory: Identifiable, Codable, Equatable{
    public let icon: String
    public let title: String
    
    enum CodingKeys: String, CodingKey {
        case icon
        case title = "key"
    }
    
    
    public var id: String{
        title
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
    static let all             = SFCategory(icon: "square.grid.2x2", title: "All")
    static let whatsnew        = SFCategory(icon: "sparkles", title: "What's New")
    static let multicolor      = SFCategory(icon: "eyedropper", title: "Multicolor")
    static let communication   = SFCategory(icon: "message", title: "Communication")
    static let weather         = SFCategory(icon: "cloud.sun", title: "Weather")
    static let objectsandtools = SFCategory(icon: "folder", title: "Objects & Tools")
    static let devices         = SFCategory(icon: "desktopcomputer", title: "Devices")
    static let gaming          = SFCategory(icon: "gamecontroller", title: "Gaming")
    static let connectivity    = SFCategory(icon: "antenna.radiowaves.left.and.right", title: "Connectivity")
    static let transportation  = SFCategory(icon: "car.fill", title: "Transportation")
    static let human           = SFCategory(icon: "person.crop.circle", title: "Human")
    static let nature          = SFCategory(icon: "flame", title: "Nature")
    static let editing         = SFCategory(icon: "slider.horizontal.3", title: "Editing")
    static let textformatting  = SFCategory(icon: "textformat.size.smaller", title: "Text Formatting")
    static let media           = SFCategory(icon: "playpause", title: "Media")
    static let keyboard        = SFCategory(icon: "command", title: "Keyboard")
    static let commerce        = SFCategory(icon: "cart", title: "Commerce")
    static let time            = SFCategory(icon: "timer", title: "Time")
    static let health          = SFCategory(icon: "staroflife", title: "Health")
    static let shapes          = SFCategory(icon: "square.on.circle", title: "Shapes")
    static let arrows          = SFCategory(icon: "arrow.right", title: "Arrows")
    static let indices         = SFCategory(icon: "a.circle", title: "Indices")
    static let math            = SFCategory(icon: "x.squareroot", title: "Math")
}

