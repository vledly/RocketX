import SwiftUI

struct DetailTextSection: View {
    let title: LocalizedStringResource
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.title2.bold())
            Text(text)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview("Long text") {
    DetailTextSection(
        title: .rocketDetailsDescription,
        text: "Falcon 9 is a reusable, two-stage rocket designed and manufactured by SpaceX for reliable transport of people and payloads into Earth orbit and beyond."
    )
    .padding()
}
