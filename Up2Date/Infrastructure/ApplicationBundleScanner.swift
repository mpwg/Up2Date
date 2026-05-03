import Foundation

struct ApplicationBundleScanner: Sendable {
    private let fileSystem: any FileSystemClient

    init(fileSystem: any FileSystemClient) {
        self.fileSystem = fileSystem
    }

    func scanApplicationBundles() throws -> [ApplicationBundle] {
        let homeApplications = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Applications", isDirectory: true)
        let searchDirectories = [
            URL(fileURLWithPath: "/Applications", isDirectory: true),
            homeApplications
        ]

        var bundles: [ApplicationBundle] = []
        var seenPaths = Set<String>()

        for directory in searchDirectories where fileSystem.fileExists(at: directory) {
            let urls = try fileSystem.contentsOfDirectory(at: directory)
            for url in urls where url.pathExtension == "app" && seenPaths.insert(url.path).inserted {
                guard let bundle = ApplicationBundle(url: url) else { continue }
                bundles.append(bundle)
            }
        }

        return bundles.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }
}

struct ApplicationBundle: Hashable, Sendable {
    let url: URL
    let name: String
    let version: String
    let bundleIdentifier: String?
    let isMacAppStoreApp: Bool

    init?(url: URL) {
        guard let bundle = Bundle(url: url) else { return nil }

        let info = bundle.infoDictionary ?? [:]
        let displayName = info["CFBundleDisplayName"] as? String
        let bundleName = info["CFBundleName"] as? String
        let fallbackName = url.deletingPathExtension().lastPathComponent
        let version = info["CFBundleShortVersionString"] as? String
            ?? info["CFBundleVersion"] as? String
            ?? "-"

        self.url = url
        self.name = displayName ?? bundleName ?? fallbackName
        self.version = version
        self.bundleIdentifier = bundle.bundleIdentifier
        self.isMacAppStoreApp = FileManager.default.fileExists(
            atPath: url.appendingPathComponent("Contents/_MASReceipt/receipt").path
        )
    }
}
