import Foundation

struct ShellCommandResult: Equatable, Sendable {
    let output: String
    let exitCode: Int32
}

protocol ShellClient: Sendable {
    func run(_ executableURL: URL, arguments: [String]) async throws -> ShellCommandResult
}

struct ProcessShellClient: ShellClient {
    func run(_ executableURL: URL, arguments: [String] = []) async throws -> ShellCommandResult {
        try await Task.detached(priority: .utility) {
            let process = Process()
            let pipe = Pipe()

            process.executableURL = executableURL
            process.arguments = arguments
            process.standardOutput = pipe
            process.standardError = pipe

            try process.run()
            process.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(decoding: data, as: UTF8.self)
            let result = ShellCommandResult(output: output, exitCode: process.terminationStatus)

            guard result.exitCode == 0 else {
                let command = ([executableURL.path] + arguments).joined(separator: " ")
                throw AppError.shellCommandFailed(
                    command: command,
                    exitCode: result.exitCode,
                    output: result.output
                )
            }

            return result
        }.value
    }
}
