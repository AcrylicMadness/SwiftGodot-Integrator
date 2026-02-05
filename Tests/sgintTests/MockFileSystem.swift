//
//  MockFileSystem.swift
//  sgint
//
//  Created by Acrylic M. on 04.02.2026.
//

import Foundation
import Testing
@testable import sgint

/// Basic file system tree emulation to avoid testing with real files
class MockFileSystem {
    class Node: Identifiable, Equatable {
        var name: String
        var isFile: Bool
        var children: [Node]
        var contents: Data?
        
        init(
            name: String,
            isFile: Bool = false,
            children: [Node] = [],
            contents: Data? = nil
        ) {
            self.name = name
            self.isFile = isFile
            self.children = children
            self.contents = contents
        }
        
        var id: String {
            name
        }
        
        subscript(index: String) -> Node? {
            children.first(where: { $0.name == index })
        }
        
        static func == (
            lhs: MockFileSystem.Node,
            rhs: MockFileSystem.Node
        ) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    enum Error: Swift.Error {
        case notImplemented
        case pathNotFound
        case notAFile
        case notADirectory
        case badString
    }
    
    private(set) var rootNode: Node
    private let cwd: String
    
    init(cwd: String = "testing") {
        self.cwd = cwd
        let rootNode = Node(
            name: cwd,
            isFile: false
        )
        self.rootNode = rootNode
    }
    
    private
    func pathComponents(
        from url: URL
    ) -> [String] {
        var components = url.pathComponents
        if let first = components.first, first == "/" {
            components.removeFirst()
        }
        return components
    }
    
    private
    func pathComponents(
        from path: String
    ) -> [String] {
        path.split(separator: "/").map({ String($0) })
    }
 
    private
    func createDirectoryNode(
        for node: Node,
        pathComponents: [String],
        createIntermidiateDirectories: Bool
    ) throws {
        var components = pathComponents
        guard let name = components.popFirst() else {
            return
        }
        let nextNode: Node
        if let existingNode = node[name] {
            nextNode = existingNode
        } else {
            nextNode = Node(name: name, isFile: false)
            if components.isEmpty || createIntermidiateDirectories {
                node.children.append(nextNode)
            } else {
                throw Error.pathNotFound
            }
        }
        if !components.isEmpty {
            try createDirectoryNode(
                for: nextNode,
                pathComponents: components,
                createIntermidiateDirectories: createIntermidiateDirectories
            )
        }
    }
    
    private
    func findEndNode(
        for node: Node,
        with pathComponents: [String]
    ) throws -> Node {
        var components = pathComponents
        guard let name = components.popFirst() else {
            return node
        }
        guard let next = node[name] else {
            throw Error.pathNotFound
        }
        return try findEndNode(for: next, with: components)
    }
    
    private
    func children(
        for node: Node,
        with pathComponents: [String]
    ) throws -> [Node] {
        let endNode = try findEndNode(for: rootNode, with: pathComponents)
        guard !endNode.isFile else {
            throw Error.notADirectory
        }
        return endNode.children
    }
    
    private
    func contents(
        for: Node,
        with pathComponents: [String]
    ) throws -> Data {
        let endNode = try findEndNode(for: rootNode, with: pathComponents)
        guard endNode.isFile else {
            throw Error.notAFile
        }
        return endNode.contents ?? Data()
    }
}

// MARK: - FileOperations
extension MockFileSystem: FileOperations {
    var currentDirectoryPath: String {
        cwd
    }
    
    func copyItem(
        at sourceUrl: URL,
        to destinationUrl: URL
    ) throws {
        throw Error.notImplemented
    }
    
    func string(
        contentsOf url: URL,
        encoding: String.Encoding = .utf8
    ) throws -> String {
        let contents = try contents(for: rootNode, with: pathComponents(from: url))
        guard let string = String(data: contents, encoding: encoding) else {
            throw Error.badString
        }
        return string
    }
    
    func write(
        string: String,
        to outputURL: URL,
        atomically: Bool,
        encoding: String.Encoding
    ) throws {
        var path = pathComponents(from: outputURL)
        guard let fileName = path.popLast() else {
            throw Error.pathNotFound
        }
        let endNode = try findEndNode(
            for: rootNode,
            with: path
        )
        let data = string.data(using: encoding)
        var workingNode: Node
        if let existing = endNode[fileName] {
            guard endNode.isFile else {
                throw Error.notAFile
            }
            workingNode = existing
        } else {
            workingNode = Node(name: fileName, isFile: true)
            endNode.children.append(workingNode)
        }
        workingNode.contents = data
    }
    
    func fileExists(atPath path: String) -> Bool {
        do {
            let endNode = try findEndNode(
                for: rootNode,
                with: pathComponents(from: path)
            )
            return endNode.isFile
        } catch {
            return false
        }
    }
    
    func removeItem(atPath path: String) throws {
        throw Error.notImplemented
    }
    
    func contentsOfDirectory(atPath path: String) throws -> [String] {
        try children(
            for: rootNode,
            with: pathComponents(from: path)
        ).map({ $0.name })
    }
    
    func createDirectory(
        at url: URL,
        withIntermediateDirectories createIntermediates: Bool,
        attributes: [FileAttributeKey : Any]? = nil
    ) throws {
        try createDirectoryNode(
            for: rootNode,
            pathComponents: pathComponents(from: url),
            createIntermidiateDirectories: createIntermediates
        )
    }
}
