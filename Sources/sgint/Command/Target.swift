//
//  Target.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import ArgumentParser
import Foundation

enum Target: String, Decodable, CaseIterable, ExpressibleByArgument {
    case macos
    case ios
    case iossimulator
    case linux
    case windows
    
    var associatedPlatform: any Platform {
        switch self {
        case .ios:
            return Platform_iOS_Device()
        case .iossimulator:
            return Platform_iOS_Simulator()
        case .macos:
            return Platform_macOS()
        case .linux:
            return Platform_Linux()
        case .windows:
            return Platform_Windows()
        }
    }
    static var current: Target {
        get throws {
#if os(macOS)
            .macos
#elseif os(Linux)
            .linux
#elseif os(Windows)
            .windows
#else
            throw TargetDetectError.platfromUnsupportedBySgint
#endif
        }
    }
    
    enum TargetDetectError: Error {
        case platfromUnsupportedBySgint
        case iosBuildsRequireMacOS
        case crossCompilingIsNotSupported
        case cannotBuildForBothDeviceAndSimulator
    }
}
