#if canImport(AppKit) && !targetEnvironment(macCatalyst)

import AppKit

@available(macOS 11.0, *)
public extension NSImage {

    /// Creates a symbol image with the system symbol and accessibility description you specify.
    ///
    /// - Parameter symbol: The `SFSymbol` describing this image.
    /// - Parameter accessibilityDescription: The accessibility description for the symbol image, if any.
    convenience init(symbol: SFSymbol, accessibilityDescription description: String? = nil) {
        self.init(systemSymbolName: symbol.title, accessibilityDescription: description)!
    }

    /// Creates a symbol image with the system symbol and variable value you specify.
    ///
    /// - Parameter symbol: The `SFSymbol` describing this image.
    /// - Parameter value: The value the system uses to customize the symbol’s content, between 0 and 1.
    /// - Parameter accessibilityDescription: The accessibility description for the symbol image, if any.
    @available(macOS 13.0, *)
    convenience init(symbol: SFSymbol, variableValue value: Double, accessibilityDescription description: String?) {
        self.init(systemSymbolName: symbol.title, variableValue: value, accessibilityDescription: description)!
    }
}

#endif
