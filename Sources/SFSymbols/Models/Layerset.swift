//
//  Layerset.swift
//
//
//  Generated Automatically
//

import Foundation

/// Supported rendering modes for SF Symbols
public enum Layerset: String, Codable, CaseIterable, Sendable {
    /// Single-color rendering
    case monochrome

    /// Automatic depth and emphasis using varying opacities
    case hierarchical

    /// Multiple colors with semantic meaning
    case multicolor
}
