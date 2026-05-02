struct AppStoreSource: UpdateSource {
    let identifier = "app-store"
    private let logger: any Logger

    init(logger: any Logger) {
        self.logger = logger
    }

    func scanInstalledApps() async throws -> [AppEntity] {
        logger.info("App-Store-Scan angefordert.")
        return []
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        logger.info("App-Store-Updateprüfung für \(apps.count) Apps angefordert.")
        return []
    }

    func perform(update: UpdateEntity) async throws {
        logger.info("App-Store-Aktualisierung für \(update.appName) angefordert.")
    }
}
