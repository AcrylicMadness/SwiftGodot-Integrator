//
//  TSCNTests.swift
//  sgint
//
//  Created by Acrylic M. on 06.04.2026.
//

import Collections
import Testing
@testable import sgint

@Suite
struct TSCNTests {
    
    let testName = "Test Name"
    let testProperties: TSCNValue = [
        "first": "one",
        "second": "two"
    ]
    lazy var reversedProperties: TSCNValue = OrderedDictionary(
        uniqueKeysWithValues: testProperties.reversed()
    )
    
    lazy var straight = TSCNHeading(
        name: testName,
        properties: testProperties
    )
    
    lazy var reversed = TSCNHeading(
        name: testName,
        properties: reversedProperties
    )
    
    @Test
    mutating func testDeterministicTSCNHeaderHashing() {
        var straightHasher = Hasher()
        var reversedHasher = Hasher()
        
        straight.hash(into: &straightHasher)
        let straightHash = straightHasher.finalize()
        
        reversed.hash(into: &reversedHasher)
        let reversedHash = reversedHasher.finalize()
        
        #expect(straightHash == reversedHash)
    }
    
    @Test
    mutating func testTSCNHeadingEqual() {
        #expect(straight == straight)
        #expect(straight == reversed)
        
        let differentName = TSCNHeading(
            name: "Different",
            properties: testProperties
        )
        #expect(differentName != straight)
        
        let differentProps = TSCNHeading(
            name: testName,
            properties: [
                "three": "three",
                "four": "four"
            ]
        )
        #expect(differentProps != reversed)
        
        let noProps = TSCNHeading(name: testName)
        #expect(straight != noProps)
        
        let differentPropValues = TSCNHeading(
            name: testName,
            properties: [
                "first": "three",
                "second": "four"
            ]
        )
        #expect(straight != differentPropValues)
    }
    
    @Test
    func testTCSNHeadingStringLiteralInit() {
        let heading: TSCNHeading = "Test"
        #expect(heading.name == "Test")
    }
}

