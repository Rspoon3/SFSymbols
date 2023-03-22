//
//  SFCategory.swift
//  
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation


public struct SFCategory: Identifiable, Codable, Equatable, Hashable {
    public let icon: String
    public let title: String
    public var id: String { title }
    public let plistTitle: String
    
    public var symbols: [SFSymbol]{
        if self == .all {
            return SFSymbol.allSymbols
        } else {
            return SFSymbol.allSymbols.filter { $0.categories?.contains(self) ?? false }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case icon
        case title = "label"
        case plistTitle = "key"
    }
    
    //MARK: Static Data
    public static let all  = SFCategory(icon: "square.grid.2x2", title: "All", plistTitle: "all")
    public static let whatsnew  = SFCategory(icon: "sparkles", title: "What’s New", plistTitle: "whatsnew")
    public static let multicolor  = SFCategory(icon: "paintpalette", title: "Multicolor", plistTitle: "multicolor")
    public static let variablecolor  = SFCategory(icon: "slider.horizontal.below.square.and.square.filled", title: "Variable Color", plistTitle: "variablecolor")
    public static let communication  = SFCategory(icon: "message", title: "Communication", plistTitle: "communication")
    public static let weather  = SFCategory(icon: "cloud.sun", title: "Weather", plistTitle: "weather")
    public static let objectsandtools  = SFCategory(icon: "folder", title: "Objects & Tools", plistTitle: "objectsandtools")
    public static let devices  = SFCategory(icon: "desktopcomputer", title: "Devices", plistTitle: "devices")
    public static let cameraandphotos  = SFCategory(icon: "camera", title: "Camera & Photos", plistTitle: "cameraandphotos")
    public static let gaming  = SFCategory(icon: "gamecontroller", title: "Gaming", plistTitle: "gaming")
    public static let connectivity  = SFCategory(icon: "antenna.radiowaves.left.and.right", title: "Connectivity", plistTitle: "connectivity")
    public static let transportation  = SFCategory(icon: "car.fill", title: "Transportation", plistTitle: "transportation")
    public static let automotive  = SFCategory(icon: "steeringwheel", title: "Automotive", plistTitle: "automotive")
    public static let accessibility  = SFCategory(icon: "figure.roll.runningpace", title: "Accessibility", plistTitle: "accessibility")
    public static let privacyandsecurity  = SFCategory(icon: "lock", title: "Privacy & Security", plistTitle: "privacyandsecurity")
    public static let human  = SFCategory(icon: "person.crop.circle", title: "Human", plistTitle: "human")
    public static let home  = SFCategory(icon: "house", title: "Home", plistTitle: "home")
    public static let fitness  = SFCategory(icon: "figure.run", title: "Fitness", plistTitle: "fitness")
    public static let nature  = SFCategory(icon: "leaf", title: "Nature", plistTitle: "nature")
    public static let editing  = SFCategory(icon: "slider.horizontal.3", title: "Editing", plistTitle: "editing")
    public static let textformatting  = SFCategory(icon: "textformat", title: "Text Formatting", plistTitle: "textformatting")
    public static let media  = SFCategory(icon: "playpause", title: "Media", plistTitle: "media")
    public static let keyboard  = SFCategory(icon: "command", title: "Keyboard", plistTitle: "keyboard")
    public static let commerce  = SFCategory(icon: "cart", title: "Commerce", plistTitle: "commerce")
    public static let time  = SFCategory(icon: "timer", title: "Time", plistTitle: "time")
    public static let health  = SFCategory(icon: "heart", title: "Health", plistTitle: "health")
    public static let shapes  = SFCategory(icon: "square.on.circle", title: "Shapes", plistTitle: "shapes")
    public static let arrows  = SFCategory(icon: "arrow.forward", title: "Arrows", plistTitle: "arrows")
    public static let indices  = SFCategory(icon: "a.circle", title: "Indices", plistTitle: "indices")
    public static let math  = SFCategory(icon: "x.squareroot", title: "Math", plistTitle: "math")
    
    
    public static var allCategories: [SFCategory] {
        return [
            .all,
            .whatsnew,
            .multicolor,
            .variablecolor,
            .communication,
            .weather,
            .objectsandtools,
            .devices,
            .cameraandphotos,
            .gaming,
            .connectivity,
            .transportation,
            .automotive,
            .accessibility,
            .privacyandsecurity,
            .human,
            .home,
            .fitness,
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
            .math
        ]
    }
}
