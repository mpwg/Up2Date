import SwiftUI

struct DetailView: View {
    let selection: SidebarItem

    var body: some View {
        Group {
            switch selection {
            case .updates:
                UpdatesView()
            case .installed:
                InstalledView()
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
