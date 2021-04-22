//
//  UIImage+Extension.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(UIKit)
import UIKit

extension UIImage {
    public convenience init(symbol: SFSymbol){
        self.init(systemName: symbol.title)!
    }
}
#endif
