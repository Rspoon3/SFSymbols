#!/usr/bin/env swift

import Foundation

// MARK: - Data Structures

struct ParsedInitializer {
    let typeName: String
    let extensionAvailability: [String]
    let initAvailability: [String]
    let documentation: [String]
    let attributes: [String]
    let signature: String
    let parameters: [Parameter]
}

struct Parameter {
    let externalName: String?
    let internalName: String
    let type: String
    let attributes: [String]
    let defaultValue: String?
}

struct ExtensionGroup {
    let typeName: String
    let availability: [String]
    let initializers: [ParsedInitializer]
}

// MARK: - Parsing State Machine

enum ParsingState {
    case scanning
    case collectingAvailability
    case collectingExtension
    case collectingDocs
    case collectingSignature
}

class ParsingBuffer {
    var extensionAvailability: [String] = []
    var initAvailability: [String] = []
    var typeName: String = ""
    var docs: [String] = []
    var attributes: [String] = []
    var signature: String = ""

    func reset() {
        extensionAvailability = []
        initAvailability = []
        typeName = ""
        docs = []
        attributes = []
        signature = ""
    }

    func clearInit() {
        initAvailability = []
        docs = []
        attributes = []
        signature = ""
    }
}

// MARK: - Main Parsing Function

func parse(plainTextFile: String) -> [ParsedInitializer] {
    guard let content = try? String(contentsOfFile: plainTextFile, encoding: .utf8) else {
        print("❌ Failed to read plain text file")
        exit(1)
    }

    let lines = content.components(separatedBy: .newlines)
    var state = ParsingState.scanning
    var results: [ParsedInitializer] = []
    let buffer = ParsingBuffer()

    for line in lines {
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        switch state {
        case .scanning:
            if trimmed.hasPrefix("@available") {
                buffer.extensionAvailability = [trimmed]
                state = .collectingAvailability
            }

        case .collectingAvailability:
            if trimmed.hasPrefix("@available") {
                buffer.extensionAvailability.append(trimmed)
            } else if trimmed.hasPrefix("extension ") {
                buffer.typeName = extractTypeName(from: trimmed)
                state = .collectingExtension
            } else {
                buffer.reset()
                state = .scanning
            }

        case .collectingExtension:
            if trimmed.hasPrefix("@available") {
                buffer.initAvailability.append(trimmed)
            } else if trimmed.hasPrefix("///") {
                buffer.docs = [line]
                state = .collectingDocs
            } else if trimmed.contains("init") && (trimmed.contains("(") || trimmed.contains("<")) {
                buffer.attributes = extractAttributes(from: trimmed)
                buffer.signature = trimmed
                state = .collectingSignature
            } else if trimmed == "}" {
                buffer.reset()
                state = .scanning
            }

        case .collectingDocs:
            if trimmed.hasPrefix("///") {
                buffer.docs.append(line)
            } else if trimmed.hasPrefix("@available") {
                buffer.initAvailability.append(trimmed)
            } else if trimmed.contains("init") && (trimmed.contains("(") || trimmed.contains("<")) {
                buffer.attributes = extractAttributes(from: trimmed)
                buffer.signature = trimmed
                state = .collectingSignature
            } else {
                state = .collectingExtension
            }

        case .collectingSignature:
            if trimmed == "}" {
                if buffer.signature.contains("image:") && hasUIImageParameter(buffer.signature) {
                    if let parsed = parseInitializer(from: buffer) {
                        results.append(parsed)
                    }
                }
                buffer.reset()
                state = .scanning
            } else if trimmed.hasPrefix("extension ") {
                if buffer.signature.contains("image:") && hasUIImageParameter(buffer.signature) {
                    if let parsed = parseInitializer(from: buffer) {
                        results.append(parsed)
                    }
                }
                buffer.typeName = extractTypeName(from: trimmed)
                buffer.clearInit()
                state = .collectingExtension
            } else {
                buffer.signature += " " + trimmed

                if isSignatureComplete(buffer.signature) {
                    if buffer.signature.contains("image:") && hasUIImageParameter(buffer.signature) {
                        if let parsed = parseInitializer(from: buffer) {
                            results.append(parsed)
                        }
                    }

                    buffer.clearInit()
                    state = .collectingExtension
                }
            }
        }
    }

    return results
}

func hasUIImageParameter(_ signature: String) -> Bool {
    // Simple check: look for "image:" followed by UIImage type
    let pattern = "image:\\s*UIImage"
    return signature.range(of: pattern, options: .regularExpression) != nil
}

// MARK: - Extraction Functions

func extractTypeName(from line: String) -> String {
    let cleaned = line.replacingOccurrences(of: "extension ", with: "")
        .replacingOccurrences(of: " {", with: "")
        .trimmingCharacters(in: .whitespaces)

    // Just get the first word (type name)
    if let spaceIdx = cleaned.firstIndex(of: " ") {
        return String(cleaned[..<spaceIdx])
    }

    return cleaned
}

func extractAttributes(from line: String) -> [String] {
    var attributes: [String] = []
    let words = line.components(separatedBy: .whitespaces).filter { !$0.isEmpty }

    for word in words {
        if word == "convenience" || word == "required" || word == "public" || word.hasPrefix("@") {
            attributes.append(word)
        } else if word.hasPrefix("init") {
            break
        }
    }

    return attributes
}

func isSignatureComplete(_ signature: String) -> Bool {
    let openCount = signature.filter { $0 == "(" }.count
    let closeCount = signature.filter { $0 == ")" }.count
    return openCount > 0 && openCount == closeCount
}

func parseInitializer(from buffer: ParsingBuffer) -> ParsedInitializer? {
    guard let parameters = parseParameters(from: buffer.signature) else {
        return nil
    }

    return ParsedInitializer(
        typeName: buffer.typeName,
        extensionAvailability: buffer.extensionAvailability,
        initAvailability: buffer.initAvailability,
        documentation: buffer.docs,
        attributes: buffer.attributes,
        signature: buffer.signature,
        parameters: parameters
    )
}

// MARK: - Parameter Parsing

func parseParameters(from signature: String) -> [Parameter]? {
    guard let openParen = signature.firstIndex(of: "("),
          let closeParen = signature.lastIndex(of: ")") else {
        return nil
    }

    let paramString = String(signature[signature.index(after: openParen)..<closeParen])
    if paramString.trimmingCharacters(in: .whitespaces).isEmpty {
        return []
    }

    let paramStrings = splitParameters(paramString)
    var parameters: [Parameter] = []

    for paramStr in paramStrings {
        if let param = parseParameter(paramStr.trimmingCharacters(in: .whitespaces)) {
            parameters.append(param)
        }
    }

    return parameters
}

func splitParameters(_ paramString: String) -> [String] {
    var result: [String] = []
    var current = ""
    var parenDepth = 0
    var angleDepth = 0

    for char in paramString {
        switch char {
        case "(":
            parenDepth += 1
            current.append(char)
        case ")":
            parenDepth -= 1
            current.append(char)
        case "<":
            angleDepth += 1
            current.append(char)
        case ">":
            angleDepth -= 1
            current.append(char)
        case "," where parenDepth == 0 && angleDepth == 0:
            result.append(current)
            current = ""
        default:
            current.append(char)
        }
    }

    if !current.isEmpty {
        result.append(current)
    }

    return result
}

func parseParameter(_ paramStr: String) -> Parameter? {
    var remaining = paramStr.trimmingCharacters(in: .whitespaces)
    var attributes: [String] = []

    // Extract attributes
    while remaining.hasPrefix("@") {
        if let spaceIdx = remaining.firstIndex(of: " ") {
            let attr = String(remaining[..<spaceIdx])
            attributes.append(attr)
            remaining = String(remaining[remaining.index(after: spaceIdx)...]).trimmingCharacters(in: .whitespaces)
        } else {
            break
        }
    }

    // Split by colon to get name and type
    guard let colonIdx = remaining.firstIndex(of: ":") else {
        return nil
    }

    let namePart = String(remaining[..<colonIdx]).trimmingCharacters(in: .whitespaces)
    let typePart = String(remaining[remaining.index(after: colonIdx)...]).trimmingCharacters(in: .whitespaces)

    // Parse name
    let nameComponents = namePart.components(separatedBy: .whitespaces).filter { !$0.isEmpty }
    let externalName: String?
    let internalName: String

    if nameComponents.count == 2 {
        externalName = nameComponents[0] == "_" ? nil : nameComponents[0]
        internalName = nameComponents[1]
    } else if nameComponents.count == 1 {
        externalName = nameComponents[0]
        internalName = nameComponents[0]
    } else {
        return nil
    }

    // Parse type and default value
    let typeAndDefault = typePart.components(separatedBy: "=")
    let type = typeAndDefault[0].trimmingCharacters(in: .whitespaces)
    let defaultValue = typeAndDefault.count > 1 ? typeAndDefault[1].trimmingCharacters(in: .whitespaces) : nil

    return Parameter(
        externalName: externalName,
        internalName: internalName,
        type: type,
        attributes: attributes,
        defaultValue: defaultValue
    )
}

// MARK: - Code Generation

func transformDocs(_ docs: [String], typeName: String) -> [String] {
    guard !docs.isEmpty else { return docs }

    var transformed = docs

    // Update references to image parameter
    for i in 0..<transformed.count {
        if transformed[i].contains("- image:") {
            transformed[i] = "    ///   - symbol: The `SFSymbol` for the image."
        }
    }

    // Find first blank doc line and add equivalence note
    var insertIndex = -1
    for (i, line) in transformed.enumerated() {
        let trimmed = line.trimmingCharacters(in: .whitespaces)
        if trimmed == "///" {
            insertIndex = i + 1
            break
        }
    }

    if insertIndex > 0 && insertIndex < transformed.count {
        transformed.insert("    /// This initializer is equivalent to the `image` variant.", at: insertIndex)
    }

    return transformed
}

func generateWrapperSignature(_ parsed: ParsedInitializer) -> String {
    var sig = "    "

    // Add attributes (filter out public, it goes on extension)
    let attrs = parsed.attributes.filter { $0 != "public" }
    if !attrs.isEmpty {
        sig += attrs.joined(separator: " ") + " "
    }

    // Ensure convenience is always included (required for initializers in extensions)
    if !attrs.contains("convenience") {
        sig += "convenience "
    }

    sig += "init"

    // Extract generics if present
    if let generics = extractGenerics(from: parsed.signature) {
        sig += generics
    }

    sig += "("

    // Build parameter list
    let params = parsed.parameters.map { param -> String in
        if isImageParameter(param) {
            var result = ""
            if !param.attributes.isEmpty {
                result += param.attributes.joined(separator: " ") + " "
            }
            if let external = param.externalName, external != param.internalName {
                result += "\(external) symbol: SFSymbol"
            } else {
                result += "symbol: SFSymbol"
            }
            return result
        } else {
            return reconstructParameter(param)
        }
    }.joined(separator: ", ")

    sig += params
    sig += ")"

    return sig
}

func extractGenerics(from signature: String) -> String? {
    guard let initRange = signature.range(of: "init") else { return nil }
    let afterInit = String(signature[initRange.upperBound...])

    guard let openAngle = afterInit.firstIndex(of: "<"),
          let closeAngle = afterInit.firstIndex(of: ">"),
          openAngle < closeAngle else {
        return nil
    }

    if let openParen = afterInit.firstIndex(of: "("), openAngle < openParen {
        return String(afterInit[openAngle...closeAngle])
    }

    return nil
}

func isImageParameter(_ param: Parameter) -> Bool {
    let isImageType = param.type.contains("UIImage")
    let hasImageName = param.externalName == "image" || param.internalName == "image"
    return isImageType && hasImageName
}

func reconstructParameter(_ param: Parameter) -> String {
    var result = ""

    if !param.attributes.isEmpty {
        result += param.attributes.joined(separator: " ") + " "
    }

    if let external = param.externalName {
        if external != param.internalName {
            result += "\(external) \(param.internalName): "
        } else {
            result += "\(param.internalName): "
        }
    } else {
        result += "_ \(param.internalName): "
    }

    result += param.type

    if let defaultValue = param.defaultValue {
        result += " = \(defaultValue)"
    }

    return result
}

func reconstructParameterForCall(_ param: Parameter) -> String {
    if let external = param.externalName {
        return "\(external): \(param.internalName)"
    }
    return param.internalName
}

func generateForwardingCall(_ parsed: ParsedInitializer) -> String {
    let params = parsed.parameters.map { param -> String in
        if isImageParameter(param) {
            if let external = param.externalName {
                return "\(external): UIImage(symbol: symbol)"
            }
            return "UIImage(symbol: symbol)"
        } else {
            return reconstructParameterForCall(param)
        }
    }.joined(separator: ", ")

    return "        self.init(\(params))"
}

func generateInitWrapper(_ parsed: ParsedInitializer, extensionAvailability: [String]) -> String {
    var output = ""

    // Add init-specific availability
    if !parsed.initAvailability.isEmpty {
        output += "    " + parsed.initAvailability.joined(separator: "\n    ") + "\n"
    }

    // Documentation
    let docs = transformDocs(parsed.documentation, typeName: parsed.typeName)
    output += docs.joined(separator: "\n") + "\n"

    // Signature
    output += generateWrapperSignature(parsed) + " {\n"
    output += generateForwardingCall(parsed) + "\n"
    output += "    }\n"

    return output
}

// MARK: - File Generation

func groupIntoExtensions(_ initializers: [ParsedInitializer]) -> [ExtensionGroup] {
    var groups: [String: ExtensionGroup] = [:]

    for initializer in initializers {
        let key = initializer.extensionAvailability.joined(separator: "|")

        if let existing = groups[key] {
            var newInits = existing.initializers
            newInits.append(initializer)
            groups[key] = ExtensionGroup(
                typeName: existing.typeName,
                availability: existing.availability,
                initializers: newInits
            )
        } else {
            groups[key] = ExtensionGroup(
                typeName: initializer.typeName,
                availability: initializer.extensionAvailability,
                initializers: [initializer]
            )
        }
    }

    return Array(groups.values)
}

func generateFileHeader(_ typeName: String) -> String {
    return """
    //
    //  \(typeName)+Init.swift
    //
    //  Generated from UIKit.framework
    //

    #if canImport(UIKit)
    import UIKit


    """
}

func generateExtensionBlock(_ group: ExtensionGroup) -> String {
    var block = ""

    if !group.availability.isEmpty {
        block += group.availability.joined(separator: "\n") + "\n"
    }

    block += "public extension \(group.typeName) {\n"

    for (index, initializer) in group.initializers.enumerated() {
        block += generateInitWrapper(initializer, extensionAvailability: group.availability)
        if index < group.initializers.count - 1 {
            block += "\n"
        }
    }

    block += "}\n"

    return block
}

func generateFiles(initializers: [ParsedInitializer], outputDir: String) {
    let byType = Dictionary(grouping: initializers) { $0.typeName }

    for (typeName, inits) in byType.sorted(by: { $0.key < $1.key }) {
        let fileName = "\(typeName)+Init.swift"
        let filePath = "\(outputDir)/\(fileName)"

        let extensions = groupIntoExtensions(inits)

        var content = generateFileHeader(typeName)

        for (index, ext) in extensions.enumerated() {
            content += generateExtensionBlock(ext)
            if index < extensions.count - 1 {
                content += "\n"
            }
        }

        content += "#endif\n"

        do {
            try content.write(toFile: filePath, atomically: true, encoding: .utf8)
            print("✅ Generated: \(fileName) (\(inits.count) initializers)")
        } catch {
            print("❌ Failed to write \(fileName): \(error)")
        }
    }
}

// MARK: - RTF Conversion

func convertToPlainText(_ rtfPath: String) -> String {
    let tmpDir = NSTemporaryDirectory()
    let txtPath = tmpDir + "uikit_doc_\(UUID().uuidString).txt"

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/usr/bin/textutil")
    process.arguments = ["-convert", "txt", "-output", txtPath, rtfPath]

    do {
        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            print("❌ Failed to convert RTF to text")
            exit(1)
        }

        return txtPath
    } catch {
        print("❌ Error running textutil: \(error)")
        exit(1)
    }
}

// MARK: - Main Entry Point

func main() {
    guard CommandLine.arguments.count > 1 else {
        print("Usage: ParseUIKitDoc.swift <path-to-rtf-file>")
        print("Example: swift ParseUIKitDoc.swift UIKitDocumentation.rtf")
        exit(1)
    }

    let rtfPath = CommandLine.arguments[1]

    guard FileManager.default.fileExists(atPath: rtfPath) else {
        print("❌ File not found: \(rtfPath)")
        exit(1)
    }

    print("📄 Converting RTF to plain text...")
    let txtPath = convertToPlainText(rtfPath)

    print("🔍 Parsing initializers with image parameters...")
    let initializers = parse(plainTextFile: txtPath)
    print("   Found \(initializers.count) initializers")

    let byType = Dictionary(grouping: initializers) { $0.typeName }
    print("   Grouped into \(byType.count) types")

    print("✍️  Generating extension files...")
    let outputDir = "./Sources/SFSymbols/Extensions"
    generateFiles(initializers: initializers, outputDir: outputDir)

    try? FileManager.default.removeItem(atPath: txtPath)

    print("✅ Complete! Generated \(byType.count) extension files")
}

main()
