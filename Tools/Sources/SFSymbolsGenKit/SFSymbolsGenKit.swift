import Foundation

/// Shared helpers for the generator CLI (`sfsym-gen`).
///
/// The generator runs entirely in-process; generation and querying share one
/// model layer in this module.

public enum GenError: Error, CustomStringConvertible {
    case missing(String)

    public var description: String {
        switch self {
        case .missing(let message): return message
        }
    }
}

public enum SymbolsApp {
    /// Known install locations, beta first.
    public static let candidates = [
        "/Applications/SF Symbols Beta.app",
        "/Applications/SF Symbols.app",
    ]

    /// First SF Symbols app that exists on disk, if any.
    public static func locate() -> String? {
        candidates.first { FileManager.default.fileExists(atPath: $0) }
    }
}
