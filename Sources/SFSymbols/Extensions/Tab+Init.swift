//
//  Tab+Init.swift
//
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - Tab with Value

@available(iOS 18.0, macOS 26.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Label == DefaultTabLabel, Value: Hashable, Content: View {
    /// Creates a tab with a localized title, symbol, and value.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:value:content:)`.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - value: The value for tab selection.
    ///   - content: The content of the tab.
    nonisolated init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        value: Value,
        @ViewBuilder content: () -> Content
    ) {
        self.init(titleKey, systemImage: symbol.title, value: value, content: content)
    }

    /// Creates a tab with a title, symbol, and value.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:value:content:)`.
    ///
    /// - Parameters:
    ///   - title: The tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - value: The value for tab selection.
    ///   - content: The content of the tab.
    @_disfavoredOverload
    nonisolated init<S>(
        _ title: S,
        symbol: SFSymbol,
        value: Value,
        @ViewBuilder content: () -> Content
    ) where S: StringProtocol {
        self.init(title, systemImage: symbol.title, value: value, content: content)
    }

    /// Creates a tab with a localized string resource title, symbol, and value.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:value:content:)`.
    ///
    /// - Parameters:
    ///   - title: The localized string resource for the tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - value: The value for tab selection.
    ///   - content: The content of the tab.
    @available(iOS 26.0, *)
    @_disfavoredOverload
    nonisolated init(
        _ title: LocalizedStringResource,
        symbol: SFSymbol,
        value: Value,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title, systemImage: symbol.title, value: value, content: content)
    }
}

// MARK: - Tab with Value and Role

@available(iOS 18.0, macOS 26.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Label == DefaultTabLabel, Value: Hashable, Content: View {
    /// Creates a tab with a localized title, symbol, value, and role.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:value:role:content:)`.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - value: The value for tab selection.
    ///   - role: The role of the tab.
    ///   - content: The content of the tab.
    nonisolated init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        value: Value,
        role: TabRole,
        @ViewBuilder content: () -> Content
    ) {
        self.init(titleKey, systemImage: symbol.title, value: value, role: role, content: content)
    }

    /// Creates a tab with a title, symbol, value, and role.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:value:role:content:)`.
    ///
    /// - Parameters:
    ///   - title: The tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - value: The value for tab selection.
    ///   - role: The role of the tab.
    ///   - content: The content of the tab.
    @_disfavoredOverload
    nonisolated init<S>(
        _ title: S,
        symbol: SFSymbol,
        value: Value,
        role: TabRole,
        @ViewBuilder content: () -> Content
    ) where S: StringProtocol {
        self.init(title, systemImage: symbol.title, value: value, role: role, content: content)
    }

    /// Creates a tab with a localized string resource title, symbol, value, and role.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:value:role:content:)`.
    ///
    /// - Parameters:
    ///   - title: The localized string resource for the tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - value: The value for tab selection.
    ///   - role: The role of the tab.
    ///   - content: The content of the tab.
    @available(iOS 26.0, *)
    @_disfavoredOverload
    nonisolated init(
        _ title: LocalizedStringResource,
        symbol: SFSymbol,
        value: Value,
        role: TabRole,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title, systemImage: symbol.title, value: value, role: role, content: content)
    }
}

// MARK: - Tab without Value (where Value == Never)

@available(iOS 18.0, macOS 26.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Label == DefaultTabLabel, Value == Never, Content: View {
    /// Creates a tab with a localized title and symbol, without a selection value.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:content:)`.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: The content of the tab.
    nonisolated init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        @ViewBuilder content: () -> Content
    ) {
        self.init(titleKey, systemImage: symbol.title, content: content)
    }

    /// Creates a tab with a title and symbol, without a selection value.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:content:)`.
    ///
    /// - Parameters:
    ///   - title: The tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: The content of the tab.
    @_disfavoredOverload
    nonisolated init<S>(
        _ title: S,
        symbol: SFSymbol,
        @ViewBuilder content: () -> Content
    ) where S: StringProtocol {
        self.init(title, systemImage: symbol.title, content: content)
    }

    /// Creates a tab with a localized string resource title and symbol, without a selection value.
    ///
    /// This initializer is equivalent to `Tab(_:systemImage:content:)`.
    ///
    /// - Parameters:
    ///   - title: The localized string resource for the tab title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: The content of the tab.
    @available(iOS 26.0, *)
    @_disfavoredOverload
    nonisolated init(
        _ title: LocalizedStringResource,
        symbol: SFSymbol,
        @ViewBuilder content: () -> Content
    ) {
        self.init(title, systemImage: symbol.title, content: content)
    }
}
#endif
