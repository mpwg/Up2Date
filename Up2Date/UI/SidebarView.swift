import SwiftUI

struct SidebarView: View {
    @Binding var selection: SidebarItem
    @Binding var searchText: String

    var body: some View {
        List(selection: $selection) {
            Section {
                sidebarLabel(for: .updates)
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
