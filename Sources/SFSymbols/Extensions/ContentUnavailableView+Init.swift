//
//  ContentUnavailableView+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension ContentUnavailableView where Label == SwiftUI.Label<Text, Image>, Description == Text?, Actions == EmptyView {
    /// Creates an interface, consisting of a title generated from a localized
    /// string, a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///   - symbol: The `SFSymbol` describing the image.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    nonisolated init(_ title: LocalizedStringKey, systemImage symbol: SFSymbol, description: Text? = nil) {
        self.init(title, systemImage: symbol.title, description: description)
    }

    /// Creates an interface, consisting of a title generated from a localized
    /// string resource, a system icon image and additional content, that you
    /// display when the content of your app is unavailable to users.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - title: A title generated from a localized string.
    ///   - symbol: The `SFSymbol` describing the image.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    nonisolated init(_ title: LocalizedStringResource, systemImage symbol: SFSymbol, description: Text? = nil) {
        self.init(title, systemImage: symbol.title, description: description)
    }

    /// Creates an interface, consisting of a title generated from a string,
    /// a system icon image and additional content, that you display when the
    /// content of your app is unavailable to users.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - title: A string used as the title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///      Use the SF Symbols app to look up the names of system symbol images.
    ///    - description: The view that describes the interface.
    nonisolated init<S>(_ title: S, systemImage symbol: SFSymbol, description: Text? = nil) where S : StringProtocol {
        self.init(title, systemImage: symbol.title, description: description)
    }
}
#endif
