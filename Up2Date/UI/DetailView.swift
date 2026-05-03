import SwiftUI

struct DetailView: View {
    let selection: SidebarItem
    let viewModel: AppViewModel

    var body: some View {
        Group {
            switch selection {
            case .updates:
                UpdatesView()
            case .installed:
                InstalledView(viewModel: viewModel)
            case .history:
                HistoryView()
            case .settings:
                SettingsView()
            }
        }
        .frame(minWidth: 620, minHeight: 420)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
