//
//  UIMenu+Init.swift
//
//  Generated from UIKit.framework
//

#if canImport(UIKit)
import UIKit

@available(iOS 13.0, tvOS 14.0, *)
@available(watchOS, unavailable)
public extension UIMenu {

    @MainActor @preconcurrency convenience init(title: String = "", symbol: SFSymbol, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = [], children: [UIMenuElement] = []) {
        self.init(title: title, image: UIImage(symbol: symbol), identifier: identifier, options: options, children: children)
    }

    @available(iOS 15.0, tvOS 15.0, *)
    @available(watchOS, unavailable)

    @MainActor @preconcurrency convenience init(title: String = "", subtitle: String? = nil, symbol: SFSymbol, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = [], children: [UIMenuElement] = []) {
        self.init(title: title, subtitle: subtitle, image: UIImage(symbol: symbol), identifier: identifier, options: options, children: children)
    }

    @available(iOS 16.0, tvOS 16.0, *)
    @available(watchOS, unavailable)

    @MainActor @preconcurrency convenience init(title: String = "", subtitle: String? = nil, symbol: SFSymbol, identifier: UIMenu.Identifier? = nil, options: UIMenu.Options = [], preferredElementSize: UIMenu.ElementSize = { if #available(iOS 17.0, tvOS 17.0, watchOS 10.0, *) { .automatic } else { .large } }(), children: [UIMenuElement] = []) {
        self.init(title: title, subtitle: subtitle, image: UIImage(symbol: symbol), identifier: identifier, options: options, preferredElementSize: preferredElementSize, children: children)
    }
}
#endif
