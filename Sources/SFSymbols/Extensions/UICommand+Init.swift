//
//  UICommand+Init.swift
//
//  Generated from UIKit.framework
//

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, *)
public extension UICommand {

    @MainActor @preconcurrency convenience init(title: String = "", symbol: SFSymbol, action: Selector, propertyList: Any? = nil, alternates: [UICommandAlternate] = [], discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off) {
        self.init(title: title, image: UIImage(symbol: symbol), action: action, propertyList: propertyList, alternates: alternates, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state)
    }

    @available(iOS 15.0, tvOS 15.0, *)

    @MainActor @preconcurrency convenience init(title: String = "", subtitle: String? = nil, symbol: SFSymbol, action: Selector, propertyList: Any? = nil, alternates: [UICommandAlternate] = [], discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off) {
        self.init(title: title, subtitle: subtitle, image: UIImage(symbol: symbol), action: action, propertyList: propertyList, alternates: alternates, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state)
    }
}

@available(iOS 17.0, tvOS 17.0, *)
public extension UICommand {

    @MainActor @preconcurrency convenience init(title: String = "", subtitle: String? = nil, symbol: SFSymbol, selectedImage: UIImage? = nil, action: Selector, propertyList: Any? = nil, alternates: [UICommandAlternate] = [], discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off) {
        self.init(title: title, subtitle: subtitle, image: UIImage(symbol: symbol), selectedImage: selectedImage, action: action, propertyList: propertyList, alternates: alternates, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state)
    }
}
#endif
