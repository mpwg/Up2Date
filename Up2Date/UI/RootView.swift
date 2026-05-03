import SwiftUI

struct RootView: View {
    @State var viewModel: AppViewModel
    @State private var selectedSidebarItem: SidebarItem = .updates
    @State private var searchText = ""
    @State private var hasLoaded = false

    var body: some View {
        NavigationSplitView {
            SidebarView(
                selection: $selectedSidebarItem,
                searchText: $searchText
            )
            .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
        } detail: {
            DetailView(selection: selectedSidebarItem, viewModel: viewModel)
        }
        .task {
            guard !hasLoaded else { return }
            guard !ProcessInfo.processInfo.arguments.contains("--uitesting") else { return }
            hasLoaded = true
            await viewModel.refresh()
        }
    }
}

#Preview {
    let manager = UpdateManager(sources: [])
    RootView(viewModel: AppViewModel(updateManager: manager, logger: OSLogger()))
}
