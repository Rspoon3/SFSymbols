//
//  ContentUnavailableView+Init.swift
//
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// Creates an interface, consisting of a symbol image, title, and description,
    /// that you display when the content of your app is unavailable to users.
    ///
    /// This initializer is equivalent to `ContentUnavailableView(_:systemImage:description:)`.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - description: The optional description text to display.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, description: Text? = nil) {
        self.init(titleKey, systemImage: symbol.title, description: description)
    }

    /// Creates an interface, consisting of a symbol image, title, and description,
    /// that you display when the content of your app is unavailable to users.
    ///
    /// This initializer is equivalent to `ContentUnavailableView(_:systemImage:description:)`.
    ///
    /// - Parameters:
    ///   - title: The title text to display.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - description: The optional description text to display.
    @_disfavoredOverload
    nonisolated init<S>(_ title: S, symbol: SFSymbol, description: Text? = nil) where S: StringProtocol {
        self.init(String(title), systemImage: symbol.title, description: description)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// Creates an interface, consisting of a symbol image, title, and description,
    /// that you display when the content of your app is unavailable to users.
    ///
    /// This initializer is equivalent to `ContentUnavailableView(_:systemImage:description:)`.
    ///
    /// - Parameters:
    ///   - title: The localized string resource for the title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - description: The optional description text to display.
    nonisolated init(_ title: LocalizedStringResource, symbol: SFSymbol, description: Text? = nil) {
        self.init(title, systemImage: symbol.title, description: description)
    }
}
#endif
