//
//  Picker+Init.swift
//
//  Generated from SwiftUI.swiftinterface
//

#if canImport(SwiftUI)
import SwiftUI

@available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *)
public extension Picker where Label == SwiftUI.Label<Text, Image> {
    /// Creates a picker that generates its label from a localized string key
    /// and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleKey: A localized string key that describes the purpose of
    ///       selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.init(titleKey, systemImage: symbol.title, selection: selection, content: content)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a picker that generates its label from a localized string
    /// resource and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - titleResource: A localized string resource that describes the
    ///       purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - content: A view that contains the set of options.
    ///
    /// This initializer creates a ``Text`` view on your behalf. See
    /// ``Text`` for more information about localizing strings.
    nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) {
        self.init(titleResource, systemImage: symbol.title, selection: selection, content: content)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a picker that generates its label from a localized string key.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         "Border Thickness",
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - titleKey: A localized string key that describes the purpose of
    ///       selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    nonisolated init<C>(_ titleKey: LocalizedStringKey, symbol: SFSymbol, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, C.Element == Binding<SelectionValue> {
        self.init(titleKey, systemImage: symbol.title, sources: sources, selection: selection, content: content)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a picker that generates its label from a localized string resource.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         "Border Thickness",
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - titleResource: A localized string resource that describes the
    ///       purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    nonisolated init<C>(_ titleResource: LocalizedStringResource, symbol: SFSymbol, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, C.Element == Binding<SelectionValue> {
        self.init(titleResource, systemImage: symbol.title, sources: sources, selection: selection, content: content)
    }

    /// Creates a picker that generates its label from a string and
    /// system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///     - title: A string that describes the purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - selection: A binding to a property that determines the
    ///       currently-selected option.
    ///     - content: A view that contains the set of options.
    nonisolated init<S>(_ title: S, symbol: SFSymbol, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content) where S : StringProtocol {
        self.init(title, systemImage: symbol.title, selection: selection, content: content)
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    /// Creates a picker bound to a collection of bindings that generates its
    /// label from a string.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// If the wrapped values of the collection passed to `sources` are not all
    /// the same, some styles render the selection in a mixed state. The
    /// specific presentation depends on the style.  For example, a Picker
    /// with a menu style uses dashes instead of checkmarks to indicate the
    /// selected values.
    ///
    /// In the following example, a picker in a document inspector controls the
    /// thickness of borders for the currently-selected shapes, which can be of
    /// any number.
    ///
    ///     enum Thickness: String, CaseIterable, Identifiable {
    ///         case thin
    ///         case regular
    ///         case thick
    ///
    ///         var id: String { rawValue }
    ///     }
    ///
    ///     struct Border {
    ///         var color: Color
    ///         var thickness: Thickness
    ///     }
    ///
    ///     @State private var selectedObjectBorders = [
    ///         Border(color: .black, thickness: .thin),
    ///         Border(color: .red, thickness: .thick)
    ///     ]
    ///
    ///     Picker(
    ///         "Border Thickness",
    ///         sources: $selectedObjectBorders,
    ///         selection: \.thickness
    ///     ) {
    ///         ForEach(Thickness.allCases) { thickness in
    ///             Text(thickness.rawValue)
    ///         }
    ///     }
    ///
    /// - Parameters:
    ///     - title: A string that describes the purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///     - sources: A collection of values used as the source for displaying
    ///       the Picker's selection.
    ///     - selection: The key path of the values that determines the
    ///       currently-selected options. When a user selects an option from the
    ///       picker, the values at the key path of all items in the `sources`
    ///       collection are updated with the selected option.
    ///     - content: A view that contains the set of options.
    nonisolated init<C, S>(_ title: S, symbol: SFSymbol, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content) where C : RandomAccessCollection, S : StringProtocol, C.Element == Binding<SelectionValue> {
        self.init(title, systemImage: symbol.title, sources: sources, selection: selection, content: content)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension Picker where Label == SwiftUI.Label<Text, Image> {
    /// Creates a picker that accepts a custom current value label and
    /// generates its label from a localized string key and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - titleKey: A localized string key that describes the purpose of
    ///      selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///    - selection: A binding to a property that determines the
    ///      currently-selected option.
    ///    - content: A view that contains the set of options.
    ///    - currentValueLabel: A view that represents the current value of the picker.
    ///
    /// This initializer creates a ``Text`` view on your behalf, and treats the
    /// localized key similar to ``Text/init(_:tableName:bundle:comment:)``. See
    /// ``Text`` for more information about localizing strings.
    nonisolated init(_ titleKey: LocalizedStringKey, symbol: SFSymbol, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) {
        self.init(titleKey, systemImage: symbol.title, selection: selection, content: content)
    }

    /// Creates a picker that accepts a custom current value label and
    /// generates its label from a localized string key and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - titleResource: A localized string resource that describes the
    ///      purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///    - selection: A binding to a property that determines the
    ///      currently-selected option.
    ///    - content: A view that contains the set of options.
    ///    - currentValueLabel: A view that represents the current value of the
    ///      picker.
    ///
    /// This initializer creates a ``Text`` view on your behalf. See
    /// ``Text`` for more information about localizing strings.
    nonisolated init(_ titleResource: LocalizedStringResource, symbol: SFSymbol, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) {
        self.init(titleResource, systemImage: symbol.title, selection: selection, content: content)
    }

    /// Creates a picker that accepts a custom current value label and
    /// generates its label from a localized string key.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - titleKey: A localized string key that describes the purpose of
    ///      selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///    - sources: A collection of values used as the source for displaying
    ///      the Picker's selection.
    ///    - selection: The key path of the values that determines the
    ///      currently-selected options. When a user selects an option from the
    ///      picker, the values at the key path of all items in the `sources`
    ///      collection are updated with the selected option.
    ///    - content: A view that contains the set of options.
    ///    - currentValueLabel: A view that represents the current value of the picker.
    nonisolated init<C>(_ titleKey: LocalizedStringKey, symbol: SFSymbol, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, C.Element == Binding<SelectionValue> {
        self.init(titleKey, systemImage: symbol.title, sources: sources, selection: selection, content: content)
    }

    /// Creates a picker that accepts a custom current value label and
    /// generates its label from a localized string resource.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - titleResource: A localized string resource that describes the
    ///      purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///    - sources: A collection of values used as the source for displaying
    ///      the Picker's selection.
    ///    - selection: The key path of the values that determines the
    ///      currently-selected options. When a user selects an option from the
    ///      picker, the values at the key path of all items in the `sources`
    ///      collection are updated with the selected option.
    ///    - content: A view that contains the set of options.
    ///    - currentValueLabel: A view that represents the current value of the
    ///      picker.
    nonisolated init<C>(_ titleResource: LocalizedStringResource, symbol: SFSymbol, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, C.Element == Binding<SelectionValue> {
        self.init(titleResource, systemImage: symbol.title, sources: sources, selection: selection, content: content)
    }

    /// Creates a picker that accepts a custom current value and generates its
    /// label from a string and system image.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - title: A string that describes the purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///    - selection: A binding to a property that determines the
    ///      currently-selected option.
    ///    - content: A view that contains the set of options.
    ///    - currentValueLabel: A view that represents the current value of the picker.
    nonisolated init<S>(_ title: S, symbol: SFSymbol, selection: Binding<SelectionValue>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where S : StringProtocol {
        self.init(title, systemImage: symbol.title, selection: selection, content: content)
    }

    /// Creates a picker bound to a collection of bindings that accepts a
    /// custom current value label and generates its label from a string.
    ///
    /// This initializer is equivalent to the `systemImage` variant.
    /// - Parameters:
    ///    - title: A string that describes the purpose of selecting an option.
    ///   - symbol: The `SFSymbol` describing the image.
    ///    - sources: A collection of values used as the source for displaying
    ///      the Picker's selection.
    ///    - selection: The key path of the values that determines the
    ///      currently-selected options. When a user selects an option from the
    ///      picker, the values at the key path of all items in the `sources`
    ///      collection are updated with the selected option.
    ///    - content: A view that contains the set of options.
    ///    - currentValueLabel: A view that represents the current value of the picker.
    nonisolated init<C, S>(_ title: S, symbol: SFSymbol, sources: C, selection: KeyPath<C.Element, Binding<SelectionValue>>, @ViewBuilder content: () -> Content, @ViewBuilder currentValueLabel: () -> some View) where C : RandomAccessCollection, S : StringProtocol, C.Element == Binding<SelectionValue> {
        self.init(title, systemImage: symbol.title, sources: sources, selection: selection, content: content)
    }
}
#endif
