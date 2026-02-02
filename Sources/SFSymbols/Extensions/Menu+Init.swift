//
//  Menu+Init.swift
//
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *)
public extension Menu where Label == SwiftUI.Label<Text, Image> {
    /// Creates a menu with a label and symbol that generates its contents from a content builder.
    ///
    /// This initializer is equivalent to `Menu(_:systemImage:content:)`.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the menu title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: A group of menu items.
    nonisolated init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        @ViewBuilder content: () -> Content
    ) {
        self.init(titleKey, systemImage: symbol.title, content: content)
    }

    /// Creates a menu with a label, symbol, and primary action that generates its contents from a content builder.
    ///
    /// This initializer is equivalent to `Menu(_:systemImage:content:primaryAction:)`.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the menu title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: A group of menu items.
    ///   - primaryAction: The action to perform when the user taps or clicks the menu.
    nonisolated init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        @ViewBuilder content: () -> Content,
        primaryAction: @escaping () -> Void
    ) {
        self.init(titleKey, systemImage: symbol.title, content: content, primaryAction: primaryAction)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Menu where Label == SwiftUI.Label<Text, Image> {
    /// Creates a menu with a label and symbol that generates its contents from a content builder.
    ///
    /// This initializer is equivalent to `Menu(_:systemImage:content:)`.
    ///
    /// - Parameters:
    ///   - title: The localized string resource for the menu title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: A group of menu items.
    @_disfavoredOverload
    nonisolated init(
        _ title: LocalizedStringResource,
        symbol: SFSymbol,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title, systemImage: symbol.title, content: content)
    }

    /// Creates a menu with a label, symbol, and primary action that generates its contents from a content builder.
    ///
    /// This initializer is equivalent to `Menu(_:systemImage:content:primaryAction:)`.
    ///
    /// - Parameters:
    ///   - title: The localized string resource for the menu title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: A group of menu items.
    ///   - primaryAction: The action to perform when the user taps or clicks the menu.
    @_disfavoredOverload
    nonisolated init(
        _ title: LocalizedStringResource,
        symbol: SFSymbol,
        @ViewBuilder content: () -> Content,
        primaryAction: @escaping () -> Void
    ) {
        self.init(title, systemImage: symbol.title, content: content, primaryAction: primaryAction)
    }
}
#endif
