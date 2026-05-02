import Testing
@testable import Up2Date

struct UpdateManagerTests {
    @Test func refreshAggregatesAppsAndUpdatesFromSources() async throws {
        let appStoreApp = AppEntity(
            id: "app-store.pages",
            name: "Pages",
            installedVersion: "14.0",
            bundleIdentifier: "com.apple.iWork.Pages",
            sourceIdentifier: "app-store"
        )
        let brewApp = AppEntity(
            id: "homebrew.wget",
            name: "wget",
            installedVersion: "1.24.0",
            sourceIdentifier: "homebrew"
        )
        let brewUpdate = UpdateEntity(
            id: "homebrew.wget-1.25.0",
            appID: brewApp.id,
            appName: brewApp.name,
            installedVersion: brewApp.installedVersion,
            availableVersion: "1.25.0",
            sourceIdentifier: brewApp.sourceIdentifier
        )

        let appStoreSource = MockUpdateSource(
            identifier: "app-store",
            apps: [appStoreApp],
            updates: []
        )
        let brewSource = MockUpdateSource(
            identifier: "homebrew",
            apps: [brewApp],
            updates: [brewUpdate]
        )
        let manager = UpdateManager(sources: [appStoreSource, brewSource])

        let result = try await manager.refresh()

        #expect(result.apps.map(\.name) == ["Pages", "wget"])
        #expect(result.updates == [brewUpdate])
    }
}
