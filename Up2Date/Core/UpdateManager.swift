import Foundation

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
            return deduplicatedApps(apps).sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
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

    private func deduplicatedApps(_ apps: [AppEntity]) -> [AppEntity] {
        let bundleDeduplicatedApps = preferredAppsByKey(apps) { app in
            app.bundleIdentifier?.lowercased() ?? normalizedName(app.name)
        }
        return preferredAppsByKey(bundleDeduplicatedApps, key: { normalizedName($0.name) })
    }

    private func preferredAppsByKey(
        _ apps: [AppEntity],
        key: (AppEntity) -> String
    ) -> [AppEntity] {
        var appsByKey: [String: AppEntity] = [:]

        for app in apps {
            let key = key(app)
            guard let existing = appsByKey[key] else {
                appsByKey[key] = app
                continue
            }

            if sourcePriority(app.sourceIdentifier) < sourcePriority(existing.sourceIdentifier) {
                appsByKey[key] = app
            }
        }

        return Array(appsByKey.values)
    }

    private func normalizedName(_ name: String) -> String {
        name
            .lowercased()
            .replacingOccurrences(of: " ", with: "-")
    }

    private func sourcePriority(_ sourceIdentifier: String) -> Int {
        switch sourceIdentifier {
        case "app-store":
            0
        case "homebrew":
            1
        case "manual":
            2
        default:
            3
        }
    }
}
