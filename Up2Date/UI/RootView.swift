import SwiftUI

struct RootView: View {
    @State var viewModel: AppViewModel
    @State private var selectedSidebarItem: SidebarItem? = .updates
    @State private var selectedUpdate: UpdateListItem?
    @State private var searchText = ""
    @State private var hasLoaded = false

    var body: some View {
        NavigationSplitView {
            SidebarView(
                selection: $selectedSidebarItem,
                searchText: $searchText,
                updateCount: AppPresentationData.updates.count
            )
            .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
        } detail: {
            DetailView(
                selection: selectedSidebarItem ?? .updates,
                selectedUpdate: $selectedUpdate,
                updateCount: AppPresentationData.updates.count
            )
        }
        .task {
            guard !hasLoaded else { return }
            hasLoaded = true
            await viewModel.refresh()
        }
        .onChange(of: selectedSidebarItem) {
            selectedUpdate = nil
        }
    }
}

#Preview {
    let manager = UpdateManager(sources: [])
    RootView(viewModel: AppViewModel(updateManager: manager, logger: OSLogger()))
}
