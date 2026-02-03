//
//  Menu+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public extension Menu where Label == SwiftUI.Label<Text, Image> {
    /// Creates a menu that generates its label from a localized string key
    /// and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - titleKey: The key for the link's localized title, which describes
    ///     the contents of the menu.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: A group of menu items.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, @ViewBuilder content: () -> Content) {
        self.init(titleKey, systemImage: symbol.title, content: content)
    }

    @available(iOS 16.0, macOS 13.0, *)
    /// Creates a menu that generates its label from a localized string resource
    /// and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - titleResource: Text resource for the link's localized title, which
    ///     describes the contents of the menu.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: A group of menu items.
    @_disfavoredOverload nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, @ViewBuilder content: () -> Content) {
        self.init(titleResource, systemImage: symbol.title, content: content)
    }

    /// Creates a menu that generates its label from a string and symbol.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - title: A string that describes the contents of the menu.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - content: A group of menu items.
    @_disfavoredOverload nonisolated init<S>(_ title: S, symbol: SFSymbol, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.init(title, systemImage: symbol.title, content: content)
    }

    @available(iOS 15.0, macOS 12.0, tvOS 17.0, *)
    @available(watchOS, unavailable)
    /// Creates a menu with a custom primary action that generates its label
    /// from a localized string key and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - titleKey: The key for the link's localized title, which describes
    ///     the contents of the menu.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - primaryAction: The action to perform on primary
    ///     interaction with the menu.
    ///   - content: A group of menu items.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) {
        self.init(titleKey, systemImage: symbol.title, content: content)
    }

    @available(iOS 16.0, macOS 13.0, *)
    @available(watchOS, unavailable)
    /// Creates a menu with a custom primary action that generates its label
    /// from a localized string resource and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - titleResource: Text resource for the link's localized title, which
    ///     describes the contents of the menu.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - primaryAction: The action to perform on primary
    ///     interaction with the menu.
    ///   - content: A group of menu items.
    @_disfavoredOverload nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, @ViewBuilder content: () -> Content, primaryAction: @escaping () -> Void) {
        self.init(titleResource, systemImage: symbol.title, content: content)
    }
}
#endif
