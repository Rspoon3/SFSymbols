//
//  Button+Deprecated.swift
//
//  Deprecated custom initializers
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - Button with Label == Image (Deprecated)

@available(iOS, deprecated: 18.0, message: "Use standard Button initializers with Label<Text, Image> instead")
@available(macOS, deprecated: 15.0, message: "Use standard Button initializers with Label<Text, Image> instead")
@available(tvOS, deprecated: 18.0, message: "Use standard Button initializers with Label<Text, Image> instead")
@available(watchOS, deprecated: 11.0, message: "Use standard Button initializers with Label<Text, Image> instead")
public extension Button where Label == Image {
    /// Creates a button with only a symbol image (no text).
    ///
    /// - Parameters:
    ///   - symbol: The `SFSymbol` for the button image.
    ///   - action: The action to perform when the user triggers the button.
    @available(*, deprecated, message: "Use Button with Label<Text, Image> instead")
    init(symbol: SFSymbol, action: @escaping @MainActor () -> Void) {
        self.init(action: action) {
            Image(systemName: symbol.title)
        }
    }

    /// Creates a button with a role and only a symbol image (no text).
    ///
    /// - Parameters:
    ///   - symbol: The `SFSymbol` for the button image.
    ///   - role: An optional semantic role describing the button.
    ///   - action: The action to perform when the user triggers the button.
    @available(iOS 15, macOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @available(*, deprecated, message: "Use Button with Label<Text, Image> instead")
    init(symbol: SFSymbol, role: ButtonRole, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action) {
            Image(systemName: symbol.title)
        }
    }
}

// MARK: - Button with textColor parameter (Deprecated)

@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(*, deprecated, message: "Use Button with custom label styling instead")
public extension Button where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button with custom text color.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the button title.
    ///   - symbol: The `SFSymbol` for the button image.
    ///   - textColor: Optional text color for the button label.
    ///   - action: The action to perform when the user triggers the button.
    @available(*, deprecated, message: "Use Button with custom label styling instead")
    init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        textColor: Color? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.init {
            action()
        } label: {
            Label {
                Text(titleKey)
                    .foregroundColor(textColor)
            } icon: {
                Image(systemName: symbol.title)
            }
        }
    }

    /// Creates a button with a role and custom text color.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the button title.
    ///   - symbol: The `SFSymbol` for the button image.
    ///   - role: An optional semantic role describing the button.
    ///   - textColor: Optional text color for the button label.
    ///   - action: The action to perform when the user triggers the button.
    @available(iOS 15, macOS 15.0, tvOS 15.0, watchOS 8.0, *)
    @available(*, deprecated, message: "Use Button with custom label styling instead")
    init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        role: ButtonRole? = nil,
        textColor: Color? = nil,
        action: @escaping @MainActor () -> Void
    ) {
        self.init(role: role) {
            action()
        } label: {
            Label {
                Text(titleKey)
                    .foregroundColor(textColor)
            } icon: {
                Image(systemName: symbol.title)
            }
        }
    }
}
#endif
