//
//  ReleaseInfo.swift
//  
//
//  Created by Richard Witherspoon on 11/15/21.
//

import Foundation

public struct ReleaseInfo: Codable, Equatable, Hashable, Sendable {
    public let iOS: Double
    public let macOS: Double
    public let tvOS: Double
    public let watchOS: Double
    public let visionOS: Double
    
    enum CodingKeys: String, CodingKey {
        case iOS, macOS, tvOS, watchOS, visionOS
    }
    
    //MARK: Initializers
    public init(
        iOS: Double,
        macOS: Double,
        tvOS: Double,
        watchOS: Double,
        visionOS:Double
    ) {
        self.iOS = iOS
        self.macOS = macOS
        self.tvOS = tvOS
        self.watchOS = watchOS
        self.visionOS = visionOS
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        // Support decoding from both Double (JSON) and String (plist)
        func decodeVersion(forKey key: CodingKeys) throws -> Double {
            if let double = try? values.decode(Double.self, forKey: key) {
                return double
            }
            let string = try values.decode(String.self, forKey: key)
            guard let double = Double(string) else {
                throw DecodingError.dataCorruptedError(forKey: key, in: values, debugDescription: "Cannot convert '\(string)' to Double")
            }
            return double
        }

        iOS = try decodeVersion(forKey: .iOS)
        macOS = try decodeVersion(forKey: .macOS)
        tvOS = try decodeVersion(forKey: .tvOS)
        watchOS = try decodeVersion(forKey: .watchOS)
        visionOS = try decodeVersion(forKey: .visionOS)
    }
}

