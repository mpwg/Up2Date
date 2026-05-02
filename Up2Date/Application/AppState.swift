import Observation

@MainActor
@Observable
final class AppState {
    var apps: [AppEntity] = []
    var updates: [UpdateEntity] = []
    var isLoading = false
    var errorMessage: String?

    var isEmpty: Bool {
        !isLoading && apps.isEmpty
    }
}
