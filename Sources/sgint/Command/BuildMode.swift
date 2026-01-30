//
//  BuildMode.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import ArgumentParser
import Foundation

enum BuildMode: String, CaseIterable, ExpressibleByArgument {
    case debug
    case release
}
