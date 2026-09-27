import SwiftUI

struct PaginationFooter: View {
    let status: PaginationStatus
    let retryTitle: LocalizedStringResource
    let onRetry: () -> Void

    @ViewBuilder
    var body: some View {
        switch status {
        case .ready, .end:
            SwiftUI.EmptyView()
        case .loading:
            ProgressView()
                .frame(maxWidth: .infinity)
        case .failed:
            Button(retryTitle, action: onRetry)
                .frame(maxWidth: .infinity)
        }
    }
}

#Preview("States") {
    VStack(spacing: 24) {
        PaginationFooter(
            status: .loading,
            retryTitle: .launchesNextPageRetry,
            onRetry: {}
        )

        PaginationFooter(
            status: .failed,
            retryTitle: .launchesNextPageRetry,
            onRetry: {}
        )
    }
    .padding()
}
