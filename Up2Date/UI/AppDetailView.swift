import SwiftUI

struct AppDetailView: View {
    let item: UpdateListItem
    let close: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 22) {
            header
            infoGrid
            changelog
            Spacer()
        }
        .padding(24)
        .navigationTitle(item.name)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    close()
                } label: {
                    Text("Done")
                }
            }
        }
    }

    private var header: some View {
        HStack(alignment: .center, spacing: 14) {
            AppIconBadgeView(symbolName: item.symbolName, size: 64)

            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.title2.weight(.semibold))
                Text(item.developer)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button("Update") {}
                .buttonStyle(.borderedProminent)
        }
    }

    private var infoGrid: some View {
        HStack(spacing: 30) {
            InfoColumn(title: "Version", value: item.availableVersion)
            InfoColumn(title: "Size", value: item.size)
            InfoColumn(title: "Date", value: item.date.formatted(date: .abbreviated, time: .omitted))
            InfoColumn(title: "Source", value: item.source)
        }
        .padding(.vertical, 8)
    }

    private var changelog: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("What’s New")
                .font(.headline)

            VStack(alignment: .leading, spacing: 6) {
                ForEach(item.changelog, id: \.self) { entry in
                    HStack(alignment: .firstTextBaseline, spacing: 8) {
                        Text("•")
                        Text(entry)
                    }
                    .font(.body)
                }
            }
            .foregroundStyle(.primary)
        }
    }
}

private struct InfoColumn: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.callout.weight(.medium))
        }
    }
}
