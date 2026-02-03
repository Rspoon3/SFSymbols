//
//  Button+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button that generates its label from a localized string key
    /// and system image name.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Label`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes
    ///     the purpose of the button's `action`.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - action: The action to perform when the user triggers the button.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, action: @escaping @MainActor () -> Void) {
        self.init(titleKey, systemImage: symbol.title, action: action)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a button that generates its label from a localized string
    /// resource and system image name.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Label`` view on your behalf. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleResource: Text resource for the button's localized title, that
    ///     describes the purpose of the button's `action`.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - action: The action to perform when the user triggers the button.
    @_disfavoredOverload nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, action: @escaping @MainActor () -> Void) {
        self.init(titleResource, systemImage: symbol.title, action: action)
    }

    /// Creates a button that generates its label from a string and
    /// system image name.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Label`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's `action`.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - action: The action to perform when the user triggers the button.
    @_disfavoredOverload nonisolated init<S>(_ title: S, symbol: SFSymbol, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(title, systemImage: symbol.title, action: action)
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button with a specified role that generates its label from a
    /// localized string key and a system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Label`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes
    ///     the purpose of the button's `action`.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - role: An optional semantic role describing the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The action to perform when the user triggers the button.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(titleKey, systemImage: symbol.title, role: role, action: action)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a button with a specified role that generates its label from a
    /// localized string resource and a system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Label`` view on your behalf. See
    /// ``Text`` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleResource: Text resource for the button's localized title, that
    ///     describes the purpose of the button's `action`.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - role: An optional semantic role describing the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The action to perform when the user triggers the button.
    @_disfavoredOverload nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, role: ButtonRole?, action: @escaping @MainActor () -> Void) {
        self.init(titleResource, systemImage: symbol.title, role: role, action: action)
    }

    /// Creates a button with a specified role that generates its label from a
    /// string and a system image and an image resource.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Label`` view on your behalf, and treats the
    /// title similar to ``Text/init(_:)``. See ``Text`` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's `action`.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - role: An optional semantic role describing the button. A value of
    ///     `nil` means that the button doesn't have an assigned role.
    ///   - action: The action to perform when the user interacts with the button.
    @_disfavoredOverload nonisolated init<S>(_ title: S, symbol: SFSymbol, role: ButtonRole?, action: @escaping @MainActor () -> Void) where S : StringProtocol {
        self.init(title, systemImage: symbol.title, role: role, action: action)
    }
}
#endif
