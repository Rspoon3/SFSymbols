//
//  Toggle+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Toggle where Label == SwiftUI.Label<Text, Image> {
    /// Creates a toggle that generates its label from a localized string key
    /// and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the toggle's localized title, that describes
    ///     the purpose of the toggle.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - isOn: A binding to a property that indicates whether the toggle is
    ///    on or off.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, isOn: Binding<Bool>) {
        self.init(titleKey, systemImage: symbol.title, isOn: isOn)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a toggle that generates its label from a localized string resource
    /// and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Text`` view on your behalf. See
    /// `Text` for more information about localizing strings.
    ///
    /// - Parameters:
    ///   - titleResource: Text resource for the toggle's localized title, that
    ///     describes the purpose of the toggle.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - isOn: A binding to a property that indicates whether the toggle is
    ///    on or off.
    @_disfavoredOverload nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, isOn: Binding<Bool>) {
        self.init(titleResource, systemImage: symbol.title, isOn: isOn)
    }

    /// Creates a toggle that generates its label from a string and
    /// system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Text`` view on your behalf. See `Text` for more
    /// information about localizing strings.
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the toggle.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - isOn: A binding to a property that indicates whether the toggle is
    ///    on or off.
    @_disfavoredOverload nonisolated init<S>(_ title: S, symbol: SFSymbol, isOn: Binding<Bool>) where S : StringProtocol {
        self.init(title, systemImage: symbol.title, isOn: isOn)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a toggle representing a collection of values that generates its
    /// label from a localized string key and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// `Text` for more information about localizing strings.
    ///
    /// The following example creates a single toggle that represents
    /// the state of multiple alarms:
    ///
    ///     struct Alarm: Hashable, Identifiable {
    ///         var id = UUID()
    ///         var isOn = false
    ///         var name = ""
    ///     }
    ///
    ///     @State private var alarms = [
    ///         Alarm(isOn: true, name: "Morning"),
    ///         Alarm(isOn: false, name: "Evening")
    ///     ]
    ///
    ///     Toggle("Enable all alarms", sources: $alarms, isOn: \.isOn)
    ///
    /// - Parameters:
    ///   - titleKey: The key for the toggle's localized title, that describes
    ///     the purpose of the toggle.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - sources: A collection of values used as the source for rendering the
    ///     Toggle's state.
    ///   - isOn: The key path of the values that determines whether the toggle
    ///     is on, mixed or off.
    nonisolated init<C>(_ titleKey: LocalizedStringKey, symbol: SFSymbol, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(titleKey, systemImage: symbol.title, sources: sources, isOn: isOn)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a toggle representing a collection of values that generates its
    /// label from a localized string resource and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Text`` view on your behalf. See
    /// `Text` for more information about localizing strings.
    ///
    /// The following example creates a single toggle that represents
    /// the state of multiple alarms:
    ///
    ///     struct Alarm: Hashable, Identifiable {
    ///         var id = UUID()
    ///         var isOn = false
    ///         var name = ""
    ///     }
    ///
    ///     @State private var alarms = [
    ///         Alarm(isOn: true, name: "Morning"),
    ///         Alarm(isOn: false, name: "Evening")
    ///     ]
    ///
    ///     Toggle("Enable all alarms", sources: $alarms, isOn: \.isOn)
    ///
    /// - Parameters:
    ///   - titleResource: Text resource for the toggle's localized title, that
    ///     describes the purpose of the toggle.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - sources: A collection of values used as the source for rendering the
    ///     Toggle's state.
    ///   - isOn: The key path of the values that determines whether the toggle
    ///     is on, mixed or off.
    @_disfavoredOverload nonisolated init<C>(_ titleResource: LocalizedStringResource, symbol: SFSymbol, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where C : RandomAccessCollection {
        self.init(titleResource, systemImage: symbol.title, sources: sources, isOn: isOn)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a toggle representing a collection of values that generates its
    /// label from a string.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// This initializer creates a ``Text`` view on your behalf. See `Text` for more
    /// information about localizing strings.
    ///
    /// The following example creates a single toggle that represents
    /// the state of multiple alarms:
    ///
    ///     struct Alarm: Hashable, Identifiable {
    ///         var id = UUID()
    ///         var isOn = false
    ///         var name = ""
    ///     }
    ///
    ///     @State private var alarms = [
    ///         Alarm(isOn: true, name: "Morning"),
    ///         Alarm(isOn: false, name: "Evening")
    ///     ]
    ///
    ///     Toggle("Enable all alarms", sources: $alarms, isOn: \.isOn)
    ///
    /// - Parameters:
    ///   - title: A string that describes the purpose of the toggle.
    ///   - symbol: The `SFSymbol` describing the image.
    ///   - sources: A collection of values used as the source for rendering
    ///     the Toggle's state.
    ///   - isOn: The key path of the values that determines whether the toggle
    ///     is on, mixed or off.
    @_disfavoredOverload nonisolated init<S, C>(_ title: S, symbol: SFSymbol, sources: C, isOn: KeyPath<C.Element, Binding<Bool>>) where S : StringProtocol, C : RandomAccessCollection {
        self.init(title, systemImage: symbol.title, sources: sources, isOn: isOn)
    }
}
#endif
