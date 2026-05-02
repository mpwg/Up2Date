import OSLog

protocol Logger: Sendable {
    func info(_ message: String)
    func error(_ message: String)
}

struct OSLogger: Logger {
    private let logger: os.Logger

    init(subsystem: String = Bundle.main.bundleIdentifier ?? "Up2Date", category: String = "App") {
        self.logger = os.Logger(subsystem: subsystem, category: category)
    }

    func info(_ message: String) {
        logger.info("\(message, privacy: .public)")
    }

    func error(_ message: String) {
        logger.error("\(message, privacy: .public)")
    }
}
