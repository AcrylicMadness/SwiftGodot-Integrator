//
//  GDFile.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Collections
import Foundation

typealias TSCN = OrderedDictionary<TSCNKey, OrderedDictionary<String, Codable>>

struct TSCNKey: Hashable, ExpressibleByStringLiteral {
    let name: String
    let properties: OrderedDictionary<String, any Codable & Hashable>
    
    init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }

    init(
        name: String,
        properties: OrderedDictionary<String, any Codable & Hashable> = [:]
    ) {
        self.name = name
        self.properties = properties
    }

    static func == (
        lhs: TSCNKey,
        rhs: TSCNKey
    ) -> Bool {
        guard lhs.name == rhs.name else { return false }
        guard lhs.properties.count == rhs.properties.count else { return false }
        for (key, lValue) in lhs.properties {
            guard let rValue = rhs.properties[key] else { return false }
            if AnyHashable(lValue) != AnyHashable(rValue) { return false }
        }
        return true
    }

    func hash(
        into hasher: inout Hasher
    ) {
        hasher.combine(name)
        // Sorting keys to ensure deterministic hashing
        for key in properties.keys.sorted() {
            hasher.combine(key)
            if let value = properties[key] {
                hasher.combine(AnyHashable(value))
            }
        }
    }
}
