import SwiftUI
import StoreKit

struct PaywallView: View {
    @EnvironmentObject var purchases: PurchaseManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(Theme.accent)
                    .padding(.top, 32)

                Text("Toolbox Tally Pro")
                    .font(Theme.titleFont)

                Text("Unlimited tools, loan-return reminders, and photo inventory export")
                    .font(Theme.bodyFont)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 32)

                Spacer()

                Button {
                    Task {
                        await purchases.purchase()
                        if purchases.isPro { dismiss() }
                    }
                } label: {
                    Text(purchases.product != nil ? "Upgrade for \(purchases.product!.displayPrice)" : "Upgrade")
                        .font(Theme.headingFont)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Theme.primary)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .accessibilityIdentifier("paywallUpgradeButton")
                .padding(.horizontal, 32)

                Button("Restore Purchases") {
                    Task { await purchases.restore() }
                }
                .accessibilityIdentifier("paywallRestoreButton")
                .font(Theme.bodyFont)
                .padding(.bottom, 8)

                Button("Not Now") { dismiss() }
                    .accessibilityIdentifier("paywallDismissButton")
                    .font(Theme.bodyFont)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 24)
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
