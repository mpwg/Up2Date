import SwiftUI

struct OverviewView: View {
    let updateCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Overview")
                .font(.title2.weight(.semibold))
            Text("\(updateCount) updates are ready to install.")
                .foregroundStyle(.secondary)
            Spacer()
        }
        .padding(24)
    }
}
