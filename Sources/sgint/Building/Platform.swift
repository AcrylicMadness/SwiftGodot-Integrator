//
//  Platform.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Foundation

protocol Platform: Hashable, Sendable {
    var name: String { get }
    var mainLibExtension: String { get }
    var additionalLibExtensions: [String] { get }
    var libPrefix: String { get }
    var swiftGodotLibName: String { get }
    var supportedArchs: [Architecture] { get }
    var separateArchs: Bool { get }
    var id: String { get }
    func directory(for arch: Architecture?) -> String
    
    func getMainLibNames(
        for driverName: String
    ) -> (driverLib: String, swiftGodotLib: String)
    
    func getAdditionalLibNames(
        for driverName: String
    ) -> [(driverLib: String, swiftGodotLib: String)]
    
    func build(
        using builder: ExtensionBuilder
    ) async throws -> String
}

extension Platform {
    var libPrefix: String { "" }
    var separateArchs: Bool { true }
    var supportedArchs: [Architecture] { [.aarch64, .x86_64] }
    var id: String { name }
    var swiftGodotLibName: String { libPrefix + "SwiftGodot" }
    var additionalLibExtensions: [String] { [] }
    
    func directory(for arch: Architecture?) -> String {
        guard let arch, separateArchs else {
            return name
        }
        return "\(id)-\(arch.rawValue)"
    }
    
    func getMainLibNames(
        for driverName: String
    ) -> (driverLib: String, swiftGodotLib: String) {
        return (
            driverLib: "\(libPrefix)\(driverName).\(mainLibExtension)",
            swiftGodotLib: "\(swiftGodotLibName).\(mainLibExtension)"
        )
    }
    
    func getAdditionalLibNames(
        for driverName: String
    ) -> [(driverLib: String, swiftGodotLib: String)] {
        additionalLibExtensions.map { ext in
            (
                driverLib: "\(libPrefix)\(driverName).\(ext)",
                swiftGodotLib: "\(swiftGodotLibName).\(ext)"
            )
        }
    }
}
