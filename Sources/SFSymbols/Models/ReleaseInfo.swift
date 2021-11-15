//
//  ReleaseInfo.swift
//  
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation


public struct ReleaseInfo: Codable{
    public let iOS: Double
    public let macOS: Double
    public let tvOS: Double
    public let watchOS: Double
    
    enum CodingKeys: String, CodingKey {
        case iOS, macOS, tvOS, watchOS
    }
    
    //MARK: Initializers
    public init(iOS: Double, macOS: Double, tvOS: Double, watchOS: Double) {
        self.iOS = iOS
        self.macOS = macOS
        self.tvOS = tvOS
        self.watchOS = watchOS
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        iOS = try Double(values.decode(String.self, forKey: .iOS))!
        macOS = try Double(values.decode(String.self, forKey: .macOS))!
        tvOS = try Double(values.decode(String.self, forKey: .tvOS))!
        watchOS = try Double(values.decode(String.self, forKey: .watchOS))!
    }
}

