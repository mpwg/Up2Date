import SwiftUI

struct InstalledView: View {
    let viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("Installiert")
                    .font(.title2.weight(.semibold))

                Spacer()

                if viewModel.state.isLoading {
                    ProgressView()
                        .controlSize(.small)
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 22)

            if let errorMessage = viewModel.state.errorMessage {
                ContentUnavailableView(
                    "Suche fehlgeschlagen",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )
            } else if viewModel.state.apps.isEmpty && !viewModel.state.isLoading {
                ContentUnavailableView(
                    "Keine Anwendungen gefunden",
                    systemImage: "app.dashed",
                    description: Text("Die Suche umfasst manuell installierte Apps, Mac-App-Store-Apps und Homebrew-Pakete.")
                )
            } else {
                List(viewModel.state.apps) { app in
                    HStack(spacing: 10) {
                        AppIconBadgeView(symbolName: app.symbolName, size: 32)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(app.name)
                            if let bundleIdentifier = app.bundleIdentifier {
                                Text(bundleIdentifier)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        Spacer()

                        Text(app.installedVersion)
                            .foregroundStyle(.secondary)
                        Text(app.sourceName)
                            .foregroundStyle(.secondary)
                            .frame(width: 100, alignment: .trailing)
                    }
                    .contextMenu {
                        Button("Details anzeigen") {}
                    }
                }
                .listStyle(.inset)
            }
        }
    }
}

private extension AppEntity {
    var sourceName: String {
        switch sourceIdentifier {
        case "app-store":
            "App Store"
        case "homebrew":
            "Homebrew"
        case "manual":
            "Manuell"
        default:
            sourceIdentifier
        }
    }

    var symbolName: String {
        switch sourceIdentifier {
        case "app-store":
            "app.badge"
        case "homebrew":
            "terminal"
        case "manual":
            "app"
        default:
            "questionmark.app"
        }
    }
}
