import Foundation

struct AppEntity: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let installedVersion: String
    let bundleIdentifier: String?
    let sourceIdentifier: String

    init(
        id: String,
        name: String,
        installedVersion: String,
        bundleIdentifier: String? = nil,
        sourceIdentifier: String
    ) {
        self.id = id
        self.name = name
        self.installedVersion = installedVersion
        self.bundleIdentifier = bundleIdentifier
        self.sourceIdentifier = sourceIdentifier
    }
}
