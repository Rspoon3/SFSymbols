//
//  Image+Init.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(SwiftUI)
import SwiftUI

public extension SwiftUI.Image {
    
    /// Creates a system symbol image.
    ///
    /// - Parameter symbol: The `SFSymbol` describing this image.
    init(symbol: SFSymbol){
        self.init(systemName: symbol.title)
    }
    
    /// Creates a system symbol image with a variable value.
    ///
    /// - Parameter symbol: The `SFSymbol` describing this image.
    /// - Parameter variableValue: An optional value between 0.0 and 1.0 that the rendered image can use to customize its appearance, if specified. If the symbol doesn’t support variable values, this parameter has no effect. Use the SF Symbols app to look up which symbols support variable values.
    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
    init(symbol: SFSymbol, variableValue: Double?) {
        self.init(systemName: symbol.title, variableValue: variableValue)
    }
}
#endif
