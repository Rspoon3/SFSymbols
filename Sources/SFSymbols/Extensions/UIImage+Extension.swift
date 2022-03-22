//
//  UIImage+Extension.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

#if canImport(UIKit)
import UIKit

public extension UIImage {
    convenience init(symbol: SFSymbol){
        self.init(systemName: symbol.title)!
    }
    
    convenience init(symbol: SFSymbol, withConfiguration configuration: UIImage.Configuration?){
        self.init(systemName: symbol.title, withConfiguration: configuration)!
    }
    
    convenience init(symbol: SFSymbol, weight: UIImage.SymbolWeight){
        let configuration = UIImage.SymbolConfiguration(weight: weight)
        self.init(systemName: symbol.title, withConfiguration: configuration)!
    }
    
    convenience init(symbol: SFSymbol, compatibleWith traitCollection: UITraitCollection?){
        self.init(systemName: symbol.title, compatibleWith: traitCollection)!
    }
}
#endif
