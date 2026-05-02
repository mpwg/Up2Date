import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem?
    @Binding var searchText: String
    let updateCount: Int

    var body: some View {
        List(selection: $selection) {
            Section {
                sidebarLabel(for: .overview)
                sidebarLabel(for: .updates)
                    .badge(updateCount)
                sidebarLabel(for: .installed)
                sidebarLabel(for: .history)
            }

            Section {
                sidebarLabel(for: .settings)
            }
        }
        .listStyle(.sidebar)
        .searchable(text: $searchText, placement: .sidebar, prompt: "Search")
        .navigationTitle("Up2Date")
    }

    private func sidebarLabel(for item: SidebarItem) -> some View {
        Label(item.title, systemImage: item.systemImage)
            .tag(item)
    }
}
