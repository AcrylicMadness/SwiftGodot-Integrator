//
//  Builder.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Foundation

actor Builder {
    actor Output {
        private(set) var content: String = ""
        
        func printLine(_ line: String) {
            print(line, terminator: line.hasSuffix("\n") ? "" : "\n")
            appendLine(line)
        }
        
        func appendLine(_ line: String) {
            content.appendLine(line)
        }
    }
    
    let projectName: String
    let driverName: String
    let workingDirectory: URL
    let fileManager: FileManager
    let binFolderName: String
    
    var buildMode: BuildMode = .debug
    var buildArchs: [Architecture]
    
    private let output: Output = Output()
    
    init(
        projectName: String,
        driverName: String,
        workingDirectory: URL,
        binFolderName: String,
        buildArchs: [Architecture],
        fileManager: FileManager
    ) {
        self.projectName = projectName
        self.driverName = driverName
        self.workingDirectory = workingDirectory
        self.buildArchs = buildArchs
        self.fileManager = fileManager
        self.binFolderName = binFolderName
    }
    
    var driverPath: URL {
        workingDirectory.appendingPathComponent("\(driverName)")
    }
    
    func setMode(_ buildMode: BuildMode) {
        self.buildMode = buildMode
    }
    
    @discardableResult
    func run(
        _ command: String,
    ) async throws -> String {
        let outputPipe = Pipe()
        let task = self.createProcess([command], outputPipe)
        outputPipe.fileHandleForReading.readabilityHandler = { fileHandle in
            if let line = self.saveOutput(outputPipe, fileHandle) {
                // Far from the best way to do it, but AsyncBytes is not available on Linux
                Task { @MainActor in
                    await self.output.printLine(line)
                }
            }
        }
        try task.run()
        task.waitUntilExit()
        guard task.terminationStatus == 0 else {
            throw BuildError.buildFailed(terminationStatus: task.terminationStatus)
        }
        return await output.content
    }
    
    private
    func createProcess(
        _ arguments: [String],
        _ pipe: Pipe
    ) -> Process {
        let task = Process()
        task.launchPath = "/bin/zsh"
        task.arguments = ["-c"] + arguments
        task.standardOutput = pipe
        task.standardError = pipe
        return task
    }

    private
    nonisolated func saveOutput(
        _ pipe: Pipe,
        _ fileHandle: FileHandle
    ) -> String? {
        let data = fileHandle.availableData
        guard data.count > 0 else {
            pipe.fileHandleForReading.readabilityHandler = nil
            return nil
        }
        guard let line = String(data: data, encoding: .utf8) else {
            return nil
        }
        return line
    }

    enum BuildError: Error {
        case buildFailed(terminationStatus: Int32)
        case swiftBuildFailedToProvideBinariesPath
        case failedToMapBinariesPaths
    }
}
