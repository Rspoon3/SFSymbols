//
//  SFCategory.swift
//
//  Generated Automatically on 6/10/25
//

import Foundation

public struct SFCategory: Identifiable, Codable, Equatable, Hashable, Sendable {
    public let icon: String
    public let title: String
    public var id: String { title }

    public var symbols: [SFSymbol] {
        if self == .all {
            return SFSymbol.allSymbols
        } else {
            return SFSymbol.allSymbols.filter { $0.categories?.contains(self) ?? false }
        }
    }

    enum CodingKeys: String, CodingKey {
        case icon
        case title = "label"
    }

    // MARK: - Static Data

    public static let all = SFCategory(icon: "square.grid.2x2", title: "All")
    public static let whatsnew = SFCategory(icon: "sparkles", title: "What’s New")
    public static let draw = SFCategory(icon: "scribble", title: "Draw")
    public static let variable = SFCategory(icon: "slider.horizontal.below.square.and.square.filled", title: "Variable")
    public static let multicolor = SFCategory(icon: "paintpalette", title: "Multicolor")
    public static let communication = SFCategory(icon: "message", title: "Communication")
    public static let weather = SFCategory(icon: "cloud.sun", title: "Weather")
    public static let maps = SFCategory(icon: "map", title: "Maps")
    public static let objectsandtools = SFCategory(icon: "folder", title: "Objects & Tools")
    public static let devices = SFCategory(icon: "desktopcomputer", title: "Devices")
    public static let cameraandphotos = SFCategory(icon: "camera", title: "Camera & Photos")
    public static let gaming = SFCategory(icon: "gamecontroller", title: "Gaming")
    public static let connectivity = SFCategory(icon: "antenna.radiowaves.left.and.right", title: "Connectivity")
    public static let transportation = SFCategory(icon: "car.fill", title: "Transportation")
    public static let automotive = SFCategory(icon: "steeringwheel", title: "Automotive")
    public static let accessibility = SFCategory(icon: "accessibility", title: "Accessibility")
    public static let privacyandsecurity = SFCategory(icon: "lock", title: "Privacy & Security")
    public static let human = SFCategory(icon: "person.crop.circle", title: "Human")
    public static let home = SFCategory(icon: "house", title: "Home")
    public static let fitness = SFCategory(icon: "figure.run", title: "Fitness")
    public static let nature = SFCategory(icon: "leaf", title: "Nature")
    public static let editing = SFCategory(icon: "slider.horizontal.3", title: "Editing")
    public static let textformatting = SFCategory(icon: "textformat", title: "Text Formatting")
    public static let media = SFCategory(icon: "playpause", title: "Media")
    public static let keyboard = SFCategory(icon: "command", title: "Keyboard")
    public static let commerce = SFCategory(icon: "cart", title: "Commerce")
    public static let time = SFCategory(icon: "timer", title: "Time")
    public static let health = SFCategory(icon: "heart", title: "Health")
    public static let shapes = SFCategory(icon: "square.on.circle", title: "Shapes")
    public static let arrows = SFCategory(icon: "arrow.forward", title: "Arrows")
    public static let indices = SFCategory(icon: "a.circle", title: "Indices")
    public static let math = SFCategory(icon: "x.squareroot", title: "Math")

    public static var allCategories: [SFCategory] {
        return [
            .all,
            .whatsnew,
            .draw,
            .variable,
            .multicolor,
            .communication,
            .weather,
            .maps,
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