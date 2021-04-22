//
//  SFSymbol.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation

public struct SFSymbol: Identifiable, Hashable{
    public let title: String
    public let categories: [Category]
    public let iOSAvailability: Double
    public let macOSAvailability: Double
    public let tvOSAvailability: Double
    public let watchOSAvailability: Double
    
    //MARK: Identifiable
    public var id: String{
        title
    }
}
