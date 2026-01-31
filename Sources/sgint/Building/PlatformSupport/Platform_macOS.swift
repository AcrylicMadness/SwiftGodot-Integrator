//
//  Platform_macOS.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Foundation

struct Platform_macOS: Platform {
    var name: String { "macos" }
    var libExtension: String { "dylib" }
    var libPrefix: String { "lib" }
    
    func build(using builder: ExtensionBuilder) async throws -> String {
        let archConfig = await builder.buildArchs.reduce(into: "") { partialResult, arch in
            partialResult.append("--arch \(arch) ")
        }
        
        let cmd = await "cd \(builder.driverPath.path) && swift build \(archConfig)--configuration \(builder.buildMode)"
        try await builder.run(cmd)
        
        let binPath = try await builder.run(cmd + " --show-bin-path")
            .trimmingCharacters(in: CharacterSet.newlines)
        
        return binPath
    }
}
