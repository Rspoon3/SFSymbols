//
//  Label+Extension.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import SwiftUI


@available(iOS 14.0, *)
extension Label where Title == Text, Icon == Image {
    public init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, textColor: Color? = nil){
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
}
