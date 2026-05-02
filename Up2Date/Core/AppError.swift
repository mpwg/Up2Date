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
            "Die Aktualisierungsquelle \"\(source)\" ist nicht verfügbar."
        case let .shellCommandFailed(command, exitCode, output):
            "Der Shell-Befehl \"\(command)\" ist mit Code \(exitCode) fehlgeschlagen: \(output)"
        case let .fileSystemFailure(message):
            "Dateisystemfehler: \(message)"
        case let .updateSourceNotFound(source):
            "Keine Aktualisierungsquelle für \"\(source)\" gefunden."
        case let .unexpected(message):
            "Unerwarteter Fehler: \(message)"
        }
    }
}
