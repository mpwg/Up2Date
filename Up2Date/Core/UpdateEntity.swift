import Foundation

struct UpdateEntity: Identifiable, Hashable, Sendable {
    let id: String
    let appID: AppEntity.ID
    let appName: String
    let installedVersion: String
    let availableVersion: String
    let sourceIdentifier: String
    let releaseNotesURL: URL?

    init(
        id: String,
        appID: AppEntity.ID,
        appName: String,
        installedVersion: String,
        availableVersion: String,
        sourceIdentifier: String,
        releaseNotesURL: URL? = nil
    ) {
        self.id = id
        self.appID = appID
        self.appName = appName
        self.installedVersion = installedVersion
        self.availableVersion = availableVersion
        self.sourceIdentifier = sourceIdentifier
        self.releaseNotesURL = releaseNotesURL
    }
}
