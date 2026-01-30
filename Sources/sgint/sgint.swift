// The Swift Programming Language
// https://docs.swift.org/swift-book
import ArgumentParser
import Foundation

@main
struct SwiftGodotIntegrate: AsyncParsableCommand {

    @Option
    var projectName: String?

    private lazy var templateLoader: ResourceLoader = .templateLoader

    mutating func run() async throws {
        print("Hello, World!")
    }
}
