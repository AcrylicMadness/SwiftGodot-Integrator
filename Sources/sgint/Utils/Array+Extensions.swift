//
//  Array+Extensions.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Foundation

extension Array {
    init?<Subject>(mirrorChildValuesOf subject: Subject) {
        guard let array = Mirror(reflecting: subject).children.map(\.value) as? Self
        else { return nil }
        
        self = array
    }
}
