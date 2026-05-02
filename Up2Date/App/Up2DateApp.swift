import SwiftUI

@main
struct Up2DateApp: App {
    @State private var viewModel: AppViewModel

    init() {
        let container = AppContainer.live()
        _viewModel = State(
            initialValue: AppViewModel(
                updateManager: container.updateManager,
                logger: container.logger
            )
        )
    }

    var body: some Scene {
        WindowGroup {
            RootView(viewModel: viewModel)
        }
    }
}
