//
//  MenuBarExtra+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(macOS 13.0, *)
@available(iOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
@available(visionOS, unavailable)
public extension MenuBarExtra where Label == SwiftUI.Label<Text, Image> {
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, isInserted: Binding<Bool>, @ViewBuilder content: () -> Content)
    {
        self.init(titleKey, systemImage: symbol.title, isInserted: isInserted, content: content)
    }

    nonisolated init<S>(_ title: S, symbol: SFSymbol, isInserted: Binding<Bool>, @ViewBuilder content: () -> Content) where S : StringProtocol
    {
        self.init(title, systemImage: symbol.title, isInserted: isInserted, content: content)
    }

    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, @ViewBuilder content: () -> Content)
    {
        self.init(titleKey, systemImage: symbol.title, content: content)
    }

    nonisolated init<S>(_ title: S, symbol: SFSymbol, @ViewBuilder content: () -> Content) where S : StringProtocol
    {
        self.init(title, systemImage: symbol.title, content: content)
    }

}

#endif
