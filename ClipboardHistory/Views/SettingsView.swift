import SwiftUI

struct SettingsView: View {
    @State private var retentionDays: Int = {
        let saved = UserDefaults.standard.integer(forKey: "retentionDays")
        return saved > 0 ? saved : 3
    }()

    var body: some View {
        VStack(spacing: 0) {
            Divider()

            HStack(spacing: 8) {
                Image(systemName: "gearshape")
                    .foregroundColor(.secondary)
                    .font(.caption)

                Text("Retention")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)

                Picker("", selection: $retentionDays) {
                    Text("1 day").tag(1)
                    Text("3 days").tag(3)
                    Text("5 days").tag(5)
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .onChange(of: retentionDays) { newValue in
                    UserDefaults.standard.set(newValue, forKey: "retentionDays")
                }

                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
        }
        .background(Color(nsColor: .windowBackgroundColor))
    }
}
