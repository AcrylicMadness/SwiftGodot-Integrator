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
    
    func getLibNames(
        for driverName: String
    ) -> (driverLib: String, swiftGodotLib: String)
    
    func build(
        using builder: ExtensionBuilder
    ) async throws -> String
}

extension Platform {
    var swiftGodotLibName: String {
        libPrefix + "SwiftGodot"
    }
    
    var libPrefix: String {
        ""
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
