//
//  Button+AppIntents.swift
//
//  AppIntent-based button initializers
//

#if canImport(SwiftUI)
import SwiftUI
import AppIntents

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension Button where Label == SwiftUI.Label<Text, Image> {
    /// Creates a button that performs an AppIntent and generates its label from a localized string key and an `SFSymbol`.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the button's localized title, that describes the purpose of the button's intent.
    ///   - symbol: The `SFSymbol` describing this image.
    ///   - role: An optional semantic role describing the button. A value of nil means that the button doesn't have an assigned role.
    ///   - intent: The AppIntent to execute.
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

    /// Creates a button that performs an AppIntent and generates its label from a string and an `SFSymbol`.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the button's intent.
    ///   - symbol: The `SFSymbol` describing this image.
    ///   - role: An optional semantic role describing the button. A value of nil means that the button doesn't have an assigned role.
    ///   - intent: The AppIntent to execute.
    @_disfavoredOverload
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
