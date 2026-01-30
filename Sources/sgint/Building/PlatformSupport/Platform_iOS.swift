//
//  Platform_iOS.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Foundation

struct Platform_iOS: Platform {
    var name: String { "ios" }
    var libExtension: String { "framework" }
    
    func build(using builder: Builder) async throws {
        fatalError("iOS Not implemented")
    }
}
