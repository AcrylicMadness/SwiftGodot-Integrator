//
//  Platform_Windows.swift
//  sgint
//
//  Created by Acrylic M. on 31.01.2026.
//

import Foundation

struct Platform_Windows: Platform_Desktop {
    var name: String { "windows" }
    var mainLibExtension: String { "dll" }
    var debugInfoFormat: String? { "codeview" }
    // On Windows, we need to copy .pdp and .lib files as well
    var additionalLibExtension: [String] { ["pdp", "lib"] }
    
    func build(
        using builder: ExtensionBuilder
    ) async throws -> String {
        return try await buildSwift(using: builder)
    }
}
