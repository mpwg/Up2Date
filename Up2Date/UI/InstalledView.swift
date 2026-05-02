import SwiftUI

struct InstalledView: View {
    private let apps = AppPresentationData.updates.map {
        RecentlyUpdatedItem(id: $0.id, name: $0.name, version: $0.installedVersion, source: $0.source, symbolName: $0.symbolName)
    } + AppPresentationData.recentlyUpdated

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Installed")
                .font(.title2.weight(.semibold))
                .padding(.horizontal, 24)
                .padding(.top, 22)

            List(apps) { app in
                HStack(spacing: 10) {
                    AppIconBadgeView(symbolName: app.symbolName, size: 32)
                    Text(app.name)
                    Spacer()
                    Text(app.version)
                        .foregroundStyle(.secondary)
                    Text(app.source)
                        .foregroundStyle(.secondary)
                        .frame(width: 90, alignment: .trailing)
                }
                .contextMenu {
                    Button("Show Details") {}
                }
            }
            .listStyle(.inset)
        }
    }
}
