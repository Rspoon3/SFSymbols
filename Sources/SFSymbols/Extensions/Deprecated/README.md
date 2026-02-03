# Deprecated Extensions

This folder contains custom initializers that have been deprecated in favor of the auto-generated wrappers from official SwiftUI/UIKit documentation.

## Files

### Button+Deprecated.swift
Contains deprecated custom Button initializers:
- `Button where Label == Image` - Buttons with only an image (no text)
- Button initializers with `textColor` parameter

### Label+Deprecated.swift
Contains deprecated custom Label initializers:
- Label initializers with `textColor` parameter

## Why Deprecated?

These initializers were custom hand-written additions that are not part of the official SwiftUI API. They have been deprecated because:

1. **Maintainability**: Auto-generated wrappers stay synchronized with Apple's official API
2. **Consistency**: Standard initializers follow Apple's design patterns
3. **Flexibility**: Custom styling should be applied using SwiftUI modifiers rather than custom parameters

## Migration Guide

### Button with Label == Image
**Old (Deprecated):**
```swift
Button(symbol: .trash) {
    // action
}
```

**New:**
```swift
Button("", symbol: .trash) {
    // action
}
// Or use Image directly
```

### Button/Label with textColor
**Old (Deprecated):**
```swift
Button("Delete", symbol: .trash, textColor: .red) {
    // action
}
```

**New:**
```swift
Button("Delete", symbol: .trash) {
    // action
}
.foregroundStyle(.red)
```

## Removal Timeline

These deprecated APIs will be removed in a future major version. Please migrate to the recommended alternatives.
