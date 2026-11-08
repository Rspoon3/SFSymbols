//
//  SFCategory.swift
//
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

    public static let all = SFCategory(icon: "square.grid.2x2", title: String(localized: "All", bundle: .module))
    public static let whatsNew = SFCategory(icon: "sparkles", title: String(localized: "What’s New", bundle: .module))
    public static let draw = SFCategory(icon: "scribble", title: String(localized: "Draw", bundle: .module))
    public static let variable = SFCategory(icon: "slider.horizontal.below.square.and.square.filled", title: String(localized: "Variable", bundle: .module))
    public static let multicolor = SFCategory(icon: "paintpalette", title: String(localized: "Multicolor", bundle: .module))
    public static let communication = SFCategory(icon: "message", title: String(localized: "Communication", bundle: .module))
    public static let weather = SFCategory(icon: "cloud.sun", title: String(localized: "Weather", bundle: .module))
    public static let maps = SFCategory(icon: "map", title: String(localized: "Maps", bundle: .module))
    public static let objectsAndTools = SFCategory(icon: "folder", title: String(localized: "Objects & Tools", bundle: .module))
    public static let devices = SFCategory(icon: "desktopcomputer", title: String(localized: "Devices", bundle: .module))
    public static let cameraAndPhotos = SFCategory(icon: "camera", title: String(localized: "Camera & Photos", bundle: .module))
    public static let gaming = SFCategory(icon: "gamecontroller", title: String(localized: "Gaming", bundle: .module))
    public static let connectivity = SFCategory(icon: "antenna.radiowaves.left.and.right", title: String(localized: "Connectivity", bundle: .module))
    public static let transportation = SFCategory(icon: "car.fill", title: String(localized: "Transportation", bundle: .module))
    public static let automotive = SFCategory(icon: "steeringwheel", title: String(localized: "Automotive", bundle: .module))
    public static let accessibility = SFCategory(icon: "accessibility", title: String(localized: "Accessibility", bundle: .module))
    public static let privacyAndSecurity = SFCategory(icon: "lock", title: String(localized: "Privacy & Security", bundle: .module))
    public static let human = SFCategory(icon: "person.crop.circle", title: String(localized: "Human", bundle: .module))
    public static let home = SFCategory(icon: "house", title: String(localized: "Home", bundle: .module))
    public static let fitness = SFCategory(icon: "figure.run", title: String(localized: "Fitness", bundle: .module))
    public static let nature = SFCategory(icon: "leaf", title: String(localized: "Nature", bundle: .module))
    public static let editing = SFCategory(icon: "slider.horizontal.3", title: String(localized: "Editing", bundle: .module))
    public static let textFormatting = SFCategory(icon: "textformat", title: String(localized: "Text Formatting", bundle: .module))
    public static let media = SFCategory(icon: "playpause", title: String(localized: "Media", bundle: .module))
    public static let keyboard = SFCategory(icon: "command", title: String(localized: "Keyboard", bundle: .module))
    public static let commerce = SFCategory(icon: "cart", title: String(localized: "Commerce", bundle: .module))
    public static let time = SFCategory(icon: "timer", title: String(localized: "Time", bundle: .module))
    public static let health = SFCategory(icon: "heart", title: String(localized: "Health", bundle: .module))
    public static let shapes = SFCategory(icon: "square.on.circle", title: String(localized: "Shapes", bundle: .module))
    public static let arrows = SFCategory(icon: "arrow.forward", title: String(localized: "Arrows", bundle: .module))
    public static let indices = SFCategory(icon: "a.circle", title: String(localized: "Indices", bundle: .module))
    public static let math = SFCategory(icon: "radicand.squareroot", title: String(localized: "Math", bundle: .module))

    public static var allCategories: [SFCategory] {
        return [
            .all,
            .whatsNew,
            .draw,
            .variable,
            .multicolor,
            .communication,
            .weather,
            .maps,
            .objectsAndTools,
            .devices,
            .cameraAndPhotos,
            .gaming,
            .connectivity,
            .transportation,
            .automotive,
            .accessibility,
            .privacyAndSecurity,
            .human,
            .home,
            .fitness,
            .nature,
            .editing,
            .textFormatting,
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
