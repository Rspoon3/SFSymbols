//
//  Label+Deprecated.swift
//
//  Deprecated custom initializers
//

#if canImport(SwiftUI)
import SwiftUI

// MARK: - Label with textColor parameter (Deprecated)

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
@available(*, deprecated, message: "Use Label with custom styling instead")
public extension Label where Title == Text, Icon == Image {
    /// Creates a label with a system symbol image and custom text color.
    ///
    /// - Parameters:
    ///   - titleKey: The localized string key for the label title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - textColor: Optional text color for the label title.
    @available(*, deprecated, message: "Use Label with custom styling instead")
    init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        textColor: Color? = nil
    ) {
        self.init(
            title: {
                Text(titleKey)
                    .foregroundColor(textColor)
            },
            icon: {
                Image(symbol: symbol)
            }
        )
    }

    /// Creates a label with a system symbol image and custom text color from a StringProtocol title.
    ///
    /// - Parameters:
    ///   - title: A string that describes the label title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - textColor: Optional text color for the label title.
    @available(*, deprecated, message: "Use Label with custom styling instead")
    @_disfavoredOverload
    init<S>(
        _ title: S,
        symbol: SFSymbol,
        textColor: Color? = nil
    ) where S: StringProtocol {
        self.init(title, systemImage: symbol.title)
    }

    /// Creates a label with a system symbol image and custom text color from a String title.
    ///
    /// - Parameters:
    ///   - title: A string that describes the label title.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - textColor: Optional text color for the label title.
    @available(*, deprecated, message: "Use Label with custom styling instead")
    init(
        _ title: String,
        symbol: SFSymbol,
        textColor: Color? = nil
    ) {
        self.init(.init(title), symbol: symbol, textColor: textColor)
    }
}
#endif
