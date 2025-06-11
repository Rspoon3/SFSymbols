//
//  SFSymbol+StandardNames.swift.swift
//
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation

/// Standard SF Symbols for layer ordering actions.
///
/// - Source: Most symbols follow Apple's official [Human Interface Guidelines – Icons](https://developer.apple.com/design/human-interface-guidelines/icons). Additional descriptions provided by library author.
/// Extend `SFSymbol` yourself to create your own.
public extension SFSymbol {
    
    // MARK: - Editing
    
    static let cut = scissors
    static let copy = docOnDoc
    static let paste = docOnClipboard
    static let done = checkmark
    static let save = checkmark
    static let cancel = xmark
    static let close = xmark
    static let delete = trash
    static let writing = squareAndPencil
    static let compose = squareAndPencil
    static let duplicate = plusSquareOnSquare
    static let rename = pencil
    static let moveTo = folder
    static let attach = paperclip
    static let add = plus
    static let more = ellipsis

    // MARK: - Selection

    static let select = checkmarkCircle
    static let deselect = xmark
    
    // MARK: - Text Formatting
    
    static let superscript = textformatSuperscript
    static let `subscript` = textformatSubscript
    static let alignLeft = textAlignleft
    static let center = textAligncenter
    static let justified = textJustify
    static let alignRight = textAlignright

    // MARK: - Search
    
    static let search = magnifyingglass
    static let find = docTextMagnifyingglass
    static let findAndReplace = docTextMagnifyingglass
    static let findNext = docTextMagnifyingglass
    static let findPrevious = docTextMagnifyingglass
    static let useSelectionForFind = docTextMagnifyingglass
    
    // MARK: - Sharing and Exporting
    
    static let share = squareAndArrowUp
    static let export = squareAndArrowUp
    static let print = printer
    
    // MARK: - Users and Accounts

    static let account = personCropCircle
    static let user = personCropCircle
    static let profile = personCropCircle
    
    // MARK: - Ratings

    static let dislike = handThumbsdown
    static let like = handThumbsup
    
    // MARK: - Other
    
    static let archive = archivebox
    static let refresh   = arrowClockwise
}

@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0, *)
public extension SFSymbol {
    // MARK: - Editing

    static let undo = arrowUturnForward
    static let redo = arrowUturnForward
    
    // MARK: - Misc
    
    static let edit = rectangleAndPencilAndEllipsis
    static let sort = arrowUpArrowDownCircle
}

// MARK: - Layer Ordering

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public extension SFSymbol {
    
    static let bringToFront = square3Layers3DTopFilled
    static let sendToBack = square3Layers3DBottomFilled
    static let bringForward = square2Layers3DTopFilled
    static let sendBackward = square2Layers3DBottomFilled
}

// MARK: - Search

public extension SFSymbol {
    static var filter: SFSymbol {
        if #available(iOS 15, macOS 15.0, tvOS 15.0, watchOS 8.0, *) {
            return line3HorizontalDecreaseCircle
        } else {
            return lineHorizontal3DecreaseCircle
        }
    }
}
