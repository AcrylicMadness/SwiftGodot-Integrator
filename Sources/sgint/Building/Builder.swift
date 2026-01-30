//
//  Builder.swift
//  sgint
//
//  Created by Acrylic M. on 30.01.2026.
//

import Foundation

actor Builder {
    let projectName: String
    let driverName: String
    let workingDirectory: URL
    let fileManager: FileManager
    let binFolderName: String
    
    var buildMode: BuildMode = .debug
    var buildArchs: [Architecture]
    
    private var logLabel: String?
    
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
    
    func setLogLabel(_ logLabel: String) {
        self.logLabel = logLabel
    }
    
    func setMode(_ buildMode: BuildMode) {
        self.buildMode = buildMode
    }
    
    @discardableResult
    func run(
        _ command: String,
        saveOutput: Bool = false
    ) async throws -> String? {
        print("Running:")
        print(command)
        
        var output = ""
        
        let task = Process()
        let pipe = Pipe()
        
        task.standardOutput = pipe
        task.standardError = pipe
        task.arguments = ["-c", command]
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        task.standardInput = nil

        try task.run()
        
        try await withThrowingTaskGroup(of: String.self) { group in
            group.addTask {
                var localOutput = ""
                for try await line in pipe.fileHandleForReading.bytes.lines {
                    if saveOutput {
                        localOutput += line + "\n"
                    }
                    print(line)
                }
                return localOutput
            }
            task.waitUntilExit()
            
            if saveOutput {
                output += try await group.next() ?? ""
            }
            
            if task.terminationStatus != 0 {
                print("Process exited with status \(task.terminationStatus)")
                throw BuildError.buildFailed(terminationStatus: task.terminationStatus)
            }
        }
        if saveOutput {
            return output
        } else {
            return nil
        }
    }
    
    enum BuildError: Error {
        case buildFailed(terminationStatus: Int32)
        case swiftBuildFailedToProvideBinariesPath
        case failedToMapBinariesPaths
    }
}
