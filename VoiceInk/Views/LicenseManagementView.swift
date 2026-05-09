import SwiftUI

struct LicenseManagementView: View {
    @StateObject private var licenseViewModel = LicenseViewModel()
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                headerSection
                licenseStatusSection
            }
            .padding(32)
            .frame(maxWidth: 720)
            .frame(maxWidth: .infinity)
        }
        .background(Color(NSColor.controlBackgroundColor))
    }

    private var headerSection: some View {
        VStack(spacing: 16) {
            AppIconView()

            Text("Tala")
                .font(.system(size: 32, weight: .bold))

            Text("v\(appVersion)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 32)
    }

    private var licenseStatusSection: some View {
        VStack(spacing: 20) {
            if case .licensed = licenseViewModel.licenseState {
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(.green)

                    Text("License Active")
                        .font(.headline)

                    Spacer()

                    Button(role: .destructive, action: {
                        licenseViewModel.removeLicense()
                    }) {
                        Label("Deactivate License", systemImage: "xmark.circle.fill")
                    }
                    .buttonStyle(.bordered)
                }
            } else {
                Text("License Activation")
                    .font(.headline)

                HStack(spacing: 12) {
                    TextField("Enter your license key", text: $licenseViewModel.licenseKey)
                        .textFieldStyle(.roundedBorder)
                        .font(.system(.body, design: .monospaced))
                        .textCase(.uppercase)

                    Button(action: {
                        Task { await licenseViewModel.validateLicense() }
                    }) {
                        if licenseViewModel.isValidating {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Text("Activate")
                                .frame(width: 80)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(licenseViewModel.isValidating)
                }

                if let message = licenseViewModel.validationMessage {
                    Text(message)
                        .foregroundColor(licenseViewModel.validationSuccess ? .green : .red)
                        .font(.callout)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(32)
        .background(CardBackground(isSelected: false))
        .shadow(color: .black.opacity(0.05), radius: 10)
    }
}
