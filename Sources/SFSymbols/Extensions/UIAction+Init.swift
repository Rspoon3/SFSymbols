//
//  UIAction+Init.swift
//
//  Generated from UIKit.framework
//

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, tvOS 14.0, *)
@available(watchOS, unavailable)
public extension UIAction {

    @MainActor @preconcurrency convenience init(title: String = "", symbol: SFSymbol, identifier: UIAction.Identifier? = nil, discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off, handler: @escaping UIActionHandler) {
        self.init(title: title, image: UIImage(symbol: symbol), identifier: identifier, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state, handler: handler)
    }

    @available(iOS 15.0, tvOS 15.0, *)
    @available(watchOS, unavailable)

    @MainActor @preconcurrency convenience init(title: String = "", subtitle: String? = nil, symbol: SFSymbol, identifier: UIAction.Identifier? = nil, discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off, handler: @escaping UIActionHandler) {
        self.init(title: title, subtitle: subtitle, image: UIImage(symbol: symbol), identifier: identifier, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state, handler: handler)
    }

    @available(iOS 17.0, tvOS 17.0, *)
    @available(watchOS, unavailable)

    @MainActor @preconcurrency convenience init(title: String = "", subtitle: String? = nil, symbol: SFSymbol, selectedImage: UIImage? = nil, identifier: UIAction.Identifier? = nil, discoverabilityTitle: String? = nil, attributes: UIMenuElement.Attributes = [], state: UIMenuElement.State = .off, handler: @escaping UIActionHandler) {
        self.init(title: title, subtitle: subtitle, image: UIImage(symbol: symbol), selectedImage: selectedImage, identifier: identifier, discoverabilityTitle: discoverabilityTitle, attributes: attributes, state: state, handler: handler)
    }
}
#endif
