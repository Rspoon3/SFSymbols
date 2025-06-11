//
//  Button+Init.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(SwiftUI)
import SwiftUI
import AppIntents

public extension Button where Label == Image {
    init(symbol: SFSymbol, action: @escaping @MainActor () -> Void) {
        self.init(action: action) {
            Image(systemName: symbol.title)
        }
    }
    
    @available(iOS 15, macOS 15.0, tvOS 15.0, watchOS 8.0,  *)
    init(symbol: SFSymbol, role: ButtonRole, action: @escaping @MainActor () -> Void) {
        self.init(role: role, action: action) {
            Image(systemName: symbol.title)
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image>{
    /// Creates a button with a specified role that generates its label from a localized string key and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action
    ///     - symbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user triggers the button.
    init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        role: ButtonRole?,
        action: @escaping () -> Void
    ) {
        self.init(
            titleKey,
            systemImage: symbol.title,
            role: role,
            action: action
        )
    }
    
    /// Creates a button with a specified role that generates its label from a string and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - symbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - action: The action to perform when the user triggers the button.
    @_disfavoredOverload
    init<S>(
        _ title: S,
        symbol: SFSymbol,
        role: ButtonRole?,
        action: @escaping () -> Void
    ) where S : StringProtocol {
        self.init(
            title,
            systemImage: symbol.title,
            role: role,
            action: action
        )
    }
}

@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0,  *)
public extension Button where Label == SwiftUI.Label<Text, Image>{
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
    
    @available(iOS 15, macOS 15.0, tvOS 15.0, watchOS 8.0,  *)
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
    
    /// Creates a button that generates its label from a string and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s action.
    ///     - symbol: The `SFSymbol` describing this image.
    ///     - action: The action to perform when the user triggers the button.
    @_disfavoredOverload
    init<S>(
        _ title: S,
        symbol: SFSymbol,
        action: @escaping () -> Void
    ) where S : StringProtocol {
        self.init(
            title,
            systemImage: symbol.title,
            action: action
        )
    }
    
    /// Creates a button that generates its label from a localized string key and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s action.
    ///     - symbol: The `SFSymbol` describing this image.
    ///     - action: The action to perform when the user triggers the button.
    init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        action: @escaping () -> Void
    ) {
        self.init(
            titleKey,
            systemImage: symbol.title,
            action: action
        )
    }
    
    /// Creates a button with a specified role that performs an AppIntent and generates its label from a localized string key and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - titleKey: The key for the button’s localized title, that describes the purpose of the button’s intent.
    ///     - symbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - intent: The AppIntent to execute.
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        role: ButtonRole? = nil,
        intent: some AppIntent
    ) {
        self.init(
            titleKey,
            systemImage: symbol.title,
            role: role,
            intent: intent
        )
    }
    
    /// Creates a button with a specified role that generates its label from a string and an `SFSymbol`.
    ///
    /// - Parameters
    ///     - title: A string that describes the purpose of the button’s intent.
    ///     - symbol: The `SFSymbol` describing this image.
    ///     - role: An optional semantic role describing the button. A value of nil means that the button doesn’t have an assigned role.
    ///     - intent: The AppIntent to execute.
    @_disfavoredOverload
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
    init(
        _ title: some StringProtocol,
        symbol: SFSymbol,
        role: ButtonRole? = nil,
        intent: some AppIntent
    ) {
        self.init(
            title,
            systemImage: symbol.title,
            role: role,
            intent: intent
        )
    }
}
#endif
