//
//  UIBarButtonItem+Extension.swift
//  
//
//  Created by Richard Witherspoon on 3/30/22.
//

#if canImport(UIKit)
import UIKit

public extension UIBarButtonItem {
    public convenience init(symbol: SFSymbol, landscapeImagePhone: UIImage?, style: UIBarButtonItem.Style, target: Any?, action: Selector?){
        self.init(image: UIImage(symbol: symbol), landscapeImagePhone: landscapeImagePhone, style: style, target: target, action: action)
    }

    public convenience init(symbol: SFSymbol, style: UIBarButtonItem.Style, target: Any?, action: Selector?){
        self.init(image: UIImage(symbol: symbol), style: style, target: target, action: action)

    }
    
    @available(iOS 14.0, *)
    public convenience init(title: String? = nil, symbol: SFSymbol, primaryAction: UIAction? = nil, menu: UIMenu? = nil){
        self.init(title: title, image: UIImage(symbol: symbol), primaryAction: primaryAction, menu: menu)
    }
}
#endif
