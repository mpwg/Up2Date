import SwiftUI

struct UpdatesView: View {
    @Binding var selectedUpdate: UpdateListItem?
    private let updates = AppPresentationData.updates
    private let recentlyUpdated = AppPresentationData.recentlyUpdated

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            header
                .padding(.horizontal, 24)
                .padding(.top, 22)
                .padding(.bottom, 12)

            List {
                Section {
                    ForEach(updates) { item in
                        UpdateRowView(item: item) {
                            selectedUpdate = item
                        }
                        .listRowInsets(EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12))
                    }
                }

                Section("Recently Updated") {
                    ForEach(recentlyUpdated) { item in
                        RecentlyUpdatedRowView(item: item)
                            .listRowInsets(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                    }
                }
            }
            .listStyle(.inset)
        }
        .navigationTitle("Updates")
    }

    private var header: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 3) {
                Text("Updates")
                    .font(.title2.weight(.semibold))
                Text("\(updates.count) updates available")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Update All") {}
                .buttonStyle(.borderedProminent)
                .controlSize(.regular)
        }
    }
}

private struct UpdateRowView: View {
    let item: UpdateListItem
    let openDetail: () -> Void
    @State private var isHovered = false

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            AppIconBadgeView(symbolName: item.symbolName, size: 40)

            VStack(alignment: .leading, spacing: 3) {
                Text(item.name)
                    .font(.system(.body, weight: .semibold))
                Text(item.versionDiff)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                Text(item.description)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 16)

            Button("Update") {}
                .controlSize(.small)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
        .background {
            if isHovered {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(nsColor: .selectedContentBackgroundColor).opacity(0.10))
            }
        }
        .onHover { isHovered = $0 }
        .onTapGesture(perform: openDetail)
        .contextMenu {
            Button("Show Details", action: openDetail)
            Button("Ignore This Update") {}
        }
    }
}

private struct RecentlyUpdatedRowView: View {
    let item: RecentlyUpdatedItem
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            AppIconBadgeView(symbolName: item.symbolName, size: 28)

            VStack(alignment: .leading, spacing: 2) {
                Text(item.name)
                    .font(.callout.weight(.medium))
                Text("\(item.version) - \(item.source)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Open") {}
                .controlSize(.small)
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 4)
        .contentShape(Rectangle())
        .background {
            if isHovered {
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color(nsColor: .selectedContentBackgroundColor).opacity(0.08))
            }
        }
        .onHover { isHovered = $0 }
        .contextMenu {
            Button("Show in Finder") {}
        }
    }
}
