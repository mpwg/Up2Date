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
        logger.info("Homebrew scan requested.")
        guard let brewURL = brewExecutableURL() else {
            logger.info("Homebrew executable not found.")
            return []
        }

        do {
            let result = try await shell.run(
                brewURL,
                arguments: ["info", "--json=v2", "--installed"]
            )
            return try parseInstalledPackagesJSON(result.output).sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
        } catch {
            logger.error("Homebrew scan failed: \(error.localizedDescription)")
            return []
        }
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        logger.info("Homebrew update check requested for \(apps.count) apps.")
        return []
    }

    func perform(update: UpdateEntity) async throws {
        logger.info("Homebrew update requested for \(update.appName).")
    }

    private func brewExecutableURL() -> URL? {
        let candidates = [
            URL(fileURLWithPath: "/opt/homebrew/bin/brew"),
            URL(fileURLWithPath: "/usr/local/bin/brew")
        ]
        return candidates.first { fileSystem.fileExists(at: $0) }
    }

    private func parseInstalledPackagesJSON(_ output: String) throws -> [AppEntity] {
        let data = Data(output.utf8)
        let packages = try JSONDecoder().decode(BrewInstalledPackages.self, from: data)
        let formulae = packages.formulae.compactMap { formula -> AppEntity? in
            guard let version = formula.installed.first?.version else { return nil }
            return AppEntity(
                id: "\(identifier).formula.\(formula.name)",
                name: formula.name,
                installedVersion: version,
                sourceIdentifier: identifier
            )
        }
        let casks = packages.casks.map { cask in
            AppEntity(
                id: "\(identifier).cask.\(cask.token)",
                name: cask.displayName,
                installedVersion: cask.installed,
                sourceIdentifier: identifier
            )
        }

        return formulae + casks
    }
}

private struct BrewInstalledPackages: Decodable {
    let formulae: [BrewFormula]
    let casks: [BrewCask]
}

private struct BrewFormula: Decodable {
    let name: String
    let installed: [BrewFormulaInstallation]
}

private struct BrewFormulaInstallation: Decodable {
    let version: String
}

private struct BrewCask: Decodable {
    let token: String
    let name: [String]
    let installed: String

    var displayName: String {
        name.first.map { displayName in
            displayName.isEmpty ? fallbackDisplayName : displayName
        } ?? fallbackDisplayName
    }

    private var fallbackDisplayName: String {
        token
            .split(separator: "-")
            .map { part in
                part.prefix(1).uppercased() + part.dropFirst()
            }
            .joined(separator: " ")
    }
}
