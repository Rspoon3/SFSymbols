//
//  SFSymbol+StaticVariables14P5.swift
//
//

import Foundation
import Foundation

@available(iOS 14.5, macOS 11.3, tvOS 14.5, watchOS 7.4, visionOS 1.0, *)
public extension SFSymbol {
    /// airpodsmax
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "airpodsMax", message: "Use 'airpodsMax' instead. This symbol has been renamed.")
    static let airpodsmax = SFSymbol(
        title: "airpodsmax",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "airpods.max"
    )

    /// applewatch.side.right
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    /// - Warning: This symbol may not be modified and may only be used to refer to Apple Watch.
    static let applewatchSideRight = SFSymbol(
        title: "applewatch.side.right",
        categories: [.devices],
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical],
        restriction: "This symbol may not be modified and may only be used to refer to Apple Watch."
    )

    /// character.bubble
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    /// - Localizations: Arabic, Bengali, Gujarati, Hebrew, Hindi, Japanese, Kannada, Korean, Malayalam, Marathi, Odia, Punjabi, Sinhala, Tamil, Telugu, Thai, Chinese
    static let characterBubble = SFSymbol(
        title: "character.bubble",
        categories: [.communication],
        searchTerms: ["a"],
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical],
        localizations: [LocalizationInfo(code: .ar, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .bn, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .gu, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .he, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .hi, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .ja, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .kn, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .ko, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .ml, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .mr, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .or, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .pa, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .si, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .ta, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .te, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .th, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .zh, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0))]
    )

    /// character.bubble.fill
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical, multicolor
    /// - Localizations: Arabic, Bengali, Gujarati, Hebrew, Hindi, Japanese, Kannada, Korean, Malayalam, Marathi, Odia, Punjabi, Sinhala, Tamil, Telugu, Thai, Chinese
    static let characterBubbleFill = SFSymbol(
        title: "character.bubble.fill",
        categories: [.communication, .multicolor],
        searchTerms: ["a"],
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical, .multicolor],
        localizations: [LocalizationInfo(code: .ar, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .bn, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .gu, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .he, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .hi, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .ja, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .kn, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .ko, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .ml, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .mr, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .or, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .pa, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .si, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .ta, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .te, availability: ReleaseInfo(iOS: 26.0, macOS: 26.0, tvOS: 26.0, watchOS: 26.0, visionOS: 26.0)), LocalizationInfo(code: .th, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0)), LocalizationInfo(code: .zh, availability: ReleaseInfo(iOS: 15.0, macOS: 12.0, tvOS: 15.0, watchOS: 8.0, visionOS: 1.0))]
    )

    /// character.cursor.ibeam
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    /// - Localizations: Arabic, Bengali, Gujarati, Hebrew, Hindi, Japanese, Kannada, Korean, Malayalam, Marathi, Odia, Punjabi, Sinhala, Tamil, Telugu, Thai, Chinese
    static let characterCursorIbeam = SFSymbol(
        title: "character.cursor.ibeam",
        categories: [.textFormatting],
        searchTerms: ["a"],
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical],
        localizations: [LocalizationInfo(code: .ar, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .bn, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .gu, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .he, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .hi, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .ja, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .kn, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .ko, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .ml, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .mr, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .or, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .pa, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .si, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .ta, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .te, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .th, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .zh, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0))]
    )

    /// character.textbox
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome, hierarchical
    /// - Localizations: Arabic, Bengali, Gujarati, Hebrew, Hindi, Japanese, Kannada, Korean, Malayalam, Marathi, Odia, Punjabi, Sinhala, Tamil, Telugu, Thai, Chinese
    static let characterTextbox = SFSymbol(
        title: "character.textbox",
        categories: [.textFormatting],
        searchTerms: ["a"],
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome, .hierarchical],
        localizations: [LocalizationInfo(code: .ar, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .bn, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .gu, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .he, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .hi, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .ja, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .kn, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .ko, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .ml, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .mr, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .or, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .pa, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .si, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .ta, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .te, availability: ReleaseInfo(iOS: 18.4, macOS: 15.4, tvOS: 18.4, watchOS: 11.4, visionOS: 2.4)), LocalizationInfo(code: .th, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0)), LocalizationInfo(code: .zh, availability: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0))]
    )

    /// hifispeaker.and.homepodmini
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "hifispeakerAndHomepodMini", message: "Use 'hifispeakerAndHomepodMini' instead. This symbol has been renamed.")
    static let hifispeakerAndHomepodmini = SFSymbol(
        title: "hifispeaker.and.homepodmini",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "hifispeaker.and.homepod.mini"
    )

    /// hifispeaker.and.homepodmini.fill
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "hifispeakerAndHomepodMiniFill", message: "Use 'hifispeakerAndHomepodMiniFill' instead. This symbol has been renamed.")
    static let hifispeakerAndHomepodminiFill = SFSymbol(
        title: "hifispeaker.and.homepodmini.fill",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "hifispeaker.and.homepod.mini.fill"
    )

    /// homepod.and.homepodmini
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "homepodAndHomepodMini", message: "Use 'homepodAndHomepodMini' instead. This symbol has been renamed.")
    static let homepodAndHomepodmini = SFSymbol(
        title: "homepod.and.homepodmini",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "homepod.and.homepod.mini"
    )

    /// homepod.and.homepodmini.fill
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "homepodAndHomepodMiniFill", message: "Use 'homepodAndHomepodMiniFill' instead. This symbol has been renamed.")
    static let homepodAndHomepodminiFill = SFSymbol(
        title: "homepod.and.homepodmini.fill",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "homepod.and.homepod.mini.fill"
    )

    /// homepodmini
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "homepodMini", message: "Use 'homepodMini' instead. This symbol has been renamed.")
    static let homepodmini = SFSymbol(
        title: "homepodmini",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "homepod.mini"
    )

    /// homepodmini.2
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "homepodMini2", message: "Use 'homepodMini2' instead. This symbol has been renamed.")
    static let homepodmini2 = SFSymbol(
        title: "homepodmini.2",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "homepod.mini.2"
    )

    /// homepodmini.2.fill
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "homepodMini2Fill", message: "Use 'homepodMini2Fill' instead. This symbol has been renamed.")
    static let homepodmini2Fill = SFSymbol(
        title: "homepodmini.2.fill",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "homepod.mini.2.fill"
    )

    /// homepodmini.fill
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "homepodMiniFill", message: "Use 'homepodMiniFill' instead. This symbol has been renamed.")
    static let homepodminiFill = SFSymbol(
        title: "homepodmini.fill",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "homepod.mini.fill"
    )

    /// rectangle.topthird.inset.fill
    /// - Since: iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0
    /// - Layersets: monochrome
    @available(*, deprecated, renamed: "insetFilledTopthirdRectangle", message: "Use 'insetFilledTopthirdRectangle' instead. This symbol has been renamed.")
    static let rectangleTopthirdInsetFill = SFSymbol(
        title: "rectangle.topthird.inset.fill",
        categories: nil,
        searchTerms: nil,
        releaseInfo: ReleaseInfo(iOS: 14.5, macOS: 11.3, tvOS: 14.5, watchOS: 7.4, visionOS: 1.0),
        layersets: [.monochrome],
        deprecatedNewName: "inset.filled.topthird.rectangle"
    )
}
