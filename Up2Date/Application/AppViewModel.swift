import Foundation
import Observation

@MainActor
@Observable
final class AppViewModel {
    let state: AppState
    private let updateManager: UpdateManager
    private let logger: any Logger

    init(
        updateManager: UpdateManager,
        state: AppState = AppState(),
        logger: any Logger
    ) {
        self.updateManager = updateManager
        self.state = state
        self.logger = logger
    }

    func refresh() async {
        state.isLoading = true
        state.errorMessage = nil

        do {
            let result = try await updateManager.refresh()
            state.apps = result.apps
            state.updates = result.updates
        } catch {
            logger.error(error.localizedDescription)
            state.errorMessage = error.localizedDescription
        }

        state.isLoading = false
    }
}
