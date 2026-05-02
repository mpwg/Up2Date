import SwiftUI

enum SidebarItem: String, CaseIterable, Identifiable, Hashable {
    case overview
    case updates
    case installed
    case history
    case settings

    var id: String { rawValue }

    var title: String {
        switch self {
        case .overview:
            "Overview"
        case .updates:
            "Updates"
        case .installed:
            "Installed"
        case .history:
            "History"
        case .settings:
            "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .overview:
            "square.grid.2x2"
        case .updates:
            "arrow.down.circle"
        case .installed:
            "checkmark.circle"
        case .history:
            "clock"
        case .settings:
            "gearshape"
        }
    }
}
