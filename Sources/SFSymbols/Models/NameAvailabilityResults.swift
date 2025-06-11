//
//  NameAvailabilityResults.swift
//  
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation


public struct NameAvailabilityResults: Codable, Sendable {
    public let symbols: [SFSymbol]
    let yearToRelease: [String: ReleaseInfo]
    
    
    enum CodingKeys: String, CodingKey {
        case symbols
        case yearToRelease = "year_to_release"
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let symbolsDict = try values.decode([String: String].self, forKey: .symbols)
        let yearToRelease = try values.decode([String: ReleaseInfo].self, forKey: .yearToRelease)
        
        self.yearToRelease = yearToRelease
        symbols = symbolsDict.map {
            SFSymbol(title: $0.key, releaseInfo: yearToRelease[$0.value]!)
        }.sorted(by: {$0.title < $1.title})
    }
}
