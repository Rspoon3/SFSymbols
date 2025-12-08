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

    public var id: String {
        title
    }

    /// Whether this symbol has been deprecated and renamed
    public var isDeprecated: Bool {
        deprecatedNewName != nil
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
        deprecatedNewName: String? = nil
    ){
        self.title = title
        self.releaseInfo = releaseInfo
        self.categories = categories
        self.searchTerms = searchTerms
        self.layersets = layersets
        self.localizations = localizations
        self.restriction = restriction
        self.deprecatedNewName = deprecatedNewName
    }
}
