//
//  SwiftPackagePatcher.swift
//  sgint
//
//  Created by Acrylic M. on 01.02.2026.
//

import Foundation
import RegexBuilder

class SwiftPackagePatcher {
    
    struct Patch {
        let additionalLines: [String]
        let patchingSection: String
        let insertAfter: String?
    }
    
    private(set) var contents: String
    private let swiftPackageUrl: URL
    private var suppressWarnings: Bool
    private var useEntryPointGenerator: Bool
    
    private lazy var patches: [Patch] = {
        let dynamicLibraryPatch = Patch(
            additionalLines: ["type: .dynamic,"],
            patchingSection: "library",
            insertAfter: "name:"
        )
        var targetLines = ["dependencies: [ \"SwiftGodot\"],"]
        if suppressWarnings {
            targetLines.append("swiftSettings: [.unsafeFlags([\"-suppress-warnings\"])],")
        }
        if useEntryPointGenerator {
            targetLines.append("plugins: [.plugin(name: \"EntryPointGeneratorPlugin\", package: \"SwiftGodot\")]")
        }
        let targetPatch = Patch(
            additionalLines: targetLines,
            patchingSection: "target",
            insertAfter: "name:"
        )
        return [dynamicLibraryPatch, targetPatch]
    }()
    
    init(
        swiftPackageUrl: URL,
        supressWarnings: Bool,
        useEntryPointGenerator: Bool
    ) throws {
        self.swiftPackageUrl = swiftPackageUrl
        self.suppressWarnings = supressWarnings
        self.useEntryPointGenerator = useEntryPointGenerator
        self.contents = try String(contentsOf: swiftPackageUrl)
    }
    
    func patch() throws {
        for patch in patches {
            apply(patch: patch)
        }
        try contents.write(
            to: swiftPackageUrl,
            atomically: true,
            encoding: .utf8
        )
    }
    
    private
    func apply(
        patch: Patch
    ) {
        let regex = Regex {
            ".\(patch.patchingSection)("
            Capture {
                ZeroOrMore(CharacterClass.anyOf(")").inverted)
            }
            "),"
        }
        for match in contents.matches(of: regex) {
            var lines = "\(match.1)"
                .split(separator: "\n")
                .map({ String($0) })
            
            var indentation: (char: Character, amount: Int)?
            var insertionIndex: Int?
            
            if let firstLine = lines.first {
                let firstChar = firstLine[firstLine.startIndex]
                indentation = (firstChar, firstLine.maxSequentialRepeats(of: firstChar))
            }
            if let after = patch.insertAfter {
                insertionIndex = lines.firstIndex(where: { $0.contains(after) })
            }
            for (lineIndex, line) in patch.additionalLines.enumerated() {
                var newLine: String = line
                
                // Try to insert matching indentation
                if let indentation {
                    newLine.insert(
                        contentsOf: String(
                            repeating: indentation.char,
                            count: indentation.amount
                        ),
                        at: newLine.startIndex
                    )
                }
                if let insertionIndex {
                    lines.insert(newLine, at: insertionIndex + lineIndex + 1)
                } else {
                    lines.append(newLine)
                }
            }
            let patchedSection = "\n" + lines.joined(separator: "\n")
            contents.removeSubrange(match.1.startIndex..<match.1.endIndex)
            contents.insert(contentsOf: patchedSection, at: match.1.startIndex)
        }
    }
}
