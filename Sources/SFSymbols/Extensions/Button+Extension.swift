//
//  Button+Extension.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import SwiftUI


extension Button where Label == Image {
    public init(symbol: SFSymbol, action: @escaping () -> Void) {
        self.init(action: action) {
            Image(systemName: symbol.title)
        }
    }
}


@available(iOS 14.0, *)
extension Button where Label == SwiftUI.Label<Text, Image>{
    public init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, textColor: Color? = nil, action: @escaping () -> Void) {
        self.init(action: {}, label: {
            SwiftUI.Label(
                title: {
                    Text(titleKey)
                        .foregroundColor(textColor)
                },
                icon: {
                    Image(symbol: symbol)
                }
            )
        })
    }
}
