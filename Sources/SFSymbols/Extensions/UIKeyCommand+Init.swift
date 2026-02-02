//
//  UIKeyCommand+Init.swift
//
//  Generated from UIKit.framework
//

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, *)
public extension UIKeyCommand {

    @MainActor @preconcurrency convenience init(title: String = "", symbol: SFSymbol, action: Selector, input: String, modifierFlags: UIKeyModifierFlags = [], propertyList: Any? = nil, alternates: [UICommandAlternate] = [], discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off) {
        self.init(title: title, image: UIImage(symbol: symbol), action: action, input: input, modifierFlags: modifierFlags, propertyList: propertyList, alternates: alternates, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state)
    }
}
#endif
