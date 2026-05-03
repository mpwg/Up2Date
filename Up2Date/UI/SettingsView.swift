import SwiftUI

struct SettingsView: View {
    @State private var checkAutomatically = true
    @State private var includeBetaUpdates = false
    @State private var updatePolicy = UpdatePolicy.notify

    var body: some View {
        Form {
            Section("General") {
                Toggle("Check for updates automatically", isOn: $checkAutomatically)
                Toggle("Include beta updates", isOn: $includeBetaUpdates)

                Picker("Update behavior", selection: $updatePolicy) {
                    ForEach(UpdatePolicy.allCases) { policy in
                        Text(policy.title).tag(policy)
                    }
                }
                .pickerStyle(.menu)
            }

            Section("Sources") {
                Toggle("App Store", isOn: .constant(true))
                Toggle("Manuell", isOn: .constant(true))
                Toggle("Homebrew", isOn: .constant(true))
            }
        }
        .formStyle(.grouped)
        .padding(20)
        .navigationTitle("Settings")
    }
}

private enum UpdatePolicy: String, CaseIterable, Identifiable {
    case notify
    case download
    case manual

    var id: String { rawValue }

    var title: String {
        switch self {
        case .notify:
            "Notify Only"
        case .download:
            "Download Automatically"
        case .manual:
            "Manual"
        }
    }
}
