//
//  Image+Extension.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import SwiftUI

extension Image{
    public init(symbol: SFSymbol){
        self.init(systemName: symbol.title)
    }
}
