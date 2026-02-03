//
//  Label+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Label where Title == Text, Icon == Image {
    /// Creates a label with a system icon image and a title generated from a
    /// localized string.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - titleKey: A title generated from a localized string.
    ///   - symbol: The `SFSymbol` describing the image.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol) {
        self.init(titleKey, systemImage: symbol.title)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a label with a system icon image and a title generated from a
    /// localized string.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - titleResource: A title generated from a localized string.
    ///   - symbol: The `SFSymbol` describing the image.
    @_disfavoredOverload nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol) {
        self.init(titleResource, systemImage: symbol.title)
    }

    /// Creates a label with a system icon image and a title generated from a
    /// string.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - title: A string used as the label's title.
    ///   - symbol: The `SFSymbol` describing the image.
    @_disfavoredOverload nonisolated init<S>(_ title: S, symbol: SFSymbol) where S : StringProtocol {
        self.init(title, systemImage: symbol.title)
    }
}
#endif
