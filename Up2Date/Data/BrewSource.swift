import Foundation

struct BrewSource: UpdateSource {
    let identifier = "homebrew"
    private let shell: any ShellClient
    private let fileSystem: any FileSystemClient
    private let logger: any Logger

    init(shell: any ShellClient, fileSystem: any FileSystemClient, logger: any Logger) {
        self.shell = shell
        self.fileSystem = fileSystem
        self.logger = logger
    }

    func scanInstalledApps() async throws -> [AppEntity] {
        logger.info("Homebrew-Scan angefordert.")
        _ = shell
        _ = fileSystem
        return []
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        logger.info("Homebrew-Updateprüfung für \(apps.count) Apps angefordert.")
        return []
    }

    func perform(update: UpdateEntity) async throws {
        logger.info("Homebrew-Aktualisierung für \(update.appName) angefordert.")
    }
}
