//
//  UIWindowScene.ActivationAction+Init.swift
//
//  Generated from UIKit.framework
//

#if canImport(UIKit)
import UIKit

@available(iOS 15.0, *)
public extension UIWindowScene.ActivationAction {

    @MainActor @preconcurrency convenience init(title: String? = nil, subtitle: String? = nil, symbol: SFSymbol, identifier: UIAction.Identifier? = nil, discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], alternate: UIAction? = nil, _ configuration: @escaping UIWindowScene.ActivationAction.ConfigurationProvider) {
        self.init(title: title, subtitle: subtitle, image: UIImage(symbol: symbol), identifier: identifier, discoverabilityTitle: discoverabilityTitle, attributes: attributes, alternate: alternate, configuration)
    }
}
#endif
