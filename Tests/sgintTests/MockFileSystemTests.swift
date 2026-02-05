//
//  MockFileSystemTests.swift
//  sgint
//
//  Created by Acrylic M. on 04.02.2026.
//

import Foundation
import Testing
@testable import sgint

extension Error {
    func isEqualTo(_ other: MockFileSystem.Error) -> Bool {
        guard let fsError = self as? MockFileSystem.Error else {
            return false
        }
        return fsError == other
    }
}

@Suite
struct MockFileSystemTests {
    
    let fileSystem: MockFileSystem = MockFileSystem()
    
    @Test
    func testCreateDirectory() throws {
        let expectedStructure = MockFileSystem.Node(
            name: fileSystem.currentDirectoryPath,
            isFile: false,
            children: [
                MockFileSystem.Node(
                    name: "foo",
                    isFile: false,
                    children: [
                        MockFileSystem.Node(
                            name: "bar"
                        ),
                        MockFileSystem.Node(
                            name: "baz"
                        )
                    ]
                )
            ]
        )
        try fileSystem.createDirectory(
            at: URL(fileURLWithPath: "/foo/bar"),
            withIntermediateDirectories: true
        )
        try fileSystem.createDirectory(
            at: URL(fileURLWithPath: "/foo/baz"),
            withIntermediateDirectories: true
        )
        #expect(fileSystem.rootNode == expectedStructure)
    }
    
    @Test
    func testCreateWithoutIntermidiates() throws {
        do {
            try fileSystem.createDirectory(
                at: URL(fileURLWithPath: "foo/bar/baz"),
                withIntermediateDirectories: false
            )
        } catch {
            #expect(error.isEqualTo(.pathNotFound))
        }
    }
    
    @Test
    func testCreateNonExistantDirectory() throws {
        let expectedStructure = MockFileSystem.Node(name: fileSystem.currentDirectoryPath)
        try fileSystem.createDirectory(
            at: URL(fileURLWithPath: "/"),
            withIntermediateDirectories: true
        )
        try fileSystem.createDirectory(
            at: URL(fileURLWithPath: ""),
            withIntermediateDirectories: true
        )
        #expect(fileSystem.rootNode == expectedStructure)
    }
    
    @Test
    func testContentsAtPath() throws {
        try fileSystem.createDirectory(
            at: URL(fileURLWithPath: "/foo/bar"),
            withIntermediateDirectories: true
        )
        try fileSystem.createDirectory(
            at: URL(fileURLWithPath: "/foo/baz"),
            withIntermediateDirectories: true
        )
        
        let contents = try fileSystem.contentsOfDirectory(atPath: "")
        #expect(contents == ["foo"])
        
        let fooContents = try fileSystem.contentsOfDirectory(atPath: "/foo")
        #expect(fooContents == ["bar", "baz"])
        
        do {
            let contents = try fileSystem.contentsOfDirectory(atPath: "/non/existent/path")
            #expect(Bool(false), "Expected to throw, but got dir contents: \(contents)")
        } catch {
            #expect(error.isEqualTo(.pathNotFound))
        }
        
        let fileUrl = URL(fileURLWithPath: "/foo/bar/file")
        
        try fileSystem.write(
            string: "Something",
            to: fileUrl,
            atomically: true,
            encoding: .utf8
        )
        
        do {
            let contents = try fileSystem.contentsOfDirectory(atPath: fileUrl.path)
            #expect(Bool(false), "Expected to throw, but got dir contents: \(contents)")
        } catch {
            #expect(error.isEqualTo(.notADirectory))
        }
    }
    
    @Test
    func testWriteRead() throws {
        let testContents = "Hello, World!"
        let testFileName = "hello.txt"
        let testDirUrl = URL(fileURLWithPath: "/foo/bar")
        let testFileUrl = testDirUrl.appendingPathComponent(testFileName)
        
        // Create and write test file
        try fileSystem.createDirectory(
            at: testDirUrl,
            withIntermediateDirectories: true
        )
        try fileSystem.write(
            string: testContents,
            to: testFileUrl,
            atomically: true,
            encoding: .utf8
        )
        
        // Test file existance check
        #expect(fileSystem.fileExists(atPath: testFileUrl.path))
        
        let nonExistantFileUrl = testDirUrl.appendingPathComponent("fake.txt")
        #expect(fileSystem.fileExists(atPath: nonExistantFileUrl.path) == false)
        
        let nonExistantDirUrl = URL(fileURLWithPath: "/fake/dir.txt")
        #expect(fileSystem.fileExists(atPath: nonExistantDirUrl.path) == false)
        
        // Test file reading
        let contents = try fileSystem.string(contentsOf: testFileUrl)
        #expect(contents == testContents)
        
        do {
            let content = try fileSystem.string(contentsOf: testDirUrl)
            #expect(Bool(false), "Expected to throw, but got content: \(content)")
        } catch {
            #expect(error.isEqualTo(.notAFile))
        }
        
        do {
            let content = try fileSystem.string(contentsOf: nonExistantFileUrl)
            #expect(Bool(false), "Expected to throw, but got content: \(content)")
        } catch {
            #expect(error.isEqualTo(.pathNotFound))
        }
    }
}
