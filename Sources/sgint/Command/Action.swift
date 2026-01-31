//
//  Action.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import ArgumentParser
import Foundation

enum Action: String, CaseIterable, ExpressibleByArgument {
    case integrate
    case build
    case setupVscodeActions
    
    var requiresTargetValidation: Bool {
        switch self {
        case .setupVscodeActions:
            return false
        default:
            return true
        }
    }
    
    var actionDescription: String {
        // TODO: Move hints into resource file
        switch self {
        case .integrate:
            return
                """
                Creates a new SPM package to with all required dependencies (SwiftGodot).
                """
        case .build:
            return 
                """
                Builds swift code for provided platforms, moves resulting files to res://bin and configures .gdextension file.
                """
        case .setupVscodeActions:
            return 
                """
                Configures .vscode/launch.json to work with sgint.
                """
        }
    }
    
    static var helpMessage: String {
        Action
            .allCases
            .map({ "\($0.rawValue): \($0.actionDescription)" })
            .joined(separator: "\n\n")
            .appending("\n\n")
    }
}
