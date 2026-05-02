@testable import Up2Date

actor MockUpdateSource: UpdateSource {
    let identifier: String
    private let apps: [AppEntity]
    private let updates: [UpdateEntity]
    private(set) var performedUpdates: [UpdateEntity] = []

    init(identifier: String, apps: [AppEntity], updates: [UpdateEntity]) {
        self.identifier = identifier
        self.apps = apps
        self.updates = updates
    }

    func scanInstalledApps() async throws -> [AppEntity] {
        apps
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        updates.filter { update in
            apps.contains { $0.id == update.appID }
        }
    }

    func perform(update: UpdateEntity) async throws {
        performedUpdates.append(update)
    }
}
