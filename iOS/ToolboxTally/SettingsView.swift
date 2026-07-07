import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss
    @AppStorage("toolboxtally_showNotes") private var showNotes: Bool = true
    @AppStorage("toolboxtally_sortNewestFirst") private var sortNewestFirst: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section("Display") {
                    Toggle("Show notes field", isOn: $showNotes)
                        .accessibilityIdentifier("settingsShowNotesToggle")
                    Toggle("Sort newest first", isOn: $sortNewestFirst)
                        .accessibilityIdentifier("settingsSortToggle")
                }

                Section("Toolbox Tally Pro") {
                    if purchases.isPro {
                        Label("Pro unlocked", systemImage: "checkmark.seal.fill")
                            .foregroundStyle(Theme.primary)
                    } else {
                        Button("Upgrade to Pro") {
                            purchases.product == nil ? nil : ()
                        }
                        .accessibilityIdentifier("settingsUpgradeButton")
                    }
                    Button("Restore Purchases") {
                        Task { await purchases.restore() }
                    }
                    .accessibilityIdentifier("settingsRestoreButton")
                }

                Section("About") {
                    Link("Privacy Policy", destination: URL(string: "https://shimondeitel.github.io/toolboxtally-app/privacy.html")!)
                        .accessibilityIdentifier("settingsPrivacyLink")
                    Link("Terms of Use", destination: URL(string: "https://shimondeitel.github.io/toolboxtally-app/terms.html")!)
                        .accessibilityIdentifier("settingsTermsLink")
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .accessibilityIdentifier("settingsDoneButton")
                }
            }
        }
    }
}
