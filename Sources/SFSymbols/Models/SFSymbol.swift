//
//  SFSymbol.swift
//
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation

/// A SFSymbol object
public struct SFSymbol: Codable, Identifiable, Equatable, Hashable, Sendable {
    public let title: String
    public var categories: [SFCategory]?
    public var searchTerms: [String]?
    public let releaseInfo: ReleaseInfo

    /// Supported rendering modes (monochrome, hierarchical, multicolor)
    public var layersets: [Layerset]

    /// Available localized variants of this symbol
    public var localizations: [LocalizationInfo]?

    /// Usage restriction warning (e.g., symbols restricted to specific Apple apps)
    public var restriction: String?

    /// If this symbol is deprecated, the name of the replacement symbol
    public var deprecatedNewName: String?

    /// The Unicode code points this symbol maps to, as uppercase hex strings
    /// without a "U+" prefix (e.g. `["278A", "2776"]`). nil when the symbol has none.
    public var unicodes: [String]?

    public var id: String {
        title
    }

    /// Whether this symbol has been deprecated and renamed
    public var isDeprecated: Bool {
        deprecatedNewName != nil
    }

    /// The symbol's Unicode scalars, derived from `unicodes`.
    public var unicodeScalars: [Unicode.Scalar] {
        (unicodes ?? []).compactMap { UInt32($0, radix: 16).flatMap(Unicode.Scalar.init) }
    }

    // MARK: - Public Init
    
    public init(
        title: String,
        categories: [SFCategory]? = nil,
        searchTerms: [String]? = nil,
        releaseInfo: ReleaseInfo,
        layersets: [Layerset] = [.monochrome],
        localizations: [LocalizationInfo]? = nil,
        restriction: String? = nil,
        deprecatedNewName: String? = nil,
        unicodes: [String]? = nil
    ){
        self.title = title
        self.releaseInfo = releaseInfo
        self.categories = categories
        self.searchTerms = searchTerms
        self.layersets = layersets
        self.localizations = localizations
        self.restriction = restriction
        self.deprecatedNewName = deprecatedNewName
        self.unicodes = unicodes
    }
}
