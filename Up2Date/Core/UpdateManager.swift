actor UpdateManager {
    private let sourcesByIdentifier: [String: any UpdateSource]

    init(sources: [any UpdateSource]) {
        self.sourcesByIdentifier = Dictionary(uniqueKeysWithValues: sources.map { ($0.identifier, $0) })
    }

    func scanInstalledApps() async throws -> [AppEntity] {
        try await withThrowingTaskGroup(of: [AppEntity].self) { group in
            for source in sourcesByIdentifier.values {
                group.addTask {
                    try await source.scanInstalledApps()
                }
            }

            var apps: [AppEntity] = []
            for try await sourceApps in group {
                apps.append(contentsOf: sourceApps)
            }
            return apps.sorted { $0.name < $1.name }
        }
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        let appsBySource = Dictionary(grouping: apps, by: \.sourceIdentifier)

        return try await withThrowingTaskGroup(of: [UpdateEntity].self) { group in
            for (sourceIdentifier, sourceApps) in appsBySource {
                guard let source = sourcesByIdentifier[sourceIdentifier] else {
                    throw AppError.updateSourceNotFound(sourceIdentifier)
                }

                group.addTask {
                    try await source.checkForUpdates(for: sourceApps)
                }
            }

            var updates: [UpdateEntity] = []
            for try await sourceUpdates in group {
                updates.append(contentsOf: sourceUpdates)
            }
            return updates.sorted { $0.appName < $1.appName }
        }
    }

    func refresh() async throws -> (apps: [AppEntity], updates: [UpdateEntity]) {
        let apps = try await scanInstalledApps()
        let updates = try await checkForUpdates(for: apps)
        return (apps, updates)
    }

    func perform(update: UpdateEntity) async throws {
        guard let source = sourcesByIdentifier[update.sourceIdentifier] else {
            throw AppError.updateSourceNotFound(update.sourceIdentifier)
        }

        try await source.perform(update: update)
    }
}
