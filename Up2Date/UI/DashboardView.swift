import SwiftUI

struct DashboardView: View {
    @State var viewModel: AppViewModel
    @State private var hasLoaded = false

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Up2Date")
                .toolbar {
                    Button("Refresh") {
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
            ProgressView("Checking apps...")
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        } else if viewModel.state.isEmpty {
            ContentUnavailableView(
                "No Apps Found",
                systemImage: "checkmark.circle",
                description: Text("No apps have been found from the configured sources yet.")
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
                name: "Example App",
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
                appName: "Example App",
                installedVersion: "1.0.0",
                availableVersion: "1.1.0",
                sourceIdentifier: identifier
            )
        ]
    }

    func perform(update: UpdateEntity) async throws {}
}
