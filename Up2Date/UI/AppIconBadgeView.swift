import SwiftUI

struct AppIconBadgeView: View {
    let symbolName: String
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(nsColor: .controlBackgroundColor))
                .overlay {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .strokeBorder(Color.secondary.opacity(0.18), lineWidth: 1)
                }

            Image(systemName: symbolName)
                .font(.system(size: size * 0.46, weight: .regular))
                .foregroundStyle(Color.accentColor)
        }
        .frame(width: size, height: size)
    }
}
