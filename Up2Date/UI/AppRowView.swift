import SwiftUI

struct AppRowView: View {
    let app: AppEntity
    let update: UpdateEntity?

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: update == nil ? "app" : "arrow.down.app")
                .foregroundStyle(update == nil ? Color.secondary : Color.accentColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 4) {
                Text(app.name)
                    .font(.headline)

                Text(versionText)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(app.sourceIdentifier)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var versionText: String {
        guard let update else {
            return "Installiert: \(app.installedVersion)"
        }

        return "\(update.installedVersion) -> \(update.availableVersion)"
    }
}
