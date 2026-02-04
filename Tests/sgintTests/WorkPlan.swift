//
//  BaseTests.swift
//  sgint
//
//  Created by Acrylic M. on 04.02.2026.
//

import Testing
@testable import sgint

@Suite
struct WorkPlan {
    @Test
    func testNothing() {
        print("This is a test")
    }
    
    /*
     Current plan:
     
     [ ] Abstract Shell access to allow command validation
     [ ] Test that Shell right commands are called correctly
     [ ] Abstract FileManager to allow testing
     [ ] Create mock FileManager
     [ ] Test file copying/writing
     [ ] Test GDExtension output
     
     */
}
