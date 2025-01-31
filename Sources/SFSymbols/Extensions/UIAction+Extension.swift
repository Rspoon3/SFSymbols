//
//  UIAction+Extension.swift
//
//
//  Created by Richard Witherspoon on 3/18/22.
//

#if canImport(UIKit) && os(iOS) || os(tvOS) || os(visionOS)
import UIKit

extension UIAction {
    @available(tvOS 17.0, *)
    public convenience init(
        title: String = "",
        symbol: SFSymbol,
        identifier: UIAction.Identifier? = nil,
        discoverabilityTitle: String? = nil,
        attributes: UIMenuElement.Attributes = [],
        state: UIMenuElement.State = .off,
        handler: @escaping UIActionHandler
    ) {
        self.init(
            title: title,
            image: UIImage(symbol: symbol),
            identifier: identifier,
            discoverabilityTitle: discoverabilityTitle,
            attributes: attributes,
            state: state,
            handler: handler
        )
    }
    
    @available(iOS 15.0, tvOS 15.0, *)
    public convenience init(
        title: String = "",
        subtitle: String? = nil,
        symbol: SFSymbol,
        identifier: UIAction.Identifier? = nil,
        discoverabilityTitle: String? = nil,
        attributes: UIMenuElement.Attributes = [],
        state: UIMenuElement.State = .off,
        handler: @escaping UIActionHandler
    ) {
        self.init(
            title: title,
            subtitle: subtitle,
            image: UIImage(symbol: symbol),
            identifier: identifier,
            discoverabilityTitle: discoverabilityTitle,
            attributes: attributes,
            state: state,
            handler: handler
        )
    }
}
#endif
