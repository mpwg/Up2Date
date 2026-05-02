import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("History")
                .font(.title2.weight(.semibold))
                .padding(.horizontal, 24)
                .padding(.top, 22)

            List(AppPresentationData.recentlyUpdated) { item in
                HStack(spacing: 10) {
                    AppIconBadgeView(symbolName: item.symbolName, size: 28)
                    Text(item.name)
                    Spacer()
                    Text("Updated to \(item.version)")
                        .foregroundStyle(.secondary)
                }
                .contextMenu {
                    Button("Show Details") {}
                }
            }
            .listStyle(.inset)
        }
    }
}
