import SwiftUI

struct DetailView: View {
    let selection: SidebarItem
    @Binding var selectedUpdate: UpdateListItem?
    let updateCount: Int

    var body: some View {
        Group {
            if let selectedUpdate {
                AppDetailView(item: selectedUpdate) {
                    self.selectedUpdate = nil
                }
            } else {
                switch selection {
                case .overview:
                    OverviewView(updateCount: updateCount)
                case .updates:
                    UpdatesView(selectedUpdate: $selectedUpdate)
                case .installed:
                    InstalledView()
                case .history:
                    HistoryView()
                case .settings:
                    SettingsView()
                }
            }
        }
        .frame(minWidth: 620, minHeight: 420)
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
