struct SparkleSource: UpdateSource {
    let identifier = "sparkle"
    private let fileSystem: any FileSystemClient
    private let logger: any Logger

    init(fileSystem: any FileSystemClient, logger: any Logger) {
        self.fileSystem = fileSystem
        self.logger = logger
    }

    func scanInstalledApps() async throws -> [AppEntity] {
        logger.info("Sparkle scan requested.")
        _ = fileSystem
        return []
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        logger.info("Sparkle update check requested for \(apps.count) apps.")
        return []
    }

    func perform(update: UpdateEntity) async throws {
        logger.info("Sparkle update requested for \(update.appName).")
    }
}
