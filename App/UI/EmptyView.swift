import SwiftUI

struct EmptyView: View {
    enum State {
        case plain
        case filtered(onReset: () -> Void)
    }

    let title: LocalizedStringResource
    let description: LocalizedStringResource
    let systemImage: String
    let state: State

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: systemImage)
        } description: {
            Text(description)
        } actions: {
            if case let .filtered(onReset) = state {
                Button(.commonClearFilter, action: onReset)
            }
        }
    }
}

#Preview("Plain") {
    EmptyView(
        title: .rocketsEmptyTitle,
        description: .rocketsEmptyDescription,
        systemImage: AppIcons.rocket,
        state: .plain
    )
}

#Preview("Filtered") {
    EmptyView(
        title: .launchesEmptyTitle,
        description: .launchesEmptyDescription,
        systemImage: AppIcons.filteredEmpty,
        state: .filtered(onReset: {})
    )
}
