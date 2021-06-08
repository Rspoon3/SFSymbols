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


@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0,  *)
extension Button where Label == SwiftUI.Label<Text, Image>{
    public init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, textColor: Color? = nil, action: @escaping () -> Void) {
        self.init(action: action, label: {
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


@available(iOS 15, macOS 15.0, tvOS 15.0, watchOS 8.0,  *)
extension Button where Label == Image {
    public init(symbol: SFSymbol, role: ButtonRole, action: @escaping () -> Void) {
        self.init(role: role, action: action) {
            Image(systemName: symbol.title)
        }
    }
}
