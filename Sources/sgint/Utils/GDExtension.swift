//
//  GDExtension.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

struct GDExtension {
    var tscnRepresentation: TSCN {
        [
            "configuration": [
                "entry_symbol": "swift_entry_point",
                "compatibility_minimum": 4.2
            ],
            "dependencies": [
                "macos.debug": "res://bin/libLDRPG3DDriver.dylib",
                "macos.release": "res://bin/libLDRPG3DDriver.dylib",
                "ios.debug": "res://bin/libLDRPG3DDriver.framework",
                "ios.release": "res://bin/LDRPG3DDriver.framework"
            ],
            "libraries": [
                "macos.debug": ["res://bin/libSwiftGodot.dylib" : ""],
                "macos.release": ["res://bin/libSwiftGodot.dylib" : ""],
                "ios.debug": ["res://bin/SwiftGodot.framework" : ""],
                "ios.release": ["res://bin/SwiftGodot.framework" : ""]
            ]
        ]
    }
}
