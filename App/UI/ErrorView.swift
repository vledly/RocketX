import SwiftUI

struct ErrorView: View {
    let title: LocalizedStringResource
    let onRetry: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: AppIcons.networkError)
        } actions: {
            Button(.commonRetry, action: onRetry)
        }
    }
}

#Preview {
    ErrorView(
        title: .detailsLoadError,
        onRetry: {}
    )
}
