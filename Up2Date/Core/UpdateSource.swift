protocol UpdateSource: Sendable {
    var identifier: String { get }

    func scanInstalledApps() async throws -> [AppEntity]
    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity]
    func perform(update: UpdateEntity) async throws
}
