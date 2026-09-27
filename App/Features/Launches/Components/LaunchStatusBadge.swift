import SwiftUI

struct LaunchStatusBadge: View {
    enum Size {
        case compact
        case regular
    }

    let status: Launch.Status
    var size: Size = .compact

    var body: some View {
        Text(title)
            .font(size == .compact ? .caption.weight(.semibold) : .subheadline.weight(.semibold))
            .foregroundStyle(color)
            .padding(.horizontal, size == .compact ? 8 : 12)
            .padding(.vertical, size == .compact ? 4 : 6)
            .background(color.opacity(0.12), in: Capsule())
    }

    private var title: LocalizedStringResource {
        switch status {
        case .upcoming: .launchStatusUpcoming
        case .successful: .launchStatusSuccessful
        case .failed: .launchStatusFailed
        case .unknown: .launchStatusUnknown
        }
    }

    private var color: Color {
        switch status {
        case .upcoming: .blue
        case .successful: .green
        case .failed: .red
        case .unknown: .secondary
        }
    }
}

#Preview("Statuses") {
    VStack(alignment: .leading, spacing: 12) {
        LaunchStatusBadge(status: .upcoming, size: .regular)
        LaunchStatusBadge(status: .successful, size: .regular)
        LaunchStatusBadge(status: .failed, size: .regular)
        LaunchStatusBadge(status: .unknown, size: .regular)
    }
    .padding()
}
