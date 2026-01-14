//
//  SFSymbol+StaticVariables15P4.swift
//
//

import Foundation
import Foundation

@available(iOS 15.4, macOS 12.3, tvOS 15.4, watchOS 8.5, visionOS 1.0, *)
public extension SFSymbol {
    /// camera.macro
    /// - Since: iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0
    /// - Layersets: monochrome
    static let cameraMacro = SFSymbol(
        title: "camera.macro",
        categories: [.cameraAndPhotos, .nature],
        searchTerms: ["macro"],
        releaseInfo: ReleaseInfo(iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0),
        layersets: [.monochrome]
    )

    /// camera.macro.circle
    /// - Since: iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    static let cameraMacroCircle = SFSymbol(
        title: "camera.macro.circle",
        categories: [.cameraAndPhotos, .nature, .variable, .draw],
        searchTerms: ["macro"],
        releaseInfo: ReleaseInfo(iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical]
    )

    /// camera.macro.circle.fill
    /// - Since: iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical, multicolor
    static let cameraMacroCircleFill = SFSymbol(
        title: "camera.macro.circle.fill",
        categories: [.cameraAndPhotos, .multicolor, .nature],
        searchTerms: ["macro"],
        releaseInfo: ReleaseInfo(iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical, .multicolor]
    )

    /// dots.and.line.vertical.and.cursorarrow.rectangle
    /// - Since: iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "dotsAndLineVerticalAndPointerArrowRectangle", message: "Use 'dotsAndLineVerticalAndPointerArrowRectangle' instead. This symbol has been renamed.")
    static let dotsAndLineVerticalAndCursorarrowRectangle = SFSymbol(
        title: "dots.and.line.vertical.and.cursorarrow.rectangle",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "dots.and.line.vertical.and.pointer.arrow.rectangle"
    )

    /// key.viewfinder
    /// - Since: iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    static let keyViewfinder = SFSymbol(
        title: "key.viewfinder",
        categories: [.objectsAndTools, .privacyAndSecurity],
        searchTerms: ["password", "security"],
        releaseInfo: ReleaseInfo(iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical]
    )

    /// person.badge.key
    /// - Since: iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    /// - Warning: This symbol may not be modified and may only be used to refer to creating or signing in with a passkey.
    static let personBadgeKey = SFSymbol(
        title: "person.badge.key",
        categories: [.human, .objectsAndTools],
        searchTerms: ["passkey", "password", "people", "privacyandsecurity", "user"],
        releaseInfo: ReleaseInfo(iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical],
        restriction: "This symbol may not be modified and may only be used to refer to creating or signing in with a passkey."
    )

    /// person.badge.key.fill
    /// - Since: iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    /// - Warning: This symbol may not be modified and may only be used to refer to creating or signing in with a passkey.
    static let personBadgeKeyFill = SFSymbol(
        title: "person.badge.key.fill",
        categories: [.human, .objectsAndTools],
        searchTerms: ["passkey", "password", "people", "privacyandsecurity", "user"],
        releaseInfo: ReleaseInfo(iOS: 15.4, macOS: 12.3, tvOS: 15.4, watchOS: 8.5, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical],
        restriction: "This symbol may not be modified and may only be used to refer to creating or signing in with a passkey."
    )
}