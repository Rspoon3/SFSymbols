//
//  SFSymbol+CommonNames.swift.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation


public extension SFSymbol{
    static let share    = SFSymbol.squareAndArrowUp
    static let refresh = SFSymbol.arrowClockwise
    static let copy    = SFSymbol.docOnDoc
    static let writing = SFSymbol.squareAndPencil
}

@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0,  *)
public extension SFSymbol{
    static let edit = SFSymbol.rectangleAndPencilAndEllipsis
}
