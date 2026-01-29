// The Swift Programming Language
// https://docs.swift.org/swift-book
import ArgumentParser
import Foundation

@main
struct SwiftGodotIntegrate: AsyncParsableCommand {

    private lazy var templateLoader: ResourceLoader = .templateLoader

    mutating func run() async throws {
        let text = try templateLoader.loadString(fromFileWithName: "Package")
        print(text)
    }
}