//
//  Label+Init.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, tvOS 14.0, watchOS 7.0, *)
public extension Label where Title == Text, Icon == Image {
    /// Creates a label with a system symbol image and a title generated from a
    /// localized string.
    ///
    /// - Parameter symbol: The `SFSymbol` describing this image.
    init(_ titleKey: LocalizedStringKey, symbol: SFSymbol) {
        self.init(titleKey, systemImage: symbol.title)
    }
    
    /// Creates a label with a system symbol image and a title generated from a
    /// string.
    ///
    /// - Parameter symbol: The `SFSymbol` describing this image.
    @_disfavoredOverload
    init<S>(_ title: S, symbol: SFSymbol) where S : StringProtocol {
        self.init(title, systemImage: symbol.title)
    }
    
    init(
        _ titleKey: LocalizedStringKey,
        symbol: SFSymbol,
        textColor: Color? = nil
    ){
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
    
    /// Creates a label with a system symbol image and a title generated from a
    /// string.
    ///
    /// - Parameter symbol: The `SFSymbol` describing this image.
    @_disfavoredOverload
    init<S>(
        _ title: S,
        symbol: SFSymbol,
        textColor: Color? = nil
    ) where S : StringProtocol {
        self.init(title, systemImage: symbol.title)
    }
    
    init(
        _ title: String,
        symbol: SFSymbol,
        textColor: Color? = nil
    ){
        self.init(.init(title), symbol: symbol, textColor: textColor)
    }
}
#endif
