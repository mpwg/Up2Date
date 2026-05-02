import Foundation

struct UpdateListItem: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let developer: String
    let installedVersion: String
    let availableVersion: String
    let description: String
    let size: String
    let date: Date
    let source: String
    let symbolName: String
    let changelog: [String]

    var versionDiff: String {
        "\(installedVersion) -> \(availableVersion)"
    }
}

struct RecentlyUpdatedItem: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let version: String
    let source: String
    let symbolName: String
}

enum AppPresentationData {
    static let updates: [UpdateListItem] = [
        UpdateListItem(
            id: "safari",
            name: "Safari",
            developer: "Apple",
            installedVersion: "17.0",
            availableVersion: "17.2",
            description: "Improves browsing performance, privacy protections, and compatibility with modern web apps.",
            size: "142 MB",
            date: Date(timeIntervalSince1970: 1_778_803_200),
            source: "App Store",
            symbolName: "safari",
            changelog: [
                "Improved page loading performance.",
                "Updated privacy protections for cross-site tracking.",
                "Fixed issues with media playback on selected websites."
            ]
        ),
        UpdateListItem(
            id: "sparkle-editor",
            name: "Nova",
            developer: "Panic",
            installedVersion: "11.8",
            availableVersion: "11.9",
            description: "Adds editor stability improvements and fixes several source-control edge cases.",
            size: "86 MB",
            date: Date(timeIntervalSince1970: 1_778_716_800),
            source: "Sparkle",
            symbolName: "curlybraces.square",
            changelog: [
                "Improved Swift syntax highlighting.",
                "Fixed Git status refresh delays.",
                "Reduced memory usage in large projects."
            ]
        ),
        UpdateListItem(
            id: "homebrew-wget",
            name: "wget",
            developer: "GNU Project",
            installedVersion: "1.24.0",
            availableVersion: "1.25.0",
            description: "Updates the command-line downloader with protocol and certificate handling fixes.",
            size: "4.8 MB",
            date: Date(timeIntervalSince1970: 1_778_544_000),
            source: "Homebrew",
            symbolName: "terminal",
            changelog: [
                "Improved TLS certificate validation.",
                "Added compatibility fixes for HTTP redirects.",
                "Updated bundled documentation."
            ]
        )
    ]

    static let recentlyUpdated: [RecentlyUpdatedItem] = [
        RecentlyUpdatedItem(id: "xcode", name: "Xcode", version: "18.4", source: "App Store", symbolName: "hammer"),
        RecentlyUpdatedItem(id: "raycast", name: "Raycast", version: "1.95", source: "Sparkle", symbolName: "sparkles"),
        RecentlyUpdatedItem(id: "ripgrep", name: "ripgrep", version: "14.1", source: "Homebrew", symbolName: "terminal")
    ]
}
