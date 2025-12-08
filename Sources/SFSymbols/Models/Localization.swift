//
//  Localization.swift
//
//
//  Generated Automatically
//

import Foundation

/// Represents a language/script localization for SF Symbols
public enum Localization: String, Codable, CaseIterable, Sendable {
    // Original localizations
    case ar, he, hi, ja, km, ko, my, rtl, th, zh
    // New localizations added in SF Symbols 6
    case bn, el, gu, kn, ml, mr, or, pa, ru, si, ta, te

    /// Human-readable name of the localization
    public var name: String {
        switch self {
        case .ar: return "Arabic"
        case .bn: return "Bengali"
        case .el: return "Greek"
        case .gu: return "Gujarati"
        case .he: return "Hebrew"
        case .hi: return "Hindi"
        case .ja: return "Japanese"
        case .km: return "Central Khmer"
        case .kn: return "Kannada"
        case .ko: return "Korean"
        case .ml: return "Malayalam"
        case .mr: return "Marathi"
        case .my: return "Burmese"
        case .or: return "Odia"
        case .pa: return "Punjabi"
        case .rtl: return "Right-to-Left"
        case .ru: return "Russian"
        case .si: return "Sinhala"
        case .ta: return "Tamil"
        case .te: return "Telugu"
        case .th: return "Thai"
        case .zh: return "Chinese"
        }
    }
}

/// Information about a localized variant of an SF Symbol
public struct LocalizationInfo: Codable, Equatable, Hashable, Sendable {
    /// The localization code (e.g., "ar", "ja", "zh")
    public let code: Localization

    /// Platform availability for this localized variant (may differ from base symbol)
    public let availability: ReleaseInfo?

    public init(code: Localization, availability: ReleaseInfo? = nil) {
        self.code = code
        self.availability = availability
    }
}
