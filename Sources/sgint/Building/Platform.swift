//
//  Platform.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Foundation

protocol Platform: Hashable, Sendable {
    var name: String { get }
    var libExtension: String { get }
    var libPrefix: String { get }
    var swiftGodotLibName: String { get }
    var supportedArchs: [Architecture] { get }
    var separateArchs: Bool { get }
    var id: String { get }
    func directory(for arch: Architecture?) -> String
    
    func getLibNames(
        for driverName: String
    ) -> (driverLib: String, swiftGodotLib: String)
    
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
    
    func directory(for arch: Architecture?) -> String {
        guard let arch, separateArchs else {
            return name
        }
        return "\(id)-\(arch.rawValue)"
    }
    
    func getLibNames(
        for driverName: String
    ) -> (driverLib: String, swiftGodotLib: String) {
        return (
            driverLib: "\(libPrefix)\(driverName).\(libExtension)",
            swiftGodotLib: "\(swiftGodotLibName).\(libExtension)"
        )
    }
}
