import SwiftUI

struct UpdatesView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Text("Updates")
                    .font(.title2.weight(.semibold))

                Spacer()

                Button("Update All") {}
                    .buttonStyle(.borderedProminent)
            }
            .padding(.horizontal, 24)
            .padding(.top, 22)

            List(AppPresentationData.updates) { item in
                HStack(spacing: 10) {
                    AppIconBadgeView(symbolName: item.symbolName, size: 28)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.name)
                        Text(item.versionDiff)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Button("Update") {}
                        .controlSize(.small)
                }
                .contextMenu {
                    Button("Show Details") {}
                    Button("Ignore This Update") {}
                }
            }
            .listStyle(.inset)
        }
    }
}
