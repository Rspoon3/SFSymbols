//
//  SFSymbol+CommonNames.swift.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation


public extension SFSymbol{
    static let share   = squareAndArrowUp
    static let refresh = arrowClockwise
    static let copy    = docOnDoc
    static let writing = squareAndPencil
}

@available(iOS 14, macOS 14.0, tvOS 14.0, watchOS 7.0,  *)
public extension SFSymbol{
    static let edit    = rectangleAndPencilAndEllipsis
    static let sort    = arrowUpArrowDownCircle
}

@available(iOS 15, macOS 15.0, tvOS 15.0, watchOS 8.0,  *)
public extension SFSymbol{
    static let filter = line3HorizontalDecreaseCircle
}
