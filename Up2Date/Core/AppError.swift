import Foundation

enum AppError: Error, Equatable, LocalizedError, Sendable {
    case sourceUnavailable(String)
    case shellCommandFailed(command: String, exitCode: Int32, output: String)
    case fileSystemFailure(String)
    case updateSourceNotFound(String)
    case unexpected(String)

    var errorDescription: String? {
        switch self {
        case let .sourceUnavailable(source):
            "The update source \"\(source)\" is unavailable."
        case let .shellCommandFailed(command, exitCode, output):
            "The shell command \"\(command)\" failed with exit code \(exitCode): \(output)"
        case let .fileSystemFailure(message):
            "File system error: \(message)"
        case let .updateSourceNotFound(source):
            "No update source found for \"\(source)\"."
        case let .unexpected(message):
            "Unexpected error: \(message)"
        }
    }
}
