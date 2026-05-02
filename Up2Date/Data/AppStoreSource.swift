struct AppStoreSource: UpdateSource {
    let identifier = "app-store"
    private let logger: any Logger

    init(logger: any Logger) {
        self.logger = logger
    }

    func scanInstalledApps() async throws -> [AppEntity] {
        logger.info("App Store scan requested.")
        return []
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        logger.info("App Store update check requested for \(apps.count) apps.")
        return []
    }

    func perform(update: UpdateEntity) async throws {
        logger.info("App Store update requested for \(update.appName).")
    }
}
