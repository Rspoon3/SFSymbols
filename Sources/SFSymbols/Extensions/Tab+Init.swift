//
//  Tab+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Value : Hashable, Content : View, Label : View {
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a string label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init<S>(_ title: S, symbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol
    {
        self.init(title, systemImage: symbol.title, value: value, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a string label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init<S>(_ title: S, symbol: SFSymbol, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol
    {
        self.init(title, systemImage: symbol.title, value: value, role: role, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a string label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init<S, T>(_ title: S, symbol: SFSymbol, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable
    {
        self.init(title, systemImage: symbol.title, value: value, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a string label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init<S, T>(_ title: S, symbol: SFSymbol, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, S : StringProtocol, T : Hashable
    {
        self.init(title, systemImage: symbol.title, value: value, role: role, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleKey, systemImage: symbol.title, value: value, content: content)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, value: Value, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleResource, systemImage: symbol.title, value: value, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleKey, systemImage: symbol.title, value: value, role: role, content: content)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, value: Value, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleResource, systemImage: symbol.title, value: value, role: role, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init<T>(_ titleKey: LocalizedStringKey, symbol: SFSymbol, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable
    {
        self.init(titleKey, systemImage: symbol.title, value: value, content: content)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - content: The view content of the tab.
    nonisolated init<T>(_ titleResource: LocalizedStringResource, symbol: SFSymbol, value: T, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable
    {
        self.init(titleResource, systemImage: symbol.title, value: value, content: content)
    }

    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init<T>(_ titleKey: LocalizedStringKey, symbol: SFSymbol, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable
    {
        self.init(titleKey, systemImage: symbol.title, value: value, role: role, content: content)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    /// Creates a tab that the tab view presents when the tab view's selection
    /// matches the tab's value using a system image for the tab's tab item image,
    /// with a localized string resource.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - value: The `selection` value which selects this tab.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    nonisolated init<T>(_ titleResource: LocalizedStringResource, symbol: SFSymbol, value: T, role: TabRole?, @ViewBuilder content: () -> Content) where Value == T?, Label == DefaultTabLabel, T : Hashable
    {
        self.init(titleResource, systemImage: symbol.title, value: value, role: role, content: content)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Tab where Value == Never, Content : View, Label : View {
    /// Creates a new tab that you can use in a tab view using a symbol
    /// for the tab item's image, and a string label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///     - image: The image for the tab's tab item.
    ///     - content: The view content of the tab.
    init<S>(_ title: S, symbol: SFSymbol, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol
    {
        self.init(title, systemImage: symbol.title, content: content)
    }

    /// Creates a new tab that you can use in a tab view using a symbol
    /// for the tab item's image, and a string label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - title: The label for the tab's tab item.
    ///     - image: The image for the tab's tab item.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    init<S>(_ title: S, symbol: SFSymbol, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel, S : StringProtocol
    {
        self.init(title, systemImage: symbol.title, role: role, content: content)
    }

    /// Creates a new tab that you can use in a tab view using a symbol
    /// for the tab item's image, and a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - image: The image for the tab's tab item.
    ///     - content: The view content of the tab.
    init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleKey, systemImage: symbol.title, content: content)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    /// Creates a new tab that you can use in a tab view using a symbol
    /// for the tab item's image, and a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - image: The image for the tab's tab item.
    ///     - content: The view content of the tab.
    init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleResource, systemImage: symbol.title, content: content)
    }

    /// Creates a new tab that you can use in a tab view using a symbol
    /// for the tab item's image, and a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleKey: The localized string key label for the tab's tab item.
    ///     - image: The image for the tab's tab item.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleKey, systemImage: symbol.title, role: role, content: content)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *)
    /// Creates a new tab that you can use in a tab view using a symbol
    /// for the tab item's image, and a localized string key label.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleResource: The localized string resource label for the tab's
    ///       tab item.
    ///     - image: The image for the tab's tab item.
    ///     - role: The role defining the semantic purpose of the tab.
    ///     - content: The view content of the tab.
    init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, role: TabRole?, @ViewBuilder content: () -> Content) where Label == DefaultTabLabel
    {
        self.init(titleResource, systemImage: symbol.title, role: role, content: content)
    }
}
#endif
