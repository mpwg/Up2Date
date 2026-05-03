import Foundation

struct ManualSource: UpdateSource {
    let identifier = "manual"
    private let fileSystem: any FileSystemClient
    private let logger: any Logger

    init(fileSystem: any FileSystemClient, logger: any Logger) {
        self.fileSystem = fileSystem
        self.logger = logger
    }

    func scanInstalledApps() async throws -> [AppEntity] {
        logger.info("Manual application scan requested.")
        let bundles = try ApplicationBundleScanner(fileSystem: fileSystem).scanApplicationBundles()

        return bundles
            .filter { !$0.isMacAppStoreApp }
            .map { bundle in
                AppEntity(
                    id: appID(for: bundle),
                    name: bundle.name,
                    installedVersion: bundle.version,
                    bundleIdentifier: bundle.bundleIdentifier,
                    sourceIdentifier: identifier
                )
            }
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        logger.info("Manual update check requested for \(apps.count) apps.")
        return []
    }

    func perform(update: UpdateEntity) async throws {
        logger.info("Manual update requested for \(update.appName).")
    }

    private func appID(for bundle: ApplicationBundle) -> String {
        let stableID = bundle.bundleIdentifier ?? bundle.url.path
        return "\(identifier).\(stableID)"
    }
}
