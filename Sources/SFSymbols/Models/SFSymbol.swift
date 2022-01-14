//
//  SFSymbol.swift
//  
//
//  Created by Richard Witherspoon on 4/22/21.
//

import Foundation


public struct SFSymbol: Codable, Identifiable, Equatable, Hashable{
    public let title: String
    public var categories: [SFCategory]?
    public var searchTerms: [String]?
    public let releaseInfo: ReleaseInfo
    
    public var id: String{
        title
    }
    
    //MARK: Public Init
    public init(title: String, categories: [SFCategory]? = nil, searchTerms: [String]? = nil, releaseInfo: ReleaseInfo){
        self.title = title
        self.releaseInfo = releaseInfo
        self.categories = categories
        self.searchTerms = searchTerms
    }
}


