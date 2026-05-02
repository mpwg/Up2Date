import SwiftUI

struct DashboardView: View {
    @State var viewModel: AppViewModel
    @State private var hasLoaded = false

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Up2Date")
                .toolbar {
                    Button("Aktualisieren") {
                        Task {
                            await viewModel.refresh()
                        }
                    }
                    .disabled(viewModel.state.isLoading)
                }
        }
        .task {
            guard !hasLoaded else { return }
            hasLoaded = true
            await viewModel.refresh()
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.state.isLoading {
            ProgressView("Apps werden geprüft...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.state.isEmpty {
            ContentUnavailableView(
                "Keine Apps gefunden",
                systemImage: "checkmark.circle",
                description: Text("Es wurden noch keine Apps aus den konfigurierten Quellen gefunden.")
            )
        } else {
            List(viewModel.state.apps) { app in
                AppRowView(
                    app: app,
                    update: viewModel.state.updates.first { $0.appID == app.id }
                )
            }
        }
    }
}

#Preview {
    let source = PreviewUpdateSource()
    let manager = UpdateManager(sources: [source])
    DashboardView(viewModel: AppViewModel(updateManager: manager, logger: OSLogger()))
}

private struct PreviewUpdateSource: UpdateSource {
    let identifier = "preview"

    func scanInstalledApps() async throws -> [AppEntity] {
        [
            AppEntity(
                id: "preview.app",
                name: "Beispiel-App",
                installedVersion: "1.0.0",
                bundleIdentifier: "com.example.preview",
                sourceIdentifier: identifier
            )
        ]
    }

    func checkForUpdates(for apps: [AppEntity]) async throws -> [UpdateEntity] {
        [
            UpdateEntity(
                id: "preview.app-1.1.0",
                appID: "preview.app",
                appName: "Beispiel-App",
                installedVersion: "1.0.0",
                availableVersion: "1.1.0",
                sourceIdentifier: identifier
            )
        ]
    }

    func perform(update: UpdateEntity) async throws {}
}
