//
//  ControlGroup+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 17.0, *)
@available(watchOS, unavailable)
public extension ControlGroup {
    /// Creates a new control group with the specified content that generates
    /// its label from a localized string key and image name.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - titleKey: The key for the group's localized title, that describes
    ///     the contents of the group.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - label: A view that describes the purpose of the group.
    nonisolated init<C>(_ titleKey: LocalizedStringKey, symbol: SFSymbol, @ViewBuilder content: () -> C) where Content == LabeledControlGroupContent<C, Label<Text, Image>>, C : View
    {
        self.init(titleKey, systemImage: symbol.title, content: content)
    }

    /// Creates a new control group with the specified content that generates
    /// its label from a localized string resource and image name.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - titleResource: Text resource for the group's localized title, that
    ///     describes the contents of the group.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - label: A view that describes the purpose of the group.
    nonisolated init<C>(_ titleResource: LocalizedStringResource, symbol: SFSymbol, @ViewBuilder content: () -> C) where Content == LabeledControlGroupContent<C, Label<Text, Image>>, C : View
    {
        self.init(titleResource, systemImage: symbol.title, content: content)
    }

    /// Creates a new control group with the specified content that generates
    /// its label from a string and image name.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///   - title: A string that describes the contents of the group.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - label: A view that describes the purpose of the group.
    nonisolated init<C, S>(_ title: S, symbol: SFSymbol, @ViewBuilder content: () -> C) where Content == LabeledControlGroupContent<C, Label<Text, Image>>, C : View, S : StringProtocol
    {
        self.init(title, systemImage: symbol.title, content: content)
    }
}
#endif
